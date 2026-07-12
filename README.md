# MoonSerde

MoonSerde 是一个为 MoonBit 语言设计的高性能、多格式、通用的数据序列化与反序列化框架。它提供了统一的中间值抽象（`Value` AST），支持与多种数据交换格式（JSON、MessagePack、XML、YAML、TOML、BSON、Form URL-Encoded）之间的相互转换，并内置了完备的 JSON Schema 校验和 JSON Pointer 查询引擎。

## 🎯 项目目标 (Project Goals)

MoonSerde 旨在成为 MoonBit 生态中最强大且易用的数据处理基石：
1. **多格式互通**：打破格式壁垒，一套 `Value` 抽象同时支持 JSON、MessagePack & BSON 二进制、XML 标签树、YAML 缩进语法、TOML 配置格式以及 URL-Encoded 表单。
2. **易用的 Trait 系统**：提供类似 Rust serde 的 `Serialize` 与 `Deserialize` 特征，轻松实现原生 MoonBit 类型与通用 `Value` AST 之间的映射。
3. **健壮的安全校验**：集成高性能的 JSON Schema 验证器，支持嵌套属性、数据边界、必填项以及 `anyOf`/`allOf`/`oneOf`/`not` 等复杂模式验证。
4. **极速 WASM 调用**：原生针对 WebAssembly 架构优化，提供专为 Web 开发设计的 FFI 数据传输接口，能够作为高性能数据网关嵌入前端 or 云函数中。

---

## 🚀 支持的格式与特性 (Formats & Features)

*   **JSON**：标准 JSON 解析与极速格式化输出。
*   **MessagePack**：高效、轻量级的二进制编码与解码，支持变长整数、字符串、数组及 map。
*   **BSON**：支持 MongoDB 式 BSON 二进制序列化与反序列化，保留类型安全。
*   **x-www-form-urlencoded**：支持 URL 表单格式的解析与序列化，提供嵌套路径括号解析（例如将 `user[name]=Alice` 解析为嵌套对象）。
*   **JSON Pointer (RFC 6901)**：提供精确的 AST 指针路径定位器，支持对转义字符（`~0` 与 `~1`）的处理。
*   **JSON Schema**：功能完整的模式校验引擎，保护您的应用免受非法输入的侵害。
*   **XML**：支持属性（`@attr`）与文本 node 混排 the XML 解析器及元素树序列化。
*   **YAML**：基于缩进感的 YAML 块级解析器，支持列表（`-`）与键值对嵌套。
*   **TOML**：支持点号路径（`a.b`）、内联表（`{ x = 1 }`）以及双重括号表格数组（`[[array]]`）的 TOML 编解码器。
*   **原生类型支持**：预置对 `Unit`、`Int64`、`Char`、`Byte`、`Option[T]`、`Result[T, E]` 以及高阶多元组（最多 4 元组）的序列化实现。

---

## 🛠️ 安装与编译 (Installation & Compilation)

要编译并运行 MoonSerde，请确保您的系统安装了 [MoonBit CLI 工具链](https://www.moonbitlang.cn/download/)。

### 1. 编译项目
在项目根目录运行以下命令编译 WASM 目标：
```bash
moon build --target wasm
```

### 2. 运行测试
执行完整的单元测试集：
```bash
moon test
```

---

## 💡 使用示例 (Usage Examples)

### 1. JSON 基础序列化与反序列化
```moonbit
let i = 42
let val_i = Serialize::to_value(i)
println(to_json(val_i)) // 输出: "42"

let map = Map::new()
map.set("key", "value")
let val_map = Serialize::to_value(map)
println(to_json(val_map)) // 输出: {"key":"value"}
```

### 2. BSON 与 Form-urlencoded 编解码
```moonbit
// 1. Form 表单解析
let form_str = "user[name]=Alice&user[role]=Admin"
let form_val = parse_form(form_str).unwrap()

// 2. BSON 序列化
let bson_bytes = to_bson(form_val).unwrap()
let decoded_val = parse_bson(bson_bytes).unwrap()
```

### 3. JSON Pointer (RFC 6901) 查询
```moonbit
let map = Map::new()
let nested = Map::new()
nested.set("role", Value::StringVal("Admin"))
map.set("user", Value::ObjectVal(nested))
let val = Value::ObjectVal(map)

let role = eval_pointer(val, "/user/role").unwrap()
println(role) // 输出: StringVal("Admin")
```

### 4. JSON Schema 安全校验
```moonbit
// 定义 Schema (要求对象含有 "name" 属性且长度不小于 3)
let schema_map = Map::new()
schema_map.set("type", Value::StringVal("object"))

let prop_name = Map::new()
prop_name.set("type", Value::StringVal("string"))
prop_name.set("minLength", Value::IntVal(3))

let properties = Map::new()
properties.set("name", Value::ObjectVal(prop_name))
schema_map.set("properties", Value::ObjectVal(properties))
schema_map.set("required", Value::ArrayVal([Value::StringVal("name")]))

let schema = parse_schema(Value::ObjectVal(schema_map)).unwrap()

// 校验合法实例
let user = Map::new()
user.set("name", Value::StringVal("Agent"))
assert_eq(validate(schema, Value::ObjectVal(user)), Ok(()))
```

---

## 🧪 测试集介绍 (Test Suite)

测试用例定义在 `src/moonserde_test.mbt` 中，全面覆盖了框架的各种数据格式转换和异常处理逻辑：
1. **基础类型序列化** (`serialize basic types`、`serialize array`、`serialize map`)：确保原生类型到 JSON 字符串的映射准确。
2. **MessagePack 编解码** (`msgpack basic roundtrip`)：验证二进制序列化器在大图、不同类型混合下的正确编解码。
3. **BSON 编解码** (`bson parse and serialize`)：验证 MongoDB BSON 文档类型、字节码封装与解析正确性。
4. **Form 表单编解码** (`urlencoded form parse and serialize`、`form urlencoded edge cases`)：保证带特殊 URL 转义字符与多级方括号路径的解析还原。
5. **JSON Pointer 定位** (`json pointer evaluation`、`json pointer unescaping and formatting`)：测试 RFC 6901 规范下的转义定位与格式化。
6. **JSON Schema 校验** (`json schema validation`)：覆盖合法边界、缺失必填属性、长度限制被破坏等各种边界情况。
7. **XML 解析与还原** (`xml parse and serialize`)：验证带属性的标签、空标签 and 文本混排标签的解析与 AST 互转。
8. **YAML 嵌套块解析** (`yaml parse and serialize`)：验证包含列表与对象的嵌套 YAML 文档。
9. **TOML 点路径解析** (`toml parse and serialize`)：覆盖带段落、表格数组以及复杂点号键路径的 TOML 解析与序列化。
10. **高级特征支持** (`expanded trait implementations`)：测试 `Option[T]` 与高阶多元组在嵌套下的正确映射。
