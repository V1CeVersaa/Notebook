# Abstraction and Generics

- 每一种编程语言都有用于处理概念重复的机制，在 Rust 中的一种工具就是泛型/Generics，其是一种用于代替具体类型或者其他属性的抽象占位符，可以在编译和运行代码时不知道其会被何种具体内容替换的情况下，表达泛型的行为或它们与其他泛型的关系。
- 特征/Trait 可以以通用的方式定义行为，进一步可以和泛型结合，限制泛型只接受具有特定行为的类型，而不是任意类型。
- 生命周期/Lifetime 是一种向编译器提供关于相互引用关系的泛型，可以让我们可以向编译器提供足够的借用值信息，在更多情况下确保引用值有效。

!!! Abstract "Outline"
    - [x] [1. Generic Data Types](#1-generic-data-types)
    - [x] [2. Traits and Shared Behavior](#2-traits-and-shared-behavior)
    - [ ] [3. Lifetime Annotations](#3-lifetime-annotations)
    - [ ] [4. Closures and Captures](#4-closures-and-captures)
    - [x] [5. Iterators and Lazy Evaluation](#5-iterators-and-lazy-evaluation)
    - [ ] [6. Trait Objects and Dynamic Dispatch](#6-trait-objects-and-dynamic-dispatch)
    - [ ] [7. Advanced Traits](#7-advanced-traits)
    - [ ] [8. Advanced Pattern Matching](#8-advanced-pattern-matching)

## 1. Generic Data Types

```rs
fn largest<T: std::cmp::PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list {
        if item > largest 
            largest = item;
    }
    largest
}
```

我们还可以为结构体和枚举实现泛型，在一个或者多个字段中使用泛型类型参数，还可以在结构体和枚举中实现泛型方法，在定义的时候使用泛型。但是注意我们必须在 `impl` 之后声明泛型 `<U>`，这样我们就可以指明 `Point<T>` 中的 `U` 是泛型类型，而不是具体类型（比如下面的 `impl Point<f32>`）。否则的话就认为 `Point<U>` 中的 `U` 是具体类型，而不是泛型类型。这里的泛型参数 `U` 可以与结构体定义中的泛型参数 `T` 不同，但是建议使用相同的命名管理，尤其是使用相同的名称。

```rs
struct Point<T> {
    x: T,
    y: T,
}

impl<U> Point<U> {
    fn x(&self) -> &U {
        &self.x
    }
}

impl Point<f32> {
    fn radius(&self) -> &f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}

struct PointMix<T, U> {
    x: T,
    y: U,
}

fn main() {
    let integer_point = Point { x: 5, y: 10 };
    let integer_point_x = integer_point.x();
    let float_point = Point { x: 1.0, y: 4.0 };
    let mixed_point = PointMix { x: 5, y: 4.0 };
}
```

当 Rust 编译使用泛型的代码的时候，编译器会执行单态化/Monomorphization，比如对于 `#!rs Some(5)` 和 `#!rs Some(5.0)` 这两个实例，在此过程中，编译器会读取 `Option<T>` 实例中使用的值，并识别出两种 `Option<T>`：一种是 `i32`，另一种是 `f64`。因此，它会将 `Option<T>` 的泛型定义扩展为两个专门针对 `i32` 和 `f64` 的定义，从而用具体的定义替换泛型定义。

```rs
enum Option_i32 {
    Some(i32),
    None,
}

enum Option_f64 {
    Some(f64),
    None,
}

fn main() {
    let integer = Option_i32::Some(5);
    let float = Option_f64::Some(5.0);
}
```

## 2. Traits and Shared Behavior

类型的行为由我们可以对类型调用的方法组成，如果我们可以对所有这些类型调用相同的方法，那么这些类型就可以共享相同的行为。特征定义了完成某个目标所需要的一组行为，这通过指定一些方法来实现。

下面实现的是一个简单的 `Summary` 特征，使用关键字 `trait` 定义，使用 `pub` 将其声明为公开的，以便所有依赖这个 crate 的代码都可以使用这个特征。

在方法签名之后，我们不强制要求实现方法，如果使用分号直接结尾，就代表这个方法必须具有该特征的类型都必须精确按照这个签名实现这个方法，如果特征下的方法有默认实现，那么实现这个特征的类型可以不实现这个方法。默认实现的方法可以调用当前特征定义的其他方法。

```rs
pub trait Summary {
    fn summarize(&self) -> String;
    fn summarize_author(&self) -> String {
        format!("@{}", "author_placeholder")
    }
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}
```

对于为类型实现特征，我们有下面称为孤儿规则/Orphan Rule 的一致性约束：不能同时使用外部特征和外部类型，类型和特征至少有一个必须是本地的，也就是定义在当前 crate 之中。这是为了避免冲突，确保代码的行为是可以预测的，不因为依赖的变化而改变。

```rs
impl Display for MyType {} // ✅ 正确：本地类型 + 外部特征
impl MyTrait for Vec<T> {} // ✅ 正确：外部类型 + 本地特征
impl Display for Vec<T> {} // ❌ 错误：外部类型 + 外部特征
```

由于特征指定了类型的行为，我们可以使用特征定义接受不同类型的函数，有下面几种方式：

```rs
pub fn notify(item: &impl Summary) {}
pub fn notify(item: &(impl Summary + Display)) {}
pub fn notify<T: Summary>(item: &T) {}
pub fn notify<T: Summary + Display>(item: &T) {}
pub fn notify<T, U>(item: &T, item2: &U)
where
    T: Summary + Display,
    U: Display + Clone,
{}
```

- 前两行指示的是使用 `impl Trait` 语法，表示接受一个实现了 `Summary` 特征的类型，这种实际上是下面两行这种语法的语法糖，下面两行将 Trait Bound 放在泛型类型参数的声明之后，使用冒号分割，放在尖括号内，后面这种 Trait Bound 语法可以表示更加丰富的含义，允许多个参数具有相同的类型以及更加复杂的约束；
- 使用 `+` 可以组合多个特征，这里面的表示接受一个实现了 `Summary` 特征和 `Display` 特征的类型；
- 使用 `where` 可以更加清晰地表示特征约束，这里表示接受一个实现了 `Summary` 特征和 `Display` 特征的类型，和一个实现了 `Display` 特征和 `Clone` 特征的类型；

当然可以返回实现了特征的类型：

```rs
fn returns_summarizable() -> impl Summary {
    NewsArticle {...}
}
```

这里仅仅通过实现的特征指定返回类型的能力在闭包和迭代器上下文中特别有用，`impl Trait` 语法让我们可以方便简洁地指定函数返回实现某种 `Iterator` 特征的类型，而无需写出很长的类型。但是，我们只能在返回**单一类型**的时候使用 `impl Trait` 语法，比如返回 `NewsArticle` 或者 `Tweet` 的函数就不能使用 `impl Trait` 语法，后续会有解决方法。

Trait Bound 还可以被使用来有条件的实现方法，只需要我们在 `impl` 块之中使用带有泛型类型参数的 Trait Bound 就可以，比如下面的方法就被限制在实现了 `Display` 和 `PartialOrd` 特征的类型上。

```rs
impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

也可以为实现另一个 Trait 的任何类型有条件地实现一个 Trait，这种在满足 Trait Bound 的任何类型上实现 Trait 被称为 Blanket Implementation，比如下面的代码就为所有实现了 `Display` 特征的类型实现了 `ToString` 特征。

```rs
impl<T: Display> ToString for T {
    fn to_string(&self) -> String {...}
}
```

## 3. Lifetime Annotations

## 4. Closures and Captures



## 5. Iterators and Lazy Evaluation

迭代器允许我们迭代一个连续的集合，比如数组、动态数组 `Vec<T>`、哈希表 `HashMap<K, V>` 等，在这个过程之中，我们只需要关注集合之中的元素如何处理，而不需要关心如何开始、如何结束、按照怎么样的索引去访问等问题。迭代器和显式地使用 `for` 循环之间的最重要差别就是，是否使用索引访问循环。下面给了一个小例子：

```rs
let arr = [1, 2, 3];
let arr_iter = arr.iter();
for v in arr { println!("{}", v); }
for v in arr.into_iter() { println!("{}", v); }  // from IntoIterator trait
for v in arr.iter() { println!("{}", v); }       // lazy evaluation
```

- 首先，数组实现了 `IntoIterator` 特征，因此 Rust 可以使用 `for` 语法糖，自动将实现了该特征的数组类型转化成迭代器，我们也可以使用 `into_iter` 方法显式地将数组转换成迭代器；
- 其次，迭代器是惰性的，如果不使用它，那么不会发生任何事情，这里第二行只是创建了一个迭代器，但是没有任何事情发生，只有真正 `for` 循环开始之后，才会开始迭代内部的元素。

迭代器之所以成为了迭代器，就是其实现了 `Iterator` 特征，要实现 `Iterator` 特征，最重要的就是实现 `next` 方法，这个方法定义了如何从集合之中取值，并且返回一个 `Option<Item>` 类型，当集合结束的时候，返回 `None`。注意取值是按照迭代器中的元素的排列顺序依次进行的，并且必须手动将迭代器声明为可变。但是 `next` 方法对迭代器的遍历是消耗性的，每次调用 `next` 方法都会消耗迭代器中的一个元素，最终迭代器中将没有元素，只能返回 `None`。

```rs
let arr = [1, 2, 3];
let mut arr_iter = arr.into_iter();

assert_eq!(arr_iter.next(), Some(1));
assert_eq!(arr_iter.next(), Some(2));
assert_eq!(arr_iter.next(), Some(3));
assert_eq!(arr_iter.next(), None);
```

下面使用显式的 `loop` 模拟了 `for` 循环：

```rs
let result = match IntoIterator::into_iter(arr) {
    mut iter => loop {
        match iter.next() {
            Some(x) => println!("{}", x),
            None => break,
        }
    },
};
```

还有几点需要注意：

- 对于实现了 `IntoIterator` 特征的类型，我们可以使用 `into_iter` 方法显式地将其转换成迭代器，如果我们转化的就是一个迭代器，那么这个方法会返回这个迭代器本身，这可以查看 `IntoIterator` 特征的实现；
- `into_iter`、`iter` 和 `iter_mut` 方法都完成了转化为迭代器的操作，但是具体实现有很多差别：`into_iter` 会夺走被转化集合的所有权，并且所有 `into_` 开头的操作都会夺走所有权，而 `iter` 和 `iter_mut` 不会夺走所有权，这两个都是借用，差别只在于可变借用和不可变借用；

```rs
let values = vec![1, 2, 3];
for v in values.into_iter() {
    println!("{}", v);
}
println!("values: {:?}", values);  // ❌ 错误：所有权已经被夺走
```

但是对于上面有一个数组切片的例子，这是一个例外，因为数组元素 `i32` 类型实现了 `Copy` 特征，当整个数组的元素都是 `Copy` 类型的时候，数组本身也是 `Copy` 类型，而 `Copy` 类型再复制和传递的时候会自动复制，而不是移动所有权，作为对比，`Vec<T>` 无论 `<T>` 是否是 `Copy` 类型，`Vec` 本身都不是 `Copy` 类型，所以这时候就出现了所有权的移动。

简单来说，迭代器可以分为消费性适配器/Consuming Adaptor 和迭代器适配器/Iterator Adaptor，消费性适配器会消耗掉迭代器中的元素，比如 `next`、`sum` 和 `collect` 方法，迭代器适配器会返回一个新的迭代器，比如 `map` 和 `filter` 方法，这是实现链式方法调用的关键，但是迭代器适配器是要最后以一个消费性适配器结束，最后转化为具体的值，这时候也可以看见迭代器惰性求值的特性。

```rs
let v1 = vec![1, 2, 3];
let v1_iter = v1.iter();
let v1_sum: i32 = v1_iter.sum();                          // 夺走 v1_iter 的所有权，并且这里必须要有类型注释
let v1_map: Vec<_> = v1.iter().map(|x| x + 1).collect();  // 这里必须要有类型注释
let v1_with_hash: HashMap<_, _> = v1.into_iter().zip(v1_map.into_iter()).collect();
assert_eq!(v1_map, vec![2, 3, 4]);
```

需要注意的是，这里的第三行到第五行都必须要有类型注释，这是为了告诉编译器 `v1_sum` 和 `v1_map` 的类型，显式指示出希望收集成的集合类型，否则编译器会报错。

下面为自定义类型实现 `Iterator` 特征，关键在于实现 `next` 方法：

```rs
struct Counter {
    count: u32,
}

impl Counter {
    fn new() -> Counter {
        Counter { count: 0 }
    }
}

impl Iterator for Counter {
    type Item = u32;

    fn next(&mut self) -> Option<Self::Item> {
        if self.count < 5 {
            self.count += 1;
            Some(self.count)
        } else {
            None
        }
    }
}
```

最后，记录一些常见的迭代器方法：

- `#!rs map(self, f: F) -> Map<Self, F>`：接受一个闭包并且创建一个迭代器，该迭代器对每一个原迭代器的元素调用一次该闭包参数，并且返回之，注意 `map` 是惰性求值的；
- `#!rs filter(self, predicate: P) -> Filter<Self, P>`：接受一个闭包并且创建一个迭代器，这个闭包必须返回 `true` 或者 `false`，`filter` 会使用闭包确定是否生成元素，这个返回的迭代器将只生成闭包返回 `true` 的元素；
- `#!rs enumerate(self) -> Enumerate<Self>`：创建一个新的迭代器，该迭代器会产生 `(index, element)` 形式的元组，索引从 0 开始，类型为 `usize`，这在循环中需要知道元素位置时非常有用；
- `#!rs collect<B>(self) -> B`：消耗整个迭代器，将迭代器转化为集合，但是这里必须要有类型注释，要么在收集的结果上放一个类型注释，要么使用 `::<>` 语法显式指定类型；
- `#!rs zip<U>(self, other: U) -> Zip<Self, U::IntoIter>`：将两个迭代器压缩合并成一个生成元组 `(elementA, elementB)` 的新迭代器，新迭代器的长度由两个输入迭代器中较短的那个决定，注意 `zip` 是惰性求值的；
- `#!rs for_each<F>(self, f: F)`：消耗整个迭代器，并对其中的每个元素执行指定的闭包操作，通常用于执行副作用（比如打印、修改外部状态等），并且没有返回值；
- `#!rs fold(self, init: B, f: F) -> B` / `#!rs reduce(self, f: F) -> Option<Self::Item>`：
    - `#!rs fold`：用于将迭代器中的所有元素“折叠”或“规约”成一个单一的值，它接受一个初始值/Accumulator 和一个闭包，闭包的参数是 Accumulator 和当前元素，返回值是更新后的 Accumulator，但是 `fold` 以及遍历整个迭代器的类似方法，对于无限迭代器可能不会终止；
    - `#!rs reduce`：与 `fold` 类似，但不接受初始值，而是使用迭代器的第一个元素作为初始值，因此，如果迭代器为空，它会返回 `None`；
- `#!rs find<P>(&mut self, predicate: P) -> Option<Self::Item>`：接受一个返回布尔值的闭包，对迭代器元素进行搜索，并返回**第一个**满足条件的元素的 `Option`，这是一个**短路**操作，一旦找到匹配项就会立即停止迭代，注意这里的参数 `self` 是一个可变引用，可能导致参数是双重引用；
- `#!rs any<F>(&mut self, f: F) -> bool` / `#!rs all<F>(&mut self, f: F) -> bool`：
    - `any`：接受一个返回布尔值的闭包，检查迭代器中**是否有任何一个**元素满足条件。只要找到一个满足条件的元素，就会立即返回 `true` 并停止迭代（短路），如果迭代器为空，则返回 `false`。
    - `all`：接受一个返回布尔值的闭包，检查迭代器中**是否所有**元素都满足条件。只要找到一个不满足条件的元素，就会立即返回 `false` 并停止迭代（短路），如果迭代器为空，则返回 `true`。
- `#!rs chain<U>(self, other: U) -> Chain<Self, U::IntoIter>`：将两个迭代器连接起来，创建一个新的按照顺序遍历两者的迭代器，新迭代器会先产生第一个迭代器的所有元素，然后再产生第二个迭代器的所有元素；
- `#!rs rev(self) -> Rev<Self>`：反转一个迭代器的方向，这个方法只对实现了 `DoubleEndedIterator` 或者 `Sized` 特征的迭代器有效（例如 `Vec` 或切片的迭代器），使其从后往前迭代。

## 6. Trait Objects and Dynamic Dispatch

## 7. Advanced Traits

## 8. Advanced Pattern Matching 
