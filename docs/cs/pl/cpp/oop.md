# Object Oriented Programming

!!! Abstract 
    OOP 的核心思想是数据抽象、继承和动态绑定。通过数据抽象，我们可以将类的接口与实现分离；使用继承，我们可以定义相似的类型并且对其相似关系进行建模；使用动态绑定，可以在一定程度上忽略相似类型之间的差别，而以统一的方式使用它们的对象。

## 1 Class Declaration

### 类类型和类声明

每个类都定义了唯一的类型，尽管类的成员完全完全一样，但是这两个类仍然是不同的类型。我们可以把类名直接作为类型的名字来使用，从而让定义的对象直接指向类类型，也可以将类名跟在关键字 `class` 或者 `struct` 后边，这样的声明都是等价的。

结构体/Structures 和类/Classes 在 C++ 中是语义相同的，但是我们仍然需要如下区分它们的语义：

- 


### 访问说明符

C++ 使用**访问说明符/Access Specifiers** 加强类的封装性：

- `public`：在类的外部和内部都可以访问，是类的接口部分；`public` 成员定义类的接口；
- `private`：只能在类内部访问，只能被类的成员访问，但是不能被使用该类的代码访问，是类的实现部分。`private` 成员对类的用户隐藏了实现细节；
- `protected`：介于 `public` 和 `private` 之间，可以被类的成员、派生类的成员和友元访问，但是不可以在外部被别的用户直接访问。派生类的成员或者友元只能通过派生类对象来访问基类的受保护成员：

    ```cpp
    class Base {
       protected:
        int prot_mem; 
    };

    class Derived : Base {
        friend void frd_fcn(Derived &d);
        friend void frd_fcn(Base &b);
    };

    void frd_fcn(Derived &d) { d.prot_mem = 1; }    // 正确，这就是通过派生类访问基类的受保护成员
    void frd_fcn(Base &b) { b.prot_mem = 1; }       // 错误
    ```

访问说明符的有效范围是从出现的地方开始，知道下一个访问说明符或者类的结尾为止。默认情况下，`class` 的成员是 `private` 的，`struct` 的成员是 `public` 的。

```cpp
struct A {
    int value;
   protected:
    void f1() { }
   private:
    void f2() { }
};

struct B : public A {
    void h1() { f1(); }         // 正确
    // void h2() { f2(); }      // 错误，f2 是 A 私有的成员
};

A a;
a.value = 1;
// a.f1();                      // 错误，受保护的成员不能在外部直接访问
// a.f2();                      // 错误，私有成员不能在外部直接访问
```

### 名字查找和类的作用域

每个类都会定义自己的作用域，在类的作用域之外，普通的数据和函数成员只能由对象、引用或者指针使用成员访问运算符访问，而类类型成员则使用作用域运算符访问。有以下几点需要注意：

1. **「一个类就是一个作用域」**：这解释了为什么当我们在类的外部定义成员函数的时候必须同时提供类名和函数名，参数列表和函数体都是在类的作用域之内的，可以直接访问类的成员，但是函数名和返回类型不在类的作用域之内，所以必须指明是哪个类的成员。
2. **「名字查找」**：名字查找/Name Lookup 是指寻找与所用名字最匹配的声明的过程。一般情况的名字查找的过程是这样的：首先在名字定义的块中寻找声明语句，只考虑在名字的使用之前出现的声明；如果没找到，就继续查找外层作用域；还没找到声明就进行报错。解析类内部成员函数的名字的方式稍有不同：编译器首先编译成员的声明，知道类全部可见之后才会编译类函数体。
3. **「类型名的特殊处理」**：一般来说，内层作用域可以重新定义外层作用域中的名字，即使这个名字已经在内层作用域中使用过，但是在类中，如果成员使用了内层定义域中的某个名字，而**该名字代表类类型**，那么**类不能在之后重新定义该名字**。这样一来，下面的代码就是错的：

    ```cpp
    typedef double Money;
    class Account {
    public:
        Money balance() { return bal; }
    private:
        typedef double Money;
        Money bal;
    };
    ```

    尽管在类内定义的 `Money` 和外层定义域中的定义是一样的，但是这样的代码仍然是错误的。另外，编译器并不会为这样的错误负责，有些编译器会顺利通过这样的代码，忽略错误的事实。
4. **「」**


## 2 Class Members

### 2.1 类型成员

除了定义数据成员之外，类还可以定义某种类型在类中的别名，类型成员也存在着访问限制，可以被 `public`、`private`、`protected` 修饰。需要注意的是**用于定义类型的成员必须先定义再使用**，这就和普通的成员有很大的区别，原因是编译器在解析类时，必须知道每个符号的确切类型。因此，编译器要求类型定义要出现在该类型被使用之前。因此，类型成员一般出现在类开始的地方。

```cpp
class Screen {
   public:
    using pos = std::string::size_type;
    // this is equivalent to typedef std::string::size_type pos;
   private:
    // data members
};
```

### 2.2 数据成员

**「类内初始值/In-class Initializer」**：类内初始值用来初始化数据成员，没有初始值的成员将被默认初始化。类内初始值必须使用 `=` 或者 `{}` 来初始化，不能使用 `()`。

**「`this`」**：类的成员函数使用一个名为 `this` 的额外的隐式参数来访问调用它的那个对象，当我们调用一个成员函数的时候，用请求该函数的对象地址初始化 `this`。在成员函数内部，我们可以直接使用调用了该函数的对象的成员，而不需通过成员访问运算符 `.` 来访问，因为 `this` 所指的就是这个对象，所有对类成员的直接访问都看作对 `this` 的隐式引用。比如实例代码中的 @todo pp231。



### 2.3 函数成员

??? Info "Part of Code Implementation of `Sales_data`"

    ```cpp
    class Sales_data {
        friend Sales_data add(const Sales_data&, const Sales_data&);
        friend std::istream &read(std::istream&, Sales_data&);
        friend std::ostream &print(std::ostream&, const Sales_data&);

       public:
        Sales_data() = default;
        Sales_data(const std::string &s, unsigned n, double p) : bookNo(s), units_sold(n), revenue(p*n) { }
        Sales_data(const std::string &s) : bookNo(s) { }
        Sales_data(std::istream &is);

       private:
        std::string bookNo;
        unsigned units_sold = 0;
        double revenue = 0.0;
    };

    Sales_data::Sales_data(std::istream &is) { read(is, *this); }

    Sales_data add(const Sales_data &lhs, const Sales_data &rhs) {
        Sales_data sum = lhs;
        sum.combine(rhs);
        return sum;
    }
    // Other Implementations
    ```

??? Info "Part of Code Implementation of `Screen`"

    ```cpp
    class Screen {
        friend class Window_mgr;
        // friend void Window_mgr::clear(ScreenIndex);          // 成员函数作为友元
        friend std::ostream &storeOn(std::ostream&, Screen&);   // 重载的友元函数
       
       public:
        typedef std::string::size_type pos;
        Screen() = default;
        Screen(pos ht, pos wd, char c) : height(ht), width(wd), contents(ht * wd, c) { }
        char get() const { return contents[cursor]; }   // 隐式内联
        inline char get(pos ht, pos wd) const;          // 显式内联
        Screen &move(pos r, pos c);                     // 在类外定义内联函数
        Screen &set(char);                              // 返回类型是引用，返回 `*this`
        Screen &set(pos, pos, char);
        Screen &display(std::ostream &os) { do_display(os); return *this; }
        const Screen &display(std::ostream &os) const { do_display(os); return *this; }
       
       private:
        pos cursor = 0;
        pos height = 0, width = 0;
        std::string contents;
        void do_display(std::ostream &os) const { os << contents; }
    };

    extern std::ostream &storeOn(std::ostream &os, Screen &s);
    extern BitMap &storeOn(BitMap &bm, Screen &s);

    char Screen::get(pos r, pos c) const {
        pos row = r * width;
        return contents[row + c];
    }

    inline Screen &Screen::move(pos r, pos c) {
        pos row = r * width;
        cursor = row + c;
        return *this;
    }

    inline Screen &Screen::set(char c) {
        contents[cursor] = c;
        return *this;
    }

    inline Screen &Screen::set(pos r, pos col, char ch) {
        contents[r * width + col] = ch;
        return *this;
    }
    ```

1. **「内联函数」**：定义在类内部的函数会被编译器隐式地视为内联函数，我们也可以在类内显式将函数声明成内联的，甚至可以在类内声明的时候不声明成内联的，但是在类外定义的时候定义成内联的。我们不需要在声明的时候和定义的时候同时声明成内联的，其一则可，也可以保持一致性。
2. **「常量成员函数」**：在成员函数的参数列表后面加上 `const` 关键字，这样的函数被称为**常量成员函数/Const Member Function**，常量成员函数不能修改对象的数据成员（定义成 `mutable` 的成员除外），并且通过隐式地将隐式参数 `this` 指针定义成 `const type *const` 的来实现，这样在函数之中，`this` 指针指向的对象就是常量了。常量成员函数可以被定义成 `const` 的对象（包括常量对象的引用、指向常量对象的指针）调用，但是非常量成员函数不能。
3. **「成员函数重载」**：类的成员函数可以被重载，但是重载的函数必顋有不同的形参列表。下面定义的两个 `get` 函数就是重载的例子，这里无参数的时候返回 `cursor` 指向的字符，有参数的时候返回两个参数指定的位置的字符。
4. **「可变数据成员」**：通常情况下，`const` 成员函数不能修改对象的任何数据成员，因为它们被视为只读的。但是，有时我们需要一个例外，让某些特定的成员可以在 `const` 成员函数中被修改。这种情况下可以使用 `mutable` 关键字。  

    即使**可变数据成员/Mutable Data Member** 是 `const` 对象的成员，它也不是 `const` 的，因此一个 `const` 成员函数可以改变一个可变数据成员的值，下面是一个简单的计数器，`const` 函数 `increment_count()` 可以增加 `access_ctr` 的值。 
    ```cpp
    class Account {
       public:
        void increment_count() const { ++access_ctr; };
       private:
        mutable size_t access_ctr = 0;
    };
    ``` 

5. **「类数据成员初始值」**：若另一个类的成员之一是某种类类型的对象，我们希望这个对象可以有一个默认的初始值，最好的方法就是将默认值声明称类内初始值：  
    ```cpp
    class Window_mgr {
       private:
        std::vector<Screen> screens{Screen(24, 80, ' ')};
    };
    ```

6. **「返回 `*this` 的成员函数」**：返回语句通过返回 `this` 的解引用来将对象本身作为左值返回，若定义返回类型为引用类型，返回的就是这个对象的引用，可以连续调用成员函数并且修改对象的值。但是若返回的不是引用类型，返回的就是这个对象的一个副本，倒是可以连续调用，但是修改的是副本的值，不会影响原对象。值得注意的是，若该函数是一个返回引用的常量成员函数，那么返回的就是一个常量引用，没法修改。
7. **「基于 `const` 的重载」**：由于我们只可以在一个常量对象上调用常量成员函数，虽然可以在非常量对象上调用常量版本和非常量版本的成员函数，但是此时调用非常量版本的是一个更好的匹配。我们可以通过区分成员函数是否是 `const` 的，对函数进行重载，编译器会在调用的时候自行选择最佳匹配的函数。上面的 `display` 函数就是一个例子，`const` 和非 `const` 版本的 `display` 函数返回的都是 `*this`，但是一个是常量引用，一个是非常量引用。

### 2.4 构造函数

??? Info "Part of Code Implementation of `Sales_data`"

    ```cpp
    class Sales_data {  
       public:
        Sales_data() = default;                             // 默认构造函数
        Sales_data(const std::string &s) : bookNo(s) { }    // 其他构造函数
        Sales_data(const std::string &s, unsigned n, double p) : bookNo(s), units_sold(n), revenue(p*n) { }
        Sales_data(std::istream &is) { read(is, *this); }
        // 其他成员和函数
    };

    Sales_data::Sales_data(std::istream &is) { read(is, *this); }
    ```

每个类都定义了他的对象被初始化的方式，类通过**构造函数/Constructor** 来控制对象的初始化过程，无论何时知道类的对象被创建，就会执行构造函数。

构造函数的名字和类名相同，没有返回类型，参数列表和函数体可以为空，但是构造函数**不可以被声明成 `const`**，当我们创建一个 `const` 的对象的时候，直到构造函数完成初始化过程，对象才能真正取得其 `const` 属性，因此构造函数在构造的过程中可以向 `const` 对象写值，构造函数也就不能是 `const` 的。

若创建一个对象，但是没有提供初始值，那么将隐式使用**默认构造函数/Default Constructor** 进行默认初始化，默认构造函数无须任何实参。默认构造函数很多方面都有特殊性，其中之一就是若没有定义**任何**构造函数，编译器就会隐式创建**合成的默认构造函数/Synthesized Default Constructor**，合成的默认构造函数将会按下面的规则初始化成员：

 - 如果存在类内初始值，用它来初始化成员；
 - 否则，执行默认初始化。

但是编译器有时候不能为某些类合成默认构造函数，比如类的某个成员没有默认构造函数；编译器合成的默认构造函数也有可能执行错误的操作；或者如果类已经有了非默认构造函数，编译器就不会合成默认构造函数，这时称这个类的默认构造函数被删除。

下面是一些琐碎的东西与解释：

1. **「`= default`」**：考察构造函数 `Sales_data() = default;`，首先这是一个默认构造函数，`= default` 是告诉编译器按照默认的行为生成默认构造函数。当 `default` 出现在类内的时候，生成的默认构造函数是内连的，否则定义在类的外部，这样的构造函数是非内联的。
2. **「删除的默认构造函数」**：如果一个类满足下面条件任意一个，其隐式的默认构造函数就会被标记为删除的：该类有用户定义的其他构造函数；有非静态的引用或者 `const` 类型成员，或者其基类是引用类型或者常量类型；其某个成员或者基类的默认构造函数被删除或者不可访问；其某个成员或者基类的析构函数被删除或者不可访问。
    
    ??? Info "Example"
        ```cpp
        struct A {
            A(int x) {}     // 定义了带参数的构造函数
                            // 默认构造函数被隐式删除
        };

        struct NoDefault {
            const int x;    // const 成员
            int& ref;       // 引用成员
                            // 默认构造函数被隐式删除
        };

        struct A {
            NoDefault var;  // NoDefault 类没有默认构造函数
                            // A 的默认构造函数被隐式删除
        };

        struct B : NoDefault {  // 基类 NoDefault 没有默认构造函数
                                // B 的默认构造函数被隐式删除
        };

        struct A {
           private:
            ~A() {}         // 私有析构函数
        };
        struct B {
            A var;          // A 的析构函数不可访问
                            // B 的默认构造函数被隐式删除
        };
        ```

3. **「构造函数初始值列表」**：考察构造函数 `Sales_data(const std::string &s) : bookNo(s) { }`，它接受一个 `const std::string &` 类型的参数，在参数后出现了冒号 `:`，冒号后边的是**构造函数初始值列表/Constructor Initialize List**，负责为新创建的对象的一个或多个数据成员赋初值。当某个数据成员被构造函数初始值列表忽略时，将执行默认初始化。**构造函数初始值列表很多时候必不可少**，尤其是**当我们初始化 `const` 或者引用类型的数据成员的时候**，这种情况下初始化这些成员的唯一机会就是在构造函数初始值列表内初始化。比如下面的例子就是说明了这一点，总而言之，**如果成员是 `const`、引用或者属于某种为提供默认构造函数的类类型，我们需要使用构造函数初始值列表为这些成员提供初值**。在 C++11 中，规定了**`const` 和引用类型的数据成员必须使用初始值列表或者在类内使用等号或者花括号进行初始化**。

    ??? Info "Example"

        ```cpp
        class ConstRef {
           public:
            ConstRef(int ii);
           private:
            int i;
            const int ci;
            int &ri;
        };

        ConstRef::ConstRef(int ii) : i(ii), ri(ii)，ci(ii) { } // 正确：显式初始化引用和常量成员
        ConstRef::ConstRef(int ii) {
            i = ii;
            ci = ii;        // 错误：不能给引用赋值
            ri = i;         // 错误：ri 未初始化
        } 
        ```

4. **「成员初始化的顺序」**：首先，在构造函数初始值中每个成员都只能出现一次，给同一个成员赋两个初始值是没有意义的；其次，**构造函数初始值列表只用于说明初始化成员的值，并不限定初始化的具体执行顺序**，而成员的舒适化顺序**和其在类定义中出现的顺序一致**：第一个成员先被初始化，然后第二个，以此类推。所以在刚才的例子中，即使我们在构造函数初始值列表中将 `ri` 放在了 `ci` 前面，但是仍然是 `ci` 先初始化了。
5. **「类外部的构造函数」**：`Sales_data::Sales_data(std::istream &is) { read(is, *this); }`，我们在类的外部定义构造函数。构造函数没有返回类型，所以定义从函数名字开始，首先指明构造函数是哪个类的成员，所以需要在函数名字前加上类名和作用域运算符 `::`，这个构造函数的初始值列表是空的，但是由于执行了构造函数体，所以对象的成员仍然可以被初始化。
6. **「委托构造函数」**：**委托构造函数/Delegating Constructor** 使用它所属类的其他构造函数执行它自己的初始化过程。换句话说，委托构造函数将自己的一些或者全部职责委托给了其他构造函数。委托构造函数的成员初始值列表只有唯一的一个入口，就是类名本身。下面的类的构造函数中，出了一个构造函数之外都委托了自己的工作，接受 `istream&` 参数的构造函数先是委托给了默认构造函数，而默认构造函数则是委托给了接受三个参数的构造函数。当一个构造函数委托给另一个构造函数的时候，受委托的构造函数的初始值列表和函数体被依次执行，然后才会将控制权交还给委托者的函数体。

    ??? Info "Example"

        ```cpp
        class Sales_data {
           public:
            Sales_data(std::string s, unsigned cnt, double price) : 
                bookNo(s), units_sold(cnt), revenue(cnt * price) { }
            Sales_data() : Sales_data("", 0, 0) { }
            Sales_data(std::string s) : Sales_data(s, 0, 0) { }
            Sales_data(std::istream &is) : Sales_data() { read(is, *this); }
        }
        ```

7. **「默认构造函数的作用」**：回忆使用默认初始化和值初始化的情况，类必须包含一个默认构造函数，以便在被值初始化和默认初始化的时候使用，大多数情况非常容易判断，比如当不实用一个初始值来定义一个局部静态变量的时候就会使用值初始化。同时，尽管类似 `Sales_data obj();` 可能书写这行代码的程序员的想法是定义一个默认初始化后的对象，但是我们不经意之间就定义了一个函数指针 `obj`，去掉括号才是定义一个默认初始化的对象，或者我们使用 `Sales_data obj{};` 来定义一个默认初始化的对象。
8. **「隐式的类类型转换」**：C++ 在内置类型之间有几种自动转换规则，类也有类似的规则。如果构造函数只有一个实参，那么它实际上就定义了转换为此类类型的隐式转换规则，我们将这种构造函数称为转换构造函数/Converting Constructor。比如对于一个 `Sales_data` 类的对象 `item`，我们可以通过 `item.combine(string("9-999-99999-9"))`（先显式转换成 `string`，再隐式转换成 `Sales_data` 类型）或者 `item.combine(Sales_data("9-999-99999-9"))` 来进行转换，但是编译器只会自动进行**一步**类型转换，比如 `item.combine("9-999-99999-9")` 的代码就是错误的。注意到转换成 `Sales_data` 类型的时候其实是执行了一次构造函数，创建了一个临时的对象，随后将这个对象传给 `combine`，然后销毁这个临时对象。
9. **「使用 `explicit` 抑制类型转换」**：使用 `explicit` 声明的构造函数不允许隐式的类型转换（也就是不允许隐式创建对应对象）或者拷贝初始化，但是其不能被应用到拷贝构造函数和移动构造函数上。同时 `explicit` 的声明只应该出现于类内声明构造函数的时候，在类外部定义时不应该重复。对于声明为 `#!cpp explicit Sales_data(std::string s)` 的构造函数，我们不能使用 `item.combine("9-999-99999-9")` 来进行隐式转换，也不应该使用 `#!cpp Sales_data item = "9-999-99999-9"` 来进行拷贝初始化。
10. **「聚合类」**：聚合类所有的成员都是 `public` 的，没有定义任何构造函数和类内初始值，没有基类也没有虚函数。聚合类允许用户可以直接访问其成员，并且可以直接使用花括号括起来成员初始值列表，用其初始化聚合类的数据成员，但是初始值的顺序必须和声明的顺序一致。
11. **「字面值常量类」**：
12. **「拷贝构造函数」**：

### 2.5 析构函数

**「」**：

### 2.6 静态成员

有的时候类需要它的成员直接和类本身相关，而不是和类的各个对象保持相关。并且如果这个成员发生改变，所有该类的实例都可以使用新值。使用 `static` 关键字可以将成员声明为静态成员。静态成员可以是 `public` 的或者是 `private` 的，数据静态成员的类型可以是常量、引用、指针、类类型等。类的静态成员存在于任何对象之外，**对象中不包含任何与静态成员有关的数据**，类似的，静态成员函数也不与任何对象绑定在一起，也不包含 `this` 指针，因此其也不能声明成 `const` 的（因为 `const` 函数隐式传递一个 `const T* this` 指针），也不能

**「」**：

### 2.7 友元

??? Info "Part of Code Implementation of `Window_mgr`"

    ```cpp
    class Window_mgr {
       public:
        using ScreenIndex = std::vector<Screen>::size_type;
        void clear(ScreenIndex);
       private:
        std::vector<Screen> screens{Screen(24, 80, ' ')};
    };

    void Window_mgr::clear(ScreenIndex i) {
        Screen &s = screens[i];
        s.contents = std::string(s.height * s.width, ' ');
    }
    ```

若使用访问说明符加强类的封装性，将数据类型封装成 `private` 的，那么定义的非成员函数的类接口 `read` 和 `print` 就不能访问 `Sales_data` 的数据成员，自然无法通过编译，**友元/Friend** 解决了这个问题。通过定义其他函数成为某个类的友元函数，就可以让这个**友元函数访问类的私有成员**，只需要在类的定义中加上 `friend` 声明即可。我们也可以将某个类作为该类的友元，这样的类可以访问该类的私有部分。

友元函数的声明可以出现在类的任何地方，但是必须出现在类定义的内部，其仅仅指定了访问权限，但是**不是一个通常意义上的函数声明**，在类内声明友元函数的时候，我们可以定义这个函数，但是仍然需要在类外有一个独立的函数声明。友元函数不是类的成员函数，也不受所在区域访问控制级别的约束。

```cpp
class X{
    friend void f() { }                 // 定义并“声明”友元函数
    X() { f(); }                        // Error: 友元函数没声明
    void g();
    void h();
};

void X::g() { f(); }                    // Error: 友元函数没声明
void f();                               // 独立的函数声明
void X::h() { f(); }                    // It works: 调用友元函数
```

类和非成员函数的声明不必须在它们的友元函数之前，当一个名字第一次出现在一个友元声明中的时候，我们隐式地认为这个名字在当前作用域中是可见的，但是友元函数并不一定真正的声明在当前的作用域中。即使在类的内部定义这个友元函数，**也必须在类的外部提供一个相应的声明是的该函数可见**，换句话说：我们需要理解**友元函数的声明仅仅是影响访问权限，它的声明并不是一般意义上的声明**。

在上面的 `Screen` 类与 `Window_ mgr` 类的部分实现中，`Window_mgr` 类是 `Screen` 类的友元，所以 `Window_mgr` 类可以访问 `Screen` 类的所有成员（包括非公有成员），这样 `Window_mgr` 类的 `clear` 函数就可以访问并且修改 `Screen` 类的 `contents` 数据成员。

我们还可以定义成员函数作为某个类的友元，这样必须明确指出这个函数是哪个类的成员函数，这样的函数可以访问该类的私有成员，但是该友元函数必须在声明包含友元函数的类的前面被声明。在上面的例子中，`Window_mgr` 类的 `clear` 函数就是一个例子，落实到程序中，我们应该这样控制顺序：首先定义 `Window_mgr` 类，声明 `clear` 函数，但是不定义（`clear` 需要使用 `Screen` 类）；然后定义 `Screen` 类，声明 `Window_mgr` 类为友元；最后定义 `Window_mgr` 类的 `clear` 函数。

上面的 `Screen` 类中还定义了一个重载的友元函数 `storeOn`，我们发现 `storeOn` 函数其实是重载的，但是这里只声明了一个作为友元。如果类需要将一组重载函数声明成其友元，就需要对这组函数中的**每一个**分别进行声明。这里只将返回 `std::ostream &` 的 `storeOn` 函数声明为友元，而没有将返回 `BitMap &` 的 `storeOn` 函数声明为友元，所以 `storeOn` 函数的重载版本中，只有返回 `std::ostream &` 的版本可以访问 `Screen` 类的私有成员。

**友元并不具有传递性**，倘若 `Window_mgr` 也有自己的友元（比如是 `A`），那么 `A` 并不能访问 `Screen` 类的私有成员，因为 `A` 并不是 `Screen` 类的友元。

## 3 Inheritance

### 虚函数

派生类经常（但不是必须）覆盖其继承的虚函数，如果派生类没有覆盖其基类中的某个虚函数，则该虚函数的行为就类似于其他的普通成员，派生类就会直接继承其在基类中的版本。

## 4 Dynamic Binding

## 5 Templates and Generic Programming




