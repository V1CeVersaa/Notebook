# Proxy、Eval 与运行时边缘机制

<!-- Source: https://javascript.info/proxy, https://javascript.info/eval, https://javascript.info/currying-partials, https://javascript.info/reference-type, https://javascript.info/bigint, https://javascript.info/unicode, https://javascript.info/weakref-finalizationregistry -->

!!! Abstract "Outline"

    Miscellaneous 这一章收的是不常每天写、但一旦遇到就必须知道边界的机制：Proxy 改写对象操作，eval 动态执行字符串，currying 改变调用形状，Reference Type 解释 `this` 为什么会丢，BigInt 和 Unicode 修正数值与字符串的底层直觉，WeakRef 则暴露垃圾回收的不确定性。

    - [x] [1. Proxy、trap 与 Reflect](#chapter-misc-proxy)
    - [x] [2. Proxy invariant 与对象边界](#chapter-misc-proxy-invariant)
    - [x] [3. Eval、currying 与 Reference Type](#chapter-misc-eval-reference)
    - [x] [4. BigInt 与数值边界](#chapter-misc-bigint)
    - [x] [5. Unicode、UTF-16 与字符串边界](#chapter-misc-unicode)
    - [x] [6. WeakRef 与 FinalizationRegistry](#chapter-misc-weakref)

## 1. Proxy、trap 与 Reflect { #chapter-misc-proxy }

Proxy 允许拦截对象上的基本操作。`new Proxy(target, handler)` 会创建一个代理对象；外部对代理的读取、赋值、函数调用、构造、枚举等操作，可以被 handler 里的 trap 接管。

```js
const target = {};

const proxy = new Proxy(target, {
  get(target, prop, receiver) {
    if (prop === "missing") {
      return "fallback";
    }

    return Reflect.get(target, prop, receiver);
  },
});

proxy.missing; // "fallback"
```

`get` trap 拦截属性读取。这里没有直接写 `target[prop]`，而是用 `Reflect.get(target, prop, receiver)` 转发默认行为。Reflect 是一组和对象底层操作对应的函数。写 Proxy 时，Reflect 经常是最好的默认转发方式，因为它会保留 receiver、返回值约定和语言细节。

常见 trap 包括 `get`、`set`、`has`、`deleteProperty`、`ownKeys`、`apply`、`construct`。如果 target 是函数，还可以用 `apply` 拦截调用，用 `construct` 拦截 `new`。

```js
function sum(a, b) {
  return a + b;
}

const loggedSum = new Proxy(sum, {
  apply(target, thisArg, args) {
    console.log("sum", args);
    return Reflect.apply(target, thisArg, args);
  },
});
```

Proxy 很适合写边界层：校验对象属性、记录访问日志、懒加载、虚拟对象、RPC stub、响应式系统。Vue 3 的 reactivity 就大量使用 Proxy。普通业务逻辑里不要为了“优雅”滥用 Proxy；它会把一次普通属性访问变成任意代码执行，调试成本很高。

## 2. Proxy invariant 与对象边界 { #chapter-misc-proxy-invariant }

Proxy 不是想怎么骗引擎都行。语言规定了一组 invariant，防止代理破坏对象模型。比如一个不可配置、不可写的数据属性，`get` trap 不能返回和真实值不一致的结果；`ownKeys` 不能隐藏不可配置属性；`setPrototypeOf` 不能随便违反 target 的不可扩展状态。

```js
const target = {};

Object.defineProperty(target, "id", {
  value: 1,
  configurable: false,
  writable: false,
});

const proxy = new Proxy(target, {
  get() {
    return 2;
  },
});

// proxy.id; // TypeError
```

这些 invariant 很有用。它们保证 `Object.freeze`、non-configurable property、prototype 这些底层约束不会被 Proxy 随手抹掉。也就是说，Proxy 可以改写操作，但不能把语言对象系统改成完全不可信。

`receiver` 参数也要认真看。getter 里的 `this` 通常应该是最初访问属性的对象，而不是保存 getter 的 target。`Reflect.get(target, prop, receiver)` 会把 receiver 正确传下去。

```js
const user = {
  firstName: "Ada",
  get name() {
    return this.firstName;
  },
};

const proxy = new Proxy(user, {
  get(target, prop, receiver) {
    return Reflect.get(target, prop, receiver);
  },
});
```

如果把转发写成 `target[prop]`，getter 的 `this` 会变成 target，在继承、代理嵌套或响应式对象里容易出错。Proxy 看起来是“拦截属性”，实际是在拦截语言的内部方法；细节比普通对象访问多一层。

## 3. Eval、currying 与 Reference Type { #chapter-misc-eval-reference }

`eval(code)` 会把字符串当 JavaScript 代码执行。直接 eval 可以访问当前词法环境；间接 eval 通常在全局环境执行。无论哪种，eval 都会破坏静态分析、安全边界和优化假设。

```js
const x = 1;

eval("console.log(x)");
```

插件代码基本不该让用户输入变成 eval。需要配置行为时，用 JSON、表达式 AST、白名单策略或小型解释器。`new Function` 至少不会访问当前局部作用域，但它仍然是在执行字符串代码，安全问题没有消失。

Currying 把多参数函数改成一串单参数函数调用。`f(a, b, c)` 变成 `f(a)(b)(c)`。它适合提前固定上下文，或者把函数组合管线写得更细。

```js
function curry(fn) {
  return function curried(...args) {
    if (args.length >= fn.length) {
      return fn.apply(this, args);
    }

    return function (...nextArgs) {
      return curried.apply(this, args.concat(nextArgs));
    };
  };
}

const sum3 = (a, b, c) => a + b + c;
curry(sum3)(1)(2)(3); // 6
```

Currying 和 partial application 很接近，但不完全一样。Partial application 固定一部分参数，返回一个还需要剩余参数的函数；currying 关注的是把参数拆成一层层调用。JS 标准库没有内置 curry。实际写插件时，简单的闭包或 `bind` 常常比通用 curry 更清楚。

Reference Type 是规范内部用来解释 `this` 的机制。表达式 `obj.method` 在调用前会同时保留函数值和 base object；`obj.method()` 因此能把 `this` 设成 `obj`。一旦把方法取出来赋给变量，base object 就没了。

```js
const obj = {
  value: 1,
  getValue() {
    return this.value;
  },
};

obj.getValue(); // 1

const fn = obj.getValue;
fn(); // strict mode 下 this 是 undefined
```

这个内部机制解释了前面反复提到的 `this` 丢失问题。`obj.method()` 和 `(obj.method)()` 仍然保留 reference；`(0, obj.method)()`、赋值、参数传递都会把它变成普通函数值。读源码时看到“方法被传出去”，就要立刻想 `this` 还在不在。

## 4. BigInt 与数值边界 { #chapter-misc-bigint }

BigInt 表示任意精度整数，字面量以 `n` 结尾。它解决的是安全整数范围以外的精确整数问题，不是浮点数问题。

```js
const id = 9007199254740993n;
id + 1n; // 9007199254740994n
```

BigInt 不能和 number 直接混算。比较可以做一部分跨类型比较，但算术不行。

```js
1n == 1;  // true
1n === 1; // false
// 1n + 1; // TypeError
```

这个限制看起来烦，其实是在阻止隐式精度损失。要混用就显式转换，但转换方向要自己负责：`Number(bigint)` 可能丢精度，`BigInt(number)` 要求 number 是整数。

BigInt 除法会截断小数部分。

```js
5n / 2n; // 2n
```

它也不能直接用于 `Math` 方法，不能被 JSON 原生序列化。写插件时，如果外部协议里有超大整数 ID，通常要在边界上决定：内部用 BigInt，序列化时转字符串；或者干脆全程用字符串保存 ID，避免和 number 混在一起。

## 5. Unicode、UTF-16 与字符串边界 { #chapter-misc-unicode }

JavaScript 字符串使用 UTF-16 code units。`length` 统计 code unit，不统计用户眼里的字符。BMP 之外的字符需要两个 code units，也就是 surrogate pair。

```js
"𝒳".length; // 2
"𝒳"[0];    // half of a surrogate pair
```

要按 Unicode code point 处理，可以用 `codePointAt` 和 `String.fromCodePoint`。

```js
const s = "𝒳";
s.codePointAt(0).toString(16);
String.fromCodePoint(0x1d4b3);
```

`for...of` 按 code point 迭代字符串，比索引访问更适合处理 emoji 或 BMP 外字符。

```js
for (const char of "𝒳a") {
  console.log(char);
}
```

另一个坑是组合字符。某些字符可以写成一个预组合 code point，也可以写成基础字符加 combining mark。视觉上相同，二进制序列不同，字符串比较也可能不同。`normalize()` 用来做 Unicode normalization。

```js
const a = "é";
const b = "e\u0301";

a === b; // false
a.normalize() === b.normalize(); // true
```

VSCode 插件里如果只是处理命令 ID、配置 key、URI，大多不需要深入 Unicode。但一旦处理用户文本、光标偏移、诊断 range，就不能把 `string.length` 直接当“字符数”。VSCode 的 `Position` 和 `Range` 也有自己的 UTF-16 位置模型，和用户看到的 grapheme cluster 不是同一个层级。

## 6. WeakRef 与 FinalizationRegistry { #chapter-misc-weakref }

WeakRef 创建弱引用。弱引用不会阻止对象被垃圾回收；调用 `.deref()` 时，如果对象还活着，就返回对象，否则返回 `undefined`。

```js
let object = { data: "cache" };
const ref = new WeakRef(object);

object = null;

const value = ref.deref();
```

这听起来很适合缓存，但要小心：垃圾回收什么时候发生不由程序控制。今天 `.deref()` 返回对象，下一次就可能是 `undefined`。不能把 WeakRef 用在业务正确性上，只能用在“有就用，没有就重建”的优化路径上。

FinalizationRegistry 允许注册一个 cleanup callback，当对象被垃圾回收后，宿主未来某个时刻可能调用它。

```js
const registry = new FinalizationRegistry((heldValue) => {
  console.log("collected", heldValue);
});

let object = {};
registry.register(object, "object metadata");
object = null;
```

这里的关键词是“可能”和“未来某个时刻”。Finalization callback 不保证及时运行，甚至在进程退出前不一定运行。它不能替代 `dispose()`、`finally` 或显式资源释放。

插件开发里更稳的生命周期模型仍然是 disposable：谁注册资源，谁把 disposable 放进 `context.subscriptions` 或在合适时机手动 dispose。WeakRef 和 FinalizationRegistry 可以做缓存兜底，不能做资源管理主路径。
