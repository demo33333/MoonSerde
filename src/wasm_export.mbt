// FFI Imports to write string back to JS
fn js_output_start() = "env" "output_start"
fn js_output_char(c : Int) = "env" "output_char"
fn js_output_end() = "env" "output_end"

fn write_json_to_js(val : Value) -> Unit {
  js_output_start()
  let json_str = to_json(val)
  for i = 0; i < json_str.length(); i = i + 1 {
    js_output_char(json_str[i].to_int())
  }
  js_output_end()
}

pub fn demo_serialize_primitive() -> Unit {
  let val = Serialize::to_value("Hello, MoonSerde Wasm Playground!")
  write_json_to_js(val)
}

pub fn demo_serialize_array() -> Unit {
  let arr = [1, 2, 3, 4, 5, 42, 100]
  let val = Serialize::to_value(arr)
  write_json_to_js(val)
}

pub fn demo_serialize_map() -> Unit {
  let map = Map::new()
  map.set("project", "MoonSerde")
  map.set("language", "MoonBit")
  map.set("status", "Active")
  let val = Serialize::to_value(map)
  write_json_to_js(val)
}

pub fn demo_serialize_nested() -> Unit {
  let map = Map::new()
  map.set("version", StringVal("1.0"))
  map.set("data", StringVal("metrics"))
  
  let arr = ArrayVal([DoubleVal(1.5), DoubleVal(2.5), DoubleVal(3.14159)])
  
  let root = Map::new()
  root.set("metadata", ObjectVal(map))
  root.set("points", arr)
  root.set("is_valid", BoolVal(true))
  
  let val = ObjectVal(root)
  write_json_to_js(val)
}

fn main { }
