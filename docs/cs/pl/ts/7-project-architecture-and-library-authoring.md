# 项目结构、库发布与类型级测试

<!-- Source: https://www.typescriptlang.org/docs/handbook/project-references.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/declaration-files/publishing.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html -->
<!-- Source: https://devblogs.microsoft.com/typescript/announcing-typescript-7-0-beta/ -->

!!! Abstract "Outline"

    小项目靠 `strict` 和清楚的边界已经够用；大项目、monorepo 和 npm 库还需要 project references、声明文件发布、类型级测试和稳定的模块入口来保持类型系统不会和真实包结构分叉。

    - [x] [1. 应用项目、库项目和 monorepo 的边界不同](#chapter-project-kinds)
    - [x] [2. Project references、`composite` 与 `tsc -b`](#chapter-project-references)
    - [x] [3. `.d.ts`、`exports` 与库发布表面](#chapter-library-surface)
    - [x] [4. 类型级测试检查 API 约定](#chapter-type-tests)
    - [x] [5. Lint、format、CI 与编辑器性能](#chapter-tooling-ci)
    - [x] [6. TS 7 native compiler 迁移要看什么](#chapter-tsgo)

## 1. 应用项目、库项目和 monorepo 的边界不同 { #chapter-project-kinds }

现代 TS 项目不能只问 "怎么写类型"。更实际的问题是：这个项目的输出给谁运行，类型给谁消费，模块入口由谁解析。前端应用、Node 服务、CLI、npm 库、monorepo 包的答案不同，`tsconfig` 和包结构也应该不同。

应用项目通常由 bundler 接管输出。源码可以使用别名、CSS import、worker import、环境变量注入，最后由 Vite、Webpack、Rollup、esbuild 或框架构建器生成产物。这里 `tsc --noEmit` 很常见，因为类型检查和产物生成是两条链路。

库项目要更保守。它发布给未知消费者，不能假设对方一定用同一个 bundler、同一个 Node 版本、同一套 path alias。库的类型表面要通过 `.d.ts`、`package.json exports`、`types` 字段和实际 JS 文件一起闭合。

monorepo 还多一个问题：包之间的依赖关系必须被 TypeScript、包管理器、测试工具和构建工具同时理解。只在 `tsconfig paths` 里写别名，会让编辑器看起来能跳转，但运行时或发布后不一定能加载。

```json
{
  "workspaces": ["packages/*"],
  "scripts": {
    "typecheck": "tsc -b packages/*"
  }
}
```

这里的重点不是命令长什么样，而是边界要统一：源码依赖、类型依赖、构建顺序、发布入口必须指向同一张图。

## 2. Project references、`composite` 与 `tsc -b` { #chapter-project-references }

Project references/项目引用 让一个 TS 工程拆成多个小工程。每个子项目有自己的 `tsconfig.json`，上层通过 `references` 声明依赖关系。这样 TS 能按图增量构建，也能让编辑器理解包之间的类型边界。

```json
{
  "files": [],
  "references": [
    { "path": "./packages/core" },
    { "path": "./packages/web" },
    { "path": "./packages/node" }
  ]
}
```

被引用的项目通常要开启 `composite`。它会要求项目边界更明确，并让 TypeScript 生成构建信息。

```json
{
  "compilerOptions": {
    "composite": true,
    "declaration": true,
    "declarationMap": true,
    "rootDir": "src",
    "outDir": "dist"
  },
  "include": ["src"]
}
```

`declarationMap` 对大项目很有用：用户从 `.d.ts` 跳定义时，可以回到源 `.ts`。这不是运行时功能，但会显著改善编辑体验。

普通 `tsc -p` 只编译当前项目，不会自动把依赖项目也按顺序构建。`tsc -b` 是 build mode，会查找 references、判断哪些项目过期，并按依赖顺序构建。

```bash
tsc -b
tsc -b packages/core packages/web
tsc -b --watch
tsc -b --clean
```

`tsc -b` 会把 `noEmitOnError` 当成开启状态处理，这个行为很合理：增量构建里如果一个依赖项目有类型错误还产出旧声明，下游项目会被陈旧类型误导。

Project references 的代价是配置数量增加。小项目不需要为了一点点源码拆成一堆 `tsconfig`；真正需要它的场景是 monorepo、多入口库、构建时间明显变长、或者包之间需要强边界。

## 3. `.d.ts`、`exports` 与库发布表面 { #chapter-library-surface }

库发布的核心不是 "源码类型检查通过"，而是 **消费者看到的类型表面** 是否和实际 JS 入口一致。`declaration: true` 会生成 `.d.ts`，但 `.d.ts` 只是产物；包入口仍然要由 `package.json` 正确声明。

```json
{
  "name": "@scope/math-tools",
  "type": "module",
  "exports": {
    ".": {
      "types": "./dist/index.d.ts",
      "import": "./dist/index.js"
    },
    "./extra": {
      "types": "./dist/extra.d.ts",
      "import": "./dist/extra.js"
    }
  },
  "files": ["dist"]
}
```

这个结构把运行时入口和类型入口放在一起。消费者 import `"@scope/math-tools"` 时，Node/bundler 找到 JS，TypeScript 找到对应 `.d.ts`。如果只写 `"types": "./dist/index.d.ts"`，但 `exports` 又把入口藏起来，某些解析模式下类型可能不可见。

公共类型不要泄露内部路径。下面这种类型表面很脆：

```ts
export type { InternalConfig } from "./internal/config";
```

一旦内部目录重构，消费者的类型导入就会坏。更稳的做法是把真正想公开的协议集中从 public entry 导出，内部类型保持内部。

```ts
export interface ClientOptions {
  endpoint: string;
  timeoutMs?: number;
}
```

库还要避免把太宽的类型写进 public API。`any`、`object`、裸 `Function`、过宽的 `Record<string, unknown>` 都会把不确定性推给消费者。公共 API 的类型应该描述可用成员和错误边界；内部实现可以更灵活。

## 4. 类型级测试检查 API 约定 { #chapter-type-tests }

单元测试验证运行时行为，类型级测试验证 public API 的静态约定。库项目尤其需要它，因为一次小改动可能没有改变 JS 结果，却改变了用户看到的推断类型。

最直接的方式是写 `tsc --noEmit` 能检查的测试文件，让应该通过的用例通过，让应该报错的地方加 `@ts-expect-error`。

```ts
import { defineRoutes } from "../src";

const routes = defineRoutes({
  getUser: { method: "GET", path: "/users/:id" },
});

type RouteName = keyof typeof routes;

const name: RouteName = "getUser";

// @ts-expect-error unknown route
const badName: RouteName = "missing";
```

`@ts-expect-error` 比 `@ts-ignore` 更适合测试。它要求下一行真的有类型错误；如果未来错误消失，测试会反过来失败。这样能防止某个 API 不小心变宽。

也可以用 `expect-type`、`tsd` 这类工具写更明确的断言。核心目标一样：检查返回类型、泛型推断、literal 保留、错误分支是否符合预期。

```ts
import { expectTypeOf } from "expect-type";

const route = routes.getUser;

expectTypeOf(route.method).toEqualTypeOf<"GET">();
```

类型级测试不应该替代运行时测试。`z.infer` 推出来的类型对了，不代表 schema 的运行时错误格式、默认值、transform 行为也对。静态约定和运行时行为是两条测试线。

## 5. Lint、format、CI 与编辑器性能 { #chapter-tooling-ci }

TypeScript compiler 负责类型正确性，不负责所有代码质量。`typescript-eslint` 能检查一部分类型系统外的问题，例如浮动 Promise、误用 `any`、不安全赋值、无意义条件。Prettier 或项目格式器负责风格统一，别把格式争论塞进类型检查。

CI 里至少要把类型检查、lint、测试、构建分开跑。分开不是为了仪式感，而是为了失败时能定位：类型关系坏了、代码风格坏了、运行时行为坏了、还是构建产物坏了。

```json
{
  "scripts": {
    "typecheck": "tsc -b",
    "lint": "eslint .",
    "test": "vitest run",
    "build": "rollup -c"
  }
}
```

大项目还要考虑编辑器性能。Project references 可以减少单个 TS program 的体积，但配置错了会让编辑器反复生成中间声明或加载过多文件。`include` 不要写得过宽，生成目录和测试 fixture 要排除，solution `tsconfig` 可以只放 `references` 和空 `files`。

```json
{
  "files": [],
  "references": [{ "path": "./packages/core" }]
}
```

这类配置不直接改变代码语义，却会决定团队每天写代码时的反馈速度。类型系统再强，如果编辑器补全和检查慢到不可用，工程上也算失败。

## 6. TS 7 native compiler 迁移要看什么 { #chapter-tsgo }

TypeScript 7 的重点不是给日常写法增加一堆新语法，而是 native compiler 带来的性能和架构变化。`tsgo` / native preview 的目标是让大型项目的类型检查、编辑器响应和构建反馈更快。

这类迁移最需要关注的是 **类型错误是否变化**、**声明文件输出是否稳定**、**工具链插件是否兼容**。TS 6.0 里出现的 `stableTypeOrdering` 就是为 6 到 7 的迁移噪音服务的：并行和 native 实现会改变内部类型排序，声明输出可能出现顺序差异。

对普通项目来说，不需要提前把笔记写成 TS 7 专题。更实用的做法是把现有工程边界打干净：少依赖陈旧 `moduleResolution: "node"`，减少隐式 `any`，公共 API 有类型级测试，声明产物可重复生成。这样迁移到新编译器时，真正的问题会浮出来，而不是被一堆历史配置噪音淹掉。

现代 TS 开发的长期方向很清楚：类型检查更快，模块解析更贴近真实运行时，纯类型语法更容易被直接擦除，库的 public API 更依赖声明文件和类型级测试。语言核心只是第一层，工程边界才决定它在真实项目里靠不靠谱。
