# MoonSerde

MoonSerde 是一个为 MoonBit 语言设计的高性能、多格式、通用的数据序列化与反序列化框架。它提供了统一的中间值抽象（`Value` AST），支持与多种数据交换格式（JSON、MessagePack、XML、YAML、TOML）之间的相互转换，并内置了完备的 JSON Schema 校验引擎。

## 🎯 项目目标 (Project Goals)

MoonSerde 旨在成为 MoonBit 生态中最强大且易用的数据处理基石：
1. **多格式互通**：打破格式壁垒，一套 `Value` 抽象同时支持 JSON、MessagePack 二进制、XML 标签树、YAML 缩进语法以及 TOML 配置格式。
2. **易用的 Trait 系统**：提供类似 Rust serde 的 `Serialize` 与 `Deserialize` 特征，轻松实现原生 MoonBit 类型与通用 `Value` AST 之间的映射。
3. **健壮的安全校验**：集成高性能的 JSON Schema 验证器，支持嵌套属性、数据边界、必填项以及 `anyOf`/`allOf`/`oneOf`/`not` 等复杂模式验证。
4. **极速 WASM 调用**：原生针对 WebAssembly 架构优化，提供专为 Web 开发设计的 FFI 数据传输接口，能够作为高性能数据网关嵌入前端或云函数中。

---

## 🚀 支持的格式与特性 (Formats & Features)

*   **JSON**：标准 JSON 解析与极速格式化输出。
*   **MessagePack**：高效、轻量级的二进制编码与解码，支持变长整数、字符串、数组及 map。
*   **JSON Schema**：功能完整的模式校验引擎，保护您的应用免受非法输入的侵害。
*   **XML**：支持属性（`@attr`）与文本节点混排的 XML 解析器及元素树序列化。
*   **YAML**：基于缩进感力的 YAML 块级解析器，支持列表（`-`）与键值对嵌套。
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

### 2. JSON Schema 安全校验
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

### 3. XML 元素树转换
```moonbit
let xml_str = "<user id=\"1\"><name>Alice</name></user>"
let node = parse_xml(xml_str).unwrap()
let val = xml_to_value(node)
// 解析后得到的 Value 包含： {"@id": "1", "name": "Alice"}
```

---

## 🧪 测试集介绍 (Test Suite)

测试用例定义在 `src/moonserde_test.mbt` 中，全面覆盖了框架的各种数据格式转换和异常处理逻辑：
1. **基础类型序列化** (`serialize basic types`、`serialize array`、`serialize map`)：确保原生类型到 JSON 字符串的映射准确。
2. **MessagePack 编解码** (`msgpack basic roundtrip`)：验证二进制序列化器在大图、不同类型混合下的正确编解码。
3. **JSON Schema 校验** (`json schema validation`)：覆盖合法边界、缺失必填属性、长度限制被破坏等各种边界情况。
4. **XML 解析与还原** (`xml parse and serialize`)：验证带属性的标签、空标签 and 文本混排标签的解析与 AST 互转。
5. **YAML 嵌套块解析** (`yaml parse and serialize`)：验证包含列表与对象的嵌套 YAML 文档。
6. **TOML 点路径解析** (`toml parse and serialize`)：覆盖带段落、表格数组以及复杂点号键路径的 TOML 解析与序列化。
7. **高级特征支持** (`expanded trait implementations`)：测试 `Option[T]` 与高阶多元组在嵌套下的正确映射。
