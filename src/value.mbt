/// Represents a JSON value in MoonSerde.
/// Supports null, booleans, numbers, strings, arrays and objects.
/// Derive Debug and Eq for debugging and comparisons.
pub enum Value {
  Null
  BoolVal(Bool)
  IntVal(Int)
  DoubleVal(Double)
  StringVal(String)
  ArrayVal(Array[Value])
  ObjectVal(Map[String, Value])
} derive(Debug, Eq)
