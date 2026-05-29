# 错误处理、Promise 与 async/await

<!-- Source: https://javascript.info/error-handling, https://javascript.info/async -->
<!-- Source: https://developer.mozilla.org/en-US/docs/Web/API/AbortController -->
<!-- Source: https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal -->
<!-- Source: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Resource_management -->
<!-- Source: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/using -->
<!-- Source: https://github.com/tc39/proposal-explicit-resource-management -->

!!! Abstract "Outline"

    JavaScript 的异步模型要从 Promise 读起。Promise 把“未来的结果”和“未来的异常”放进同一条链，microtask queue 决定这些回调何时恢复；`async/await` 只是把这套机制写得像同步代码。取消和资源释放不属于 Promise 状态机本身，要靠额外协议表达。

    - [x] [1. `try...catch...finally` 与 Error 对象](#chapter-async-try-catch)
    - [x] [2. 自定义错误与同步异常边界](#chapter-async-custom-error)
    - [x] [3. 从 callback 到 Promise 状态机](#chapter-async-promise)
    - [x] [4. Promise chaining 与 rejection propagation](#chapter-async-chain)
    - [x] [5. Promise API、promisification 与并发形状](#chapter-async-api)
    - [x] [6. Microtask queue 与执行顺序](#chapter-async-microtask)
    - [x] [7. `async/await` 与 VSCode extension 模式](#chapter-async-await)
    - [x] [8. `AbortController`、`AbortSignal` 与可取消异步](#chapter-async-abort-controller)
    - [x] [9. `using` / `await using` 与显式资源管理](#chapter-async-explicit-resource-management)

## 1. `try...catch...finally` 与 Error 对象 { #chapter-async-try-catch }

`try...catch` 捕获的是当前同步执行路径里抛出的异常。`throw` 可以抛任意值，但工程上应该抛 `Error` 或其子类，因为 `Error` 带 `message`、`name`、`stack` 等调试信息。

```js
try {
  JSON.parse(raw);
} catch (error) {
  console.error(error.message);
}
```

`catch` 只捕获 `try` 块中同步抛出的错误。如果 `try` 里启动了一个未来才执行的 callback，callback 里抛出的异常不会被外层 `catch` 接住。

```js
try {
  setTimeout(() => {
    throw new Error("later");
  }, 0);
} catch (error) {
  // will not run
}
```

原因很直接：`try` 执行完时，timer callback 还没运行。等 callback 进入调用栈时，原来的 `try...catch` 早就离开了。异步错误必须通过 callback 参数、Promise rejection 或 event error channel 传递。

`finally` 无论是否抛错都会执行，适合释放同步资源、恢复状态、关闭临时 UI。除非你明确要覆盖原始结果，否则别在 `finally` 里吞掉错误。

```js
let token;

try {
  token = acquire();
  run(token);
} finally {
  release(token);
}
```

如果 `finally` 里 `return` 或再次 `throw`，它会覆盖 `try` 或 `catch` 的结果。这种写法很不透明。只有在极小范围内确实要表达“清理失败优先”时才值得用。

## 2. 自定义错误与同步异常边界 { #chapter-async-custom-error }

错误类型的价值是让调用者区分“哪里错了”和“是否可恢复”。解析用户配置失败、外部命令不存在、workspace 状态不满足，都可以是不同错误类型或至少不同 `code`。

```js
class ConfigError extends Error {
  constructor(message, path) {
    super(message);
    this.name = "ConfigError";
    this.path = path;
  }
}
```

自定义错误继承 `Error` 后，`instanceof ConfigError` 可以在同一 realm 内工作。设置 `name` 能让日志显示更具体。需要保留底层错误时，现代 JS 支持 `cause`。

```js
throw new ConfigError("Invalid config", configPath);

throw new Error("Failed to load workspace config", {
  cause: error,
});
```

别把所有异常都 catch 后转成字符串。字符串会丢掉 stack、cause 和类型信息。更好的模式是在边界层捕获，补上下文，再重新抛出或转换成用户可见消息。

```js
try {
  await loadConfig(uri);
} catch (error) {
  throw new Error(`Failed to load config from ${uri.toString()}`, {
    cause: error,
  });
}
```

`try...catch` 的作用域要尽量小。把大量代码包进一个 catch，最后只能得到“某处失败”。如果你知道哪个操作可能失败，就围住那个操作，并在 catch 里处理这个操作的语义。

## 3. 从 callback 到 Promise 状态机 { #chapter-async-promise }

早期异步 API 常用 callback：发起操作时传入函数，操作完成后宿主调用它。callback 的问题是错误传播和顺序组合会越来越深，形成 callback pyramid。

```js
loadScript("a.js", (error) => {
  if (error) {
    handle(error);
    return;
  }

  loadScript("b.js", (error) => {
    if (error) {
      handle(error);
      return;
    }

    run();
  });
});
```

Promise 把异步操作抽象成一个对象。Promise 有三种状态：pending、fulfilled、rejected。状态一旦从 pending 变成 fulfilled 或 rejected，就不可再改变。fulfilled 带 result，rejected 带 error。

```js
const promise = new Promise((resolve, reject) => {
  if (ready) {
    resolve(value);
  } else {
    reject(new Error("not ready"));
  }
});
```

executor 会同步执行；`resolve` 和 `reject` 只是决定 Promise 的最终状态。后续通过 `.then`、`.catch`、`.finally` 注册的 handler 不会同步立刻执行，而是进入 microtask queue。

Promise 的一个关键性质是：异步成功和异步失败都在同一个值上表达。函数返回 Promise 后，调用者可以用同一套链式接口处理结果和错误。这比 callback 的 `(error, result)` 约定更容易组合。

Thenable 是带 `.then` 方法的对象。Promise resolution procedure 会吸收 thenable，让它表现得像 Promise。这让不同库的 Promise-like 对象可以互操作，但也意味着随便给对象定义奇怪的 `then` 属性可能引发意外。

```js
Promise.resolve({
  then(resolve) {
    resolve("assimilated");
  },
});
```

日常代码里很少需要手写 thenable；返回标准 Promise 或使用 `async` 函数更清楚。

## 4. Promise chaining 与 rejection propagation { #chapter-async-chain }

`.then` 返回新的 Promise。handler 的返回值会决定新 Promise 的状态：返回普通值会 fulfilled；抛异常会 rejected；返回另一个 Promise 会等待它 settle。

```js
readFile(uri)
  .then((text) => parseConfig(text))
  .then((config) => validateConfig(config))
  .catch((error) => report(error));
```

这条链不是“注册几个回调”这么简单。每个 `.then` 都创建下一段异步结果，所以链可以扁平地表达顺序依赖。`parseConfig` 如果抛异常，后面的 fulfilled handler 会被跳过，控制流进入最近的 rejection handler。

`catch` 本质上是 `.then(null, onRejected)`。它会捕获前面链条里的 rejection，也会捕获前面 fulfilled handler 同步抛出的异常。处理后如果返回普通值，链会恢复为 fulfilled；如果想继续失败，要重新抛出。

```js
doWork()
  .catch((error) => {
    log(error);
    throw error;
  })
  .then(() => {
    // only runs if doWork eventually fulfilled
  });
```

很多“错误被吞掉”就出在这里。`catch` 里只记录日志但不重新抛出，调用者看到的是一个成功完成的 Promise。除非你真的把错误恢复成了可用结果，否则 catch 后要 `throw`。

`.finally` 不接收 fulfilled value 或 rejection reason，适合做清理。它返回的 Promise 会保留原来的结果，除非 finally handler 自己抛错或返回 rejected Promise。

```js
setBusy(true);

return doWork()
  .finally(() => {
    setBusy(false);
  });
```

链式写法仍然要注意 return。嵌套启动一个 Promise 但不 return，外层链不会等待它。

```js
doWork()
  .then(() => {
    saveState(); // not awaited if saveState returns Promise and is not returned
  });
```

正确写法是 return 或用 `await`：

```js
doWork()
  .then(() => {
    return saveState();
  });
```

## 5. Promise API、promisification 与并发形状 { #chapter-async-api }

Promise API 不靠背方法名记，先看并发形状。`Promise.all` 表示全部成功才成功，有一个失败就立刻 rejected；`Promise.allSettled` 等所有任务 settle，保留每个任务的状态；`Promise.race` 采用第一个 settle 的结果；`Promise.any` 采用第一个 fulfilled 的结果，如果全失败才 rejected。

```js
const [config, packageJson] = await Promise.all([
  readConfig(),
  readPackageJson(),
]);
```

这里两个读取互不依赖，所以可以并发启动。写成先 `await readConfig()` 再 `await readPackageJson()`，会把本来可以并行的 I/O 串行化。

如果你需要收集每个文件的诊断结果，即使某些文件失败也要继续处理，用 `allSettled` 更合适。

```js
const results = await Promise.allSettled(
  uris.map((uri) => analyzeDocument(uri))
);
```

`Promise.race` 常用于 timeout，但它不会自动取消输掉的 Promise。底层操作仍然可能继续跑。需要取消时，要使用对应 API 的 cancellation 机制，例如 `AbortController` 或 VSCode 的 `CancellationToken`。

```js
function timeout(ms) {
  return new Promise((_, reject) => {
    setTimeout(() => reject(new Error("timeout")), ms);
  });
}

await Promise.race([doWork(), timeout(1000)]);
```

Promisification 是把 callback API 包装成 Promise API。Node 里常见 error-first callback，形态是 `(error, result) => {}`。包装时要保证 callback 只 settle 一次，并正确转发异常。

```js
function readLegacy(uri) {
  return new Promise((resolve, reject) => {
    legacyRead(uri, (error, result) => {
      if (error) {
        reject(error);
        return;
      }
      resolve(result);
    });
  });
}
```

现代 Node 有 `util.promisify`，很多 API 也已经原生返回 Promise。插件代码如果还遇到 callback，多半来自老库或 event-style API。event listener 不适合为了“统一”而 promisify；事件是多次发生的流，Promise 只表示一次结果。

## 6. Microtask queue 与执行顺序 { #chapter-async-microtask }

Promise handler 总是异步执行，进入 microtask queue。Microtask 会在当前同步代码执行完、调用栈清空后运行，并且通常在下一个 macrotask（例如 timer）之前清空。

```js
console.log("A");

Promise.resolve().then(() => console.log("B"));

setTimeout(() => console.log("C"), 0);

console.log("D");
```

输出顺序是 `A, D, B, C`。同步代码先跑完，所以 `A` 和 `D` 先出现；Promise reaction 是 microtask，所以在 timer callback 前运行；`setTimeout` 是后续 task。

`await` 也会制造 microtask 边界。即使等待的是已经 fulfilled 的 Promise，`await` 后面的代码也会暂停到当前同步代码之后继续。

```js
async function run() {
  console.log("B");
  await null;
  console.log("C");
}

console.log("A");
run();
console.log("D");
// A, B, D, C
```

这解释了为什么 async 函数的前半段可以同步执行到第一个 `await`，而 `await` 后面的逻辑总是稍后恢复。状态更新、日志顺序、测试断言都要考虑这个边界。

Microtask starvation 也要知道。如果一个 microtask 不断排入新的 microtask，timer 和 UI 事件可能迟迟得不到执行。普通业务代码很少手写这种循环，但递归 Promise 链、无限重试和过度 `queueMicrotask` 都可能造成类似问题。

Unhandled rejection 是 Promise 世界里的“异步异常没人接”。如果一个 Promise rejected，而当前或后续没有 rejection handler，宿主环境会报告 unhandled rejection。Node 和 VSCode extension host 对这类错误的处理策略会影响日志和进程稳定性。top-level async 调用要么 `await`，要么 return；边界层负责 catch。

## 7. `async/await` 与 VSCode extension 模式 { #chapter-async-await }

`async function` 总是返回 Promise。返回普通值会被包装成 fulfilled Promise；抛异常会变成 rejected Promise。`await` 会等待 Promise settle；fulfilled 时得到值，rejected 时在 `await` 这一行重新抛出异常，所以可以用 `try...catch` 写同步形态的错误处理。

```js
async function loadWorkspaceConfig(uri) {
  try {
    const text = await vscode.workspace.fs.readFile(uri);
    return JSON.parse(new TextDecoder().decode(text));
  } catch (error) {
    throw new Error(`Failed to load config: ${uri.toString()}`, {
      cause: error,
    });
  }
}
```

这段代码的错误边界很明确：文件读取失败、解码失败、JSON parse 失败都会进入 catch，然后带上下文重新抛出。调用者仍然得到 rejected Promise，而不是一个被吞掉的错误。

`await` 只能直接出现在 async function 或支持 top-level await 的 module 里。CommonJS 环境和某些打包目标不支持顶层 await 时，要把启动逻辑包进 async 函数。VSCode 插件入口通常导出 `activate`，可以让它返回 Promise。

```js
async function activate(context) {
  const config = await loadWorkspaceConfig();
  registerCommands(context, config);
}

module.exports = { activate };
```

顺序依赖用连续 `await`，独立任务用 `Promise.all` 并发启动。这个判断比语法更重要。

```js
const config = await loadConfig();
const client = await connect(config);
```

这里 `connect` 依赖 `config`，必须串行。下面则可以并发：

```js
const [workspaceInfo, packageInfo] = await Promise.all([
  readWorkspaceInfo(),
  readPackageInfo(),
]);
```

数组上直接写 `items.forEach(async item => await work(item))`，外层不会等待。`forEach` 不关心 callback 返回的 Promise。需要串行时用 `for...of`；需要并发时用 `map` 加 `Promise.all`。

```js
for (const item of items) {
  await work(item);
}

await Promise.all(items.map((item) => work(item)));
```

这两段语义完全不同。第一段一次处理一个，适合需要顺序、限流或共享可变状态的任务；第二段同时启动，适合互不依赖的 I/O。第二段短，但不是默认答案。

VSCode provider API 常接受可以返回值或 Promise 的方法，例如 completion、hover、definition provider。实现上可以直接写 async 方法，但要尊重 cancellation token：异步等待回来后先检查是否已取消，避免把过期结果写回 UI。

```js
const provider = {
  async provideHover(document, position, token) {
    const result = await computeHover(document, position);

    if (token.isCancellationRequested) {
      return undefined;
    }

    return new vscode.Hover(result);
  },
};
```

异步函数让代码读起来像同步，但运行时仍然是 Promise 和 microtask。每个 `await` 都是暂停点，暂停点之间的共享状态可能已经被其他事件改过。写 extension 时要少依赖“我刚才检查过，所以现在一定还成立”的假设；如果状态重要，就在 `await` 之后重新验证。

Promise 链里不处理的错误要继续向外传播，边界层再统一报告。底层函数负责抛错和补上下文，用户消息留给边界层；`catch` 里只 `console.error` 后继续返回成功，会把失败伪装成成功。错误传播保持干净，VSCode extension 的异步控制流才不会变成一团安静失败。

## 8. `AbortController`、`AbortSignal` 与可取消异步 { #chapter-async-abort-controller }

Promise 没有 cancellation state。一个 Promise 只能 pending、fulfilled 或 rejected，不能被“撤回”。所谓取消，是调用者把“我已经不需要这个结果了”的意图传给底层操作，底层操作如果支持，就尽早停止 I/O、清掉 timer、释放锁或停止继续计算。

`Promise.race` 的 timeout 例子只解决“调用者等多久”的问题，不解决“底层工作还跑不跑”的问题。timeout 赢了以后，输掉的 `doWork()` 仍然可能继续访问网络、写缓存、改共享状态。要让底层任务停下，`doWork` 必须接受一个 cancellation signal。

```js
async function fetchJson(url, signal) {
  const response = await fetch(url, { signal });
  return response.json();
}

const controller = new AbortController();
const timer = setTimeout(() => controller.abort(new Error("timeout")), 1000);

try {
  const data = await fetchJson(url, controller.signal);
  consume(data);
} finally {
  clearTimeout(timer);
}
```

`AbortController` 负责发出取消，`AbortSignal` 是传下去的只读信号。被调用函数不应该拿到 controller，否则它就能随意取消上层任务；它只需要读 `signal.aborted`、监听 `abort` 事件，或者调用 `signal.throwIfAborted()`。这和函数参数里的 capability 边界一致：谁创建 controller，谁拥有取消权。

```js
async function analyzeDocument(document, signal) {
  signal.throwIfAborted();

  const text = document.getText();
  const result = await expensiveAnalyze(text, { signal });

  signal.throwIfAborted();
  return result;
}
```

`AbortSignal.timeout(ms)` 和 `AbortSignal.any([...])` 能减少手写 controller 的样板，但它们是较新的 API，插件代码要看目标 VSCode extension host、Node 版本和 web extension runtime。可移植基线仍然是手动创建 `AbortController`，在 `finally` 里清理自己创建的 timer 或 listener。

VSCode API 自己更常用 `CancellationToken`。它和 `AbortSignal` 表达的是同一个意思：结果不再需要了，正在跑的任务应该尽快停下。但它们不是同一个类型。调用 VSCode provider 时接受 `token`，调用 Web/Node 风格 API 时常需要 `signal`，中间可以做一个小 adapter。

```js
function abortSignalFromToken(token) {
  const controller = new AbortController();

  if (token.isCancellationRequested) {
    controller.abort();
  }

  const listener = token.onCancellationRequested(() => {
    controller.abort();
  });

  return {
    signal: controller.signal,
    dispose() {
      listener.dispose();
    },
  };
}
```

这个 adapter 里的 `dispose()` 很关键。取消监听本身也是资源，任务结束后还挂着 listener，只是把泄漏换了个名字。插件里所有跨 API 的 cancellation bridge 都要问一句：谁负责注销监听，谁负责停止 timeout，谁负责避免过期结果写回 UI。

## 9. `using` / `await using` 与显式资源管理 { #chapter-async-explicit-resource-management }

`finally` 是资源释放的老基线。它能表达释放动作，但释放动作和资源声明分散在两处：前面拿锁、注册 listener、打开文件，后面手写 `finally` 释放。代码短时还能靠纪律维持；资源一多，顺序、异常覆盖和漏清理都会变成真实 bug。

显式资源管理/Explicit Resource Management 把释放协议放进对象本身。同步资源实现 `[Symbol.dispose]()`，异步资源实现 `[Symbol.asyncDispose]()`。`using` 声明的变量离开作用域时会自动调用同步 dispose；`await using` 离开作用域时会调用并等待异步 dispose。多个资源按后声明先释放的顺序清理，这和嵌套 `try...finally` 的安全顺序一致。

```js
function disposableOf(value) {
  return {
    value,
    [Symbol.dispose]() {
      value.dispose();
    },
  };
}

{
  using command = disposableOf(
    vscode.commands.registerCommand("note.refresh", refresh)
  );

  // command.value 在这个 block 内可用
}
// 离开 block 时自动 command.value.dispose()
```

VSCode 的 `Disposable` 传统上只有 `.dispose()`，不天然等于 `[Symbol.dispose]()`。上面这种 adapter 只是说明协议怎么接上。extension 里跨整个插件生命周期的 command、provider、watcher 仍然适合放进 `context.subscriptions`；`using` 更适合短作用域资源，例如临时 listener、临时 lock、手动驱动的 iterator、一次任务内打开的 handle。

异步释放要写 `await using`。这里有两个 await 边界经常混在一起：获取资源可能需要 `await`，释放资源也可能需要 `await`。前者等资源创建完成，后者等资源关闭完成。

```js
async function readConfig(path) {
  await using file = await openFile(path);
  return await file.readText();
}
```

这里的 `return await` 不是多余写法。如果 `file.readText()` 返回 Promise，直接 `return file.readText()` 可能让函数先离开作用域并触发 dispose，读取还没真正完成。资源还要被后续异步步骤使用时，把那个步骤 `await` 在作用域内部。

`DisposableStack` 和 `AsyncDisposableStack` 解决的是“资源数量和释放顺序动态变化”的情况。你可以把资源逐个 `use()` 进去，也可以用 `adopt(value, disposer)` 给一个还没实现 dispose protocol 的值补释放函数。它比手写数组更可靠，因为栈自己记录释放顺序，也能处理中途构造失败时已经拿到的资源。

```js
{
  using stack = new DisposableStack();

  const watcher = stack.adopt(createWatcher(), (value) => value.dispose());
  const timer = stack.adopt(setInterval(flush, 1000), clearInterval);

  watcher.onDidChange(schedule);
}
```

兼容性要单独看。`using` / `await using`、`DisposableStack` 和相关 symbol 在 2026 年已经进入现代 JS 讨论和实现路径，但 MDN 仍把 `using` 标为 limited availability。VSCode 插件要同时满足 manifest 里的 `engines.vscode`、desktop/web extension host、bundler 输出和测试矩阵，不能只看本机 Node。要写现在就稳定发布的插件，`try...finally` 和 `context.subscriptions` 仍然是最稳的可移植基线；`using` 可以在确认 runtime 或转译链路支持后使用。

`FinalizationRegistry` 不能替代 dispose。GC 什么时候发生没有确定性，finalizer 甚至不保证一定运行。文件句柄、listener、timer、锁和临时目录都属于逻辑资源，不是普通内存对象。它们需要明确生命周期，不能把正确性交给垃圾回收。
