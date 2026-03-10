# Chapter 3 随机变量与分布函数

## Knowledge

### 1. 随机变量及其分布

- **「随机变量与其概率分布」**：设 $\xi(\omega)$ 是定义于概率空间 $(\Omega, \mathcal{F}, P)$ 上的单值实函数，如果 $\xi$ 是 $\mathcal{F}$-可测的，也就是对于直线上的任一博雷尔点集 $B$, 有

    $$
    \{\omega : \xi(\omega) \in B\} \in \mathcal{F}
    $$

    则称 $\xi(\omega)$ 为**随机变量**，而 $P\{\xi(\omega) \in B\}$ 称为随机变量 $\xi(\omega)$ 的**概率分布**。特别地，若取 $B = (-\infty, x)$，则有

    $$
    \{\omega : \xi(\omega) < x\} \in \mathcal{F}
    $$

    因此 $P\{\xi(\omega) < x\}$ 有定义。注意到

    $$
    P\{a \leq \xi(\omega) < b\} = P\{\xi(\omega) < b\} - P\{\xi(\omega) < a\}
    $$

    所以只要对一切实数 $x$ 给出概率 $P\{\xi(\omega) < x\}$，就能算出 $\xi(\omega)$ 落入某个区间 $[a, b)$ 的概率，再利用概率的性质还可以算出 $\xi(\omega)$ 属于某些相当复杂的直线点集（譬如可列个不相交的左闭右开区间之和）的概率。

- **「随机变量的分布函数」**：称

    $$
    F(x) = P\{\xi(\omega) < x\}, \quad -\infty < x < \infty
    $$

    为随机变量 $\xi(\omega)$ 的**分布函数**（distribution function）。**需要注意的是，这里分布函数的定义取的是小于号 $<$**。为书写方便起见，通常把“随机变量 $\xi(\omega)$ 服从分布函数 $F(x)$” 简记作 $\xi(\omega) \sim F(x)$。由上面的式子立刻得到 

    $$
    P\{a \leq \xi(\omega) < b\} = F(b) - F(a)
    $$

- **「分布函数的性质」**：分布函数 $F(x)$ 具有下列性质：

    1. 单调性：若 $a < b$，则 $F(a) \leq F(b)$；
    2. $\lim\limits_{x \to -\infty} F(x) = 0$, $\lim\limits_{x \to +\infty} F(x) = 1$；
    3. 左连续性：$F(x - 0) = F(x)$。

    ???- Info "Proof"

        1. $F(b) - F(a) = P\{a \leq \xi < b\} \geq 0$。
        2. 根据

            $$
            \begin{aligned}
            P\{-\infty < \xi < +\infty \} &:= \sum_{n=-\infty}^{\infty}\limits P\{n \leq \xi < n + 1\} \\
            &= \sum_{n=-\infty}^{\infty} \left[ F(n+1) - F(n) \right] \\ 
            &= \lim_{n \to +\infty} F(n) - \lim_{m \to -\infty} F(m) = 1 \\
            \end{aligned}
            $$

            由于 $F(x)$ 的单调性，$\lim\limits_{x \to -\infty} F(x) = \lim\limits_{m \to -\infty} F(m)$ 存在。

            因为 $0 \leq F(x) \leq 1$，故

            $$
            \lim\limits_{x \to -\infty} F(x) = 0, \quad \lim\limits_{x \to +\infty} F(x) = 1
            $$

            今后为书写方便起见，将记

            $$
            F(-\infty) = \lim\limits_{x \to -\infty} F(x), \quad F(+\infty) = \lim\limits_{x \to +\infty} F(x) \tag{3.1.7}
            $$

        3. 由于 $F(x)$ 是单调函数，只须证明对于一列单调上升的数列 $x_0 < x_1 < x_2 < \cdots < x_n < \cdots$, 当 $x_n \to x$ 成立时 $\lim\limits_{n \to \infty} F(x_n) = F(x)$ 即可。因为

            $$
            \begin{aligned}
            F(x) - F(x_0) &= P\{x_0 \leq \xi < x\} = \sum_{n=1}^{\infty} \left[ F(x_n) - F(x_{n-1}) \right] \\ 
            &= \lim_{n \to \infty} F(x_n) - F(x_0)
            \end{aligned}
            $$

            所以

            $$
            F(x-0) = \lim_{n \to \infty} F(x_n) = F(x)
            $$

        可以看出分布函数的这三个基本性质，正好对应于概率的三个基本性质。

    有了分布函数之后，就可以计算很多关于随机变量 $\xi$ 的概率了，比如

    $$\begin{aligned}
        &P\{\xi(\omega) = a\} = F(a + 0) - F(a) \\
        &P\{\xi(\omega) \leq a\} = F(a + 0) \\ 
        &P\{\xi(\omega) \geq a\} = 1 - F(a) \\
        &P\{\xi(\omega) > a\} = 1 - F(a + 0)
    \end{aligned}$$

- **「常见的离散型随机变量的分布」**：这里大多是复习上章的内容：
    1. 「伯努利分布/两点分布」：
    2. 「二项分布」：背景是 $n$ 重伯努利试验中，考虑随机变量 $\mu$ 位事件 $A$ 发生 $k$ 次的次数，其分布律为：$\displaystyle P\{\mu = k\} = \binom{n}{k} p^k (1-p)^{n-k}$，简记为 $\mu \sim B(n, p)$。
    3. 「超几何分布」：
    4. 「泊松分布」：若随机变量 $\xi$ 可以取任何的非负整数值，其满足 $\displaystyle P\{\xi = k\} = \frac{\lambda^k}{k!} e^{-\lambda}$，则称 $\xi$ 服从参数为 $\lambda$ 的泊松分布，简记为 $\xi \sim \mathcal{P}(\lambda)$。
    5. 「几何分布」：
    6. 「帕斯卡分布」：
    7. 「负二项分布」：
- **「连续型随机变量及其分布」**：连续型随机变量 $\xi$ 可以取区间 $[c, d]$ 中的任何值，并且满足其分布函数 $F(x)$ 是绝对连续函数，即存在可积函数 $p(x)$，使

    $$
    F(x) = \int_{-\infty}^{x} p(y) \, \mathrm{d}y
    $$

    称 $p(x)$ 为 $\xi$ 的**分布密度函数/Density Function**。进一步，我们可以对任意博雷尔点集 $B$ 进行积分：

    $$
    P\{\xi \in B\} = \int_B p(x) \, \mathrm{d}x
    $$

- **「正态分布」**：其密度函数为 

    $$
    p(x) = \dfrac{1}{\sqrt{2\pi}\sigma} e^{-(x-\mu)^2/2\sigma^2}, \enspace -\infty < x < \infty 
    $$

    期中 $\mu$ 为数学期望，$\sigma$ 为标准差。正态分布的分布函数为

    $$
    F(x) = \dfrac{1}{\sqrt{2\pi}\sigma} \int_{-\infty}^{x} e^{-(t-\mu)^2/2\sigma^2} \, \mathrm{d}t, \enspace -\infty < x < \infty
    $$

    一方面，虽然 $F(x)$ 无法用初等函数表示，但是可以证明这样确实定义了一个密度函数和分布函数：

    ???- Info "Proof"
        1. 显然 $p(x) \geq 0$；
        2. 下面验证 $F(\infty) = 1$：$\dfrac{x - \mu}{\sigma} = z$，则

        $$
        \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi} \sigma} e^{-\frac{(x - \mu)^2}{2 \sigma^2}} \, \mathrm{d}x = \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{z^2}{2}} \, \mathrm{d}z
        $$

        耦合成二维问题，并转换成极坐标$x = r \cos \varphi$，$y = r \sin \varphi$：

        $$\begin{aligned}
        \left( \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{x^2}{2}} \, \mathrm{d}x \right) \left( \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{y^2}{2}} \, \mathrm{d}y \right)
        &= \dfrac{1}{2 \pi} \int_{-\infty}^{\infty} \int_{-\infty}^{\infty} e^{-\frac{x^2 + y^2}{2}} \, \mathrm{d}x \, \mathrm{d}y \\ 
        &= \dfrac{1}{2 \pi} \int_{0}^{\infty} \int_{0}^{2 \pi} e^{-\frac{r^2}{2}} r \, \mathrm{d}r \, \mathrm{d}\varphi \\
        &= \int_{0}^{\infty} r e^{-\frac{r^2}{2}} \, \mathrm{d}r = 1
        \end{aligned}$$

        由 $\displaystyle\int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{z^2}{2}} \, \mathrm{d}z$ 的非负性知

        $$
        \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi} \sigma} e^{-\frac{(x - \mu)^2}{2 \sigma^2}} \, \mathrm{d}x = \int_{-\infty}^{\infty} \dfrac{1}{\sqrt{2 \pi}} e^{-\frac{z^2}{2}} \, \mathrm{d}z = 1
        $$

    当 $\mu = 0$，$\sigma = 1$ 时，称为**标准正态分布**，记为 $N(0, 1)$，其分布函数为 $\Phi(x)$。我们可以将一般的正态分布的分布函数转化成标准正态分布的分布函数：

    $$\begin{aligned}
    &F(x) = P\{\xi < x\} = P\left\{\frac{\xi - \mu}{\sigma} < \frac{x - \mu}{\sigma}\right\} = \Phi\left(\frac{x - \mu}{\sigma}\right) \\ 
    &P\{\lvert \xi - \mu \rvert < k\sigma\} = P\left\{-k < \frac{\xi - \mu}{\sigma} < k\right\} = \Phi(k) - \Phi(-k) = 2\Phi(k) - 1
    \end{aligned}$$

- **「指数分布」**：
- **「埃尔朗分布」**：
- **「$\Gamma$分布」**：

### 2. 随机向量、随机变量的独立性

在某些随机现象中，每次试验的结果不能只用一个数来描述，所以引入随机向量。

- **「随机向量」**：若随机变量 $\xi_1(\omega), \xi_2(\omega), \cdots, \xi_n(\omega)$ 定义在同一概率空间 $(\Omega, \mathcal{F}, P)$ 上，则称

    $$
    \boldsymbol{\xi}(\omega) = (\xi_1(\omega), \xi_2(\omega), \cdots, \xi_n(\omega))
    $$

    构成一个 $n$ **维随机向量**，亦称 **$n$ 维随机变量**。显然，一维随机向量即为随机变量，$n$ 维随机向量 $\boldsymbol{\xi}$ 取值于 $n$ 维欧氏空间 $\mathbb{R}^n$。值得注意的是，随机向量并没有要求其分量都是连续型或者离散型的，可以混合使用。另外，对于任意的 $n$ 个实数 $x_1, x_2, \cdots, x_n$

    $$
    \{\xi_1(\omega) < x_1, \xi_2(\omega) < x_2, \cdots, \xi_n(\omega) < x_n\} = \bigcap_{i=1}^{n} \{\xi_i(\omega) < x_i\} \in \mathcal{F}
    $$

    亦即对于 $\mathbb{R}^n$ 中的 $n$ 维矩形 $C_n = \prod\limits_{i=1}^{n} (-\infty, x_i)$，有 $\{\boldsymbol{\xi}(\omega) \in C_n\} \in \mathcal{F}$。利用测度论的方法还可证明，若 $B_n$ 为 $\mathbb{R}^n$ 上任一博雷尔点集，也有 $\{\boldsymbol{\xi}(\omega) \in B_n\} \in \mathcal{F}$。

- **「联合分布函数」**：称 $n$ 元函数

    $$
    F(x_1, x_2, \cdots, x_n) = P \{\xi_1(\omega) < x_1, \xi_2(\omega) < x_2, \cdots, \xi_n(\omega) < x_n\}
    $$

    为随机向量 $\boldsymbol{\xi}(\omega) = (\xi_1(\omega), \xi_2(\omega), \cdots, \xi_n(\omega))$ 的联合分布函数。

- **「联合分布函数的性质」**：完全可以类似于一元的情形：
    1. **单调性**：联合分布函数 $F(x_1, x_2, \cdots, x_n)$ 关于每个变量都是单调不减的；
    2. $F(-\infty, x_2, \cdots, x_n) = 0$，$F(+\infty, +\infty, \cdots, +\infty) = 1$；
    3. **左连续性**：关于每个变量左连续，也就是 $F(x_1 - 0, x_2, \cdots, x_n) = F(x_1, x_2, \cdots, x_n)$；
    4. 对任意 $a_1 < b_1$，$a_2 < b_2$，都有 $F(b_1, b_2) - F(a_1, b_2) - F(b_1, a_2) + F(a_1, a_2) \geq 0$。

    其中第四条是必须的，这是为了保证 $P\{a_1 \leq \xi_1 < b_1, a_2 \leq \xi_2 < b_2\} \geq 0$。并且第四条可以推出单调性，单调性并不能保证第四条。同时，满足后三条性质的二元函数也一定是某个二维随机变量的分布函数。这些结论对于 $n$ 元的情况也成立。

- **「连续型随机变量的情况」**：没啥特殊的，非负的**（多元分布）密度函数** $p(x_1, x_2, \cdots, x_n)$ 的分布函数为 $\displaystyle F(x_1, x_2, \cdots, x_n) = \int_{-\infty}^{x_1} \cdots \int_{-\infty}^{x_n} p(y_1, y_2, \cdots, y_n) \, \mathrm{d}y_1 \cdots \mathrm{d}y_n$。
- **「多元正态分布」**：
- **「边际分布」**：以二维随机向量 $\boldsymbol{\xi} = (\xi, \eta)$ 为例，若其为离散型分布，$\xi$ 取值 $x_1, x_2, \cdots$；$\eta$ 取值 $y_1, y_2, \cdots$，记 $P\{\xi = x_i, \eta = y_j\} = p(x_i, y_j)$，则对于固定的 $i$ 关于 $j$ 求和，就可以得到 $\xi$ 的概率分布 $p_1(x_i) = \sum\limits_{j} p(x_i, y_j) = P\{\xi = x_i\}$，同理可以求得 $p_2(y_j) = \sum\limits_{i} p(x_i, y_j) = P\{\eta = y_j\}$。这两个分布函数分别称为 $p(x_i, y_j)$ 的**边际分布**。对于连续型随机变量，若其分布函数为 $F(x, y)$，密度函数为 $p(x, y)$，可以得出 

    $$\begin{aligned}
    F_1(x) = P\{\xi < x\} = P\{\xi < x, \eta < +\infty\} = F(x, +\infty) = \int_{-\infty}^{x} \int_{-\infty}^{+\infty} p(u, y) \, \mathrm{d}v \, \mathrm{d}y \\ 
    F_2(y) = P\{\eta < y\} = P\{\xi < +\infty, \eta < y\} = F(+\infty, y) = \int_{-\infty}^{+\infty} \int_{-\infty}^{y} p(u, y) \, \mathrm{d}v \, \mathrm{d}y
    \end{aligned}$$

    并且其密度函数几乎显然：$p_1(x) = \displaystyle\int_{-\infty}^{+\infty} p(x, y) \, \mathrm{d}y$，$p_2(y) = \displaystyle\int_{-\infty}^{+\infty} p(x, y) \, \mathrm{d}x$。称为 $p(x, y)$ 的**边际密度函数**。

- **「二元正态分布」**：函数

    $$
    p(x, y) = \frac{1}{2 \pi \sigma_1 \sigma_2 \sqrt{1 - \rho^2}} \exp \left\{ -\frac{1}{2(1 - \rho^2)} \left[ \frac{(x - \mu_1)^2}{\sigma_1^2} - 2\rho \frac{(x - \mu_1)(y - \mu_2)}{\sigma_1 \sigma_2} + \frac{(y - \mu_2)^2}{\sigma_2^2} \right] \right\}
    $$

    这里 $\mu_1, \mu_2, \sigma_1, \sigma_2, \rho$ 为常数，$\sigma_1 > 0, \sigma_2 > 0, |\rho| < 1$，称为**二元正态（分布）密度函数**。简记为 $N(\mu_1, \mu_2, \sigma_1^2, \sigma_2^2, \rho)$。其有两个完全对称的典型分解：

    $$\begin{aligned}
    p(x, y) = \frac{1}{\sqrt{2 \pi} \sigma_1} e^{-\frac{(x - \mu_1)^2}{2 \sigma_1^2}} \times \frac{1}{\sqrt{2 \pi} \sigma_2 \sqrt{1 - \rho^2}} e^{-\frac{\left[y - \left(\mu_2 + \frac{\sigma_2}{\sigma_1} \rho (x - \mu_1)\right)\right]^2}{2 \sigma_2^2 (1 - \rho^2)}} \\
    p(x, y) = \frac{1}{\sqrt{2 \pi} \sigma_2} e^{-\frac{(y - \mu_2)^2}{2 \sigma_2^2}} \times \frac{1}{\sqrt{2 \pi} \sigma_1 \sqrt{1 - \rho^2}} e^{-\frac{\left[x - \left(\mu_1 + \frac{\sigma_1}{\sigma_2} \rho (y - \mu_2)\right)\right]^2}{2 \sigma_1^2 (1 - \rho^2)}}
    \end{aligned}$$ 

    第一个式子右边第一部分分为 $N(\mu_1, \sigma_1^2)$ 的密度函数，第二部分为 $N \left( \mu_2 + \frac{\sigma_2}{\sigma_1} \rho (x - \mu_1), \sigma_2^2(1 - \rho^2) \right)$ 的密度函数；第二个式子右边第一部分分为 $N(\mu_2, \sigma_2^2)$ 的密度函数，第二部分为 $N \left( \mu_1 + \frac{\sigma_1}{\sigma_2} \rho (y - \mu_2), \sigma_1^2(1 - \rho^2) \right)$ 的密度函数。并且通过计算边际分布密度得到

    $$
    p_1(x) = \int_{-\infty}^{+\infty} p(x, y) \, dy = \frac{1}{\sqrt{2 \pi} \sigma_1} e^{-(x - \mu_1)^2/2 \sigma_1^2}
    $$

    也就是说，二元正态分布的边际分布是正态分布。
    
- **「条件分布」**：离散型随机变量的**条件分布**很好理解，若已知 $\xi = x_i$，则事件 $\{\eta = y_j\}$ 的概率为 $P\{\eta = y_j \mid \xi = x_i\} = \dfrac{P\{\xi = x_i, \eta = y_j\}}{P\{\xi = x_i\}} = \dfrac{p(x_i, y_j)}{p_1(x_i)}$。对于一般的随机向量 $(\xi, \eta)$，虽然有 $P\{\xi = x\} = 0$，但是我们可以通过极限来定义：

    $$\begin{aligned}
        P\{\eta = y \mid \xi = x\} &= \lim_{\Delta x \to 0} P\{\eta < y \mid x \leq \xi < x + \Delta x\} \\
        &= \lim_{\Delta x \to 0} \frac{P\{x \leq \xi < x + \Delta x, \eta < y\}}{P\{x \leq \xi < x + \Delta x\}} \\
        &= \lim_{\Delta x \to 0} \frac{F(x + \Delta x, y) - F(x, y)}{F(x + \Delta x, +\infty) - F(x, +\infty)}
    \end{aligned}$$

    特别的，对于密度函数连续的情况，有

    $$\begin{aligned}
        P\{\eta < y \mid \xi = x\} &= \lim_{\Delta x \to 0} \frac{\displaystyle\int_{x}^{x + \Delta x} \int_{-\infty}^{y} p(u, v) \, \mathrm{d}v \, \mathrm{d}u}{\displaystyle\int_{x}^{x + \Delta x} \int_{-\infty}^{+\infty} p(u, v) \, \mathrm{d}v \, \mathrm{d}u} \\
        &= \lim_{\Delta x \to 0} \frac{\displaystyle\int_{-\infty}^{y} p(x, v) \, \mathrm{d}v}{p_1(x)} = \displaystyle\int_{-\infty}^{y} \frac{p(x, v)}{p_1(x)} \, \mathrm{d}v
    \end{aligned}$$

    因此我们可以得到在给定 $\xi = x$ 的情况下，$\eta$ 的条件分布密度函数为 $p(y \mid x) = \dfrac{p(x, y)}{p_1(x)}$。

- **「随机变量的独立性」**：设 $\xi_1, \xi_2, \cdots, \xi_n$ 是定义在同一概率空间上的随机变量，若对于任意的 $x_1. x_2, \cdots, x_n$ 有

    $$
    P\{\xi_1 < x_1, \xi_2 < x_2, \cdots, \xi_n < x_n\} = P\{\xi_1 < x_1\} P\{\xi_2 < x_2\} \cdots P\{\xi_n < x_n\}
    $$

    则称 $\xi_1, \xi_2, \cdots, \xi_n$ 为相互独立的。若我们知道其分布函数分别为 $F_1(x_1), F_2(x_2), \cdots, F_n(x_n)$，与联合分布函数 $F(x_1, x_2, \cdots, x_n)$，则独立性的定义可以转化为

    $$
    F(x_1, x_2, \cdots, x_n) = F_1(x_1) F_2(x_2) \cdots F_n(x_n)
    $$

    同时，随机变量 $\xi_1, \xi_2, \cdots, \xi_n$ 独立的充要条件是对于任意的一维 Borel 集合 $B_1, B_2, \cdots, B_n$，有

    $$
    P\{\xi_1 \in B_1, \xi_2 \in B_2, \cdots, \xi_n \in B_n\} = P\{\xi_1 \in B_1\} P\{\xi_2 \in B_2\} \cdots P\{\xi_n \in B_n\}
    $$

 
### 3. 随机变量的函数及其分布

- **「」**：
- **「」**：
- **「」**：
- **「随机向量的变换」**：若 $(\xi_1, \cdots, \xi_n)$ 的密度函数为 $p(x_1, \cdots, x_n)$，求 $\eta_1 = g_1(\xi_1, \cdots, \xi_n), \cdots, \eta_m = g_m(\xi_1, \cdots, \xi_n)$ 的分布。这时有

    $$\begin{aligned}
    G(y_1, \cdots, y_m) &= P\{\eta_1 < y_1, \cdots, \eta_m < y_m\} \\ 
    &= \int_{\substack{g_1(x_1, \cdots, x_n) < y_1 \\ \cdots \\ g_m(x_1, \cdots, x_n) < y_m}} p(x_1, \cdots, x_n) \mathrm{d}\,x_1 \cdots \mathrm{d}\,x_n
    \end{aligned}$$

    考虑一个重要的特殊情形：当 $(\xi_1, \cdots, \xi_n)$ 与 $(\eta_1, \cdots, \eta_m)$ 有一一对应变换关系时，当然这时 $n = m$ 必须成立。如果对 $y_i = g_i(x_1, \cdots, x_n)$ 都存在唯一的**反函数** $x_i = x_i(y_1, \cdots, y_n) = x_i$，并且设 $(\eta_1, \cdots, \eta_n)$ 的密度函数为 $q(y_1, \cdots, y_n)$，则有

    $$
    G(y_1, \cdots, y_n) = \int_{\substack{u_1 < y_1 \\ \cdots \\ u_n < y_n}} q(u_1, \cdots, u_n) \mathrm{d}\,u_1 \cdots \mathrm{d}\,u_n
    $$

    所以这时就有（要求 $(y_1, \cdots, y_n)$ 落在 $(g_1, \cdots, g_n)$ 的值域内）

    $$
    q(y_1, \cdots, y_n) = p(x_1(y_1, \cdots, y_n), \cdots, x_n(y_1, \cdots, y_n)) \left| J \right|
    $$

    其中 $J$ 为**雅可比行列式**，即
    
    $$J = \begin{vmatrix}
    \dfrac{\partial x_1}{\partial y_1} & \cdots & \dfrac{\partial x_1}{\partial y_n} \\
    \vdots & \ddots & \vdots \\
    \dfrac{\partial x_n}{\partial y_1} & \cdots & \dfrac{\partial x_n}{\partial y_n}
    \end{vmatrix}$$



- **「随机变量的函数的独立性」**：若 $\xi_1, \cdots, \xi_n$ 是相互独立的随机变量，则 $f_1(\xi_1), \cdots, f_n(\xi_n)$ 也是相互独立的，这里 $f_i (i = 1, \cdots, n)$ 是任意的一元博雷尔函数。值得注意的是，这个结果可以被推广到随机向量的情形。

    ???- Info "Proof"

        对任意的一维博雷尔点集 $A_1, \cdots, A_n$ 有

        $$\begin{aligned}
            P\{f_1(\xi_1) \in A_1, \cdots, f_n(\xi_n) \in A_n\} &= P\{\xi_1 \in f_1^{-1}(A_1), \cdots, \xi_n \in f_n^{-1}(A_n)\} \\
            &= P\{\xi_1 \in f_1^{-1}(A_1)\} \cdots P\{\xi_n \in f_n^{-1}(A_n)\} \\
            &= P\{f_1(\xi_1) \in A_1\} \cdots P\{f_n(\xi_n) \in A_n\}
        \end{aligned}$$   

- **「$\chi^2$分布」**：
- **「Rayleigh 分布」**：
- **「」**：



## Exercises

1. 还没写
2. 还没写
3. 还没写
4. 还没写
5. 对下面的二元正态分布，将其化为标准形式，指出 $\mu_1$，$\mu_2$，$\sigma_1^2$，$\sigma_2^2$，$\rho$ 的值；并且求关于 $x$ 的边际密度函数 $p_1(x)$ 与条件密度函数 $p(x \mid y)$。 

    $$
    p(x, y) = \frac{1}{2\pi} \exp \left\{ -\frac{1}{2} \left( 2x^2 + y^2 + 2xy - 22x - 14y + 65 \right) \right\}
    $$

6. （Mill's Inequality）证明：对于服从标准正态分布的随机变量 $\xi$，有
    $$
    \dfrac{1}{\sqrt{2\pi}} \cdot \left(\dfrac{1}{x} - \dfrac{1}{x^3}\right) e^{-x^2/2} < P(\xi > x) < \dfrac{1}{\sqrt{2\pi}} \cdot \dfrac{1}{x} e^{-x^2/2}
    $$

    ???+ Info "Answer"
        1. 不等式左侧：激情分部积分

            $$
            \begin{aligned}
            \int_x^\infty e^{-t^2/2}\, dt &= \int_x^\infty \frac{1}{t}\cdot t e^{-t^2/2}\, dt \\
            &= \left[ \frac{1}{t} \cdot \int te^{-t^2/2}\, dt \right]_x^\infty - \int_x^\infty \left( \frac{1}{t} \right)' \left( \int te^{-t^2/2}\, dt \right) dt \\
            &= \frac{e^{-x^2/2}}{x} - \int_x^\infty \frac{e^{-t^2/2}}{t^2}\, dt
            \end{aligned}
            $$

            前半部分已经搞定了，下面积分后半部分：

            $$
            \begin{aligned}
            \int_x^\infty \frac{e^{-t^2/2}}{t^2}\, dt &= \int_x^\infty \frac{1}{t^3} \cdot te^{-t^2/2}\, dt \\
            &= \left[ \frac{1}{t^3} \cdot \int te^{-t^2/2}\, dt \right]_x^\infty - \int_x^\infty \left( \frac{1}{t^3} \right)' \left( \int te^{-t^2/2}\, dt \right) dt\\
            &= \frac{e^{-x^2/2}}{x^3} - 3\int_x^\infty \frac{e^{-t^2/2}}{t^4}\, dt
            \end{aligned}
            $$

            由于 $\dfrac{e^{-t^2/2}}{t^4}$ 一定恒为正的，合起来就有

            $$
            \begin{aligned}
            \int_x^\infty e^{-t^2/2}\, dt &= e^{-x^2/2} \left( \frac{1}{x} - \frac{1}{x^3} \right) + 3 \int_x^\infty \frac{e^{-t^2/2}}{t^4}\, dt \\
            &> e^{-x^2/2} \left( \frac{1}{x} - \frac{1}{x^3} \right)
            \end{aligned}
            $$

        2. 不等式右侧：还是激情分部积分

            $$
            \begin{aligned}
            \int_x^\infty e^{-t^2/2}\, dt &= \dfrac{1}{x} \int_x^\infty xe^{-t^2/2}\, dt \\
            &< \dfrac{1}{x} \int_x^\infty te^{-t^2/2}\, dt \\ 
            &= \dfrac{1}{x} e^{-x^2/2}
            \end{aligned}
            $$


<!-- ### Chapter 4 -->

<!-- ???+ Info "Answer"
    
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer"
    ???+ Info "Answer" -->




