# Chapter 1: 预备知识

## 2. 重要不等式

「Hoeffding 不等式」：对 $m$ 个独立随机变量 $X_i \in [0, 1]$，$i \in \{1, 2, \ldots, m\}$，令 $\bar{X} = \frac{1}{m} \sum_{i=1}^m X_i$，则对任意 $\epsilon > 0$，有

$$\begin{aligned}
P(\bar{X} \geq E[\bar{X}] + \epsilon) &\leq e^{-2m\epsilon^2}, \\ 
P(\bar{X} \leq E[\bar{X}] - \epsilon) &\leq e^{-2m\epsilon^2}. 
\end{aligned}$$
