# 第二部分：函数即对象

## 七、函数是一等对象

### 高阶函数

接受函数作为参数或者将函数作为结果返回的函数是高阶函数，比如 `map` 函数和 `sorted` 函数。我们经常使用的内置高阶函数为 `map`、`filter` 和 `reduce` 函数（其中 `reduce` 函数从 Python 3.0 开始被移到了 `functools` 模块中）：

- `map` 接受一个函数和可迭代对象作为参数，返回一个将函数应用于可迭代对象的每个元素后得到的结果组成的迭代器（生成器）。
- `filter` 接受一个函数和可迭代对象作为参数，返回将函数应用于可迭代对象的每个元素后得到的结果为 `True` 的元素组成的迭代器（生成器）。
- `reduce` 接受一个函数和可迭代对象作为参数，这个函数必须接受两个参数，`reduce` 将函数从前到后依次应用到可迭代对象的每个元素上，并返回最终的结果。

其中 `map` 和 `filter` 函数的替代品是现代的生成器表达式，比如：

- `#!python map(factorial, range(10))` 等价于 `#!python (factorial(n) for n in range(10))`
- `#!python filter(lambda n: n % 2 == 0, range(10))` 等价于 `#!python (n for n in range(10) if n % 2 == 0)`

### 可调用对象

Python 3.9 开始，可调用对象有九种：

- **用户定义的函数**：比如使用 `def` 语句或者 `lambda` 表达式定义的函数；
- **内置函数**：比如 CPython 使用 C 语言实现的函数，比如 `len` 或者 `time.strftime`；
- **内置方法**：使用 C 语言实现的方法，比如 `dict.get`；
- **方法**：在类主体中定义的函数；
- **类**：调用类的时候运行类的 `__new__` 方法创建一个实例，然后运行 `__init__` 方法初始化实例，最后将实例返回给调用方。Python 中没有 `new` 运算符，调用类就相当于调用函数；
- **类实例**：如果类实现了 `__call__` 方法，那么这个类的实例也可以作为函数调用；
- **生成器函数**：主体中有 `yield` 关键字的函数或者方法，调用生成器函数返回一个生成器对象；
- **原生协程函数**：使用 `async def` 定义的函数或者方法，调用原生协程函数返回一个协程对象；
- **异步生成器函数**：使用 `async def` 定义，主体中含有 `yield` 关键字的函数或者方法，调用异步生成器函数返回一个异步生成器对象，供 `async for` 使用；

### 位置参数和关键字参数

对于如下的声明：`#!python def tag(name, *content, cls=None, **attrs)`，重温一下关于 `*` 和 `**` 的解包操作：

- `*content` 将第一个参数后面任意数量的参数捕获到 `content` 中，并将其转换为元组；
- `**attrs` 将最后一个参数后面没有指定名称的关键字参数捕获到 `attrs` 中，并将其转换为字典。

这时注意到，`cls` 参数就只能使用关键字参数来指定，而不能使用位置参数来指定，否则就会被捕获到 `content` 中。在定义函数的时候，如果想指定仅限关键字参数，那么就要将其放在带有 `*` 的参数后面（因为带有 `*` 的参数其实做的是一个解包操作），如果不想支持数量不定的位置参数，就可以在签名中放一个 `*` 来指定仅限关键字参数：`#!python def func(a, *, b=1)`，这样 `*` 后面的参数就只能使用关键字参数来指定，在前面的参数没有要求。注意仅限关键字参数不一定要有默认值。

同样，使用 `/` 来指定仅限位置参数，比如 `#!python def func(a, /, b=1)`，在 `/` 之前的参数就只能使用位置参数来指定，在 `/` 之后的参数没有要求。

### 支持函数式编程的包

`opearator` 模块

`functools.partial` 函数

## 八、函数中的类型提示

Python 在 PEP 484 中引入了渐进式类型系统，其主要性质有：可选、不在运行时捕获类型错误，不改善运行性能。

### 8.x 类型受支持的操作定义

比如，对于表达式 `#!python lambda x: x * 2` 来讲，`x` 的参数可以是数值、序列、Numpy 中的 `array` 或者所有实现或继承 `__mul__` 方法的对象。在渐进式类型系统之中，我们需要了解下面两种对类型的解读：

- **鸭子类型**：来自于印第安纳诗人的一句话：当我看到一只鸟，它走路像鸭子、游泳像鸭子、叫声像鸭子，我就称其为鸭子。对象有类型，但是变量和参数没有类型。核心思想是为对象的声明的类型无关紧要，重要的是对象具体支持什么操作。如果对象 `birdle` 可以调用方法 `.quack()`，那么 `birdle` 就是一个鸭子。只有在运行时尝试操作对象的时候，才会施行鸭子类型相关的检查。
- **名义类型/Nominal Typing**：带注释的 Python 支持这种类型。对象和参数都具有类型，但是对象只存在于运行时，类型检查工具只关心使用类型提示注释变量的源码。

名义类型比鸭子类型更加严格但是死板，优点是可以更早捕获一些错误。实际上鸭子类型是结构类型/Structural Typing 的一种内隐形式，我们在后面会更详细讲解。

## 九、装饰器和闭包

### 9.1 装饰器基础

简单来说，装饰器是一种可调用对象，其参数是另一个函数。装饰器可能会对被装饰的函数做一些处理，然后返回函数，或者将函数替换成另一个函数或者可调用对象。以下两种写法等价，当运行完毕之后，`target` 就将绑定到 `decorate(target)` 返回的函数上：

```py
@decorate
def target():
    print('running target()')

target = decorate(target)

def decorate(func):
    def inner():
        print('running inner()')
    return inner
```

这时，如果我们调用 `target()`，实际上输出的是 `running inner()`，如果我们在控制台检查 `target`，那么会得到 `<function __main__.decorate.<locals>.inner()>`，意味着其实 `target` 现在只是 `inner` 函数的一个引用。

装饰器有下面三个基本性质，其中第三点是装饰器的关键：

- 装饰器是一个函数或者其他可调用对象；
- 装饰器可将被装饰的函数替换成别的函数；
- 装饰器在被装饰的函数被定义的时候，在加载模块时立即执行。

第三点的前半段可以直接推出后半段，比如我们定义一个这样的模块：

```py
registry = []

def register(func):
    print(f'running register({func})')
    registry.append(func)
    return func

@register
def f1():
    print('running f1()')

def f2():
    print('running f2()')

def main():
    print('running main()')
    print('registry ->', registry)

if __name__ == '__main__':
    main()
```

如果我们在另一个程序中导入这个模块，那么我们可以直接看见 `running register(<function f1 at 0x...>)` 这样的输出，这就意味着 `register` 装饰器在加载模块时立即执行了。

### 9.2 变量作用域与闭包

考察下面代码：

```py
>>> b = 6
>>> def f1(a):
...     print(a)
...     print(b)
...     b = 9
... 
>>> f1(3)
3
UnboundLocalError: local variable 'b' referenced before assignment

>>> def f2(a):
...     global b
...     print(a)
...     print(b)
...     b = 9
...
>>> f2(3)
3
6
>>> b
9
```

上述代码出现了两种作用域：

- 模块全局作用域：在类或者函数块外部分配值的名称；
- 函数局部作用域：通过参数或者在函数主体内直接分配值的名称。

对于函数 `f1`，Python 判断 `b` 是局部变量，因为在函数内对其进行了赋值，因此会尝试从局部作用域中获取 `b`，但是发现 `b` 没有绑定值，于是抛出 `UnboundLocalError` 错误。而使用 `global` 声明的 `b` 被解释器认为是全局变量，并且对其分配一个新值。

总结地说，Python 字节码编译器按照如下规则获取函数主体中出现的变量 `x`：

- 如果是 `global x` 声明，那么 `x` 来自模块全局作用域，并且赋予那个作用域中 `x` 的值；
- 如果是 `nonlocal x` 声明，那么 `x` 来自最近一个定义它的外层函数，并且赋予那个函数中局部变量 `x` 的值；
- 如果 `x` 是参数，或者在函数主体中赋值，那么 `x` 就是局部变量；
- 如果引用了 `x` 但是没有赋值也不是参数，那么按照如下规则查找：
    - 在外层函数主体的作用域中查找 `x`；
    - 如果外层函数主体中未找到，那么从模块全局作用域内获取；
    - 如果在模块全局作用域内没有找到，那么从 `__builtins__.__dict__` 中获取。

Python 融合了很多函数式语言的想法，类似的想法可以参考编译原理等课程的一些知识一起理解。

对于 `nonlocal` 声明，我们可以通过闭包来理解。闭包是延伸了作用域的函数，包含函数主体中引用的非全局变量和局部变量，这些变量必须来自包含 `f` 的外部函数的局部作用域。考察下面代码：

```py
def make_averager_list():
    series = []

    def averager(new_value):
        series.append(new_value)
        total = sum(series)
        return total / len(series)

    return averager

avg = make_averager_list()
```

在这里定义的 `averager` 函数中，`series` 是**自由变量/Free Variable**，指的是未在局部作用域中绑定的变量。Python 在 `__code__` 属性中保存局部变量和自由变量的名称，查看 `avg.__code__.co_freevars` 可以得到 `('series',)`，表示 `series` 是自由变量。

<img class="center-picture" src="./assets/9-1.webp" alt="Python 自由变量" width=600>

```py
def make_averager_numeric():
    count = 0
    total = 0

    def averager(new_value):
        nonlocal count, total
        count += 1
        total += new_value
        return total / count

    return averager
```

这里对于 `averager` 中的 `count` 和 `total` 使用 `nonlocal` 声明是必要的，因为 `count += 1` 实际上是 `count = count + 1`，对 `count` 进行了重新赋值，会按照局部变量进行处理，因此如果没有 `nonlocal` 声明，就会出现 `Reference before assignment` 错误。

上一个例子中，我们其实利用了列表是可变对象的事实，`.append` 方法对其进行了更新。而数值、字符串和元组是不可变类型，只能读取不能更新，这样就清晰解释了 `count` 实际上会被隐式地创建成局部变量，不是自由变量，不会被保存到闭包之中。`nonlocal` 声明实际上是将变量标记成自由变量，如果其被赋予新值，闭包中保存的绑定也会被更新。

最后仍需注意，只有嵌套在其他函数中的函数才可能需要处理不在全局作用域中的外部变量，这些外部变量位于外层函数的局部作用域中。

### 9.3 装饰器的实现例子

```py
import time

def clock(func):
    def clocked(*args):
        t0 = time.perf_counter()
        result = func(*args)
        elapsed = time.perf_counter() - t0
        name = func.__name__
        arg_str = ', '.join(repr(arg) for arg in args)
        print(f'[{elapsed:0.8f}s] {name}({arg_str}) -> {result!r}')
        return result
    return clocked

@clock
def factorial(n):
    return 1 if n < 2 else n * factorial(n - 1)
```

查询 `factorial.__name__` 可以得到 `'clocked'`，此后每次调用 `factorial` 都会执行 `clocked` 函数，而其做的是下面几件事：

- 记录初始时间 `t0`；
- 调用原来的 `factorial` 函数，保存结果；
- 计算运行时间 `elapsed`；
- 格式化结果并且打印；
- 返回第二步的结果。

这就是装饰器的标准行为：将被装饰的函数替换成新函数，新函数接受的参数和被装饰的函数一样，通常返回被装饰的函数原本该返回的值，同时会做一些额外操作。

但是注意，我们现在实现的装饰器不支持关键字参数，而且遮盖了被装饰函数的 `__name__` 和 `__doc__` 属性。我们可以使用 `functools.wraps` 装饰器来修复这个问题：

```py
import functools, time

def clock(func):
    @functools.wraps(func)
    def clocked(*args, **kwargs):
        t0 = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - t0
        name = func.__name__
        arg_lst = [repr(arg) for arg in args]
        arg_lst.extend(f'{k}={v!r}' for k, v in kwargs.items())
        arg_str = ', '.join(arg_lst)
        print(f'[{elapsed:0.8f}s] {name}({arg_str}) -> {result!r}')
        return result
    return clocked
```

Effective Python 建议始终使用 `functools.wraps` 装饰器。

### 9.4 标准库中的装饰器

`functools.cache` 装饰器：

`functools.lru_cache` 装饰器：

`functools.singledispatch` 装饰器：

### 9.5 参数化装饰器

## 十、使用一等函数实现设计模式


