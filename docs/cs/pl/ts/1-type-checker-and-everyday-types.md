# Type Checker 与日常类型

<!-- Source: https://www.typescriptlang.org/docs/handbook/intro.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/basic-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/everyday-types.html -->

!!! Abstract "Outline"

    TypeScript 是 JavaScript 的静态检查层：它检查值在运行前能不能安全使用，编译后类型会被擦除，执行的仍然是 JavaScript。

    - [x] [1. TypeScript 是检查器，不是新运行时](#chapter-checker-runtime)
    - [x] [2. 标注、推断与 literal widening](#chapter-annotation-inference)
    - [x] [3. Primitive、array、tuple 与 object](#chapter-everyday-types)
    - [x] [4. Union、literal type 与可表达的状态空间](#chapter-union-literal)
    - [x] [5. `any`、`unknown` 与 `never`](#chapter-top-bottom-types)
    - [x] [6. `null`、`undefined` 与 `strictNullChecks`](#chapter-nullish-strict)
    - [x] [7. `tsc`、emit with errors 与项目边界](#chapter-tsc-project)

## 1. TypeScript 是检查器，不是新运行时 { #chapter-checker-runtime }

TypeScript 的定位很直白：**TypeScript is JavaScript with syntax for types**。它接受 JavaScript 语法，在上面增加类型标注、接口、泛型、类型运算等静态信息，然后把这些静态信息擦掉，输出普通 JavaScript。运行时看到的是 JS，不会多出一套带类型对象的 VM。

这条边界要先记住。TypeScript 能在编辑器和编译阶段告诉你某个值可能没有 `toUpperCase`，但它不会在编译后的代码里自动插入检查。

```ts
function shout(message: string) {
  return message.toUpperCase();
}

shout("ready");
// shout(42); // TypeScript error
```

编译后的 JavaScript 大致只剩函数和方法调用：

```js
function shout(message) {
  return message.toUpperCase();
}
```

如果你绕过类型检查，运行时照样可能炸。TypeScript 不提供 Rust 那种强制内存安全，也没有 JVM 里的运行时 class verifier。它是一套给 JS 项目使用的静态推理系统：不改变 JS 执行模型，只提前发现 "这个操作对这个值不一定合法"。

所以 TS 的错误经常围绕 **property access** 和 **call expression** 出现。JavaScript 允许你写 `obj.missing()`，运行时才会因为 `missing` 是 `undefined` 而抛 `TypeError`。TS 会在运行前判断 `obj` 的类型里是否真的有 `missing` 这个成员。

```ts
const command = { id: "demo.run" };

// command.title.toUpperCase();
// Property 'title' does not exist on type '{ id: string; }'.
```

这种检查很适合边界很多的 JS 项目：HTTP response、用户配置、URL 参数、事件回调、表单状态、插件宿主 API、第三方 SDK 都在传对象。这里常见问题是对象形状和 API 约定对不上，不是算法本身有多难。TS 把这些约定交给编辑器和编译器提前检查。

## 2. 标注、推断与 literal widening { #chapter-annotation-inference }

类型标注/Type Annotation 是给变量、参数或返回值写明类型。参数通常应该标注，因为函数边界是外部调用者进入当前代码的入口。局部变量如果初始化表达式已经足够明确，交给类型推断/Type Inference 就够了。

```ts
function normalizeCommand(id: string): string {
  return id.trim().toLowerCase();
}

const normalized = normalizeCommand("Demo.Run");
```

`normalized` 不需要写成 `const normalized: string`。TS 能从函数返回值推出它是 `string`。这种推断来自表达式的静态结构，不依赖运行时观察。

TS 还有 contextual typing。函数表达式被放到一个已经有类型的位置时，参数类型可以从上下文流入函数体。

```ts
const handlers: Array<(id: string) => void> = [
  (id) => {
    console.log(id.toUpperCase());
  },
];
```

这里 `id` 没有显式标注，但它处在 `(id: string) => void` 的上下文里。事件监听、路由注册、任务调度、UI callback 都会把上下文类型传给回调。

literal widening 是另一条容易忘的规则。`let` 变量可能被重新赋值，所以字符串字面量会拓宽成 `string`；`const` 绑定不能重新绑定，所以保留更窄的 literal type。

```ts
let mode = "node";   // string
const host = "node"; // "node"
```

对象属性默认仍然会拓宽，因为对象内部属性即使用 `const` 绑定也可以修改。

```ts
const config = {
  host: "node",
};

config.host = "web"; // ok, host is string
```

如果确实需要把一个对象当成不可变配置字面量，可以用 `as const`。它会把属性变成 readonly，并保留 literal type。

```ts
const runtimeKind = {
  server: "node",
  web: "web",
} as const;

type RuntimeKind = typeof runtimeKind[keyof typeof runtimeKind];
// "node" | "web"
```

这里的 readonly 仍然是类型层约束。它会让 TS 拒绝赋值，但编译后的 JS 没有运行时冻结。

类型断言/Type Assertion 用 `as` 告诉编译器 "把这个值当成某类型看"。它不做运行时转换，也不验证值是否真的符合目标类型。

```ts
const input = document.querySelector("#name") as HTMLInputElement;
```

这句不会检查 `querySelector` 是否真的找到了 input。应用里更常见的断言是从外部 JSON、message event、命令参数或数据库记录里恢复类型。断言越靠近外部边界，越应该配运行时检查；否则只是把类型错误推迟成运行时错误。

## 3. Primitive、array、tuple 与 object { #chapter-everyday-types }

TS 的 primitive 类型和 JS 运行时值类型对应：`string`、`number`、`bigint`、`boolean`、`symbol`、`null`、`undefined`。日常代码里最常见的是前四个。普通值类型用小写，不要写成 `String`、`Number`、`Boolean` 这些 wrapper object 类型，除非你真的在处理对象包装器。

```ts
const title: string = "Demo";
const retry: number = 3;
const enabled: boolean = true;
const id: bigint = 9007199254740993n;
```

数组类型可以写成 `string[]` 或 `Array<string>`。前者短，后者在嵌套或泛型组合时有时更容易读。

```ts
const commands: string[] = ["demo.run", "demo.stop"];
const groups: Array<readonly string[]> = [["demo.run", "demo.stop"]];
```

`readonly string[]` 表示不能通过这个引用修改数组。它保护的是这个类型视角下的写操作，不代表底层数组在运行时被冻结。

```ts
function render(items: readonly string[]) {
  // items.push("new"); // TypeScript error
  return items.join(", ");
}
```

tuple/元组表示固定长度、固定位置含义的数组。它适合返回少量位置语义明确的数据，例如 `[line, character]`。如果元素数量增长，或者每个位置都需要名字，普通对象更容易维护。

```ts
type PositionTuple = [line: number, character: number];

const pos: PositionTuple = [3, 14];
```

object type 描述对象形状。TS 关心的是这个值有没有对应属性，以及属性类型能不能兼容。

```ts
type CommandSpec = {
  id: string;
  title: string;
  enabled?: boolean;
};

function register(spec: CommandSpec) {
  console.log(spec.id, spec.title);
}
```

`enabled?: boolean` 表示 optional property。它和 `enabled: boolean | undefined` 不完全一样：前者允许属性不存在，后者要求属性存在但值可以是 `undefined`。如果开启 `exactOptionalPropertyTypes`，这个差异会更严格。配置对象、JSON patch、部分更新参数都需要这条边界。

## 4. Union、literal type 与可表达的状态空间 { #chapter-union-literal }

Union type 用 `|` 表示一个值可能属于几种类型。TS 不会因为你写了 union 就让你随便使用每一支的能力；在没有收窄之前，只能使用所有成员共同拥有的操作。

```ts
function format(value: string | number) {
  return value.toString();
}

function upper(value: string | number) {
  if (typeof value === "string") {
    return value.toUpperCase();
  }

  return value.toFixed(2);
}
```

这就是 TS 和普通注释的差异。你写下 `string | number` 之后，编译器会追踪控制流，直到它能证明当前分支里 `value` 是其中一类。

literal type 把某个具体值作为类型。单独看 `"node"` 这样的类型没什么意义，和 union 组合后就能表达有限状态空间。

```ts
type RuntimeTarget = "node" | "browser" | "worker";
type Severity = "info" | "warning" | "error";
```

这比随手写 `string` 更精确。现代项目里很多字段本来就是有限集合：路由名、feature flag、事件类型、运行环境、日志级别、消息类型。把它们压成 literal union，拼写错误会提前暴露。

```ts
type Message =
  | { kind: "ready" }
  | { kind: "run"; command: string }
  | { kind: "error"; message: string };
```

这种写法叫 discriminated union/可辨识联合。`kind` 是判别字段，TS 可以根据它判断当前对象到底是哪一种形状。它比一堆 optional property 更适合表达互斥状态。

```ts
function handle(message: Message) {
  if (message.kind === "run") {
    return message.command;
  }

  if (message.kind === "error") {
    return message.message;
  }

  return "ready";
}
```

如果用一个大对象写成 `{ kind: string; command?: string; message?: string }`，TS 不能知道 `kind === "run"` 时 `command` 一定存在。类型越接近真实状态机，后续代码越少靠猜。

## 5. `any`、`unknown` 与 `never` { #chapter-top-bottom-types }

`any` 是类型检查逃生口。一个值变成 `any` 后，几乎所有操作都会被允许，错误会重新回到运行时。

```ts
let payload: any = JSON.parse("{}");

payload.missing.deep.call(); // allowed by TypeScript, unsafe at runtime
```

`any` 在迁移老 JS、临时绕过第三方类型缺口时有用，但它会污染后续推断。一个 `any` 进入函数，返回值也很容易跟着失去类型信息。写新代码时，外部未知数据优先用 `unknown`。

```ts
let payload: unknown = JSON.parse("{}");

// payload.missing; // TypeScript error
```

`unknown` 表示 "我还不知道它是什么"。你必须先做运行时检查，才能把它当成更具体的类型使用。

```ts
function readMessage(payload: unknown): string | undefined {
  if (
    typeof payload === "object" &&
    payload !== null &&
    "message" in payload &&
    typeof payload.message === "string"
  ) {
    return payload.message;
  }

  return undefined;
}
```

这段代码看起来比 `as { message: string }` 麻烦，但它处理了不可信边界。HTTP body、message event、localStorage、CLI 参数、JSON 配置都属于这类边界。`unknown` 强迫你先证明，再使用。

`never` 表示不可能出现的类型。函数永远抛异常、永远不返回，返回类型可以是 `never`；union 被完整收窄后，剩下的也会是 `never`。

```ts
function fail(message: string): never {
  throw new Error(message);
}
```

`never` 常用于 exhaustiveness check。每个状态都处理完之后，default 分支里的值应该是 `never`。如果未来新增状态但没有改处理逻辑，编译器会报错。

```ts
type Result =
  | { status: "ok"; value: string }
  | { status: "error"; reason: string };

function describe(result: Result) {
  switch (result.status) {
    case "ok":
      return result.value;
    case "error":
      return result.reason;
    default: {
      const exhaustive: never = result;
      return exhaustive;
    }
  }
}
```

这种写法适合 UI 状态、后台任务状态、message protocol 和异步请求状态。它把 "新增状态时别忘了改 switch" 从人工记忆变成类型错误。

## 6. `null`、`undefined` 与 `strictNullChecks` { #chapter-nullish-strict }

JavaScript 里 `null` 和 `undefined` 是两个运行时值。TS 如果不开 `strictNullChecks`，它们会被允许流入很多类型，这会掩盖最常见的一类错误：你以为拿到了对象，实际拿到的是空值。

开启 `strictNullChecks` 后，`null` 和 `undefined` 不再自动属于所有类型。要么在类型里显式写出来，要么在使用前收窄。

```ts
function first(items: string[]): string | undefined {
  return items[0];
}

const value = first([]);

if (value !== undefined) {
  console.log(value.toUpperCase());
}
```

这和 JS 笔记里的空值逻辑接得上。`undefined` 通常表示缺省或没有结果，`null` 通常表示显式清空。TS 不替你决定语义，它只要求你把语义写进类型。

```ts
type AppConfig = {
  debounceMs?: number;
  outputChannelName: string | null;
};
```

`debounceMs?` 表示配置项可以不存在。`outputChannelName: string | null` 表示字段必须存在，但值可能被显式清空。两者在读取时应该有不同处理。

```ts
function normalize(config: AppConfig) {
  const debounceMs = config.debounceMs ?? 250;
  const channelName = config.outputChannelName ?? "Demo";

  return { debounceMs, channelName };
}
```

`??` 只处理 `null` 和 `undefined`，不会吞掉 `0`、`false`、`""`。配置解析里这比 `||` 更贴近类型语义。TS 能帮你看见空值，但默认值逻辑仍然要按 JS 运行时规则写。

## 7. `tsc`、emit with errors 与项目边界 { #chapter-tsc-project }

`tsc` 是 TypeScript compiler。它主要做两件事：检查类型，按配置输出 JavaScript。容易误解的是，TS 默认允许 **emit with errors**：即使有类型错误，也可能继续输出 JS 文件。这个设计方便老项目迁移，因为一处类型错误不一定要立刻阻断所有输出。

```bash
tsc -p .
```

如果希望类型错误时不输出产物，要在 `tsconfig.json` 里启用 `noEmitOnError`。

```json
{
  "compilerOptions": {
    "strict": true,
    "noEmitOnError": true,
    "outDir": "out",
    "rootDir": "src"
  }
}
```

现代 TS 项目通常应该开 `strict`，再用少量局部收窄和运行时验证处理外部输入。`strict` 是一组严格检查的总开关，包括 `strictNullChecks`、`noImplicitAny` 等。新项目默认打开更省事；旧 JS 迁移项目可以分阶段收紧。

`tsc` 不等于 bundler。它能把 TS 语法变成 JS，也能生成 declaration file，但它不会自动把所有依赖打成一个文件，不会替你处理 CSS、图片、worker、WASM，也不会替你决定运行时代码如何加载。现代项目里，`tsc` 常用于类型检查；实际打包可能交给 Vite、esbuild、swc、webpack、Rollup、Bun 或运行时自己的 loader。

类型检查的边界也要清楚：`.ts` 文件内的类型会被检查，外部 JS、JSON、用户输入、宿主 API 返回值仍然可能带来运行时不确定性。TypeScript 能减少错误，但它不是可信输入验证器。只要数据来自运行时边界，`unknown`、schema validation 或手写 guard 仍然需要出现。
