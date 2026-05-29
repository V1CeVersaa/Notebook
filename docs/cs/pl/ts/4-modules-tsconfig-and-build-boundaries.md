# Modules、`tsconfig` 与构建边界

<!-- Source: https://www.typescriptlang.org/docs/handbook/2/modules.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/modules/theory.html -->
<!-- Source: https://www.typescriptlang.org/tsconfig/ -->
<!-- Source: https://www.typescriptlang.org/tsconfig/moduleResolution.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-5-0.html -->
<!-- Source: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-6-0.html -->

!!! Abstract "Outline"

    TypeScript 工程化要把类型系统、模块系统、编译输出和运行时加载规则放在一起看；`tsconfig.json` 决定 TS 怎么理解项目，也决定输出 JS 能不能被 Node、浏览器、bundler 或测试工具正确加载。

    - [x] [1. TS modules、ESM/CJS 与 type-only import](#chapter-modules)
    - [x] [2. `.d.ts`、ambient declaration 与 `@types`](#chapter-declarations)
    - [x] [3. `tsconfig.json` 的现代基线](#chapter-tsconfig)
    - [x] [4. `moduleResolution`、NodeNext 与 bundler](#chapter-module-resolution)
    - [x] [5. `tsc`、bundler 与运行时加载](#chapter-build-boundary)
    - [x] [6. 编译、调试与严格性迁移](#chapter-workflow)

## 1. TS modules、ESM/CJS 与 type-only import { #chapter-modules }

TypeScript 复用 JavaScript module 语法。`import` 和 `export` 的运行时语义取决于编译输出和宿主加载规则：输出成 ESM 时走 ES module，输出成 CommonJS 时会变成 `require` / `exports` 形态。TS 类型不会改变模块运行时。

```ts
import { createServer } from "node:http";
import { createRouter } from "./router";

export function start() {
  const router = createRouter();
  const server = createServer(router.handle);
  server.listen(3000);
}
```

`module` 选项决定输出模块格式，`moduleResolution` 决定 TS 如何根据 import specifier 找到类型和源码。Node 生态正在从 CommonJS 过渡到 ESM，前端项目又经常交给 bundler 处理模块图。这里不能凭感觉改配置；运行时怎么加载，TS 就要按对应模式解析。

TS 还提供 type-only import/export。它只用于类型位置，编译后不会生成运行时导入。

```ts
import type { RequestHandler } from "./types";
import { createRouter } from "./router";

export function attach(handler: RequestHandler) {
  return createRouter().use(handler);
}
```

这能避免把纯类型依赖误带进运行时，也能让读代码的人立刻知道哪些 import 只服务于类型检查。TS 5 以后，显式区分 type import 会更直观，配合 `verbatimModuleSyntax` 这类选项时尤其明显。

不要误以为 `import type` 可以替代真实依赖。如果函数体里要调用 `createRouter()`，就必须有运行时 import。类型和值在 TS 源码里共用名字空间的一部分语法，但编译后只有值会存在。

```ts
import type * as routerTypes from "./router";

// routerTypes.createRouter();
// type-only namespace cannot be used as a runtime value
```

这和 "类型擦除" 是同一个原则在模块系统里的表现。

## 2. `.d.ts`、ambient declaration 与 `@types` { #chapter-declarations }

Declaration file/声明文件 `.d.ts` 描述已有 JS 模块或全局变量的类型，不提供实现。它让 TS 能理解运行时已经存在的 API。

```ts
declare module "legacy-parser" {
  export function parse(input: string): unknown;
}
```

这段声明只告诉编译器：有一个模块叫 `"legacy-parser"`，它导出 `parse`。运行时能不能 `require` 或 `import` 到这个模块，取决于依赖是否安装、打包器是否处理、宿主环境是否支持。

Ambient declaration/环境声明 用 `declare` 表示 "这个东西在运行时由外部提供"。全局变量也可以声明。

```ts
declare const runtimeBridge: {
  postMessage(message: unknown): void;
};
```

浏览器注入的全局变量、宿主环境提供的 bridge、测试环境里的 mock global 都常见这种模式：运行时有这个值，TS 源码里没有实现。声明应该尽量窄，只描述实际使用的形状，别为了省事写成 `any`。

`@types/*` 是 DefinitelyTyped 生态里的类型包。很多 JS 库没有内置 TS 类型，就通过 `@types/library-name` 提供声明。Node 项目常见 `@types/node`，测试项目常见 `@types/jest` 或测试框架自己的内置类型。

```json
{
  "devDependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^6.0.0"
  }
}
```

类型包版本应该和真实运行时相匹配。目标 Node 版本越低，可用 API 越少；DOM lib、Node lib、测试框架类型如果混在一起，也可能让你调用到运行时没有的成员。类型通过了，不代表目标环境一定有这个 API。

## 3. `tsconfig.json` 的现代基线 { #chapter-tsconfig }

`tsconfig.json` 是 TS 项目的边界文件。没有它时，单文件编译很容易看漏项目级选项；有它时，`tsc -p .` 会按项目配置检查和输出。

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "preserve",
    "moduleResolution": "bundler",
    "lib": ["ES2022", "DOM"],
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "verbatimModuleSyntax": true,
    "noEmit": true
  },
  "include": ["src"]
}
```

`target` 决定输出 JS 使用到哪个 ECMAScript 版本的语法。目标环境越新，输出越接近源码；目标环境越旧，TS 会降级部分语法。现代前端和 Node 项目不应该盲目设成很旧的 target；真正要支持旧浏览器时，通常还要把 bundler、Babel 或 SWC 的转译目标一起配置清楚。

`lib` 决定类型检查时可见的标准库声明。Node 服务不应该默认依赖 DOM 类型，浏览器应用才需要 DOM lib。很多 "为什么 `document` 有类型但运行时没有" 的问题，根源就是 lib 和运行环境混了。

`strict` 是新项目默认该打开的总开关。它会开启一组严格规则，让 `any`、空值、函数类型等边界更早暴露。`noUncheckedIndexedAccess` 和 `exactOptionalPropertyTypes` 不只是洁癖，它们会把数组索引、字典访问和 optional property 的真实风险推到类型层。

`verbatimModuleSyntax` 的意义是让 import/export 更接近源码本意：类型导入就写 `import type`，值导入就保留为运行时导入。它减少了 import elision 带来的猜测，尤其适合 ESM、bundler 和 type stripping 工作流。

## 4. `moduleResolution`、NodeNext 与 bundler { #chapter-module-resolution }

`moduleResolution` 是现代 TS 项目最容易配错的选项之一。老的 `"node"` 现在实际对应 Node 10 前后的 CommonJS 解析模型；现代代码通常在 `"bundler"`、`"node16"`、`"nodenext"` 之间选。

`"bundler"` 模拟 Vite、esbuild、Webpack、Rollup、Parcel 这类工具的混合解析规则。它支持 `package.json` 的 `"imports"` / `"exports"`，但不像 Node ESM 那样强制相对导入写文件扩展名。

```json
{
  "compilerOptions": {
    "module": "preserve",
    "moduleResolution": "bundler",
    "noEmit": true
  }
}
```

这适合前端应用、Bun 应用、由 bundler 接管输出的库内部开发。它不一定适合直接发布给 npm 的库，因为 bundler 可能替你吞掉一些真实 Node 用户会遇到的解析问题。

`"nodenext"` 更像是在告诉 TS：源码最终就要按 Node 的 ESM/CJS 规则运行。它会更严格地对待扩展名、`package.json` 的 `"type"`、`.mts` / `.cts`、条件 exports。写 Node 服务、CLI 或发布 npm 库时，这个严格性反而是好事。

```json
{
  "type": "module",
  "compilerOptions": {
    "module": "nodenext",
    "moduleResolution": "nodenext",
    "declaration": true,
    "outDir": "dist"
  }
}
```

路径别名也要小心。`tsconfig` 的 `paths` 只教 TypeScript 怎么解析类型，不会自动教 Node 怎么加载。现代 Node 项目更推荐用 `package.json` 的 `"imports"` 建内部别名；前端项目则让 bundler alias、TS `paths` 和测试工具 alias 三者保持一致。

```json
{
  "imports": {
    "#/*": "./dist/*"
  },
  "compilerOptions": {
    "moduleResolution": "nodenext"
  }
}
```

TypeScript 6.0 开始支持 `#/` 形式的 subpath imports。这个方向很明确：少用只在编译器里存在的 `baseUrl` 幻觉，多用运行时和类型检查器都能理解的模块边界。

## 5. `tsc`、bundler 与运行时加载 { #chapter-build-boundary }

Bundling/打包器 的作用是把模块图整理成发布产物，减少文件数量、裁剪依赖、处理 ESM/CJS 差异，有时也负责 CSS、图片、worker、WASM、polyfill 和平台替换。`tsc` 和 bundler 分工不同：`tsc` 做类型检查和基础 emit，bundler 处理模块图和资源。

前端应用常见配置是 `tsc --noEmit` 加 `vite build`。这时类型检查和代码输出是两条链路：`tsc` 负责证明类型关系，Vite/esbuild/Rollup 负责生成浏览器能加载的 JS、CSS 和资产。

```json
{
  "scripts": {
    "typecheck": "tsc -p tsconfig.json --noEmit",
    "build": "vite build",
    "test": "vitest run"
  }
}
```

Node 服务或 CLI 可以选择直接由 TS-aware 运行时执行源码，也可以先编译到 `dist/`。两者的约束不同：直接运行 TypeScript 时，运行时通常只支持可擦除语法；先编译时，TS-only runtime syntax 由编译器降级输出。

静态 import 会进入初始模块图。冷门命令、可选语言服务、只在特定条件里使用的重依赖，可以考虑 dynamic import。

```ts
export async function runOptionalTask() {
  const { run } = await import("./heavy-task.js");
  await run();
}
```

这和 JS module 笔记里的结论一致：dynamic import 把加载成本推迟到运行时，也把错误处理推迟到运行时。用户可见路径要捕获并报告失败，不能让 import rejection 变成沉默错误。

不同运行环境的类型也要隔离。Node-only 文件可以引用 `node:fs`，浏览器文件不能因为 `@types/node` 在项目里就默认有文件系统。

```ts
// Node runtime only
import { readFile } from "node:fs/promises";
```

如果同一个包同时提供 Node 和 browser 入口，应该用条件 exports、bundler alias 或独立 entry point 隔离平台相关代码。不要在共享模块顶层静态 import Node-only 依赖，否则即使某条路径不会在浏览器里执行，打包或加载阶段也可能失败。

## 6. 编译、调试与严格性迁移 { #chapter-workflow }

日常开发一般有三条命令：类型检查、测试和构建。它们可以共享 `tsconfig`，但不应该互相假装已经覆盖全部风险。

```bash
npm run typecheck
npm test
npm run build
```

watch 模式适合配合浏览器、Node inspector 或测试 runner 调试。TS 输出 JS 和 source map 后，调试器能把断点映射回 `.ts`。如果断点不命中，先检查 `outDir`、`sourceMap`、`package.json exports/main`、bundler sourcemap 和 launch 配置是否指向同一套产物。

严格性迁移不要一口气靠 `as any` 压掉错误。更稳的顺序是先开 `strict`，把外部边界标成 `unknown`，给配置和 message protocol 建 discriminated union，再逐步打开 `noUncheckedIndexedAccess`、`exactOptionalPropertyTypes` 这类更尖锐的检查。`any` 可以作为临时迁移标记，但应该局部、可搜索、能删除。

```ts
function parseMessage(payload: unknown): ClientMessage | undefined {
  if (
    typeof payload === "object" &&
    payload !== null &&
    "type" in payload
  ) {
    return payload as ClientMessage;
  }

  return undefined;
}
```

这段还不够严格，因为最后仍然用了断言。更完整的实现应该继续检查每个 message 分支的 payload。现实项目里可以分层推进：先把 `unknown` 边界建立起来，再用手写 guard 或 schema validator 逐步替换粗断言。

发布前至少要保证 `tsc -p .` 成功、测试跑的是最新输出、`dist/` 没有陈旧产物误导调试。TS 帮你看见类型层的问题，但工程链路还需要自己闭合：源码、编译输出、打包产物和 `package.json` 入口必须指向同一件东西。
