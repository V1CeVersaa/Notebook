# Topic 12：面向对象语言

!!! Abstract "Outline"

    - [x] [1. 概述](#1)
    - [x] [2. 单继承](#2)
    - [x] [3. 多继承](#3)
    - [ ] [4. 类成员关系测试](#4) 「很遗憾，不考了」
    - [ ] [5. 私有字段和私有方法](#5) 「很遗憾，不考了」
    - [ ] [6. 面向对象程序的优化](#6) 「很遗憾，你也不考」

## 1. 概述

面向对象语言/Object-Oriented Language/OO Language/Class-Based Language 是现代编程语言中非常重要的一类语言，其核心思想是：

- 一切/几乎所有值都是对象，比如 Python；
- 对象属于某个类，或者说是某个类的实例/Instance；
- 对象封装了状态/字段/成员变量/Fields 与行为/方法/成员函数/Methods；

面向对象语言有三个重要的概念：

- 继承/Inheritance：派生类继承基类的特性，比如假设基类 `Rocket` 具有方法 `fire()`，则子类 `Spaceship` 自然也有 `fire()` 方法；
- 封装/Encapsulation：将状态和行为封装在一起，隐藏不该被外部接触到的接口；
- 多态/Polymorphism：对象可以以不同形态呈现，比如由于 `Cat` 继承自 `Animal`，一个 `Cat` 实例也可以被看作是一个 `Animal` 实例；

我们使用 Object-Tiger 作为支持面向对象的函数式语言的例子，其语法如下：

```bnf
dec         -> classdec
classdec    -> class class-id extends class-id { { classfield } }
classfield  -> vardec
            |  method
method      -> method id( tyfields ) = exp
            |  method id( tyfields ) : type-id = exp
```

声明类语法为：`class B extends A { ... }`，声明了一个继承自基类 `A` 的派生类 `B`，`A` 的所有字段和方法都隐式地属于 `B`，且 `B` 可以重写/Override `A` 的方法，但是字段不支持重写。Object-Tiger 中所有类都隐式继承自根类 `Object`，且 `Object` 没有字段和方法。这种设计也被 Java 和 Python 采用。

方法在语法语法上类似于函数，但是每个方法内部都隐式携带一个形式参数 `self`，类型为当前类，表示当前方法调用的对象，注意 `self` 在 Object-Tiger 中不是关键字，也不出现在源代码声明中，在运行时自动绑定当前对象。

```ocaml
class Car extends Vehicle {
  method await((*self: Car*) v: Vehicle) {
    if (v.position < position) then v.move(position - v.position)
    else self.move(10)
  }
}

var C: Car = new Car
c.move(60)
```

下面是对于类的表达式语法：

```bnf
exp -> new class-id
     | lvalue.id()
     | lvalue.id(exp{, exp})
```

`new` 表达式用于创建对象，对象的各个数据字段的初始化是通过计算类声明中与这些域对应的初值表达式来完成的，`lvalue.id()` 和 `lvalue.id(exp{, exp})` 均是用来调用方法的，左值 `b.x` 表示对象 `b` 的字段 `x`，其中 `b` 是一个类型为类 `B` 的左值，`lvalue.id(exp{, exp})` 表示以显式的实参 `exp{, exp}` 以及隐含的参数 `self` 的值 `b` 调用对象 `b` 的方法 `id`。

类的继承关系可以使用图来表示，主要分为两种：

- 单继承/Single-inheritance/SI：继承图是一棵树，每个类只有一个父类；
- 多继承/Multiple-inheritance/MI：继承图是一张有向无环图/DAG/Directed Acyclic Graph，允许多个父类；

在 Tiger 中实现类需要解决三个问题：

- 字段布局/Field layout：安排各个字段在内存中的位置，这决定我们如何访问对象的字段；
- 方法分发/Method dispatch：调用某个实例的方法时，如何找到正确的方法位于何地址；
- 类型检查/Membership test：如何检查给定实例是否是给定类的实例；

## 2. 单继承

对于单继承来讲，字段布局的解决还蛮简单的，有一个简单的方法：前缀法/Prefixing，即父类的字段放在子类字段的最前面，子类的新增字段放在父类字段之后。

```ocaml
class A extends Object { var a: int = 0 }
class B extends A { var b: int = 0, var c: int = 0 }
class C extends A { var d: int = 0 }
class D extends B { var e: int = 0 }
```

<img class="center-picture" src="assets/12 oop/12-1.webp" alt="Field Inheritance" width="550" />

这样的方法也可以正确处理多态，比如 `D` 的实例 `d` 可以被看作是 `A` 的实例，相当于将新增的字段都屏蔽了。

对于方法来讲，分两部分：首先将方法编译成机器码，放置在特定的地址；然后在调用方法的那个点，判定需要跳转到哪个地址。

- 方法的编译很像对函数的编译；
- 在语义分析阶段，每一个变量的环境登记项/Environment Entry 都包含一个指向其类描述符/Class Descriptor 的指针，每一个类描述符都包括：
    - 一个指向其父类的指针；
    - 一个包含方法实例的列表，每一个方法实例都含有一个唯一的机器码标签/Label；

对于静态方法来讲，调用 `c.f()` 执行的代码取决于 `c` 的声明类型，为了编译 `c.f()`，编译器需要：

- 在 `c` 的类描述符中搜索方法名 `f`；
- 如果不存在，往父类继续查找；
- 找到后，直接生成对对应 label（如 `A_f`）的函数调用。
- 静态方法的查找速度很快，完全可以在编译时完成，没有运行时开销；

<img class="center-picture" src="assets/12 oop/12-2.webp" alt="Static Method Dispatch" width="550" />

对于动态方法来讲，处理稍微复杂一点：如果我们对 `C` 的一个对象调用 `c.f()`，编译器在编译期无法确定 `c` 的实际类型是 `C` 还是 `D`，因此就不确定到底是调用 `D_f` 还是 `C_f`：

<img class="center-picture" src="assets/12 oop/12-3.webp" alt="Dynamic Method Dispatch" width="550" />

解决方法是：每一个类描述符都包含一个分发向量/Dispatch Vector/虚表/Virtual Table/vtable，此向量中每一个非静态的方法名都对应一个方法实例，当 `B` 继承 `A` 的时候，其虚表的开始是 `A` 的所有方法名的登记项，然后才是 `B` 中用声明的新方法，当重载出现的时候，`B` 中重载的方法会替换掉 `A` 中对应的方法。

<img class="center-picture" src="assets/12 oop/12-4.webp" alt="Dynamic Method Dispatch" width="550" />

为了执行一个动态方法 `c.f()`，编译器编译出来的代码必须执行如下指令：

- 在对象 `c` 的偏移 `0` 处取出类描述符 `d`；
- 从 `d` 的偏移 `f`（`f` 是常量）处取出方法实例指针 `p`；
- 转移到地址 `p`，并保存返回地址（即调用 `p`）。

## 3. 多继承

很多语言都支持类继承多个基类，比如 C++、Perl、Python 等，但是多继承的实现非常复杂，找出字段的偏移和方法实例就比较困难，并且也不能做到既将一个基类的字段放到开头，又将另一个基类的字段放到开头。

### 3.1 图染色方法

解决方法之一就是静态地一次同时分析所有类，找到每个字段的一个统一的偏移。我们将问题建模成一个图染色问题：

- 节点：每一个不同的字段声明都对应着一个节点，这里的节点并不是字符串意义的不同，字段或方法的每一个新的声明（它没有重载父类的字段或方法）实际上是一个不同的名字；
- 边：如果两个字段或方法曾共现于同一个类中，就在它们之间连一条边；
- 颜色：对应偏移量 0、1、2...

<img class="center-picture" src="assets/12 oop/12-5.webp" alt="Graph Coloring" width="550" />

分析步骤和图染色的一样，就是我们不提具体算法了：先构建干涉图、然后染个色、最后根据染出来的颜色确定每个字段的偏移。

=== "Step 1: Interference Graph Construction"

    <img class="center-picture" src="assets/12 oop/12-6.webp" alt="Graph Coloring" width="550" />

=== "Step 2: Coloring"

    <img class="center-picture" src="assets/12 oop/12-7.webp" alt="Graph Coloring" width="550" />

=== "Step 3: Determining Layout"

    <img class="center-picture" src="assets/12 oop/12-8.webp" alt="Graph Coloring" width="550" />

问题当然是有的，最后的字段布局中出现了空槽/Wasted Empty Slots，比如 `B` 和 `C` 的对象布局分别在某些偏移处没有字段，造成空间浪费。

解决方法也是有的，但是不考，我们还是提一下：我们将字段紧凑打包，转而使用类描述符指出每个字段的位置：

- 还是对字段的名字进行着色，颜色还是偏移量，但是偏移量在描述符中指出；
- 描述符这下额外支持一个字段，这个字段标注了真实字段在对象中的偏移量；
- 对象的内存布局就没有空槽了，但是开销从未消失，只不过是从空间的浪费转移到了时间的开销。

为了读取对象 `x` 的字段 `a`：首先需要从对象头取出类描述符 `d`，然后从 `d` 中取出与 `a` 对应的字段偏移量，最后通过这个偏移量在对象的合适位置找到数据的值。注意到这时候类描述符就出现了空槽，但是因为类的数量远远小于对象的数目，所以这个开销是完全可以接受的。我们也将这个方法称为在类上着色。

<img class="center-picture" src="assets/12 oop/12-9.webp" alt="Graph Coloring" width="550" />

但是问题又出现了，正如我们所说，开销从未消失，只不过是从空间的浪费转移到了时间的开销。另外每一个字段的偏移量也没有完全确定，比如在某个类中 `b` 的偏移量就是 1，但是在另一个类中 `b` 的偏移量就是 2。

方法又如何呢？方法的布局和字段类似，可以将方法名和字段名一起着色，然后分别映射到代码地址/偏移，也存在查找的开销。

<img class="center-picture" src="assets/12 oop/12-10.webp" alt="Graph Coloring" width="550" />

### 3.2 哈希方法 

>「对不起，你不考」

## 4. 类成员关系测试

## 5. 私有字段和私有方法

## 6. 面向对象程序的优化

特定对于面向对象程序的优化，我们主要关注以下几个方面：

- 方法特化/方法复制/Method Specialization/Replication：为常见接收者类型生成专门版本；
- 去虚拟化/Devirtualization：将动态调用转换为静态直接调用；
- 内联展开/Inline Expansion：方法体内联；
- 类型分支优化/Typecase Optimization：针对 `final` 或密封类做类型分支优化。

优化的信息来源：

- 类继承关系/Class Hierarchy；
- 方法重写链/Method Overriding Patterns；
- 对象创建点/Object Creation Sites：`new` 表达式的位置；
- 类型流向分析/Assignment Patterns：变量赋值的类型流向；
- 确定无子类可做更强推断/Final/Sealed Declarations。
