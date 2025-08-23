# Robustness and Concurrency

错误在软件之中是司空见惯的，因此 Rust 提供了许多用于处理错误情况的特性。在许多情况下，Rust 要求你承认可能发生错误并在代码编译之前采取某些措施。这个要求通过确保你会在将代码部署到生产环境之前发现并适当处理错误。

Rust 将错误分为两大类：可恢复错误和不可恢复错误。对于可恢复错误，例如文件未找到错误，我们通常只想向用户报告问题并重试该操作，不可恢复错误往往是程序缺陷的象征，比如尝试访问数组末尾之外的位置，因此我们希望立即停止程序。大多数语言不区分这两种错误，并且使用异常机制来处理两者，Rust 没有异常，而为可恢复错误提供了类型 `Result<T, E>`，并且在程序遇到不可以恢复错误时提供了 `panic!` 宏。

## 1. Unrecoverable Errors with `panic!`

有两种情况会造成 panic：执行导致代码 panic 的操作（比如访问数组越界）或者显式调用 `panic!` 宏。默认情况下，这些 panic 会打印一条失败信息，进行栈展开，回溯并清理栈然后退出。通过环境变量，还可以让 Rust 在 panic 发生时显示调用栈，以便更容易地追踪 panic 的来源。回溯并且清理栈是一项耗费资源的操作，Rust 允许你选择在 panic 发生时直接中止程序。如果在发布的时候，你希望 panic 时直接中止程序，可以在 `Cargo.toml` 文件的 `[profile]` 部分添加 `panic = 'abort'`。

```toml
[profile.release]
panic = 'abort'
```

下面是几个会 panic 的示例：

```rust
fn call_panic() {
    panic!("crash and burn");
}

fn passive_panic() {
    let v = vec![1, 2, 3];
    v[99];
}

fn main() {
    call_panic();
    passive_panic();
}
```

设置 `RUST_BACKTRACE` 环境变量为除了 0 以外的值，可以显示 panic 的回溯信息。

比如原来对于数组越界长生的 panic 信息是：

```
$ cargo run
   Compiling panic v0.1.0 (file:///projects/panic)
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.27s
     Running `target/debug/panic`

thread 'main' panicked at src/main.rs:4:6:
index out of bounds: the len is 3 but the index is 99
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

设置 `RUST_BACKTRACE` 环境变量为 1 后，会显示 panic 的回溯信息：

```
$ RUST_BACKTRACE=1 cargo run
thread 'main' panicked at src/main.rs:4:6:
index out of bounds: the len is 3 but the index is 99
stack backtrace:
   0: rust_begin_unwind
             at /rustc/4d91de4e48198da2e33413efdcd9cd2cc0c46688/library/std/src/panicking.rs:692:5
   1: core::panicking::panic_fmt
             at /rustc/4d91de4e48198da2e33413efdcd9cd2cc0c46688/library/core/src/panicking.rs:75:14
   2: core::panicking::panic_bounds_check
             at /rustc/4d91de4e48198da2e33413efdcd9cd2cc0c46688/library/core/src/panicking.rs:273:5
   3: <usize as core::slice::index::SliceIndex<[T]>>::index
             at file:///home/.rustup/toolchains/1.85/lib/rustlib/src/rust/library/core/src/slice/index.rs:274:10
   4: core::slice::index::<impl core::ops::index::Index<I> for [T]>::index
             at file:///home/.rustup/toolchains/1.85/lib/rustlib/src/rust/library/core/src/slice/index.rs:16:9
   5: <alloc::vec::Vec<T,A> as core::ops::index::Index<I>>::index
             at file:///home/.rustup/toolchains/1.85/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs:3361:9
   6: panic::main
             at ./src/main.rs:4:6
   7: core::ops::function::FnOnce::call_once
             at file:///home/.rustup/toolchains/1.85/lib/rustlib/src/rust/library/core/src/ops/function.rs:250:5
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
```

具体输出随着操作系统和 Rust 版本而异，为了获得这些信息，必须启用调试符号，使用 `cargo build` 或者不带 `--release` 标志的 `cargo run` 时，默认启用调试符号。

!!! Note "`panic!` 的基本原理"

    TBD

## 2. Recoverable Errors with `Result`


```rs
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let file_result = File::open("hello.txt");

    let file = match file_result {
        Ok(file) => file,
        Err(e) => match e.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            _ => panic!("Problem opening the file: {:?}", e),
        },
    };
}
```

```rs
fn main() {
    let file_result = File::open("hello.txt");
    let file_expect = file_result.expect("Failed to open hello.txt");
    let file_unwrap = file_result.unwrap();
    let file_unwrap_or_else = file_result.unwrap_or_else(|e| {
        if e.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|e| {
                panic!("Problem creating the file: {:?}", e);
            })
        } else {
            panic!("Problem opening the file: {:?}", e);
        }
    });
}
```

```rs
use std::fs::File;
use std::io::{self, Read};

fn read_user_name() -> Result<String, io::Error> {
    let file_result = File::open("hello.txt");

    let mut user_name = match file_result {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut contents = String::new();
    match user_name.read_to_string(&mut contents) {
        Ok(size) => Ok(contents),
        Err(e) => Err(e),
    }
}
```

上述的代码虽然完备，但是有些冗长，Rust 也经常使用这种错误处理方式，因此提供了 `?` 运算符，可以简化错误处理。简单来讲，其定义就是上面代码第一个 `match` 的语法糖：如果 `Result` 的值是 `Ok`，则 `Ok` 中的值将从表达式之中返回，程序继续执行，如果 `Result` 的值是 `Err`，则 `Err` 中的值将作为整个函数的返回值被返回，就好像使用了 `return` 一样，从而将错误传播到调用代码（调用的上一层）。

但是对被使用 `?` 运算符调用了的错误值会经过 `from` 函数，其定义在标准库中的 `From` 特征/Trait 之中，当 `?` 运算符调用 `from` 函数时，接收到的错误类型会**被转换为当前函数返回类型中定义的错误类型**。

```rs
fn read_user_name() -> Result<String, io::Error> {
    let mut username = String::new();
    let mut username_file = File::open("hello.txt")?;
    username_file.read_to_string(&mut username)?;
    // or: File::open("hello.txt")?.read_to_string(&mut username)?;
    Ok(username)
}
```

但是 `?` 运算符只能用在返回类型与 `?` 所**作用的值兼容的函数**之中，这是因为 `?` 运算符被定义为将值提前从函数返回。这就是说，我们**只能**在返回 `Result`、`Option` 或者实现了 `FromResidual` 的类型的函数之中使用 `?` 运算符。

对类型为 `Option<T>` 的值使用 `?` 运算符时，其行为与对 `Result` 使用 `?` 运算符时类似：如果该值是 `None`，则 `None` 会从函数中提前返回，如果该值是 `Some`，则 `Some` 中的值是表达式的结果值，函数继续执行。

值得注意的是，**`main` 函数不止可以返回 `()`，还可以返回 `Result<(), E>`**，当 `main` 函数返回 `Result<(), E>` 时，`main` 函数的结尾应该手动添加一个 `Ok(())` 来表示成功。如果 `main` 函数返回 `Ok(())`，则程序会以 `0` 值退出，如果 `main` 函数返回 `Err(e)`，则程序会以非 `0` 值退出。

更确切地说，`main` 函数可以返回任何实现了 `std::process::Termination` 特征的类型，该特征包含一个名为 `report` 的函数，该函数返回一个 `ExitCode` 类型。`()` 和 `Result<T, E>` 都实现了 `Termination` 特征，因此可以作为 `main` 函数的返回值。我们可以自定义实现别的类型，使得其可以作为 `main` 函数的返回值。

```rs
use std::process::{ExitCode, Termination};

enum CliResult {
    Success,
    InternalError,
}

impl Termination for CliResult {
    fn report(self) -> ExitCode {
        let code = match self {
            CliResult::Success => 0,
            CliResult::InternalError => 1,
        };
        ExitCode::from(code)
    }
}

fn main() -> CliResult {
    let args: Vec<String> = env::args().collect();
    if something_wrong() {
        return CliResult::InternalError;
    }
    CliResult::Success
}
```

## 3. Error Handling Patterns

## 4. Writing Automated Tests

Rust 中的测试是一个使用 `#[test]` **属性标注**的**函数**，属性是关于 Rust 代码的元数据，`#[test]` 属性告诉 Rust 这是一个测试函数，当使用 `cargo test` 命令运行测试时，Rust 会构建一个测试运行器程序，该程序会运行被标注的函数，并报告测试通过或者失败。

这里的 `tests` 是一个常规模块，也是一个内部模块，我们需要将外部模块之中被测试的代码引入内部模块的作用域，使用 `use super::*;` 引入父模块对当前模块可见的所有项，这里可见项说明是父模块具有 `pub` 可见性或者具有默认可见性的项。


```rs
pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

fn panic_add(left: u64, right: u64) -> u64 {
    panic!("This function will panic");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }

    #[test]
    #[should_panic(expected = "This function will panic")]
    fn it_works_with_panic() {
        panic_add(2, 2);
    }
}
```

常见的测试使用的东西如下：

- `assert!`：断言一个条件为真，不然就 panic；
- `assert_eq!(left, right)`：断言两个值相等，不然就 panic；
- `assert_ne!(left, right)`：断言两个值不相等，不然就 panic；
- `should_panic`：在函数上面添加属性 `#[should_panic]`，如果函数 panic，则测试通过，否则测试失败，但是这样的测试可能不精确，可以添加 `expected` 参数来指定预期的 panic 信息。

但是 `assert_eq!` 和 `assert_ne!` 分别使用了 `==` 和 `!=` 运算符，也使用调试格式化打印其参数，因此需要实现 `PartialEq` 特征和 `Debug` 特征。所有原始类型和大多数标准库类型都实现这些特征，这两个特征也都是可派生特征，可以使用 `#[derive(PartialEq, Debug)]` 派生宏自动实现。

还可以编写返回 `Result<T, E>` 的测试，在测试通过的时候，返回 `Ok(T)`，在测试失败的时候，返回 `Err(E)`。但是需要注意的是，如果断言一个操作返回一个 `Err`，那么应该使用 `assert!(result.is_err())` 而不是直接使用 `?`，因为 `?` 会直接返回 `Err`，导致原本期待正确返回 `Err` 的测试失败。

```rs
    #[test]
    fn it_works() -> Result<(), String> {
        let result = add(2, 2);

        if result == 4 {
            Ok(())
        } else {
            Err(String::from("two plus two does not equal four"))
        }
    }
```



## 5. Test Organization

## 6. Thread-based Concurrency

## 7. Message Passing

## 8. Shared-State Concurrency

## 9. Async/Await Fundamentals

## 10. Futures and Streams

