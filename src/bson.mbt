// BSON (Binary JSON) Parser and Serializer for MoonSerde

pub fn to_bson(v : Value) -> Result[Array[Byte], String] {
  let writer = BsonWriter::new()
  match v {
    ObjectVal(map) => {
      match writer.write_document(map) {
        Ok(_) => Ok(writer.to_bytes())
        Err(e) => Err(e)
      }
    }
    _ => Err("BSON root must be an Object/Document")
  }
}

pub fn parse_bson(bytes : Array[Byte]) -> Result[Value, String] {
  if bytes.length() < 5 {
    return Err("BSON document too small")
  }
  let reader = BsonReader::new(bytes)
  match reader.read_document() {
    Ok(map) => Ok(ObjectVal(map))
    Err(e) => Err(e)
  }
}

struct BsonWriter {
  buf : Array[Byte]
}

fn BsonWriter::new() -> BsonWriter {
  { buf: [] }
}

fn BsonWriter::write_byte(self : BsonWriter, b : Byte) -> Unit {
  self.buf.push(b)
}

fn BsonWriter::write_bytes(self : BsonWriter, bytes : Array[Byte]) -> Unit {
  for i = 0; i < bytes.length(); i = i + 1 {
    self.buf.push(bytes[i])
  }
}

fn BsonWriter::write_int32(self : BsonWriter, val : Int) -> Unit {
  self.buf.push((val & 0xFF).to_byte())
  self.buf.push(((val >> 8) & 0xFF).to_byte())
  self.buf.push(((val >> 16) & 0xFF).to_byte())
  self.buf.push(((val >> 24) & 0xFF).to_byte())
}

fn BsonWriter::write_int64(self : BsonWriter, val : Int64) -> Unit {
  let mut v = val
  for i = 0; i < 8; i = i + 1 {
    self.buf.push(((v & (255).to_int64()).to_int()).to_byte())
    v = v >> 8
  }
}

fn BsonWriter::write_double(self : BsonWriter, val : Double) -> Unit {
  let bits = val.reinterpret_as_uint64().to_int64()
  self.write_int64(bits)
}

fn BsonWriter::write_cstring(self : BsonWriter, s : String) -> Unit {
  for i = 0; i < s.length(); i = i + 1 {
    let b = s[i].to_int().to_byte()
    if b == (0).to_byte() {
      break
    }
    self.buf.push(b)
  }
  self.buf.push((0).to_byte())
}

fn BsonWriter::write_string(self : BsonWriter, s : String) -> Unit {
  let utf8_len = s.length()
  self.write_int32(utf8_len + 1)
  for i = 0; i < s.length(); i = i + 1 {
    self.buf.push(s[i].to_int().to_byte())
  }
  self.buf.push((0).to_byte())
}

fn BsonWriter::write_document(self : BsonWriter, map : Map[String, Value]) -> Result[Unit, String] {
  let start_pos = self.buf.length()
  self.write_int32(0)
  
  let mut err = None
  map.each(fn(k, v) {
    if err.is_none() {
      match self.write_element(k, v) {
        Ok(_) => ()
        Err(e) => err = Some(e)
      }
    }
  })
  
  if err.is_some() {
    return Err(err.unwrap())
  }
  
  self.write_byte((0).to_byte())
  
  let end_pos = self.buf.length()
  let size = end_pos - start_pos
  
  self.buf[start_pos] = (size & 0xFF).to_byte()
  self.buf[start_pos + 1] = ((size >> 8) & 0xFF).to_byte()
  self.buf[start_pos + 2] = ((size >> 16) & 0xFF).to_byte()
  self.buf[start_pos + 3] = ((size >> 24) & 0xFF).to_byte()
  
  Ok(())
}

fn BsonWriter::write_element(self : BsonWriter, name : String, val : Value) -> Result[Unit, String] {
  match val {
    Null => {
      self.write_byte((0x0A).to_byte())
      self.write_cstring(name)
    }
    BoolVal(b) => {
      self.write_byte((0x08).to_byte())
      self.write_cstring(name)
      self.write_byte(if b { (1).to_byte() } else { (0).to_byte() })
    }
    IntVal(i) => {
      self.write_byte((0x10).to_byte())
      self.write_cstring(name)
      self.write_int32(i)
    }
    DoubleVal(d) => {
      self.write_byte((0x01).to_byte())
      self.write_cstring(name)
      self.write_double(d)
    }
    StringVal(s) => {
      self.write_byte((0x02).to_byte())
      self.write_cstring(name)
      self.write_string(s)
    }
    ArrayVal(arr) => {
      self.write_byte((0x04).to_byte())
      self.write_cstring(name)
      let array_map = Map::new()
      for i = 0; i < arr.length(); i = i + 1 {
        array_map.set(i.to_string(), arr[i])
      }
      match self.write_document(array_map) {
        Ok(_) => ()
        Err(e) => return Err(e)
      }
    }
    ObjectVal(map) => {
      self.write_byte((0x03).to_byte())
      self.write_cstring(name)
      match self.write_document(map) {
        Ok(_) => ()
        Err(e) => return Err(e)
      }
    }
  }
  Ok(())
}

fn BsonWriter::to_bytes(self : BsonWriter) -> Array[Byte] {
  self.buf
}

struct BsonReader {
  buf : Array[Byte]
  mut pos : Int
}

fn BsonReader::new(bytes : Array[Byte]) -> BsonReader {
  { buf: bytes, pos: 0 }
}

fn BsonReader::read_byte(self : BsonReader) -> Result[Byte, String] {
  if self.pos >= self.buf.length() {
    return Err("BSON parse error: Unexpected EOF")
  }
  let b = self.buf[self.pos]
  self.pos = self.pos + 1
  Ok(b)
}

fn BsonReader::read_int32(self : BsonReader) -> Result[Int, String] {
  if self.pos + 4 > self.buf.length() {
    return Err("BSON parse error: Unexpected EOF reading int32")
  }
  let b0 = self.buf[self.pos].to_int()
  let b1 = self.buf[self.pos + 1].to_int()
  let b2 = self.buf[self.pos + 2].to_int()
  let b3 = self.buf[self.pos + 3].to_int()
  self.pos = self.pos + 4
  Ok(b0 | (b1 << 8) | (b2 << 16) | (b3 << 24))
}

fn BsonReader::read_int64(self : BsonReader) -> Result[Int64, String] {
  if self.pos + 8 > self.buf.length() {
    return Err("BSON parse error: Unexpected EOF reading int64")
  }
  let mut val = (0).to_int64()
  for i = 0; i < 8; i = i + 1 {
    let b = self.buf[self.pos + i].to_int64()
    val = val | (b << (i * 8))
  }
  self.pos = self.pos + 8
  Ok(val)
}

fn BsonReader::read_double(self : BsonReader) -> Result[Double, String] {
  match self.read_int64() {
    Ok(bits) => Ok(bits.reinterpret_as_uint64().reinterpret_as_double())
    Err(e) => Err(e)
  }
}

fn BsonReader::read_cstring(self : BsonReader) -> Result[String, String] {
  let builder = StringBuilder::new()
  let mut done = false
  while not(done) {
    match self.read_byte() {
      Ok(b) => {
        if b == (0).to_byte() {
          done = true
        } else {
          builder.write_char(Char::from_int(b.to_int()))
        }
      }
      Err(e) => return Err(e)
    }
  }
  Ok(builder.to_string())
}

fn BsonReader::read_string(self : BsonReader) -> Result[String, String] {
  match self.read_int32() {
    Ok(len) => {
      if len <= 0 {
        return Err("BSON parse error: Invalid string length")
      }
      let builder = StringBuilder::new()
      for i = 0; i < len - 1; i = i + 1 {
        match self.read_byte() {
          Ok(b) => builder.write_char(Char::from_int(b.to_int()))
          Err(e) => return Err(e)
        }
      }
      match self.read_byte() {
        Ok(b) => {
          if b != (0).to_byte() {
            return Err("BSON parse error: Missing string terminating null byte")
          }
        }
        Err(e) => return Err(e)
      }
      Ok(builder.to_string())
    }
    Err(e) => Err(e)
  }
}

fn BsonReader::read_document(self : BsonReader) -> Result[Map[String, Value], String] {
  match self.read_int32() {
    Ok(total_size) => {
      let start_pos = self.pos - 4
      if start_pos + total_size > self.buf.length() {
        return Err("BSON parse error: Document size overflows buffer")
      }
      let map = Map::new()
      let mut done = false
      while not(done) {
        match self.read_byte() {
          Ok(t) => {
            if t == (0).to_byte() {
              done = true
            } else {
              match self.read_cstring() {
                Ok(name) => {
                  match self.read_element_value(t) {
                    Ok(val) => {
                      map.set(name, val)
                    }
                    Err(e) => return Err(e)
                  }
                }
                Err(e) => return Err(e)
              }
            }
          }
          Err(e) => return Err(e)
        }
      }
      
      if self.pos != start_pos + total_size {
        return Err("BSON parse error: Read bytes do not match declared document size")
      }
      Ok(map)
    }
    Err(e) => Err(e)
  }
}

fn BsonReader::read_element_value(self : BsonReader, t : Byte) -> Result[Value, String] {
  let t_int = t.to_int()
  if t_int == 0x01 {
    match self.read_double() {
      Ok(d) => Ok(DoubleVal(d))
      Err(e) => Err(e)
    }
  } else if t_int == 0x02 {
    match self.read_string() {
      Ok(s) => Ok(StringVal(s))
      Err(e) => Err(e)
    }
  } else if t_int == 0x03 {
    match self.read_document() {
      Ok(m) => Ok(ObjectVal(m))
      Err(e) => Err(e)
    }
  } else if t_int == 0x04 {
    match self.read_document() {
      Ok(m) => {
        let arr = []
        let mut i = 0
        let mut has_items = true
        while has_items {
          match m.get(i.to_string()) {
            Some(val) => {
              arr.push(val)
              i = i + 1
            }
            None => {
              has_items = false
            }
          }
        }
        Ok(ArrayVal(arr))
      }
      Err(e) => Err(e)
    }
  } else if t_int == 0x08 {
    match self.read_byte() {
      Ok(b) => Ok(BoolVal(b != (0).to_byte()))
      Err(e) => Err(e)
    }
  } else if t_int == 0x0A {
    Ok(Null)
  } else if t_int == 0x10 {
    match self.read_int32() {
      Ok(i) => Ok(IntVal(i))
      Err(e) => Err(e)
    }
  } else if t_int == 0x12 {
    match self.read_int64() {
      Ok(i64) => Ok(IntVal(i64.to_int()))
      Err(e) => Err(e)
    }
  } else {
    Err("BSON parse error: Unsupported element type: " + t_int.to_string())
  }
}
