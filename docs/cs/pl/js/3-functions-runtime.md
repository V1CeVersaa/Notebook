# 函数对象、闭包与运行时边界

<!-- Source: https://javascript.info/advanced-functions -->

!!! Abstract "Outline"

    JavaScript 函数是一等对象，闭包会让词法环境活过函数调用，`this` 又由调用点决定。异步回调、装饰器转发、timer 和 VSCode command handler 都要靠这几条规则拼起来。

    - [x] [1. 调用栈、递归与 rest/spread](#chapter-functions-stack)
    - [x] [2. 词法环境、闭包与老 `var`](#chapter-functions-closure)
    - [x] [3. Global object、function object 与 NFE](#chapter-functions-object)
    - [x] [4. `new Function`、timer 与调度边界](#chapter-functions-scheduling)
    - [x] [5. Decorator forwarding、`call/apply` 与 `bind`](#chapter-functions-forwarding)
    - [x] [6. 箭头函数、回调值与 VSCode API](#chapter-functions-vscode)

## 1. 调用栈、递归与 rest/spread { #chapter-functions-stack }

每次函数调用都会创建一个执行上下文/Execution Context，并压入调用栈/Call Stack。递归只是函数在自己的执行过程中再次调用自己，所以它消耗的是调用栈空间，而不是某种特殊循环结构。

```js
function sumTo(n) {
  if (n === 1) return 1;
  return n + sumTo(n - 1);
}
```

这段递归读起来清楚，但在 JavaScript 里不能指望尾调用优化救你。规范曾经讨论过 proper tail calls，主流引擎的现实支持不适合作为日常假设。处理文件树、AST、JSON schema 这类可能很深的数据结构时，深递归更适合改成循环或显式栈。

```js
function sumToLoop(n) {
  let result = 0;
  for (let i = 1; i <= n; i++) {
    result += i;
  }
  return result;
}
```

Rest parameters `...args` 把剩余实参收集成数组。老的 `arguments` 是 array-like object，不是真数组，也不会在箭头函数里创建。现代代码需要可变参数时直接用 rest。

```js
function command(name, ...args) {
  return { name, args };
}
```

Spread syntax 方向相反：它把 iterable 展开。函数调用、数组字面量和对象字面量里都能用 `...`，但含义不同。函数调用和数组要求右侧是 iterable，对象 spread 复制可枚举自有属性。

```js
const xs = [1, 2, 3];
Math.max(...xs);

const base = { enabled: true };
const config = { ...base, timeout: 1000 };
```

对象 spread 是浅复制，和前一页讲的一样，不会递归复制内部对象。这个规则在写 wrapper config 时很重要：`{ ...defaults, ...user }` 只合并第一层。

## 2. 词法环境、闭包与老 `var` { #chapter-functions-closure }

JavaScript 的每个函数、代码块和模块都会关联词法环境/Lexical Environment。词法环境可以看成“标识符到值的绑定表”加上对外层环境的引用。函数创建时会记住它创建位置的外层环境；函数之后在别处调用，仍然能访问当时的外层变量。这种函数和外层绑定一起存活的机制就是**闭包/Closure**。

```js
function makeCounter() {
  let count = 0;

  return function () {
    count += 1;
    return count;
  };
}

const next = makeCounter();
next(); // 1
next(); // 2
```

`makeCounter` 返回后，它的局部变量 `count` 没有被释放，因为返回的函数还引用着那份词法环境。闭包保留的是对绑定的访问，不是创建时的一份值拷贝。很多异步行为都要按这个规则读：

```js
let current = "first";
const read = () => current;

current = "second";
read(); // "second"
```

箭头函数 `read` 捕获的是 `current` 这个绑定，不是创建时的字符串值。要捕获当时的值，需要在新作用域里创建新的绑定，例如函数参数或循环里的 `let`。

```js
const handlers = [];

for (let i = 0; i < 3; i++) {
  handlers.push(() => i);
}

handlers.map((fn) => fn()); // [0, 1, 2]
```

老 `var` 的问题正好在这里。`var` 是函数作用域/Function Scope，不是块级作用域；并且声明会被提升/Hoisting 到函数顶部，初始化仍然留在原位置。循环里用 `var` 会让所有闭包共享同一个绑定。

```js
const bad = [];

for (var i = 0; i < 3; i++) {
  bad.push(() => i);
}

bad.map((fn) => fn()); // [3, 3, 3]
```

现代 JS 基本不用 `var`，硬理由就在这里：它的作用域模型和闭包组合后太容易制造错误状态。

块级函数声明还有历史兼容问题。strict mode 下行为更清楚，非 strict 脚本里不同环境曾有差异。条件创建函数时，用 `let fn` 加函数表达式，别把代码押在块级函数声明的兼容语义上。

```js
let formatter;

if (pretty) {
  formatter = (value) => JSON.stringify(value, null, 2);
} else {
  formatter = (value) => JSON.stringify(value);
}
```

## 3. Global object、function object 与 NFE { #chapter-functions-object }

全局对象/Global Object 是宿主环境提供的顶层对象。浏览器里传统上是 `window`，Node 里是 `global`，跨环境标准入口是 `globalThis`。全局对象可以帮你理解宿主差异，但不适合当状态仓库。

```js
globalThis.setTimeout;
```

在模块里，顶层 `let` 和 `const` 不会变成全局对象属性。老脚本里的 `var` 和函数声明可能会挂到全局对象上，这也是旧代码污染全局命名空间的来源。VSCode 插件一般通过模块系统加载，仍然应该避免写入 `globalThis`，除非是在测试或 polyfill 边界上有明确理由。

函数本身也是对象。它有 `name`、`length` 等属性，也可以挂自定义属性。`length` 表示函数声明中第一个有默认值参数之前的形参数量，不等于实际传入参数数量。

```js
function connect(host, port = 443, options) {}

connect.name;   // "connect"
connect.length; // 1
```

给函数挂属性可以做简单缓存或 metadata，但别让它变成常规状态容器。函数一边表示行为，一边保存状态，测试和热重载都会更绕。多数情况下，闭包或 class 实例更清楚。

命名函数表达式/Named Function Expression/NFE 是函数表达式带内部名字。这个名字只在函数体内部可见，适合递归或让 stack trace 更清楚。

```js
const factorial = function inner(n) {
  return n <= 1 ? 1 : n * inner(n - 1);
};
```

这里外部变量名 `factorial` 可以被重新绑定，但函数体内部的 `inner` 仍然稳定指向自己。普通递归直接用函数声明就行；NFE 的价值在于函数值需要被传来传去，同时还想保留内部自引用。

## 4. `new Function`、timer 与调度边界 { #chapter-functions-scheduling }

`new Function(args..., body)` 会从字符串创建函数，并且只挂到全局词法环境。它访问不到当前局部作用域里的变量，和 `eval` 一样会绕开很多静态约束。

```js
const x = 1;
const fn = new Function("return typeof x");
fn(); // usually "undefined" unless x is global
```

这类动态代码生成会破坏静态分析、类型检查、打包器 tree shaking 和安全审计。插件开发里基本用不上它。需要配置化行为时，用数据描述策略，再在代码里解释数据；别让用户配置直接变成可执行代码。

`setTimeout` 和 `setInterval` 是宿主 API，不是语言语法。它们把回调安排到未来执行，返回 timer id。`setTimeout(fn, 0)` 不表示立刻执行，只表示当前调用栈清空并且宿主调度到它之后，才有机会运行。

```js
console.log("A");
setTimeout(() => console.log("B"), 0);
console.log("C");
// A, C, B
```

`setInterval` 会重复调度，直到 `clearInterval`。如果回调执行时间可能超过间隔，或者需要等待异步任务完成，递归 `setTimeout` 往往更可控，因为下一次调度可以放在当前任务结束后。

```js
async function poll() {
  await refresh();
  timer = setTimeout(poll, 1000);
}
```

注意 timer 会持有回调，回调会持有闭包里的对象。长期 timer 是典型的生命周期边界，dispose 时必须清掉，否则对象可达性会被 timer 链保住。

## 5. Decorator forwarding、`call/apply` 与 `bind` { #chapter-functions-forwarding }

JavaScript 里 decorator 的基础形态是“接收一个函数，返回一个包装后的函数”。缓存、日志、节流、防抖、错误上报都可以这样写。包装本身不难，难点是**转发调用时必须保留 `this` 和参数**。

```js
function logCalls(fn) {
  return function (...args) {
    console.log("call", fn.name, args);
    return fn.apply(this, args);
  };
}
```

这里不能写 `fn(...args)`，因为那会丢掉包装函数被调用时的 `this`。`apply(this, args)` 明确把当前 `this` 和参数数组转发给原函数。`call` 和 `apply` 都能指定 `this`，差别只是参数形态：`call(thisArg, a, b)` 接收参数列表，`apply(thisArg, argsArray)` 接收数组或 array-like。

```js
fn.call(obj, 1, 2);
fn.apply(obj, [1, 2]);
```

`bind` 会创建一个新函数，把 `this` 和部分参数永久绑定进去。它常用于把方法作为回调传出。

```js
const bound = runner.run.bind(runner);
```

`bind` 的副作用是函数身份变化。每次调用 `runner.run.bind(runner)` 都会创建新函数，所以注册和注销 listener 时要保存同一个 bound function 引用。否则你可能注册了 A，却试图移除新创建的 B。

```js
class Watcher {
  constructor(emitter) {
    this.emitter = emitter;
    this.onEvent = this.onEvent.bind(this);
  }

  start() {
    this.emitter.on("event", this.onEvent);
  }

  stop() {
    this.emitter.off("event", this.onEvent);
  }

  onEvent(event) {
    // use this safely
  }
}
```

方法 borrowing 也是同一套机制。把某个对象的方法拿来处理另一个对象时，用 `call` 或 `apply` 指定接收者。但现代代码里这类技巧不应滥用；如果只是把 iterable 转成数组，`Array.from` 比 `Array.prototype.slice.call(...)` 更清楚。

## 6. 箭头函数、回调值与 VSCode API { #chapter-functions-vscode }

箭头函数不能只按“更短的普通函数”理解。它没有自己的 `this` 和 `arguments`，适合捕获外层状态做回调；它不能被 `new` 调用，也不适合作为需要动态 `this` 的对象方法。

```js
class ExtensionController {
  constructor(output) {
    this.output = output;
  }

  register(context) {
    context.subscriptions.push(
      vscode.commands.registerCommand("demo.run", async () => {
        await this.run();
      })
    );
  }

  async run() {
    this.output.appendLine("running");
  }
}
```

这里 command handler 用箭头函数是正确的，因为它要捕获 `register` 方法调用时的 `this`。如果写成普通函数，`this.run()` 会失效。反过来，`run` 方法本身用普通方法语法，因为它是类实例的行为，需要在 `controller.run()` 这种调用点上接收实例。

VSCode API 大量把函数当成值：`registerCommand` 接收 command handler，`workspace.onDidChangeTextDocument` 接收 event listener，language provider 接收一组方法，disposable 保存注销逻辑。JavaScript 的函数一等值能力让这些 API 很自然，但也把生命周期和 `this` 绑定问题暴露出来。

```js
const disposable = vscode.workspace.onDidChangeTextDocument((event) => {
  if (event.document.languageId === "javascript") {
    refreshDiagnostics(event.document);
  }
});

context.subscriptions.push(disposable);
```

这段代码里 listener 闭包捕获了 `refreshDiagnostics` 以及它外层能访问到的状态。只要 disposable 没被 dispose，这个闭包就仍然可能被调用，它捕获的对象也可能继续可达。因此回调不是“传一个函数过去”这么简单，它同时建立了**控制流入口**和**生命周期引用**。

回调作为值还有一个测试好处：你可以把宿主 API 隔离在边界上，把核心逻辑写成普通函数，再在 handler 里调用它。

```js
function shouldRefresh(document) {
  return document.languageId === "javascript";
}

vscode.workspace.onDidChangeTextDocument((event) => {
  if (shouldRefresh(event.document)) {
    refreshDiagnostics(event.document);
  }
});
```

JavaScript 函数模型对插件开发的价值很实际：函数携带行为，闭包携带上下文，`bind` 或箭头函数固定接收者。代价也在同一个地方：每固定一次上下文，都会延长一条引用链。写长期运行的 extension 时，这条链要看得见。
