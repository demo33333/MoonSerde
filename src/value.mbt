/// Represents a JSON value in MoonSerde.
/// Supports null, booleans, numbers, strings, arrays and objects.
/// Derive Debug and Eq for debugging and comparisons.
pub(all) enum Value {
  Null
  BoolVal(Bool)
  IntVal(Int)
  DoubleVal(Double)
  StringVal(String)
  ArrayVal(Array[Value])
  ObjectVal(Map[String, Value])
} derive(Debug, Eq)

pub impl Show for Value with output(self, logger) {
  logger.write_string(to_json(self))
}




fn sub_string(s : String, start : Int, end : Int) -> String {
  s[start:end].to_string()
}

fn sub_string_view(s : StringView, start : Int, end : Int) -> String {
  s[start:end].to_string()
}
