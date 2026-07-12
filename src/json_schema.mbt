// JSON Schema Validator engine in MoonBit

pub struct Schema {
  types : Array[String]
  properties : Map[String, Schema]
  required : Array[String]
  minimum : Option[Double]
  maximum : Option[Double]
  min_length : Option[Int]
  max_length : Option[Int]
  min_items : Option[Int]
  max_items : Option[Int]
  items : Option[Schema]
  any_of : Array[Schema]
  all_of : Array[Schema]
  one_of : Array[Schema]
  not_schema : Option[Schema]
}

pub fn parse_schema(val : Value) -> Result[Schema, String] {
  match val {
    ObjectVal(map) => {
      let types = match map.get("type") {
        Some(StringVal(s)) => [s]
        Some(ArrayVal(arr)) => {
          let t_arr = []
          for i = 0; i < arr.length(); i = i + 1 {
            match arr[i] {
              StringVal(s) => t_arr.push(s)
              _ => return Err("Schema type array must contain only strings")
            }
          }
          t_arr
        }
        _ => []
      }
      
      let properties = Map::new()
      match map.get("properties") {
        Some(ObjectVal(p_map)) => {
          let mut err = None
          p_map.each(fn(k, v) {
            match err {
              None => match parse_schema(v) {
                Ok(s) => properties.set(k, s)
                Err(e) => err = Some(e)
              }
              Some(_) => ()
            }
          })
          match err {
            Some(e) => return Err(e)
            None => ()
          }
        }
        _ => ()
      }
      
      let required = match map.get("required") {
        Some(ArrayVal(arr)) => {
          let req_arr = []
          for i = 0; i < arr.length(); i = i + 1 {
            match arr[i] {
              StringVal(s) => req_arr.push(s)
              _ => return Err("Schema required property must be an array of strings")
            }
          }
          req_arr
        }
        _ => []
      }
      
      let minimum = match map.get("minimum") {
        Some(DoubleVal(d)) => Some(d)
        Some(IntVal(i)) => Some(i.to_double())
        _ => None
      }
      
      let maximum = match map.get("maximum") {
        Some(DoubleVal(d)) => Some(d)
        Some(IntVal(i)) => Some(i.to_double())
        _ => None
      }
      
      let min_length = match map.get("minLength") {
        Some(IntVal(i)) => Some(i)
        _ => None
      }
      
      let max_length = match map.get("maxLength") {
        Some(IntVal(i)) => Some(i)
        _ => None
      }
      
      let min_items = match map.get("minItems") {
        Some(IntVal(i)) => Some(i)
        _ => None
      }
      
      let max_items = match map.get("maxItems") {
        Some(IntVal(i)) => Some(i)
        _ => None
      }
      
      let items = match map.get("items") {
        Some(v) => match parse_schema(v) {
          Ok(s) => Some(s)
          Err(e) => return Err(e)
        }
        None => None
      }
      
      let any_of = match map.get("anyOf") {
        Some(ArrayVal(arr)) => {
          let list = []
          for i = 0; i < arr.length(); i = i + 1 {
            match parse_schema(arr[i]) {
              Ok(s) => list.push(s)
              Err(e) => return Err(e)
            }
          }
          list
        }
        _ => []
      }
      
      let all_of = match map.get("allOf") {
        Some(ArrayVal(arr)) => {
          let list = []
          for i = 0; i < arr.length(); i = i + 1 {
            match parse_schema(arr[i]) {
              Ok(s) => list.push(s)
              Err(e) => return Err(e)
            }
          }
          list
        }
        _ => []
      }
      
      let one_of = match map.get("oneOf") {
        Some(ArrayVal(arr)) => {
          let list = []
          for i = 0; i < arr.length(); i = i + 1 {
            match parse_schema(arr[i]) {
              Ok(s) => list.push(s)
              Err(e) => return Err(e)
            }
          }
          list
        }
        _ => []
      }
      
      let not_schema = match map.get("not") {
        Some(v) => match parse_schema(v) {
          Ok(s) => Some(s)
          Err(e) => return Err(e)
        }
        None => None
      }
      
      Ok({
        types,
        properties,
        required,
        minimum,
        maximum,
        min_length,
        max_length,
        min_items,
        max_items,
        items,
        any_of,
        all_of,
        one_of,
        not_schema
      })
    }
    _ => Err("Schema definition must be a JSON object")
  }
}

pub fn validate(schema : Schema, val : Value) -> Result[Unit, String] {
  // 1. Type validation
  if schema.types.length() > 0 {
    let mut type_ok = false
    let val_type = get_value_type(val)
    for i = 0; i < schema.types.length(); i = i + 1 {
      let t = schema.types[i]
      if t == val_type {
        type_ok = true
        break
      }
      // "number" type matches both "integer" and "number" in JSON Schema
      if t == "number" && (val_type == "integer" || val_type == "number") {
        type_ok = true
        break
      }
    }
    if !type_ok {
      return Err("Value type mismatch: expected one of " + type_array_to_string(schema.types) + ", got " + val_type)
    }
  }
  
  // 2. Numeric validation
  match val {
    IntVal(i) => {
      let d = i.to_double()
      match schema.minimum {
        Some(min) => if d < min { return Err("Value " + i.to_string() + " is less than minimum " + min.to_string()) }
        None => ()
      }
      match schema.maximum {
        Some(max) => if d > max { return Err("Value " + i.to_string() + " is greater than maximum " + max.to_string()) }
        None => ()
      }
    }
    DoubleVal(d) => {
      match schema.minimum {
        Some(min) => if d < min { return Err("Value " + d.to_string() + " is less than minimum " + min.to_string()) }
        None => ()
      }
      match schema.maximum {
        Some(max) => if d > max { return Err("Value " + d.to_string() + " is greater than maximum " + max.to_string()) }
        None => ()
      }
    }
    _ => ()
  }
  
  // 3. String validation
  match val {
    StringVal(s) => {
      let len = s.length()
      match schema.min_length {
        Some(min) => if len < min { return Err("String length " + len.to_string() + " is less than minLength " + min.to_string()) }
        None => ()
      }
      match schema.max_length {
        Some(max) => if len > max { return Err("String length " + len.to_string() + " exceeds maxLength " + max.to_string()) }
        None => ()
      }
    }
    _ => ()
  }
  
  // 4. Array validation
  match val {
    ArrayVal(arr) => {
      let len = arr.length()
      match schema.min_items {
        Some(min) => if len < min { return Err("Array items count " + len.to_string() + " is less than minItems " + min.to_string()) }
        None => ()
      }
      match schema.max_items {
        Some(max) => if len > max { return Err("Array items count " + len.to_string() + " exceeds maxItems " + max.to_string()) }
        None => ()
      }
      match schema.items {
        Some(item_schema) => {
          for i = 0; i < len; i = i + 1 {
            match validate(item_schema, arr[i]) {
              Ok(_) => ()
              Err(e) => return Err("At index " + i.to_string() + ": " + e)
            }
          }
        }
        None => ()
      }
    }
    _ => ()
  }
  
  // 5. Object validation
  match val {
    ObjectVal(map) => {
      // Required properties check
      for i = 0; i < schema.required.length(); i = i + 1 {
        let req = schema.required[i]
        match map.get(req) {
          None => return Err("Missing required property: " + req)
          Some(_) => ()
        }
      }
      
      // Properties validation
      let mut err = None
      schema.properties.each(fn(k, s) {
        match err {
          None => match map.get(k) {
            Some(v) => match validate(s, v) {
              Ok(_) => ()
              Err(e) => err = Some("In property \"" + k + "\": " + e)
            }
            None => ()
          }
          Some(_) => ()
        }
      })
      match err {
        Some(e) => return Err(e)
        None => ()
      }
    }
    _ => ()
  }
  
  // 6. Schema Combinators: anyOf
  if schema.any_of.length() > 0 {
    let mut any_ok = false
    for i = 0; i < schema.any_of.length(); i = i + 1 {
      match validate(schema.any_of[i], val) {
        Ok(_) => {
          any_ok = true
          break
        }
        Err(_) => ()
      }
    }
    if !any_ok {
      return Err("Value does not match any of the permitted subschemas")
    }
  }
  
  // 7. Schema Combinators: allOf
  if schema.all_of.length() > 0 {
    for i = 0; i < schema.all_of.length(); i = i + 1 {
      match validate(schema.all_of[i], val) {
        Ok(_) => ()
        Err(e) => return Err("Validation failed for allOf subschema index " + i.to_string() + ": " + e)
      }
    }
  }
  
  // 8. Schema Combinators: oneOf
  if schema.one_of.length() > 0 {
    let mut match_count = 0
    for i = 0; i < schema.one_of.length(); i = i + 1 {
      match validate(schema.one_of[i], val) {
        Ok(_) => match_count = match_count + 1
        Err(_) => ()
      }
    }
    if match_count == 0 {
      return Err("Value does not validate against any of the oneOf subschemas")
    } else if match_count > 1 {
      return Err("Value validates against more than one of the oneOf subschemas (count: " + match_count.to_string() + ")")
    }
  }
  
  // 9. Schema Combinators: not
  match schema.not_schema {
    Some(ns) => match validate(ns, val) {
      Ok(_) => return Err("Value must not validate against the subschema definition")
      Err(_) => ()
    }
    None => ()
  }
  
  Ok(())
}

fn get_value_type(val : Value) -> String {
  match val {
    Null => "null"
    BoolVal(_) => "boolean"
    IntVal(_) => "integer"
    DoubleVal(_) => "number"
    StringVal(_) => "string"
    ArrayVal(_) => "array"
    ObjectVal(_) => "object"
  }
}

fn type_array_to_string(arr : Array[String]) -> String {
  let builder = StringBuilder::new()
  builder.write_string("[")
  for i = 0; i < arr.length(); i = i + 1 {
    if i > 0 {
      builder.write_string(", ")
    }
    builder.write_string(arr[i])
  }
  builder.write_string("]")
  builder.to_string()
}
