# YAML

YAML 是一种**数据序列化语言**，更多用于编写配置文件

## 基本语法

- 大小写敏感；
- 使用缩进表示层级关系；
- 缩进只能使用空格，不能使用 `tab`；
- 缩进的空格数目不重要，但是**同一个层级上的元素左侧必须对齐**；
- `#` 表示注释，但是只支持单行注释。

## 数据类型

YAML 支持下面几种数据类型：

- 对象：是键值对的集合，也叫映射（Mapping）；
- 数组：一组按照次序排列的值，有成为序列（Sequence）或者列表（List）；
- 纯量：单个的、不可再分的值，也叫标量（Scalar）。

### 对象

对象键值对使用冒号结构表示 `key: value`，冒号的后面要加一个空格。对象支持**多级嵌套**，也支持**流式风格**的语法（亦即使用花括号包裹，拿逗号分割），比如：

```yaml
key:
  value
  chile-key: value
  flow-style-key: {child-key1: value1, child-key2: value2}
```

当遇到复杂对象时，我们允许使用问号 `?` 来声明，这样就可以使用多个词汇（其实是数组）来组成键，亦即对象的属性是一个数组，对应的值也是一个数组：

```yaml
?
  - keypart1
  - keypart2
:
  - value1
  - value2
```

### 数组

一组以**区块格式/Block Format**（亦即短横线+空格）开头的数据构成一个数组：

```yaml
values: 
  - value1
  - value2
  - value3
```

YAML也支持**内联格式/Inline Format**的数组（拿方括号包裹，逗号加空格分割）：

```yaml
values: [value1, value2, value3]
```

同样，嵌套格式的数组也是完全支持的，只需要使用缩进表示层级关系就好了。

### 纯量

**字符串**一般不需要使用引号包裹，但是如果在字符串之中使用了反斜杠开头的转义字符就必须用引号包裹了：

```yaml
strings:
  - this is a string
  - 'this is s string'
  - "this is a string"
  - this is "a 'string'"
```

**布尔值**：`True`、`true`、`TRUE`、`Yes`、`yes`、`YES` 都为真；`False`、`false`、`FALSE`、`No`、`no`、`NO` 皆为假。

**整数**：除了可以正常写十进制，YAML 还支持二进制（前缀 `0b`）和十六进制（前缀 `0x`）表示：

```yaml
int: 
  - 666
  - 0b1010_0111
  - 0x10
```

**浮点数**：字面量（`3,14`）和科学计数法（`6.8523015e+5`）都可以。

**空**：`null`、`Null`、`~` 都是空，不指定默认也是空。

**时间戳**：使用**ISO 8601**格式的时间数据（日期和时间之间使用 `T` 链接，使用 `+` 表示时区）：

```yaml
date1: 2024-02-10 # 这是日期
date2: 2024-02-10T20:30:00+08:00 # 这是时间戳
```

## 引用

为了保持内容的简洁，避免过多的重复的定义，YAML使用 `&` 表示建立锚点，`*` 表示引用锚点、`<<` 表示合并到当前数据：

```yaml
defaults: &defaults
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  <<: *defaults

test:
  database: myapp_test
  <<: *defaults
```

上面的代码相当于：

```yaml
defaults:
  adapter:  postgres
  host:     localhost

development:
  database: myapp_development
  adapter:  postgres
  host:     localhost

test:
  database: myapp_test
  adapter:  postgres
  host:     localhost
```

## 特殊语法支持

### 保留换行

使用竖线 `|` 来表示该语法，这时每行的缩进和尾行空白都会去掉，而额外的缩进则被保留：
```yaml
lines: |
  我是第一行
  我是第二行
    我是吴彦祖
      我是第四行
  我是第五行
```

```Json
"lines": "我是第一行\n我是第二行\n  我是吴彦祖\n    我是第四行\n我是第五行"
```

### 折叠换行

使用右尖括号 `>` 表示该语法，这时只有空白行才会被识别为换行，原来的换行符都会被转换为一个空格：

```yaml
lines: >
  我是第一行
  也是第一行
  仍是第一行
  依旧是第一行

  第二行
  也是第二行
```

```json
"lines": "我是第一行 也是第一行 仍是第一行 依旧是第一行\n第二行 也是第二行"
```
