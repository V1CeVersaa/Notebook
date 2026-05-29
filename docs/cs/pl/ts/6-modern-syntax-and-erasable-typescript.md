# 现代语法、资源管理与可擦除 TypeScript

<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-5-2.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-5-0.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/enums.html -->
<!-- Source: https://www.typescriptlang.org/tsconfig/erasableSyntaxOnly.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-0.html -->

!!! Abstract "Outline"

    现代 TypeScript 不只是类型标注；它还要区分哪些语法会留下运行时代码，哪些语法能被直接擦除，以及哪些新特性适合用来收紧 API 的字面量信息和资源生命周期。

    - [x] [1. TS-only runtime syntax 与可擦除语法](#chapter-erasable-syntax)
    - [x] [2. `using`、`await using` 与显式资源管理](#chapter-explicit-resource-management)
    - [x] [3. `const` 类型参数保留 literal 信息](#chapter-const-type-parameters)
    - [x] [4. Variadic tuple types 表达参数列表变换](#chapter-variadic-tuples)
    - [x] [5. `enum`、literal union 与 `as const` registry](#chapter-enum-vs-union)
    - [x] [6. Decorators、JSX 与框架类型边界](#chapter-framework-syntax)

## 1. TS-only runtime syntax 与可擦除语法 { #chapter-erasable-syntax }

TypeScript 大部分类型语法都能被擦掉：类型标注、interface、type alias、generic 参数、`import type` 只服务编译器，输出 JS 时不存在。但 TS 也有一小部分语法会产生运行时代码，比如 `enum`、带运行时代码的 `namespace`、parameter property、`import = require()`、`export =`。这些语法不是 "纯类型"，编译器需要把它们改写成 JS。

这条边界在现代运行时里变得更重要。Node.js 已经支持直接运行部分 TypeScript 文件，但这种 type stripping 工作流只能擦除类型，不能替你降级 TS-only runtime syntax。换句话说，能不能直接运行取决于源码是否接近 "删掉类型后就是合法 JS"。

```ts
class Point {
  constructor(public x: number, public y: number) {}
}
```

这段 parameter property 看起来很短，但它不是可擦除语法。删掉 `public` 和类型以后，`x`、`y` 不会自动变成实例字段。更可擦除的写法是显式声明字段并赋值。

```ts
class Point {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}
```

`erasableSyntaxOnly` 的价值就是把这类语法边界提前变成类型错误。它适合直接运行 TS 源码、依赖 type stripping、或者想让源码尽量贴近标准 JS 的项目。它通常和 `verbatimModuleSyntax` 一起用，因为后者要求你把类型导入和值导入写清楚。

```json
{
  "compilerOptions": {
    "erasableSyntaxOnly": true,
    "verbatimModuleSyntax": true
  }
}
```

这不是说所有项目都必须禁用 TS-only runtime syntax。如果你明确用 `tsc` 或 bundler 编译输出，`enum` 和 parameter property 仍然能工作。关键是别把 "能被编译" 和 "能被直接擦除运行" 混为一谈。

## 2. `using`、`await using` 与显式资源管理 { #chapter-explicit-resource-management }

显式资源管理/Explicit Resource Management 解决的是 `try/finally` 的样板代码：打开一个资源后，无论正常返回、提前返回还是抛错，都应该释放。TS 5.2 支持 `using` 和 `await using`，对应同步和异步 dispose。

```ts
class Subscription implements Disposable {
  constructor(private readonly unsubscribe: () => void) {}

  [Symbol.dispose]() {
    this.unsubscribe();
  }
}

function listen(target: EventTarget, event: string, handler: EventListener) {
  target.addEventListener(event, handler);

  return new Subscription(() => {
    target.removeEventListener(event, handler);
  });
}
```

`Disposable` 的核心协议是对象有 `[Symbol.dispose]()` 方法。`using` 声明的变量在离开作用域时会被自动 dispose，顺序是后创建的先释放。

```ts
function attachResizeHandler(target: EventTarget) {
  using subscription = listen(target, "resize", () => {
    console.log("resize");
  });

  runSynchronousWork();
}
```

这段代码等价于把 `subscription[Symbol.dispose]()` 放进 `finally`，但资源释放协议被写在对象自己身上。它适合文件句柄、临时目录、事件订阅、锁、测试 fixture、数据库连接、短生命周期服务。

异步释放用 `Symbol.asyncDispose` 和 `await using`。

```ts
class TempConnection implements AsyncDisposable {
  async query(sql: string) {
    return sql;
  }

  async [Symbol.asyncDispose]() {
    await this.close();
  }

  private async close() {
    // close socket or database connection
  }
}

async function runQuery() {
  await using connection = new TempConnection();
  return connection.query("select 1");
}
```

这里要看运行时和编译目标。`using` 是语言级运行时行为，不是纯类型。目标环境不支持时，需要编译器输出 helper 或 runtime polyfill。写库时更要谨慎：公开 API 暴露 `Disposable` / `AsyncDisposable`，等于要求用户理解这套生命周期协议。

## 3. `const` 类型参数保留 literal 信息 { #chapter-const-type-parameters }

普通泛型推断经常会把字面量拓宽成更一般的类型。`const` 类型参数让函数作者告诉 TS：调用方传进来的对象、数组和字符串字面量尽量保持精确信息。

```ts
function defineRoutes<const T extends Record<string, { method: string; path: string }>>(
  routes: T,
) {
  return routes;
}

const routes = defineRoutes({
  getUser: { method: "GET", path: "/users/:id" },
  createUser: { method: "POST", path: "/users" },
});

type RouteName = keyof typeof routes;
// "getUser" | "createUser"
```

没有 `const` 类型参数时，很多 API 需要调用者在参数后面写 `as const`。这会把 API 的类型体验推给调用者。`const T` 更适合 `defineConfig`、`defineRoutes`、`createMachine`、`defineMessages` 这类声明式工厂：调用者写普通对象，库函数保留 literal 信息。

这不是越多越好。`const T` 会保留更窄、更 readonly 的推断结果，可能让后续修改变得不方便。它适合 "把一份常量声明变成类型来源" 的 API，不适合普通数据处理函数。

## 4. Variadic tuple types 表达参数列表变换 { #chapter-variadic-tuples }

Variadic tuple types/可变长元组类型 让 TS 能表达 "一个参数列表前面加点东西"、"保留剩余参数"、"把函数参数包起来再传下去"。这类模式以前容易退化成一堆 overload。

```ts
type WithContext<Args extends unknown[]> = [context: RequestContext, ...args: Args];

type Handler<Args extends unknown[]> = (...args: WithContext<Args>) => Promise<void>;
```

`...args: Args` 在类型位置表示保留一段参数列表。它不是运行时 rest parameter 的简单注释，而是把参数列表本身当成可组合的类型。

```ts
function withLogging<Args extends unknown[], R>(
  fn: (...args: Args) => R,
): (...args: Args) => R {
  return (...args) => {
    console.log("call", args);
    return fn(...args);
  };
}
```

这里 `withLogging` 不关心 `fn` 具体有几个参数，也不丢掉参数类型。传入 `(id: string, retry: number) => Promise<User>`，返回函数仍然要求 `(id: string, retry: number)`。

可变长元组适合函数包装器、middleware、event emitter、command dispatcher、测试 helper。它的风险也很明显：类型签名一复杂，读者很难判断推断结果。内部 helper 可以复杂一点，公共 API 要克制。

## 5. `enum`、literal union 与 `as const` registry { #chapter-enum-vs-union }

`enum` 是 TypeScript 少数会产生运行时代码的特性。它不只是类型别名，而是会变成 JS 对象。官方文档也直接把 enum 归类为少数不是纯类型层扩展的 TS 特性。

```ts
enum Direction {
  Up,
  Down,
  Left,
  Right,
}
```

数字 enum 有自增和反向映射等运行时行为，字符串 enum 也会留下对象。这个特点有时有用，比如和历史 API、协议常量、运行时枚举对象交互；但如果你只需要有限字符串集合，literal union 通常更轻。

```ts
type Direction = "up" | "down" | "left" | "right";
```

如果同时需要运行时列表和值派生类型，用 `as const` registry。

```ts
const directions = ["up", "down", "left", "right"] as const;

type Direction = (typeof directions)[number];

function isDirection(value: string): value is Direction {
  return directions.includes(value as Direction);
}
```

对象 registry 也一样。

```ts
const statusCode = {
  ok: 200,
  notFound: 404,
  serverError: 500,
} as const;

type StatusName = keyof typeof statusCode;
type StatusCode = (typeof statusCode)[StatusName];
```

现代 TS 代码更倾向于用 literal union、`as const` 和 `satisfies` 管理常量集合。原因不是 enum "错误"，而是它有运行时代码、type stripping 不友好、和纯 JS 生态的常量对象相比更不透明。确实需要运行时 enum 对象时再用。

## 6. Decorators、JSX 与框架类型边界 { #chapter-framework-syntax }

Decorators、JSX/TSX、Angular/Nest/TypeORM 里的反射 metadata、React/Vue/Svelte 的组件类型，都属于现代 TS 开发的一部分，但它们不是 TS 语言核心的同一层。它们会把类型系统和框架编译器、运行时约定、Babel/SWC 插件、模板编译器绑在一起。

Decorators 是真实运行时语法，不是普通类型标注。它会参与 class、method、field 的定义过程，框架还可能依赖 metadata 来做依赖注入、路由注册或 ORM 映射。学 decorators 时要把标准 decorators、旧版 experimental decorators、`emitDecoratorMetadata` 分清楚，否则很容易把不同年代的生态约定混在一起。

JSX/TSX 也类似。`<Button disabled />` 的类型检查不只来自 TypeScript，还来自 `jsx` 编译选项、框架的 JSX namespace、组件 props 类型和构建器。React typing、Vue SFC typing、Solid 的 signal/JSX 模型都应该作为框架专题来学，而不是塞进 TS 核心笔记里草草带过。

所以这里的边界很清楚：现代 TS 通识必须知道这些领域存在，知道它们会影响 compiler options 和类型推断；真正展开时应该进入对应框架笔记。TS 核心笔记负责打底，框架笔记负责解释具体运行时和编译链。
