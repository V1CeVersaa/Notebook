# Chapter 1-2

## Knowledge

- **「事件」**：如果事件 $A$ 和事件 $B$ 的交 $AB = \varnothing$，那么称 $A$ 和 $B$ 互不相容。

- **「卡塔兰数」**：Catalan 数列 $H_n$ 可以应用于以下问题：

    1.  有 $2n$ 个人排成一行进入剧场。入场费 5 元。其中只有 $n$ 个人有一张 5 元钞票，另外 $n$ 人只有 10 元钞票，剧院无其它钞票，问有多少种方法使得只要有 10 元的人买票，售票处就有 5 元的钞票找零？
    2.  有一个大小为 $n\times n$ 的方格图左下角为 $(0, 0)$ 右上角为 $(n, n)$，从左下角开始每次都只能向右或者向上走一单位，不走到对角线 $y=x$ 上方（但可以触碰）的情况下到达右上角有多少可能的路径？
    3.  一个栈（无穷大）的进栈序列为 $1,2,3, \cdots ,n$ 有多少个不同的出栈序列？
    4.  由 $n$ 个 $+1$ 和 $n$ 个 $-1$ 组成的 $2n$ 个数 $a_1,a_2, \cdots ,a_{2n}$，其部分和满足 $\sum\limits_{l=1}^{k}a_l \geqslant 0$ $(k=1,2,3, \cdots ,2n)$，有多少个满足条件的数列？

    卡特兰数的递推式为 $\displaystyle H_n=\sum_{i=0}^{n-1}H_{i}H_{n-i-1} \quad (n\ge 2)$，其中 $H_0=1,H_1=1$，该递推关系的解为：

    $$
    H_n = \frac{1}{n+1}\binom{2n}{n}(n \geq 2, n \in \mathbf{N_{+}})
    $$

    关于 Catalan 数的常见公式：

    $$
    H_n = \begin{cases}
        \sum\limits_{i=1}^{n} H_{i-1} H_{n-i} & n \geq 2, n \in \mathbf{N_{+}}\\
        1 & n = 0, 1
    \end{cases}
    $$

    $$
    H_n = \frac{H_{n-1} (4n-2)}{n+1}
    $$

    $$
    H_n = \binom{2n}{n} - \binom{2n}{n-1}
    $$

- **「一维 Borel 点集」**：记 $\mathbb{R}^1$ 为直线或实数全体，并称由一切形为 $[a, b)$ 的有界左闭右开区间构成的集类所产生的 $\sigma$ 域为**一维博雷尔 $\sigma$ 域**，记之为 $\mathcal{B}_1$，称 $\mathcal{B}_1$ 中的集为**一维博雷尔点集**。若 $x, y$ 为任意实数，由于

    $$
    \begin{align}
    &\{x\} = \bigcap_{n=1}^{\infty} \left[x, x + \frac{1}{n}\right) 
    &(x, y) = [x, y) - \{x\} \\ 
    &[x, y] = [x, y) + \{y\} 
    &(x, y] = [x, y] - \{x\}
    \end{align}
    $$

    因此，$\mathcal{B}_1$ 中包含**一切开区间、闭区间、单个实数、可列个实数**，以及由它们经过可列次逆并、交运算而得出的集合。这是相当大的一个集类，足够把实际问题中感兴趣的点集都包括在内。若不从左闭右开区间 $[a, b)$ 出发，而从 $(a, b]$ 或 $(a, b)$，或 $[a, b]$，甚至 $(-\infty, x]$ 出发，都将产生同一个 $\sigma$ 域，这里的一部分证明在下面的 [Exercise Chapter 1](http://127.0.0.1:8000/Math/Probability/0%20Final%20Review/#chapter-1) 里。

- **「$n$ 维博雷尔点集」**  以 $\mathbb{R}^n$ 记 $n$ 维欧几里得空间，可以类似地定义 **n 维博雷尔点集**，它们是由一切 $n$ 维矩形产生的 **$n$ 维博雷尔 $\sigma$ 域** $\mathcal{B}_n$ 中的集合，也可以把 $\mathbb{R}^n$ 中我们感兴趣的点集都包括在内。
- **「公理化概率定义」**：定义在事件域 $\mathcal{F}$ 上的一个集合函数 $P$ 称为概率，如果它满足如下三个要求：

    1. 非负性：$P(A) \geq 0$, 对一切 $A \in \mathcal{F}$；
    2. 规范性：$P(\Omega) = 1$；
    3. 可数可加性：若 $A_i \in \mathcal{F}$, $i = 1, 2, \dots$ 且两两互不相容, 则

        $$
        P \left( \sum_{i=1}^{\infty} A_i \right) = \sum_{i=1}^{\infty} P(A_i) \tag{1.5.1}
        $$

- **「概率计算公式小结」**（独立与互斥情况省略）：
    - 加法公式：$P(A\cup B) = P(A) + P(B) - P(AB)$
    - 一般加法公式：$\displaystyle P(A_1 \cup A_2 \cup \cdots \cup A_n) = \sum_{i=1}^{n} P(A_i) - \sum_{1 \leqslant i < j \leqslant n} P(A_iA_j) + \cdots + (-1)^{n-1} P(A_1A_2\cdots A_n)$
    - 事件概率等式：$P(\overline{A}) = 1 - P(A)$
    - 减法公式：$P(A-B) = P(A) - P(AB)$
    - 乘法公式：$P(AB) = P(A)P(B|A)$
    - 乘法公式推广：$\displaystyle P(A_1A_2\cdots A_n) = P(A_1)P(A_2|A_1)P(A_3|A_1A_2)\cdots P(A_n|A_1A_2\cdots A_{n-1})$
    - 一般乘法公式：$\displaystyle P(A_1A_2\cdots A_n) = \sum_{i=1}^{n} P(A_i) - \sum_{1 \leqslant i < j \leqslant n} P(A_i\cup A_j) + \cdots + (-1)^{n-1} P(A_1\cup A_2\cup\cdots\cup A_n)$
    - 全概率公式：$\displaystyle P(B) = \sum_{i=1}^{n} P(A_i)P(B|A_i)$
    - 贝叶斯公式：$\displaystyle P(A_i|B) = \dfrac{P(A_i)P(B|A_i)}{\sum_{i=1}^{n} P(A_i)P(B|A_i)}$
- **「伯努利实验」**：我们将事件域取为 $\mathcal{F} = \{ \varnothing, A, \overline{A}, \Omega \}$，这种只有两个可能结果的实验称为**伯努利试验**，在伯努利试验中，首先是要给出下面概率：$P(A) = p$，$P(\overline{A}) = q$，显然 $p \geq 0, q \geq 0$, 且 $p+q=1$。现在考虑重复进行 $n$ 次独立的伯努利试验，这里的“重复”是指在每次试验中事件 $A$，从而事件 $A$ 出现的概率都保持不变。这种试验称为 $n$ **重伯努利试验**，记作 $E^n$。总之，$n$ 重伯努利试验有下面四个约定：

    1. 每次试验至多出现两个可能结果之一：$A$ 或 $\overline{A}$；
    2. $A$ 在每次试验中出现的概率 $p$ 保持不变；
    3. 各次试验相互独立；
    4. 共进行 $n$ 次试验。

    下面先给出 $n$ 重伯努利试验的概率空间：$n$ 重伯努利试验 $E^n$ 的样本点形如：$(\hat{A_1}, \hat{A_2}, \dots, \hat{A_n})$，其中 $\hat{A_i}$ 是 $A_i$ 或 $\overline{A_i}$，分别表示第 $i$ 次试验中出现 $A$ 或 $\overline{A}$，显然这种样本点共有 $2^n$ 个，这是一个有限样本空间。样本点也可以简记为 $\hat{A_1} \hat{A_2} \dots \hat{A_n}$。例如，$(A_1, A_2, \dots, A_{n-1}, \overline{A_n})$ 表示前 $n-1$ 次试验均出现事件 $A$，而第 $n$ 次试验出现事件 $\overline{A}$，简记为 $A_1 A_2 \dots A_{n-1} \overline{A_n}$。

    为了给定样本点 $(\hat{A_1}, \hat{A_2}, \dots, \hat{A_n})$ 的概率，主要看其中 $A$ 出现的次数。例如其中有 $l$ 个 $A$，从而有 $n-l$ 个 $\overline{A}$，则利用试验的独立性则有 
    
    $$
    P(\hat{A_1} \hat{A_2} \dots \hat{A_n}) = P(\hat{A_1}) P(\hat{A_2}) \dots P(\hat{A_n}) = p^l q^{n-l}
    $$

    一般事件的概率由它所含样本点的概率求和得到，这样一来，我们就已经对 $n$ 重伯努利实验给定了概率空间。我们有时候也需要考虑**可列重伯努利试验** $E^{\infty}$，这时样本空间不再有限，甚至不再可列，事实上这可以形成一个与 $[0, 1]$ 的一一对应，这种情况就不能将样本空间的任意子集都看作事件（测度论告诉我们的）。

- **「二项分布」**：我们来确定 $n$ 重伯努利试验中事件 $A$ 出现 $k$ 次的概率，这概率我们记之为 $b(k; n, p)$。若以 $B_k$ 记 $n$ 重伯努利试验中事件 $A$ 正好出现 $k$ 次这一事件，而以 $A_i$ 表示第 $i$ 次试验中出现事件 $A$，以 $\bar{A}_i$ 表示第 $i$ 次试验中出现 $\bar{A}$，则

    $$
    B_k = A_1 A_2 \cdots A_k \bar{A}_{k+1} \cdots \bar{A}_n + \cdots + \bar{A}_1 \bar{A}_2 \cdots \bar{A}_{n-k} A_{n-k+1} \cdots A_n
    $$

    右边的每一项表示某 $k$ 次试验中出现事件 $A$，在另外 $n - k$ 次试验中出现 $\bar{A}$，这种项共有 $\displaystyle \binom{n}{k}$ 个，而且两两互不相容。由伯努利试验的每个样本点的概率可知 $\displaystyle P(B_k) = \binom{n}{k} p^k q^{n-k}$，即 
    
    $$
    b(k; n, p) = \binom{n}{k} p^k q^{n-k}, \quad k = 0, 1, 2, \dots, n
    $$

    注意到 $b(k; n, p)$，$k = 0, 1, 2, \dots, n$，是二项式 $(q + p)^n$ 展开式中 $p^k$ 项的系数，因此称该分布为二项分布。$\sum\limits_{k=0}^{n} b(k; n, p)= 1$ 也是很容易检验的。特别地，我们将**两点分布**称为**伯努利分布**。

- **「几何分布」**：现在讨论在伯努利试验中首次成功出现在第 $k$ 次试验的概率，要使首次成功出现在第 $k$ 次试验，必须而且只需在前 $k-1$ 次试验中都出现事件 $\bar{A}$，而第 $k$ 次试验出现 $A$，因此这事件（记为 $W_k$）可表示为
    
    $$
    W_k = \bar{A}_1 \bar{A}_2 \cdots \bar{A}_{k-1} A_k
    $$

    利用试验的独立性，其概率为
    
    $$
    P(W_k) = P(\bar{A}_1) P(\bar{A}_2) \cdots P(\bar{A}_{k-1}) P(A_k) = q^{k-1} p
    $$
    
    记 $g(k; p) = q^{k-1} p$，$k = 1, 2, \dots$，$g(k; p)$ 是几何级数的一般项，因此称为几何分布。$\sum\limits_{k=1}^{\infty} g(k; p) = 1$ 也是很容易验证的，这里省略证明。

- **「帕斯卡分布」**：考虑伯努利试验，让我们考察要多长时间才会出现第 $r$ 次成功：若第 $r$ 次成功发生在第 $\zeta$ 次试验，则必然有 $\zeta \geqslant r$。

    让我们以 $C_k$ 表示第 $r$ 次成功发生在第 $k$ 次试验这一事件，并以 $f(k;r,p)$ 记其概率，$C_k$ 发生当且仅当前面的 $k-1$ 次试验中有 $r-1$ 次成功、$k-r$ 次失败，而第 $k$ 次试验的结果为成功，这两个事件的概率分别为 $\displaystyle \binom{k-1}{r-1} p^{r-1} q^{k-r}$ 与 $p$，于是利用试验的独立性，得到：

    $$
    P(C_k) = \binom{k-1}{r-1} p^{r-1} q^{k-r} \cdot p = \binom{k-1}{r-1} p^r q^{k-r}
    $$

    即

    $$
    f(k;r,p) = \binom{k-1}{r-1} p^r q^{k-r}, \quad k = r, r+1, \dots
    $$

    注意到
    
    $$
    \begin{align}
    \sum_{k=r}^{\infty} f(k;r,p) &= \sum_{k=r}^{\infty} \binom{k-1}{r-1} p^r q^{k-r}\\
    &= \sum_{l=0}^{\infty} \binom{r+l-1}{r-1} p^r q^l = \sum_{l=0}^{\infty} \binom{r+l-1}{l} p^r q^l \\
    &= \sum_{l=0}^{\infty} \binom{-r}{l} (-1)^l p^r q^l = p^r(1-q)^{-r} = 1
    \end{align}
    $$

    这里利用了推广的二项系数公式 $\displaystyle \binom{-a}{k} = \binom{a + k - 1}{k} \left(-1\right)^k$ 和牛顿二项式 $\displaystyle (a+b)^\alpha = \sum_{n=1}^{\infty}\binom{-\alpha}{n}x^{-\alpha - n} y ^n$；$f(k;r,p)$ 称为帕斯卡分布。特别当 $r=1$ 时，我们得到几何分布。

    可以使用帕斯卡分布简单解决分赌注问题，在每一轮赌局中，甲赢的概率为 $p$，乙赢的概率为 $q = 1 - p$，在某个节点，甲还差 $r$ 次胜利就能获胜，乙还差 $s$ 次胜利就能获胜，但是赌局无法继续，两人按照最终获胜的概率来分配赌注。下面计算甲获胜的概率 $p_{A}$：首先注意到至多还需要进行 $r + s - 1$ 轮赌局才能分出胜负，甲获胜至少需要经历 $r$ 轮赌局，并且甲获胜可以理解为：第 $r$ 次胜利发生在第 $[r, r + s - 1]$ 轮赌局中，因此使用帕斯卡分布的概率质量函数，我们有

    $$
    \begin{aligned}
    p_A &= \sum_{k=r}^{r+s-1} f(k; r, p) = \sum_{k=r}^{r+s-1} \binom{k-1}{r-1} p^r q^{k-r} \\
    &= \sum_{l=0}^{s-1} \binom{r+l-1}{r-1} p^r q^l. \quad\text{ (Letting } l = k - r\text{) }
    \end{aligned}
    $$

- **「泊松分布」**：历史上，泊松分布来自于对二项分布的近似，其核心是下面的定理：在独立试验中，以 $p_n$ 代表事件 $A$ 在试验中出现的概率，它与试验总数 $n$ 有关，如果 $n p_n \rightarrow \lambda$，则当 $n \rightarrow \infty$ 时，

    $$
    b(k; n, p_n) \rightarrow \dfrac{\lambda^k}{k!} e^{-\lambda}
    $$

    ???- Info "Proof"
        记 $\lambda_n = n p_n$，则

        $$\begin{aligned}
        b(k; n, p_n) &= \binom{n}{k} p_n^k (1 - p_n)^{n - k} \\
        &= \dfrac{n (n - 1) \cdots (n - k + 1)}{k!} \left( \dfrac{\lambda_n}{n} \right)^k \left( 1 - \dfrac{\lambda_n}{n} \right)^{n - k} \\ 
        &= \dfrac{\lambda^k}{k!} \left( 1 - \dfrac{1}{n} \right) \left( 1 - \dfrac{2}{n} \right) \cdots \left( 1 - \dfrac{k - 1}{n} \right) \left( 1 - \dfrac{\lambda_n}{n} \right)^{n - k}
        \end{aligned}$$

        由于对固定的 $k$ 有

        $$
        \lim\limits_{n\to \infty} \lambda_n^k = \lambda^k, \quad \lim\limits_{n\to \infty} \left( 1 - \dfrac{\lambda_n}{n} \right)^{n - k} = e^{-\lambda}
        $$

        以及

        $$
        \lim_{n \rightarrow \infty} \left( 1 - \dfrac{1}{n} \right) \left( 1 - \dfrac{2}{n} \right) \cdots \left( 1 - \dfrac{k - 1}{n} \right) = 1
        $$

        因此

        $$
        \lim_{n \rightarrow \infty} b(k; n, p_n) = \dfrac{\lambda^k}{k!} e^{-\lambda}
        $$

        这就完成了证明，并且有

        $$
        \sum_{k=0}^{\infty} p(k; \lambda) = \sum_{k=0}^{\infty} \dfrac{\lambda^k}{k!} e^{-\lambda} = e^{-\lambda} \cdot e^{\lambda} = 1
        $$

    我们将 $p(k; \lambda) = \dfrac{\lambda^k}{k!} e^{-\lambda}$ 称为**泊松分布**，$\lambda$ 称为它的参数。

- **「泊松过程」**：以接电话举例，泊松过程具有下面性质，且具有下面性质的一定是泊松过程：
    1. **平稳性**：在 $[t_0, t_0 + t)$ 中来到的呼叫数只与时间间隔长度 $t$ 有关而与时间起点 $t_0$ 无关。若以 $P_k(t)$ 记在长度为 $t$ 的时间区间中来到 $k$ 个呼叫的概率，当然 $\sum\limits_{k=0}^{\infty} P_k(t) = 1$ 对任何 $t > 0$ 成立。

        过程的平稳性表示了它的概率规律不随时间的推移而改变。

    2. **独立增量性（无后效性）** 在 $[t_0, t_0 + t)$ 内来到 $k$ 个呼叫这一事件与时刻 $t_0$ 以前发生的事件独立。换言之，在对时刻 $t_0$ 以前的事件发生情况所作的任何假定之下，计算出来的在 $[t_0, t_0 + t)$ 内发生 $k$ 个呼叫的条件概率都等于同一事件的无条件概率。独立增量性表明在互不相交的时间区间内过程进行的相互独立性。

    3. **普通性** 在充分小的时间间隔中，最多来到一个呼叫。即，若记

        $$
        \psi(t) = \sum_{k=2}^{\infty} P_k(t) = 1 - P_0(t) - P_1(t)
        $$

        应有 $\psi(t) = o(t)$，即

        $$
        \lim_{t \to 0} \dfrac{\psi(t)}{t} = 0
        $$

        普通性表明，在同一时间间隔内来两个或两个以上呼叫实际上是不可能的。


## Chapter 1 Exercises

1. 从装有号码 $1,2,\ldots,N$ 的球的箱子中有放回地摸了 $n$ 次球，依次记下其号码，试求这些号码按**严格上升次序**排列的概率。
2. 在上题中，这些号码按**上升（不一定严格）次序**排列的概率。
3. 任意从数列 $1,2,\ldots,N$ 中**不放回地取出** $n$ 个数并按大小排列成 $x_1 < x_2 < \ldots < x_n$，求 $x_m = M$ 的概率。

    ???- Info "Answer"

        考虑 $x_m = M$ 之下有几个小于 $M$，几个大于 $M$ 就可以了。

4. 在上题中，若采用有放回取数，这时 $x_1 \leqslant x_2 \leqslant \ldots \leqslant x_m$，求 $x_m = M$ 的概率。

    ???- Info "Answer"

        其实是一个多项分布：从 $1, 2, \dots, N$ 中有放回地取 $n$ 个数，这 $n$ 个数可分为 3 类：小于 $M$，等于 $M$，大于 $M$。以 $k_1$ 记取到小于 $M$ 的数的次数，以 $k_2$ 记取到大于 $M$ 的数的次数，则取到等于 $M$ 的次数为 $n - k_1 - k_2$。

        在固定 $k_1, k_2$ 的条件下，取到 $k_1$ 个小于 $M$ 的数，$n - k_1 - k_2$ 个 $M$，$k_2$ 个大于 $M$ 的数的概率为：

        $$
        \dfrac{n!}{k_1!k_2!(n-k_1-k_2)!} \cdot \dfrac{(M-1)^{k_1}(N-M)^{k_2}}{N^n}
        $$

        易见 $k_1$ 可取 $0, 1, 2, \dots, m-1$，$k_2$ 可取 $0, 1, 2, \dots, n-m$，于是所求概率为：

        $$
        \sum_{k_1=0}^{m-1} \sum_{k_2=0}^{n-m} \dfrac{n!}{k_1!k_2!(n-k_1-k_2)!} \cdot \dfrac{(M-1)^{k_1}(N-M)^{k_2}}{N^n}
        $$

5. 利用概率论的想法证明下列恒等式：

    $$
    1 + \dfrac{A - a}{A - 1} + \dfrac{(A - a)(A - 1)}{(A - 1)(A - 2)} + \cdots + \dfrac{(A - a)(A - 1) \cdots 2 \cdot 1}{(A - 1)(A - 2) \cdots (a+1)a} = \dfrac{A}{a}.
    $$

    其中 $A, a$ 都是正整数，且 $A > a$。

    ???- Info "Answer"

        设袋中有 $A$ 只球，其中有 $a$ 只是白球，其余为黑球。现不放回地从袋中逐个取球，则第 $k$ 次才首次取得白球的概率为

        $$
        p_1 = \dfrac{a}{A}, \quad p_k = \dfrac{a(A - a)(A - a - 1) \cdots (A - a - k + 2)}{A(A - 1)(A - 2) \cdots (A - k + 1)}, \quad k = 2, \dots, A - a + 1
        $$

        因为袋中只有 $a$ 只白球，其余为黑球，所以第 1 次或第 2 次⋯⋯或至少到第 $A - a + 1$ 次必取得白球，因此必有

        $$
        1 = p_1 + p_2 + \cdots + p_{A - a + 1}
        $$

        即

        $$
        1 = \dfrac{a}{A} + \dfrac{a(A - a)}{A(A - 1)} + \cdots + \dfrac{a(A - a)(A - 1) \cdots 2 \cdot 1}{A(A - 1) \cdots (a+1)a}
        $$

        等式两边同乘以 $\dfrac{A}{a}$ 得

        $$
        1 + \dfrac{A - a}{A - 1} + \dfrac{(A - a)(A - 1)}{(A - 1)(A - 2)} + \cdots + \dfrac{(A - a)(A - 1) \cdots 2 \cdot 1}{(A - 1)(A - 2) \cdots (a+1)a} = \dfrac{A}{a}
        $$

6. 某班有 $N$ 个士兵，每人各有一支枪，这些枪外形完全一样，在一次夜间紧急集合中，若每人随机地取走一支枪，问恰好有 $k$ $( 0 \leqslant k \leqslant N)$ 个人拿到自己的枪的概率。

    ???- Info "Answer"

        在 $N$ 个士兵中任意选出 $k$ 个士兵来有 $\binom{N}{k}$ 种选法。
        
        一组指定的 $k$ 个士兵都拿到自己的枪的概率为

        $$
        \dfrac{1}{N(N-1)\cdots(N-k+1)}
        $$

        为了求剩下的 $N - k$ 个士兵都没有拿到自己的枪的概率，我们需要求其均拿到了自己的枪的概率：我们求一般情况下的，若一共有 $N$ 个士兵，设 $A_i = \{\text{第 } i \text{ 个士兵拿到自己的枪}\}, i = 1, 2, \dots, N$，则

        $$
        \begin{gathered}
        P(A_i) = \dfrac{(N-1)!}{N!} = \dfrac{1}{N}\\
        P(A_i A_j) = \dfrac{(N-2)!}{N!} = \dfrac{1}{N(N-1)}, \quad i \neq j\\
        \cdots \cdots\\
        P(A_1 A_2 \cdots A_N) = \dfrac{1}{N!}\\
        \end{gathered}
        $$

        由容斥原理得，“至少有一个士兵拿到自己的枪”的概率为

        $$
        \begin{aligned}
        P(A_1 \cup A_2 \cup \cdots \cup A_N) &= \sum_{i=1}^{N} P(A_i) - \sum_{1 \leqslant i < j \leqslant N} P(A_i A_j) + \cdots + (-1)^{N-1} P(A_1 A_2 \cdots A_N)\\
        &= \binom{N}{1} \dfrac{1}{N} - \binom{N}{2} \dfrac{1}{N(N-1)} + \cdots + (-1)^{N-1} \binom{N}{N} \dfrac{1}{N!}\\
        &= 1 - \dfrac{1}{2!} + \cdots + (-1)^{N-1} \dfrac{1}{N!}\\
        &= \sum_{k=1}^{N} \dfrac{(-1)^{k-1}}{k!}
        \end{aligned}
        $$

        所以，一个士兵都没有拿到自己的枪的概率为
        
        $$
        1 - \sum_{l=1}^{N-k} \dfrac{(-1)^{l-1}}{l!} = \sum_{l=0}^{N-k} \dfrac{(-1)^l}{l!} 
        $$

        于是，恰好有 $k$ 个士兵拿到自己枪的概率为

        $$
        P_{[k]} = \binom{N}{k} \dfrac{1}{N(N-1)\cdots(N-k+1)} \sum_{l=0}^{N-k} \dfrac{(-1)^l}{l!}
        $$

7. 考试时一共有 $N$ 个签，$n$ $(n \geqslant N)$ 个学生有放回抽签，在全抽完之后至少有一张考签没有被抽到的概率为多少？

    ???- Info "Answer"

        还是容斥原理，设 $A_i = \{\text{第 } i \text{ 张考签没有被抽到}\}, i = 1, 2, \dots, N$，则

        $$
        \begin{align}
        P( \{ 至少有一张考签未被抽到 \} ) &=P(A_1 \cup A_2 \cup \cdots \cup A_N) \\
        &= \sum_{i=1}^{N} P(A_i) - \sum_{1 \leqslant i < j \leqslant N} P(A_i A_j) + \cdots + (-1)^{N-1} P(A_1 A_2 \cdots A_N) \\
        &= \sum_{i=1}^{N} \binom{N}{1} \dfrac{(N-1)^n}{N^n} - \binom{N}{2} \dfrac{(N-2)^n}{N^n} + \cdots + (-1)^{N-1} \binom{N}{N-1} \dfrac{1}{N^n} + 0 \\
        &= \sum_{i=1}^{N-1} (-1)^{i-1} \binom{N}{i} \dfrac{(N-i)^n}{N^n}
        \end{align}
        $$

8. 证明 $\sigma$ 域的交仍然是 $\sigma$ 域。

    ???- Info "Answer"

        设 $\mathcal{F}_t$ $(t \in T)$ 是 $\sigma$ 域，记 $\displaystyle\mathcal{F} = \bigcap_\limits{t \in T} \mathcal{F}_t$。

        (i) $\forall t \in T$，$\Omega \in \mathcal{F}_t$，所以 $\Omega \in \bigcap\limits_{t \in T} \mathcal{F}_t$，即 $\Omega \in \mathcal{F}$；

        (ii) 若 $A \in \mathcal{F}$，则 $A \in \mathcal{F}_t$，$\forall t \in T$。由于 $\mathcal{F}_t$ 是 $\sigma$ 域，得 $\forall t \in T$，$\overline{A} \in \mathcal{F}_t$，所以 $\overline{A} \in \bigcap\limits_{t \in T} \mathcal{F}_t$，从而有 $\overline{A} \in \mathcal{F}$；

        (iii) 若 $A_i \in \mathcal{F}$，$i = 1, 2, \dots$，则 $\forall t \in T$，$A_i \in \mathcal{F}_t$。由于 $\mathcal{F}_t$ 是 $\sigma$ 域，所以 $\forall t \in T$， $\bigcup\limits_{i=1}^{\infty} A_i \in \mathcal{F}_t$，即 $\bigcup\limits_{i=1}^{\infty} A_i \in \bigcap{t \in T} \mathcal{F}_t = \mathcal{F}$。

        所以 $\mathcal{F}$ 是 $\sigma$ 域。

9. 包含一切形为 $(-\infty, x)$ 的区间的最小 $\sigma$ 域是一维 Borel $\sigma$ 域。

    ???- Info "Answer"

        一维 Borel $\sigma$ 域 $\mathcal{B} = \sigma \{[a, b)\}$ 是由左闭右开区间类产生的 $\sigma$ 域，设 $\widetilde{\mathcal{B}} = \sigma {(-\infty, x)}$ 是由形如 $(-\infty, x)$ 区间类产生的 $\sigma$ 域。

        因为 $[a, b) = (-\infty, b) - (-\infty, a)$，$\mathcal{B}$ 是 $\sigma$ 域，所以 $[a, b) \in \widetilde{\mathcal{B}}$，因此有 $\mathcal{B} \subseteq \widetilde{\mathcal{B}}$。

        又由于 $(-\infty, x) = \displaystyle\bigcup\limits_{n=1}^{\infty} [x - n, x - n + 1)$，$\mathcal{B}$ 是 $\sigma$ 域，所以 $(-\infty, x) \in \mathcal{B}$，因此有 $\widetilde{\mathcal{B}} \subseteq \mathcal{B}$。

        于是有 $\widetilde{\mathcal{B}} = \mathcal{B}$

10. 证明：概率论定义中的三个条件可以使用下面两个条件代替：

    (i) $P(A) \geq 0$, 对一切 $A \in \mathcal{F}$;  

    (ii) 若 $A_i \in \mathcal{F}, i=1, 2, \dots$, 两两互不相容，且 $\displaystyle\sum_{i=1}^{\infty} A_i = \Omega$ 则 $\displaystyle\sum_{i=1}^{\infty} P(A_i) = 1$。

    ???- Info "Answer"

        概率定义的三个条件为：  
        1. 非负性：$P(A) \geq 0$, 对 $\forall A \in \mathcal{F}$;  
        2. 规范性：$P(\Omega) = 1$;  
        3. 可列可加性：若 $A_i \in \mathcal{F}, i=1, 2, \dots, A_i \cap A_j = \varnothing$, 当 $i \neq j$, 则  $\displaystyle P\left( \sum_{i=1}^{\infty} A_i \right) = \sum_{i=1}^{\infty} P(A_i)$

        显然 (i) 与 (1) 是等价的。

        若 $A_i \in \mathcal{F}, i=1, 2, \dots$, 两两互不相容，且  
        $$
        \sum_{i=1}^{\infty} A_i = \Omega
        $$
        则由 (2)(3) 可推出
        $$
        1 = P(\Omega) = P\left( \sum_{i=1}^{\infty} A_i \right) = \sum_{i=1}^{\infty} P(A_i)
        $$
        即 (ii) 成立。

        反之，当 (ii) 成立，则由 $\Omega = \Omega + \varnothing + \varnothing + \cdots$ 可得  
        $P(\varnothing) = 0$，因此 (2) 成立，再由  
        $\Omega = B + \overline{B} + \varnothing + \varnothing + \cdots$ 可得  
        $P(B) + P(\overline{B}) = 1$，若 $\forall A_i \in \mathcal{F}, i=1, 2, \dots$, 且两两互不相容，则
        $$
        \sum_{i=1}^{\infty} A_i + \overline{\sum_{i=1}^{\infty} A_i} = \Omega
        $$
        由 (ii) 可得  
        $$
        \sum_{i=1}^{\infty} P(A_i) + P\left( \overline{\sum_{i=1}^{\infty} A_i }\right) = 1
        $$
        加上前面的结论，得出
        $$
        P\left( \overline{\sum_{i=1}^{\infty} A_i} \right) + P\left( \sum_{i=1}^{\infty} A_i \right) = 1
        $$
        所以有
        $$
        P\left( \sum_{i=1}^{\infty} A_i \right) = \sum_{i=1}^{\infty} P(A_i)
        $$
        即可列可加性成立。

11. 甲有 $n+2$ 枚硬币，乙有 $n$ 枚硬币，投掷后比较，求 $A=\{\text{甲正} > \text{乙正}\}$ 的概率。

    ???+ Info "Answer"
        若记 $B=\{\text{甲反} > \text{乙反}\}$，由对称性仍有 $P(A) = P(B)$。

        但这里 $AB \neq \varnothing$，不过由于 $\overline{A} \overline{B} = \emptyset$，故知 $P(A \cup B) = P(\Omega) = 1$，又

        $$ 
        \begin{align}
        AB &= \{\text{甲正} = \text{乙正} + 1, \text{甲反} > \text{乙反}\}\\
        &= \{\text{甲正} - \text{乙正} = 1, \text{甲反} - \text{乙反} = 1\}\\
        &= \{\text{甲正} - \text{乙正} = 1\}
        \end{align}
        $$

        故

        $$ 
        \begin{align}
        P(AB) &= \sum_{k=0}^{n} P\{\text{甲正} = k + 1, \text{乙正} = k\} \\
        &= \sum_{k=0}^{n} \binom{n+2}{k+1} \binom{n}{k} \dfrac{1}{2^{2n+2}} \\
        &= \sum_{k=0}^{n} \binom{n+2}{n+1-k} \binom{n}{k} \dfrac{1}{2^{2n+2}} \\
        &= \binom{2n+2}{n+1} \dfrac{1}{2^{2n+2}}
        \end{align}
        $$

        由

        $$ 1 = P(A) + P(B) - P(AB) $$

        得

        $$ P(A) = \dfrac{1}{2} \left[1 + \dfrac{(2n+2)}{(n+1)2^{2n+2}}\right] $$

## Chapter 2 Exercises

1. 设一个家庭中有 $n$ 个小孩的概率为

    $$
    p_n = \begin{cases} 
    \alpha p^n, & n \geq 1 \\
    1 - \dfrac{\alpha p}{1 - p}, & n = 0 
    \end{cases}
    $$

    这里 $0 < p < 1$, $0 < \alpha < \dfrac{1-p}{p}$，若认为生一个小孩为男孩或女孩是等可能的，求证一个家庭有 $k$ $(k \geqslant 1)$ 个男孩的概率为 $\dfrac{2 \alpha p^k}{(2 - p)^{k+1}}$。

    ???+ Info "Answer"
        设 $A_n = \{\text{一个家庭中有 } n \text{ 个孩子}\}, n = 1, 2, \cdots$，$B_k = \{\text{该家庭中有 } k \text{ 个男孩}, k \geqslant 1\}$。由于假定生男孩或生女孩是等可能的，所以有 $\displaystyle P(B_k|A_n) = \binom{n}{k} \left(\dfrac{1}{2}\right)^n$，由全概率公式得

        $$
        \begin{align}
        P(B_k) &= \sum_{n=k}^{\infty} P(A_n) P(B_k | A_n) = \sum_{n=k}^{\infty} \alpha p^n \binom{n}{k} \left(\dfrac{1}{2}\right)^n \\ 
        &= \alpha \sum_{n=k}^{\infty} \binom{k+i}{k} \left(\dfrac{p}{2}\right)^{k+i} = \alpha \left(\dfrac{p}{2}\right)^k \sum_{i=0}^{\infty} \binom{k+i}{i} \left(\dfrac{p}{2}\right)^i \\ 
        &=  \alpha \left(\dfrac{p}{2}\right)^k \sum_{k=0}^{\infty} \binom{-k-1}{i} \left(-\dfrac{p}{2}\right)^i = \alpha \left(\dfrac{p}{2}\right)^k \dfrac{1}{\left(1 - \dfrac{p}{2}\right)^{k+1}} \\ 
        &= \dfrac{2 \alpha p^k}{(2 - p)^{k+1}}
        \end{align}
        $$

        这里用到了一个小技巧：一般组合数有下面公式

        $$
        \binom{n}{k} = \begin{cases}
        1, & k = 0 \\
        0, & (0 \leqslant n < k) \lor (k < 0 < n) \\ 
        \left(-1\right)^k\binom{\lvert n\rvert + k - 1}{k}, & (n < 0) \land (k > 0)\\ 
        \left(-1\right)^{n+k} \binom{\lvert k\rvert -1}{\lvert n\rvert -1}, & (n < 0) \land (k < 0)
        \end{cases}
        $$

        换成更容易记忆的形式：

        $$
        \binom{-a}{k} = \binom{a + k - 1}{k} \left(-1\right)^k.
        $$

        这个公式嘎嘎有用，需要记忆。

2. 对称随机游走：甲、乙均有 $n$ 个硬币，全部掷完后分别计算掷出的正面数，试求两人掷出的正面数相等的概率。

    ???+ Info "Answer"
        利用二项分布，得
        
        $$
        \begin{align}
        p &= \sum_{k=0}^{n} \binom{n}{k} \left(\dfrac{1}{2}\right)^k \left(\dfrac{1}{2}\right)^{n-k} \cdot \binom{n}{k} \left(\dfrac{1}{2}\right)^k \left(\dfrac{1}{2}\right)^{n-k} \\
        &= \left(\dfrac{1}{2}\right)^{2n} \sum_{k=0}^{n} \binom{n}{k}^2 \\
        &= \left(\dfrac{1}{2}\right)^{2n} \sum_{k=0}^{n} \binom{n}{k} \binom{n}{n-k} \\ 
        &= \binom{2n}{n} \left(\dfrac{1}{2}\right)^{2n}
        \end{align}
        $$

3. 帕斯卡分布视角下的分赌注问题：甲、乙两个赌徒按某种方式下注赌博，设甲在每局中取胜的概率为 $p$，他们说定先胜 $t$ 局者将赢得全部赌注，但进行到甲胜 $r$ 局，乙胜 $s$ 局（$r<t,s<t$）时，由于不得不中止，试问如何分配这些赌注才公平合理？

    ???+ Info "Answer"

        以 $n=t-r$ 及 $m=t-s$ 分别记甲及乙为达到最后胜利所须再胜的局数，我们可以把分赌注问题归结为如下概率问题：在伯努利试验中，求在出现 $m$ 次 $\overline{A}$ 之前出现 $n$ 次 $A$ 的概率。

        若以 $p_{甲}$ 记上述概率，则它为甲最终取胜的概率，那么赌注以 $p_{甲}:1-p_{甲}$ 分配是公平合理的。现在，若利用帕斯卡分布，则容易写出答案
        
        $$
        p_{甲} = \sum_{k=0}^{m-1} \binom{n+k-1}{k} p^n q^k
        $$
        
        或
        
        $$
        p_{甲} = \sum_{k=0}^{\infty} \binom{m+k-1}{k} p^k q^m
        $$
        
        另外，容易证明，再赌 $n+m-1$ 局一定可以决定胜负。因此甲为取得最终胜利只须而且必须在后续的 $n+m-1$ 局中至少胜 $n$ 局。这样，利用二项分布可以知道，
        
        $$
        p_{甲} = \sum_{k=n}^{n+m-1} \binom{n+m-1}{k} p^k q^{n+m-1-k}
        $$

        可以证明这三个答案确实是一致的，但是答案真的太长了。

4. 带有吸收壁的随机游走：设质点每隔单位时间分别以概率 $p$ 和 $q = 1 - p$ 向正的或负的方向移动一个单位。假定其在时刻 $t=0$ 时，位于 $x=a$，而在 $x=0$ 及 $x=a+b$ 处各有一个吸收壁，我们要求质点 $x=0$ 被吸收或在 $x=a+b$ 被吸收的概率。

    ???+ Info "Answer"
        我们用的是差分方程法。

        若以 $q_n$ 记质点的初始位置为 $n$ 而最终在 $x=a+b$ 点被吸收的概率。显然 $q_0 = 0$，$q_{a+b} = 1$。

        如果某时刻质点位于 $x=n$，这里 $1\leqslant n\leqslant a+b-1$，则它要被 $x=a+b$ 吸收，有两种方式来实现：一种是接下去一次移动是向右的而最终被 $x=a+b$ 吸收；另一种是接下去一次移动是向左的而最终被 $x=a+b$ 吸收。所以按全概率公式有
        
        $$
        q_n = p q_{n+1} + q q_{n-1}, \quad n=1,2,\cdots,a+b-1
        $$

        这样，我们得到了关于 $q_n$ 的一个二阶差分方程，再用边界条件就可以求解。利用这个差分方程系数的特殊性，比较方便的解法是把这个差分方程改写成

        $$
        p (q_{n+1} - q_n) = q (q_n - q_{n-1}), \quad n=1,2,\cdots,a+b-1
        $$

        若记 $c_n = q_{n+1} - q_n, r = \dfrac{q}{p}$，则又能写成

        $$
        c_n = r c_{n-1}, \quad n=1,2,\cdots,a+b-1
        $$

        下面分两种情况求解：

        (i). $r=1$，即 $p=q=\dfrac{1}{2}$ 的场合，也即对称随机游动的场合。这时 $c_n = c_{n-1}$，因此，若记

        $$
        q_{n+1} - q_n = q_n - q_{n-1} = \cdots = q_1 - q_0 = d
        $$

        则

        $$
        q_n = q_0 + n d
        $$

        由于 $q_0 = 0, q_{a+b} = 1$，故有

        $$
        q_n = \dfrac{n}{a+b}
        $$

        特别地

        $$
        q_a = \dfrac{a}{a+b}
        $$

        (ii). $r\neq1$，即 $p\neq q$ 的场合

        这时

        $$
        c_n = r c_{n-1} = r^2 c_{n-2} = \cdots = r^n c_0
        $$

        从而
        
        $$
        q_n - q_0 = \sum_{k=0}^{n-1} (q_{k+1} - q_k) = \sum_{k=0}^{n-1} c_k = \sum_{k=0}^{n-1} r^k c_0 = \dfrac{1 - r^n}{1 - r} c_0
        $$

        由于 $q_0 = 0, q_{a+b} = 1$，故有
        
        $$
        \dfrac{1 - r^{a+b}}{1 - r} c_0 = 1
        $$

        因此
        
        $$
        q_n = \dfrac{1 - r^n}{1 - r^{a+b}}
        $$

        特别地
        
        $$
        q_a = \dfrac{1 - r^a}{1 - r^{a+b}} = \dfrac{1 - \left( \dfrac{q}{p} \right)^a}{1 - \left( \dfrac{q}{p} \right)^{a+b}}
        $$

        若以 $p_n$ 记质点自 $n$ 出发而在 $0$ 点被吸收的概率，同样可以列出差分方程
        
        $$
        p_n = p p_{n+1} + q p_{n-1}, \quad n=1,2,\cdots,a+b-1
        $$

        及边界条件
        
        $$
        p_0 = 1, \quad p_{a+b} = 0
        $$

        类似地可以求得，当 $p = q = \dfrac{1}{2}$ 时
        
        $$
        p_a = \dfrac{b}{a+b}
        $$

        而在 $p \neq q$ 的场合
        
        $$
        p_a = \dfrac{1 - \left( \dfrac{p}{q} \right)^b}{1 - \left( \dfrac{p}{q} \right)^{a+b}} \dfrac{\left( \dfrac{q}{p} \right)^a - \left( \dfrac{q}{p} \right)^{a+b}}{1 - \left( \dfrac{q}{p} \right)^{a+b}}
        $$

        不管在什么场合，都有

        $$
        p_a + q_a = 1
        $$

5. 

