# Basic Syntax

## 1. Variables and Mutability

## 2. Data Types

## 3. Functions

## 4. Control Flow

## 5. Basic Collections (Vectors)

## 6. Strings and Text

## 7. Hash Maps


## 一、变量

### 1 命名惯例

| 条目                               | 惯例                                        |
| :--------------------------------- | :------------------------------------------ |
| 模块 Modules                       | `snake_case`                                |
| 类型 Types                         | `UpperCamelCase`                            |
| 特征 Traits                        | `UpperCamelCase`                            |
| 枚举 Enumerations                  | `UpperCamelCase`                            |
| 结构体 Structs                     | `UpperCamelCase`                            |
| 函数 Functions                     | `snake_case`                                |
| 方法 Methods                       | `snake_case`                                |
| 通用构造器 General constructors    | `new` or `with_more_details`                |
| 转换构造器 Conversion constructors | `from_some_other_type`                      |
| 宏 Macros                          | `snake_case!`                               |
| 局部变量 Local variables           | `snake_case`                                |
| 静态类型 Statics                   | `SCREAMING_SNAKE_CASE`                      |
| 常量 Constants                     | `SCREAMING_SNAKE_CASE`                      |
| 类型参数 Type parameters           | `UpperCamelCase`，通常使用一个大写字母: `T` |
| 生命周期 Lifetimes                 | 通常使用小写字母: `'a`，`'de`，`'src`       |

### 2 绑定与解构

使用 `#!rust let` 关键字将值绑定到一个变量上，变量绑定**默认是不可变的**，如果需要可变绑定，使用 `#!rust let mut` 关键字。

使用 `#!rust let` 关键字还可以进行复杂变量的解构，这也就是从一个相对复杂的变量之中，匹配出这个变量的一部分内容。

### 3 所有权与引用

可变引用允许我们修改借用来的值，而不需要获取该值的所有权。首先要求我们声明变量为 `mut`，然后使用 `&mut` 关键字来创建一个可变引用。

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);
}

fn change(some_string: &mut String) {
}
```

Rust 严格限制可变引用，借以有效避免数据竞争。如果以下三个条件同时满足，则会发生数据竞争：

- 两个或更多的指针同时访问同一数据；
- 至少有一个指针被用来写入数据；
- 没有同步数据访问的机制。

Rust 要求**在同一个作用域之中**，**一个数据只能有一个可变引用**，同时，**可变引用和不可变引用不能同时存在**，但是多个不可变引用同时存在是可以的。显然，Rust 通过避免第一条，通过限制可变引用的数量，以及同一时间只能有一个可变引用的规则，避免了数据竞争。

## 二、基础类型系统

### 1 基础类型

1. 整数类型：
2. 浮点类型：
3. 布尔类型：
4. 字符类型：

### 2 复合类型

**元组**：A finite heterogeneous sequence。有限长，可以包含各种类型，可以通过 index 访问。逗号分割，圆括号包裹，长度固定，在尺寸上不能增长也不能缩水，可以析构，直接使用 `.index` 访问：

```rust
let tup: (i32, f64, char) = (500, 6.4, 'x');

let (x, y, z) = tup;
println!("The value of tup.2 is: {}", tup.2);
```

`tup` 被绑定到整个元组上，因为元组被视为是一个单独的复合元素。空元组 `()` 被称为 unit，其值和类型都为 `()`。表达式如果不返回任何值，则隐式返回 `()`。

**数组**：A fixed-size array。长度固定，里边类型相同，直接使用 `[type; length]` 声明，使用 `[index]` 访问，使用 `[ele1, ele2, ...]` 或者 `[exp; length]` 初始化，其中 `exp` 要么是实现了 `Copy` 特征的类型，要么是一个 `const` 类型；

```rs
let a: [i32; 5] = [1, 2, 3, 4, 5];
let b = ["hello"; 5];
```

数组在栈中分配内存，长度固定，不能增长或缩水，如果需要动态大小的数组，可以使用 `Vec` 类型。违法的索引会引起 Runtime Error。

**切片**：A dynamically-sized view into a contiguous sequence。对于定义为 `[T; n]` 的数组，其切片类型为 `[T]`，对应的内存大小在编译时期不确定，因此不能直接使用。对应的引用类型为 `&[T]`，切片引用事实上更为常见，因为其长度在编译时期确定，事实上被实现为胖指针，包含一个指向数据的指针，以及一个长度信息。

### 3 结构体

**结构体**：A type that is composed of other types。和元组类似，可以存储多个相关值，并且各个字段可以为不同类型，但是结构体的各个字段都是命名的。结构体使用 `struct` 关键字声明，使用花括号包裹，字段间使用逗号分割，字段名和类型间使用冒号分割。使用 `.name` 访问字段。

创建实例的时候，指定结构体名称并且添加包含键值对的花括号，实例化的时候不要求顺序一致。结构体的实例必须整体标记为 `mut`，不能单独指定字段是可变的。

```rs
struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

let mut user1 = User {
    active: true,
    username: String::from("someusername123"),
    email: String::from("someone@example.com"),
    sign_in_count: 1,
};

user1.email = String::from("anotheremail@example.com");
```

可以使用 `..another_instance` 来从其余实例中复制其余字段，但是其必须最后出现。

```rs
let user2 = User {
    email: String::from("another@example.com"),
    ..user1
};
```

注意这样的更新语法使用的是赋值 `=`，因此会发生所有权转移，这样 `user1` 的 `username` 字段的所有权就转移给了 `user2`，而 `user1` 的 `email` 字段就无效了，我们因此也不能再整体使用 `user1` 了。

元组结构体：

单元结构体：

方法：

关联函数：所有在 `impl` 块中定义的函数被称为关联函数/Associated Functions，因为其与对应的类型相关。我们知道，所谓方法是以 `self` 作为第一个参数的函数，而关联函数则不以 `self` 作为第一个参数，因此常常被使用在构造器上。

```rs
impl Rectangle {
    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }
}
```

其中关键词 `Self` 表示类型本身，也就是 `Rectangle` 类型，我们也使用结构体名和 `::` 语法来调用对应的关联函数，比如 `#!rs let sq = Rectangle::square(3);`。

### 4 枚举

A type that can be any one of several variants. 如果我们想定义一个操作/类型的集合，并且每个元素都有自己的字段，那么枚举是一个很好的选择。

```rs
enum Figure {
    Circle { radius: f64 },
    Rectangle { width: f64, height: f64 },
    Dot (f64, f64),
}

let c = Figure::Circle { radius: 2.0 };
let r = Figure::Rectangle { width: 2.0, height: 3.0 };
let d = Figure::Dot(1.0, 2.0);
```



### 5 Vector

A contiguous growable array type, written as `Vec<T>`, short for ‘vector’。

### 6 String

A UTF-8 encoded, growable string.

### 7 HashMap

Rust 中的哈希映射集合类型，用于存储键值对映射关系，类型表示为 `#!rs HashMap<K, V>`，其中 `K` 是键的类型，`V` 是值的类型。

```rs
use std::collections::HashMap;

let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
scores.insert(String::from("Blue"), 25);

let team_name = String::from("Blue");
let score = scores.get(&team_name).copied().unwrap_or(0);

for (key, value) in &scores {
    println!("{}: {}", key, value);
}
```

- 需要使用 `#!rs use std::collections::HashMap;` 导入 HashMap 类型。
- HashMap 和 Vec 类似，是同质的并且数据保存在堆上。
- 通过 `.get()` 方法查询键值对，返回 `Option<&V>` 类型，如果键不存在，则返回 `None`，对于返回的 `Option<&V>` 类型，可以使用 `.copied()` 方法使之成为 `Option<V>` 类型，再使用 `.unwrap_or()` 方法返回默认值或者原本值。
- 通过 `for` 循环遍历键值对，返回 `(&K, &V)` 类型。
- 对于实现了 `Copy` 特征的类型，在插入的时候，其值会自动拷贝进 HashMap 中，对于拥有所有权的类型，其值会被移动到 HashMap 中。当引用类型被插入到 HashMap 中的时候，我们必须保证其引用的值在 HashMap 的有效期之内不会失效。
- 如果键值对已经存在，那么插入的值会覆盖原有的值。

```rs
let mut scores = HashMap::new();

scores.insert(String::from("Blue"), 10);
scores.entry(String::from("Yellow")).or_insert(50);
scores.entry(String::from("Blue")).or_insert(50);
```

`.entry()` 方法会返回一个 `Entry` 类型，其是一个枚举类型，包含 `Occupied` 和 `Vacant` 两种情况，分别表示键存在和键不存在。`.entry(key).or_insert(value)` 则是如果键存在，则不进行任何操作，如果键不存在，则插入对应的值，并且返回该值的可变引用。同理还有 `.entry(key).and_modify(f)` 方法，如果键存在，则执行 `f` 函数，如果键不存在，则返回 `Vacant` 类型。

借用 `.entry().or_insert()` 方法返回的引用，可以修改键对应的值：

```rs
let mut scores = HashMap::new();

let score = scores.entry(String::from("Blue")).or_insert(10);
*score += 1;
```

## 三、函数，控制流与模式匹配

### 1 函数

### 2 控制流

### 3 模式匹配

`match` 允许我们将一个值和一系列的类型相匹配，类型可以是变量、字面量、通配符或者其余模式。

`if let` 可以认为是 `match` 的一种语法糖，只匹配一个模式，其余模式完全忽略。运行模式也几乎一样：`if let` 接收一个模式和一个表达式，用等号分割，如果模式匹配，则进行绑定并且执行对应代码块，否则执行 `else` 分支（或者没有这个分支）。

```rs
let cfg_max = Some(3u8);
let mut cnt = 0;

match cfg_max {
    Some(max) => println!("The maximum is configured to be {}", max),
    _ => cnt += 1,
}

if let Some(max) = cfg_max {
    println!("The maximum is configured to be {}", max);
} else {
    cnt += 1;
}
```

`let else` 是另外一种比较新的语法。和 `if let` 不同的是，`let else` 如果模式匹配，那么直接进行绑定，没有对应的代码快，如果不匹配，那么直接进行返回。下面进行一个简单的比较：

```rs
let cfg_max = Some(3u8);

let mut max = if let Some(__max) = cfg_max {
    __max
} else {
    return None;
}

let Some(mut max) = cfg_max else {
    return None;
}
```

能写出第一种的都是神人了。`if let` 和 `let else` 都有语法简洁，缩进较少的特点，尤其 `let else` 在不匹配的时候直接终止流程，并且可以在更大作用域上绑定值，所以更加易用。

## 四、特征与泛型

## 五、模块系统与并发

### 1 箱与包

箱/Crate：Rust 编译器编译的最小单元，一个由模块组成的树状结构。箱可以包含模块，模块可能被定义在别的文件中，分为两种形式：

- 二进制箱/Binary Crate：可以编译为可执行文件的程序。必须有一个 `main` 函数定义执行行为。
- 库箱/Library Crate：不具有 `main` 函数，不编译为可执行文件，但是定义了可以在多个项目中共享的功能。

箱根/Crate Root：是编译器开始编译的源文件，构成箱的根模块。

包/Package：提供一组功能的一个或者多个箱。一个包包含了一个 `Cargo.toml` 文件，描述如何构建这个包。Cargo 其实就是一个包，其包含了构建代码的命令行工具（二进制箱）及其库箱。一个包可以包含任意多个二进制箱，但是至多有一个库箱。

如果我们运行 `cargo new` 命令，会生成一个包，其内当然包含 `Cargo.toml` 文件，描述如何构建这个包。我们遵循如下规定：

- `src/main.rs` 是与包同名的二进制箱的箱根；
- `src/lib.rs` （如果存在）是与包同名的库箱的箱根。
- 可以在 `src/bin` 目录下放置文件来创建多个二进制箱，每个文件都是一个独立的二进制箱。

### 2 模块

模块/Modules 是 Rust 中组织代码的单元，

编译箱的基本规则大致如下：

- 编译器首先检查箱根文件，通常是上文提到的 `src/main.rs` 或者 `src/lib.rs`；
- 声明模块：在箱根文件中，可以声明新的模块 `mod module_name;`，编译器会在下面三个地方检查其定义：内连方式，也就是使用花括号代替分号；文件方式，会查找 `src/module_name.rs` 文件；目录方式，会查找 `src/module_name` 目录，该目录下必须有一个 `mod.rs` 文件。
- 声明子模块：在非箱根文件中，比如在 `src/module_name.rs` 中，可以声明子模块 `mod submodule_name;`，编译器会按照上述规则递归检查其定义：内连方式同理；文件方式，会查找 `src/module_name/submodule_name.rs` 文件；目录方式，会查找 `src/module_name/submodule_name` 目录，该目录下必须有一个 `mod.rs` 文件。
- 代码路径：比如 `crate::module_name::submodule_name::type` 表示在子模块中的 `type` 类型。
- `use` 关键字：在作用域内，创建对应条目的快捷方式，比如 `use crate::module_name::submodule_name::type;` 表示我们引入了 `type` 类型，之后只需要写 `type` 即可。
- `pub` 关键字：模块中的代码默认对其父模块私有，使用 `pub mod` 可以将其声明为公开的，如果要是使里面的某个条目公开，则需要在其对应的声明前面加上 `pub` 关键字。


<!-- 

### 1.4 所有权

#### 1.4.1 基本规则

- Rust 每一个值都被一个变量所拥有，这个变量被称为这个值的所有者；
- 一个值同时只能被一个变量所拥有；
- 当所有者离开作用域范围的时候，值就会被丢弃。

作用域和别的编程语言没有区别，可以参考块作用域。

#### 1.4.2 所有权转移

对于以拷贝值的方式完成的赋值，没有所有权的转移。

```rust
let x = 5;
let y = x;
```

这段代码当然是通过拷贝值完成赋值的，因为整数是 Rust 基本数据类型，是固定大小的简单值，因此这两个值都是通过**自动拷贝**的方式来赋值的，都被存在栈中，完全无需在堆上分配内存。当然没有所有权的转移。

```rust
let s1 = String::from("hello");
let s2 = s1;
```

`String` 类型和上面的整数类型很不一样，是由存储在栈中的堆指针、字符串长度和字符串容量共同组成的，总之指向了一个在堆上的空间。`#!rust let s2 = s1;` 这行代码会让 `s1` 被赋给 `s2`，而一个值同时只能被一个变量所拥有，所以 Rust 认为 `s1` 不再有效，在赋值完成之后就马上失效了。

这就是**所有权转移**，对应的操作是移动而不是拷贝，我们将对这个字符串的所有权从 `s1` 转移到了 `s2`。`s1` 不指向任何数据，只有 `s2` 才有效。

如果不发生所有权转移，那么在两个变量同时同时离开作用域的时候，就会尝试释放相同的内存，这就会出现了二次释放的错误，会导致内存污染。而发生所有权转移后，如果还尝试使用旧的所有者 `s1`，Rust 就会禁止你使用无效的引用。

如果我们确实需要深度复制 `String` 堆上的数据，就要使用**克隆/深拷贝**，`#!rust let s2 = s1.clone();` 会在堆上分配一块新的内存，将 `s1` 的数据拷贝到新的内存中，这样就不会发生所有权转移了。

与深拷贝相对的是**浅拷贝**，正常的拷贝其实就是浅拷贝，浅拷贝发生在栈中，效率很高。

Rust 有一个叫做 `Copy` 的特征，可以用在类似整型这样在栈中存储的类型。如果一个类型拥有 `Copy` 特征，一个旧的变量在被赋值给其他变量后仍然可用，也就是赋值的过程即是拷贝的过程。

那么什么类型是可 `Copy` 的呢？可以查看给定类型的文档来确认，这里可以给出一个通用的规则： **任何基本类型的组合可以 `Copy` ，不需要分配内存或某种形式资源的类型是可以 `Copy` 的**。如下是一些 `Copy` 的类型：

- 所有基本类型；
- 元组，当且仅当其包含的类型也都是 `Copy` 的时候。比如，`(i32, i32)` 是 `Copy` 的，但 `(i32, String)` 就不是
- 不可变引用 `&T`，**但是注意：可变引用 `&mut T` 是不可以 Copy的**。

#### 1.4.3 函数传值和返回

函数在传值的时候也会发生移动或者复制，相应的发生所有权的转移：

```rust
fn main(){
    let s = String::from("hello");
    takes_ownership(s);
    // println!("{}", s); // error: value borrowed here after move
}

fn takes_ownership(some_string: String) {
    println!("{}", some_string);
}
```

如果在 `takes_ownership` 函数后边尝试再使用 `s` ，就会出现所有权报错，因为 `s` 对于 `String` 的所有权在函数传值的时候已经移动给了 `some_string`，随后 `take_owmership` 结束的时候，`some_string` 的值内存被 `drop` 了，加上原本的 `s` 的所有权已经移动，所以 `s` 就无效了。如果函数调用完了还想使用 `s`，一种方法是传递 `s.clone()`，另一种方法是返回值：

```rust
fn main(){
    let mut s = String::from("hello");
    s = takes_ownership(s);
    println!("{}", s);  // no error
}

fn takes_ownership(some_string: String) -> String {
    println!("{}", some_string);
    some_string
}
```

这里利用了函数返回的时候也会发生所有权的转移，所以 `some_string` 的所有权在函数返回的时候又转移给了 `s`，`s` 又可以使用了。但这里要求 `s` 是可变的，即便传来传去都是一个 `String` 类型，但是变量还是发生了变化。

### 1.5 引用和借用

Rust 也支持类似于使用指针和引用的方式简化传值的流程，利用**借用/Borrowing**这个概念完成上述目的。借用是指获取变量的引用。

常规引用是一个指针类型，指向了对象存储的内存地址。使用 `&` 进行引用，使用 `*` 进行解引用。

```rust
let x: i32 = 5;
let y: &i32 = &x;
assert_eq!(*y, x);
```

使用借用可以进行函数调用，并且维持所有权：

```rust
fn main() {
    let s = String::from("hello");
    let len = calculate_length(&s);     
    println!("The length of '{}' is {}.", s, len);
}

fn calculate_length(string: &String) -> usize {
    string.len()
}
```

我们首先创建了 `s` 的引用并且将其传入，这样，我们通过操纵引用来操纵 `s`，在函数调用结束的时候，`string` 离开作用域，但是它并不拥有任何值，所以不会发生什么。

上面创建的都是不可变引用，一直处于只读状态，也就是说，不能在 `calculate_length` 函数中修改 `string` 的值，比如 `#!rust string.push_str("...");`，如果需要修改，可以使用 `&mut` 创建可变引用：

```rust
let mut x: i32 = 1;
let y: &mut i32 = &mut x;
```

```rust
fn main() {
    let mut s = String::from("hello");
    change(&mut s);
    println!("{}", s);
}

fn change(string: &mur String) {
    string.push_str(" world!");
}
```

这里创建的就是可变引用了，可以通过引用来更改变量的值。但是对于可变引用， Rust 存在着一些限制：

- 在同一个作用域之中，一个数据只能存在一个可变引用；
- 可变引用和不可变引用不能同时存在；

这样做的目的是避免产生数据竞争，以及防止不可变引用的值被可变引用所改变。数据竞争可由以下行为造成：

- 两个或更多的指针同时访问同一数据；
- 至少有一个指针被用来写入数据；
- 没有同步数据访问的机制。

另外，引用的作用域 `s` 从创建开始，一直持续到它最后一次使用的地方，这个跟变量的作用域有所不同，变量的作用域从创建持续到某一个花括号 `}`。

以及如果存在引用，且后面用到了这个引用，则被引用的即使是 `mut` 的，也不能被修改，例如：

我们也应该注意**悬垂引用/Dangling Reference**，悬垂引用也叫做悬垂指针，意思为指针指向某个值后，这个值被释放掉了，而指针仍然存在，其指向的内存可能不存在任何值或已被其它变量重新使用。Rust 编译器会在编译时检测到悬垂引用并且报错。下面是一个悬垂引用的例子：

```rust
fn dangle() -> &String {
    let s = String::from("hello");
    &s  // this function's return type contains a borrowed value
}       // but there is no value for it to be borrowed from.
```

### 1.6 遮蔽


## 2 类型和值

Rust 的类型可以分为两类：基本类型和符合类型。基本类型意味着其是一个最小化原子类型，无法解构为其他类型，有以下几种：

- 数值类型：有符号整数 `i8`, `i16`, `i32`, `i64`, `i128`, `isize`, 无符号整数 `u8`, `u16`, `u32`, `u64`, `u128`, `usize`, 浮点数 `f32`, `f64`；
- 布尔类型：`bool`， 字面量为 `true` 和 `false`；
- 字符类型：`char`，用单引号括起来的 Unicode 字符；
- 单元类型：`()`，只有一个值 `()`，`main` 函数的返回值就是 `()`，这玩意其实就是一个零长度的元组。

复合类型是由其他类型组合而成的，最典型的就是结构体 `struct`，有以下几种：

- 字符串
- 元组
- 结构体
- 枚举
- 数组

### 2.1 数值类型

**序列**是生成连续的数值的

要显式处理溢出，可以使用标注怒对原始数字类型提供的这些方法：

- `wrapping_*`：在所有模式下都按照补码循环溢出规则处理；
- `overflowing_*`：返回该值和一个指示是否发生溢出的布尔值；
- `saturating_*`：限定计算后的结果不超过目标类型的最大值或最小值；
- `checked_*`：如果溢出则返回 `None`。

### 2.2 布尔类型

### 2.3 单元类型

### 2.4 字符类型

### 2.5 字符串 

字符串大抵分为两种，被硬编码到程序代码之中的不可变的字面量 `str`，和用堆动态分配内存的可变的 `String` 类型。在语言级别来说，其实只有一种字符串类型 `str`，并且一般是以引用形式 `&str` 出现的，存储的时候是一个指针和字符串长度。`String` 类型是标准库提供的一个字符串类型，它是一个可变的、可增长的、具有所有权的 UTF-8 编码的字符串类型。 

#### 2.5.1 `String` 和切片

使用 `String::from` 方法将一个字符串字面量转换为 `String` 类型，这里的 `::` 是一种调用操作符，这里表示调用 `String` 模块中的 `from` 方法，由于 `String` 类型的变量 `s` 存储在堆上，因此它是动态的，如果 `s` 是 mut 的，可以通过 `s.push_str("...")` 来追加字面量：

```rust
let mut s = String::from("Hello");
s.push_str(" world!");
println!("{}", s);
```

基于上面的代码，下面介绍切片：切片就是对 `String` 类型之中某一部分的引用，类型就是 `&str`，通过 `[begin..off_the_end]` 指定引用范围，这个范围是左闭右开的（参考 C++ 的尾后迭代器），这和别的编程语言一样。我们可以认为这个语法其实就是数值类型一节中范围的语法，所以 `[begin..=end]` 就生成了一个闭区间的范围。

### 2.6 元组

### 2.7 结构体

### 2.8 枚举

### 2.9 数组

## 3 语句、函数和控制流

### 3.1 语句与表达式

简单说来：

- 带分号的就是一个语句，不带分号的就是一个表达式；
- 能返回一个值的就是一个表达式，表达式会在求值后返回该值，语句会执行一些操作但是不返回值，`#!rust let` 就是一个经典的语句，只负责绑定变量和值，但是不返回值；
- 表达式可以是语句的一部分，`#!rust let a = 1;` 就是一个语句，`1` 其实就是一个表达式；
- 函数调用是表达式，因为返回了一个值，就算不返回值，就会隐式的返回一个 `()`；
- 用花括号括起来的能返回值的代码块是一个表达式，代码块的类型和值就是最后一个表达式的类型和值，如果最后一个表达式是一个分号结尾的语句，那么代码块的类型就是 `()`。

### 3.2 函数

```rust
fn add(x: i32, y: i32) -> i32 {
    x + y
}
```

上面是典型的函数定义，下面是几个需要注意的点：

- 使用关键词 `fn` 定义一个函数；
- 必须显示指定参数类型，除了返回单元类型 `()`，因为这种情况下编译器会自动推断返回类型，都要显式指定返回类型；
- 中途返回使用 `return` 关键字，带不带分号都可以；
- 以语句为最后一行代码的函数，返回值是 `()`；
- 永远不返回的函数类型为 `!`，一般用于一定会抛出 panic 的函数，或者无限循环的函数。
- 由于函数也返回值，所以函数调用也是一个表达式，可以用在赋值语句的右边。

### 3.3 控制流

### 3.4 简单的宏

宏在编译过程中会扩展为 Rust 代码，并且可以接受可变数量的参数。它们以 `!` 结尾来进行区分。Rust 标准库包含各种有用的宏。

- `println!(format, ..)` 在标准输出中打印一行字符串；
- `format!(format, ..)` 的用法与 `println!` 类似，但并不打印，它以字符串形式返回结果；
- `dbg!(expression)` 会记录表达式的值并返回该值；
- `todo!()` 用于标记尚未实现的代码段。如果执行该代码段，则会触发 panic；
- `unreachable!()` 用于标记无法访问的代码段。如果执行该代码段，则会触发 panic；
- `assert_eq!(left, right)` 用于断言两个值是否相等；
 -->
