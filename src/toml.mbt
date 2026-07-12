// TOML AST, Parser, and Serializer implementation for MoonSerde

// Parse TOML string to unified Value AST
pub fn parse_toml(s : String) -> Result[Value, String] {
  let lines = split_lines(s)
  let clean_lines = []
  for i = 0; i < lines.length(); i = i + 1 {
    let l = lines[i].trim().to_owned()
    if l.length() > 0 && !l.has_prefix("#") {
      clean_lines.push(l)
    }
  }
  
  let root = Map::new()
  let mut current_table_path = []
  
  for i = 0; i < clean_lines.length(); i = i + 1 {
    let line = clean_lines[i]
    if line.has_prefix("[[") && line.has_suffix("]]") {
      // Array of tables: `[[table.sub]]`
      let path_str = sub_string(line, 2, line.length() - 2).trim().to_owned()
      match parse_dotted_path(path_str) {
        Ok(path) => {
          current_table_path = path
          create_array_table_entry(root, path)
        }
        Err(e) => return Err(e)
      }
    } else if line.has_prefix("[") && line.has_suffix("]") {
      // Standard table: `[table]`
      let path_str = sub_string(line, 1, line.length() - 1).trim().to_owned()
      match parse_dotted_path(path_str) {
        Ok(path) => {
          current_table_path = path
          create_table_path(root, path)
        }
        Err(e) => return Err(e)
      }
    } else {
      // Key-value pair: `key = value`
      let eq_idx = get_toml_eq_idx(line)
      if eq_idx < 0 {
        return Err("Expected '=' in key-value pair on line: " + line)
      }
      let key_str = sub_string(line, 0, eq_idx).trim().to_owned()
      let val_str = sub_string(line, eq_idx + 1, line.length()).trim().to_owned()
      
      match parse_dotted_path(key_str) {
        Ok(key_path) => {
          match parse_toml_inline(val_str) {
            Ok(val) => {
              match insert_value_at_path(root, current_table_path, key_path, val) {
                Ok(_) => ()
                Err(e) => return Err(e)
              }
            }
            Err(e) => return Err(e)
          }
        }
        Err(e) => return Err(e)
      }
    }
  }
  
  Ok(ObjectVal(root))
}

// Convert unified Value AST to TOML String
pub fn to_toml_string(v : Value) -> Result[String, String] {
  match v {
    ObjectVal(map) => {
      let builder = StringBuilder::new()
      match serialize_toml_table(builder, map, []) {
        Ok(_) => Ok(builder.to_string())
        Err(e) => Err(e)
      }
    }
    _ => Err("Root of TOML must be an Object/Table")
  }
}

fn parse_dotted_path(s : String) -> Result[Array[String], String] {
  let parts = []
  let mut start = 0
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
    } else if c == '.' && !in_quote {
      let part = sub_string(s, start, i).trim().to_owned()
      parts.push(clean_yaml_key(part))
      start = i + 1
    }
  }
  
  if start < s.length() {
    let part = sub_string(s, start, s.length()).trim().to_owned()
    parts.push(clean_yaml_key(part))
  }
  
  if parts.length() == 0 {
    return Err("Empty path segment in key: " + s)
  }
  
  Ok(parts)
}

fn get_toml_eq_idx(s : String) -> Int {
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
    } else if c == '=' && !in_quote {
      return i
    }
  }
  -1
}

fn parse_toml_inline(s : String) -> Result[Value, String] {
  if s.length() == 0 {
    return Err("Empty TOML value")
  }
  
  // Double quotes string
  let c0 = Char::from_int(s[0].to_int())
  let clast = Char::from_int(s[s.length()-1].to_int())
  if c0 == '"' {
    if clast != '"' { return Err("Unterminated string: " + s) }
    return Ok(StringVal(sub_string(s, 1, s.length() - 1)))
  }
  
  // Literal string
  if c0 == '\'' {
    if clast != '\'' { return Err("Unterminated literal string: " + s) }
    return Ok(StringVal(sub_string(s, 1, s.length() - 1)))
  }
  
  if s == "true" {
    return Ok(BoolVal(true))
  }
  if s == "false" {
    return Ok(BoolVal(false))
  }
  
  // Array: `[1, 2, 3]`
  if c0 == '[' {
    if clast != ']' { return Err("Unterminated array: " + s) }
    let inner = sub_string(s, 1, s.length() - 1).trim().to_owned()
    if inner == "" {
      return Ok(ArrayVal([]))
    }
    match split_toml_array_items(inner) {
      Ok(parts) => {
        let arr = []
        for i = 0; i < parts.length(); i = i + 1 {
          match parse_toml_inline(parts[i]) {
            Ok(p_val) => arr.push(p_val)
            Err(e) => return Err(e)
          }
        }
        return Ok(ArrayVal(arr))
      }
      Err(e) => return Err(e)
    }
  }
  
  // Inline Table: `{ a = 1, b = 2 }`
  if c0 == '{' {
    if clast != '}' { return Err("Unterminated inline table: " + s) }
    let inner = sub_string(s, 1, s.length() - 1).trim().to_owned()
    let map = Map::new()
    if inner == "" {
      return Ok(ObjectVal(map))
    }
    match split_toml_array_items(inner) {
      Ok(parts) => {
        for i = 0; i < parts.length(); i = i + 1 {
          let kv = parts[i].trim().to_owned()
          let eq = get_toml_eq_idx(kv)
          if eq < 0 { return Err("Expected '=' in inline table key-value: " + kv) }
          let k = sub_string(kv, 0, eq).trim().to_owned()
          let v_str = sub_string(kv, eq + 1, kv.length()).trim().to_owned()
          match parse_dotted_path(k) {
            Ok(k_path) => {
              match parse_toml_inline(v_str) {
                Ok(v) => {
                  match insert_value_at_path(map, [], k_path, v) {
                    Ok(_) => ()
                    Err(e) => return Err(e)
                  }
                }
                Err(e) => return Err(e)
              }
            }
            Err(e) => return Err(e)
          }
        }
        return Ok(ObjectVal(map))
      }
      Err(e) => return Err(e)
    }
  }
  
  // Number
  match parse_int_str(s) {
    Some(i) => Ok(IntVal(i))
    None => match parse_double_str(s) {
      Some(d) => Ok(DoubleVal(d))
      None => {
        // Treat anything else as unquoted string (e.g. datetime or fallback)
        Ok(StringVal(s))
      }
    }
  }
}

fn split_toml_array_items(s : String) -> Result[Array[String], String] {
  let arr = []
  let mut start = 0
  let mut in_quote = false
  let mut quote_char = ' '
  let mut bracket_depth = 0
  let mut brace_depth = 0
  
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
    } else if !in_quote {
      if c == '[' { bracket_depth = bracket_depth + 1 }
      else if c == ']' { bracket_depth = bracket_depth - 1 }
      else if c == '{' { brace_depth = brace_depth + 1 }
      else if c == '}' { brace_depth = brace_depth - 1 }
      else if c == ',' && bracket_depth == 0 && brace_depth == 0 {
        let item = sub_string(s, start, i).trim().to_owned()
        if item != "" {
          arr.push(item)
        }
        start = i + 1
      }
    }
  }
  
  let final_item = sub_string(s, start, s.length()).trim().to_owned()
  if final_item != "" {
    arr.push(final_item)
  }
  
  Ok(arr)
}

fn create_table_path(root : Map[String, Value], path : Array[String]) -> Unit {
  let mut current = root
  for i = 0; i < path.length(); i = i + 1 {
    let p = path[i]
    match current.get(p) {
      Some(ObjectVal(child_map)) => {
        current = child_map
      }
      _ => {
        let new_map = Map::new()
        current.set(p, ObjectVal(new_map))
        current = new_map
      }
    }
  }
}

fn create_array_table_entry(root : Map[String, Value], path : Array[String]) -> Unit {
  let mut current = root
  for i = 0; i < path.length(); i = i + 1 {
    let p = path[i]
    let is_last = i + 1 == path.length()
    
    if is_last {
      match current.get(p) {
        Some(ArrayVal(arr)) => {
          let new_map = Map::new()
          arr.push(ObjectVal(new_map))
        }
        _ => {
          let new_map = Map::new()
          current.set(p, ArrayVal([ObjectVal(new_map)]))
        }
      }
    } else {
      match current.get(p) {
        Some(ObjectVal(child_map)) => {
          current = child_map
        }
        Some(ArrayVal(arr)) => {
          if arr.length() == 0 {
            let new_map = Map::new()
            arr.push(ObjectVal(new_map))
            current = new_map
          } else {
            match arr[arr.length() - 1] {
              ObjectVal(child_map) => current = child_map
              _ => {
                let new_map = Map::new()
                current.set(p, ObjectVal(new_map))
                current = new_map
              }
            }
          }
        }
        _ => {
          let new_map = Map::new()
          current.set(p, ObjectVal(new_map))
          current = new_map
        }
      }
    }
  }
}

fn insert_value_at_path(
  root : Map[String, Value],
  table_path : Array[String],
  key_path : Array[String],
  val : Value
) -> Result[Unit, String] {
  // 1. Resolve table_path
  let mut current = root
  for i = 0; i < table_path.length(); i = i + 1 {
    let p = table_path[i]
    match current.get(p) {
      Some(ObjectVal(child_map)) => {
        current = child_map
      }
      Some(ArrayVal(arr)) => {
        if arr.length() == 0 {
          return Err("Array table path resolves to empty array")
        }
        match arr[arr.length() - 1] {
          ObjectVal(child_map) => current = child_map
          _ => return Err("Invalid table path resolution")
        }
      }
      _ => {
        let new_map = Map::new()
        current.set(p, ObjectVal(new_map))
        current = new_map
      }
    }
  }
  
  // 2. Resolve key_path and insert val
  for i = 0; i < key_path.length(); i = i + 1 {
    let k = key_path[i]
    let is_last = i + 1 == key_path.length()
    if is_last {
      current.set(k, val)
    } else {
      match current.get(k) {
        Some(ObjectVal(child_map)) => {
          current = child_map
        }
        _ => {
          let new_map = Map::new()
          current.set(k, ObjectVal(new_map))
          current = new_map
        }
      }
    }
  }
  
  Ok(())
}

fn serialize_toml_table(builder : StringBuilder, map : Map[String, Value], path : Array[String]) -> Result[Unit, String] {
  // 1. Write non-table elements first
  let mut err = None
  map.each(fn(k, val) {
    match err {
      None => match val {
        ObjectVal(_) | ArrayVal(_) => () // handle tables/arrays of tables later
        _ => {
          builder.write_string(k)
          builder.write_string(" = ")
          serialize_toml_value(builder, val)
          builder.write_string("\n")
        }
      }
      Some(_) => ()
    }
  })
  if err.is_some() { return Err(err.unwrap()) }
  
  // 2. Write tables and array of tables
  map.each(fn(k, val) {
    match err {
      None => {
        let new_path = []
        for i = 0; i < path.length(); i = i + 1 {
          new_path.push(path[i])
        }
        new_path.push(k)
        
        match val {
          ObjectVal(child_map) => {
            builder.write_string("\n[")
            write_toml_path(builder, new_path)
            builder.write_string("]\n")
            match serialize_toml_table(builder, child_map, new_path) {
              Ok(_) => ()
              Err(e) => err = Some(e)
            }
          }
          ArrayVal(arr) => {
            let mut is_array_of_tables = false
            if arr.length() > 0 {
              match arr[0] {
                ObjectVal(_) => is_array_of_tables = true
                _ => ()
              }
            }
            if is_array_of_tables {
              for i = 0; i < arr.length(); i = i + 1 {
                builder.write_string("\n[[")
                write_toml_path(builder, new_path)
                builder.write_string("]]\n")
                match arr[i] {
                  ObjectVal(child_map) => {
                    match serialize_toml_table(builder, child_map, new_path) {
                      Ok(_) => ()
                      Err(e) => err = Some(e)
                    }
                  }
                  _ => err = Some("Expected Table in Array of Tables")
                }
              }
            } else {
              builder.write_string(k)
              builder.write_string(" = ")
              serialize_toml_value(builder, val)
              builder.write_string("\n")
            }
          }
          _ => ()
        }
      }
      Some(_) => ()
    }
  })
  
  if err.is_some() { return Err(err.unwrap()) }
  Ok(())
}

fn write_toml_path(builder : StringBuilder, path : Array[String]) -> Unit {
  for i = 0; i < path.length(); i = i + 1 {
    if i > 0 {
      builder.write_string(".")
    }
    builder.write_string(path[i])
  }
}

fn serialize_toml_value(builder : StringBuilder, v : Value) -> Unit {
  match v {
    Null => builder.write_string("\"\"")
    BoolVal(b) => builder.write_string(b.to_string())
    IntVal(i) => builder.write_string(i.to_string())
    DoubleVal(d) => builder.write_string(d.to_string())
    StringVal(s) => {
      builder.write_string("\"")
      builder.write_string(s)
      builder.write_string("\"")
    }
    ArrayVal(arr) => {
      builder.write_string("[")
      for i = 0; i < arr.length(); i = i + 1 {
        if i > 0 {
          builder.write_string(", ")
        }
        serialize_toml_value(builder, arr[i])
      }
      builder.write_string("]")
    }
    ObjectVal(map) => {
      // Inline table
      builder.write_string("{ ")
      let mut first = true
      map.each(fn(k, val) {
        if !first {
          builder.write_string(", ")
        }
        first = false
        builder.write_string(k)
        builder.write_string(" = ")
        serialize_toml_value(builder, val)
      })
      builder.write_string(" }")
    }
  }
}
