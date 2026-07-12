// YAML AST, Parser, and Serializer implementation for MoonSerde

// Parse YAML string to unified Value AST
pub fn parse_yaml(s : String) -> Result[Value, String] {
  let lines = split_lines(s)
  let clean_lines = []
  for i = 0; i < lines.length(); i = i + 1 {
    let l = lines[i]
    let trimmed = l.trim().to_owned()
    // Skip empty lines and full comment lines
    if trimmed.length() > 0 && !trimmed.has_prefix("#") {
      clean_lines.push(l)
    }
  }
  
  if clean_lines.length() == 0 {
    return Ok(Null)
  }
  
  let reader = { lines: clean_lines, line_idx: 0 }
  parse_yaml_indented(reader, 0)
}

// Convert unified Value AST to YAML string
pub fn to_yaml_string(v : Value) -> String {
  let builder = StringBuilder::new()
  serialize_yaml_value(builder, v, 0, false)
  builder.to_string()
}

struct YamlReader {
  lines : Array[String]
  mut line_idx : Int
}

fn split_lines(s : String) -> Array[String] {
  let arr = []
  let mut start = 0
  let mut i = 0
  while i < s.length() {
    let c = Char::from_int(s[i].to_int())
    if c == '\n' {
      arr.push(sub_string(s, start, i))
      start = i + 1
    } else if c == '\r' {
      if i + 1 < s.length() {
        let next_c = Char::from_int(s[i+1].to_int())
        if next_c == '\n' {
          arr.push(sub_string(s, start, i))
          i = i + 1
          start = i + 1
        } else {
          arr.push(sub_string(s, start, i))
          start = i + 1
        }
      } else {
        arr.push(sub_string(s, start, i))
        start = i + 1
      }
    }
    i = i + 1
  }
  if start <= s.length() {
    arr.push(sub_string(s, start, s.length()))
  }
  arr
}

fn get_indent_level(line : String) -> Int {
  let mut count = 0
  for i = 0; i < line.length(); i = i + 1 {
    let c = Char::from_int(line[i].to_int())
    if c == ' ' {
      count = count + 1
    } else {
      break
    }
  }
  count
}

fn parse_yaml_indented(r : YamlReader, min_indent : Int) -> Result[Value, String] {
  if r.line_idx >= r.lines.length() {
    return Ok(Null)
  }
  
  let line = r.lines[r.line_idx]
  let indent = get_indent_level(line)
  
  if indent < min_indent {
    return Ok(Null)
  }
  
  let trimmed = line.trim().to_owned()
  
  // Case 1: Sequence Item `-`
  if trimmed.has_prefix("-") {
    let arr = []
    while r.line_idx < r.lines.length() {
      let cur_line = r.lines[r.line_idx]
      let cur_indent = get_indent_level(cur_line)
      if cur_indent < min_indent {
        break
      }
      
      let cur_trimmed = cur_line.trim().to_owned()
      if !cur_trimmed.has_prefix("-") {
        break
      }
      
      let content = sub_string(cur_trimmed, 1, cur_trimmed.length()).trim().to_owned()
      r.line_idx = r.line_idx + 1
      
      if content == "" {
        // Nested block under sequence
        match parse_yaml_indented(r, cur_indent + 1) {
          Ok(val) => arr.push(val)
          Err(e) => return Err(e)
        }
      } else {
        // Inline value
        let inline_val = parse_yaml_inline(content)
        arr.push(inline_val)
      }
    }
    return Ok(ArrayVal(arr))
  }
  
  // Case 2: Mapping block `key: value` or `key:`
  if is_mapping_line(trimmed) {
    let map = Map::new()
    while r.line_idx < r.lines.length() {
      let cur_line = r.lines[r.line_idx]
      let cur_indent = get_indent_level(cur_line)
      if cur_indent < min_indent {
        break
      }
      
      let cur_trimmed = cur_line.trim().to_owned()
      if !is_mapping_line(cur_trimmed) {
        break
      }
      
      let colon_idx = get_mapping_colon_idx(cur_trimmed)
      let key = sub_string(cur_trimmed, 0, colon_idx).trim().to_owned()
      let key_clean = clean_yaml_key(key)
      let val_str = sub_string(cur_trimmed, colon_idx + 1, cur_trimmed.length()).trim().to_owned()
      
      r.line_idx = r.line_idx + 1
      
      if val_str == "" {
        // Value is nested in next lines
        match parse_yaml_indented(r, cur_indent + 1) {
          Ok(val) => map.set(key_clean, val)
          Err(e) => return Err(e)
        }
      } else {
        let val = parse_yaml_inline(val_str)
        map.set(key_clean, val)
      }
    }
    return Ok(ObjectVal(map))
  }
  
  // Case 3: Simple Scalar value
  r.line_idx = r.line_idx + 1
  Ok(parse_yaml_inline(trimmed))
}

fn is_mapping_line(s : String) -> Bool {
  let idx = get_mapping_colon_idx(s)
  idx > 0
}

fn get_mapping_colon_idx(s : String) -> Int {
  let mut in_quote = false
  let mut quote_char = ' '
  for i = 0; i < s.length(); i = i + 1 {
    let c = Char::from_int(s[i].to_int())
    if c == '"' || c == '\'' {
      if in_quote {
        if c == quote_char {
          in_quote = false
        }
      } else {
        in_quote = true
        quote_char = c
      }
    } else if c == ':' && !in_quote {
      // Must be followed by space or end of string
      if i + 1 == s.length() {
        return i
      } else {
        let next_c = Char::from_int(s[i+1].to_int())
        if next_c == ' ' || next_c == '\t' {
          return i
        }
      }
    }
  }
  -1
}

fn clean_yaml_key(s : String) -> String {
  let len = s.length()
  if len >= 2 {
    let c0 = Char::from_int(s[0].to_int())
    let clast = Char::from_int(s[len-1].to_int())
    if (c0 == '"' && clast == '"') || (c0 == '\'' && clast == '\'') {
      return sub_string(s, 1, len - 1)
    }
  }
  s
}

fn parse_yaml_inline(s : String) -> Value {
  let len = s.length()
  if len >= 2 {
    let c0 = Char::from_int(s[0].to_int())
    let clast = Char::from_int(s[len-1].to_int())
    if (c0 == '"' && clast == '"') || (c0 == '\'' && clast == '\'') {
      return StringVal(sub_string(s, 1, len - 1))
    }
  }
  
  if s == "null" || s == "~" || s == "" {
    Null
  } else if s == "true" {
    BoolVal(true)
  } else if s == "false" {
    BoolVal(false)
  } else {
    match parse_int_str(s) {
      Some(i) => IntVal(i)
      None => match parse_double_str(s) {
        Some(d) => DoubleVal(d)
        None => StringVal(s)
      }
    }
  }
}

fn serialize_yaml_value(builder : StringBuilder, v : Value, indent : Int, is_array_item : Bool) -> Unit {
  match v {
    Null => builder.write_string("null\n")
    BoolVal(b) => {
      builder.write_string(b.to_string())
      builder.write_string("\n")
    }
    IntVal(i) => {
      builder.write_string(i.to_string())
      builder.write_string("\n")
    }
    DoubleVal(d) => {
      builder.write_string(d.to_string())
      builder.write_string("\n")
    }
    StringVal(s) => {
      if needs_quotes(s) {
        builder.write_string("\"")
        builder.write_string(s)
        builder.write_string("\"\n")
      } else {
        builder.write_string(s)
        builder.write_string("\n")
      }
    }
    ArrayVal(arr) => {
      if arr.length() == 0 {
        builder.write_string("[]\n")
        return
      }
      if !is_array_item && indent > 0 {
        builder.write_string("\n")
      }
      for i = 0; i < arr.length(); i = i + 1 {
        let item_indent = if is_array_item && i == 0 { "" } else { get_indent(indent) }
        builder.write_string(item_indent)
        builder.write_string("- ")
        
        let child = arr[i]
        match child {
          ArrayVal(_) | ObjectVal(_) => {
            serialize_yaml_value(builder, child, indent + 2, true)
          }
          _ => {
            serialize_yaml_value(builder, child, 0, false)
          }
        }
      }
    }
    ObjectVal(map) => {
      if map.length() == 0 {
        builder.write_string("{}\n")
        return
      }
      if !is_array_item && indent > 0 {
        builder.write_string("\n")
      }
      let mut first = true
      map.each(fn(k, val) {
        let item_indent = if is_array_item && first { "" } else { get_indent(indent) }
        first = false
        builder.write_string(item_indent)
        builder.write_string(k)
        builder.write_string(": ")
        
        match val {
          ArrayVal(_) | ObjectVal(_) => {
            serialize_yaml_value(builder, val, indent + 2, false)
          }
          _ => {
            serialize_yaml_value(builder, val, 0, false)
          }
        }
      })
    }
  }
}

fn needs_quotes(s : String) -> Bool {
  if s == "true" || s == "false" || s == "null" || s == "~" {
    return true
  }
  if s.length() == 0 {
    return true
  }
  let c0 = Char::from_int(s[0].to_int())
  if c0 == '-' || c0 == '?' || c0 == '{' || c0 == '}' || c0 == '[' || c0 == ']' || c0 == ',' || c0 == '#' || c0 == '|' || c0 == '>' || c0 == '&' || c0 == '*' || c0 == '!' || c0 == '%' || c0 == '@' || c0 == '`' {
    return true
  }
  for i = 0; i < s.length(); i = i + 1 {
    let c = Char::from_int(s[i].to_int())
    if c == ':' || c == ' ' || c == '\t' || c == '\n' || c == '\r' {
      return true
    }
  }
  false
}
