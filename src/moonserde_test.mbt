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

test "msgpack basic roundtrip" {
  let map = Map::new()
  map.set("name", Value::StringVal("MoonSerde"))
  map.set("version", Value::IntVal(1))
  map.set("is_fast", Value::BoolVal(true))
  
  let val = Value::ObjectVal(map)
  let bytes = to_msgpack(val)
  
  match from_msgpack(bytes) {
    Ok(v) => {
      match v {
        Value::ObjectVal(m) => {
          assert_eq(m.get("name"), Some(Value::StringVal("MoonSerde")))
          assert_eq(m.get("version"), Some(Value::IntVal(1)))
          assert_eq(m.get("is_fast"), Some(Value::BoolVal(true)))
        }
        _ => fail("Expected ObjectVal")
      }
    }
    Err(e) => fail(e)
  }
}

test "json schema validation" {
  // Define Schema
  let prop_name = Map::new()
  prop_name.set("type", Value::StringVal("string"))
  prop_name.set("minLength", Value::IntVal(3))
  
  let prop_age = Map::new()
  prop_age.set("type", Value::StringVal("integer"))
  prop_age.set("minimum", Value::IntVal(0))
  
  let properties = Map::new()
  properties.set("name", Value::ObjectVal(prop_name))
  properties.set("age", Value::ObjectVal(prop_age))
  
  let schema_map = Map::new()
  schema_map.set("type", Value::StringVal("object"))
  schema_map.set("properties", Value::ObjectVal(properties))
  schema_map.set("required", Value::ArrayVal([Value::StringVal("name")]))
  
  let schema_val = Value::ObjectVal(schema_map)
  
  match parse_schema(schema_val) {
    Ok(schema) => {
      // 1. Valid instance
      let user = Map::new()
      user.set("name", Value::StringVal("Agent"))
      user.set("age", Value::IntVal(25))
      assert_eq(validate(schema, Value::ObjectVal(user)), Ok(()))
      
      // 2. Missing required
      let user_bad = Map::new()
      user_bad.set("age", Value::IntVal(25))
      assert_eq(validate(schema, Value::ObjectVal(user_bad)), Err("Missing required property: name"))
      
      // 3. String too short
      let user_short = Map::new()
      user_short.set("name", Value::StringVal("Ab"))
      user_short.set("age", Value::IntVal(25))
      assert_eq(validate(schema, Value::ObjectVal(user_short)), Err("In property \"name\": String length 2 is less than minLength 3"))
    }
    Err(e) => fail(e)
  }
}

test "xml parse and serialize" {
  let xml_str = "<user id=\"1\"><name>Alice</name><role>Admin</role></user>"
  match parse_xml(xml_str) {
    Ok(node) => {
      match node {
        Element(tag, attrs, _) => {
          assert_eq(tag, "user")
          assert_eq(attrs.get("id"), Some("1"))
        }
        _ => fail("Expected Element")
      }
      
      let val = xml_to_value(node)
      match val {
        Value::ObjectVal(m) => {
          assert_eq(m.get("@id"), Some(Value::StringVal("1")))
          assert_eq(m.get("name"), Some(Value::StringVal("Alice")))
          assert_eq(m.get("role"), Some(Value::StringVal("Admin")))
        }
        _ => fail("Expected ObjectVal")
      }
    }
    Err(e) => fail(e)
  }
}

test "yaml parse and serialize" {
  let yaml_str = 
    #|name: MoonSerde
    #|version: 1
    #|features:
    #|  - json
    #|  - yaml
    #|  - xml
  
  match parse_yaml(yaml_str) {
    Ok(val) => {
      match val {
        Value::ObjectVal(m) => {
          assert_eq(m.get("name"), Some(Value::StringVal("MoonSerde")))
          assert_eq(m.get("version"), Some(Value::IntVal(1)))
          match m.get("features") {
            Some(Value::ArrayVal(arr)) => {
              assert_eq(arr.length(), 3)
              assert_eq(arr[0], Value::StringVal("json"))
              assert_eq(arr[1], Value::StringVal("yaml"))
              assert_eq(arr[2], Value::StringVal("xml"))
            }
            _ => fail("Expected ArrayVal for features")
          }
        }
        _ => fail("Expected ObjectVal")
      }
      
      let serialized = to_yaml_string(val)
      assert_eq(serialized.contains("name: MoonSerde"), true)
      assert_eq(serialized.contains("- json"), true)
    }
    Err(e) => fail(e)
  }
}

test "toml parse and serialize" {
  let toml_str =
    #|title = "TOML Example"
    #|
    #|[database]
    #|server = "192.168.1.1"
    #|ports = [ 8000, 8001, 8002 ]
    #|connection_max = 5000
    #|enabled = true
  
  match parse_toml(toml_str) {
    Ok(val) => {
      match val {
        Value::ObjectVal(m) => {
          assert_eq(m.get("title"), Some(Value::StringVal("TOML Example")))
          match m.get("database") {
            Some(Value::ObjectVal(db)) => {
              assert_eq(db.get("server"), Some(Value::StringVal("192.168.1.1")))
              assert_eq(db.get("connection_max"), Some(Value::IntVal(5000)))
              assert_eq(db.get("enabled"), Some(Value::BoolVal(true)))
            }
            _ => fail("Expected ObjectVal for database")
          }
        }
        _ => fail("Expected ObjectVal")
      }
      
      match to_toml_string(val) {
        Ok(serialized) => {
          assert_eq(serialized.contains("title = \"TOML Example\""), true)
          assert_eq(serialized.contains("server = \"192.168.1.1\""), true)
        }
        Err(e) => fail(e)
      }
    }
    Err(e) => fail(e)
  }
}

test "expanded trait implementations" {
  // Option
  let o_some : Option[Int] = Some(10)
  let o_none : Option[Int] = None
  
  assert_eq(to_json(Serialize::to_value(o_some)), "10")
  assert_eq(to_json(Serialize::to_value(o_none)), "null")
  
  // Tuple
  let tuple2 = (42, "hello")
  let val_t2 = Serialize::to_value(tuple2)
  assert_eq(to_json(val_t2), "[42,\\u0022hello\\u0022]")
}
