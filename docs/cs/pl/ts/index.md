# TypeScript

!!! info

    TypeScript 给 JavaScript 加上一层可擦除的静态类型检查。现代 TS 开发的核心不是把所有东西都类型化，而是把 **静态类型、运行时边界、模块解析、构建链和包发布** 放在同一个工程模型里理解。

## Table of Contents

- [x] [Type Checker 与日常类型](./1-type-checker-and-everyday-types.md)
- [x] [控制流收窄、函数与对象类型](./2-narrowing-functions-and-object-types.md)
- [x] [Generics 与类型级派生](./3-generics-and-type-manipulation.md)
- [x] [Modules、`tsconfig` 与构建边界](./4-modules-tsconfig-and-build-boundaries.md)
- [x] [运行时边界、Schema Validation 与断言函数](./5-runtime-boundaries-and-validation.md)
- [x] [现代语法、资源管理与可擦除 TypeScript](./6-modern-syntax-and-erasable-typescript.md)
- [x] [项目结构、库发布与类型级测试](./7-project-architecture-and-library-authoring.md)

## Introduction

TypeScript 要和 JavaScript 放在一起理解：运行时仍然是 JS，类型系统只在开发期工作。对已经会现代语言的人来说，TS 需要重点补的是 **structural typing**、**control-flow narrowing**、**generic constraints**、**type manipulation**、**runtime validation** 和 **compiler configuration**。这些机制决定了一个前端应用、Node 服务、CLI、库包或 monorepo 能不能被 IDE、编译器、测试和运行时同时读懂。
