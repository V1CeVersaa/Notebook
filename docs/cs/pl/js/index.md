# JavaScript

!!! info

    JavaScript 的语言层由动态类型、对象引用、词法闭包、prototype、module graph、event loop 和 Promise 共同决定。写 VSCode 插件时，这些机制会直接落到 extension host 的加载、异步取消、资源释放和打包边界上。

## Table of Contents

- [x] [语言核心与代码质量](./1-language-core.md)
- [x] [对象、引用与内置数据结构](./2-objects-and-data.md)
- [x] [函数对象、闭包与运行时边界](./3-functions-runtime.md)
- [x] [属性描述符、原型与 Class](./4-object-model.md)
- [x] [错误处理、Promise 与 async/await](./5-errors-and-async.md)
- [x] [Generators 与高级迭代](./6-generators-iteration.md)
- [x] [Modules、静态导入与动态加载](./7-modules.md)
- [x] [Proxy、Eval 与运行时边缘机制](./8-miscellaneous-runtime.md)
- [x] [JS/TS 插件工具链](./9-toolchain.md)

## Introduction

这组内容把 JS 当成插件工程的运行时语言来读：语法只保留必要边界，重点放在值语义、对象模型、模块加载、异步恢复点和工程链路。ES modules、CommonJS、`package.json`、bundler、test runner 与 publisher 不是外部杂项，它们共同决定源码能否被 VSCode extension host 正确加载。
