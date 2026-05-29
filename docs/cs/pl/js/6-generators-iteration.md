# Generators 与高级迭代

<!-- Source: https://javascript.info/generators, https://javascript.info/async-iterators-generators -->
<!-- Source: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Iterator -->
<!-- Source: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fromAsync -->

!!! Abstract "Outline"

    Generator 把函数调用拆成多次恢复，Iteration Protocol 把“下一个值从哪里来”变成统一接口；异步版本再把每一步 `next()` 包进 Promise。读文件、分页 API、流式结果和可取消任务时，这套模型比一次性数组更贴近真实控制流，Iterator Helpers 则把惰性变换也留在这条链上。

    - [x] [1. Generator function 的暂停点](#chapter-generators-pause)
    - [x] [2. Generator object、iterator 与 iterable](#chapter-generators-iterable)
    - [x] [3. `yield*`、双向通信与提前结束](#chapter-generators-yield-star)
    - [x] [4. Async iterable 与 `for await...of`](#chapter-generators-async-iterable)
    - [x] [5. Async generator 的实际位置](#chapter-generators-async-generator)
    - [x] [6. Iterator Helpers 与 `Array.fromAsync`](#chapter-generators-iterator-helpers)

## 1. Generator function 的暂停点 { #chapter-generators-pause }

普通函数一旦开始执行，就会一路跑到 `return` 或抛异常。Generator function 不一样。`function*` 定义的函数被调用时，函数体不会立刻执行；它返回一个 generator object。之后每次调用 `.next()`，函数才从上一次暂停的位置继续跑，直到遇到下一个 `yield`。

```js
function* numbers() {
  yield 1;
  yield 2;
  return 3;
}

const gen = numbers();

gen.next(); // { value: 1, done: false }
gen.next(); // { value: 2, done: false }
gen.next(); // { value: 3, done: true }
```

`yield` 是暂停点，不是单纯返回值。第一次 `.next()` 会让函数从开头跑到第一个 `yield`；第二次 `.next()` 会从第一个 `yield` 后面继续。`return` 给出的值会出现在最后一次 `.next()` 的 `value` 里，但 `done: true` 也表示迭代已经结束。`for...of` 会消费 `done: false` 的值，通常不会拿到最后这个 `return` 值。

```js
for (const value of numbers()) {
  console.log(value);
}
// 1, 2
```

所以 generator 的 `return` 更像“结束时给手动调用者看的结果”，不是序列中的最后一个元素。要让 `3` 也进入 `for...of`，就写 `yield 3`。

## 2. Generator object、iterator 与 iterable { #chapter-generators-iterable }

JavaScript 的迭代协议/Iteration Protocol 分两层。Iterator 有 `.next()` 方法，每次返回 `{ value, done }`。Iterable 有 `[Symbol.iterator]()` 方法，返回一个 iterator。Generator object 同时满足这两层：它自己有 `.next()`，也有 `[Symbol.iterator]()`，而且 `[Symbol.iterator]()` 返回自己。

```js
function* range(from, to) {
  for (let current = from; current <= to; current++) {
    yield current;
  }
}

const values = range(1, 3);

values[Symbol.iterator]() === values; // true
[...range(1, 3)]; // [1, 2, 3]
```

这让 generator 很适合替代手写 iterator。上一页如果要自己实现 `Symbol.iterator`，需要维护 `current`、返回 object、写 `next()`。Generator 把这些样板折叠掉，保留“每一步产出什么”。

```js
const rangeObject = {
  from: 1,
  to: 3,

  *[Symbol.iterator]() {
    for (let current = this.from; current <= this.to; current++) {
      yield current;
    }
  },
};

[...rangeObject]; // [1, 2, 3]
```

这里 `*[Symbol.iterator]()` 是一个 generator method。它让普通对象直接变成 iterable。对插件开发来说，这种写法适合把内部集合、懒加载结果或遍历状态暴露成可迭代接口，而不是一次性构造数组。

## 3. `yield*`、双向通信与提前结束 { #chapter-generators-yield-star }

`yield*` 用来把一个 iterable 的产出委托给当前 generator。它不是简单循环的语法糖那么浅，因为它还会转发 `.next(value)`、`.throw(error)` 和 `.return(value)` 这类控制信号。

```js
function* digits() {
  yield* [0, 1, 2];
  yield* [3, 4, 5];
}

[...digits()]; // [0, 1, 2, 3, 4, 5]
```

组合 generator 时，`yield*` 比手写 `for...of` 更能表达“当前序列由另一个序列接上来”。如果被委托的 generator 有自己的 `return` 值，`yield*` 表达式本身还能拿到它。

Generator 也可以从外部接收值。`.next(value)` 的参数会成为上一个 `yield` 表达式的结果。注意第一次 `.next(value)` 的参数会被忽略，因为函数还没有停在任何 `yield` 上。

```js
function* ask() {
  const name = yield "name?";
  const age = yield "age?";
  return `${name}: ${age}`;
}

const gen = ask();

gen.next();       // { value: "name?", done: false }
gen.next("Ada");  // { value: "age?", done: false }
gen.next(28);     // { value: "Ada: 28", done: true }
```

这套双向通信能力很强，但普通业务代码里不要急着用。它会把控制流分散到 generator 内外两边，调试成本高。更常见的用途还是惰性产出值，或者把状态机写成可暂停的序列。

`.throw(error)` 会把异常注入 generator 当前暂停的 `yield` 位置。Generator 内部可以用 `try...catch` 捕获。`.return(value)` 会请求 generator 提前结束，并触发 `finally`。

```js
function* lines() {
  try {
    yield "first";
    yield "second";
  } finally {
    console.log("cleanup");
  }
}

const gen = lines();
gen.next();
gen.return();
```

这个 cleanup 行为不能省。一个 generator 如果持有文件句柄、锁、临时状态，提前结束时应该有机会释放资源。不过 JavaScript 的 generator 本身不是资源管理万能方案，I/O 资源还要看宿主 API。

## 4. Async iterable 与 `for await...of` { #chapter-generators-async-iterable }

同步 iterable 的 `.next()` 立刻返回 `{ value, done }`。异步 iterable/Async Iterable 的下一步结果要等未来才知道，所以 `[Symbol.asyncIterator]()` 返回 async iterator，而 async iterator 的 `.next()` 返回 Promise。

```js
const asyncRange = {
  from: 1,
  to: 3,

  [Symbol.asyncIterator]() {
    let current = this.from;
    const last = this.to;

    return {
      async next() {
        await new Promise((resolve) => setTimeout(resolve, 100));

        if (current <= last) {
          return { value: current++, done: false };
        }

        return { done: true };
      },
    };
  },
};
```

消费 async iterable 要用 `for await...of`。它每一轮都会等待 `.next()` 返回的 Promise settle，再决定是否进入循环体。

```js
for await (const value of asyncRange) {
  console.log(value);
}
```

`for await...of` 的价值在于把“每次拿下一项都可能异步”写成普通循环形状。分页 API、文件流、网络流、语言服务逐步产出结果，都比一次性 `await getAll()` 更适合这个模型。

同步 iterable 可以用 `for...of`，异步 iterable 要用 `for await...of`。不要混用。`for...of` 不会等待 async iterator 的 Promise；`for await...of` 虽然也能处理同步 iterable，但语义上已经进入异步循环，错误传播和调度都要按 Promise 看。

## 5. Async generator 的实际位置 { #chapter-generators-async-generator }

`async function*` 同时具备 async function 和 generator 的特征：函数调用后返回 async generator object；每次 `.next()` 返回 Promise；函数体内部可以 `await`，也可以 `yield`。

```js
async function* fetchPages(urls) {
  for (const url of urls) {
    const response = await fetch(url);
    yield await response.json();
  }
}

for await (const page of fetchPages(urls)) {
  consume(page);
}
```

这段代码的控制流很清楚：每次循环先等待当前 URL 的响应，再产出一页结果。它不会一次性启动所有请求。如果想并发，需要显式用 `Promise.all` 或并发池；async generator 默认表达的是“按顺序、可逐步消费”的异步序列。

VSCode 插件里不一定常直接暴露 async generator，但它的模型很有用。比如逐步扫描 workspace 文件、批量分析文档、分批读取外部工具输出，都可以先写成 async generator，再由上层决定是逐步展示、收集成数组，还是在 cancellation token 触发时提前退出。

```js
async function* analyzeDocuments(documents, token) {
  for (const document of documents) {
    if (token.isCancellationRequested) {
      return;
    }

    yield await analyze(document);
  }
}
```

这里的 `return` 会结束 async generator。消费端的 `for await...of` 自然停止，不需要额外的 sentinel value。这个模式比返回 `null`、`undefined` 或特殊字符串干净得多。

## 6. Iterator Helpers 与 `Array.fromAsync` { #chapter-generators-iterator-helpers }

Generator 解决的是惰性产出，Iterator Helpers 补上的是惰性变换。数组方法的默认姿势是先有完整数组，再 `map`、`filter`、`slice`；iterator helper 的姿势是每次只拉取下一项，顺手完成变换，再把结果交给下一个消费者。

```js
const firstMarkdownFiles = files
  .values()
  .filter((file) => file.endsWith(".md"))
  .map((file) => file.toLowerCase())
  .take(20)
  .toArray();
```

这里 `.values()` 返回的是 iterator，后面的 `.filter()`、`.map()`、`.take()` 才是 iterator helper。它们不是挂在所有 iterable 上的 helper，所以普通对象只要有 `[Symbol.iterator]()`，也不能直接写 `object.map(...)`。要先拿到 iterator，或者让自己的 iterator 继承标准 `Iterator` 能力。

惰性 helper 分两类。`map`、`filter`、`take`、`drop`、`flatMap` 返回新的 iterator helper object，不会立刻消费完整输入；`toArray`、`reduce`、`some`、`every`、`find`、`forEach` 是终端操作，会真的向底层 iterator 要值。`some`、`every`、`find` 还能短路，找到结果后就不再继续拉后面的值。

Iterator 仍然是一次性数据源。helper 共享同一个底层 iterator，消费 helper 就是在推进原 iterator。这里没有“复制一条流”的语义。

```js
const values = [1, 2, 3].values();
const doubled = values.map((value) => value * 2);

doubled.next(); // { value: 2, done: false }
values.next();  // { value: 2, done: false }，原 iterator 已经被推进
```

这正是它适合大数据、流式结果和分页 API 的原因，也是它不适合“我想反复遍历同一批值”的原因。需要反复遍历时，把结果 materialize 成数组，或者让数据源重新创建新的 iterator。

`Array.fromAsync` 是 async iterable 世界里的收集器。它返回 Promise，最终 fulfilled 成数组。它可以消费 async iterable，也可以消费普通 iterable 或 array-like；如果输入元素本身是 Promise，它会按消费顺序等待。

```js
async function* readPages(urls) {
  for (const url of urls) {
    const response = await fetch(url);
    yield response.json();
  }
}

const pages = await Array.fromAsync(readPages(urls));
```

`Array.fromAsync(iterableOfPromises)` 不是 `Promise.all(iterableOfPromises)` 的别名。`Array.fromAsync` 按 `for await...of` 的风格顺序消费：当前值 settle 后才取下一项。`Promise.all` 会先拿到所有 Promise，再并发等待。前者适合背压、分页、顺序读取和可提前停止的来源；后者适合已经有完整任务列表、并且任务互不依赖的并发等待。

```js
const sequential = await Array.fromAsync(makePromises());
const concurrent = await Promise.all(makePromises());
```

如果 `makePromises()` 是 generator，`sequential` 会一边产出一边等待；`concurrent` 会先把 generator 产出的 Promise 全部取出来。差别涉及速度、资源占用、错误时机和副作用时机。插件里扫描 workspace、逐步请求语言服务、按批读取外部工具输出时，这个边界比方法名本身重要。
