# OCaml

!!! Info 

    一直想学一门函数式编程语言，打算将这个部分写成备忘录的样子，对于一些不太好理解的东西或许会更加详细地记录一下。

OCaml 程序不需要有一个名为 `main` 的特殊函数来启动程序。通常的做法就是让文件中的最后一个定义作为启动计算的主函数。

```ocaml
let rec fact n = if n = 0 then 1 else n * fact (n - 1)

let rec pow (n : int) (m: int ) : int = if m = 1 then n else n * pow n (m - 1)
```

```ocaml
(** [even n] is whether [n] is even.
    Requires: [n >= 0]. *)
let rec even n = n = 0 || odd (n - 1)

(** [odd n] is whether [n] is odd.
    Requires: [n >= 0]. *)
and odd n = n <> 0 && even (n - 1)
```

```ocaml
let inc x = x + 1
let inc = fun x -> x + 1
```

这两种写法语法层面不同但是语义层面相等。来一个更惊人的例子：

```ocaml
let x = e1 in e2
(fun x -> e2) e1
```

这两种情况语法层面不同但是语义等价，简要说来，`let` 表达式其实就是调用匿名函数的语法糖。

> In essence, `let` expressions are just syntactic sugar for anonymous function application.

假设 `inc` 定义如上不变，再定义一个 `#!ocaml let square x = x * x`：

```ocaml
let x = square (inc 1)
let x = 5 |> inc |> square
```

但是管道运算符每侧都只能有一个参数。

There is a built-in infix operator in OCaml for function application called the pipeline operator, written |>. Imagine that as depicting a triangle pointing to the right. The metaphor is that values are sent through the pipeline from left to right. For example, suppose we have the increment function inc from above as well as a function square that squares its input:

```ocaml
let id x = x
- : val id : 'a -> 'a = <fun>

let id_int (x: int) : int = x
let id_int' : int -> int = id
```

对于多态函数，编译器会做类似于这样的处理：

```ocaml
let inc' : 'a -> 'a = fun x -> x + 1
- : val inc' : int -> int = <fun>
```

因为传递一个 bool 或 string 或一些复杂的数据结构给它是不安全的，而 `+` 可以安全操作的唯一数据是整数。因此，OCaml 将类型变量 `'a` 实例化为 `int`，从而防止我们将 `id'` 应用于非整数。

```ocaml
let func ~name1: a ~name2: b = a + b
let func ~name1:(arg1: int) ~name2:(arg2: int) = arg1 + arg2
func ~name2: 22 ~name1: 11
let func_default ?name1:(arg1 = 1) ?name2:(arg2 = 2) = arg1 + arg2
```

对于代标签的参数和可选参数，对于这样的情况分别会报 warning 和报错：

- 完全不带标签调用会报 warning：`func 1 2`

如果参数的标签和变量名相同，那么可以简写为：

```ocaml
let func ~a ~b = a + b
func ~a: 11 ~b: 22
```

部分调用：

```ocaml
let add x y = x + y
let add x = fun y -> x + y
let add = fun x -> (fun y -> x + y)
```

这三种写法还是语法层面不同，但是语义层面等价。

```ocaml
let ( ^^ ) arg1 arg2 = max arg1 arg2
```

```ocaml
[] (* called nil, a' list *)
[1; 2; 3]
1 :: 2 :: 3 :: []
```

```ocaml
let rec append lst1 lst2 =
    match lst1 with
    | [] -> lst2
    | h :: t -> h :: append t lst2
```

模式匹配语法：

```ocaml
match expr with
| pattern1 -> result1
| pattern2 -> result2
| ...
| patternN -> resultN
```

同一个变量名不能在模式中出现多次。例如，模式 `x :: x` 是非法的。通配符可以出现任意次数。

???- Info "Pattern in Documentation"

    ```ocaml
    pattern	::=	value-name
            ∣	 _
            ∣	 constant
            ∣	 pattern as value-name
            ∣	 ( pattern )
            ∣	 ( pattern : typexpr )
            ∣	 pattern | pattern
            ∣	 constr pattern
            ∣	 `tag-name pattern
            ∣	 #typeconstr
            ∣	 pattern { , pattern }+
            ∣	 { field [: typexpr] [= pattern]{ ; field [: typexpr] [= pattern] } [; _ ] [ ; ] }
            ∣	 [ pattern { ; pattern } [ ; ] ]
            ∣	 pattern :: pattern
            ∣	 [| pattern { ; pattern } [ ; ] |]
            ∣	 char-literal .. char-literal
            ∣	 lazy pattern
            ∣	 exception pattern
            ∣	 module-path .( pattern )
            ∣	 module-path .[ pattern ]
            ∣	 module-path .[| pattern |]
            ∣	 module-path .{ pattern }
    ```

关于模式匹配如何求值：

- 首先对 `expr` 进行求值，假设结果为 `v`；
- 尝试将 `v` 与 `pattern1`、`pattern2`、...、`patternN` 进行模式匹配，按照其出现在模式匹配中的顺序进行；
- 如果 `v` 没有出现在任何一个模式之中，则抛出 `Match_failure` 异常；
- 否则，令 `pattern` 为第一个与 `v` 匹配的模式，并且令 `b` 为将 `v` 匹配到 `pattern` 过程中生成的变量绑定；
- 在 `pattern` 对应的 `result` 中，将 `b` 代入其中，得到新的表达式 `result'`；
- 对 `result'` 进行求值，得到结果 `v'`；
- 整个表达式的结果就是 `v'`。

除了类型检查规则，编译器还会对**完整性/Exhaustiveness** 和 **冗余/Redundancy**/Unused Branches 进行检查：

- 完整性：编译器尝试保证至少会有一个模式可以和表达式 `expr` 进行匹配，而不论其在运行时产生了什么值，`#!ocaml let head lst = match lst with h :: _ -> h` 就会产生一个 Warning；
- 冗余：编译器会检查是否有永远都不会被匹配的模式，比如其前面的某个模式一定会匹配成功，`#!ocaml let rec sum lst = match lst with [] -> 0 | h :: t -> h + sum t | [h] -> h` 就会产生一个 Warning。

Unused Branches 一般代表着程序员写了其本不想写的内容，编译器来帮助程序员检查。

- `_ :: []` 匹配所有**恰好有一个元素**的列表
- `_ :: _` 匹配所有**至少有一个元素**的列表
- `_ :: _ :: []` 匹配所有**恰好有两个元素**的列表
- `_ :: _ :: _ :: _` 匹配所有**至少有三个元素**的列表

列表是不可变的，没有办法将列表的元素从一个值更改为另一个值。如果需要修改（真的是修改吗）列表，就需要从旧列表中创建新列表。

```ocaml
let rec inc_first lst = 
    match lst with
    | [] -> []
    | h :: t -> (h + 1) :: t
```

OCaml 中，列表的元素类型必须相同。

Variant 类似于 C 的枚举类型：

```ocaml
type day = Sun | Mon | Tue | Wed | Thu | Fri | Sat
let d = Tue
```



