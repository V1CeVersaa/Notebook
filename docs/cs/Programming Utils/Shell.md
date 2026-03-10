# Bourne-Again Shell

!!! Abstract

    我有时候使用 Bash 编写一部分脚本用于训练模型，本笔记参考 [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/bash.html)。

## Basics

Bash 是 GNU 操作系统的 shell，或者称其为命令语言解释器，是当前 Unix shell `sh` 的直接前身，很大程度和 `sh` 兼容，融合了 `ksh` 和 `csh` 的使用功能，旨在成为 IEEE POSIX 规范的符合式实现。

根本来讲，shell 是一个执行命令的**宏处理器/Macro Processor**，将文本和符号扩展以创建更大表达式。

## Definitions

- **Control Operator**：执行控制功能的 token，是空行或者是以下之一的字符：`||`、`&&`、`&`、`;`、`;;`、`;&`、`;;&`、`|`、`|&`、`(`、`)`。
- **Exit Status**：命令返回给调用者的值，被限制为八位，为 `0` 到 `255` 的整数。
