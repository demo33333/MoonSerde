// JSON Pointer (RFC 6901) parser and evaluator for MoonSerde Value AST

pub fn eval_pointer(v : Value, pointer : String) -> Result[Value, String] {
  if pointer.length() == 0 {
    return Ok(v)
  }
  
  if Char::from_int(pointer[0].to_int()) != '/' {
    return Err("JSON Pointer must start with '/': " + pointer)
  }
  
  let tokens = parse_pointer_tokens(pointer)
  eval_pointer_tokens(v, tokens, 0)
}

pub fn format_pointer(path : Array[String]) -> String {
  let builder = StringBuilder::new()
  for i = 0; i < path.length(); i = i + 1 {
    builder.write_string("/")
    let escaped = escape_pointer_token(path[i])
    builder.write_string(escaped)
  }
  builder.to_string()
}

fn parse_pointer_tokens(pointer : String) -> Array[String] {
  let tokens = []
  let mut start = 1
  for i = 1; i < pointer.length(); i = i + 1 {
    let c = Char::from_int(pointer[i].to_int())
    if c == '/' {
      let raw_token = sub_string(pointer, start, i)
      tokens.push(unescape_pointer_token(raw_token))
      start = i + 1
    }
  }
  if start <= pointer.length() {
    let raw_token = sub_string(pointer, start, pointer.length())
    tokens.push(unescape_pointer_token(raw_token))
  }
  tokens
}

fn unescape_pointer_token(token : String) -> String {
  let builder = StringBuilder::new()
  let mut i = 0
  while i < token.length() {
    let c = Char::from_int(token[i].to_int())
    if c == '~' && i + 1 < token.length() {
      let next_c = Char::from_int(token[i+1].to_int())
      if next_c == '0' {
        builder.write_char('~')
        i = i + 2
        continue
      } else if next_c == '1' {
        builder.write_char('/')
        i = i + 2
        continue
      }
    }
    builder.write_char(c)
    i = i + 1
  }
  builder.to_string()
}

fn escape_pointer_token(token : String) -> String {
  let builder = StringBuilder::new()
  for i = 0; i < token.length(); i = i + 1 {
    let c = Char::from_int(token[i].to_int())
    if c == '~' {
      builder.write_string("~0")
    } else if c == '/' {
      builder.write_string("~1")
    } else {
      builder.write_char(c)
    }
  }
  builder.to_string()
}

fn eval_pointer_tokens(v : Value, tokens : Array[String], token_idx : Int) -> Result[Value, String] {
  if token_idx >= tokens.length() {
    return Ok(v)
  }
  
  let token = tokens[token_idx]
  
  match v {
    ObjectVal(map) => {
      match map.get(token) {
        Some(child_val) => eval_pointer_tokens(child_val, tokens, token_idx + 1)
        None => Err("JSON Pointer resolution failed: member not found: " + token)
      }
    }
    ArrayVal(arr) => {
      if token == "-" {
        return Err("JSON Pointer resolution failed: '-' refers to non-existent array element")
      }
      match parse_int_str(token) {
        Some(idx) => {
          if idx < 0 || idx >= arr.length() {
            return Err("JSON Pointer resolution failed: index out of bounds: " + token)
          }
          eval_pointer_tokens(arr[idx], tokens, token_idx + 1)
        }
        None => Err("JSON Pointer resolution failed: non-integer array index: " + token)
      }
    }
    _ => Err("JSON Pointer resolution failed: cannot query non-container value with token: " + token)
  }
}
