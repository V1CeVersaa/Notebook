# Chapter 5 大数定律与中心极限定理

## Knowledge

### 1. 伯努利试验中的极限定理

**「中心极限定理」**：设 $\{\xi_n\}$ 是一列随机变量，如果存在常数 $B_n > 0$ 和 $A_n$，使得

$$
\frac1{B_N} \sum_{k=1}^n \xi_k - A_n \stackrel{d}{\longrightarrow} \xi,
$$

就称 $\{\xi_n\}$ 服从中心极限定理。

**「弱大数定律」**：设 $\{\xi_n\}$ 是一列的随机变量，

**「棣莫弗-拉普拉斯定理」**：令 $\mu_n$ 为 $n$ 次伯努利试验中事件 $A$ 出现的次数，$p$ 为事件 $A$ 出现的概率，$q=1-p$，则对于任意有限区间 $[a, b]$，一致地有

$$
\lim_{n\to\infty} P\left\{a\leq \dfrac{\mu_n-np}{\sqrt{npq}} < b\right\} = \int_a^b \dfrac{1}{\sqrt{2\pi}} e^{-x^2/2} dx = \Phi(b) - \Phi(a).
$$

上式被称为**积分极限定理**。

**「Bernoulli 大数定律」**：给定 $0 < p < 1$，$n$ 次独立伯努利试验中事件 $A$ 出现的次数为 $\mu_n$，那么 $n\to\infty$ 的时候

$$  
P\left\{\left|\dfrac{\mu_n}{n} - p\right| \leq \varepsilon\right\} \to 1 \text{ or } \dfrac{\mu_n}{n} \stackrel{P}{\longrightarrow} p.
$$

**「Possion 极限定理」**：令 $0 < p_n < 1$，假设 $\mu_n \sim B(n, p_n)$，如果 $np_n \to \lambda$，并且 $0 < \lambda < \infty$，那么对任何 $k = 0, 1, 2, \cdots$，当 $n\to\infty$ 的时候

$$
P(\mu_n = k) \to \dfrac{\lambda^k}{k!} e^{-\lambda}.
$$


### 2. 独立随机变量的中心极限定理

**「Levy-Feller 中心极限定理」**：设 $\{\xi_n\}$ 是一列**独立同分布**的随机变量，$E\xi_1 = \mu$，$D\xi_1 = \sigma^2$（也就是我们需要知道数学期望和方差），$S_n = \sum\limits_{k=1}^n \xi_k$，则中心极限定理成立：

$$
P\left(\dfrac{S_n - n\mu}{\sigma\sqrt{n}} < x\right) \to \Phi(x) \text{ or } \frac{S_n - n\mu}{\sigma\sqrt{n}} \stackrel{d}{\longrightarrow} N(0, 1).
$$

!!! Note

    1. Levy-Feller 中心极限定理显然比棣莫弗-拉普拉斯定理更强。
    2. 连续 $n$ 次观测，真值为 $\mu$，方差为 $\sigma^2$，$n$ 次观测误差叠加，总共误差为 $X = \sum\limits_{k=1}^n \xi_k = \sum\limits_{k=1}^n (\xi_k - \mu)$，那么 $X\sim N(0, n\sigma^2)$，直接从 Levy-Feller 中心极限定理得到。

**「Lyapunov 中心极限定理」**：设 $\{\xi_n\}$ 是一列**独立**随机变量（不一定同分布），$E\xi_k = \mu_k$，$D\xi_k = \sigma_k^2$，$B_n = \sum\limits_{k=1}^n \sigma_k^2$，$S_n = \sum\limits_{k=1}^n \xi_k$，如果

- $B_n \to \infty$，
- $E\lvert \xi_k \rvert^3 < \infty$，且在 $n\to\infty$ 的时候 $\sum\limits_{k=1}^n E\lvert \xi_k\rvert ^3/B_n^{3/2} \to 0$

那么对于任意 $x\in\mathbb{R}$，有

$$
P\left(\dfrac{\sum_{k=1}^n (\xi_k - \mu_k)}{\sqrt{B_n}} \leq  x\right) \to \Phi(x) \text{ or } \dfrac{\sum_{k=1}^n (\xi_k - \mu_k)}{\sqrt{B_n}} \stackrel{d}{\longrightarrow} N(0, 1).
$$

**「Khintchine 大数定律」**：设 $\{\xi_n\}$ 是一列**独立同分布**的随机变量，$E\xi_1 = \mu$，那么

$$
\dfrac1n \sum\limits_{k=1}^n \xi_k \stackrel{P}{\longrightarrow} \mu.
$$

### 3. 收敛性

**「弱收敛」**：设 $F$ 为一个分布函数，$\{F_n\}$ 为一列分布函数，如果对于 $F$ 的任意连续点 $x\in\mathbb{R}$，当 $n\to\infty$ 的时候都有 $F_n(x) \to F(x)$，则称 $\{F_n\}$ 弱收敛于 $F$，记为 $F_n \stackrel{w}{\longrightarrow} F$。

**「依分布收敛」**：设 $\xi$ 为一个随机变量，$\{\xi_n\}$ 为一列随机变量，如果 $\xi_n$ 的分布函数弱收敛于 $\xi$ 的分布函数，则称 $\{\xi_n\}$ 依分布收敛于 $\xi$，记为 $\xi_n \stackrel{d}{\longrightarrow} \xi$。

**「依概率收敛」**：对于随机变量 $\xi$ 和随机变量列 $\{\xi_n\}$，如果对于任意 $\varepsilon > 0$，有

$$
\lim_{n\to\infty} P\left\{\left|\xi_n - \xi\right| < \varepsilon\right\} = 1 \text{ or } \lim_{n\to\infty} P\left\{\left|\xi_n - \xi\right| \geq \varepsilon\right\} = 0,
$$

则称 $\xi_n$ 依概率收敛于 $\xi$，记为 $\xi_n \stackrel{P}{\longrightarrow} \xi$。

**「极限唯一性」**：假设 $\xi_n \stackrel{P}{\longrightarrow} \eta$，$\xi_n \stackrel{P}{\longrightarrow} \zeta$，则 $P(\eta = \zeta) = 1$。

!!! Info "Proof"

    只需要证明 $P(\eta \neq \zeta) = 0$ 即可。注意到 

    $$\begin{aligned}
    P(\eta \neq \zeta) &= P(\lvert \eta - \zeta \rvert > 0) = P(\bigcup_{n=1}^\infty \lvert \eta - \zeta \rvert > 1/n) 
    \end{aligned}$$

    所以我们只需要证明对于任意 $\varepsilon > 0$，有 $P(\lvert \eta - \zeta \rvert > \varepsilon) = 0$。

    给定 $\varepsilon > 0$，对任意的 $n \geq 1$，有

    $$\begin{aligned}
    P(\lvert \eta - \zeta \rvert > \varepsilon) &= P(\lvert \xi_n - \eta - \xi_n + \zeta \rvert > \varepsilon) \\ 
    &\leq P(\lvert \xi_n - \eta \rvert + \lvert \xi_n - \zeta \rvert > \varepsilon) \\
    &\leq P(\lvert \xi_n - \eta \rvert > \varepsilon/2) + P(\lvert \xi_n - \zeta \rvert > \varepsilon/2).
    \end{aligned}$$

    令 $n\to\infty$，由依概率收敛的定义，有 $P(\lvert \xi_n - \eta \rvert > \varepsilon/2) \to 0$ 和 $P(\lvert \xi_n - \zeta \rvert > \varepsilon/2) \to 0$，所以 $P(\lvert \eta - \zeta \rvert > \varepsilon) = 0$。

**「r 阶收敛推出依概率收敛」**：如果存在某个 $r > 0$，使得当 $n\to\infty$ 的时候 $E\lvert \xi_n - \xi \rvert^r \to 0$，则 $\xi_n \stackrel{P}{\longrightarrow} \xi$。这直接通过马尔可夫不等式可以知道。

**「依概率收敛的运算性质」**：如果 $\xi_n \stackrel{P}{\longrightarrow} \xi$，$\eta_n \stackrel{P}{\longrightarrow} \eta$，那么 $\xi_n + \eta_n \stackrel{P}{\longrightarrow} \xi + \eta$，$\xi_n \eta_n \stackrel{P}{\longrightarrow} \xi \eta$，如果 $P(\eta \neq 0) = 1$，那么 $\xi_n/\eta_n \stackrel{P}{\longrightarrow} \xi/\eta$。

**「连续映射保持依概率收敛」**：如果 $f\colon \mathbb{R} \to \mathbb{R}$ 是一个连续函数，$\xi_n \stackrel{P}{\longrightarrow} \xi$，那么 $f(\xi_n) \stackrel{P}{\longrightarrow} f(\xi)$。

!!! Info "Proof"

**「海莱第一定理」**：设 $\{F_n\}$ 是一列分布函数，那么存在一个**单调不减右连续**的函数 $F$，$0\leq F(x) \leq 1$，$\forall x\in\mathbb{R}$，和一子列 $\{F_{n_k}\}$，使得对 $F$ 的每个连续点 $x$，$F_{n_k}(x)\to F(x)$（$k\to\infty$）。

**「海莱第二定理」**：设 $F$ 是一个分布函数，$\{F_n\}$ 是一列分布函数，$F_n \stackrel{w}{\longrightarrow} F$。如果 $g(x)$ 是 $\mathbb{R}$ 上的有界连续函数，则

$$
\int_{-\infty}^\infty g(x) dF_n(x) \to \int_{-\infty}^\infty g(x) dF(x).
$$

设 $F, F_n$ 是**单调不减右连续**函数（不一定是分布函数），并且对于 $F$ 的任一连续点 $x$ 有 $F_n(x) \to F(x)$。如果 $a < b$ 是 $F$ 的连续点，$g(x)$ 是 $[a, b]$ 上的连续函数，则

$$
\int_a^b g(x) dF_n(x) \to \int_a^b g(x) dF(x).
$$

**「勒维连续性定理/正极限定理」**：设 $F$ 为一个分布函数，$\{F_n\}$ 为一列分布函数，如果 $F_n \stackrel{w}{\longrightarrow} F$，则相应的特征函数列 $\{f_n(t)\}$ 收敛于特征函数 $f(t)$，且在 $t$ 的任何一个有限区间内收敛是一致的。

**「逆极限定理」**：设特征函数列 $\{f_n(t)\}$ 收敛于特征函数 $f(t)$，且 $f(t)$ 在 $t=0$ 处连续，则相应的分布函数列 $\{F_n\}$ **弱收敛**于某一个分布函数 $F(x)$，且 $f(t)$ 一定是 $F(x)$ 的特征函数。









## Exercise

**棣莫弗-拉普拉斯定理推导伯努利大数定律**：

**已知** $n$、$p$、$\varepsilon$ **求概率** $P\left\{\left|\dfrac{\mu_n}{n}-p\right| < \varepsilon\right\}$。

**要使** $\dfrac{\mu_n}{n}$ **与** $p$ **的差异不大于预先给定的数** $\beta$，问至少应该做多少次实验？

**已知** $n$、$\beta$，求 $\varepsilon$，这和误差估计有关。
