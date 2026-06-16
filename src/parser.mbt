struct Parser {
  str : String
  mut pos : Int
}

fn Parser::skip_whitespace(self : Parser) -> Unit {
  while self.pos < self.str.length() {
    let c = self.str[self.pos].to_int()
    if c == 32 || c == 10 || c == 13 || c == 9 {
      self.pos = self.pos + 1
    } else {
      break
    }
  }
}

fn Parser::match_char(self : Parser, c : Char) -> Bool {
  if self.pos < self.str.length() && self.str[self.pos].to_int() == c.to_int() {
    self.pos = self.pos + 1
    true
  } else {
    false
  }
}

fn Parser::expect_char(self : Parser, c : Char) -> Result[Unit, String] {
  if self.match_char(c) {
    Ok(())
  } else {
    Err("Expected " + c.to_string() + " at pos " + self.pos.to_string())
  }
}

fn Parser::parse_string(self : Parser) -> Result[String, String] {
  match self.expect_char('"') {
    Err(e) => return Err(e)
    Ok(_) => ()
  }
  let b = StringBuilder::new()
  while self.pos < self.str.length() {
    let c = self.str[self.pos].to_int()
    if c == 34 {
      self.pos = self.pos + 1
      break
    } else if c == 92 {
      self.pos = self.pos + 1
      if self.pos < self.str.length() {
        let esc = self.str[self.pos].to_int()
        if esc == 110 { b.write_char('\n') }
        else if esc == 34 { b.write_char('"') }
        else if esc == 92 { b.write_char('\\') }
        else { b.write_char(Char::from_int(esc)) }
        self.pos = self.pos + 1
      }
    } else {
      b.write_char(Char::from_int(c))
      self.pos = self.pos + 1
    }
  }
  Ok(b.to_string())
}

fn Parser::parse_number(self : Parser) -> Result[Double, String] {
  let mut val = 0.0
  let mut sign = 1.0
  if self.pos < self.str.length() && self.str[self.pos].to_int() == 45 {
    sign = -1.0
    self.pos = self.pos + 1
  }
  while self.pos < self.str.length() {
    let c = self.str[self.pos].to_int()
    if c >= 48 && c <= 57 {
      val = val * 10.0 + (c - 48).to_double()
      self.pos = self.pos + 1
    } else {
      break
    }
  }
  while self.pos < self.str.length() {
    let c = self.str[self.pos].to_int()
    if c == 46 || (c >= 48 && c <= 57) {
      self.pos = self.pos + 1
    } else {
      break
    }
  }
  Ok(val * sign)
}

fn Parser::parse_value(self : Parser) -> Result[Value, String] {
  self.skip_whitespace()
  if self.pos >= self.str.length() {
    return Err("Unexpected end of input")
  }
  let c = self.str[self.pos].to_int()
  if c == 123 {
    match self.expect_char('{') { Err(e) => return Err(e); Ok(_) => () }
    self.skip_whitespace()
    let map = Map::new()
    if self.match_char('}') {
      return Ok(ObjectVal(map))
    }
    while true {
      self.skip_whitespace()
      let key = match self.parse_string() { Err(e) => return Err(e); Ok(v) => v }
      self.skip_whitespace()
      match self.expect_char(':') { Err(e) => return Err(e); Ok(_) => () }
      let val = match self.parse_value() { Err(e) => return Err(e); Ok(v) => v }
      map.set(key, val)
      self.skip_whitespace()
      if self.match_char('}') {
        break
      }
      match self.expect_char(',') { Err(e) => return Err(e); Ok(_) => () }
    }
    Ok(ObjectVal(map))
  } else if c == 91 {
    match self.expect_char('[') { Err(e) => return Err(e); Ok(_) => () }
    self.skip_whitespace()
    let arr = []
    if self.match_char(']') {
      return Ok(ArrayVal(arr))
    }
    while true {
      let val = match self.parse_value() { Err(e) => return Err(e); Ok(v) => v }
      arr.push(val)
      self.skip_whitespace()
      if self.match_char(']') {
        break
      }
      match self.expect_char(',') { Err(e) => return Err(e); Ok(_) => () }
    }
    Ok(ArrayVal(arr))
  } else if c == 34 {
    let s = match self.parse_string() { Err(e) => return Err(e); Ok(v) => v }
    Ok(StringVal(s))
  } else if c == 116 {
    match self.expect_char('t') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('r') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('u') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('e') { Err(e) => return Err(e); Ok(_) => () }
    Ok(BoolVal(true))
  } else if c == 102 {
    match self.expect_char('f') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('a') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('l') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('s') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('e') { Err(e) => return Err(e); Ok(_) => () }
    Ok(BoolVal(false))
  } else if c == 110 {
    match self.expect_char('n') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('u') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('l') { Err(e) => return Err(e); Ok(_) => () }
    match self.expect_char('l') { Err(e) => return Err(e); Ok(_) => () }
    Ok(Null)
  } else {
    let d = match self.parse_number() { Err(e) => return Err(e); Ok(v) => v }
    Ok(DoubleVal(d))
  }
}

pub fn from_json(str : String) -> Result[Value, String] {
  let p = { str: str, pos: 0 }
  p.parse_value()
}
