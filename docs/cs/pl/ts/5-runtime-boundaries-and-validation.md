# 运行时边界、Schema Validation 与断言函数

<!-- Source: https://zod.dev/basics -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/2/narrowing.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html -->
<!-- Source: https://www.typescriptlang.org/tsconfig/noUncheckedIndexedAccess.html -->
<!-- Source: https://www.typescriptlang.org/tsconfig/useUnknownInCatchVariables.html -->

!!! Abstract "Outline"

    TypeScript 只检查静态源码，不替运行时数据背书；现代 TS 项目要把外部输入先当成 `unknown`，再用 schema、guard 或 assertion function 把值收窄到可信形状。

    - [x] [1. 类型系统停在运行时边界外](#chapter-runtime-boundary)
    - [x] [2. Zod、`z.infer` 与单一 schema 来源](#chapter-zod-infer)
    - [x] [3. `safeParse` 与 discriminated result](#chapter-safeparse)
    - [x] [4. Type predicate 与 assertion function](#chapter-assertion-functions)
    - [x] [5. `noUncheckedIndexedAccess` 与索引访问风险](#chapter-index-access)
    - [x] [6. `catch` 变量为什么应该是 `unknown`](#chapter-catch-unknown)

## 1. 类型系统停在运行时边界外 { #chapter-runtime-boundary }

TypeScript 能证明源码里一个值如何被使用，但它不能证明外部世界一定按类型声明传数据。`fetch()` 的 response、`localStorage`、URL query、postMessage、CLI 参数、数据库记录、第三方 SDK 返回值，本质上都是 **运行时边界/runtime boundary**。边界外的数据先按 `unknown` 看，比直接写 `as SomeType` 更诚实。

```ts
type User = {
  id: string;
  role: "admin" | "member";
};

async function loadUser(id: string): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  return response.json() as Promise<User>;
}
```

这段代码的问题很冷酷：`as Promise<User>` 没有检查任何东西。服务器返回 `{ id: 42, role: "root" }` 时，TypeScript 不会在运行时拦住它，后续代码还会以为自己拿到了合法 `User`。类型断言把错误从边界处推迟到了更深的业务逻辑里。

更可靠的形态是先承认边界未知，再把收窄动作写出来。

```ts
async function loadJson(url: string): Promise<unknown> {
  const response = await fetch(url);
  return response.json();
}
```

`unknown` 的好处是强迫调用者做证明。这个证明可以是手写 guard，也可以是 schema validation。现代项目更常见的是后者，因为 schema 同时服务运行时校验和静态类型派生。

## 2. Zod、`z.infer` 与单一 schema 来源 { #chapter-zod-infer }

Zod 这类 schema validation 库解决的是同一个老问题：运行时要检查数据，静态类型也要描述数据。如果分别写一份 validator 和一份 TypeScript type，它们迟早会分叉。**schema-first** 的写法把 schema 当成唯一事实来源，再从 schema 派生类型。

```ts
import { z } from "zod";

const UserSchema = z.object({
  id: z.string(),
  role: z.enum(["admin", "member"]),
  profile: z
    .object({
      displayName: z.string(),
    })
    .optional(),
});

type User = z.infer<typeof UserSchema>;
```

`UserSchema` 是运行时值，真的会执行检查；`User` 是静态类型，来自 `z.infer<typeof UserSchema>`。这条关系很关键：字段新增、删改或变成 optional 时，只改 schema，类型自动跟着变。

```ts
async function loadUser(id: string): Promise<User> {
  const payload = await loadJson(`/api/users/${id}`);
  return UserSchema.parse(payload);
}
```

`parse` 成功时返回类型已经是 `User`，失败时抛 `ZodError`。这比 `as User` 多做了一件运行时实事：它真的检查了 `id` 是字符串，`role` 是允许的枚举值，`profile` 如果存在也有正确形状。

这不是说所有地方都要上 Zod。热路径、极小 helper、只在内部流动的值，用手写 guard 可能更轻。schema validation 最适合 **外部输入边界**、**配置解析**、**API response**、**消息协议**、**表单提交** 这些容易漂移的地方。

## 3. `safeParse` 与 discriminated result { #chapter-safeparse }

`parse` 的失败路径是异常；`safeParse` 的失败路径是返回值。后者更适合在 UI、CLI 和服务端 request handler 里显式分支处理。

```ts
const result = UserSchema.safeParse(await loadJson("/api/me"));

if (!result.success) {
  console.error(result.error.format());
  throw new Error("Invalid user payload");
}

const user = result.data;
```

`safeParse` 的返回值本身就是 discriminated union：`success: true` 时有 `data`，`success: false` 时有 `error`。这和前面学过的状态建模完全一致。Zod 只是把运行时校验结果也做成了 TS 能收窄的形状。

异步校验要用 `safeParseAsync` 或 `parseAsync`。比如 schema 里有 async refinement，需要查数据库判断用户名是否重复，同步 parse 就表达不了这条异步边界。

```ts
const SignupSchema = z.object({
  email: z.string().email(),
  password: z.string().min(12),
});

type SignupInput = z.infer<typeof SignupSchema>;
```

表单场景下，`SignupInput` 不是 UI 状态的全部类型。输入框里可能暂时是空字符串，错误提示也可能挂在字段上；schema 描述的是 **提交边界**，不是每一帧 UI 的临时状态。别把所有中间态都硬塞进最终 payload schema。

## 4. Type predicate 与 assertion function { #chapter-assertion-functions }

Type predicate/类型谓词 写成 `value is T`，适合返回 boolean 的检查函数。调用者可以在 `if` 分支里获得收窄。

```ts
function isUser(value: unknown): value is User {
  return UserSchema.safeParse(value).success;
}

function greet(value: unknown) {
  if (isUser(value)) {
    return `hello ${value.id}`;
  }

  return "invalid user";
}
```

Assertion function/断言函数 写成 `asserts condition` 或 `asserts value is T`，适合失败就抛错的检查函数。它不返回 `true` / `false`；只要函数正常返回，TS 就认为断言已经成立。

```ts
function assertUser(value: unknown): asserts value is User {
  const result = UserSchema.safeParse(value);

  if (!result.success) {
    throw new Error("Invalid user payload");
  }
}

function handle(value: unknown) {
  assertUser(value);
  return value.role;
}
```

`asserts value is User` 比 `value is User` 更适合初始化、测试 helper、边界入口和命令式流程。它的语义是 "失败就中断"，所以后续主路径不需要套一层 `if`。

还有一种 `asserts condition`，用于表达普通条件为真。

```ts
function assert(condition: unknown, message: string): asserts condition {
  if (!condition) {
    throw new Error(message);
  }
}

function getFirst<T>(items: readonly T[]): T {
  assert(items.length > 0, "Expected non-empty array");
  return items[0]!;
}
```

断言函数依然可能写错。TypeScript 信任函数签名，不会证明函数体真的覆盖了所有坏数据。所以公共断言最好薄一点，内部直接调用成熟 schema 或小而清楚的 guard。

## 5. `noUncheckedIndexedAccess` 与索引访问风险 { #chapter-index-access }

数组和字典访问是 TS 默认比较宽松的地方。不开 `noUncheckedIndexedAccess` 时，`items[0]` 在类型上可能是 `T`，但运行时空数组会返回 `undefined`。

```ts
const items = ["a", "b"];
const first = items[0];
```

开启 `noUncheckedIndexedAccess` 后，索引访问会自动把 `undefined` 加进类型里。

```ts
function first<T>(items: readonly T[]): T | undefined {
  return items[0];
}
```

这和手写 `T | undefined` 的习惯是一致的，只是编译器帮你把所有索引访问都变得诚实。它不在传统 `strict` 总开关里，需要单独开启。配置对象、环境变量、URL query、`Record<string, T>` 字典都很适合受它约束。

```ts
type Env = Record<string, string>;

declare const env: Env;

const nodeEnv = env.NODE_ENV;
// with noUncheckedIndexedAccess: string | undefined
```

如果某个 key 在类型上确实必然存在，就不要用宽泛 index signature；把它写成明确属性。

```ts
interface RuntimeEnv {
  NODE_ENV: "development" | "production" | "test";
  [key: string]: string;
}
```

这种写法把已知字段和未知字段分开：`NODE_ENV` 是必有字段，其他环境变量仍然可能缺失。TS 的严格性最好落在真实模型上，而不是靠一堆 `!` 把错误压掉。

## 6. `catch` 变量为什么应该是 `unknown` { #chapter-catch-unknown }

JavaScript 允许抛任何值，不只允许抛 `Error`。`throw "bad"`、`throw 404`、`throw { code: "E_FAIL" }` 都是合法 JS。所以 catch 变量按 `unknown` 处理是合理的：你还不知道它到底是什么。

```ts
try {
  await runTask();
} catch (error) {
  if (error instanceof Error) {
    console.error(error.message);
  } else {
    console.error("Unknown error", error);
  }
}
```

`useUnknownInCatchVariables` 打开后，`catch (error)` 默认就是 `unknown`，不需要再写 `catch (error: unknown)`。它通常随 `strict` 一起出现。这个选项逼你在错误处理里做运行时判断，避免到处假设 `error.message` 一定存在。

如果项目有统一错误类型，也不要指望 catch 自动给你这个类型。边界处还是要转换。

```ts
class AppError extends Error {
  constructor(
    message: string,
    readonly code: string,
  ) {
    super(message);
  }
}

function normalizeError(error: unknown): AppError {
  if (error instanceof AppError) {
    return error;
  }

  if (error instanceof Error) {
    return new AppError(error.message, "UNKNOWN");
  }

  return new AppError(String(error), "NON_ERROR_THROWN");
}
```

这条规则和 schema validation 是同一套思想：**外部输入先不信，边界处显式恢复类型**。区别只在于数据来源从 HTTP body 换成了异常通道。
