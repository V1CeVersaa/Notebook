# 控制流收窄、函数与对象类型

<!-- Source: https://www.typescriptlang.org/docs/handbook/2/narrowing.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/functions.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/objects.html -->

!!! Abstract "Outline"

    TypeScript 的日常建模靠控制流、函数边界和对象形状一起工作。类型越贴近真实分支，后面的实现越少靠断言。

    - [x] [1. Control-flow narrowing 的基本模型](#chapter-narrowing-model)
    - [x] [2. 常见 narrowing 手段与空值陷阱](#chapter-narrowing-tools)
    - [x] [3. Discriminated union 与 exhaustiveness](#chapter-discriminated-union)
    - [x] [4. 函数类型、callback 与 overload](#chapter-function-types)
    - [x] [5. `interface`、`type` 与结构类型](#chapter-object-shapes)
    - [x] [6. Optional、`readonly`、index signature 与 excess property check](#chapter-object-details)
    - [x] [7. Class 类型、TS-only 修饰符与结构化协议边界](#chapter-class-boundary)

## 1. Control-flow narrowing 的基本模型 { #chapter-narrowing-model }

Control-flow narrowing/控制流收窄 让 TypeScript 不只停在 "变量声明时是什么类型"。一个变量可以在函数入口处是宽类型，经过 `if`、`return`、`switch`、赋值和异常路径后，TS 会按当前控制流推断它在某个位置更具体的类型。

```ts
function print(value: string | string[] | undefined) {
  if (value === undefined) {
    return;
  }

  if (Array.isArray(value)) {
    console.log(value.join(", "));
    return;
  }

  console.log(value.toUpperCase());
}
```

函数入口处的 `value` 有三种可能。第一个分支返回后，后续代码里 `undefined` 已经被排除。第二个分支判断数组并返回后，最后一段里只剩 `string`。TS 的类型分析会沿着控制流图移动，所以它能读懂这种提前返回的结构。

真实项目经常拿到宽类型或可选结果。URL query 可能没有某个参数，DOM 查询可能返回 `null`，配置读取可能返回 `T | undefined`，message event 来自运行时。与其在每个使用点写 `as`，不如在边界处把类型收窄干净。

```ts
function requireElement<T extends Element>(
  element: T | null,
  selector: string,
) {
  if (!element) {
    throw new Error(`Missing element: ${selector}`);
  }

  return element;
}
```

抛异常、提前 `return`、`continue` 都会影响收窄。写 TS 时，guard clause 不只是风格问题，它能让后续主路径拿到更窄的类型。

## 2. 常见 narrowing 手段与空值陷阱 { #chapter-narrowing-tools }

`typeof` 适合区分 JS primitive。它返回的是运行时字符串，因此能把 `unknown` 或 union 收窄到具体 primitive。

```ts
function readLabel(value: unknown): string | undefined {
  if (typeof value === "string") {
    return value.trim();
  }

  return undefined;
}
```

`instanceof` 适合区分 class 或内置构造函数产生的对象。它依赖运行时 prototype chain，所以只对运行时真实存在的构造函数有意义。

```ts
function formatError(error: unknown) {
  if (error instanceof Error) {
    return error.message;
  }

  return String(error);
}
```

`in` 可以判断对象里是否有某个属性。它常用于从 `unknown` 进入对象形状，但必须先排除 `null`，因为 `typeof null === "object"` 是 JS 历史行为。

```ts
function hasCommand(value: unknown): value is { command: string } {
  return (
    typeof value === "object" &&
    value !== null &&
    "command" in value &&
    typeof value.command === "string"
  );
}
```

这里的返回类型 `value is { command: string }` 是 type predicate/类型谓词。它告诉 TS：如果函数返回 true，传入的 `value` 就可以被看成这个对象形状。谓词本身不会验证逻辑是否正确，函数体写错了，类型系统也会被你骗过去。

truthiness narrowing 要谨慎。`if (value)` 会排除 `null`、`undefined`、`false`、`0`、`""`、`NaN` 等 falsy 值。它适合判断 "有没有对象"，不适合判断 "有没有字符串"，因为空字符串可能是合法值。

```ts
function normalizeTitle(title: string | undefined) {
  if (title === undefined) {
    return "Untitled";
  }

  return title; // empty string is preserved
}
```

配置和 UI 文本里不要随便用 `||` 或 truthiness。用户把 debounce 配成 `0`、把 label 配成空字符串，可能是有意为之。`??` 和显式 `=== undefined` 更贴近真实语义。

Equality narrowing 也很常用。两个 union 值相等时，TS 会收窄到双方可能交集。

```ts
function compare(x: string | number, y: string | boolean) {
  if (x === y) {
    x.toUpperCase();
    y.toUpperCase();
  }
}
```

在 `x === y` 分支里，两边唯一共同可能是 `string`。这种推理让 TS 能读懂很多自然的 JS 写法。

## 3. Discriminated union 与 exhaustiveness { #chapter-discriminated-union }

Discriminated union/可辨识联合 是 TS 里表达状态机最顺手的方式。每个分支都有一个共同的 literal 字段，通常叫 `kind`、`type`、`status`。TS 根据这个字段收窄对象形状。

```ts
type TaskState =
  | { status: "idle" }
  | { status: "running"; startedAt: number }
  | { status: "failed"; error: Error }
  | { status: "done"; output: string };
```

这样写能表达互斥关系。`status: "running"` 时 `startedAt` 必然存在；`status: "failed"` 时 `error` 必然存在。一个全是 optional property 的大对象表达不出这层约束。

```ts
function renderState(state: TaskState) {
  switch (state.status) {
    case "idle":
      return "Waiting";
    case "running":
      return `Started at ${state.startedAt}`;
    case "failed":
      return state.error.message;
    case "done":
      return state.output;
  }
}
```

Message protocol 很适合这样建模。Web worker、iframe、WebSocket、CLI command bus、RPC 调用本质上都是一组带判别字段的事件。

```ts
type ClientMessage =
  | { type: "ready" }
  | { type: "navigate"; url: string }
  | { type: "runTask"; task: string; args?: unknown[] };

function handleMessage(message: ClientMessage) {
  if (message.type === "navigate") {
    return new URL(message.url);
  }

  if (message.type === "runTask") {
    return dispatchTask(message.task, message.args ?? []);
  }

  return undefined;
}
```

状态集合会演化时，可以加 exhaustiveness check。

```ts
function assertNever(value: never): never {
  throw new Error(`Unexpected value: ${String(value)}`);
}

function renderStrict(state: TaskState) {
  switch (state.status) {
    case "idle":
      return "Waiting";
    case "running":
      return "Running";
    case "failed":
      return "Failed";
    case "done":
      return "Done";
    default:
      return assertNever(state);
  }
}
```

如果以后给 `TaskState` 新增 `"cancelled"`，但没有修改 `renderStrict`，`assertNever(state)` 会报类型错误。类型变了，相关实现也会被迫跟着改。

## 4. 函数类型、callback 与 overload { #chapter-function-types }

函数类型写的是参数类型和返回类型。日常最常见的是 callback。

```ts
type CommandHandler = (url: URL) => Promise<void>;

function registerCommand(id: string, handler: CommandHandler) {
  commandRegistry.set(id, handler);
}
```

返回 `void` 的函数表示调用者不应该依赖返回值。它不是 "函数真的不能返回值"。在 TS 里，一个返回具体值的函数可以赋给返回 `void` 的 callback 类型，因为调用方会忽略返回值。

```ts
const values = [1, 2, 3];

values.forEach((value) => values.push(value + 10)); // callback returns number, ignored
```

这个规则符合 JS 回调习惯，但也容易藏 bug。事件处理器、command handler 里如果返回 Promise，调用方是否会等待它，要看 API 约定。类型只能表达一部分契约，宿主 API 文档仍然要看。

Optional parameter 写成 `name?: string`，表示调用时可以省略，函数体里类型是 `string | undefined`。不要把 optional parameter 用在 callback 类型里表达 "调用方可以传也可以不传"，除非 API 确实会少传参数。对回调来说，optional parameter 会让实现者必须处理缺失。

```ts
type BadCallback = (value?: string) => void;
type GoodCallback = (value: string) => void;
```

如果 API 一定会传入 `value`，就写 `GoodCallback`。否则每个实现者都得面对 `undefined`，类型信息反而变差。

Overload/重载适合表达 "同一个函数根据参数形状返回不同类型"。TS 的重载由多个 overload signature 加一个 implementation signature 组成，调用者只能看到 overload signature，看不到 implementation signature。

```ts
function readSetting(name: "enabled"): boolean;
function readSetting(name: "timeout"): number;
function readSetting(name: string): boolean | number {
  if (name === "enabled") {
    return true;
  }

  return 250;
}

const enabled = readSetting("enabled"); // boolean
```

能用 union 或 generic 表达清楚时，不要急着写 overload。重载多起来后，维护成本很高，而且 implementation signature 必须同时兼容所有分支。日常代码里，重载通常只适合公共 API 或明显的字符串 literal 映射；普通内部 helper 用 union 更容易读。

`this` parameter 是 TS 专门给函数类型使用的假参数，用来声明普通函数被调用时需要的 `this` 类型。它不会出现在 JS 输出里。

```ts
interface LogWriter {
  appendLine(message: string): void;
}

function appendLine(this: LogWriter, message: string) {
  this.appendLine(message);
}
```

它能把 JS 笔记里讲过的 `this` 绑定问题提前暴露出来。日常 TS 代码里，更推荐用箭头函数或显式闭包，少依赖动态 `this`。

## 5. `interface`、`type` 与结构类型 { #chapter-object-shapes }

`interface` 和 `type` 都能描述对象形状。

```ts
interface CommandSpec {
  id: string;
  title: string;
}

type CommandResult = {
  ok: boolean;
  message?: string;
};
```

两者在对象建模上高度重合。`interface` 可以 declaration merging，适合给公开对象形状、第三方扩展点和 class implements 使用；`type` 可以表达 union、tuple、conditional type 等更宽的类型表达式。日常规则可以简单一点：公共对象协议用 `interface`，组合类型和 union 用 `type`。

TypeScript 是 structural typing/结构类型。两个类型是否兼容，主要看成员结构，不看名字是否相同。

```ts
interface HasId {
  id: string;
}

type Command = {
  id: string;
  title: string;
};

function useId(value: HasId) {
  return value.id;
}

const command: Command = { id: "demo.run", title: "Run" };
useId(command);
```

`Command` 没有显式声明实现 `HasId`，但它有 `id: string`，所以可以传入。这个模型和 Java、C# 的 nominal class hierarchy 不一样。TS 关心的是 "这个值能不能提供我需要的成员"。

结构类型很适合 JS 生态，因为 JS 对象本来就经常按形状使用。代价是，有些概念上不同但结构相同的值会被认为兼容。如果你需要区分两个同样是 string 的 id，可以用 branded type。

```ts
type CommandId = string & { readonly __brand: "CommandId" };
type ViewId = string & { readonly __brand: "ViewId" };
```

这类技巧不要滥用。只有当两个值结构相同、误用代价又高时，brand 才值得写。

## 6. Optional、`readonly`、index signature 与 excess property check { #chapter-object-details }

Optional property 写成 `prop?: T`。读取时得到的类型通常是 `T | undefined`，因为属性可能不存在。

```ts
interface AppConfig {
  debounceMs?: number;
  outputChannelName?: string;
}

function readDebounce(config: AppConfig) {
  return config.debounceMs ?? 250;
}
```

`readonly` 限制通过当前类型视角写入属性。

```ts
interface CommandRegistration {
  readonly id: string;
  dispose(): void;
}
```

它不是运行时冻结。如果底层对象还有别的可写引用，属性仍然可能被改。TS 的 `readonly` 适合表达 API 约束：调用者不应该改这个字段。需要运行时不可变时，用 `Object.freeze` 或不可变数据结构。

Index signature 表示未知属性名的统一值类型。

```ts
interface CommandMap {
  [id: string]: () => Promise<void>;
}
```

它适合真正的字典结构。不要把明确字段全塞进 index signature，否则会损失字段级信息。能用 `Record<CommandId, Handler>` 或明确对象类型时，优先让 key 空间更具体。

Excess property check 是 TS 对对象字面量额外做的一层检查。把对象字面量直接传给函数时，如果多写了目标类型没有的字段，会报错。

```ts
interface CommandSpec {
  id: string;
  title: string;
}

function register(spec: CommandSpec) {
  console.log(spec.id);
}

// register({ id: "demo.run", title: "Run", titlle: "Typo" });
// Object literal may only specify known properties.
```

这不是普通结构兼容规则的全部。先把对象赋给变量，再传入函数，TS 可能允许额外属性，因为结构类型允许 "至少有这些成员"。

```ts
const spec = { id: "demo.run", title: "Run", internal: true };
register(spec); // ok
```

对象字面量检查的目的很现实：在最容易拼错字段名的位置抓 typo。写配置常量时，`satisfies` 很有用，它既检查对象符合目标类型，又保留对象自己的精确 literal 信息。

```ts
const command = {
  id: "demo.run",
  title: "Run",
} satisfies CommandSpec;
```

## 7. Class 类型、TS-only 修饰符与结构化协议边界 { #chapter-class-boundary }

TypeScript 支持 JS class，并增加类型层的字段声明、访问修饰符和 `implements` 检查。

```ts
interface DisposableLike {
  dispose(): void;
}

class Runner implements DisposableLike {
  private disposed = false;

  constructor(private readonly output: LogWriter) {}

  run() {
    if (!this.disposed) {
      this.output.appendLine("run");
    }
  }

  dispose() {
    this.disposed = true;
    this.output.dispose();
  }
}
```

`private`、`protected`、`public`、`readonly` 这些 TS 修饰符主要是类型检查层的约束。它们和 JS 的 `#privateField` 不一样。`#privateField` 是运行时语法，外部真的无法访问；TS `private` 编译到普通属性时，运行时仍然只是 JS 对象属性。

```ts
class Example {
  private softPrivate = 1;
  #hardPrivate = 2;
}
```

如果需要运行时私有，使用 `#`。如果只是希望项目内 API 不被误用，TS `private` 更轻。工程代码里常见的是把资源、连接、订阅或输出通道封进 class，再通过一个统一的生命周期容器负责关闭。

`implements` 只检查实例形状是否满足接口，不会改变运行时 prototype，也不会自动复制方法。

```ts
interface Activatable {
  activate(): Promise<void>;
}

class Service implements Activatable {
  async activate() {
    // prepare service
  }
}
```

这依然是结构类型。如果一个对象有 `activate(): Promise<void>`，即使它不是 `Service` 实例，也能当成 `Activatable` 使用。对现代 JS API 来说这是自然的：handler、provider、plugin、task、disposable 本来就是按形状接入宿主。

class method 的 `this` 仍然要小心。TS 能检查方法里 `this.output` 是否存在，但如果你把方法当普通函数传出去，JS 运行时仍然可能丢 `this`。

```ts
const runner = new Runner(output);

commandRegistry.set("demo.run", () => runner.run());
```

这里保留箭头函数闭包，比直接传 `runner.run` 安全。TS 能把很多形状错误提前暴露，但 JS 的调用规则没有被改写。
