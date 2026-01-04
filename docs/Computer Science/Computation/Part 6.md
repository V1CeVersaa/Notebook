# Part 6: Computational Complexity

!!! Info "Outline"

    - 形式化定义运行时间、复杂度类 $\mathbf{P}$、$\mathbf{EXP}$；
    - 我们证明了使用图灵机计算函数的时间与使用 RAM 机器/NAND-RAM 程序计算的时间在多项式意义上是相关的，实现了双向的模拟；
    - 我们给出了一个高效的通用 NAND-RAM 程序，并用它来建立时间层次定理，表明 $\mathbf{P} \subsetneq \mathbf{EXP}$，如果允许使用更多资源，则可以解决更多的问题；
    - 表明复杂度大小并非均匀的，证明 $\mathbf{P} \subsetneq \mathbf{P}_{/\text{poly}}$，并且 $\mathbf{P}_{/\text{poly}}$ 包含不可计算的问题。

## 1. Defining Running Time


