# Modules、静态导入与动态加载

<!-- Source: https://javascript.info/modules-intro, https://javascript.info/import-export, https://javascript.info/modules-dynamic-imports -->

!!! Abstract "Outline"

    Module 把文件变成带依赖边界的执行单元：顶层作用域不再污染全局，导入是 live binding，模块只执行一次。静态 import 适合构建期依赖，dynamic import 适合运行时按需加载。

    - [x] [1. Module 的执行模型](#chapter-modules-model)
    - [x] [2. Named export、default export 与导入形状](#chapter-modules-import-export)
    - [x] [3. Re-export 与 barrel 文件](#chapter-modules-reexport)
    - [x] [4. Static import 的限制与好处](#chapter-modules-static)
    - [x] [5. Dynamic import 与按需加载](#chapter-modules-dynamic)
    - [x] [6. VSCode 插件里的模块边界](#chapter-modules-vscode)

## 1. Module 的执行模型 { #chapter-modules-model }

JavaScript module 是一个文件级执行单元。浏览器里 `<script type="module">` 会按 module 规则执行；Node 和打包器也有自己的 module 加载规则。语言层面要记住几件事：module 自动处于 strict mode，顶层变量有模块作用域，顶层 `this` 是 `undefined`，同一个 module 被多个地方导入时只会执行一次。

```js
// counter.js
console.log("evaluated");

export let count = 0;

export function inc() {
  count += 1;
}
```

如果两个文件都 import `counter.js`，`console.log("evaluated")` 只会执行一次。之后大家拿到的是同一个 module instance 的导出绑定。这个行为很像“模块级单例”，适合缓存配置、共享 registry，也容易制造隐藏状态。测试里如果一个 module 保存了可变顶层状态，不重置 module cache 就可能串用例。

导入的是 live binding，不是导出值的拷贝。导出方改变 `count` 后，导入方读到的是新值。

```js
// main.js
import { count, inc } from "./counter.js";

console.log(count); // 0
inc();
console.log(count); // 1
```

这里的 `count` 不能在导入方重新赋值。它是只读视图，背后仍然连着导出方的绑定。想改变状态，要通过导出方提供的函数。

Module 还有 `import.meta`。浏览器里常用 `import.meta.url` 拿当前模块 URL；打包器和运行时可能扩展更多字段。它适合解决“当前模块文件在哪里”这类问题，不要把它当跨环境稳定配置中心。

## 2. Named export、default export 与导入形状 { #chapter-modules-import-export }

Named export 用名字导出多个绑定。导入时要写同名，或者用 `as` 改本地名。

```js
// math.js
export const pi = 3.14159;

export function square(x) {
  return x * x;
}

// main.js
import { pi, square as sq } from "./math.js";
```

也可以先声明，再在文件底部统一导出。这种写法在导出项较多时更容易扫一眼看全公共 API。

```js
function parse(input) {
  return JSON.parse(input);
}

function stringify(value) {
  return JSON.stringify(value);
}

export { parse, stringify };
```

Default export 表示“这个模块的主导出”。一个模块最多一个 default export。导入 default 时，本地名字由导入方决定。

```js
// logger.js
export default class Logger {
  log(message) {
    console.log(message);
  }
}

// main.js
import Logger from "./logger.js";
```

Named export 更利于自动补全、重命名和 tree shaking。Default export 在表达单一主对象时很顺手，例如一个 class、一个 factory、一个配置对象。不要为了少打一对花括号就把所有东西都 default export；模块 API 多起来后，named export 更稳。

`import * as ns` 会把一个模块的所有 named exports 收进 module namespace object。

```js
import * as math from "./math.js";

math.pi;
math.square(2);
```

namespace import 适合导入一组确实属于同一命名空间的工具，或者避免本地名字太多。它不是把模块对象复制一份，里面的导出仍然是 live binding。

## 3. Re-export 与 barrel 文件 { #chapter-modules-reexport }

Re-export 把别的模块导出的东西再从当前模块导出。它常用于 barrel 文件，也就是用一个入口文件整理多个子模块的公共 API。

```js
// index.js
export { parseConfig } from "./config.js";
export { createClient } from "./client.js";
export { Logger } from "./logger.js";
```

这样调用方可以从一个入口导入：

```js
import { parseConfig, createClient } from "./lib/index.js";
```

Barrel 文件的好处是公共 API 清楚，坏处是依赖边界可能被抹平。如果 `index.js` 重新导出太多东西，调用方看不出哪些模块会被加载，循环依赖也更难定位。写插件时，barrel 适合暴露稳定 API；内部实现之间不要为了“整齐”全绕一层 barrel。

Re-export default 要显式命名：

```js
export { default as Logger } from "./logger.js";
```

`export * from "./module.js"` 会重新导出 named exports，但不会重新导出 default。这个规则很容易忘。需要 default 时就像上面那样显式写出来。

## 4. Static import 的限制与好处 { #chapter-modules-static }

Static import 必须写在模块顶层，模块路径也必须是字符串字面量，不能放进 `if`、函数或动态表达式里。

```js
import { readFile } from "./fs.js";

// if (debug) {
//   import { trace } from "./debug.js"; // syntax error
// }
```

这个限制换来的是静态可分析。引擎、打包器、TypeScript、lint 工具可以在运行前看到依赖图，提前加载模块，检查拼写，做 tree shaking。插件项目里，静态 import 也让入口依赖更透明：打开 `extension.ts` 或 `extension.js` 就能看到激活时大概率会加载哪些模块。

Static import 会被 hoist。即使 import 写在文件中间，模块依赖也会先解析和执行，再执行当前模块主体。出于可读性，import 仍然应该集中放在文件顶部。

Side-effect import 只执行模块，不绑定任何导出。

```js
import "./register-polyfills.js";
```

这种写法适合 polyfill、全局注册、一次性初始化。它也最容易隐藏副作用。看到 side-effect import 时，要直接问：这个模块到底改了什么全局状态，执行顺序有没有要求，测试里需不需要隔离。

循环依赖/Circular Dependency 在 ESM 里不一定立刻炸，因为 live binding 可以让两个模块互相引用尚未初始化完成的绑定。但这不代表循环依赖健康。只要某个模块在初始化阶段读取了对方还没初始化的导出，就可能触发 temporal dead zone 错误或读到未准备好的状态。循环依赖出现时，优先抽公共部分，别靠加载顺序猜。

## 5. Dynamic import 与按需加载 { #chapter-modules-dynamic }

`import(specifier)` 是动态导入/Dynamic Import。它可以出现在普通表达式位置，返回 Promise，fulfilled 后得到 module namespace object。

```js
async function loadFormatter(name) {
  const module = await import(`./formatters/${name}.js`);
  return module.default;
}
```

Dynamic import 适合运行时才知道要加载什么，或者某个依赖很重、只有特定命令才需要加载。它的返回值是 Promise，所以错误也走 Promise rejection：模块不存在、加载失败、模块执行抛错，都会让 `await import(...)` 抛异常。

```js
try {
  const { default: formatter } = await import("./formatter.js");
  formatter(document);
} catch (error) {
  reportLoadError(error);
}
```

动态导入不是免费午餐。路径如果来自用户输入，会变成安全和打包问题；路径如果太动态，打包器可能无法知道要把哪些文件打进产物；加载发生在运行时，第一次调用会多一次异步延迟。按需加载重依赖很合理，把核心依赖全改成 dynamic import 只会让控制流更散。

Dynamic import 也能和条件分支配合：

```js
async function createRenderer(kind) {
  if (kind === "markdown") {
    return import("./renderers/markdown.js");
  }

  return import("./renderers/plain.js");
}
```

这种写法比在顶层静态导入两个 renderer 更懒，但调用者必须记得 `await`。只要模块导入进入运行时分支，错误处理也要进入运行时分支。

## 6. VSCode 插件里的模块边界 { #chapter-modules-vscode }

VSCode 插件开发通常还会经过 TypeScript、CommonJS/ESM 配置和打包器。这里先不展开 packaging，只抓语言层面的模块判断：静态 import 表示激活时依赖，dynamic import 表示按需依赖，模块顶层状态会被缓存，导入绑定是 live binding。

这几条会直接影响 extension 结构。`activate` 文件不要把所有重依赖都静态 import 进来，否则插件激活路径会变重。冷门命令、可选语言服务、外部工具适配层，可以考虑 dynamic import。反过来，核心类型、轻量工具、稳定 provider 注册逻辑，静态 import 更清楚。

```js
export async function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand("demo.heavyCommand", async () => {
      const { runHeavyCommand } = await import("./heavy-command.js");
      await runHeavyCommand();
    })
  );
}
```

这个例子把重命令推迟到用户执行时加载。它也暴露一个边界：第一次执行命令时可能失败，或者慢一点。用户可见命令必须有错误报告，不能让 dynamic import 的 rejection 变成 unhandled rejection。

模块顶层状态也要小心。把 mutable cache 放在模块顶层很方便，但它会跨多次命令调用保留。这个行为有时正是你想要的，有时会让测试和 reload 行为变脏。简单规则是：顶层可以放纯函数、常量、轻量 registry；会变的状态要么能 reset，要么明确属于插件生命周期。
