# Swift

## Table of Contents

- [Basic Syntax](./1%20Basic.md)
- [Function and Code Organization](./2%20Function.md)
- [Object-Oriented Programming](./3%20Objects.md)
- [Abstraction and Generics](./4%20Abstraction.md)
- [Robustness and Concurrency](./5%20Concurrency.md)
- [Advanced Topics](./6%20Advanced.md)

<!-- 闭包：可以在代码中被传递和使用的自包含的功能代码块，类似于 Lambda 表达式和匿名函数，我们通过代码展示语法：

```swift
let closure = { (number: Int) -> Int in
    let result = 3 * number
    return result
}
```

也就是使用 `{ }` 包裹的代码块，其中 `(number: Int) -> Int` 表示闭包的参数和返回值类型，`in` 将参数和返回类型与代码块分隔开，`return` 表示返回值。当闭包的类型已知的时候，可以省略参数类型、返回类型或者干脆全都省略，单语句闭包会直接返回其唯一语句的值，甚至还可以使用 `$0` 来表示第一个参数，`$1` 来表示第二个参数，以此类推。

- `#!swift let mappedNums = numbers.map({ number in 3 * number })`
- `#!swift let sortedNums = numbers.sorted { $0 > $1 }` -->









