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
