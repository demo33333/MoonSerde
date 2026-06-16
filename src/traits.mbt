pub trait Serialize {
  to_value(Self) -> Value
}

pub trait Deserialize {
  from_value(Value) -> Result[Self, String]
}
