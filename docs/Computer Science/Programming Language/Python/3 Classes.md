# 第三部分：类和协议

## 十一、Python 风格对象

Python 中用户自定义的行为可以像内置类型一样自然，这得益于鸭子类型而不是继承，只需要用户按照预定行为实现对象所需的方法即可。这一节接续第一节，我们关注如何实现很多 Python 类型中常见的特殊方法，设计类型转换需要的内置函数，可读属性，可哈希化，`__slots__` 优化，以及私有属性、类方法与静态方法等内容。

### 11.1 对象表示形式

先不考虑重载 `*` 等运算符，这些我们会在第 16 节讨论。我们讨论一些常见的特殊方法。首先，回忆一下 `__repr__` 和 `__str__` 方法，它们分别以便于开发者理解的方式返回对象的字符串表示，以及被 `print` 函数调用。

`__bytes__` 方法和 `__str__` 方法类似，只不过是 `bytes()` 函数调用其获取对象的字节序列表示形式。`__format__` 方法被格式化字符串、`format()` 函数和 `str.format()` 方法调用，使用 `obj.__format__(format_spec)` 以特殊的格式化代码显示对象的字符串表示形式。对于之前实现的 `Vector2d` 类，我们接下来实现 `__format__` 方法和 `__bytes__` 方法：

```py
from array import array

class Vector2d:
    typecode = 'd'

    def __init__(self, x, y):
        self.x = float(x)
        self.y = float(y)
        
    def __eq__(self, other):
        return tuple(self) == tuple(other)

    def __repr__(self):
        class_name = type(self).__name__
        return f"{class_name}({self.x!r}, {self.y!r})"

    def __str__(self):
        return str(tuple(self))

    def __bytes__(self):
        return bytes([ord(self.typecode)]) + bytes(array(self.typecode, self))

    def __format__(self, fmt_spec=''):
        if fmt_spec.endswith('p'):
            fmt_spec = fmt_spec[:-1]
            coords = (abs(self.x), abs(self.y))
            outer_fmt = '<{}, {}>'
        else:
            coords = self
            outer_fmt = '({}, {})'
        components = (format(c, fmt_spec) for c in coords)
        return outer_fmt.format(*components)
```

其中 `__bytes__` 首先将 `typecode` 转换为字节序列，然后迭代这个 `Vector2d` 实例。得到一个数组，再讲数组按照 `typecode` 转换为字节序列。简单看一下 `__format__` 其实也可以发现，这里也对 `Vector2d` 实例进行了迭代，这就要求我们实现 `__iter__` 方法。

```py
class Vector2d:
    ...
    def __iter__(self):
        return (i for i in (self.x, self.y))
        # or yield self.x; yield self.y
```

这样实现的 `Vector2d` 实例就可以被用于拆包和迭代了。

接下来是关于 `__format__` 方法的实现：

### 11.2 备选构造函数

注意到 `Vector2d` 类中，我们定义了转化为 `bytes` 的 `__bytes__` 方法，这个方法实现的目标实现 `bytes` 与 `Vector2d` 实例的相互转化，因而我们希望实现另一边的转化，下面我们实现 `frombytes` 方法，并将这个方法实现成一个类方法：

```py
class Vector2d:
    ...
    @classmethod
    def frombytes(cls, octets):
        typecode = chr(octets[0])
        memv = memoryview(octets[1:]).cast(typecode)
        return cls(*memv)
```

`@classmethod` 装饰器装饰的方法可以直接在类上调用，其第一个参数永远是类本身，习惯性命名为 `cls`，并且 `cls` 一定是一个位置参数。

这样我们就实现了一个备选构造函数，可以用于从 `bytes` 转换为 `Vector2d` 实例。

### 11.3 `classmethod` 与 `staticmethod`

这一部分可以参考十二年前的一个技术博客：[The Definitive Guide on How to Use Static, Class or Abstract Methods on Python](https://dzone.com/articles/definitive-guide-how-use)。简而言之，`@classmethod` 定义的方法是操作类而不是操作实例的方法，其改变了调用方法的方式，因此接收的第一个参数是永远是类本身，而不是实例。

`@staticmethod` 定义的方法也会改变方法的调用方式，但是第一个参数没有变化。静态方法就是一般的函数，只是碰巧放在类的定义体中，而不是在模块层面。作者认为 `@classmethod` 装饰器非常有用，但是 `@staticmethod` 装饰器几乎不存在必须使用的情况。下面是一个简单的例子：

???- Info "Simple Example"

    ```py
    >>> class Demo:
    ...     @classmethod
    ...     def klassmeth(*args):
    ...         return args
    ...     @staticmethod
    ...     def statmeth(*args):
    ...         return args
    ...
    >>> Demo.klassmeth()
    (<class '__main__.Demo'>,)
    >>> Demo.klassmeth('spam')
    (<class '__main__.Demo'>, 'spam')
    >>> Demo.statmeth()
    ()
    >>> Demo.statmeth('spam')
    ('spam',)
    ```

### 11.4 可哈希化

回忆可哈希化的定义，我们需要实现 `__hash__` 方法和 `__eq__` 方法，注意到 `__eq__` 方法我们已经实现过了，只需要实现 `__hash__` 方法。同时我们需要让向量实例不可变，因此我们需要将 `x` 分量和 `y` 分量实现成只读属性，继续修改 `Vector2d` 类，并且加上 `@property` 装饰器：

```py
class Vector2d:
    typecode = 'd'

    def __init__(self, x, y):
        self.__x = float(x)
        self.__y = float(y)

    @property
    def x(self):
        return self.__x

    @property
    def y(self):
        return self.__y
    
    def __iter__(self):
        return (i for i in (self.x, self.y))

    def __hash__(self):
        return hash((self.x, self.y))
```

我们进行了如下修改：

- 使用两个前导下划线（尾部不能有下划线或者只有一个下划线）将属性标记成私有；
- 使用 `@property` 装饰器将读取方法标记为特性/Property，读值属性与公开属性同名，都是 `x` 和 `y`，但是对应的方法需要直接返回 `__x` 和 `__y` 的值；
- 需要读取 `x` 和 `y` 分量的值的方法可以保持不变，可以通过 `self.x` 和 `self.y` 读取公开特性，而不需要读取私有属性。
- 实现 `__hash__` 方法直接借用了元组可以哈希化的特性。

注意到创建可哈希的类型并不一定需要实现特性，也不一定需要保护实例属性，但是可哈希对象的值一定不应该变化，我们因此提到了只读特性。

### 11.5 私有属性与覆盖类属性

Python 实现了名为**名称改写/Name Mangling** 的语言功能：如果以带有两个前导下划线（尾部没有下划线或者只有一个下划线）的形式命名实例属性，那么 Python 会自动将属性名改写，在前面加上 `_` 和类名，存入实例的 `__dict__` 属性中。比如：

```py
>>> class Demo:
...     def __init__(self, x, y):
...         self.__x = x
...         self.__y = y
...
>>> Demo(12, 13).__dict__
{'_Demo__x': 12, '_Demo__y': 13}
```

因此，如果我们在类中定义了 `__x` 和 `__y` 属性，那么我们无法通过 `Demo().__x` 访问到 `__x` 属性，但是可以通过 `Demo()._Demo__x` 访问。因此我们可以看出来，名称改写其实只能防止意外访问，但是不能阻止蓄意做错事。

很多人不喜欢这样的特殊句法，约定使用一个下划线前缀编写受保护的属性（比如 `self._x`），并且认为应该使用命名约定来避免意外覆盖属性。一般来说，Python 解释器不会对但下划线开头的属性名做特殊处理，但是这是很多 Python 开发者严格遵守的约定，他们不会在类的外部访问这种属性。值得注意的是，在模块中，如果使用 `from my_module import *` 导入模块，那么所有以单下划线开头的名称 `_x` 不会被导入，但是可以 `from my_module import _x` 导入。

总之，无论是单下划线还是双下划线，我们的实现似乎都不是真正的私有和不可变，但这对开发来说已经足够了。

注意一下我们在 `Vector2d` 类中设置了类属性 `typecode`，在 `__bytes__` 方法中使用了这个属性：由于每一个 `Vector2d` 实例本身没有这个属性，所以默认会获取 `Vector2d.typecode` 类属性的值。如果为不存在的实例属性赋值，那么会创建一个新的实例属性，假如我们为一个 `Vector2d` 实例 `v` 赋值 `v.typecode = 'f'`，那么 `v.typecode` 实际上读取的是实例属性 `'f'`，而同名类属性不受影响。

另一种方法是使用继承：

```py
class ShortVector2d(Vector2d):
    typecode = 'f'
```

这样我们将 `ShortVector2d` 类定义为 `Vector2d` 类的子类，并且重写了 `typecode` 类属性，这样 `ShortVector2d` 实例将使用 `'f'` 类型代码。

### 11.6 `__slots__` 优化

### 11.7 位置模式匹配

## 十二、序列的特殊方法

## 十三、接口、协议和抽象基类

从 Python 3.8 开始，Python 接口的定义和使用方式有如下四种，其中鸭子类型、静态类型我们已经谈过，我们在这里主要探讨大鹅类型和静态鸭子类型。

<img class="center-picture" src="./assets/13-1.webp" width=550>

## 十四、继承

## 十五、类型提示进阶

## 十六、运算符重载


