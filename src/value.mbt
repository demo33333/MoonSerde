pub enum Value {
  Null
  BoolVal(Bool)
  IntVal(Int)
  DoubleVal(Double)
  StringVal(String)
  ArrayVal(Array[Value])
  ObjectVal(Map[String, Value])
} derive(Debug, Eq)
