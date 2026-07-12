// XML AST, Parser, and Serializer implementation for MoonSerde

pub enum XmlNode {
  Element(String, Map[String, String], Array[XmlNode])
  Text(String)
  Comment(String)
} derive(Debug, Eq)

// Parse XML string to XML Node
pub fn parse_xml(s : String) -> Result[XmlNode, String] {
  let parser = { input: s, pos: 0 }
  skip_whitespace_and_prolog(parser)
  parse_xml_node(parser)
}

// Convert XML Node to XML String
pub fn to_xml_string(node : XmlNode) -> String {
  let builder = StringBuilder::new()
  serialize_xml_node(builder, node, 0)
  builder.to_string()
}

// Convert unified Value AST to XML Node
pub fn value_to_xml(v : Value, root_tag : String) -> XmlNode {
  match v {
    Null => Element(root_tag, Map::new(), [Text("null")])
    BoolVal(b) => Element(root_tag, Map::new(), [Text(b.to_string())])
    IntVal(i) => Element(root_tag, Map::new(), [Text(i.to_string())])
    DoubleVal(d) => Element(root_tag, Map::new(), [Text(d.to_string())])
    StringVal(s) => Element(root_tag, Map::new(), [Text(s)])
    ArrayVal(arr) => {
      let children = []
      for i = 0; i < arr.length(); i = i + 1 {
        children.push(value_to_xml(arr[i], "item"))
      }
      Element(root_tag, Map::new(), children)
    }
    ObjectVal(map) => {
      let children = []
      let attrs = Map::new()
      map.each(fn(k, val) {
        // If child is a primitive value, it can sometimes be serialized as attribute
        // But for simplicity, we map object keys to child elements
        children.push(value_to_xml(val, k))
      })
      Element(root_tag, attrs, children)
    }
  }
}

// Convert XML Node to unified Value AST
pub fn xml_to_value(node : XmlNode) -> Value {
  match node {
    Text(s) => {
      // Try to parse primitives
      if s == "null" { Null }
      else if s == "true" { BoolVal(true) }
      else if s == "false" { BoolVal(false) }
      else {
        match parse_int_str(s) {
          Some(i) => IntVal(i)
          None => match parse_double_str(s) {
            Some(d) => DoubleVal(d)
            None => StringVal(s)
          }
        }
      }
    }
    Comment(_) => Null
    Element(_, attrs, children) => {
      if children.length() == 0 && attrs.size() == 0 {
        return Null
      }
      
      // If it only contains text child and no attributes, parse it directly as primitive value
      if children.length() == 1 && attrs.size() == 0 {
        match children[0] {
          Text(txt) => return xml_to_value(Text(txt))
          _ => ()
        }
      }
      
      // If it has children with duplicate tag names, treat as array
      let mut is_array = false
      if children.length() > 0 {
        let first_tag = get_node_tag(children[0])
        if first_tag != "" {
          let mut all_same = true
          for i = 1; i < children.length(); i = i + 1 {
            if get_node_tag(children[i]) != first_tag {
              all_same = false
              break
            }
          }
          if all_same && children.length() > 1 {
            is_array = true
          }
        }
      }
      
      if is_array {
        let arr = []
        for i = 0; i < children.length(); i = i + 1 {
          arr.push(xml_to_value(children[i]))
        }
        ArrayVal(arr)
      } else {
        let map = Map::new()
        attrs.each(fn(k, v) {
          map.set("@" + k, StringVal(v))
        })
        for i = 0; i < children.length(); i = i + 1 {
          let child = children[i]
          match child {
            Element(tag, _, _) => map.set(tag, xml_to_value(child))
            Text(t) => if children.length() == 1 { return StringVal(t) } // fallback
            Comment(_) => ()
          }
        }
        ObjectVal(map)
      }
    }
  }
}

fn get_node_tag(node : XmlNode) -> String {
  match node {
    Element(tag, _, _) => tag
    _ => ""
  }
}

fn parse_int_str(s : String) -> Option[Int] {
  if s.length() == 0 { return None }
  let mut val = 0
  let mut sign = 1
  let mut start = 0
  if s[0] == '-' {
    sign = -1
    start = 1
  } else if s[0] == '+' {
    start = 1
  }
  if start >= s.length() { return None }
  for i = start; i < s.length(); i = i + 1 {
    let c = s[i].to_int()
    if c >= 48 && c <= 57 {
      val = val * 10 + (c - 48)
    } else {
      return None
    }
  }
  Some(val * sign)
}

fn parse_double_str(s : String) -> Option[Double] {
  // Simple check for decimal point
  let mut has_dot = false
  for i = 0; i < s.length(); i = i + 1 {
    if s[i] == '.' {
      has_dot = true
      break
    }
  }
  if !has_dot { return None }
  
  // FFI helper to parse double in JS
  let d = parse_float_ffi(s)
  if is_nan_ffi(d) {
    None
  } else {
    Some(d)
  }
}

#cfg(target = "js")
extern "js" fn parse_float_ffi(s : String) -> Double = "(s) => parseFloat(s)"
#cfg(target = "js")
extern "js" fn is_nan_ffi(d : Double) -> Bool = "(d) => isNaN(d)"

#cfg(not(target = "js"))
fn parse_float_ffi(s : String) -> Double {
  let mut val = 0.0
  let mut factor = 10.0
  let mut dot = false
  let mut start = 0
  let mut sign = 1.0
  if s.length() > 0 && Char::from_int(s[0].to_int()) == '-' {
    sign = -1.0
    start = 1
  } else if s.length() > 0 && Char::from_int(s[0].to_int()) == '+' {
    start = 1
  }
  for i = start; i < s.length(); i = i + 1 {
    let c = Char::from_int(s[i].to_int())
    if c == '.' {
      dot = true
    } else {
      let digit = s[i].to_int() - 48
      if digit >= 0 && digit <= 9 {
        if dot {
          val = val + digit.to_double() / factor
          factor = factor * 10.0
        } else {
          val = val * 10.0 + digit.to_double()
        }
      }
    }
  }
  val * sign
}

#cfg(not(target = "js"))
fn is_nan_ffi(_d : Double) -> Bool {
  false
}

struct XmlParser {
  input : String
  mut pos : Int
}

fn skip_whitespace_and_prolog(p : XmlParser) -> Unit {
  while p.pos < p.input.length() {
    let c = p.input[p.pos]
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' {
      p.pos = p.pos + 1
    } else if p.pos + 2 < p.input.length() && p.input[p.pos] == '<' && p.input[p.pos+1] == '?' {
      // Skip prolog <?xml ... ?>
      p.pos = p.pos + 2
      while p.pos + 1 < p.input.length() && not(p.input[p.pos] == '?' && p.input[p.pos+1] == '>') {
        p.pos = p.pos + 1
      }
      p.pos = p.pos + 2
    } else {
      break
    }
  }
}

fn parse_xml_node(p : XmlParser) -> Result[XmlNode, String] {
  if p.pos >= p.input.length() {
    return Err("Unexpected end of XML input")
  }
  
  if p.input[p.pos] == '<' {
    if p.pos + 4 < p.input.length() && p.input[p.pos+1] == '!' && p.input[p.pos+2] == '-' && p.input[p.pos+3] == '-' {
      // Parse comment <!-- ... -->
      p.pos = p.pos + 4
      let start = p.pos
      while p.pos + 2 < p.input.length() && not(p.input[p.pos] == '-' && p.input[p.pos+1] == '-' && p.input[p.pos+2] == '>') {
        p.pos = p.pos + 1
      }
      if p.pos + 2 >= p.input.length() {
        return Err("Unterminated XML comment")
      }
      let comment_str = p.input[start:p.pos].to_string()
      p.pos = p.pos + 3
      return Ok(Comment(comment_str))
    }
    
    // Parse Element tag
    p.pos = p.pos + 1
    let tag_name = parse_tag_name(p)
    if tag_name == "" {
      return Err("Expected element tag name at pos " + p.pos.to_string())
    }
    
    let attrs = Map::new()
    skip_xml_whitespace(p)
    
    while p.pos < p.input.length() && p.input[p.pos] != '/' && p.input[p.pos] != '>' {
      let attr_name = parse_tag_name(p)
      if attr_name == "" {
        return Err("Expected attribute name at pos " + p.pos.to_string())
      }
      skip_xml_whitespace(p)
      if p.pos >= p.input.length() || p.input[p.pos] != '=' {
        return Err("Expected '=' after attribute name at pos " + p.pos.to_string())
      }
      p.pos = p.pos + 1
      skip_xml_whitespace(p)
      match parse_quoted_value(p) {
        Ok(attr_val) => attrs.set(attr_name, attr_val)
        Err(e) => return Err(e)
      }
      skip_xml_whitespace(p)
    }
    
    if p.pos >= p.input.length() {
      return Err("Unclosed XML element tag")
    }
    
    if p.input[p.pos] == '/' {
      // Self-closing element `<tag />`
      if p.pos + 1 >= p.input.length() || p.input[p.pos+1] != '>' {
        return Err("Expected '>' after '/' in self-closing tag")
      }
      p.pos = p.pos + 2
      return Ok(Element(tag_name, attrs, []))
    }
    
    p.pos = p.pos + 1 // skip '>'
    
    let children = []
    while p.pos < p.input.length() {
      skip_xml_whitespace(p)
      if p.pos + 1 < p.input.length() && p.input[p.pos] == '<' && p.input[p.pos+1] == '/' {
        // Closing tag `</tag>`
        p.pos = p.pos + 2
        let close_tag = parse_tag_name(p)
        skip_xml_whitespace(p)
        if p.pos >= p.input.length() || p.input[p.pos] != '>' {
          return Err("Expected '>' in closing tag")
        }
        p.pos = p.pos + 1
        if close_tag != tag_name {
          return Err("Mismatched closing tag: expected </" + tag_name + ">, got </" + close_tag + ">")
        }
        return Ok(Element(tag_name, attrs, children))
      } else {
        // Child node (element or text)
        if p.input[p.pos] == '<' {
          match parse_xml_node(p) {
            Ok(child) => children.push(child)
            Err(e) => return Err(e)
          }
        } else {
          let text_node = parse_text_node(p)
          if get_text_content(text_node) != "" {
            children.push(text_node)
          }
        }
      }
    }
    
    Err("Unclosed element tag: <" + tag_name + ">")
  } else {
    // Parse pure Text Node
    Ok(parse_text_node(p))
  }
}

fn get_text_content(node : XmlNode) -> String {
  match node {
    Text(t) => t
    _ => ""
  }
}

fn skip_xml_whitespace(p : XmlParser) -> Unit {
  while p.pos < p.input.length() {
    let c = p.input[p.pos]
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' {
      p.pos = p.pos + 1
    } else {
      break
    }
  }
}

fn parse_tag_name(p : XmlParser) -> String {
  let start = p.pos
  while p.pos < p.input.length() {
    let c = p.input[p.pos]
    if (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_' || c == '-' || c == ':' {
      p.pos = p.pos + 1
    } else {
      break
    }
  }
  p.input[start:p.pos].to_string()
}

fn parse_quoted_value(p : XmlParser) -> Result[String, String] {
  if p.pos >= p.input.length() {
    return Err("Expected quoted value")
  }
  let quote = p.input[p.pos]
  if quote != '"' && quote != '\'' {
    return Err("Expected quote character \" or ' at pos " + p.pos.to_string())
  }
  p.pos = p.pos + 1
  let start = p.pos
  while p.pos < p.input.length() && p.input[p.pos] != quote {
    p.pos = p.pos + 1
  }
  if p.pos >= p.input.length() {
    return Err("Unterminated quoted attribute value")
  }
  let val = p.input[start:p.pos].to_string()
  p.pos = p.pos + 1 // skip end quote
  Ok(val)
}

fn parse_text_node(p : XmlParser) -> XmlNode {
  let start = p.pos
  while p.pos < p.input.length() && p.input[p.pos] != '<' {
    p.pos = p.pos + 1
  }
  let text = p.input[start:p.pos].to_string().trim().to_string()
  Text(text)
}

fn serialize_xml_node(builder : StringBuilder, node : XmlNode, indent : Int) -> Unit {
  let indent_str = get_indent(indent)
  match node {
    Text(t) => {
      builder.write_string(t)
    }
    Comment(c) => {
      builder.write_string(indent_str)
      builder.write_string("<!--")
      builder.write_string(c)
      builder.write_string("-->\n")
    }
    Element(tag, attrs, children) => {
      builder.write_string(indent_str)
      builder.write_string("<")
      builder.write_string(tag)
      attrs.each(fn(k, v) {
        builder.write_string(" ")
        builder.write_string(k)
        builder.write_string("=\"")
        builder.write_string(v)
        builder.write_string("\"")
      })
      
      if children.length() == 0 {
        builder.write_string(" />\n")
      } else {
        builder.write_string(">")
        
        let has_element_children = children_have_elements(children)
        if has_element_children {
          builder.write_string("\n")
          for i = 0; i < children.length(); i = i + 1 {
            serialize_xml_node(builder, children[i], indent + 2)
          }
          builder.write_string(indent_str)
        } else {
          for i = 0; i < children.length(); i = i + 1 {
            serialize_xml_node(builder, children[i], 0)
          }
        }
        
        builder.write_string("</")
        builder.write_string(tag)
        builder.write_string(">\n")
      }
    }
  }
}

fn children_have_elements(arr : Array[XmlNode]) -> Bool {
  for i = 0; i < arr.length(); i = i + 1 {
    match arr[i] {
      Element(_, _, _) => return true
      _ => ()
    }
  }
  false
}

fn get_indent(n : Int) -> String {
  let builder = StringBuilder::new()
  for i = 0; i < n; i = i + 1 {
    builder.write_string(" ")
  }
  builder.to_string()
}
