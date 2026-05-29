# JS/TS 插件工具链

<!-- Source: https://code.visualstudio.com/api/get-started/extension-anatomy -->
<!-- Source: https://code.visualstudio.com/api/references/extension-manifest -->
<!-- Source: https://code.visualstudio.com/api/working-with-extensions/bundling-extension -->
<!-- Source: https://code.visualstudio.com/api/extension-guides/web-extensions -->
<!-- Source: https://code.visualstudio.com/api/working-with-extensions/testing-extension -->
<!-- Source: https://code.visualstudio.com/api/working-with-extensions/publishing-extension -->

!!! Abstract "Outline"

    VSCode 插件的工具链要回答同一个问题：源码如何变成 extension host 能加载的文件，哪些错误在本机和 CI 里被拦住，发布产物又如何声明自己依赖的 VSCode API 版本。

    - [x] [1. `package.json` 是插件的 manifest](#chapter-toolchain-package-json)
    - [x] [2. Runtime、package manager 与 scripts](#chapter-toolchain-runtime-scripts)
    - [x] [3. Type check、transpile 与 source map](#chapter-toolchain-compile)
    - [x] [4. Lint、format 与代码约束](#chapter-toolchain-lint-format)
    - [x] [5. Bundler、desktop extension 与 web extension](#chapter-toolchain-bundler)
    - [x] [6. 测试、调试与发布](#chapter-toolchain-test-release)

## 1. `package.json` 是插件的 manifest { #chapter-toolchain-package-json }

普通 Node 包里的 `package.json` 主要描述包名、入口、依赖和脚本。VSCode 插件的 `package.json` 还承担 extension manifest 的角色：它告诉 VSCode 这个插件叫什么、支持哪个 VSCode API 版本、何时激活、暴露哪些 contribution point，以及激活后应该加载哪个 JS 文件。

```json
{
  "name": "note-tools",
  "publisher": "v1ceversa",
  "version": "0.0.1",
  "engines": {
    "vscode": "^1.92.0"
  },
  "activationEvents": [],
  "main": "./dist/extension.js",
  "contributes": {
    "commands": [
      {
        "command": "noteTools.refresh",
        "title": "Refresh Notes"
      }
    ]
  },
  "scripts": {
    "compile": "npm run check && node esbuild.js",
    "watch": "node esbuild.js --watch",
    "test": "vscode-test",
    "vscode:prepublish": "npm run package",
    "package": "npm run check && node esbuild.js --production"
  }
}
```

`engines.vscode` 是 API 兼容边界。它会约束用户能否安装这个插件：你调用的新 VSCode API、`@types/vscode` 的版本、测试用的 VSCode 版本和发布声明都应该对齐。把它设得太低，用户可能在旧 VSCode 里装上一个实际跑不起来的插件；设得太高，又会挡住仍可支持的用户。

`main` 指向 desktop extension host 加载的入口文件。web extension 用 `browser` 指向浏览器 worker 环境下的入口；同一个插件如果同时支持 desktop 和 web，可以同时声明 `main` 和 `browser`，但源码里要隔离 Node-only API。`activationEvents` 决定什么时候加载插件，`contributes` 是静态声明，例如 commands、configuration、languages、grammars、views。`contributes.commands` 让命令出现在 VSCode 里，运行时代码还要在 `activate` 里用 `vscode.commands.registerCommand` 绑定。

```js
function activate(context) {
  const disposable = vscode.commands.registerCommand("noteTools.refresh", run);
  context.subscriptions.push(disposable);
}

module.exports = { activate };
```

manifest 的静态声明和运行时代码要用同一个 command id。这个字符串错一次，常见症状不是编译失败；更麻烦的是命令能看到但执行不了，或者代码注册了一个没人触发的命令。

## 2. Runtime、package manager 与 scripts { #chapter-toolchain-runtime-scripts }

工具链里至少有两层 runtime。开发阶段的 Node 负责跑 package manager、编译脚本、测试 runner 和 bundler；插件运行阶段的 extension host 负责加载 `main` 或 `browser` 指向的产物。两者版本可能不同。你在本机 Node 里能用某个 JS API，不代表目标 VSCode extension host 一定能用。

Package manager 解决依赖安装和命令分发。npm、pnpm、Yarn 都可以，关键是项目里要有一个清楚的选择：提交对应 lockfile，最好在 `package.json` 里写 `packageManager`，CI 和同伴机器都按同一种解析结果安装。插件开发里 dependency drift 很烦，因为打包产物可能把库代码直接带进去，lockfile 变动会改变 `.vsix` 内容。

`scripts` 是工具链的公共接口。真实构建命令应该放在这里，而不是散落在 README 或个人 shell history 里。`npm run compile`、`npm run watch`、`npm test`、`npm run package` 应该足够表达本地开发、测试和发布前构建。

```json
{
  "packageManager": "pnpm@10.0.0",
  "scripts": {
    "check": "tsc -p tsconfig.json --noEmit",
    "lint": "eslint src",
    "format": "prettier --check .",
    "compile": "npm run check && node esbuild.js",
    "watch": "node esbuild.js --watch",
    "test": "vitest run && vscode-test"
  }
}
```

`npm run` 会优先使用项目本地 `node_modules/.bin` 里的命令，这比依赖全局安装可靠。`vsce` 这类发布工具也可以放在 devDependencies 里，通过 `npm exec vsce package` 或脚本调用，避免“我的全局 vsce 版本和 CI 不一样”。

## 3. Type check、transpile 与 source map { #chapter-toolchain-compile }

JS 插件也可以用类型检查。最轻的做法是在 JS 文件里开启 `// @ts-check`，配合 JSDoc 和 `jsconfig.json`；更常见的是直接写 TS，编译成 JS。两条路线最后都要面对同一个事实：VSCode 加载的是 JavaScript，TypeScript 类型在运行时不存在。

```js
// @ts-check

/**
 * @param {import("vscode").ExtensionContext} context
 */
function activate(context) {
  // ...
}
```

Transpile 只是把源码语法变成目标 runtime 接受的 JS。Type check 是证明类型关系。Bundler 可以顺手处理 TS 文件，但很多 bundler 只擦掉类型，不做完整类型检查。VSCode 官方 bundling 文档也采用 `esbuild` 加 `tsc --noEmit` 的分工：一个负责快的输出，一个负责真的类型检查。

```json
{
  "scripts": {
    "check": "tsc -p tsconfig.json --noEmit",
    "compile": "npm run check && node esbuild.js"
  }
}
```

Source map 决定调试体验。源码在 `src/extension.ts`，运行时代码在 `dist/extension.js`，断点要能从运行时代码映射回源码。调试时断点不命中，先检查 `outFiles`、`sourceMap`、bundler sourcemap、`main` 入口和实际输出路径是否指向同一套产物。这里没有玄学，路径对不上就调不动。

更细的 TS module、`tsconfig` 和 `moduleResolution` 边界已经放在 [Modules、`tsconfig` 与构建边界](../ts/4-modules-tsconfig-and-build-boundaries.md) 里。JS 侧只要记住一件事：编译配置不是类型系统内部事务，它会改变 extension host 实际加载的文件形状。

## 4. Lint、format 与代码约束 { #chapter-toolchain-lint-format }

Formatter 负责排版一致，linter 负责代码约束。Prettier 基本只管格式，ESLint 管语义规则、潜在 bug 和团队约定；Biome 把 formatter 和 linter 做进同一个快工具里，但规则生态和 TypeScript type-aware 检查的深度要按项目需要评估。

插件工程里，lint 最有价值的规则通常和异步、模块、资源释放有关：没有等待的 Promise、错误吞掉后继续成功、未使用 import、Node-only 模块误进 web entry、`any` 或 `unknown` 边界被粗暴断言。纯风格规则不应该盖过这些真实风险。

```json
{
  "scripts": {
    "lint": "eslint src",
    "format": "prettier --check .",
    "format:write": "prettier --write ."
  }
}
```

格式化可以在保存时自动跑，lint 更适合进 CI。type-aware ESLint 会读取 TS project，精度更高，也更慢。小插件可以先用普通 ESLint 加 `tsc --noEmit`；等异步边界、unsafe call、floating promise 这类问题开始变多，再引入 type-aware 规则。

## 5. Bundler、desktop extension 与 web extension { #chapter-toolchain-bundler }

Bundling 同样会影响 VSCode 插件。插件也有模块图、依赖体积、冷启动路径和目标 runtime。desktop extension 运行在 Node 风格 extension host 里，包太散会增加安装体积和加载路径复杂度；web extension 运行在 browser worker 环境里，不能依赖 Node 的模块加载和核心库，通常必须打成 web-friendly bundle。

`vscode` 模块由 VSCode runtime 提供，打包时应该 external 掉。把它打进 bundle 是错误方向；真实运行时没有 npm 上的 `vscode` 实现，只有 extension host 提供的 API bridge。

```js
const esbuild = require("esbuild");

esbuild.build({
  entryPoints: ["src/extension.ts"],
  bundle: true,
  format: "cjs",
  platform: "node",
  sourcemap: true,
  outfile: "dist/extension.js",
  external: ["vscode"],
});
```

Desktop entry 常见输出是 CommonJS，因为 VSCode 的示例和很多插件仍以 `module.exports = { activate }` 这条路径为主。ESM 也可以做，但要让 `package.json` 的 `"type"`、输出格式、文件扩展名和 VSCode 加载规则完全一致。模块系统笔记里讲过的 ESM/CJS 边界，在插件入口这里会直接变成能不能激活。

Web extension 的 `browser` 入口运行在 web extension host。它能用 VSCode API，但不能直接用 `node:fs`、`child_process`、`path` 这类 Node API；文件访问要走 `vscode.workspace.fs`，网络访问要考虑 `fetch` 和 CORS。官方文档也明确说 web extension 的 main file 不能像 Node 那样继续 `require` 其他模块，所以 bundle 往往是必需品。

同一个源码同时支持 desktop 和 web 时，平台差异要在 entry point 或 adapter 层隔离。

```txt
src/extension-node.ts   -> dist/node/extension.js   -> package.json main
src/extension-web.ts    -> dist/web/extension.js    -> package.json browser
src/core/               -> shared pure logic
```

共享层尽量不碰 Node API 和 VSCode UI；平台层负责文件系统、进程、网络、storage、telemetry 和 activation glue。这样单测可以集中测 `src/core`，集成测试再分别覆盖 node/web entry。

## 6. 测试、调试与发布 { #chapter-toolchain-test-release }

插件测试分两层。纯函数、parser、配置合并、路径转换、协议消息处理，可以用 Vitest、Jest 或 Node 自带 test runner 跑普通单测。这些测试快，适合覆盖大量边界。依赖 VSCode API 的命令、provider、webview、workspace 行为，需要在 Extension Development Host 或 web extension host 里跑集成测试。

VSCode 官方测试链路现在以 `@vscode/test-cli`、`@vscode/test-electron` 和 `@vscode/test-web` 为主。desktop 集成测试会下载或启动 VSCode，把当前目录作为 extensionDevelopmentPath，再执行测试入口。web extension 测试要跑在 browser 形态的 VSCode 里，能暴露 Node API 误用、bundle 缺口和虚拟文件系统问题。

```json
{
  "devDependencies": {
    "@vscode/test-cli": "^0.0.10",
    "@vscode/test-electron": "^2.0.0",
    "@vscode/test-web": "^0.0.70",
    "vitest": "^3.0.0"
  },
  "scripts": {
    "test:unit": "vitest run",
    "test:desktop": "vscode-test",
    "test:web": "vscode-test-web --extensionDevelopmentPath=. .",
    "test": "npm run test:unit && npm run test:desktop"
  }
}
```

调试配置本质上也是工具链的一部分。`launch.json` 启动 Extension Development Host，`tasks.json` 在启动前跑 watch 或 compile，source map 把断点映射回源码。调试失败时先看构建任务是否真的更新了 `dist/`，再看 manifest 入口是否指向这个 `dist/`。

发布用 `vsce package` 生成 `.vsix`，用 `vsce publish` 发布到 Marketplace。`.vsix` 是最终安装产物，适合本地检查和离线安装；publish 前要确认 README、LICENSE、icon、repository、`.vscodeignore`、bundle 输出和 `engines.vscode` 都是有意为之。`.vscodeignore` 容易漏：测试夹具、源码 map、未打包源码、截图和大文件都可能把扩展包撑大。

```bash
npm run package
npm exec vsce package
npm exec vsce publish
```

`vscode:prepublish` 会在 VSCode 扩展发布流程中被调用，适合挂 production build。发布命令应该重新生成 production 产物，而不是复用还在 watch 的开发输出；本地能跑但 CI 没跑过测试的 bundle 也不应该发布。插件工程的闭环很朴素：manifest 指向产物，产物来自脚本，脚本跑过检查，检查覆盖目标 runtime。
