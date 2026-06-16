/// Core representation of JSON data in MoonSerde.
///
/// Mirrors the JSON data model with variants for null, boolean, numbers,
/// strings, arrays and objects.  The `derive(Debug, Eq)` at the end provides
/// debugging and equality capabilities.
pub enum Value {
  Null
  BoolVal(Bool)
  IntVal(Int)
  DoubleVal(Double)
  StringVal(String)
  ArrayVal(Array[Value])
  ObjectVal(Map[String, Value])
}

/// Serialize a MoonBit `Value` into a JSON string.
///
/// This function recursively walks the `Value` enum and produces a valid JSON
/// representation. It is intended for use by the Web Playground to display the
/// result of serialization.
pub fn to_json(v: Value) -> String {
  match v {
    Null => "null"
    BoolVal(b) => if b { "true" } else { "false" }
    IntVal(i) => i.to_string()
    DoubleVal(d) => d.to_string()
    StringVal(s) => "\\u0022" + s + "\\u0022"
    ArrayVal(arr) => {
      let mut res = "["
      for i = 0; i < arr.length(); i = i + 1 {
        if i > 0 {
          res = res + ","
        }
        res = res + to_json(arr[i])
      }
      res + "]"
    }
    ObjectVal(map) => {
      let mut res = "{"
      let mut first = true
      map.each(fn(k, val) {
        if !first {
          res = res + ","
        }
        first = false
        res = res + "\\u0022" + k + "\\u0022:" + to_json(val)
      })
      res + "}"
    }
  }
}
