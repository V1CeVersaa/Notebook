# 对象、引用与内置数据结构

<!-- Source: https://javascript.info/object-basics, https://javascript.info/data-types -->

!!! Abstract "Outline"

    JavaScript 的普通对象更像可变属性表，不像“轻量 class 实例”。数组、函数、Date、Map、Set 都要放回对象模型和引用语义里看，很多坑就出在属性访问、引用共享、转换协议和集合边界上。

    - [x] [1. 对象字面量、属性访问与引用共享](#chapter-objects-reference)
    - [x] [2. 垃圾回收、方法与 `this`](#chapter-objects-this)
    - [x] [3. 构造函数、optional chaining 与 Symbol](#chapter-objects-constructor)
    - [x] [4. Primitive wrapper、Number 与 String](#chapter-data-primitive)
    - [x] [5. Array、Iterable、Map 与 Set](#chapter-data-collections)
    - [x] [6. Destructuring、Date 与 JSON](#chapter-data-structured)

## 1. 对象字面量、属性访问与引用共享 { #chapter-objects-reference }

JavaScript 的普通对象/Object 可以先当成一张动态属性表：键通常是 string 或 symbol，值可以是任意 JS 值。对象字面量 `{}` 会创建新对象，点号访问适合固定属性名，方括号访问适合运行时计算出来的键。

```js
const user = {
  name: "Ada",
  "preferred-theme": "dark",
};

user.name;
user["preferred-theme"];

const key = "name";
user[key];
```

点号后的名字不是表达式，`user.key` 读的是字面属性 `"key"`；方括号里才会先计算表达式。这个差异在写配置读取、JSON 对象和 VSCode command metadata 时很常见，因为外部数据的键名不一定是合法 identifier，也不一定在编码时已知。

属性可以动态增删。`delete obj.prop` 删除属性本身，不是把值设为 `undefined`。读取不存在的属性得到 `undefined`，这也是为什么 `undefined` 经常表示“没有这个东西”。

```js
const item = {};
item.enabled = true;
delete item.enabled;
item.enabled; // undefined
```

对象属性名最终会被转换成 property key。普通对象里，非 symbol 的 key 会变成 string，所以 `obj[1]` 和 `obj["1"]` 访问的是同一个属性。普通对象也因此不适合做“任意值到任意值”的映射：对象 key 会先被转成字符串，多个对象可能撞成同一个 `"[object Object]"`。需要对象作为 key 时用 `Map`。

对象赋值复制的是引用，不复制对象内容。这个规则比“对象是引用类型”更具体：变量里保存的是指向对象的引用值，把它赋给另一个变量，只是多了一个名字指向同一个对象。

```js
const a = { count: 1 };
const b = a;

b.count = 2;
a.count; // 2
```

这和 Python 的 list/dict 绑定很像，和 Rust 的 move/borrow 不是一个模型。JS 没有所有权检查，也没有默认深拷贝。函数参数传递同样复制引用值，所以函数内部修改对象属性会影响调用者可见的对象。

```js
function enable(config) {
  config.enabled = true;
}

const config = {};
enable(config);
config.enabled; // true
```

浅拷贝可以用 spread 或 `Object.assign`，但它只复制第一层属性值。如果属性值本身还是对象，复制后的两个外层对象仍然共享内层对象。

```js
const original = { ui: { theme: "dark" } };
const copy = { ...original };

copy.ui.theme = "light";
original.ui.theme; // "light"
```

深拷贝没有一个适合所有对象的简单语法。`structuredClone` 能处理很多结构化数据，但函数、DOM node、某些宿主对象不在普通 JSON 数据范围内。`JSON.parse(JSON.stringify(obj))` 更粗糙，会丢掉 `undefined`、function、symbol、Date 类型和循环引用。它可以处理简单配置对象，不适合拿来拷运行时对象。

对象比较也只比较引用。两个内容相同的对象字面量不是同一个对象。

```js
{} === {}; // false

const x = {};
const y = x;
x === y; // true
```

这会影响缓存和去重逻辑。如果你用对象作为 Map key，判断的是对象身份/Object Identity；如果你想按内容去重，需要自己生成稳定 key，例如 JSON schema、URI string 或业务 id。

## 2. 垃圾回收、方法与 `this` { #chapter-objects-this }

JavaScript 使用可达性/Reachability 判断对象是否能被回收。从 roots 出发还能访问到的对象会保留；不可达对象可以被垃圾回收。roots 包括当前调用栈里的局部变量、闭包捕获的变量、全局对象上的属性、宿主环境持有的引用等。

这个模型对插件很重要。event listener、timer、subscription 都可能让对象继续可达。VSCode 插件里经常把 disposable push 到 `context.subscriptions`，等于把资源生命周期交给宿主管理。忘记 dispose，或者让闭包长期捕获大对象，垃圾回收不会替你判断“这个逻辑上已经没用了”。

对象属性值如果是函数，这个函数通常被称为方法/Method。JS 的方法没有自动绑定接收者，`this` 看调用表达式，不看函数定义位置。

```js
const user = {
  name: "Ada",
  sayHi() {
    return this.name;
  },
};

user.sayHi(); // "Ada"

const f = user.sayHi;
f(); // strict mode 下 this 是 undefined
```

`user.sayHi()` 这个调用表达式把 `user` 作为 base object，因此函数体里的 `this` 是 `user`。`const f = user.sayHi` 只是取出函数值，后面 `f()` 是裸调用，没有 base object。strict mode 下裸调用的 `this` 是 `undefined`；非 strict 普通函数里可能退回全局对象，这更危险。

这一点解释了很多 VSCode 回调里的 bug。把实例方法直接传给 API，经常会丢失 `this`：

```js
class Runner {
  constructor(output) {
    this.output = output;
  }

  run() {
    this.output.appendLine("run");
  }
}

const runner = new Runner(output);
context.subscriptions.push(
  vscode.commands.registerCommand("demo.run", runner.run)
);
```

当 VSCode 调用这个 handler 时，它只拿到了函数值 `runner.run`，不会自动把 `runner` 作为 `this`。修法是传箭头函数，或者显式绑定。

```js
vscode.commands.registerCommand("demo.run", () => runner.run());
vscode.commands.registerCommand("demo.runBound", runner.run.bind(runner));
```

箭头函数没有自己的 `this`，它读取外层词法环境里的 `this`。这让它很适合做回调，却不适合作为对象方法。对象方法写成箭头函数后，`this` 不会指向该对象，而会沿外层作用域找。

```js
const bad = {
  name: "Ada",
  sayHi: () => this.name,
};
```

这里的 `this` 不是 `bad`。这不是风格问题，是语义问题。对象方法用普通方法语法，回调用箭头函数，是最稳妥的默认选择。

## 3. 构造函数、optional chaining 与 Symbol { #chapter-objects-constructor }

JavaScript 的构造函数/Constructor Function 是可以被 `new` 调用的普通函数。约定上构造函数首字母大写。`new Fn(args)` 会创建一个新对象，把它作为 `this` 传入函数，执行函数体，然后默认返回这个新对象。

```js
function User(name) {
  this.name = name;
  this.isAdmin = false;
}

const user = new User("Ada");
```

如果构造函数显式返回对象，`new` 的结果会变成那个对象；如果返回 primitive，则返回值被忽略。现代代码更多使用 `class` 语法，但 class 仍然落在原型和构造调用机制上，构造函数这层不能完全跳过。

Optional chaining `?.` 用来安全穿过可能为空的引用。它能用于属性读取、方括号读取和函数调用。

```js
const title = item.metadata?.title;
const value = mapLike?.[key];
listener?.(event);
```

它只在左侧是 `null` 或 `undefined` 时短路。它不会吞掉所有错误。如果 `listener` 存在但不是函数，`listener?.(event)` 仍然会抛 `TypeError`。如果 `item.metadata` 的 getter 自己抛异常，`?.` 也不会吞掉。

`Symbol` 是唯一且不可意外碰撞的 property key。`Symbol("id")` 每次都会创建新的 symbol，即使描述字符串相同也不相等。它常用来给对象挂内部协议属性，避免和用户数据字段冲突。

```js
const internal = Symbol("internal");
const obj = {
  visible: true,
  [internal]: 42,
};
```

内置 symbol 更关键。`Symbol.iterator` 定义对象如何被 `for...of`、spread 和 destructuring 消费。一个对象只要提供这个方法，就能进入 JS 的 iterable 协议。

```js
const range = {
  from: 1,
  to: 3,
  [Symbol.iterator]() {
    let current = this.from;
    const last = this.to;
    return {
      next() {
        if (current <= last) {
          return { value: current++, done: false };
        }
        return { done: true };
      },
    };
  },
};

[...range]; // [1, 2, 3]
```

这里 `Symbol.iterator` 返回 iterator，iterator 的 `next()` 每次返回 `{ value, done }`。数组、字符串、Map、Set 都已经实现了这个协议，所以它们能被 `for...of` 和 spread 处理。

## 4. Primitive wrapper、Number 与 String { #chapter-data-primitive }

JavaScript 的 primitive 包括 string、number、bigint、boolean、symbol、null、undefined。除了 `null` 和 `undefined`，primitive 看起来能调用方法：

```js
"hello".toUpperCase();
(42).toString();
```

这靠的是临时对象包装/Primitive Wrapper。访问方法时，引擎临时创建对应 wrapper object，让方法运行，随后丢掉这个对象。因此 primitive 本身仍然不是对象，给 primitive 写属性没有可持续意义。

```js
let text = "hello";
text.extra = 1; // non-strict ignored; strict mode throws TypeError
text.extra;     // undefined if the assignment was ignored
```

避免手写 `new String("x")`、`new Number(1)`、`new Boolean(false)`。它们创建的是对象，不是 primitive。尤其 `new Boolean(false)` 是 truthy，因为任何对象都是 truthy。

Number 的坑主要来自 double 精度。`0.1 + 0.2 !== 0.3` 不是 JS 独有，但 JS 里普通数字全是这套模型，所以没有整数类型帮你隔离问题。安全整数范围用 `Number.MAX_SAFE_INTEGER` 判断；超出范围的精确整数要用 `bigint` 或字符串。

```js
0.1 + 0.2; // 0.30000000000000004
Number.isSafeInteger(9007199254740993); // false
```

字符串是 UTF-16 code units 序列。`length` 统计的是 code unit 数，不是用户眼中的字符数。emoji、组合字符、部分 Unicode 字符会让长度和索引行为偏离直觉。普通插件命令标题、配置 key、URI 处理通常不需要深入 Unicode 内部；复杂文本处理别靠 `str[i]` 硬切。

字符串方法大多不修改原字符串，而是返回新字符串。`slice`、`trim`、`replace`、`toLowerCase` 都是这个模式。primitive 不可变，变量重绑才会看到新值。

```js
let name = " Ada ";
name.trim(); // "Ada"
name;        // " Ada "
name = name.trim();
```

## 5. Array、Iterable、Map 与 Set { #chapter-data-collections }

Array 是对象，但它有专门的 `length` 和整数索引行为。`length` 记录最大索引加一的边界，不是严格的元素个数。给很大的索引赋值会拉大 `length`，删除元素不会自动压缩数组。

```js
const arr = [];
arr[2] = "x";
arr.length; // 3
0 in arr;   // false
```

这种带空洞的数组/Sparse Array 会制造很多不合直觉的行为。大多数业务代码应该把数组当成连续序列。删除元素用 `splice`，过滤元素用 `filter` 返回新数组，别靠 `delete` 挖洞。

数组方法要按行为记。`push`、`pop`、`shift`、`unshift`、`splice`、`sort`、`reverse` 会修改原数组；`slice`、`concat`、`map`、`filter`、`toSorted`、`toReversed` 返回新数组。`find` 和 `some` 会短路，`map` 不会。`forEach` 的返回值会被丢弃，不适合写异步流程控制。

```js
const xs = [3, 1, 2];
const sorted = xs.toSorted();
xs;     // [3, 1, 2]
sorted; // [1, 2, 3]
```

老的 `sort` 默认按字符串比较，这是另一个经典坑。

```js
[1, 10, 2].sort();           // [1, 10, 2] as strings
[1, 10, 2].sort((a, b) => a - b); // [1, 2, 10]
```

`map`、`filter`、`reduce` 是数组方法，不是语言级循环魔法。`map` 用于一对一转换，`filter` 用于筛选，`reduce` 用于累计状态。如果只是为了副作用，用 `for...of` 更清楚。特别是 async 场景下，`forEach(async () => {})` 不会等待内部 Promise。

```js
for (const uri of uris) {
  await processUri(uri);
}
```

`for...of` 消费的是 iterable，不是普通对象属性。数组、字符串、Map、Set 都可以 `for...of`；普通对象要先用 `Object.keys`、`Object.values` 或 `Object.entries` 转成数组。

Map 才是通用键值映射，key 可以是任意值，并按对象身份区分对象 key。Set 是唯一值集合，也按 SameValueZero 规则比较值：`NaN` 可以等于 `NaN`，对象仍然按引用身份。

```js
const cache = new Map();
const key = { uri: "file:///a.ts" };
cache.set(key, "diagnostics");
cache.get(key); // "diagnostics"

const seen = new Set([NaN, NaN]);
seen.size; // 1
```

WeakMap 和 WeakSet 的 key 必须是对象，并且不阻止 key 被垃圾回收。它们适合给对象附加外部元数据，例如给某些 AST node、document object 或 provider instance 记录缓存，同时不强行延长对象生命周期。代价是不可迭代，也拿不到 size，因为可回收对象集合本身不稳定。

## 6. Destructuring、Date 与 JSON { #chapter-data-structured }

Destructuring assignment 是从数组或对象里按结构取值。数组解构按位置，对象解构按属性名。默认值只在取到 `undefined` 时生效。

```js
const [first, second = "fallback"] = items;
const { title, range: selectedRange } = command;
```

对象解构里的 `range: selectedRange` 读取 `command.range`，再绑定到本地变量 `selectedRange`。这个语法第一次看很反直觉，因为冒号左边是属性名，右边才是新变量名；处理 VSCode API 返回的大对象时很常见。

函数参数也可以解构，适合配置对象。默认空对象通常要写在参数层，否则调用者完全不传参数时，解构 `undefined` 会抛异常。

```js
function createItem({ title, description = "" } = {}) {
  return { title, description };
}
```

Date 表示一个时间点，内部存的是从 Unix epoch 开始的毫秒数。它同时提供 local time 和 UTC 方法，所以麻烦点通常不在创建，而在时区解释。`new Date("2026-05-27")` 这类字符串解析在不同语义下容易产生偏移；需要稳定日期时，明确使用 ISO 字符串、时间戳，或者专门的日期库。

JSON 是数据交换格式，不是 JavaScript 对象字面量的完全子集。`JSON.stringify` 会忽略 `undefined`、function、symbol 属性；`Date` 会经由 `toJSON` 变成字符串；循环引用会抛异常。`JSON.parse` 可以用 reviver 二次转换，但默认不会帮你恢复 Date、Map、Set 或 class 实例。

```js
const raw = JSON.stringify({
  createdAt: new Date("2026-05-27T00:00:00Z"),
  skip: undefined,
});

JSON.parse(raw);
```

VSCode 插件里经常读写 JSON 配置、package metadata、workspace state。要把 JSON 当成边界格式：进入程序后转换成内部结构，离开程序前再序列化，不要假设 JSON 能保留运行时对象的身份、方法和原型。
