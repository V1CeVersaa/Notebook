# 第一部分：Python 数据结构

## 一、Python 数据模型

Python 解释器通过调用特殊方法来执行对象基本操作，特殊方法的名称两端都有双下划线，比如我们在使用 `[]` 来访问元素的时候，其实背后提供支持的是 `__getitem__` 方法，运算符重载的实现就是通过重写这些特殊方法。

??? Info "Code"

    ```python
    class Vector:
        def __init__(self, x=0, y=0):
            self.x = x
            self.y = y

        def __repr__(self):
            return f"Vector({self.x!r}, {self.y!r})"

        def __abs__(self):
            return math.hypot(self.x, self.y)

        def __bool__(self):
            return bool(abs(self))

        def __add__(self, other):
            x = self.x + other.x
            y = self.y + other.y
            return Vector(x, y)

        def __mul__(self, scalar):
            return Vector(self.x * scalar, self.y * scalar)

        def __rmul__(self, scalar):
            return self * scalar
    ```

下面是 Python 特殊方法的列表：

???- Info "Python 特殊方法"

    首先是不包含运算符的特殊方法：

    - 字符串（字节）表示方式：`__repr__`、`__str__`、`__format__`、`__bytes__`、`__fspath__`；
    - 数值转换：`__bool__`、`__complex__`、`__int__`、`__float__`、`__hash__`、`__index__`；
    - 模拟容器：`__len__`、`__getitem__`、`__setitem__`、`__delitem__`、`__contains__`；
    - 迭代：`__iter__`、`__aiter__`、`__next__`、`__anext__`、`__reversed__`；
    - 可调用对象：`__call__`、`__await__`；
    - 上下文管理：`__enter__`、`__exit__`、`__aexit__`、`__aenter__`；
    - 实例创建和销毁：`__new__`、`__init__`、`__del__`；
    - 属性管理：`__getattr__`、`__getattribute__`、`__setattr__`、`__delattr__`、`__dir__`；
    - 属性描述符：`__get__`、`__set__`、`__delete__`、`__set_name__`；
    - 抽象基类：`__instancecheck__`、`__subclasscheck__`；
    - 类元编程：`__prepare__`、`__init_subclass__`、`__class_getitem__`、`__mro_entries__`；

    下面是包含运算符的特殊方法：

    - 一元数值运算：`__neg__`（`-`）、`__pos__`（`+`）、`__abs__`（`abs()`）；
    - 比较运算：`__lt__`（`<`）、`__le__`（`<=`）、`__eq__`（`==`）、`__ne__`（`!=`）、`__gt__`（`>`）、`__ge__`（`>=`）；
    - 算术运算：`__add__`（`+`）、`__sub__`（`-`）、`__mul__`（`*`）、`__truediv__`（`/`）、`__floordiv__`（`//`）、`__mod__`（`%`）、`__matmul__`（`@`）、`__divmod__`（`divmod()`）、`__round__`（`round()`）、`__pow__`（`**`）；
    - 反向算术运算符（交换操作数）：`__radd__`、`__rsub__`、`__rmul__`、`__rtruediv__`、`__rfloordiv__`、`__rmod__`、`__rmatmul__`、`__rdivmod__`、`__rround__`、`__rpow__`；
    - 增量赋值算术运算符：`__iadd__`（`+=`）、`__isub__`（`-=`）、`__imul__`（`*=`）、`__itruediv__`（`/=`）、`__ifloordiv__`（`//=`）、`__imod__`（`%=`）、`__imatmul__`（`@=`）、`__ipow__`（`**=`）；
    - 位运算：`__and__`（`&`）、`__or__`（`|`）、`__xor__`（`^`）、`__lshift__`（`<<`）、`__rshift__`（`>>`）、`__invert__`（`~`）；
    - 反向位运算符（交换操作数）：`__rand__`、`__ror__`、`__rxor__`、`__rlshift__`、`__rrshift__`；
    - 增强赋值位运算符：`__iand__`（`&=`）、`__ior__`（`|=`）、`__ixor__`（`^=`）、`__ilshift__`（`<<=`）、`__irshift__`（`>>=`）；

对于 `__add__` 方法以及 `__radd__` 方法，如果第一个操作数对应的特殊方法不可用，则 Python 会尝试调用第二个操作数的 `__radd__` 方法。

Python 对象基本都需要一个可用的字符串表示方法，这在调试和交互时非常有用。`__repr__` 方法供内置函数 `repr()` 使用，获取对象的字符串表示形式，交互式控制台和调试器在表达式求值结果上就调用 `repr()` 函数。我们要求 `__repr__` 方法返回的字符串应当没有歧义。`__str__` 方法供内置函数 `str()` 使用，在背后供 `print()` 函数使用，有时候 `__repr__` 方法返回的字符串足够好，就无需定义 `__str__` 方法，因为继承自 `object` 的 `__str__` 方法最终会调用 `__repr__`。

默认情况下，用户定义的实例都是真值，除非实现了 `__bool__` 方法或者 `__len__` 方法。简单来说，`bool(x)` 会调用 `x.__bool__()`，并且以 `__bool__` 方法的返回值为准，如果没有实现 `__bool__` 方法，则尝试调用 `__len__` 方法，如果 `__len__` 方法返回 0，则 `bool(x)` 返回 `False`，否则返回 `True`。我们要求 `__bool__` 方法必须返回布尔值。

下面这张图展示了 Python 的基本容器类型的接口，图中所有的都是抽象基类：

<img class="center-picture" src="./assets/1-1.webp" alt="Python 基本容器类型接口" width=600 />

顶部三个抽象基类都只有一个特殊方法，每一个容器类型都需要实现如下事项：

- Iterable 要支持 `for`、拆包和其他迭代方式；
- Sized 要支持内置函数 `len()`；
- Container 要支持 `in` 运算符；

Python 不强制要求具体类继承这些抽象基类中的任何一个，只需要实现对应的特殊方法，就说明对应的类满足对应接口。

Collection 有三个很重要的接口：

- Sequence 规范 list 和 str 等内置类型的接口；
- Mapping 被 dict、collections.defaultdict 等实现；
- Set 规范 set、frozenset 等内置类型的接口；

并且只有 Sequence 需要实现 `__reversed__` 方法，因为需要按照各种方向排列内容。

## 二、序列

### 2.1 列表推导式与生成器表达式

### 2.2 序列与可迭代对象拆包

### 2.3 序列模式匹配

### 2.4 切片

### 2.5 `+`、`*`、`list.sort()` 和 `sorted()`

## 三、字典和集合

### 3.x 可哈希

可哈希/Hashable 在 Python 的术语表中有定义，其含义如下：如果一个对象的哈希值在整个生命周期内不改变，并且这个对象可以与其他对象相比较，那么这个对象就是可哈希的，两个可哈希对象相等当且仅当其哈希值相等。可以见的，我们需要实现 `__hash__` 方法和 `__eq__` 方法。

数值类型和不可变的扁平类型 `str`、`bytes` 都是可哈希的；如果容器类型是不可变的，并且其所含的对象都是可哈希的，那么容器自身是可哈希的。

一个对象的哈希值根据所使用的 Python 版本和设备架构有关，哈希计算过程中也有加盐操作，正确实现的对象，其哈希值在一个进程内保持不变。

## 五、数据类构建器

Python 提供了几种构建简单类的方式，这些类只是字段的容器，几乎没有额外功能，这些模式被称为数据类/Data Class，`dataclasses` 包就支持该模式。这一节介绍 `collections.namedtuple`、`typing.NamedTuple` 和 `@dataclasses.dataclass`。

### 5.1 概述

???- Info "例子"

    ```python
    class Coordinate:

        def __init__(self, lat, lon):
            self.lat = lat
            self.lon = lon


    >>> from coordinates import Coordinate
    >>> moscow = Coordinate(55.76, 37.62)
    >>> moscow
    <coordinates.Coordinate object at 0x107142f10>
    >>> location = Coordinate(55.76, 37.62)
    >>> location == moscow
    False
    >>> (location.lat, location.lon) == (moscow.lat, moscow.lon)
    True
    ```

    可以看见，这个类的实现比较简单但是失败：

    - 没有 `__repr__` 方法，从 `object` 继承的 `__repr__` 方法返回的字符串没有信息量；
    - 没有 `__eq__` 方法，从 `object` 继承的 `__eq__` 方法比较的是对象的地址/ID，而不是 `lat` 和 `lon` 的值；
    - 想要对比两个坐标是否相等，需要手动对比 `lat` 和 `lon` 的值；

    ```python
    >>> from collections import namedtuple
    >>> Coordinate = namedtuple('Coordinate', 'lat lon')
    >>> issubclass(Coordinate, tuple)
    True
    >>> moscow = Coordinate(55.756, 37.617)
    >>> moscow
    Coordinate(lat=55.756, lon=37.617)
    >>> moscow == Coordinate(lat=55.756, lon=37.617)
    True
    ```

    ```python
    >>> import typing
    >>> Coordinate = typing.NamedTuple('Coordinate',
    ...     [('lat', float), ('lon', float)])
    >>> issubclass(Coordinate, tuple)
    True
    >>> typing.get_type_hints(Coordinate)
    {'lat': <class 'float'>, 'lon': <class 'float'>}
    ```

    `typing.NamedTuple` 可以在 `class` 语句最后使用，类型注释按照 PEP 526 标准编写，这样的代码更易读。值得注意的是，虽然 `typing.NamedTuple` 位于超类的位置上，但是实际上 `typing.NamedTuple` 使用元类构建用户类。`typing.NamedTuple` 生成的 `__init__` 方法中，字段参数的顺序与在 `class` 中出现的顺序相同。

    ```python
    from typing import NamedTuple

    class Coordinate(NamedTuple):
        lat: float
        lon: float

        def __str__(self):
            ns = 'N' if self.lat >= 0 else 'S'
            we = 'E' if self.lon >= 0 else 'W'
            return f'{abs(self.lat):.1f}°{ns}, {abs(self.lon):.1f}°{we}'

    >>> issubclass(Coordinate, tuple)
    True
    >>> issubclass(Coordinate, NamedTuple)
    False
    ```

    ```python
    from dataclasses import dataclass

    @dataclass(frozen=True)
    class Coordinate:
        lat: float
        lon: float

        def __str__(self):
            ns = 'N' if self.lat >= 0 else 'S'
            we = 'E' if self.lon >= 0 else 'W'
            return f'{abs(self.lat):.1f}°{ns}, {abs(self.lon):.1f}°{we}'
    ```

简单来说，三种数据类构造器的共同点和差异如下：

<img class="center-picture" src="./assets/5-1.webp" alt="数据类构造器共同点和差异" width=600 />
