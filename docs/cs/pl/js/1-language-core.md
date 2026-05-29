# 语言核心与代码质量

<!-- Source: https://javascript.info/first-steps, https://javascript.info/code-quality -->

!!! Abstract "Outline"

    JavaScript 的基础语法不难，麻烦在于它保留了很多历史容错：自动插入分号、隐式类型转换、`==`、全局绑定和老语法兼容都会把小失误拖进运行时。

    - [x] [1. 运行位置、`script` 与 strict mode](#chapter-language-runtime)
    - [x] [2. 变量绑定、值类型与基本数据](#chapter-language-binding)
    - [x] [3. 类型转换、比较与空值逻辑](#chapter-language-conversion)
    - [x] [4. 控制流与函数声明的 JS 边界](#chapter-language-control)
    - [x] [5. 调试、风格、测试与兼容性](#chapter-language-quality)

## 1. 运行位置、`script` 与 strict mode { #chapter-language-runtime }

刚接触 JavaScript 时，很容易把它当成“插在 HTML 里的脚本”。这个印象只适合浏览器页面。JavaScript 本身是一门语言，浏览器、Node.js、VSCode extension host 都是宿主环境/Host Environment。语言提供语法、对象模型、Promise 和异常；宿主环境提供 `document`、`window`、`process`、`vscode` 这些外部 API。写 VSCode 插件时，代码运行在 extension host 里，默认对象不是浏览器 DOM，`alert`、`prompt`、`document.querySelector` 都不是语言能力。

网页用 `<script>` 插入 JS，外部脚本通过 `src` 引入。带 `src` 的 `<script>` 里再写内联代码没有意义，浏览器会按外部文件加载这段脚本。

```html
<script src="main.js"></script>
<script>
  console.log("inline script");
</script>
```

VSCode 插件开发通常不直接写这种 `<script>`，但理解它有用：JavaScript 代码总是由宿主环境加载和调度。浏览器加载脚本，Node 加载 CommonJS/ESM，VSCode 读取 `package.json` 的 activation events 后再执行 extension entrypoint。**代码如何被加载**会影响顶层变量、模块缓存、异常边界和异步启动顺序。

`"use strict"` 是现代 JavaScript 代码的基本前提。严格模式/Strict Mode 会关闭一部分历史容错行为：意外创建全局变量会报错，普通函数裸调用时的 `this` 不再退回全局对象，某些静默失败也会变成异常。现代 ES modules 和 class body 自动处于 strict mode；普通脚本或老式 CommonJS 文件里仍然可以把它显式写在文件顶部。

```js
"use strict";

function typo() {
  message = "leaked global"; // ReferenceError
}
```

如果没有 strict mode，上面这类拼错变量名可能会在全局对象上创建属性。对小脚本来说只是难看，对长期运行的 extension host 来说就是状态污染：一次命令执行留下的全局状态，可能影响下一次命令、另一个 provider，甚至测试里的后续用例。

JavaScript 还有**自动分号插入/Automatic Semicolon Insertion/ASI**。换行不总是语句结束，解释器会在某些位置补分号。最容易踩的是 `return` 后换行：

```js
function makeConfig() {
  return
  {
    enabled: true
  };
}
```

这段代码返回 `undefined`，因为 `return` 后面被补了分号。插件配置、command handler、provider result 里如果出现这种 bug，表面现象常常只是“API 接到 undefined”。写 JS 时显式加分号，把返回对象放在 `return` 同一行，能少掉一类很无聊的排错。

## 2. 变量绑定、值类型与基本数据 { #chapter-language-binding }

现代 JavaScript 默认用 `let` 和 `const`。`let` 表示变量可以重新绑定，`const` 表示这个名字不能再指向别的值。这里要盯住的是**绑定/Binding**，不是对象不可变。`const` 保护的是变量名到值的指向，不保护对象内部属性。

```js
const options = { timeout: 1000 };
options.timeout = 2000; // ok
options = {};          // TypeError
```

这和 Rust 的 `let mut` 或 C++ 的 `const` 都不一样。JavaScript 里的对象默认是可变引用值；`const` 只能防止你把 `options` 这个名字重新绑定到另一个对象。要限制对象属性，需要 `Object.freeze` 或更系统的不可变数据策略。普通业务代码里把 `const` 当不可变对象用，会误判共享状态。

JavaScript 是**动态类型/Dynamically Typed** 语言，变量没有固定类型，值有类型。一个变量先绑定字符串再绑定数字是合法的，类型检查发生在运行时。

```js
let value = "42";
value = Number(value);
```

语言内置类型里，`string` 和 `boolean` 比较直观，更值得单独记的是 `number`、`bigint`、`null`、`undefined` 和 `symbol`。普通数字统一是 `number`，底层使用 IEEE 754 double，所以整数和浮点数不是两套类型。`1 / 0` 得到 `Infinity`，`"abc" / 2` 得到 `NaN`，而 `NaN` 与任何值都不相等，包括它自己。

```js
Number.isNaN(NaN); // true
NaN === NaN;       // false
```

`bigint` 用来表示任意精度整数，字面量以 `n` 结尾。它不能和 `number` 直接混算，这是刻意设计的边界：否则精度损失会藏在自动转换里。

```js
const id = 9007199254740993n;
// id + 1; // TypeError: cannot mix BigInt and other types
```

`null` 和 `undefined` 是两个不同的空值。`undefined` 更像“没有被赋值”或“属性不存在时的读取结果”，`null` 更像程序员显式写下的“这里就是空”。在 API 设计里最好区分这两种语义：`undefined` 表示缺省，`null` 表示刻意清空。VSCode API 里也经常使用 `undefined` 表示“没有结果”。

`symbol` 是唯一标识符值，常用于对象属性键，避免普通字符串属性名冲突。普通插件代码不一定常写 `Symbol()`，但你会遇到内置 symbol，例如 iterator 协议使用的 `Symbol.iterator`。它告诉语言“这个对象可以被 `for...of` 消费”。

## 3. 类型转换、比较与空值逻辑 { #chapter-language-conversion }

JavaScript 的隐式类型转换是整门语言里最容易低估的部分。`String(value)`、`Number(value)`、`Boolean(value)` 这三种显式转换很直接；危险来自运算符在背后自动调用它们，而且不同运算符的转换方向不一致。

`+` 同时负责数值加法和字符串拼接。只要其中一侧是字符串，结果通常就是字符串拼接。其他算术运算符没有字符串拼接含义，会把操作数转成 number。

```js
"1" + 2;  // "12"
"6" / "2"; // 3
+"42";   // 42
```

布尔转换里只有少数值是 falsy：`false`、`0`、`-0`、`0n`、`""`、`null`、`undefined`、`NaN`。空数组 `[]` 和空对象 `{}` 都是 truthy。这个规则在条件判断里很有用，但不能用来偷懒判断集合是否为空。

```js
if ([]) {
  console.log("empty array is truthy");
}
```

比较运算必须默认使用 `===` 和 `!==`。宽松相等 `==` 会先做类型转换，导致一些结果在直觉上完全不可维护。

```js
0 == false;   // true
"" == false;  // true
null == undefined; // true
null === undefined; // false
```

宽松相等唯一相对常见的“有意使用”是 `value == null`，它同时匹配 `null` 和 `undefined`。但这需要团队明确接受这个 idiom，否则宁愿写得直接一点：`value === null || value === undefined`。对插件代码来说，清楚比短更重要。

`??` 是**空值合并运算符/Nullish Coalescing Operator**，只在左侧是 `null` 或 `undefined` 时使用右侧默认值。它和 `||` 的差异必须分清：`||` 会把所有 falsy 都当成缺省，`??` 只处理空值。

```js
const timeout = userConfig.timeout ?? 1000;
const retries = userConfig.retries || 3;
```

如果 `timeout` 配置为 `0`，`??` 会保留 `0`；如果用 `||`，`0` 会被误判为“没配置”。配置解析里优先用 `??`。只有当 `""`、`0`、`false` 都应该算无效输入时，`||` 才符合语义。

`?.` 是 optional chaining，虽然它属于对象基础章节，但和空值逻辑常一起出现。`obj?.prop` 在 `obj` 为 `null` 或 `undefined` 时直接返回 `undefined`，不会抛异常。它只短路左侧那一段，不会让整条表达式都变成安全宇宙。

```js
const label = command.metadata?.title ?? command.id;
```

这句的含义很精确：如果 `metadata` 不存在，就用 `command.id`；如果 `metadata.title` 是空字符串，`??` 不会覆盖它。这样的组合比 `command.metadata && command.metadata.title || command.id` 更接近真实意图。

## 4. 控制流与函数声明的 JS 边界 { #chapter-language-control }

`if`、`while`、`for`、`switch` 本身没有什么新鲜的。更值得记的是循环和块级绑定的交互：`let` 和 `const` 是块级作用域/Block Scope，每一轮 `for` 循环的 `let` 绑定都是新的。老 `var` 在异步回调里捕获同一个循环变量的问题，就卡在这里。

```js
for (let i = 0; i < 3; i++) {
  setTimeout(() => console.log(i), 0);
}
// 0, 1, 2
```

如果这里用 `var i`，三个回调会共享同一个函数作用域里的 `i`，最后都看到循环结束后的值。现代代码里这类问题会直接导致异步回调读错状态，不能只当“面试题”看。

`switch` 使用严格相等比较，不会做 `==` 那套转换。`case "1"` 不会匹配数字 `1`。这点反而是好事，因为它让分支条件更接近你写出来的类型。

函数有三种常见写法：函数声明/Function Declaration、函数表达式/Function Expression 和箭头函数/Arrow Function。函数声明会被提升，可以在声明前调用；函数表达式和箭头函数遵守变量绑定的初始化时机。

```js
declared(); // ok

function declared() {
  return "ready";
}

// expressed(); // ReferenceError if declared with const before initialization
const expressed = function () {
  return "ready";
};
```

函数声明适合顶层工具函数和清晰的局部 helper。函数表达式适合把函数当成值传入别处。箭头函数更短，而且不创建自己的 `this`、`arguments`、`super` 或 `new.target`。把箭头函数只当短写法看，会直接看漏 `this` 的差异。

```js
const extension = {
  id: "demo",
  activateLater() {
    setTimeout(() => {
      console.log(this.id);
    }, 0);
  },
};
```

这里箭头函数捕获外层方法的 `this`，所以能读到 `extension.id`。如果把回调写成普通函数，`this` 会由 `setTimeout` 的调用方式决定，通常不会是 `extension`。在 VSCode extension 里，event listener 和 command handler 大量使用回调；如果回调需要实例状态，箭头函数或显式 `bind` 必须有一个。

参数默认值、rest 参数和展开语法也属于基础工具。默认值只在参数为 `undefined` 时生效，不会覆盖 `null`。rest 参数把剩余实参收集成实际数组，spread 则把可迭代对象展开成实参或数组元素。

```js
function log(level = "info", ...messages) {
  console.log(level, messages.join(" "));
}

const args = ["warn", "missing config"];
log(...args);
```

这和 `??` 的规则一致：`undefined` 是缺省，`null` 是显式传入的值。API 设计时把二者分开，后面的默认值逻辑会清楚很多。

## 5. 调试、风格、测试与兼容性 { #chapter-language-quality }

浏览器开发者工具和 Node inspector 都支持断点、单步、watch expression、call stack 和 console。写 VSCode 插件时更常见的是在 extension host 上启动调试会话，让 VSCode 打开一个 Extension Development Host 窗口。语言层面要记住的是：`debugger` 语句会在调试器连接时暂停执行，适合临时定位异步路径。

```js
async function activate(context) {
  debugger;
  // inspect context, subscriptions, workspace state
}
```

代码风格会直接影响正确性。JavaScript 的隐式转换和回调边界太多，风格本身就是防错工具。现代代码优先用 `const`，需要重绑时用 `let`，不用 `var`；比较默认用 `===`；默认值优先用 `??`；异步函数返回 Promise 时让调用者 `await`，别混出“有时 callback、有时 Promise”的双通道 API。

注释也要节制。解释“这行在做什么”通常没价值，解释“为什么这个边界必须这样处理”才有用。例如配置解析里刻意保留 `0`，值得写明。

```js
const debounceMs = config.debounceMs ?? 250; // 0 disables debouncing intentionally.
```

javascript.info 用 Mocha 展示自动化测试。这里不用记死框架名，重点是测试要锁住行为边界：隐式转换、默认值、错误分支、异步顺序。这些地方肉眼 review 最容易放过。

```js
import assert from "node:assert/strict";

function normalizeLimit(value) {
  return value ?? 100;
}

assert.equal(normalizeLimit(0), 0);
assert.equal(normalizeLimit(undefined), 100);
```

Polyfill 和 transpiler 是兼容性工具。**Transpiler** 把新语法转换成旧环境能解析的语法，例如 Babel 或 TypeScript compiler。**Polyfill** 补运行时缺失的 API，例如旧环境没有 `Promise.allSettled`。这两个概念不能混：语法需要编译，API 需要补实现。VSCode 插件的运行环境由目标 VSCode 版本和其内置 Electron/Node 版本决定，因此写插件时要把 `engines.vscode`、Node API 可用性和打包目标一起看。

Modules 暂时放到后面。实际 VSCode 插件当然需要模块系统，但 javascript.info 把 Modules 放在 Part 1 更靠后的章节；先把语言运行时的坑讲清楚，再进入 TypeScript 和 extension packaging 会更顺。
