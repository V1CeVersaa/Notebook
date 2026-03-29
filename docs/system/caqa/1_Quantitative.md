# Fundamentals of Quantitative Design and Analysis

## Classes of Computer Systems

Flynn 分类法：按照指令流和数据流，分为四种类型：SISD/单指令流单数据流，SIMD/单指令流多数据流，MISD/多指令流单数据流，MIMD/多指令流多数据流。

<img class="center-picture" src="./assets/1 quantitative/1.webp" alt="drawing" width="550" />

需要注意以下几点：

- 其中 SIMD 的最典型运算就是向量运算，也是我们在体系结构课程中重点讨论的。
- 市面上基本没有 MISD 这种处理器。

## Measures of Performance

- Response time/Elapsed time：总的响应时间包含所有方面的时间，比如处理时间、I/O、Overhead 与空闲时间；
- Execution time/CPU Time：Time spent processing a given time。
    - 用户 CPU 时间：程序本身执行的时间；
    - 系统 CPU 时间：操作系统花费的时间。
- Performance：$\mathrm{Performance} = 1 / \mathrm{Execution\ Time}$。
- CPU Performance：$\mathrm{CPU\ Execution\ Time} = \mathrm{CPU\ Clock\ Cycles} \times \mathrm{Clock\ Period} = \mathrm{CPU\ Clock\ Cycles} / \mathrm{Clock\ Rate}$。
- Average Cycles per Instruction：$\mathrm{CPI} = \mathrm{CPU\ Clock\ Cycles} / \mathrm{Instruction\ Count}$。

显然，CPU 时间可以通过减少 CPU 周期数、提升时钟频率来提升，设计的时候需要权衡。更详细一些，整体的性能取决于下面四个因素：

- 算法：影响 IC ，可能影响 CPI；
- 编程语言：影响 IC 和 CPI；
- 编译器：影响 IC 和 CPI；
- ISA：影响 IC、CPI、$T_c$。

Amdahl's Law，有两个重要概念：改进部分所占的比例 $\mathrm{Fraction}_{\mathrm{enhanced}}$ 和改进部分带来的加速比 $\mathrm{Speedup}_{\mathrm{enhanced}}$，其可以完全改写下面的公式：

- $\mathrm{Improved\ Execution\ Time} = \mathrm{Affected\ Execution\ Time}/\mathrm{Amount\ of\ Improvement}$ + $\mathrm{Unaffected\ Execution\ Time}$。
- $\mathrm{Speedup} = \mathrm{Performance\ of\ entire\ task}_{\mathrm{old}} / \mathrm{Performance\ of\ entire\ task}_{\mathrm{new}}$。
- $\mathrm{Execution\ Time}_{\mathrm{new}} = \mathrm{Execution\ Time}_{\mathrm{old}} \times \left[(1 - \mathrm{Fraction}_{\mathrm{enhanced}}) + \mathrm{Fraction}_{\mathrm{enhanced}} / \mathrm{Speedup}_{\mathrm{enhanced}}\right]$。

推论之一为：$\mathrm{Speedup} \leq 1 / (1 - \mathrm{Fraction}_{\mathrm{enhanced}})$。

## Great Architecture Ideas

- Design for Moore's Law；
    - 摩尔定律：集成电路上可容纳的晶体管数目，大约每 18 到 24 个月翻一倍。
- Use abstraction to simplify design；
- Make the common case fast；
- Performance via parallelism；
- Performance via prediction；
- Performance via pipelining；
- Use a hierarchy of memories‘
- Improve dependability via rebundancy。


