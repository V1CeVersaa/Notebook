# C++ Standard Library

## 1. 容器简述

容器是一些特定类型对象的集合，顺序容器提供了控制元素存储与访问顺序的能力。在这里，我们将介绍对于所有容器都适用的操作，除此之外的仅仅针对于**顺序容器**、**关联容器**以及**无序容器**或一小部分特定容器的操作将在后续介绍。

容器均定义为模版类，需要提供额外信息来特定的容器类型，对于大多数容器，我们需要额外提供元素类型信息，比如 `vector<int>`、`list<Sales_data>` 等。容器几乎可以保存任意类型的对象，甚至可以是另一个容器。

对于一个类型为 `C` 的容器对象 `c` 来说，我们有下面操作或者属性：

- 类型别名：
    - `iterator`：此容器类型的迭代器类型；
    - `const_iterator`：可以读取元素，但是不能修改元素的迭代器类型；
    - `size_type`：无符号整数类型，足够存储容器中最大可能的元素数量；
    - `difference_type`：有符号整数类型，足够存储两个迭代器之间的距离；
    - `value_type`：容器中元素的类型；
    - `reference`：元素的左值类型，与 `value_type&` 的类型相同；
    - `const_reference`：元素的 `const` 左值类型，也就是 `const value_type&`。
- 构造函数：
    - `C c`：默认构造函数，创建一个空容器；
    - `C c(c2)`：构造 `c2` 的拷贝 `c`；
    - `C c(b, e)`：构造 `c`，并且将迭代器 `b` 和 `e` 之间的元素拷贝到 `c` 中，但是 `array` 类型的容器除外；
    - `C c{a, b, c, d}`：列表初始化 `c`。
- 赋值与交换：
    - `c = c2`：将 `c2` 中的元素拷贝给 `c`；
    - `c = {a, b, c, d}`：将 `c` 中的元素替换为列表中的元素，不适用于 `array`；
    - `c.swap(c2)`：交换 `c` 和 `c2` 中的元素；
    - `swap(c, c2)`：交换 `c` 和 `c2` 中的元素。
- 大小与容量：
    - `c.size()`：返回 `c` 中元素的数量，不支持 `forward_list`；
    - `c.max_size()`：返回 `c` 中最多可以存储的元素数量；
    - `c.empty()`：判断 `c` 是否为空，非空则返回 `false`。
- 添加与删除（不适用于 `array`）：
    - `c.insert(args)`：将 `args` 中的元素拷贝到 `c` 中；
    - `c.erase(args)`：删除 `args` 中指定的元素；
    - `c.emplace(inits)`：使用 `inits` 在 `c` 中构造一个元素；
    - `c.clear()`：删除 `c` 中所有元素，返回 `void`。
- 获取迭代器：
    - `c.begin()`：返回指向 `c` 的首元素的迭代器；
    - `c.end()`：返回指向 `c` 尾元素的下一个位置的迭代器；
    - `c.cbegin()`：返回 `const_iterator`，指向 `c` 的首元素；
    - `c.cend()`：返回 `const_iterator`，指向 `c` 尾元素的下一个位置；
- 反向容器特供：
    - `reverse_iterator`：按逆序寻址元素的迭代器；
    - `const_reverse_iterator`：不能修改元素的逆序迭代器；
    - `c.rbegin()`：返回指向 `c` 尾元素的迭代器；
    - `c.rend()`：返回指向 `c` 首元素前一个元素的迭代器；
    - `c.crbegin()`：返回 `const_reverse_iterator`，指向 `c` 尾元素；
    - `c.crend()`：返回 `const_reverse_iterator`，指向 `c` 首元素前一个元素。

并不是所有标准库容器都支持下标运算符，但是所有标准库容器都支持迭代器，迭代器类似于指针类型，提供对对象的间接访问。我们一般有下面操作：

- `C::iterator iter`：声明一个 `C` 类型容器的迭代器，比如 `vector<int>::iterator iter`；
- `C::const_iterator iter`：声明一个只能读取元素的 `C` 类型容器的迭代器；
- `auto iter = c.begin()`：返回指向容器 `c` 的首元素的迭代器，类型根据 `c` 的类型而定；
- `auto iter = c.cbegin()`：返回的迭代器类型为 `const_iterator`；
- `auto iter = c.end()`：返回指向容器 `c` 的尾后元素的迭代器，类型根据 `c` 的类型而定；
- `auto iter = c.cend()`：返回的迭代器类型为 `const_iterator`；
- `*iter`：解引用迭代器，返回迭代器指向的元素的引用，但是不能对尾后迭代器解引用；
- `iter->mem`：解引用迭代器，返回迭代器指向的元素的 `mem` 成员的引用，等价于 `(*iter).mem`；
- `++iter`：递增迭代器，返回当前指示元素的下一个元素；
- `--iter`：递减迭代器，返回当前指示元素的前一个元素；
- `iter1 == iter2` 与 `iter1 != iter2`：比较两个迭代器是否相等，如果两个迭代器指示的是同一个元素或者是同一个容器的尾后迭代器，则相等；

需要注意的是：首先，如果对于容器的操作让容器的容量发生了变化，那么指向该容器元素的**迭代器**就会**失效**；另一方面，并不是所有容器类型都支持了更多的迭代器运算，比如关系运算或者 `+` 与 `-`。

迭代器的接口是公共的，如果一个迭代器提供某个操作，那么所有提供相同操作的迭代器对这个操作的实现方式都是相同的。迭代器范围由一对迭代器表示，两个迭代器分别指向同一个中的元素或者尾后位置，一般分别称为 `begin` 和 `end`，`first` 和 `last`。迭代器范围包含着 `[begin, end)` 之内的所有元素，这种范围叫做左闭合区间。这其实就隐含着构成迭代器范围的迭代器的另一个要求：`begin` 必须在 `end` 之前，也就是可以通过反复递增 `begin` 来得到 `end`。

每个容器类型都定义了一个默认构造函数，除了 `array` 之外的所有容器类型的默认构造函数都会创建一个指定类型的空容器，并且可以接受指定容器大小和元素初始值的参数。

容器的初始化方式很多，不接受参数就构造一个空容器，括号初始化就会创建一个拷贝，使用 `=` 也会初始化为一个拷贝，列表初始化需要列表内的元素类型与容器内元素类型相同，对于 `array` 类型而言，需要列表内元素树木小于等于 `array` 的大小，任何遗漏的部分都会进行值初始化。使用迭代器进行初始化的时候，给定范围 `[begin, end)` 之间的元素会被拷贝到新容器中，但是 `array` 类型的容器并不适用这一点，我们还可以让顺序容器内包含 `n` 个相同的元素 `val`，如果不提供元素的值 `val` 就会执行值初始化，但是只有顺序容器支持这一点。

赋值运算符 `=` 将左侧容器的全部元素替换成右边容器中元素的**拷贝**，对于除了 `array` 之外的顺序容器而言，我们还有对应的赋值函数 `assign`：

- `seq.assign(b, e)`：将迭代器范围 `[b, e)` 之间的元素拷贝到 `seq` 中，但是迭代器不能指向 `seq` 中的元素；
- `seq.assign(n, val)`：将 `seq` 中的元素替换为 `n` 个 `val`；
- `seq.assign(il)`：将 `seq` 中的元素替换为列表 `il` 中的元素。

赋值相关的运算会导致左侧容器内部的迭代器、引用和指针失效，但是 `swap` 对于除了 `array` 和 `string` 之外的容器而言，就不会出现这种情况，这是因为 `swap` 仅仅交换了两个容器内部的数据结构，而不会改变容器内部的元素，但是在 `swap` 完成之后，这些元素都不属于原来的容器了。

`assign` 比简单的 `=` 更加灵活，并且生成的还不是拷贝了（这才是真正的赋值），它允许我们从一个不同但相容的类型赋值，比如将 `char*` 赋值给 `string`，或者将 `vector<int>` 赋值给 `list<int>`。

```cpp
list<string> names;
vector<const char*> oldstyle;
names.assign(oldstyle.cbegin(), oldstyle.cend());   // 允许
names = oldstyle;                                   // 不允许，因为容器类型不匹配
```

## 2. 顺序容器

### 2.1 顺序容器简述

除了 `array` 之外，所有的标准库内的顺序容器都提供灵活的内存管理，运行时可以动态添加或者删除元素来改变容器大小，下面是例子：

- `c.push_back(t)`：在 `c` 的尾部添加一个值为 `t` 的元素，返回 `void`；
- `c.emplace_back(args)`：在 `c` 的尾部构造一个元素，元素由参数 `args` 构造；
- `c.push_front(t)`：在 `c` 的首部添加一个值为 `t` 的元素，返回 `void`；
- `c.emplace_front(args)`：在 `c` 的首部构造一个元素，元素由参数 `args` 构造；
- `c.insert(p, t)`：在迭代器 `p` 指向的元素之前插入一个值为 `t` 的元素，返回指向新元素的迭代器；
- `c.emplace(p, args)`：在迭代器 `p` 指向的元素之前构造一个元素，元素由参数 `args` 构造；
- `c.insert(p, n, t)`：在迭代器 `p` 指向的元素之前插入 `n` 个值为 `t` 的元素，返回指向第一个新元素的迭代器，如果 `n` 为 0 则返回 `p`；
- `c.insert(p, b, e)`：在迭代器 `p` 指向的元素之前插入迭代器范围 `[b, e)` 之间的元素，返回指向第一个新元素的迭代器，如果范围为空则返回 `p`，`b` 和 `e` 不能指向 `c` 中的元素；
- `c.insert(p, il)`：`il` 是一个花括号抱着的元素值列表，将列表中的元素插入到 `p` 指向的元素之前，返回指向第一个新元素的迭代器，如果列表为空则返回 `p`。

需要注意的是，`forward_list` 有自己专用版本的 `insert` 和 `emplace`，并且也不支持 `push_front` 和 `emplace_front`; `vector` 和 `string` 也不支持 `push_front` 和 `emplace_front`，因为在头部插入元素就需要移动元素，代价太高了。并且向 `vector` `string` 和 `deque` 插入元素会使得所有指向容器的迭代器、引用和指针失效。

使用一个对象去初始化容器的时候，或者将一个对象插入容器之中的时候，实际上放进去的是对象值的一个拷贝，并不是对象本身，这和参数传递一样，容器内的元素和提供的对象之间没有任何关联。

`insert` 返回插入的第一个元素的迭代器这一点可以允许我们在一个容器的同一个特定位置反复插入元素。

```cpp
list<string> lst("hello");
auto iter = lst.begin() + 2;
while (cin >> word)
    iter = lst.insert(iter, word);
```

对于顺序容器而言，`emplace` 系列成员函数允许我们通过参数 `args` 构造元素并且插入，而不是类似于 `push_back` 与 `insert` 那样拷贝元素。调用 `emplace` 成员函数的时候，接受的参数被传递给元素类型的构造函数，使用这些参数在容器管理的内存空间中直接构造函数，这就要求 `emplace` 接受的参数必须和元素类型的构造函数相匹配。



### 2.2 `#!cpp std::vector`

需要使用 `#!C++ #include<vector>` 来使用 vector，vector 是一个可变大小的数组，支持快速随机访问，但是在尾部以外的部分插入或者删除元素的速度可能很慢。

1. 创建与初始化
    ```cpp
    vector<ElementType> v1;                 // 空 vector，潜在元素是 ElementType 类型，执行默认初始化
    vector<ElementType> v2(v1);             // 拷贝 v1 副本
    vector<ElementType> v3 = v1;            // 拷贝 v1 副本
    vector<ElementType> v4(n, value);       // n 个元素，每个元素的值为 value
    vector<ElementType> v5(n);              // n 个元素
    vector<ElementType> v6{a, b, c, d};     // 列表初始化
    vector<ElementType> v7 = {a, b, c, d};  // 和 v6 等价
    ```

2. 访问与操作：除了最初提到的通用操作，vector 还有下面的操作：
    - `vec.at(n)`：返回 vector 中第 `n` 个元素的引用，同时检查是否越界，如果越界，抛出 `std::out_of_range` 异常；
    - `vec.front()`：返回 vector 的第一个元素的引用；
    - `vec.back()`：返回 vector 的最后一个元素的引用；
    - `vec.data()`：返回指向作为存储工作的底层数组的指针；
    - `vec.push_back(ele)`：在 vector 尾部添加元素；
    - `vec.pop_back()`：删除 vector 尾部元素；
    - `vec.insert(pos, ele)`：在 `pos` 位置插入元素；
    - `vec.erase(iter)`：删除迭代器 `iter` 指向的元素；
    - `vec.erase(beg, end)`：删除 `[beg, end)` 区间的元素；
    - `vec.find(first, end, v)`：在 `[first, end)` 区间内查找值为 `v` 的元素，返回指向该元素的迭代器，否则返回 `end`；
    - `vec[n]`：下标运算符，返回 vector 中第 `n`` 个元素的引用；
    - `==`, `!=`, `<`, `<=`：诸如此类按照字典序比较两个 vector，同时考虑元素数量；

3. 迭代器运算：`vector` 支持了更多的迭代器运算，一方面可以使得迭代器的每次移动都夸跨过多个元素，也支持迭代器进行关系运算，这些运算都被称为迭代器运算：
    - `iter +/- n`：返回迭代器 `iter` 向前/后移动 `n` 个元素的迭代器；
    - `iter +/-= n`：迭代器 `iter` 向前/后移动 `n` 个元素；
    - `iter1 - iter2`：返回两个迭代器之间的距离；
    - `>` `>=` `<` `<=`：若某个迭代器在另一个迭代器之前，则认为前者小于后者；

### String

需要使用 `#!C++ #include<string>` 来使用 `string`，`string` 是一个可变大小的字符序列，支持快速随机访问，但是在尾部以外的部分插入或者删除元素的速度可能很慢。

- 定义变量并初始化：`#!C++ string s1 = "hello";`；
- 输入输出：`#!C++ cout << s1; cin >> s1;`；
- 赋值：`#!C++ string s2 = s1;`，这是合法的，其实就是拷贝（对比 C 字符串）；
- 拼接：`#!C++ string s3 = s1 + s2;`，`#!C++ s1 += s2;`，`s1` 和 `s3` 都变成了 `hellohello`；



### Array

### Queue

需要使用 `#!C++ #include<queue>` 来使用 queue，queue

### Priority Queue

### Stack

## 3. 关联容器

### 3.1 关联容器简述

### 3.2 `#!cpp std::map`

### 3.3 `#!cpp std::set`
