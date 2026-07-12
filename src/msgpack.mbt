// MessagePack implementation for MoonSerde

pub fn to_msgpack(v : Value) -> Array[Byte] {
  let buf = []
  pack_value(buf, v)
  buf
}

pub fn from_msgpack(bytes : Array[Byte]) -> Result[Value, String] {
  let reader = { bytes, pos: 0 }
  unpack_value(reader)
}

struct MessagePackReader {
  bytes : Array[Byte]
  mut pos : Int
}

fn pack_value(buf : Array[Byte], v : Value) -> Unit {
  match v {
    Null => buf.push((0xC0).to_byte())
    BoolVal(b) => if b { buf.push((0xC3).to_byte()) } else { buf.push((0xC2).to_byte()) }
    IntVal(i) => pack_int(buf, i)
    DoubleVal(d) => pack_double(buf, d)
    StringVal(s) => pack_string(buf, s)
    ArrayVal(arr) => pack_array(buf, arr)
    ObjectVal(map) => pack_map(buf, map)
  }
}

fn pack_int(buf : Array[Byte], i : Int) -> Unit {
  if i >= 0 && i <= 127 {
    buf.push(i.to_byte())
  } else if i < 0 && i >= -32 {
    let b = 0xE0 + (i + 32)
    buf.push(b.to_byte())
  } else if i >= 0 && i <= 255 {
    buf.push((0xCC).to_byte())
    buf.push(i.to_byte())
  } else if i >= -128 && i <= 127 {
    buf.push((0xD0).to_byte())
    buf.push(i.to_byte())
  } else if i >= 0 && i <= 65535 {
    buf.push((0xCD).to_byte())
    buf.push(((i >> 8) & 0xFF).to_byte())
    buf.push((i & 0xFF).to_byte())
  } else if i >= -32768 && i <= 32767 {
    buf.push((0xD1).to_byte())
    buf.push(((i >> 8) & 0xFF).to_byte())
    buf.push((i & 0xFF).to_byte())
  } else {
    // 32-bit int
    buf.push((0xD2).to_byte())
    buf.push(((i >> 24) & 0xFF).to_byte())
    buf.push(((i >> 16) & 0xFF).to_byte())
    buf.push(((i >> 8) & 0xFF).to_byte())
    buf.push((i & 0xFF).to_byte())
  }
}

fn pack_double(buf : Array[Byte], d : Double) -> Unit {
  buf.push((0xCB).to_byte())
  let bits = d.reinterpret_as_uint64().to_int64()
  buf.push((((bits >> 56) & 0xFF).to_int()).to_byte())
  buf.push((((bits >> 48) & 0xFF).to_int()).to_byte())
  buf.push((((bits >> 40) & 0xFF).to_int()).to_byte())
  buf.push((((bits >> 32) & 0xFF).to_int()).to_byte())
  buf.push((((bits >> 24) & 0xFF).to_int()).to_byte())
  buf.push((((bits >> 16) & 0xFF).to_int()).to_byte())
  buf.push((((bits >> 8) & 0xFF).to_int()).to_byte())
  buf.push(((bits & 0xFF).to_int()).to_byte())
}

fn pack_string(buf : Array[Byte], s : String) -> Unit {
  let bytes = []
  for i = 0; i < s.length(); i = i + 1 {
    let c = s[i].to_int()
    if c <= 0x7F {
      bytes.push(c.to_byte())
    } else if c <= 0x7FF {
      bytes.push(((0xC0 & (c >> 6))).to_byte())
      bytes.push(((0x80 & (c & 0x3F))).to_byte())
    } else {
      bytes.push(((0xE0 & (c >> 12))).to_byte())
      bytes.push(((0x80 & ((c >> 6) & 0x3F))).to_byte())
      bytes.push(((0x80 & (c & 0x3F))).to_byte())
    }
  }
  
  let len = bytes.length()
  if len <= 31 {
    let b = 0xA0 + len
    buf.push(b.to_byte())
  } else if len <= 255 {
    buf.push((0xD9).to_byte())
    buf.push(len.to_byte())
  } else if len <= 65535 {
    buf.push((0xDA).to_byte())
    buf.push(((len >> 8) & 0xFF).to_byte())
    buf.push((len & 0xFF).to_byte())
  } else {
    buf.push((0xDB).to_byte())
    buf.push(((len >> 24) & 0xFF).to_byte())
    buf.push(((len >> 16) & 0xFF).to_byte())
    buf.push(((len >> 8) & 0xFF).to_byte())
    buf.push((len & 0xFF).to_byte())
  }
  
  for i = 0; i < len; i = i + 1 {
    buf.push(bytes[i])
  }
}

fn pack_array(buf : Array[Byte], arr : Array[Value]) -> Unit {
  let len = arr.length()
  if len <= 15 {
    let b = 0x90 + len
    buf.push(b.to_byte())
  } else if len <= 65535 {
    buf.push((0xDC).to_byte())
    buf.push(((len >> 8) & 0xFF).to_byte())
    buf.push((len & 0xFF).to_byte())
  } else {
    buf.push((0xDD).to_byte())
    buf.push(((len >> 24) & 0xFF).to_byte())
    buf.push(((len >> 16) & 0xFF).to_byte())
    buf.push(((len >> 8) & 0xFF).to_byte())
    buf.push((len & 0xFF).to_byte())
  }
  for i = 0; i < len; i = i + 1 {
    pack_value(buf, arr[i])
  }
}

fn pack_map(buf : Array[Byte], map : Map[String, Value]) -> Unit {
  let len = map.length()
  if len <= 15 {
    let b = 0x80 + len
    buf.push(b.to_byte())
  } else if len <= 65535 {
    buf.push((0xDE).to_byte())
    buf.push(((len >> 8) & 0xFF).to_byte())
    buf.push((len & 0xFF).to_byte())
  } else {
    buf.push((0xDF).to_byte())
    buf.push(((len >> 24) & 0xFF).to_byte())
    buf.push(((len >> 16) & 0xFF).to_byte())
    buf.push(((len >> 8) & 0xFF).to_byte())
    buf.push((len & 0xFF).to_byte())
  }
  map.each(fn(k, v) {
    pack_string(buf, k)
    pack_value(buf, v)
  })
}

fn unpack_value(r : MessagePackReader) -> Result[Value, String] {
  if r.pos >= r.bytes.length() {
    return Err("Unexpected end of MessagePack input")
  }
  let b = r.bytes[r.pos].to_int()
  r.pos = r.pos + 1
  
  if b <= 0x7F {
    Ok(IntVal(b))
  } else if b >= 0x80 && b <= 0x8F {
    let len = b - 0x80
    unpack_map(r, len)
  } else if b >= 0x90 && b <= 0x9F {
    let len = b - 0x90
    unpack_array(r, len)
  } else if b >= 0xA0 && b <= 0xBF {
    let len = b - 0xA0
    unpack_string(r, len)
  } else if b == 0xC0 {
    Ok(Null)
  } else if b == 0xC2 {
    Ok(BoolVal(false))
  } else if b == 0xC3 {
    Ok(BoolVal(true))
  } else if b == 0xCC {
    let val = read_u8(r)
    Ok(IntVal(val))
  } else if b == 0xCD {
    let val = read_u16(r)
    Ok(IntVal(val))
  } else if b == 0xCE {
    let val = read_u32(r)
    Ok(IntVal(val))
  } else if b == 0xD0 {
    let val = read_i8(r)
    Ok(IntVal(val))
  } else if b == 0xD1 {
    let val = read_i16(r)
    Ok(IntVal(val))
  } else if b == 0xD2 {
    let val = read_i32(r)
    Ok(IntVal(val))
  } else if b == 0xCB {
    let val = read_double(r)
    Ok(DoubleVal(val))
  } else if b == 0xD9 {
    let len = read_u8(r)
    unpack_string(r, len)
  } else if b == 0xDA {
    let len = read_u16(r)
    unpack_string(r, len)
  } else if b == 0xDB {
    let len = read_u32(r)
    unpack_string(r, len)
  } else if b == 0xDC {
    let len = read_u16(r)
    unpack_array(r, len)
  } else if b == 0xDD {
    let len = read_u32(r)
    unpack_array(r, len)
  } else if b == 0xDE {
    let len = read_u16(r)
    unpack_map(r, len)
  } else if b == 0xDF {
    let len = read_u32(r)
    unpack_map(r, len)
  } else if b >= 0xE0 && b <= 0xFF {
    let val = b - 0xE0 - 32
    Ok(IntVal(val))
  } else {
    Err("Unsupported MessagePack byte marker: " + b.to_string())
  }
}

fn read_u8(r : MessagePackReader) -> Int {
  if r.pos >= r.bytes.length() { 0 } else {
    let val = r.bytes[r.pos].to_int() & 0xFF
    r.pos = r.pos + 1
    val
  }
}

fn read_i8(r : MessagePackReader) -> Int {
  let val = read_u8(r)
  if val >= 128 { val - 256 } else { val }
}

fn read_u16(r : MessagePackReader) -> Int {
  let b1 = read_u8(r)
  let b2 = read_u8(r)
  (b1 << 8) + b2
}

fn read_i16(r : MessagePackReader) -> Int {
  let val = read_u16(r)
  if val >= 32768 { val - 65536 } else { val }
}

fn read_u32(r : MessagePackReader) -> Int {
  let b1 = read_u8(r)
  let b2 = read_u8(r)
  let b3 = read_u8(r)
  let b4 = read_u8(r)
  (b1 << 24) + (b2 << 16) + (b3 << 8) + b4
}

fn read_i32(r : MessagePackReader) -> Int {
  read_u32(r)
}

fn read_double(r : MessagePackReader) -> Double {
  let b1 = read_u8(r).to_int64()
  let b2 = read_u8(r).to_int64()
  let b3 = read_u8(r).to_int64()
  let b4 = read_u8(r).to_int64()
  let b5 = read_u8(r).to_int64()
  let b6 = read_u8(r).to_int64()
  let b7 = read_u8(r).to_int64()
  let b8 = read_u8(r).to_int64()
  
  let bits = (b1 << 56) + (b2 << 48) + (b3 << 40) + (b4 << 32) + (b5 << 24) + (b6 << 16) + (b7 << 8) + b8
  bits.to_uint64().reinterpret_as_double()
}

fn unpack_string(r : MessagePackReader, len : Int) -> Result[Value, String] {
  if r.pos + len > r.bytes.length() {
    return Err("String length exceeds input boundaries")
  }
  let builder = StringBuilder::new()
  let mut i = 0
  while i < len {
    let b1 = r.bytes[r.pos + i].to_int() & 0xFF
    if b1 <= 0x7F {
      builder.write_char(Char::from_int(b1))
      i = i + 1
    } else if (b1 >> 5) == 0x06 {
      if i + 1 >= len { return Err("Invalid UTF-8 sequence") }
      let b2 = r.bytes[r.pos + i + 1].to_int() & 0xFF
      let c = ((b1 & 0x1F) << 6) + (b2 & 0x3F)
      builder.write_char(Char::from_int(c))
      i = i + 2
    } else if (b1 >> 4) == 0x0E {
      if i + 2 >= len { return Err("Invalid UTF-8 sequence") }
      let b2 = r.bytes[r.pos + i + 1].to_int() & 0xFF
      let b3 = r.bytes[r.pos + i + 2].to_int() & 0xFF
      let c = ((b1 & 0x0F) << 12) + ((b2 & 0x3F) << 6) + (b3 & 0x3F)
      builder.write_char(Char::from_int(c))
      i = i + 3
    } else {
      return Err("Unsupported multi-byte UTF-8 sequence")
    }
  }
  r.pos = r.pos + len
  Ok(StringVal(builder.to_string()))
}

fn unpack_array(r : MessagePackReader, len : Int) -> Result[Value, String] {
  let arr = []
  for i = 0; i < len; i = i + 1 {
    match unpack_value(r) {
      Ok(v) => arr.push(v)
      Err(e) => return Err(e)
    }
  }
  Ok(ArrayVal(arr))
}

fn unpack_map(r : MessagePackReader, len : Int) -> Result[Value, String] {
  let map = Map::new()
  for i = 0; i < len; i = i + 1 {
    match unpack_value(r) {
      Ok(StringVal(k)) => {
        match unpack_value(r) {
          Ok(v) => map.set(k, v)
          Err(e) => return Err(e)
        }
      }
      Ok(_) => return Err("Map keys must be String type")
      Err(e) => return Err(e)
    }
  }
  Ok(ObjectVal(map))
}
