# MoonSerde

MoonSerde is a lightweight data serialization and deserialization tool for MoonBit.

It provides a unified abstraction for converting MoonBit data structures to and from format-independent representations (`Value`). Currently, it includes a JSON stringifier.

## Usage

```moonbit
let i = 42
let val_i = Serialize::to_value(i)
let json_str = to_json(val_i)
println(json_str) // "42"

let map = Map::new()
map.set("key", "value")
let val_map = Serialize::to_value(map)
println(to_json(val_map)) // {"key":"value"}
```

## Features
- Unified `Value` enum.
- `Serialize` and `Deserialize` traits for builtin Moonbit types.
- Lightweight JSON stringifier.
