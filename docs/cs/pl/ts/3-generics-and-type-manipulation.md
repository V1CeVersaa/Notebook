# Generics 与类型级派生

<!-- Source: https://www.typescriptlang.org/docs/handbook/2/generics.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/keyof-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/typeof-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/indexed-access-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/conditional-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/mapped-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/template-literal-types.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/utility-types.html -->

!!! Abstract "Outline"

    TypeScript 的泛型和类型运算会改变 API 设计方式：类型可以从已有值、对象形状和函数签名里派生出来，不必人工同步一堆重复声明。

    - [x] [1. Generic 表达输入和输出的关系](#chapter-generics-relationship)
    - [x] [2. Generic constraint 与可用成员](#chapter-generics-constraint)
    - [x] [3. `keyof`、`typeof` 与 indexed access type](#chapter-keyof-typeof-indexed)
    - [x] [4. Conditional type、`infer` 与分布行为](#chapter-conditional-infer)
    - [x] [5. Mapped type、key remapping 与 template literal type](#chapter-mapped-template)
    - [x] [6. Utility types 的真实用途](#chapter-utility-types)
    - [x] [7. 什么时候别把类型写复杂](#chapter-type-complexity)

## 1. Generic 表达输入和输出的关系 { #chapter-generics-relationship }

Generic/泛型 用来 **表达多个位置之间的类型关系**。如果一个函数的输入是什么类型，输出就应该保持同一个类型，那么类型参数就值得写。

```ts
function identity<T>(value: T): T {
  return value;
}

const a = identity("demo"); // string
const b = identity(42);     // number
```

如果把参数写成 `any`，调用者也能传任何值，但返回值会失去信息。

```ts
function identityAny(value: any): any {
  return value;
}

const result = identityAny("demo");
result.missing.deep.call(); // allowed, unsafe
```

`T` 的意义是 "这个位置和那个位置是同一个未知类型"。未知类型仍然保留关系，不会退回到 `any` 那种放弃检查的状态。数组工具函数最容易看出这点。

```ts
function first<T>(items: readonly T[]): T | undefined {
  return items[0];
}

const command = first(["demo.run", "demo.stop"]);
// string | undefined
```

TS 通常能从调用点推断类型参数，不需要手写 `first<string>(...)`。只有当推断信息不足，或者你想显式选择更宽的类型时，才需要写类型参数。

```ts
const values = first<string | number>(["demo.run", 1]);
```

泛型也能用于 interface 和 type。比如一个异步任务结果，可以把成功值类型留给调用方决定。

```ts
type AsyncResult<T> =
  | { status: "ok"; value: T }
  | { status: "error"; error: Error };

async function runCommand<T>(work: () => Promise<T>): Promise<AsyncResult<T>> {
  try {
    return { status: "ok", value: await work() };
  } catch (error) {
    return {
      status: "error",
      error: error instanceof Error ? error : new Error(String(error)),
    };
  }
}
```

这里 `T` 把 `work` 的返回值和成功结果里的 `value` 绑在一起。没有泛型，只能写成 `unknown` 或 `any`，调用者会丢掉结果类型。

## 2. Generic constraint 与可用成员 { #chapter-generics-constraint }

未受约束的 `T` 什么成员都不能假设。TS 只知道它是某种类型，但不知道它有没有 `.length`、`.id` 或 `.dispose()`。

```ts
function logLength<T>(value: T) {
  // value.length; // TypeScript error
  console.log(value);
}
```

Generic constraint/泛型约束 用 `extends` 表示 `T` 至少要满足某个形状。加上约束后，函数体里就能使用这个形状提供的成员。

```ts
function logLength<T extends { length: number }>(value: T): T {
  console.log(value.length);
  return value;
}

logLength("demo");
logLength(["demo.run"]);
```

`extends` 在这里表示类型兼容约束，不是 class inheritance。只要有 `length: number`，就能传入。结构类型仍然生效。

约束最常见的模式是 key/value 关系。`K extends keyof T` 表示 `K` 必须是 `T` 的属性名。

```ts
function getProperty<T, K extends keyof T>(object: T, key: K): T[K] {
  return object[key];
}

const spec = { id: "demo.run", title: "Run" };

const id = getProperty(spec, "id");       // string
// getProperty(spec, "missing");          // TypeScript error
```

这段代码已经有 TS 类型级编程的味道：`T` 表示整个对象形状，`K` 表示对象键，`T[K]` 表示这个键对应的值类型。函数实现只有一行，重要信息在类型关系里。

读取配置、feature flag 或表单字段时也适合这种模式。把配置 schema 写成一个对象形状后，读取函数可以根据 key 返回对应类型。

```ts
interface AppSettings {
  debounceMs: number;
  enabled: boolean;
  outputChannelName: string;
}

const settings: AppSettings = {
  debounceMs: 250,
  enabled: true,
  outputChannelName: "app",
};

function readSetting<K extends keyof AppSettings>(key: K): AppSettings[K] {
  return settings[key];
}

const debounceMs = readSetting("debounceMs"); // number
```

这里的关键是 `K` 同时出现在入参和返回值里。传入 `"debounceMs"` 时返回 `number`，传入 `"enabled"` 时返回 `boolean`。如果配置来自外部 JSON，读取函数就不能直接返回 `AppSettings[K]`，而应该先做运行时校验，或者把返回值写成 `AppSettings[K] | undefined`。

## 3. `keyof`、`typeof` 与 indexed access type { #chapter-keyof-typeof-indexed }

`keyof` 把对象类型的键取出来，形成 union。

```ts
type CommandSpec = {
  id: string;
  title: string;
  enabled: boolean;
};

type CommandSpecKey = keyof CommandSpec;
// "id" | "title" | "enabled"
```

这让 key 不再只是普通 `string`。如果一个函数只允许访问配置对象里存在的字段，参数就应该写成 `keyof Config`，而不是 `string`。

`typeof` 在类型位置可以从值推导类型。注意它和 JS 运行时的 `typeof value` 不同；类型位置的 `typeof` 是 TS 操作符。

```ts
const defaultConfig = {
  debounceMs: 250,
  enabled: true,
};

type AppConfig = typeof defaultConfig;
```

它适合从默认配置、常量表、命令 registry 里派生类型。好处很直接：少维护一份重复声明。

如果要保留 literal 信息，配合 `as const`。

```ts
const commands = {
  run: "demo.run",
  stop: "demo.stop",
} as const;

type CommandName = keyof typeof commands;
// "run" | "stop"

type CommandId = typeof commands[CommandName];
// "demo.run" | "demo.stop"
```

`typeof commands[CommandName]` 就是 indexed access type/索引访问类型。它从对象类型里按 key 取 value 类型。数组也一样，可以用 `T[number]` 取元素类型。

```ts
const severities = ["info", "warning", "error"] as const;

type Severity = (typeof severities)[number];
// "info" | "warning" | "error"
```

这个模式在现代 TS 里很好用：路由名、事件类型、权限名、日志级别、feature flag 都可以先写成值，再派生类型。这样运行时常量和静态类型不会分叉。

`satisfies` 补的是检查边界。它检查一个值符合某个类型，但不把值强行拓宽成那个类型。

```ts
const commandRegistry = {
  run: { id: "demo.run", title: "Run" },
  stop: { id: "demo.stop", title: "Stop" },
} satisfies Record<string, { id: string; title: string }>;

type RegisteredCommand = keyof typeof commandRegistry;
// "run" | "stop"
```

如果写成 `const commandRegistry: Record<string, ...>`，`keyof typeof commandRegistry` 会变成 `string`，精确信息丢了。`satisfies` 能同时检查结构和保留字面量。

## 4. Conditional type、`infer` 与分布行为 { #chapter-conditional-infer }

Conditional type/条件类型 的形式是 `T extends U ? X : Y`。它像类型层的条件表达式：如果 `T` 能赋给 `U`，结果是 `X`，否则是 `Y`。

```ts
type IsString<T> = T extends string ? true : false;

type A = IsString<"demo">; // true
type B = IsString<number>; // false
```

常见用法是从复杂类型里抽取一部分。`infer` 可以在条件类型里声明一个待推断的类型变量。

```ts
type ElementType<T> = T extends readonly (infer Item)[] ? Item : never;

type CommandIds = ElementType<readonly ["demo.run", "demo.stop"]>;
// "demo.run" | "demo.stop"
```

函数返回值也可以这么抽。

```ts
type AsyncValue<T> = T extends Promise<infer Value> ? Value : T;

type Loaded = AsyncValue<Promise<string>>;
// string
```

TS 标准库里的 `ReturnType`、`Parameters`、`Awaited` 都是这种思路。你不需要天天自己写 `infer`，但要能读懂这些工具类型为什么能工作。

Conditional type 遇到裸类型参数的 union 时会分布。也就是说，`T extends U ? X : Y` 会分别作用到 union 的每一支，再把结果合起来。

```ts
type ToArray<T> = T extends unknown ? T[] : never;

type Result = ToArray<string | number>;
// string[] | number[]
```

如果不想分布，可以把两边包进 tuple。

```ts
type ToArrayNonDistributive<T> = [T] extends [unknown] ? T[] : never;

type Result = ToArrayNonDistributive<string | number>;
// (string | number)[]
```

这个规则一开始很容易看漏。写 `Exclude`、`Extract`、事件映射和 message protocol 类型时，分布行为派得上用场；写容器类型时，它又可能让结果比预期更散。

## 5. Mapped type、key remapping 与 template literal type { #chapter-mapped-template }

Mapped type/映射类型 会遍历一组 key，为每个 key 生成属性。

```ts
type ReadonlyConfig<T> = {
  readonly [K in keyof T]: T[K];
};

type PartialConfig<T> = {
  [K in keyof T]?: T[K];
};
```

这就是 `Readonly<T>` 和 `Partial<T>` 的基本形状。它们不关心具体字段名，只关心 "对每个字段做同一种变换"。这类类型适合表达配置 patch、只读视图、DTO、事件 handler map。

映射类型可以用 `+readonly`、`-readonly`、`+?`、`-?` 控制修饰符。去掉 optional 就能得到 `Required<T>` 的基本形状。

```ts
type Concrete<T> = {
  [K in keyof T]-?: T[K];
};
```

Key remapping 用 `as` 改生成出来的 key。配合 template literal type，可以从一种命名约定生成另一种。

```ts
type EventHandlers<T extends string> = {
  [K in T as `on${Capitalize<K>}`]: (event: { type: K }) => void;
};

type Handlers = EventHandlers<"ready" | "error">;
// { onReady: ...; onError: ... }
```

Template literal type 把字符串 literal 组合成新字符串类型。它适合描述有规则的 id，而不是任意字符串。

```ts
type CommandNamespace = "demo" | "tools";
type CommandAction = "run" | "stop";
type CommandId = `${CommandNamespace}.${CommandAction}`;

const id: CommandId = "demo.run";
// const bad: CommandId = "demo.delete";
```

路由名、事件名、配置 key、CSS token、i18n key 都经常有命名规则。把这些规则写进类型，可以抓到拼写错误。不过要注意边界：如果 id 来自用户配置、数据库或第三方系统，静态 literal type 管不到运行时字符串。

## 6. Utility types 的真实用途 { #chapter-utility-types }

Utility types 不适合按 API 表硬背。更好的记法是看它们在项目里减少了哪类重复建模。

`Partial<T>` 把所有属性变成 optional，适合配置 patch 或测试里只覆盖部分字段。`Required<T>` 反过来，把 optional 属性变成必填，适合 "默认值补齐之后" 的内部形状。

```ts
interface RawConfig {
  debounceMs?: number;
  outputChannelName?: string;
}

type NormalizedConfig = Required<RawConfig>;

function normalize(config: RawConfig): NormalizedConfig {
  return {
    debounceMs: config.debounceMs ?? 250,
    outputChannelName: config.outputChannelName ?? "Demo",
  };
}
```

`Readonly<T>` 表达只读视图，`Record<K, V>` 表达 key 到 value 的映射。

```ts
type CommandId = "demo.run" | "demo.stop";
type CommandHandlers = Record<CommandId, () => Promise<void>>;

const handlers: Readonly<CommandHandlers> = {
  "demo.run": async () => {},
  "demo.stop": async () => {},
};
```

`Pick<T, K>` 和 `Omit<T, K>` 用来从对象类型里取字段或删字段。它们适合把内部完整对象裁剪成公共 API。

```ts
interface InternalCommand {
  id: string;
  title: string;
  telemetryKey: string;
}

type PublicCommand = Pick<InternalCommand, "id" | "title">;
type CommandWithoutTelemetry = Omit<InternalCommand, "telemetryKey">;
```

`Exclude<T, U>` 从 union 里去掉能赋给 `U` 的分支，`Extract<T, U>` 保留能赋给 `U` 的分支，`NonNullable<T>` 去掉 `null` 和 `undefined`。

```ts
type Runtime = "node" | "web" | "test";

type ProductionRuntime = Exclude<Runtime, "test">;
type BrowserRuntime = Extract<Runtime, "web">;
type Present<T> = NonNullable<T>;
```

`ReturnType<T>`、`Parameters<T>` 和 `Awaited<T>` 则从函数类型或 Promise-like 类型里抽取信息。它们特别适合避免 API 改动后重复类型不同步。

```ts
async function loadConfig() {
  return {
    debounceMs: 250,
    enabled: true,
  };
}

type LoadedConfig = Awaited<ReturnType<typeof loadConfig>>;
```

这句把 `loadConfig` 的异步返回值变成类型。如果函数实现改了，`LoadedConfig` 会跟着变。类型从实现派生，就少一处重复维护。

## 7. 什么时候别把类型写复杂 { #chapter-type-complexity }

TS 的类型系统足够强，也足够容易被写过头。判断一个类型抽象是否值得，先看它有没有减少真实重复，或者有没有把 API 关系表达得更准确。

值得写泛型的场景通常有明显关系：输入 key 决定输出 value，输入函数决定返回值，配置常量决定合法 id，message discriminant 决定 payload。只是在一个地方出现的对象类型，直接写 interface 就好。

```ts
interface OpenFileMessage {
  type: "openFile";
  uri: string;
}
```

这比为了 "通用" 写一套 `MessageOf<Type, Payload>` 更容易读。类型级编程应该减少实现错误，而不是展示技巧。

另一个边界是编译性能和错误信息。复杂 conditional type、深层 mapped type、递归 type 都可能让错误信息变成一大段不可读的展开结果。公共 API 尤其要克制，因为调用方看到的是你的错误信息。

实用的默认策略是：值层有真实 registry 或 schema 时，用 `typeof`、`keyof`、indexed access 从值派生类型；API 存在稳定的变换关系时，用泛型和 utility types；如果只是为了少写几个字段，宁可重复一点，也不要制造读不懂的类型机器。
