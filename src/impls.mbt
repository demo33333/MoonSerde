// Int
pub impl Serialize for Int with to_value(self) {
  IntVal(self)
}

pub impl Deserialize for Int with from_value(value) {
  match value {
    IntVal(i) => Ok(i)
    _ => Err("Expected Int")
  }
}

// Double
pub impl Serialize for Double with to_value(self) {
  DoubleVal(self)
}

pub impl Deserialize for Double with from_value(value) {
  match value {
    DoubleVal(d) => Ok(d)
    _ => Err("Expected Double")
  }
}

// String
pub impl Serialize for String with to_value(self) {
  StringVal(self)
}

pub impl Deserialize for String with from_value(value) {
  match value {
    StringVal(s) => Ok(s)
    _ => Err("Expected String")
  }
}

// Bool
pub impl Serialize for Bool with to_value(self) {
  BoolVal(self)
}

pub impl Deserialize for Bool with from_value(value) {
  match value {
    BoolVal(b) => Ok(b)
    _ => Err("Expected Bool")
  }
}

// Array
pub impl[T : Serialize] Serialize for Array[T] with to_value(self) {
  let arr = []
  for i = 0; i < self.length(); i = i + 1 {
    arr.push(self[i].to_value())
  }
  ArrayVal(arr)
}

pub impl[T : Deserialize] Deserialize for Array[T] with from_value(value) {
  match value {
    ArrayVal(arr) => {
      let res = []
      for i = 0; i < arr.length(); i = i + 1 {
        match T::from_value(arr[i]) {
          Ok(v) => res.push(v)
          Err(e) => return Err(e)
        }
      }
      Ok(res)
    }
    _ => Err("Expected Array")
  }
}

// Map
pub impl[T : Serialize] Serialize for Map[String, T] with to_value(self) {
  let map = Map::new()
  self.each(fn(k, v) {
    map.set(k, v.to_value())
  })
  ObjectVal(map)
}

pub impl[T : Deserialize] Deserialize for Map[String, T] with from_value(value) {
  match value {
    ObjectVal(map) => {
      let res = Map::new()
      let mut err = None
      map.each(fn(k, v) {
        match err {
          None => match T::from_value(v) {
            Ok(val) => res.set(k, val)
            Err(e) => err = Some(e)
          }
          Some(_) => ()
        }
      })
      match err {
        Some(e) => Err(e)
        None => Ok(res)
      }
    }
    _ => Err("Expected Object")
  }
}

// Unit
pub impl Serialize for Unit with to_value(self) {
  Null
}

pub impl Deserialize for Unit with from_value(value) {
  match value {
    Null => Ok(())
    _ => Err("Expected Null for Unit")
  }
}

// Int64
pub impl Serialize for Int64 with to_value(self) {
  IntVal(self.to_int())
}

pub impl Deserialize for Int64 with from_value(value) {
  match value {
    IntVal(i) => Ok(i.to_int64())
    _ => Err("Expected Int64")
  }
}

// Char
pub impl Serialize for Char with to_value(self) {
  StringVal(self.to_string())
}

pub impl Deserialize for Char with from_value(value) {
  match value {
    StringVal(s) => {
      if s.length() == 1 {
        Ok(Char::from_int(s[0].to_int()))
      } else {
        Err("Expected single character String")
      }
    }
    _ => Err("Expected Char")
  }
}

// Byte
pub impl Serialize for Byte with to_value(self) {
  IntVal(self.to_int())
}

pub impl Deserialize for Byte with from_value(value) {
  match value {
    IntVal(i) => Ok(i.to_byte())
    _ => Err("Expected Byte")
  }
}

// Option
pub impl[T : Serialize] Serialize for Option[T] with to_value(self) {
  match self {
    None => Null
    Some(v) => v.to_value()
  }
}

pub impl[T : Deserialize] Deserialize for Option[T] with from_value(value) {
  match value {
    Null => Ok(None)
    v => match T::from_value(v) {
      Ok(val) => Ok(Some(val))
      Err(e) => Err(e)
    }
  }
}

// Result
pub impl[T : Serialize, E : Serialize] Serialize for Result[T, E] with to_value(self) {
  let map = Map::new()
  match self {
    Ok(v) => {
      map.set("Ok", v.to_value())
      ObjectVal(map)
    }
    Err(e) => {
      map.set("Err", e.to_value())
      ObjectVal(map)
    }
  }
}

pub impl[T : Deserialize, E : Deserialize] Deserialize for Result[T, E] with from_value(value) {
  match value {
    ObjectVal(map) => {
      match map.get("Ok") {
        Some(v) => match T::from_value(v) {
          Ok(val) => Ok(Ok(val))
          Err(err) => Err(err)
        }
        None => match map.get("Err") {
          Some(v) => match E::from_value(v) {
            Ok(err) => Ok(Err(err))
            Err(e) => Err(e)
          }
          None => Err("Expected Ok or Err field in Result")
        }
      }
    }
    _ => Err("Expected Object for Result")
  }
}

// Tuple 2
pub impl[T1 : Serialize, T2 : Serialize] Serialize for (T1, T2) with to_value(self) {
  ArrayVal([self.0.to_value(), self.1.to_value()])
}

pub impl[T1 : Deserialize, T2 : Deserialize] Deserialize for (T1, T2) with from_value(value) {
  match value {
    ArrayVal(arr) => {
      if arr.length() == 2 {
        match (T1::from_value(arr[0]), T2::from_value(arr[1])) {
          (Ok(v1), Ok(v2)) => Ok((v1, v2))
          (Err(e), _) => Err(e)
          (_, Err(e)) => Err(e)
        }
      } else {
        Err("Expected array of length 2 for Tuple2")
      }
    }
    _ => Err("Expected Array for Tuple2")
  }
}

// Tuple 3
pub impl[T1 : Serialize, T2 : Serialize, T3 : Serialize] Serialize for (T1, T2, T3) with to_value(self) {
  ArrayVal([self.0.to_value(), self.1.to_value(), self.2.to_value()])
}

pub impl[T1 : Deserialize, T2 : Deserialize, T3 : Deserialize] Deserialize for (T1, T2, T3) with from_value(value) {
  match value {
    ArrayVal(arr) => {
      if arr.length() == 3 {
        match (T1::from_value(arr[0]), T2::from_value(arr[1]), T3::from_value(arr[2])) {
          (Ok(v1), Ok(v2), Ok(v3)) => Ok((v1, v2, v3))
          (Err(e), _, _) => Err(e)
          (_, Err(e), _) => Err(e)
          (_, _, Err(e)) => Err(e)
        }
      } else {
        Err("Expected array of length 3 for Tuple3")
      }
    }
    _ => Err("Expected Array for Tuple3")
  }
}

// Tuple 4
pub impl[T1 : Serialize, T2 : Serialize, T3 : Serialize, T4 : Serialize] Serialize for (T1, T2, T3, T4) with to_value(self) {
  ArrayVal([self.0.to_value(), self.1.to_value(), self.2.to_value(), self.3.to_value()])
}

pub impl[T1 : Deserialize, T2 : Deserialize, T3 : Deserialize, T4 : Deserialize] Deserialize for (T1, T2, T3, T4) with from_value(value) {
  match value {
    ArrayVal(arr) => {
      if arr.length() == 4 {
        match (T1::from_value(arr[0]), T2::from_value(arr[1]), T3::from_value(arr[2]), T4::from_value(arr[3])) {
          (Ok(v1), Ok(v2), Ok(v3), Ok(v4)) => Ok((v1, v2, v3, v4))
          (Err(e), _, _, _) => Err(e)
          (_, Err(e), _, _) => Err(e)
          (_, _, Err(e), _) => Err(e)
          (_, _, _, Err(e)) => Err(e)
        }
      } else {
        Err("Expected array of length 4 for Tuple4")
      }
    }
    _ => Err("Expected Array for Tuple4")
  }
}
