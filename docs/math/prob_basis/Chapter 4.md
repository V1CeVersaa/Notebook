# Chapter 4 数字特征与特征函数

## Knowledge

### 1. 数学期望

对于离散型随机变量 $\xi$，其取值为 $x_1, x_2, \cdots$ 的概率分别为 $p_1, p_2, \cdots$，如果级数 $\sum\limits_{i=1}^\infty x_i p_i$ 绝对收敛，则称其为

### 2. 方差、相关系数与矩

**切比雪夫不等式**：对任何具有有限方差的随机变量 $\xi$，有 $P(\lvert \xi - E\xi \rvert \geq \varepsilon) \leq \dfrac{D\xi}{\varepsilon^2}$。

**马尔可夫不等式**：对随机变量 $\xi$，$f(x)$ 是定义在 $[0, +\infty)$ 上的**非负单调不减**函数，对任意 $x > 0$，有 $P(\lvert \xi\rvert > x) \leq \dfrac{E f(\lvert \xi\rvert)}{f(x)}$。

!!! Info "Proof"

    当 $E f(|\xi|) = \infty$ 时，上式显然成立。设 $E f(|\xi|) < \infty$，$\xi$ 的分布函数为 $F(x)$。因 $f(x)$ 单调不减，故当 $|y| > x$ 时，$f(|y|) \geq f(x)$，从而

    $$\begin{aligned}
    P(|\xi| > x) &= \int_{|y| > x} dF(y) \leq \int_{|y| > x} \frac{f(|y|)}{f(x)} dF(y) \\
    &\leq \frac{1}{f(x)} \int_{-\infty}^{\infty} f(|y|) dF(y) = \frac{E f(|\xi|)}{f(x)}.
    \end{aligned}$$

**协方差**：称 $\sigma_{ij} = \operatorname*{cov}(\xi_i, \xi_j)= E[(\xi_i - E\xi_i)(\xi_j - E\xi_j)]$ 为随机变量 $\xi_i$ 与 $\xi_j$ 的协方差。

不难验算：

- $\operatorname*{cov}(\xi_i, \xi_j) = E(\xi_i \xi_j) - E\xi_i \cdot E\xi_j$；
- $D(\sum\limits_{i=1}^n \xi_i) = \sum\limits_{i=1}^n D\xi_i + 2\sum\limits_{1 \leq i < j \leq n} \operatorname*{cov}(\xi_i, \xi_j)$。

**相关系数**：称 $\rho_{ij} = \dfrac{\operatorname*{cov}(\xi_i, \xi_j)}{\sqrt{D\xi_i \cdot D\xi_j}}$ 为随机变量 $\xi_i$ 与 $\xi_j$ 的相关系数。

**柯西-施瓦茨不等式**：对任意两个随机变量 $\xi$ 和 $\eta$，有 $\lvert E\xi\eta \rvert^2 \leq E\xi^2 \cdot E\eta^2$。当且仅当 $P(\xi = a\eta) = 1$ 时等号成立，这里的 $a$ 是一个常数。

**柯西-施瓦茨不等式**也可以如下表示：对任意两个随机变量 $\xi$ 和 $\eta$，有 

$$
E\lvert \xi - E\xi\rvert \lvert \eta - E\eta \rvert \leq \left( E(\xi - E\xi)^2 \right)^{1/2} \left( E(\eta - E\eta)^2 \right)^{1/2} = \sqrt{D\xi \cdot D\eta}
$$

**协方差性质**：对随机变量 $\xi$ 和 $\eta$，下面是等价的：

1. $\operatorname*{cov}(\xi, \eta) = 0$；
2. $\rho_{\xi\eta} = 0$，也就是说 $\xi$ 和 $\eta$ 不相关；
3. $E(\xi \eta) = E\xi \cdot E\eta$；
4. $D(\xi + \eta) = D\xi + D\eta$。

**定理**：若 $\xi$ 和 $\eta$ 独立，则 $\xi$ 和 $\eta$ 不相关。

!!! Info "证明"

但是反过来不相关性不一定表示独立性。不过对二元**正态分布**和**二值随机变量**来说，不相关性和独立性是等价的。

**矩**：对正整数 $k$，称 $m_k = E\xi^k$ 为随机变量 $\xi$ 的 $k$ 阶原点矩；称 $c_k = E(\xi - E\xi)^k$ 为随机变量 $\xi$ 的 $k$ 阶中心矩。

其中数学期望是 1 阶原点矩，方差是 2 阶中心矩。由于 

$$
c_k = E(\xi - E\xi)^k = \sum_{i=0}^k \binom{k}{i}(-E\xi)^{k-i}E\xi^i = \sum_{i=0}^k \binom{k}{i}(-m_1)^{k-i} m_i
$$

所以中心矩可以通过原点矩表示，反之

$$\begin{aligned}
m_k &= E\xi^k = E[(\xi - E\xi) + E\xi]^k = \sum_{i=0}^k \binom{k}{i}E(\xi - E\xi)^{k-i}(E\xi)^i\\
&= \sum_{i=0}^k \binom{k}{i}c_{k-i} m_1^i
\end{aligned}$$

也就是知道了数学期望之后，原点矩也可以通过中心矩给出。

!!! Example 

    设 $\xi$ 为正态随机变量，其密度函数为 

    $$
    p(x) = \dfrac{1}{\sqrt{2\pi}\sigma} e^{-x^2/2\sigma^2}
    $$

    因此 $E\xi = 0$，$m_k = c_k = E\xi^k = \displaystyle\int_{-\infty}^{+\infty} x^k \dfrac{1}{\sqrt{2\pi}\sigma} e^{-x^2/2\sigma^2} \, dx$。

对于多维随机变量，我们可以定义混合矩，比如 $E(\xi - E\xi)^k(\eta - E\eta)^l$，这里的 $k$ 和 $l$ 是正整数，称为 $\xi$ 和 $\eta$ 的 $k$ 阶 $l$ 阶混合中心矩。协方差为二阶混合中心矩。

**「条件数学期望」**：对离散随机变量 $\xi$ 与 $\eta$，在给定 $\eta = y$ 的条件下，$\xi$ 的条件数学期望为 $E(\xi \mid \eta = y) = \sum\limits_{i=1}^\infty x_i p_{\xi \mid \eta}(x_i \mid y)$，其中 $p_{\xi \mid \eta}(x_i \mid y) = P(\xi = x_i \mid \eta = y)$。同样，我们要求这个级数**绝对收敛**。

**「条件数学期望」**：对连续随机变量 $\xi$ 与 $\eta$，在给定 $\eta = y$ 的条件下，$\xi$ 的条件数学期望为 $E(\xi \mid \eta = y) = \displaystyle\int_{-\infty}^{+\infty} x p_{\xi \mid \eta}(x \mid y) \, dx$，其中 $p_{\xi \mid \eta}(x \mid y)$ 是 $\xi$ 在给定 $\eta = y$ 的条件下的概率密度函数。

**「回归」**：称 $y = E(\xi \mid \eta = x)$ 为 $\xi$ 关于 $\eta$ 的**回归**。 

**「全期望公式/重期望公式」**：对随机变量 $\xi$ 和 $\eta$，每一个 $y\in R_\eta$ 都对应着一个条件期望/回归函数 $E(\xi \mid \eta = y)$，定义 $g(\eta) = E(\xi \mid \eta)$，则有 $E\xi = Eg(\eta)$。

!!! Info "Proof"

    我们对连续形式给出证明：

    $$\begin{aligned}
    Eg(\eta) &= E(E(\xi \mid \eta)) = \int_{-\infty}^{+\infty} E(\xi \mid \eta = y) p_\eta(y) \, dy\\
    &= \int_{-\infty}^{+\infty} \left( \int_{-\infty}^{+\infty} x p_{\xi \mid \eta}(x \mid y) \, dx \right) p_\eta(y) \, dy\\
    &= \int_{-\infty}^{+\infty} \int_{-\infty}^{+\infty} x p_{\xi \mid \eta}(x \mid y) p_\eta(y) \, dx \, dy\\
    &= \int_{-\infty}^{+\infty} \int_{-\infty}^{+\infty} x p_{\xi, \eta}(x, y) \, dx \, dy = E\xi
    \end{aligned}$$


简而言之，回归的期望是原来的期望。


### 3. 熵与信息

### 4. 母函数

### 5. 特征函数

**「特征分布的分析性质」**：

1. 

**「特征函数的运算性质」**：

1. 令 $\xi$ 的特征函数为 $\varphi_{\xi}(t)$，则 $Ee^{it(a\xi+c)} = e^{itc}\varphi_{\xi}(at)$；
2. 如果 $\xi$ 和 $\eta$ 相互独立，则 $\gamma = \xi+\eta$ 的特征函数为 $\varphi_{\gamma}(t) = \varphi_{\xi}(t) \cdot \varphi_{\eta}(t)$；
3. 如果 $\xi_1, \xi_2, \cdots, \xi_n$ 相互独立，则 $\gamma = \xi_1 + \xi_2 + \cdots + \xi_n$ 的特征函数为 $\varphi_{\gamma}(t) = \varphi_{\xi_1}(t) \cdot \varphi_{\xi_2}(t) \cdots \varphi_{\xi_n}(t)$。利用这条性质，可以推出伯努利分布的特征函数。

**「逆转公式」**：设分布函数 $F(x)$ 的特征函数为 $\varphi(t)$，则 $F(x)$ 可以表示为

$$
F(x_2) - F(x_1) = \lim\limits_{T \to \infty} \dfrac{1}{2\pi} \int_{-T}^T \dfrac{e^{-itx_1} - e^{-itx_2}}{it} \varphi(t) \, dt
$$

**「特征函数和分布函数相互唯一确定」**：分布函数唯一确定特征函数这一点是显然的，下面证明如果 $\xi$ 和 $\eta$ 的特征函数相等，则 $\xi$ 和 $\eta$ 的分布函数相等。

!!! Info "Proof"
    通过逆转公式：

    $$
    F(y) = F(x) + \lim\limits_{T \to \infty} \dfrac{1}{2\pi} \int_{-T}^T \dfrac{e^{-ity} - e^{-itx}}{it} \varphi(t) \, dt
    $$

    所以

    $$
    F(y) = \lim\limits_{y \to -\infty}\lim\limits_{T \to \infty} \dfrac{1}{2\pi} \int_{-T}^T \dfrac{e^{-ity} - e^{-itx}}{it} \varphi(t) \, dt
    $$

    所以分布函数由其连续点上的值唯一确定

如果 $\xi$ 的特征函数绝对可积，也就是 $\displaystyle\int_{-\infty}^{+\infty} \lvert \varphi(t) \rvert \, dt < \infty$ 存在，那么 $\xi$ 的分布函数可以确定为

$$
p(x) = \dfrac{1}{2\pi} \int_{-\infty}^{+\infty} e^{-itx} \varphi(t) \, dt
$$

!!! Example 
    如果我们知道 $\varphi_{\xi}(t) = e^{-\lvert t\rvert}$，显然其绝对可积，所以其概率密度函数可以求为

    $$\begin{aligned}
    p(x) &= \dfrac{1}{2\pi} \int_{-\infty}^{+\infty} e^{-itx} e^{-\lvert t\rvert} \, dt\\
    &= \dfrac{1}{2\pi} \left[ \int_{0}^\infty e^{-itx} e^{-t} \, dt + \int_{-\infty}^0 e^{-itx} e^t \, dt \right] \\
    &= \dfrac{1}{2\pi} \left(\frac{1}{xi+1} + \frac{1}{1-xi}\right) = \dfrac{1}{\pi(1+x^2)}
    \end{aligned}$$

**「二元随机向量的特征函数」**：对于二元随机向量 $(\xi, \eta)$，其特征函数为一个二元函数 $\varphi(t_1, t_2) = Ee^{i(t_1\xi + t_2\eta)}$。特别的，当 $\xi$ 和 $\eta$ 相互独立时，有 $\varphi(t_1, t_2) = Ee^{it_1\xi}\cdot Ee^{it_2\eta}=$ $\varphi_{\xi}(t_1) \cdot \varphi_{\eta}(t_2)$。

典型分布的特征函数：

- **「退化分布」**：
- **「两点分布」**：
- **「均匀分布」**：
- **「伯努利分布」**：
- **「泊松分布」**：如果 $\xi \sim \mathcal{P}(\lambda)$，则其特征函数为 $\varphi(t) = e^{\lambda(e^{it} - 1)}$。

    $$\varphi(t) = \sum\limits_{k=0}^\infty e^{itk} \dfrac{\lambda^k}{k!} e^{-\lambda} = e^{-\lambda} \sum\limits_{k=0}^\infty \dfrac{(\lambda e^{it})^k}{k!} = e^{\lambda(e^{it} - 1)}$$

- **「均匀分布」**：
- **「指数分布」**：
- **「正态分布」**：$\varphi(t) = e^{-t^2/2}$

### 6. 多元正态分布

## Exercises

**不相关性不代表独立**：

袋中有 $N$ 张卡片，各记为数字 $Y_1, Y_2, \cdots, Y_N$，不放回地抽出 $n$ 张，求其和的数学期望和方差。

**第二统计量相关**：若 $\xi_1$，$\xi_2$ 相互独立，均服从 $N(\mu, \sigma^2)$，试证：

$$
E \max(\xi_1, \xi_2) = \mu + \dfrac{\sigma}{\sqrt{\pi}}
$$


!!! Info "Proof"

    先求分布，再求期望。设：

    $$
    \eta_1 = \dfrac{\xi_1 - \mu}{\sigma}, \quad \eta_2 = \dfrac{\xi_2 - \mu}{\sigma},
    $$

    则 $\eta_1, \eta_2$ 是相互独立的标准正态变量，且

    $$
    \max(\xi_1, \xi_2) = \max(\sigma \eta_1 + \mu, \sigma \eta_2 + \mu) = \sigma \max(\eta_1, \eta_2) + \mu.
    $$

    记 $X = \max(\eta_1, \eta_2)$，其分布函数为

    $$
    F_X(x) = P\{\max(\eta_1, \eta_2) < x\} = P\{\eta_1 < x, \eta_2 < x\} = [\Phi(x)]^2,
    $$

    得 $X = \max(\eta_1, \eta_2)$ 的密度函数为

    $$
    p_X(x) = 2 \Phi(x) \varphi(x) = \dfrac{2}{\sqrt{2\pi}} e^{-\frac{x^2}{2}} \int_{-\infty}^x \dfrac{1}{\sqrt{2\pi}} e^{-\frac{t^2}{2}} \, dt = \dfrac{1}{\pi} e^{-\frac{x^2}{2}} \int_{-\infty}^x e^{-\frac{t^2}{2}} \, dt.
    $$

    由此得

    $$
    E \max(\eta_1, \eta_2) = \int_{-\infty}^\infty x p_X(x) \, dx.
    $$

    展开计算：

    $$\begin{aligned}
    E \max(\eta_1, \eta_2) &= \dfrac{1}{\pi} \int_{-\infty}^\infty x \left(e^{-\frac{x^2}{2}} \int_{-\infty}^x e^{-\frac{t^2}{2}} \, dt \right) dx \\ 
    &= -\dfrac{1}{\pi} \int_{-\infty}^\infty \left(\int_{-\infty}^x e^{-\frac{t^2}{2}} \, dt \right) d \left(e^{-\frac{x^2}{2}}\right)\\
    &= -\dfrac{1}{\pi} \left[e^{-\frac{x^2}{2}} \int_{-\infty}^x e^{-\frac{t^2}{2}} \, dt \right]_{-\infty}^\infty + \dfrac{1}{\pi} \int_{-\infty}^\infty e^{-\frac{x^2}{2}} e^{-\frac{x^2}{2}} \, dx\\
    &= \dfrac{1}{\pi} \int_{-\infty}^\infty e^{-x^2} \, dx = \dfrac{1}{\sqrt{\pi}}.
    \end{aligned}$$

    从而

    $$
    E \max(\xi_1, \xi_2) = \sigma E \max(\eta_1, \eta_2) + \mu = \mu + \dfrac{\sigma}{\sqrt{\pi}}.
    $$



