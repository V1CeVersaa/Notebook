# Chapter 2: Basic Probability Inequalities for Sums of Independent Random Variables

我们希望对经验均值显著偏离数学期望的事件进行上界的估计，其对应的概率被称为**尾概率**，下面我们将要研究使用指数矩估计来估计尾概率的基本数学工具。

令 $X_1, \ldots, X_n$ 为 $n$ 个独立同分布的实值随机变量，每一个的数学期望都为 $\mu = \mathbb{E}X_i$。令 

$$
\bar{X}_n = \frac{1}{n} \sum_{i=1}^{n} X_i.
$$

给定 $\epsilon > 0$，我们感兴趣的是估计以下尾概率：

$$\begin{aligned}
\operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon), \\
\operatorname*{Pr}(\bar{X}_n \le \mu - \epsilon).
\end{aligned}$$

在机器学习中，我们可以将 $\bar{X}_n$ 视为在训练数据上观察到的训练误差。未知的均值 $\mu$ 是我们希望从训练误差中推断出的测试误差。因此，在机器学习中，这些尾不等式可以解释为：高概率下，测试误差接近训练误差。这样的结果将被用于推导后续章节中的泛化误差界的严格陈述。

### 2.1 正态随机变量

对于具有相对轻尾的随机变量之和的尾不等式，其一般形式一般是 $\epsilon^2$ 的指数形式，我们将尾部分布在远离均值的情况下下降更快的随机变量称为具有相对轻尾的随机变量，正态分布是具有轻尾的随机变量的一个例子。

**定理**：令 $X_1, \ldots, X_n$ 为 $n$ 个独立同分布的正态随机变量，$X_i \sim N(\mu, \sigma^2)$，令 $\bar{X}_n = n^{-1} \sum_{i=1}^{n} X_i$。那么对于任意的 $\epsilon > 0$，

$$
\frac{1}{2} e^{-n(\epsilon + \sigma/\sqrt{n})^2/2\sigma^2} \le \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) \le \frac{1}{2} e^{-n\epsilon^2/2\sigma^2}.
$$

!!! Info "证明"

    首先考虑标准正态随机变量 $X \sim N(0, 1)$，其概率密度函数为

    $$
    p(x) = \frac{1}{\sqrt{2\pi}} e^{-x^2/2}.
    $$

    对于任意的 $\epsilon > 0$，我们可以将尾概率 $\operatorname*{Pr}(X \ge \epsilon)$ 上界如下放缩：

    $$\begin{aligned}
    \operatorname*{Pr}(X \ge \epsilon) & = \int_{\epsilon}^{\infty} \frac{1}{\sqrt{2\pi}} e^{-x^2/2} \,\mathrm{d}x \\
    & = \int_{0}^{\infty} \frac{1}{\sqrt{2\pi}} e^{-(x+\epsilon)^2/2} \,\mathrm{d}x \leq \int_{0}^{\infty} \frac{1}{\sqrt{2\pi}} e^{-(x^2 + \epsilon^2)/2} \,\mathrm{d}x \\
    & = \frac{1}{2} e^{-\epsilon^2/2}.
    \end{aligned}$$

    下界也可以类似放缩：

    $$\begin{aligned}
    \operatorname*{Pr}(X \ge \epsilon) & = \int_{\epsilon}^{\infty} \frac{1}{\sqrt{2\pi}} e^{-x^2/2} \,\mathrm{d}x \\
    & \ge \int_{0}^{1} \frac{1}{\sqrt{2\pi}} e^{-(x+\epsilon)^2/2} \,\mathrm{d}x \\ 
    & \ge \int_{0}^{1} \frac{1}{\sqrt{2\pi}} e^{-x^2/2} e^{-(2\epsilon + \epsilon^2)/2} \,\mathrm{d}x \\
    & \ge 0.34 e^{-(2\epsilon + \epsilon^2)/2} \ge \frac{1}{2} e^{-(\epsilon + 1)^2/2}.
    \end{aligned}$$

    因此我们就有了 

    $$
    \frac{1}{2} e^{-(\epsilon + 1)^2/2} \le \operatorname*{Pr}(X \ge \epsilon) \le \frac{1}{2} e^{-\epsilon^2/2}.
    $$

    由于 $\sqrt{n}(\bar{X}_n - \mu)/\sigma \sim N(0, 1)$，我们可以得到

    $$
    \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) = \operatorname*{Pr}\left(\sqrt{n}(\bar{X}_n - \mu)/\sigma \ge \sqrt{n}\epsilon/\sigma\right)
    $$

    这就得到了我们想要的结果。

我们注意到正态随机变量的尾概率以指数速率衰减，这样的不等式被称为指数不等式。这种不等式的指数上界是**渐进紧/Asymptotically Tight**的，当 $n \rightarrow \infty$，对任意的 $\epsilon > 0$，我们有

$$
\lim\limits_{n \rightarrow \infty} \frac{1}{n} \ln \operatorname*{Pr}(\lvert \bar{X}_n - \mu \rvert \ge \epsilon) = -\frac{\epsilon^2}{2\sigma^2}.
$$

这样的结果也被称为大偏差结果/Large Deviation Result，其适用于当经验均值和真实均值 $\mu$ 的偏差远大于 $\bar{X}_n$ 的标准差 $\sigma/\sqrt{n}$ 的时候。对于正态随机变量的分析，我们可以完全依赖标准的微积分技巧，对于一般的具有指数衰减尾概率的一般随机变量，我们可以使用指数矩/Exponential Moment 技术来推导类似的结果，这种技术可以用来估计样本均值和真实均值的大偏差的概率。

### 2.2 马尔可夫不等式

估计一般的随机变量的尾概率的一个标准技巧就是 Markov 不等式，令 $X_1, \ldots, X_n$ 为 $n$ 个实值独立同分布的随机变量，其均值为 $\mu$。令 $\bar{X}_n$ 为经验均值，我们感兴趣的是估计尾概率 $\operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon)$，Markov 不等式给出了如下的结果：

**定理**（马尔可夫不等式）：对于任意的非负函数 $h(x) \ge 0$ 和一个集合 $S \subset \mathbb{R}$，我们有

$$
\operatorname*{Pr}(\bar{X}_n \in S) \le \frac{\mathbb{E}h(\bar{X}_n)}{\inf_{x \in S} h(x)}.
$$

!!! Info "证明"

    既然 $h(x)$ 是非负的，我们有

    $$
    \mathbb{E}h(\bar{X}_n) \ge \mathbb{E}_{\bar{X}_n \in S} h(\bar{X}_n) \ge \mathbb{E}_{\bar{X}_n \in S} \inf_{x \in S} h(x) = \operatorname*{Pr}(\bar{X}_n \in S) \inf_{x \in S} h(x).
    $$

    这就完成了证明。

**定理**（切比雪夫不等式）：我们有

$$
\operatorname*{Pr}(\lvert \bar{X}_n - \mu \rvert \ge \epsilon) \le \frac{\operatorname*{Var}(X_1)}{n\epsilon^2}.
$$

!!! Info "证明"

    令 $h(x) = x^2$，我们有

    $$
    \mathbb{E}h(\bar{X}_n) = \mathbb{E}(\bar{X}_n - \mu)^2 = \frac{1}{n^2} \sum_{i=1}^{n} \mathbb{E}(X_i - \mu)^2 = \frac{1}{n}\operatorname*{Var}(X_1).
    $$

注意到，在切比雪夫不等式之中，我们使用了 $h(x) = x^2$，这样的不等式是关于 $n^{-1}$ 和 $\epsilon$ 的多项式形式，并且只要求随机变量的方差有界。作为对比，高斯尾概率有着更快的指数衰减。

### 2.3 指数尾不等式

为了得到指数级别的尾概率界，我们需要选择 $h(x) = e^{\lambda n x}$，其中 $\lambda \in \mathbb{R}$ 是某个调节参数。类似于切比雪夫不等式对随机变量方差有界的要求，我们要求随机变量的指数矩 $\mathbb{E}e^{\lambda X_1} < \infty$。这就隐含了随机变量 $X_i$ 的尾概率以指数速率衰减。我们可以定义如下的指数矩生成函数：

**定义**：给定一个随机变量 $X$，我们可以定义其**对数矩生成函数/Logarithmic Moment Generating Function** 为

$$
\Lambda_X(\lambda) = \ln \mathbb{E}e^{\lambda X}.
$$

对于任意的 $z \in \mathbb{R}$，我们可以定义**率函数/Rate Function** 为

$$
I_X(z) = \begin{cases}
\sup_{\lambda > 0} [\lambda z - \Lambda_X(\lambda)], & z > \mu, \\
0, & z = \mu, \\
\sup_{\lambda < 0} [\lambda z - \Lambda_X(\lambda)], & z < \mu,
\end{cases}
$$

其中 $\mu = \mathbb{E}X$。

**定理**：对于任意的 $n$ 和 $\epsilon > 0$，

$$\begin{aligned}
\frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) & \le -I_X(\mu + \epsilon) = \inf_{\lambda > 0} [-\lambda(\mu + \epsilon) + \Lambda_X(\lambda)], \\
\frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n \le \mu - \epsilon) & \le -I_X(\mu - \epsilon) = \inf_{\lambda < 0} [-\lambda(\mu - \epsilon) + \Lambda_X(\lambda)].
\end{aligned}$$

!!! Info "证明"

    我们选择 $h(z) = e^{\lambda n z}$，$S = \{\bar{X}_n - \mu \ge \epsilon\}$，使用马尔可夫不等式。对于 $\lambda > 0$，我们有

    $$\begin{aligned}
    \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) & \le \frac{\mathbb{E}e^{\lambda n \bar{X}_n}}{\mathbb{E}e^{\lambda n X_1}} = \frac{\mathbb{E}e^{\lambda \sum_{i=1}^{n} X_i}}{e^{\lambda n \mu}} \\ 
    & = \frac{\mathbb{E}\prod_{i=1}^{n} e^{\lambda X_i}}{e^{\lambda n(\mu + \epsilon)}} = e^{-\lambda n(\mu + \epsilon)} \left[\mathbb{E}e^{\lambda X_1}\right]^n.
    \end{aligned}$$

    最后一个等式使用了 $X_i$ 的独立同分布性质。取对数，我们得到 

    $$
    \ln \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) \le n\left[-\lambda (\mu + \epsilon) + \ln \mathbb{E}e^{\lambda X_1}\right].
    $$

    对所有的 $\lambda > 0$ 取 $\inf$，我们就得到了第一个不等式。类似的，我们可以得到第二个不等式。

第一个不等式可以重写为

$$
\operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) \le \exp[-nI_X(\mu + \epsilon)].
$$

这就表明了如果率函数 $I_X(\cdot)$ 是有限的，那么经验均值的尾概率以指数速率衰减。更具体的指数尾不等式可以通过将上面的定理应用到特定的随机变量上得到。比如对于正态随机变量，我们可以算出

$$\begin{aligned}
\mathbb{E}e^{\lambda (X_1 - \mu)} & = \int_{-\infty}^{\infty} \frac{1}{\sqrt{2\pi}\sigma} e^{\lambda x} e^{-x^2/2\sigma^2} \,\mathrm{d}x \\
& = \int_{-\infty}^{\infty} \frac{1}{\sqrt{2\pi}} e^{\lambda^2 \sigma^2/2} e^{-(x/\sigma - \lambda\sigma)^2/2} \,\mathrm{d}x/\sigma = e^{\lambda^2 \sigma^2/2}.
\end{aligned}$$

这里第一个等式使用了匿名统计学家公式，我在概率论的期末考试就忘记了这个公式 QAQ。因此率函数就为

$$
I_{X_1}(\mu + \epsilon) = \sup\limits_{\lambda > 0} [\lambda \epsilon - \ln \mathbb{E}e^{\lambda(X_1 - \mu)}] = \sup\limits_{\lambda > 0} \left[\lambda \epsilon - \frac{\lambda^2 \sigma^2}{2}\right] = \frac{\epsilon^2}{2\sigma^2}.
$$

其中极值在 $\lambda = \epsilon/\sigma^2$ 处取得，因此我们得到

$$
\operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) \le \exp[-nI_{X_1}(\mu + \epsilon)] = \exp\left[-n\epsilon^2/2\sigma^2\right].
$$

这就得到了和本章最开始得到的内容一致的概率界，只是相差一个常数因子。这个例子和最开始的定理表明了我们在上个定理刚刚证明的指数不等式是渐进紧的。这个结果可以推广到一般的随机变量的大偏差不等式，我们有如下的定理。

**定理**：对于所有的 $\epsilon^\prime > \epsilon > 0$，我们有

$$\begin{aligned}
\liminf\limits_{n \rightarrow \infty} \frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) & \ge -I_X(\mu + \epsilon^\prime), \\
\liminf\limits_{n \rightarrow \infty} \frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n \le \mu - \epsilon) & \ge -I_X(\mu - \epsilon^\prime).
\end{aligned}$$

!!! Info "证明"

    我们只需要证明第一个不等式。考虑 $\operatorname*{Pr}(X_i \le x)$ 作为 $x$ 的函数，并定义一个随机变量 $X_i^\prime$，其在 $x$ 处的密度为

    $$
    \mathrm{d} \operatorname*{Pr}(X_i^\prime \le x) = e^{\lambda x - \Lambda_{X_1}(\lambda)} \,\mathrm{d} \operatorname*{Pr}(X_i \le x).
    $$

    注意到对数矩生成函数是这样定义的

    $$
    \Lambda_{X_1}(\lambda) = \ln \mathbb{E}e^{\lambda X_1} = \ln \int e^{\lambda x} \,\mathrm{d} \operatorname*{Pr}(X_1 \le x).
    $$

    这样随机变量的选择就表明

    $$
    \frac{\mathrm{d}}{\mathrm{d}\lambda} \Lambda_{X_1}(\lambda) = \frac{\displaystyle\int x e^{\lambda x} \,\mathrm{d} \operatorname*{Pr}(X_1 \le x)}{\displaystyle\int e^{\lambda x} \,\mathrm{d} \operatorname*{Pr}(X_1 \le x)} = \int x e^{\lambda x} \,\mathrm{d} \operatorname*{Pr}(X_1 \le x) \cdot e^{-\Lambda_{X_1}(\lambda)} = \mathbb{E}_{X_1^\prime}X_1^\prime.
    $$

    取 $\lambda$ 使得 $\lambda = \operatorname*{\arg\max}\limits_{\lambda^\prime > 0} [\lambda^\prime(\mu + \epsilon^\prime) - \Lambda_{X_1}(\lambda^\prime)]$，我们就得到了

    $$\begin{aligned}
    \mathbb{E}_{X_1^\prime}X_1^\prime = \frac{\mathrm{d}}{\mathrm{d}\lambda} \Lambda_{X_1}(\lambda) & = \mu + \epsilon^\prime, \\
    -\lambda(\mu + \epsilon^\prime) + \Lambda(\lambda) & = -I(\mu + \epsilon^\prime).
    \end{aligned}$$

    令 $\bar{X}_n^\prime = n^{-1} \sum_{i=1}^{n} X_i^\prime$，根据大数定律，我们知道对于任意的 $\epsilon^{\prime\prime} > \epsilon^\prime$，有

    $$
    \lim\limits_{n \rightarrow \infty} \operatorname*{Pr}(\bar{X}_n^\prime - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}]) = 1.
    $$

    由于 $(X_1^\prime, \ldots, X_n^\prime)$ 的联合密度满足

    $$
    e^{-\lambda\sum_{i=1}^{n} x_i + n\Lambda_{X_1}(\lambda)} \prod\limits_i \,\mathrm{d} \operatorname*{Pr}(X_i \le x_i) = \prod\limits_i \,\mathrm{d} \operatorname*{Pr}(X_i^\prime \le x_i).
    $$

    使用 $\mathbb{1}(\cdot)$ 表示指示函数，我们有

    $$\begin{aligned}
    \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) & \ge \operatorname*{Pr}(\bar{X}_n^\prime - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}]) \\
    & = \mathbb{E}_{X_1, \ldots, X_n} \mathbb{1}(\bar{X}_n - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}]) \\
    & = \mathbb{E}_{X_1^\prime, \ldots, X_n^\prime} e^{-\lambda n\bar{X}_n^\prime + n\Lambda(\lambda)} \mathbb{1}(\bar{X}_n^\prime - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}]) \\
    &\ge e^{-\lambda n(\mu + \epsilon^\prime) + n\Lambda(\lambda)} \operatorname*{Pr}(\bar{X}_n^\prime - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}])
    \end{aligned}$$

    第一个等式使用了概率的定义，第二个等式使用了上面联合概率密度的性质，第三个不等式使用了马尔可夫不等式。取对数两面都除以 $n$，可以得到

    $$\begin{aligned}
    \frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) & \ge -\lambda(\mu + \epsilon^{\prime\prime}) + \Lambda(\lambda) + \frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n^\prime - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}]) \\
    & = -I(\mu + \epsilon^{\prime}) - \lambda(\epsilon^{\prime\prime} - \epsilon^{\prime}) + \frac{1}{n} \ln \operatorname*{Pr}(\bar{X}_n^\prime - \mu \in [\epsilon^\prime, \epsilon^{\prime\prime}]).
    \end{aligned}$$

    对 $n$ 取极限，令 $\epsilon^{\prime\prime} \rightarrow \epsilon^{\prime}$，我们就得到了我们想要的结果。

**命题**：对于一个具有有限方差的随机变量，我们有

$$
\Lambda_X(\lambda)\Big|_{\lambda = 0} = \mu, \quad \frac{\mathrm{d}\Lambda_X(\lambda)}{\mathrm{d}\lambda}\Big|_{\lambda = 0} = \operatorname*{Var}(X), \quad \frac{\mathrm{d}^2\Lambda_X(\lambda)}{\mathrm{d}\lambda^2}\Big|_{\lambda = 0} = \operatorname*{Var}(X).
$$

**引理**：考虑一个随机变量 $X$，其均值为 $\mu$，存在一个 $\alpha > 0$ 和 $\beta \ge 0$，使得对于所有的 $\lambda \in [0, \beta^{-1})$，我们有

$$
\Lambda_X(\lambda) \le \lambda \mu + \frac{\alpha \lambda^2}{2(1 - \beta \lambda)}.
$$

那么对于任意的 $\epsilon > 0$，我们有

$$\begin{aligned}
&-I_X(\mu + \epsilon) \le -\frac{\epsilon^2}{2(\alpha + \beta \epsilon)}, \\
&-I_X(\mu + \epsilon + \frac{\beta \epsilon^2}{2\alpha}) \le -\frac{\epsilon^2}{2\alpha}.
\end{aligned}$$

**定理**：如果对于 $\lambda > 0$，$X_1$ 的对数矩生成函数满足引理中的条件，那么对于所有的 $\epsilon > 0$，我们有

$$
\operatorname*{Pr}(\bar{X}_n \ge \mu + \epsilon) \le \exp\left[-\frac{n\epsilon^2}{2(\alpha + \beta \epsilon)}\right].
$$

并且，对于所有的 $t > 0$，我们有

$$
\operatorname*{Pr}\left(\bar{X}_n \ge \mu + \sqrt{\frac{2\alpha t}{n}} + \frac{\beta t}{n}\right) \le e^{-t}.
$$

<!--
The combination of Theorem 2.5 and Theorem 2.7 shows that the large devia-
tion tail probability is determined by the rate function. This result is referred to
as Cram´er’s theorem (Cram´er, 1938; Deuschel and Stroock, 2001).
¯
For specific cases, one can obtain an estimate of Pr(
X′
n−µ∈[ϵ,ϵ′′]) in (2.8) with
finite nat ϵ′
= ϵ+ 2 Var(X1)/nand ϵ′′
= ϵ+ 4 Var(X1)/n. Using Chebyshev’s
¯
inequality, we expect that Pr(
X′
n−µ ∈[ϵ,ϵ′′]) is lower bounded by a constant.
This means that as n→∞, the exponential tail inequality of Theorem 2.5 is gen-
erally loose by no more than O( Var(X1)/n) in terms of deviation ϵ. A concrete
calculation will be presented for bounded random variables in Section 2.5.
Before we investigate concrete examples of random variables, we state the fol-
lowing property of the logarithmic generating function of a random variable,
which provides intuitions on its behavior. The proof is left as an exercise.
Proposition 2.8 Given a random variable with finite variance, we have
ΛX(λ)
dΛX(λ)
= 0,
λ=0
dλ λ=0
d2ΛX(λ)
= E[X],
dλ2
= Var[X].
In the application of large deviation bounds, we are mostly interested in the
case that deviation ϵis close to zero. As shown in Example 2.6, the optimal λwe
shall choose is λ= O(ϵ) ≈0. It is thus natural to consider the Taylor expansion
of the logarithmic moment generating function around λ = 0. Proposition 2.8
implies that the leading terms of the Taylor expansion are
λ2
ΛX(λ) = λµ+
2 Var[X] + o(λ2),
where µ= E[X]. The first two terms match that of the normal random variable
in Example 2.6. When ϵ>0 is small, to obtain the rate function
IX(µ+ ϵ) = sup
λ>0
λ2
λ(µ+ ϵ)−λµ−
2 Var[X]−o(λ2),
we should set the optimal λapproximately as λ≈ϵ/Var[X], and the correspond-
ing rate function becomes
IX(µ+ ϵ) ≈
ϵ2
2Var[X] + o(ϵ2).
For specific forms of logarithmic moment generation functions, one may obtain
more precise bounds of the rate function. In particular, the following general esti-
mate is useful in many applications. This estimate is what we will use throughout
the chapter.
Lemma 2.9 Consider a random variable Xso that E[X] = µ. Assume that
there exists α>0 and β ≥0 such that for λ∈[0,β−1),
αλ2
ΛX(λ) ≤λµ+
2(1−βλ), (2.9)
then for ϵ>0,
ϵ2
−IX(µ+ ϵ) ≤−
2(α+ βϵ),
−IX µ+ ϵ+ βϵ2
2α
≤−
ϵ2
2α
.
Proof Note that
We can take λ at
−IX(µ+ ϵ) ≤inf
λ>0
αλ2
−λ(µ+ ϵ) + λµ+
2(1−βλ).
¯
λ= ϵ/(α+ βϵ). This implies that α¯
¯
λ/(1−β
λ) = ϵ. Therefore
α¯
λ2
−IX(µ+ ϵ) ≤−¯
λϵ+
=−
¯
2(1−β
λ)
¯
λϵ
2
ϵ2
=−
Moreover, with the same choice of
−IX µ+ ϵ+ β
2α
¯
λ, we have
ϵ2 ≤−¯
λϵ 1 + β
2α
ϵ +
ϵ2
.
2(α+ βϵ).
α¯
λ2
¯
2(1−β
λ)
=−
2αThis proves the second desired bound.
Lemma 2.9 implies the following generic theorem.
Theorem 2.10 If X1 has a logarithmic moment generating function that sat-
isfies (2.9) for λ>0, then for all ϵ>0,
¯
Pr(
Xn ≥µ+ ϵ) ≤exp
−nϵ2
2(α+ βϵ).
Moreover, for t>0, we have
Pr
¯
Xn ≥µ+
2αt
+ βt
n
Proof The first inequality of the theorem follows from the first inequality of
Lemma 2.9 and Theorem 2.5. The second inequality of the theorem follows from
the second inequality of Lemma 2.9 and Theorem 2.5, with ϵ= 2αt/n.
-->

### 2.4 次高斯随机变量

对于一个正态随机变量，其对数矩生成函数关于 $\lambda$ 是二次的。更一般的，我们可以定义一个**次高斯随机变量**为对数矩生成函数在 $\lambda$ 上被二次函数支配的随机变量。这样的随机变量有着轻尾，这意味着它们有着和正态随机变量类似的尾概率不等式。

**定义**：一个次高斯随机变量 $X$ 满足对于所有的 $\lambda \in \mathbb{R}$，其对数矩生成函数满足

$$
\ln \mathbb{E}e^{\lambda X} \le \lambda \mu + \frac{\lambda^2}{2}b.
$$

**定理**：如果 $X_1$ 是一个次高斯随机变量，那么对于所有的 $t > 0$，我们有

$$\begin{aligned}
\operatorname*{Pr}\left(\bar{X}_n \ge \mu + \sqrt{\frac{2bt}{n}} + \frac{t}{n}\right) &\le e^{-t}.\\
\operatorname*{Pr}\left(\bar{X}_n \le \mu - \sqrt{\frac{2bt}{n}} - \frac{t}{n}\right) &\le e^{-t}.
\end{aligned}$$

!!! Info "证明"

    使用上一节的最后一个定理，取 $\alpha = b$ 和 $\beta = 0$，我们就得到了我们想要的结果。

一般的次高斯随机变量的例子包括高斯随机变量和有界随机变量，其中高斯随机变量的 $b = \sigma^2$，在 $[\alpha, \beta]$ 上有界随机变量的 $b = (\beta - \alpha)^2/4$。

取 $\delta \in (0, 1)$ 使得 $\delta = \exp(-t)$，我们可以将上面的不等式写成另一种形式。在不少于 $1 - \delta$ 的概率下，我们有

$$
\bar{X}_n < \mu + \sqrt{\frac{2b\ln(1/\delta)}{n}}. 
$$

### 2.5 Hoeffding 不等式

<!-- Hoeﬀding’s inequality (Hoeﬀding, 1963) is an exponential tail inequality for bounded
random variables. In the machine learning and computer science literature, it is
often referred to as the Chernoﬀ bound.
Lemma 2.15 the following inequality:
Consider a random variable X ∈[0,1] and EX= µ. We have
ln EeλX ≤ln[(1−µ)e0 + µeλ] ≤λµ+ λ2/8.
Proof Let hL(λ) = EeλX and hR(λ) = (1−µ)e0 + µeλ. We know that hL(0) =
hR(0). Moreover, when λ≥0,
h′
L(λ) = EXeλX ≤EXeλ
= µeλ
= h′
R(λ),
and similarly h′
L(λ) ≥h′
R(λ) when λ≤0. This proves the first inequality.
Now we let
h(λ) = ln[(1−µ)e0 + µeλ].
It implies that
h′(λ) = µeλ
(1−µ)e0 + µeλ,
and
(µeλ)2
h′′(λ) = µeλ
(1−µ)e0 + µeλ−
[(1−µ)e0 + µeλ]2
= |h′(λ)|(1 −|h′(λ)|) ≤1/4.
Using Taylor expansion, we obtain the inequality h(λ) ≤h(0) + λh′(0) + λ2/8,
which proves the second inequality.The lemma implies that the maximum logarithmic moment generating func-
tion of a random variable X taking values in [0,1] is achieved by a {0,1}-valued
Bernoulli random variable with the same mean. Moreover, the random varia-
ble X is sub-Gaussian. We can then apply the sub-Gaussian tail inequality in
Theorem 2.12 to obtain the following additive form of Chernoﬀ bound.
Theorem 2.16 (Additive Chernoﬀ Bounds) Assume that X1 ∈[0,1]. Then for
all ϵ>0,
¯
Pr(
Xn ≥µ+ ϵ) ≤e−2nϵ2
¯
Pr(
Xn ≤µ−ϵ) ≤e−2nϵ2
Proof We simply take b= 1/4 and t= 2nϵ2 in Theorem 2.12 to obtain the first
¯
inequality. The second inequality follows from the equivalence of
Xn ≤µ−ϵand
¯
−
Xn ≤−µ+ ϵ.
In some applications, one may need to employ a more refined form of Chernoﬀ
bound, which can be stated as follows.
Theorem 2.17 Assume that X1 ∈[0,1]. Then for all ϵ>0, we have
¯
Pr(
Xn ≥µ+ ϵ) ≤e−nKL(µ+ϵ||µ)
,
¯
Pr(
Xn ≤µ−ϵ) ≤e−nKL(µ−ϵ||µ)
,
where KL(z||µ) is the Kullback–Leibler divergence (KL-divergence) defined as
KL(z||µ) = zln z
µ + (1−z) ln 1−z
.
1−µ
Proof Consider the case z= µ+ ϵ. We have
−IX1 (z) ≤inf
λ>0[−λz+ ln((1−µ)e0 + µeλ)].
Assume that the optimal value of λ on the right-hand side is achieved at λ∗. By
setting the derivative to zero, we obtain the expression
µeλ∗
z=
(1−µ)e0 + µeλ∗
,
which implies that
z(1−µ)
eλ∗ =
µ(1−z).
This implies that−IX1 (z) ≤−KL(z||µ). The case of z= µ−ϵis similar. We can
thus obtain the desired bound from Theorem 2.5.
In many applications, we will be interested in the situation µ ≈0. For ex-
ample, this happens when the classification error is close to zero. In this case,
Theorem 2.17 is superior to Theorem 2.16, and the result implies a simplified
form stated in the following corollary.Corollary 2.18 (Multiplicative Chernoﬀ Bounds) Assume that X1 ∈ [0,1].
Then for all ϵ>0,
¯
Pr
Xn ≥(1 + ϵ)µ ≤exp
−nµϵ2
2 + ϵ
,
¯
Pr
Xn ≤(1−ϵ)µ ≤exp
−nµϵ2
2.
Moreover, for t>0, we have
Pr
¯
Xn ≥µ+
2µt
t
3n
Proof The first and the second results can be obtained from Theorem 2.17 and
the inequality KL(z||µ) ≥(z−µ)2/max(2µ,µ+ z) (which is left as an exercise).
We then take z = (1 + ϵ)µ and z = (1−ϵ)µ, respectively, for the first and the
second inequalities.
For the third inequality (which is sharper than the first inequality), we may
apply Theorem 2.10. Just observe from Lemma 2.15 that when λ>0,
ΛX1 (λ) ≤ln[(1−µ)e0 + µeλ]
λk
≤µ(eλ
−1) = µλ+ µ
k≥2
≤µλ+ µλ2
2(1−λ/3).
In this derivation, the equality used the Taylor expansion of exponential function.
The last inequality used k! ≥2·3k−2 and the sum of infinite geometric series. We
may take α= µ and β = 1/3 in Theorem 2.10 to obtain the desired bound.
The multiplicative form of Chernoﬀ bound can be expressed alternatively as
follows. With probability at least 1−δ,
¯
µ<
Xn +
2µln(1/δ)
It implies that for any γ ∈(0,1),
¯
Xn >(1−γ)µ−
Moreover, with probability at least 1−δ,
¯
Xn <µ+
2µln(1/δ)
It implies that for any γ >0,
¯
Xn <(1 + γ)µ+ (3 + 2γ) ln(1/δ)
6γn
.
n
ln(1/δ)
. (2.11)
2γn
n
+ ln(1/δ)
3n
.
. (2.12)For Bernoulli random variables with X1 ∈{0,1}, the moment generating function
achieves equality in Lemma 2.15, and thus the proof of Theorem 2.17 implies that
the rate function is given by
IX1 (z) = KL(z||µ).
We can obtain the following lower bound from (2.8), which suggests that the KL
formulation of Hoeﬀding’s inequality is quite tight for Bernoulli random variables
when n is large.
Corollary 2.19 Assume that X1 ∈{0,1}. Then for all ϵ>0 that satisfy
′
ϵ
= ϵ+ 2 (µ+ ϵ)(1−(µ+ ϵ))/n<1−µ
and n≥(1−µ−ϵ)/(µ+ ϵ), we have
¯
Pr(
Xn ≥µ+ ϵ) ≥0.25 exp−nKL(µ+ ϵ
′||µ)−√n∆I ,
where
∆I = 2 (µ+ ϵ)(1−µ−ϵ) ln (µ+ ϵ′)(1−µ)
(1−(µ+ ϵ′))µ
.
Proof In (2.8), we let ϵ′′= 2ϵ′
−ϵ. Since X′
i ∈{0,1}and EX′
i = µ+ ϵ′, we have
Var(X′
1) = (µ+ ϵ′)(1−µ−ϵ′). Using Chebyshev’s inequality, we obtain
Pr |¯
X′
n−(µ+ ϵ
′)|≥ϵ
′
−ϵ ≤(µ+ ϵ′)(1−µ−ϵ′)
n(ϵ′
−ϵ)2
(µ+ ϵ′)(1−µ−ϵ′)
=
4(µ+ ϵ)(1−(µ+ ϵ)) ≤ (µ+ ϵ′)
4(µ+ ϵ) = 0.25 + ϵ′
4(µ+ ϵ).
−ϵ
Therefore
¯
Pr
X′
n ∈(µ+ ϵ,µ+ ϵ
′′) = 1−Pr |¯
X′
n−(µ+ ϵ
′)|≥ϵ
′
−ϵ
ϵ′
−ϵ
≥0.75−
4(µ+ ϵ) = 0.75−0.5
1−µ−ϵ
n(µ+ ϵ) ≥0.25.
The choice of λ in (2.4) is given by
λ= ln (µ+ ϵ′)(1−µ)
(1−(µ+ ϵ′))µ
By using these estimates, we can obtain the desired bound from (2.8). -->


### 2.6 Bennett 不等式

### 2.7 Bernstein 不等式

### 2.8 非一致分布的随机变量

### 2.9 卡方的尾概率
