test "serialize basic types" {
  let i = 42
  let s = "hello"
  
  let val_i = Serialize::to_value(i)
  assert_eq(to_json(val_i), "42")

  let val_s = Serialize::to_value(s)
  assert_eq(to_json(val_s), "\\u0022hello\\u0022")
}

test "serialize array" {
  let arr = [1, 2, 3]
  let val = Serialize::to_value(arr)
  assert_eq(to_json(val), "[1,2,3]")
}

test "serialize map" {
  let map = Map::new()
  map.set("key", "value")
  let val = Serialize::to_value(map)
  assert_eq(to_json(val), "{\\u0022key\\u0022:\\u0022value\\u0022}")
}
