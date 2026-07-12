// x-www-form-urlencoded Parser and Serializer for MoonSerde

pub fn parse_form(s : String) -> Result[Value, String] {
  if s.length() == 0 {
    return Ok(ObjectVal(Map::new()))
  }
  
  let root = Map::new()
  let pairs = split_char(s, '&')
  
  for i = 0; i < pairs.length(); i = i + 1 {
    let pair = pairs[i]
    if pair.length() == 0 {
      continue
    }
    
    let eq_idx = get_char_idx(pair, '=')
    let key_raw = if eq_idx < 0 { pair } else { sub_string(pair, 0, eq_idx) }
    let val_raw = if eq_idx < 0 { "" } else { sub_string(pair, eq_idx + 1, pair.length()) }
    
    match url_decode(key_raw) {
      Ok(key_decoded) => {
        match url_decode(val_raw) {
          Ok(val_decoded) => {
            match parse_form_key_path(key_decoded) {
              Ok(path) => {
                let val = parse_form_value(val_decoded)
                match insert_form_value(root, path, val) {
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
      Err(e) => return Err(e)
    }
  }
  
  Ok(ObjectVal(root))
}

pub fn to_form_string(v : Value) -> Result[String, String] {
  let builder = StringBuilder::new()
  match serialize_form_value(builder, v, "") {
    Ok(_) => {
      let mut s = builder.to_string()
      if s.has_suffix("&") {
        s = sub_string(s, 0, s.length() - 1)
      }
      Ok(s)
    }
    Err(e) => Err(e)
  }
}

fn split_char(s : String, delimiter : Char) -> Array[String] {
  let arr = []
  let mut start = 0
  for i = 0; i < s.length(); i = i + 1 {
    if Char::from_int(s[i].to_int()) == delimiter {
      arr.push(sub_string(s, start, i))
      start = i + 1
    }
  }
  if start <= s.length() {
    arr.push(sub_string(s, start, s.length()))
  }
  arr
}

fn get_char_idx(s : String, c : Char) -> Int {
  for i = 0; i < s.length(); i = i + 1 {
    if Char::from_int(s[i].to_int()) == c {
      return i
    }
  }
  -1
}

fn url_decode(s : String) -> Result[String, String] {
  let builder = StringBuilder::new()
  let mut i = 0
  while i < s.length() {
    let c = Char::from_int(s[i].to_int())
    if c == '+' {
      builder.write_char(' ')
      i = i + 1
    } else if c == '%' {
      if i + 2 >= s.length() {
        return Err("Invalid percent encoding in: " + s)
      }
      let h1 = s[i+1].to_int()
      let h2 = s[i+2].to_int()
      let v1 = hex_val(h1)
      let v2 = hex_val(h2)
      if v1 < 0 || v2 < 0 {
        return Err("Invalid hex characters in percent encoding: " + s)
      }
      let byte_val = v1 * 16 + v2
      builder.write_char(Char::from_int(byte_val))
      i = i + 3
    } else {
      builder.write_char(c)
      i = i + 1
    }
  }
  Ok(builder.to_string())
}

fn hex_val(c : Int) -> Int {
  if c >= 48 && c <= 57 { return c - 48 } // '0'..'9'
  if c >= 65 && c <= 70 { return c - 55 } // 'A'..'F'
  if c >= 97 && c <= 102 { return c - 87 } // 'a'..'f'
  -1
}

fn url_encode(s : String) -> String {
  let builder = StringBuilder::new()
  for i = 0; i < s.length(); i = i + 1 {
    let c = Char::from_int(s[i].to_int())
    if (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '-' || c == '_' || c == '.' || c == '~' {
      builder.write_char(c)
    } else if c == ' ' {
      builder.write_char('+')
    } else {
      let b = s[i].to_int()
      let h1 = b / 16
      let h2 = b % 16
      builder.write_string("%")
      builder.write_char(hex_char(h1))
      builder.write_char(hex_char(h2))
    }
  }
  builder.to_string()
}

fn hex_char(v : Int) -> Char {
  if v >= 0 && v <= 9 { return Char::from_int(v + 48) }
  Char::from_int(v + 55) // 'A'..'F'
}

enum FormKeySegment {
  KeyName(String)
  ArrayIndex(Int)
  ArrayPush
} derive(Debug, Eq)

fn parse_form_key_path(s : String) -> Result[Array[FormKeySegment], String] {
  let path = []
  let bracket_idx = get_char_idx(s, '[')
  if bracket_idx < 0 {
    path.push(KeyName(s))
    return Ok(path)
  }
  
  let first_key = sub_string(s, 0, bracket_idx)
  if first_key.length() == 0 {
    return Err("Form key path cannot start with a bracket: " + s)
  }
  path.push(KeyName(first_key))
  
  let mut i = bracket_idx
  while i < s.length() {
    let c = Char::from_int(s[i].to_int())
    if c == '[' {
      let close = get_char_idx_from(s, ']', i + 1)
      if close < 0 {
        return Err("Unclosed bracket in key path: " + s)
      }
      let inner = sub_string(s, i + 1, close)
      if inner == "" {
        path.push(ArrayPush)
      } else {
        match parse_int_str(inner) {
          Some(idx) => path.push(ArrayIndex(idx))
          None => path.push(KeyName(inner))
        }
      }
      i = close + 1
    } else {
      return Err("Invalid character outside brackets in: " + s)
    }
  }
  
  Ok(path)
}

fn get_char_idx_from(s : String, c : Char, start : Int) -> Int {
  for i = start; i < s.length(); i = i + 1 {
    if Char::from_int(s[i].to_int()) == c {
      return i
    }
  }
  -1
}

fn parse_form_value(s : String) -> Value {
  if s == "true" { return BoolVal(true) }
  if s == "false" { return BoolVal(false) }
  if s == "null" { return Null }
  match parse_int_str(s) {
    Some(i) => IntVal(i)
    None => match parse_double_str(s) {
      Some(d) => DoubleVal(d)
      None => StringVal(s)
    }
  }
}

fn insert_form_value(
  root : Map[String, Value],
  path : Array[FormKeySegment],
  val : Value
) -> Result[Unit, String] {
  if path.length() == 0 {
    return Ok(())
  }
  
  match path[0] {
    KeyName(first_key) => {
      if path.length() == 1 {
        root.set(first_key, val)
        return Ok(())
      }
      
      let next_map = match root.get(first_key) {
        Some(ObjectVal(m)) => m
        Some(ArrayVal(arr)) => {
          // Convert array to object or return error. Let's return error to keep it simple.
          return Err("Conflicting container types at path segment: " + first_key)
        }
        _ => {
          let m = Map::new()
          root.set(first_key, ObjectVal(m))
          m
        }
      }
      insert_form_value_nested(next_map, path, 1, val)
    }
    _ => Err("First segment of form key path must be a KeyName")
  }
}

fn insert_form_value_nested(
  current_map : Map[String, Value],
  path : Array[FormKeySegment],
  idx : Int,
  val : Value
) -> Result[Unit, String] {
  if idx >= path.length() {
    return Ok(())
  }
  
  let seg = path[idx]
  let is_last = idx + 1 == path.length()
  
  match seg {
    KeyName(k) => {
      if is_last {
        current_map.set(k, val)
        return Ok(())
      }
      
      let next_map = match current_map.get(k) {
        Some(ObjectVal(m)) => m
        _ => {
          let m = Map::new()
          current_map.set(k, ObjectVal(m))
          m
        }
      }
      insert_form_value_nested(next_map, path, idx + 1, val)
    }
    ArrayIndex(arr_idx) => {
      // Form arrays are represented in MoonSerde Value AST as ArrayVal
      // We will handle them as array list or map conversion.
      // E.g. we treat index arrays as nested items. Let's make it simpler:
      // index array can be stored under a key string representation or nested.
      // Let's store under array list if possible.
      let k = arr_idx.to_string()
      if is_last {
        current_map.set(k, val)
        return Ok(())
      }
      let next_map = match current_map.get(k) {
        Some(ObjectVal(m)) => m
        _ => {
          let m = Map::new()
          current_map.set(k, ObjectVal(m))
          m
        }
      }
      insert_form_value_nested(next_map, path, idx + 1, val)
    }
    ArrayPush => {
      // Push to a list.
      // Since map keys are strings, we represent array push elements by numbering them.
      let mut max_idx = -1
      current_map.each(fn(k, _) {
        match parse_int_str(k) {
          Some(n) => if n > max_idx { max_idx = n }
          None => ()
        }
      })
      let new_key = (max_idx + 1).to_string()
      if is_last {
        current_map.set(new_key, val)
        return Ok(())
      }
      let next_map = Map::new()
      current_map.set(new_key, ObjectVal(next_map))
      insert_form_value_nested(next_map, path, idx + 1, val)
    }
  }
}

fn serialize_form_value(
  builder : StringBuilder,
  v : Value,
  prefix : String
) -> Result[Unit, String] {
  match v {
    Null => {
      builder.write_string(prefix)
      builder.write_string("=null&")
      Ok(())
    }
    BoolVal(b) => {
      builder.write_string(prefix)
      builder.write_string("=")
      builder.write_string(b.to_string())
      builder.write_string("&")
      Ok(())
    }
    IntVal(i) => {
      builder.write_string(prefix)
      builder.write_string("=")
      builder.write_string(i.to_string())
      builder.write_string("&")
      Ok(())
    }
    DoubleVal(d) => {
      builder.write_string(prefix)
      builder.write_string("=")
      builder.write_string(d.to_string())
      builder.write_string("&")
      Ok(())
    }
    StringVal(s) => {
      builder.write_string(prefix)
      builder.write_string("=")
      builder.write_string(url_encode(s))
      builder.write_string("&")
      Ok(())
    }
    ArrayVal(arr) => {
      for i = 0; i < arr.length(); i = i + 1 {
        let array_prefix = prefix + "[" + i.to_string() + "]"
        match serialize_form_value(builder, arr[i], array_prefix) {
          Ok(_) => ()
          Err(e) => return Err(e)
        }
      }
      Ok(())
    }
    ObjectVal(map) => {
      let mut err = None
      map.each(fn(k, val) {
        if err.is_none() {
          let object_prefix = if prefix == "" { url_encode(k) } else { prefix + "[" + url_encode(k) + "]" }
          match serialize_form_value(builder, val, object_prefix) {
            Ok(_) => ()
            Err(e) => err = Some(e)
          }
        }
      })
      match err {
        Some(e) => Err(e)
        None => Ok(())
      }
    }
  }
}
