# 备忘知识

## 1 内置类型

### 1.2 序列类型

#### 通用序列操作

> 可见 [Sequence Types — list, tuple, range](https://docs.python.org/3/library/stdtypes.html#sequence-types-list-tuple-range)
>
> 也可见 [collections.abc — Abstract Base Classes for Containers](https://docs.python.org/zh-cn/3/library/collections.abc.html#collections.abc.Sequence)

大多数序列类型，无论是可变类型还是不可变类型都支持下表中的操作，这里的 `s` 和 `t` 都是具有相同类型的序列，`n`，`i`，`j`，`k` 是整数，`x` 是满足序列定义的任何元素。

- `x in s` 如果 `s` 中的某项等于 `x`，则返回 `True`，否则返回 `False`；在 `str` 与 `bytes`、`bytearray` 类型中，这也可以用于检查子序列：`'ab' in 'abc'` 返回 `True`。
- `x not in s` 如果 `s` 中的某项等于 `x`，则返回 `False`，否则返回 `True`。
- `s + t` 返回 `s` 和 `t` 拼接的序列。
    - 某些序列类型仅仅支持特定模式的项序列，因此不支持序列拼接或者重复，比如 `range`。
    - 拼接不可变序列总是会生成新的对象，下面是一些可以降低开销到线性的方法：
    - 对于 `str` 类型，可以使用 `str.join()` 方法，或者写入 `io.StringIO` 对象，结束的时候再获取值；
    - 对于 `bytes` 类型，可以使用 `bytes.join()` 方法，或者写入 `io.BytesIO` 对象，也可以使用 `bytearray` 对象进行原地拼接，因为 `bytearray` 是可变的，并且有高效的重分配机制；
    - 对于 `tuple` 类型，可以改为扩展 `list` 类。
- `s * n` 或 `n * s` 返回由 `s` 的 `n` 个拷贝构成的序列。
    - 但是序列 `s` 中的项并不会被拷贝，它们会被多次引用，所以会造成下面的问题：
    ```python
    >>> lists = [[]] * 3
    >>> lists
    [[], [], []]
    >>> lists[0].append(3)
    >>> lists
    [[3], [3], [3]]
    ```
    原因是 `[[]]` 其实是一个包含了空列表的单元素列表，`* 3` 后结果的三个元素都是对这个空列表的引用，修改其中一个元素的值，其他两个也会受到影响，同时受到修改，应该修改成 `#!python lists = [[] for _ in range(3)]`；
- `s[i]` 返回序列 `s` 中的第 `i` 个元素，`i` 是整数。
- `s[i:j]` 返回序列 `s` 中的第 `i` 到 `j - 1` 个元素构成的序列，`i` 和 `j` 是整数。
    - `j` 是切片的终止位置，可以理解成尾后位置，这样的切片定义成所有满足 `i <= k < j` 的索引号 `k` 的项组成的序列。
    - 如果 `i` 或者 `j` 超出了 `len(s)`，那么会被替换为 `len(s)`。
    - 如果 `i` 被省略或者被替换成 `None`，那么会被替换为 `0`，如果 `j` 被省略或者被替换成 `None`，那么会被替换为 `len(s)`；
    - 如果 `i >= j`，那么切片为空。
- `s[i:j:k]` 返回序列 `s` 从 `i` 到 `j` 步长为 `k` 的切片，具体定义所有满足 `0 <= n < (j-i)/k` 的索引号为 `i + n * k` 的项组成的序列。如果 `i` 或 `j` 被省略或为 `None`，它们会成为“终止”，比如我们常用的 `s[::-1]` 就会得到一个反转的列表。
- `len(s)` 返回序列 `s` 的长度。
- `max(s)`/`min(s)` 返回序列 `s` 中的最大/最小值；如果序列为空，会抛出 `ValueError`。
- `s.index(x[, i[, j]])`: `x` 在 `s` 中首次出现项的索引号，后面两个是可选参数，分别表示在 `i` 之后和在 `j` 之前搜索。
    - 如果 `x` 不在 `s` 中，会抛出 `ValueError`。
- `s.count(x)` 返回 `x` 在 `s` 中出现的次数，没出现就会返回 `0`。


### 文本序列类型

#### `str` 类型

Python 中的 `str` 是 Unicode 码位的构成的不可变序列。字符串字面值允许多种写法：

- 单引号：`'allows embedded "double" quotes'`；
- 双引号：`"allows embedded 'single' quotes"`；
- 三重引号：`'''Three single quotes'''` 或 `"""Three double quotes"""`。

使用三重引号的字符串字面值可以跨越多行，所有的空白（包括换行符）都会被包含在字符串中，可以使用 `\` 来避免这种情况。

#### 格式字符串/f-string

> 见 [f-strings from Python documentation](https://docs.python.org/3.11/reference/lexical_analysis.html#formatted-string-literals)


### 二进制序列类型



### 类型转化

## File I/O

打开文件首先要使用 `open()` 函数，`open(filename, mode, encoding="utf-8")` 会返回一个 file object：第一个参数是包含了文件名的字符串；第二个参数是指定了文件使用方式的字符串，常见的有：

- `r`：只读模式（默认）；
- `w`：只写模式，创建新文件（覆盖同名文件），并且先截断文件；
- `a`：追加模式，打开一个文件用于追加到末尾，如果文件不存在则创建；
- `*b`：`b` 作为后缀，表示二进制模式；
- `+`：读写模式，打开用于更新；
- `t`：文本模式（默认）；

默认的参数是 `r` 并且与 `rt` 同义，也就是通常情况下，文件是以 text mode 模式打开的，从文件中读写字符串，这些字符串是以特定的形式编码的，返回参数都是 `str`，可以在 `open()` 函数中指定 `encoding` 参数来指定编码方式，不然就以平台默认的字节编码解码。
