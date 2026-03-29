# Chapter 4: Empirical Covering Number Analysis and Symmetrization

## 4.1 度量覆盖数与经验覆盖数

我们首先在一般伪度量空间上引入度量覆盖数的概念。

**定义 4.1**：设 $(\mathcal{V},d)$ 是具有度量 $d(\cdot,\cdot)$ 的伪度量空间。如果对于所有 $\phi \in \mathcal{G}$，存在 $\phi' \in \mathcal{G}(\epsilon)$ 使得 $d(\phi',\phi) \leq \epsilon$，则称有限集 $\mathcal{G}(\epsilon) \subset \mathcal{V}$ 是 $\mathcal{G} \subset \mathcal{V}$ 的 $\epsilon$ 覆盖（或 $\epsilon$ 网）。具有度量 $d$ 的 $\mathcal{G}$ 的 $\epsilon$ 覆盖数是这样的 $\mathcal{G}(\epsilon)$ 的最小基数 $N(\epsilon,\mathcal{G},d)$。量 $\ln N(\epsilon,\mathcal{G},d)$ 被称为 $\epsilon$-熵。

对于具有半范数 $L_p(\mathcal{D})$ 的函数类 $\mathcal{G}$，我们将相应的 $L_p(\mathcal{D})$ 覆盖数记为 $N(\epsilon,\mathcal{G},L_p(\mathcal{D}))$。当 $1 \leq p \leq q$ 时，我们有：

$$N(\epsilon,\mathcal{G},L_p(\mathcal{D})) \leq N(\epsilon,\mathcal{G},L_q(\mathcal{D})),\text{ where } \lVert f - f^{\prime} \rVert_{L_p(\mathcal{D})} = \left[\mathbb{E}_{Z\sim\mathcal{D}}|f(Z) - f^{\prime}(Z)|^p\right]^{1/p}$$

这是因为对于 $1 \leq p \leq q$，$\lVert f - f^{\prime} \rVert_{L_p(\mathcal{D})} \leq \lVert f - f^{\prime} \rVert_{L_q(\mathcal{D})}$，度量更大，反而球就更小了。

容易验证下面的关系，它表明 $L_p(\mathcal{D})$ 括号覆盖比 $L_p(\mathcal{D})$ 覆盖更强。

**命题 4.2**：以下结果成立：

$$N(\epsilon,\mathcal{G},L_p(\mathcal{D})) \leq N_{[]}(2\epsilon,\mathcal{G},L_p(\mathcal{D}))$$

!!! Info "证明"
    想法就是根据 $L_p(\mathcal{D})$ 括号覆盖构造出一组 $L_p(\mathcal{D})$ 覆盖。

    设 $\{[\phi_1^L(z),\phi_1^U(z)],\ldots,[\phi_N^L(z),\phi_N^U(z)]\}$ 是 $\mathcal{G}$ 的 $2\epsilon$ $L_p(\mathcal{D})$-括号覆盖。令 $\phi_j(z) = (\phi_j^L(z) + \phi_j^U(z))/2$，则 $\{\phi_1(z),\ldots,\phi_N(z)\}$ 是 $\mathcal{G}$ 的 $\epsilon$ $L_p(\mathcal{D})$-覆盖。

下面的结果表明，当 $p = \infty$ 时，命题 4.2 的反向命题成立。也就是说，$L_\infty(\mathcal{D})$ 括号覆盖等价于 $L_\infty(\mathcal{D})$ 覆盖。这意味着第 3 章中使用下括号数的分析也可以应用于 $L_\infty(\mathcal{D})$ 覆盖数。这个命题成立的究其原因还是因为 $L_{\infty}(\mathcal{D})$ 范数的结构（在 van der Vaart 的书中被称为一致范数/Uniform Norm）变成了本质上确界范数，这时括号覆盖和覆盖的集合就一样了。对于非一致范数的情况，只需要考虑三角不等式 $\lVert f - f^{\prime\prime} \rVert_{L_\infty(\mathcal{D})} + \lVert f^{\prime} - f^{\prime\prime} \rVert_{L_\infty(\mathcal{D})} \geq \lVert f - f^{\prime} \rVert_{L_\infty(\mathcal{D})}$ 即可。

**命题 4.3**：我们有：

$$N_{[]}(\epsilon,\mathcal{G},L_\infty(\mathcal{D})) = N(\epsilon/2,\mathcal{G},L_\infty(\mathcal{D}))$$

!!! Info "证明"
    设 $\{\phi_j\}$ 是 $\mathcal{G}$ 的 $\epsilon/2$ $L_\infty(\mathcal{D})$ 覆盖。令 $\phi_j^L = \phi_j - \epsilon/2$ 且 $\phi_j^U = \phi_j + \epsilon/2$。则 $[\phi_j^L,\phi_j^U]$ 构成一个 $\epsilon$ 括号覆盖。反向的证明类似命题 4.2。

这个结果意味着 $L_\infty(\mathcal{D})$ 覆盖数导出 $L_1(\mathcal{D})$ 括号数的上界（命题 3.28）。因此，可以如定理 3.14 所示使用 $L_\infty(\mathcal{D})$ 覆盖数获得一致收敛结果。然而，对于 $p < \infty$，不能直接使用 $L_p(\mathcal{D})$ 覆盖数获得一致收敛。为此，需要引入**经验覆盖数**和**一致覆盖数**的概念。

**定义 4.4**（经验覆盖数和一致覆盖数）：给定经验分布 $\mathcal{S}_n = \{Z_1,\ldots,Z_n\}$，我们定义伪度量 $d = L_p(\mathcal{S}_n)$ 为：

$$d(\phi,\phi') = \left[\frac{1}{n}\sum_{i=1}^n|\phi(Z_i) - \phi'(Z_i)|^p\right]^{1/p}$$

相应的度量覆盖数 $N(\epsilon,\mathcal{G},L_p(\mathcal{S}_n))$ 被称为经验 $L_p$ 覆盖数。给定 $n$，经验分布 $\mathcal{S}_n$ 上**最大**的 $L_p$ 覆盖数被称为**一致** $L_p$ **覆盖数**：

$$N_p(\epsilon,\mathcal{G},n) = \sup_{\mathcal{S}_n}N(\epsilon,\mathcal{G},L_p(\mathcal{S}_n))$$

由于 $L_p(\mathcal{S}_n)$ 伪度量**随** $p$ **增加而增加**，我们有以下简单结果。

**命题 4.5**：对 $1 \leq p \leq q$，我们有：

$$N(\epsilon,\mathcal{G},L_p(\mathcal{S}_n)) \leq N(\epsilon,\mathcal{G},L_q(\mathcal{S}_n))$$

且

$$N_p(\epsilon,\mathcal{G},n) \leq N_q(\epsilon,\mathcal{G},n)$$

我们稍后将证明一致 $L_1$ 覆盖数可以用来获得一致收敛和预言不等式。首先，我们展示对于线性分类器很容易获得经验 $L_\infty$ 覆盖数的估计，这就可以导出一致 $L_1$ 覆盖数的界。

**例 4.6**：考虑 $d$ 维空间中形如 $f(w,x) = \mathbb{1}(w^\top x \geq 0)$ 的 $\{0,1\}$-值线性分类器，其中 $w \in \Omega = \mathbb{R}^d$ 且 $x \in \mathcal{X} = \mathbb{R}^d$。设 $Y \in \{0,1\}$，则分类误差为 $\phi(w,z) = \mathbb{1}(f(w,x) \neq y)$，其中 $z = (x,y)$。注意，对于任意 $\mathcal{D}$，获得这类问题的括号覆盖是困难的。然而，获得 $L_\infty$ 经验覆盖数是容易的。使用 VC 维度的概念可以得到一致 $L_\infty$ 覆盖数的一般界。对于线性分类器，也可以使用凸优化得到界：

$$N_\infty(\epsilon, \mathcal{G}, n) \leq (2n)^d$$

其中 $\epsilon = 0$。详见练习 4.4。

## 4.2 对称化

使用第3章的记号，我们令 $Z = (X,Y)$。考虑这样的设定：我们观察到从 $\mathcal{D}$ 中独立抽取的训练数据 $\mathcal{S}_n = \{Z_1,\ldots,Z_n\}$，以及同样从 $\mathcal{D}$ 中独立抽取的验证数据 $\mathcal{S}_n' = \{Z_1',\ldots,Z_n'\}$。

给定函数 $f(Z)$，我们可以定义训练损失和验证损失为：

$$f(\mathcal{S}_n) = \frac{1}{n}\sum_{Z\in\mathcal{S}_n}f(Z),\quad f(\mathcal{S}_n') = \frac{1}{n}\sum_{Z\in\mathcal{S}_n'}f(Z)$$

对于每个划分 $(\mathcal{S}_n,\mathcal{S}_n')$。一个自然的问题是如何用训练损失来界定验证损失。注意，这样的验证结果可以自然地转化为关于测试分布 $\mathcal{D}$ 的泛化结果。

在对称化论证中，我们使用对称化经验过程的一致收敛来界定验证损失，对称化经验过程定义如下。

**定义 4.7**：考虑实值函数族 $\mathcal{F}: \mathcal{Z} \to \mathbb{R}$。考虑 $n$ 个独立同分布的伯努利随机变量 $\sigma_i \in \{\pm1\}$，其中 $\operatorname{Pr}(\sigma_i = 1) = \operatorname{Pr}(\sigma_i = -1) = 0.5$。对称化经验过程定义为：

$$f(\sigma,\mathcal{S}_n) = \frac{1}{n}\sum_{i=1}^n\sigma_if(Z_i)\quad f \in \mathcal{F}$$

其中随机性来自于 $\mathcal{S}_n = \{Z_i\}$ 和 $\sigma = \{\sigma_i\}$ 两者。

注意，为了界定对称化经验过程，我们只需要在 $\mathcal{S}_n$ 上的覆盖数结果。因此对称化分析允许我们使用经验覆盖数。接下来，我们将证明对称化经验过程的界可以用来获得经验过程 $\{f(\mathcal{S}_n): f \in \mathcal{F}\}$ 到验证数据上对应结果的一致收敛。由于可以将学习算法的验证损失与其在测试数据上的泛化误差联系起来，我们可以使用这个结果来获得泛化界。

下面的引理表明，如果我们能够获得对称化经验过程 $\{f(\sigma,\mathcal{S}_n): f \in \mathcal{F}\}$ 的上界，并且该上界满足超可加性，那么我们就可以获得训练数据 $\mathcal{S}_n$ 上的经验过程 $\{f(\mathcal{S}_n): f \in \mathcal{F}\}$ 到验证数据 $\mathcal{S}_n'$ 上对应结果的一致收敛。

**引理 4.8**（对称化）：考虑实值函数族 $\mathcal{F} = \{f: \mathcal{Z} \to \mathbb{R}\}$。假设存在函数 $\psi: \mathcal{F} \times \mathcal{Z}^n \to \mathbb{R}$ 和 $\epsilon_n: (0,1) \to \mathbb{R}$，使得以至少 $1-\delta$ 的概率，

$$\forall f \in \mathcal{F},\quad f(\sigma,\mathcal{S}_n) \leq \psi(f,\mathcal{S}_n) + \epsilon_n(\delta)$$

其中随机性来自于 $\mathcal{S}_n \sim \mathcal{D}^n$ 和 $\sigma$ 两者。如果存在 $\tilde{\psi}(f,\mathcal{S}_n \cup \mathcal{S}_n')$ 使得对所有 $(\mathcal{S}_n,\mathcal{S}_n')$ 都满足如下超可加性不等式：

$$\psi(f,\mathcal{S}_n) + \psi(f,\mathcal{S}_n') \leq \tilde{\psi}(f,\mathcal{S}_n \cup \mathcal{S}_n')$$

那么对于独立随机数据 $(\mathcal{S}_n,\mathcal{S}_n') \sim \mathcal{D}^{2n}$，以至少 $1-\delta$ 的概率有：

$$\forall f \in \mathcal{F},\quad f(\mathcal{S}_n') \leq f(\mathcal{S}_n) + \tilde{\psi}(f,\mathcal{S}_n \cup \mathcal{S}_n') + 2\epsilon_n(\delta/2)$$

!!! Info "证明"
    考虑独立随机样本 $(\mathcal{S}_n,\mathcal{S}_n') \sim \mathcal{D}^{2n}$，由于它们独立同分布，所以对于每一个样本对 $(Z_i, Z_i^{\prime})$，函数差值 $f(Z_i) - f(Z_i^{\prime})$ 的分布关于原点对称，也就是 $f(Z_i) - f(Z_i^{\prime})$ 和 $-(f(Z_i) - f(Z_i^{\prime}))$ 同分布。进而可以得知 $f(\mathcal{S}_n) - f(\mathcal{S}_n')$ 与 $f(\sigma,\mathcal{S}_n) - f(\sigma,\mathcal{S}_n')$ 具有相同的分布，后者包含了来自伯努利随机变量 $\sigma$ 的额外随机性。因此

    $$\begin{aligned}
    \operatorname{Pr}&\left(\exists f \in \mathcal{F}, f(\mathcal{S}_n') > f(\mathcal{S}_n) + \tilde{\psi}(f,\mathcal{S}_n \cup \mathcal{S}_n') + 2\epsilon_n(\delta/2)\right) \\
    &= \operatorname{Pr}\left(\exists f \in \mathcal{F}, f(\sigma,\mathcal{S}_n') > f(\sigma,\mathcal{S}_n) + \tilde{\psi}(f,\mathcal{S}_n \cup \mathcal{S}_n') + 2\epsilon_n(\delta/2)\right) \\
    &\stackrel{(a)}{\leq} \operatorname{Pr}\left(\exists f \in \mathcal{F}, f(\sigma,\mathcal{S}_n') > f(\sigma,\mathcal{S}_n) + (\psi(f,\mathcal{S}_n) + \psi(f,\mathcal{S}_n')) + 2\epsilon_n(\delta/2)\right) \\
    &\stackrel{(b)}{\leq} \operatorname{Pr}\left(\exists f \in \mathcal{F}, f(\sigma,\mathcal{S}_n') > \psi(f,\mathcal{S}_n') + \epsilon_n(\delta/2)\right) + \operatorname{Pr}\left(\exists f \in \mathcal{F}, -f(\sigma,\mathcal{S}_n) > \psi(f,\mathcal{S}_n) + \epsilon_n(\delta/2)\right) \\
    &= 2\operatorname{Pr}\left(\exists f \in \mathcal{F}, f(\sigma,\mathcal{S}_n) > \psi(f,\mathcal{S}_n) + \epsilon_n(\delta/2)\right) \leq 2(\delta/2) = \delta
    \end{aligned}$$

    在推导中，第一个等式使用了 $f(\mathcal{S}_n) - f(\mathcal{S}_n')$ 和 $f(\sigma,\mathcal{S}_n) - f(\sigma,\mathcal{S}_n')$ 具有相同分布的事实。(a) 使用了假设 $\psi(\mathcal{S}_n) + \psi(\mathcal{S}_n') \leq \tilde{\psi}(\mathcal{S}_n \cup \mathcal{S}_n')$；(b) 使用了并集界，以及如果事件 $E_0$ 成立，那么事件 $E_1$ 或事件 $E_2$ 成立的事实，这也利用了事件 $E_1$ 和事件 $E_2$ 对称的性质。下一个等式使用了 $-f(\sigma,\mathcal{S}_n)$ 和 $f(\sigma,\mathcal{S}_n)$ 的对称性，最后的不等式使用了引理的假设。这个结果蕴含了所需的界。

引理 4.8 表明对称化经验过程可以用来获得适当定义的训练统计量（如训练损失，$f(\mathcal{S}_n)$）到验证统计量（如验证损失，$f(\mathcal{S}_n^{\prime})$）的一致收敛结果。下面的例子说明了其结果。

**例 4.9**：我们可以在引理 4.8 中取 $\psi = \tilde{\psi} = 0$，这显然满足超可加性。假设我们对对称化经验过程有如下界：

$$\forall f \in \mathcal{F},\quad f(\sigma,\mathcal{S}_n) \leq \epsilon_n(\delta)$$

那么以至少 $1-\delta$ 的概率，

$$\forall f \in \mathcal{F},\quad f(\mathcal{S}_n') \leq f(\mathcal{S}_n) + 2\epsilon_n(\delta/2)$$

**例 4.10**：在引理 4.8 中，我们也可以取 $\gamma \in (0,1)$。令

$$\psi(f,\mathcal{S}_n) = \gamma f(\mathcal{S}_n) = \frac{\gamma}{n}\sum_{i=1}^nf(Z_i),\quad \tilde{\psi}(f,\mathcal{S}_n \cup \mathcal{S}_n') = \frac{\gamma}{n}\sum_{i=1}^n[f(Z_i) + f(Z_i')]$$

这也满足超可加性。假设我们对对称化经验过程有如下界：以至少 $1-\delta$ 的概率，

$$\forall f \in \mathcal{F},\quad f(\sigma,\mathcal{S}_n) \leq \gamma f(\mathcal{S}_n) + \epsilon_n(\delta)$$

那么我们得到以至少 $1-\delta$ 的概率，

$$\forall f \in \mathcal{F},\quad (1-\gamma)f(\mathcal{S}_n') \leq (1+\gamma)f(\mathcal{S}_n) + 2\epsilon_n(\delta/2)$$

以下结果可以与引理 4.8 一起使用，以获得训练统计量到测试统计量（例如测试损失）的一致收敛。得到的界可以与引理 3.11 一起使用，以获得经验风险最小化的预言不等式。

**引理 4.11**：设 $\psi_{\text{trn}}: \mathcal{F} \times \mathcal{Z}^n \to \mathbb{R}$，$\psi_{\text{val}}: \mathcal{F} \times \mathcal{Z}^n \to \mathbb{R}$，$\psi_{\text{tst}}: \mathcal{F} \times \mathcal{D} \to \mathbb{R}$ 分别是适当的训练（其中 $\mathcal{D}$ 表示 $\mathcal{Z}$ 上的概率分布）、验证和测试统计量。假设对于任意 $\delta_1 \in (0,1)$，以下一致收敛结果成立。对随机抽取的训练集和验证集 $(\mathcal{S}_n,\mathcal{S}_n') \sim \mathcal{D}^{2n}$，以至少 $1-\delta_1$ 的概率有：

$$\forall f \in \mathcal{F}: \psi_{\text{val}}(f,\mathcal{S}_n') \leq \psi_{\text{trn}}(f,\mathcal{S}_n) + \epsilon_n^1(\delta_1)$$

此外，假设对所有 $f \in \mathcal{F}$，对随机抽取的 $\mathcal{S}_n' \sim \mathcal{D}$，以 $1-\delta_2$ 的概率有：

$$\psi_{\text{tst}}(f,\mathcal{D}) \leq \psi_{\text{val}}(f,\mathcal{S}_n') + \epsilon_n^2(\delta_2)$$

那么以下一致收敛陈述成立。以至少 $1-\delta_1-\delta_2$ 的概率，

$$\forall f \in \mathcal{F}: \psi_{\text{tst}}(f,\mathcal{D}) \leq \psi_{\text{trn}}(f,\mathcal{S}_n) + \epsilon_n^1(\delta_1) + \epsilon_n^2(\delta_2)$$

!!! Info "证明"
    令 $Q(f,\mathcal{S}_n) = \psi_{\text{tst}}(f,\mathcal{D})-\psi_{\text{trn}}(f,\mathcal{S}_n)-(\epsilon_n^1(\delta_1)+\epsilon_n^2(\delta_2))$，并令 $E$ 为事件 $\sup_{f\in\mathcal{F}}Q(f,\mathcal{S}_n) \leq 0$。我们选择 $\hat{f}(\mathcal{S}_n) \in \mathcal{F}$ 使得如果 $E$ 成立，则选择任意满足 $Q(\hat{f}(\mathcal{S}_n),\mathcal{S}_n) \leq 0$ 的 $\hat{f}$，如果 $E$ 不成立，则选择使得 $Q(\hat{f}(\mathcal{S}_n),\mathcal{S}_n) > 0$ 的 $\hat{f}$。我们考虑样本 $(\mathcal{S}_n,\mathcal{S}_n') \sim \mathcal{D}^{2n}$。为简便起见，在下文中，我们令 $\hat{f} = \hat{f}(\mathcal{S}_n)$。定理的一致收敛条件意味着以至少 $1-\delta_1$ 的概率，以下事件成立：

    $$E_1: \psi_{\text{val}}(\hat{f},\mathcal{S}_n') \leq \psi_{\text{trn}}(\hat{f},\mathcal{S}_n) + \epsilon_n^1(\delta_1)$$

    注意验证数据 $\mathcal{S}_n'$ 独立于训练数据 $\mathcal{S}_n$。因此 $\mathcal{S}_n'$ 也独立于 $\hat{f}$。因此定理的条件意味着以至少 $1-\delta_2$ 的概率，以下事件成立：

    $$E_2: \psi_{\text{tst}}(\hat{f},\mathcal{D}) \leq \psi_{\text{val}}(\hat{f},\mathcal{S}_n') + \epsilon_n^2(\delta_2)$$

    如果事件 $E_1$ 和 $E_2$ 都成立，那么

    $$\begin{aligned}
    \psi_{\text{tst}}(\hat{f},\mathcal{D}) &\leq \psi_{\text{val}}(\hat{f},\mathcal{S}_n') + \epsilon_n^2(\delta_2) \\
    &\leq \psi_{\text{trn}}(\hat{f},\mathcal{S}_n) + \epsilon_n^1(\delta_1) + \epsilon_n^2(\delta_2)
    \end{aligned}$$

    $\hat{f}$ 的定义意味着 $E$ 成立。因此 $\operatorname{Pr}(E) \geq \operatorname{Pr}(E_1\text{ and }E_2) \geq 1-\delta_1-\delta_2$。这就得到了所需的界。

在文献中，也可以通过考虑 $\hat{f}$ 和 $E_2$ 之间的独立关系来获得不同的界。我们将推导留作练习。

## 4.3 使用一致 L1 覆盖数的一致收敛

使用第3章的记号，我们考虑函数类

$$\mathcal{G} = \{\phi(w,z): w \in \Omega\}$$

其中 $\phi(w,\mathcal{S}_n)$ 和 $\phi(w,\mathcal{D})$ 在(3.5)和(3.6)中定义。我们可以获得以下一致收敛界，这些界类似于定理3.14的结果。这里我们简单地用 $L_1$ 一致覆盖数替换了 $L_1(\mathcal{D})$-下括号数。也可以通过假设界以较大概率成立来放松一致覆盖数的要求。为简单起见，我们不考虑这样的分析。

**定理 4.12** 假设对所有 $w$ 和 $z$ 都有 $\phi(w,z) \in [0,1]$。那么对于给定的 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率，以下不等式成立：

$$\forall w \in \Omega: \phi(w,\mathcal{D}) \leq \phi(w,\mathcal{S}_n) + \epsilon_n(\delta)$$

其中

$$\epsilon_n(\delta) = \inf_{\epsilon>0}\left[2\epsilon + 3\sqrt{\frac{\ln(3N_1(\epsilon,\mathcal{G},2n)/\delta)}{2n}}\right]$$

此外，对于任意 $\gamma \in (0,1)$，以至少 $1-\delta$ 的概率，以下不等式成立：

$$\forall w \in \Omega: (1-\gamma)^2\phi(w,\mathcal{D}) \leq \phi(w,\mathcal{S}_n) + \epsilon_n(\delta)$$

其中

$$\epsilon_n(\delta) = \inf_{\epsilon>0}\left[2\epsilon + \frac{(5-4\gamma)\ln(3N_1(\epsilon,\mathcal{G},n)/\delta)}{2\gamma n}\right]$$

!!! Info "证明"
    令 $\mathcal{F} = \{f(z) = \phi(w,z) - 0.5: w \in \Omega\}$。给定 $\mathcal{S}_n$，我们考虑 $\mathcal{F}$ 的 $\epsilon$-$L_1(\mathcal{S}_n)$ 覆盖 $\mathcal{F}_\epsilon(\mathcal{S}_n)$，其大小不超过 $N = N_1(\epsilon,\mathcal{G},n)$。我们可以假设对于 $f \in \mathcal{F}_\epsilon(\mathcal{S}_n)$ 有 $f(Z_i) \in [-0.5,0.5]$。从推论 2.27（取 $a_i = 0.5$）和并集界，我们得到以下对 $\mathcal{F}_\epsilon(\mathcal{S}_n)$ 的一致收敛结果。以 $1-\delta$ 的概率，

    $$\forall f \in \mathcal{F}_\epsilon(\mathcal{S}_n): f(\sigma,\mathcal{S}_n) \leq \sqrt{\frac{\ln(N/\delta)}{2n}}$$

    由于对于所有 $f \in \mathcal{F}$，我们可以找到 $f' \in \mathcal{F}_\epsilon(\mathcal{S}_n)$ 使得对所有 $Z \in \mathcal{S}_n$ 都有 $n^{-1}\sum_{Z\in\mathcal{S}_n}|f(Z)-f'(Z)| \leq \epsilon$。因此

    $$f(\sigma,\mathcal{S}_n) \leq f'(\sigma,\mathcal{S}_n) + \epsilon \leq \epsilon + \sqrt{\frac{\ln(N/\delta)}{2n}}$$

    使用引理 4.8（取 $\psi = 0$），这个对称化经验过程的一致收敛结果蕴含以下一致收敛结果。以至少 $1-\delta_1$ 的概率，对于 $(\mathcal{S}_n,\mathcal{S}_n') \sim \mathcal{D}^{2n}$，

    $$\forall w \in \Omega: \phi(w,\mathcal{S}_n') \leq \phi(w,\mathcal{S}_n) + 2\epsilon + \sqrt{\frac{2\ln(2N/\delta_1)}{n}}$$

    标准加性 Chernoff 界蕴含对于所有 $w \in \Omega$，以至少 $1-\delta_2$ 的概率，

    $$\phi(w,\mathcal{D}) \leq \phi(w,\mathcal{S}_n') + \sqrt{\frac{\ln(1/\delta_2)}{2n}}$$

    因此在引理 4.11 中，我们可以取符号如图所示，并取 $\delta_1 = 2\delta/3$ 和 $\delta_2 = \delta/3$ 来获得所需的界。

类似地，我们考虑 $\mathcal{F} = \{f(z) = \phi(w,z): w \in \Omega\}$。给定 $\mathcal{S}_n$，我们考虑 $\mathcal{F}$ 的 $\epsilon$-$L_1(\mathcal{S}_n)$ 覆盖 $\mathcal{F}_\epsilon(\mathcal{S}_n)$，其大小不超过 $N = N_1(\epsilon,\mathcal{G},n)$。我们假设对于 $f \in \mathcal{F}_\epsilon(\mathcal{S}_n)$ 有 $f(Z_i) \in [0,1]$。从推论 2.27 和并集界，我们得到以下对 $\mathcal{F}_\epsilon(\mathcal{S}_n)$ 的一致收敛结果。以至少 $1-\delta$ 的概率，

$$\forall f \in \mathcal{F}_\epsilon(\mathcal{S}_n): f(\sigma,\mathcal{S}_n) \leq \sqrt{\frac{2\sum_{Z\in\mathcal{S}_n}f(Z)^2\ln(N/\delta)}{n^2}} \leq \gamma'\frac{1}{n}\sum_{Z\in\mathcal{S}_n}f(Z) + \frac{\ln(N/\delta)}{2\gamma'n}$$

第一个不等式使用了推论 2.27。第二个不等式使用了 $\sqrt{2ab} \leq \gamma'a + b/(2\gamma')$ 和 $f(Z)^2 \leq f(Z)$。由于对于所有 $f \in \mathcal{F}$，我们可以找到 $f' \in \mathcal{F}_\epsilon(\mathcal{S}_n)$ 使得 $\frac{1}{n}\sum_{Z\in\mathcal{S}_n}|f(Z)-f'(Z)| \leq \epsilon$。因此

$$f(\sigma,\mathcal{S}_n) \leq f'(\sigma,\mathcal{S}_n) + \epsilon \leq \gamma'\frac{1}{n}\sum_{Z\in\mathcal{S}_n}f'(Z) + \frac{\ln(N/\delta)}{2\gamma'n} + \epsilon \leq \gamma'\frac{1}{n}\sum_{Z\in\mathcal{S}_n}f(Z) + \frac{\ln(N/\delta)}{2\gamma'n} + (1+\gamma')\epsilon$$

现在，取 $\psi(f,\mathcal{S}_n) = \tilde{\psi}(f,\mathcal{S}_n) = \gamma'\frac{1}{n}\sum_{Z\in\mathcal{S}_n}f(Z)$，我们从引理 4.8 得到以下一致收敛结果。以至少 $1-\delta_1$ 的概率，对于 $(\mathcal{S}_n,\mathcal{S}_n') \sim \mathcal{D}^{2n}$，

$$\forall w \in \Omega: (1-\gamma')\phi(w,\mathcal{S}_n') \leq (1+\gamma')\phi(w,\mathcal{S}_n) + 2(1+\gamma')\epsilon + \frac{\ln(2N/\delta_1)}{\gamma'n}$$

令 $\gamma' = \gamma/(2-\gamma)$，则容易代数验证 $(1-\gamma')/(1+\gamma') = 1-\gamma$ 且 $1/(\gamma'(1+\gamma')) = (2-\gamma)^2/(2\gamma)$。因此我们得到

$$\forall w \in \Omega: (1-\gamma)\phi(w,\mathcal{S}_n') \leq \phi(w,\mathcal{S}_n) + 2\epsilon + \frac{(2-\gamma)^2\ln(2N/\delta_1)}{2\gamma n}$$

标准乘性 Chernoff 界 (2.11) 蕴含以 $1-\delta_2$ 的概率，

$$(1-\gamma)(1-\gamma)\phi(w,\mathcal{D}) \leq (1-\gamma)\phi(w,\mathcal{S}_n') + (1-\gamma)\frac{\ln(1/\delta_2)}{2\gamma n}$$

因此在引理 4.11 中，我们可以使用这里显示的符号，并取 $\delta_1 = 2\delta/3$ 和 $\delta_2 = \delta/3$ 来获得所需的界。

使用引理 3.11，可以从定理 4.12 获得以下预言不等式。结果类似于推论 3.15，证明也类似。因此我们将证明留作练习。

**推论 4.13** 如果 $\phi(w,z) \in [0,1]$。令 $\mathcal{G} = \{\phi(w,z): w \in \Omega\}$。以至少 $1-\delta$ 的概率，近似 ERM 方法 (3.3) 满足（加性）预言不等式：

$$\mathbb{E}_{Z\sim\mathcal{D}}\phi(\hat{w},Z) \leq \inf_{w\in\Omega}\mathbb{E}_{Z\sim\mathcal{D}}\phi(w,Z) + \epsilon' + \inf_{\epsilon>0}\left[2\epsilon + \sqrt{\frac{8\ln(4N_1(\epsilon,\mathcal{G},n)/\delta)}{n}}\right]$$

此外，对于所有 $\gamma \in (0,1)$，我们有以下（乘性）预言不等式：以至少 $1-\delta$ 的概率，

$$(1-\gamma)^2\mathbb{E}_{(X,Y)\sim\mathcal{D}}\phi(\hat{w},Z) \leq \inf_{w\in\Omega}(1+\gamma)\mathbb{E}_{(X,Y)\sim\mathcal{D}}\phi(w,Z) + \epsilon' + \inf_{\epsilon>0}\left[2\epsilon + \frac{(6-3\gamma)\ln(4N_1(\epsilon,\mathcal{G},n)/\delta)}{2\gamma n}\right]$$

**例 4.14** 考虑例 4.6 中的线性分类器例子。由于 $\ln N_\infty(\epsilon,\mathcal{G},n) \leq d\ln(2n)$，对于 ERM 方法，我们有以下预言不等式。以至少 $1-\delta$ 的概率，

$$\mathbb{E}_\mathcal{D}\mathbb{1}(f(\hat{w},X) \neq Y) \leq \inf_{w\in\mathbb{R}^d}\mathbb{E}_\mathcal{D}\mathbb{1}(f(w,X) \neq Y) + \sqrt{\frac{8(\ln(4/\delta) + d\ln(2n))}{n}}$$

此外，通过在集合 $\gamma \in \{i/n: i \in [n]\}$ 上优化乘性界中的 $\gamma$，并取并集界，我们可以得到以下不等式。以至少 $1-\delta$ 的概率，

$$\mathbb{E}_\mathcal{D}\mathbb{1}(f(\hat{w},X) \neq Y) \leq \text{err}_* + C\left[\sqrt{\text{err}_*\frac{\ln(\delta^{-1}) + d\ln(n)}{n}} + \frac{\ln(\delta^{-1}) + d\ln(n)}{n}\right]$$

其中 $C$ 是一个绝对常数且

$$\text{err}_* = \inf_{w\in\Omega}\mathbb{E}_\mathcal{D}\mathbb{1}(f(w,X) \neq Y)$$

## 4.4 VC 维

设 $\mathcal{G} = \{\phi(w,z): w \in \Omega\}$ 是一个由 $w \in \Omega$ 索引的、定义在 $z \in \mathcal{Z}$ 上的 $\{0,1\}$-值二值函数类。给定任意 $n$ 个样本 $\mathcal{S}_n = \{Z_1,\ldots,Z_n\} \in \mathcal{Z}^n$，我们关心函数类在这些点上能够实现的函数数量（即函数类在 $\epsilon = 0$ 时的一致 $L_\infty$ 覆盖）$\mathcal{G}(\mathcal{S}_n) = \{[\phi(w,Z_1),\ldots,\phi(w,Z_n)]: w \in \Omega\}$。我们引入 Vapnik 和 Chervonenkis (1971) 的如下定义。

**定义 4.15**（VC 维度） 如果 $|\mathcal{G}(\mathcal{S}_n)| = 2^n$，我们就说 $\mathcal{G}$ 打散了 $\mathcal{S}_n$。也就是说，我们总能找到 $w \in \Omega$ 使得 $\phi(w,z)$ 能够匹配在这 $n$ 个点上的任意可能的 $\{0,1\}^n$ 取值。使得 $\mathcal{G}$ 至少能打散一个 $\mathcal{S}_n \in \mathcal{Z}^n$ 的最大 $n$ 值，记为 $\operatorname{VC}(\mathcal{G})$，被称为 $\mathcal{G}$ 的 VC 维度。

注意，$\mathcal{G}(\mathcal{S}_n)$ 中函数的最大数量是 $2^n$。如果 $n > d$，那么对于任意 $n$ 个样本 $\mathcal{S}_n$，$\mathcal{G}(\mathcal{S}_n)$ 包含的元素少于 $2^n$。令人惊讶的是，如果一个二值函数类 $\mathcal{G}$ 的 VC 维度为 $d$，那么当 $n > d$ 时，集合 $\mathcal{G}(\mathcal{S}_n)$ 的大小只能以 $n$ 的多项式增长。这给出了具有有限 VC 维度的函数类的一致熵的 $O(d\ln n)$ 上界（参见 Vapnik and Chervonenkis, 1968, 1971; Sauer, 1972）。

**引理 4.16**（Sauer 引理） 如果 $\operatorname{VC}(\mathcal{G}) = d$，那么对于所有 $n > 0$ 和经验样本 $\mathcal{S}_n = \{Z_1,\ldots,Z_n\} \in \mathcal{Z}^n$，有：

$$|\mathcal{G}(\mathcal{S}_n)| \leq \sum_{\ell=0}^d\binom{n}{\ell} \leq \max(2,en/d)^d$$

!!! Info "证明"
    首先，我们在假设 $|\mathcal{G}(\mathcal{S}_n)|$ 被 $\mathcal{S}_n$ 的被打散子集（包括空集）的数量上界的条件下证明该陈述。在这个假设下，由于根据 VC 维度的定义，任何被 $\mathcal{G}$ 打散的子集大小不能超过 $d$，且大小为 $\ell$ 的子集数量为 $\binom{n}{\ell}$，我们知道被 $\mathcal{G}$ 打散的子集数量不能超过 $\sum_{\ell=0}^d\binom{n}{\ell}$。当 $n \geq d$ 时，我们有（见练习 4.1）

    $$\sum_{\ell=0}^d\binom{n}{\ell} \leq (en/d)^d$$

    当 $n \leq d$ 时，我们有 $\sum_{\ell=0}^d\binom{n}{\ell} \leq 2^d$。这就得到了所需的结果。

    接下来，我们只需要证明 $|\mathcal{G}(\mathcal{S}_n)|$ 被 $\mathcal{S}_n$ 的被打散子集数量上界的陈述。这可以通过对 $n$ 归纳来证明。当 $n = 1$ 时，可以很容易验证该陈述成立。

    现在假设该陈述对所有大小不超过 $n-1$ 的经验样本都成立。考虑 $n$ 个样本 $\{Z_1,\ldots,Z_n\}$。我们定义

    $$\phi(w,\mathcal{S}_k) = [\phi(w,Z_1),\ldots,\phi(w,Z_k)]$$
    $$\mathcal{G}_{n-1}(\mathcal{S}_n) = \{[\phi(w,\mathcal{S}_{n-1}),1]: [\phi(w,\mathcal{S}_{n-1}),0] \in \mathcal{G}(\mathcal{S}_n)\}$$

    使用归纳假设，我们知道 $|\mathcal{G}_{n-1}(\mathcal{S}_n)|$ 被 $\mathcal{S}_{n-1}$ 的被打散子集数量上界；对于每个被打散的 $\mathcal{S} \subset \mathcal{S}_{n-1}$，$\mathcal{S} \cup \{Z_n\}$ 被 $\mathcal{G}(\mathcal{S}_n)$ 打散，因为 $[\phi(w,\mathcal{S}_{n-1}),1]$ 和 $[\phi(w,\mathcal{S}_{n-1}),0]$ 都属于 $\mathcal{G}(\mathcal{S}_n)$。因此 $|\mathcal{G}_{n-1}(\mathcal{S}_n)|$ 不超过包含 $Z_n$ 的被打散子集的数量。

    此外，由于对于 $\phi(w,\cdot) \in \mathcal{G}(\mathcal{S}_n)-\mathcal{G}_{n-1}(\mathcal{S}_n)$，$\phi(w,Z_n)$ 由其在 $\mathcal{S}_{n-1}$ 上的取值唯一确定（如果不是这样，那么 $[\phi(w,\mathcal{S}_{n-1}),0]$ 和 $[\phi(w,\mathcal{S}_{n-1}),1]$ 都可以在 $\mathcal{G}(\mathcal{S}_n) - \mathcal{G}_{n-1}(\mathcal{S}_n)$ 中实现，这是不可能的，因为根据定义，我们应该把 $[\phi(w,\mathcal{S}_{n-1}),1]$ 放在 $\mathcal{G}_{n-1}(\mathcal{S}_n)$ 中），因此 $|\mathcal{G}(\mathcal{S}_n) - \mathcal{G}_{n-1}(\mathcal{S}_n)|$ 不超过 $|\mathcal{G}(\mathcal{S}_{n-1})|$。根据归纳假设，$|\mathcal{G}(\mathcal{S}_{n-1})|$ 不超过不包含 $Z_n$ 的被打散子集的数量。通过组合这两个事实，$|\mathcal{G}(\mathcal{S}_n)|$ 不超过被打散子集的数量。

Sauer 引理蕴含了具有有限 VC 维度的问题的如下预言不等式。这是推论 4.13 的直接推论。

**定理 4.17** 假设 $L(\cdot,\cdot) \in \{0,1\}$ 是一个二值损失函数。设 $\mathcal{G} = \{L(f(w,x),y): w \in \Omega\}$ 具有有限 VC 维度 $\operatorname{VC}(\mathcal{G}) = d$。给定 $n \geq d$，考虑近似 ERM 方法 (3.3)，以至少 $1-\delta$ 的概率，

$$\mathbb{E}_\mathcal{D}L(f(\hat{w},X),Y) \leq \inf_{w\in\Omega}\mathbb{E}_\mathcal{D}L(f(w,X),Y) + \epsilon' + \sqrt{\frac{8d\ln(en/d) + 8\ln(4/\delta)}{n}}$$

此外，对于所有 $\gamma \in (0,1)$，以至少 $1-\delta$ 的概率，以下不等式成立：

$$(1-\gamma)^2\mathbb{E}_\mathcal{D}L(f(\hat{w},X),Y) \leq \inf_{w\in\Omega}(1+\gamma)\mathbb{E}_\mathcal{D}L(f(w,X),Y) + \epsilon' + \frac{(6-3\gamma)(d\ln(en/d) + \ln(4/\delta))}{2\gamma n}$$

**命题 4.18** 考虑 $d$ 维的 $\{0,1\}$-值线性分类器 $\mathcal{F} = \{f_w(x) = \mathbb{1}(w^\top x \geq 0), w \in \mathbb{R}^d\}$，那么 $\operatorname{VC}(\mathcal{F}) = d$。这蕴含着 $d$ 维线性分类器 $\mathcal{G} = \{\mathbb{1}(f_w(X) \neq Y), w \in \mathbb{R}^d\}$ 的 VC 维度为 $\operatorname{VC}(\mathcal{G}) = d$。

!!! Info "证明"
    由于很容易找到被 $\mathcal{F}$ 打散的 $n = d$ 个点，我们只需要证明任何 $n = d+1$ 个点都不能被线性函数打散。

    设这 $d+1$ 个点为 $x_1,\ldots,x_{d+1}$。那么我们知道它们线性相关。因此存在 $d+1$ 个不全为零的实值系数 $a_1,\ldots,a_{d+1}$ 使得 $a_1x_1 + \cdots + a_{d+1}x_{d+1} = 0$，且我们可以假设存在至少一个 $a_j > 0$。

    为了证明 $x_1,\ldots,x_{d+1}$ 不能被打散，我们只需要证明不存在 $w \in \mathbb{R}^d$ 使得

    $$\mathbb{1}(w^\top x_i \geq 0) = 0\quad (a_i > 0);\quad \mathbb{1}(w^\top x_i \geq 0) = 1\quad (a_i \leq 0)$$

    这意味着这些点上的某个特定函数值组合不能实现。我们通过反证法证明这一点。假设上述函数值可以实现，那么对所有 $i$ 都有 $a_iw^\top x_i \leq 0$。由于存在至少一个 $a_j > 0$，我们知道对这个 $j$，有 $a_jw^\top x_j < 0$。因此

    $$\sum_{i=1}^{d+1}a_iw^\top x_i < 0$$

    然而，这与 $a_1x_1 + \cdots + a_{d+1}x_{d+1} = 0$ 矛盾。

注意定理 4.17 的结果对所有分布 $\mathcal{D}$ 都一致成立。因此，如果我们假设求解 ERM 在计算上是高效的，那么具有有限 VC 维度的概念类是 PAC 可学习的。另一方面，如果一个概念类的 VC 维度是无限的，那么对于任意样本大小 $n$，存在一个分布 $\mathcal{D}$ 和 $n$ 个样本，使得该概念类可以在 $\mathcal{D}$ 上实现所有可能的 $2^n$ 个二值取值。因此在这样的分布上，学习这个概念类不会比在某些训练分布上随机猜测更好。下面是一个无限 VC 维度的例子。

**例 4.19** 二值函数类 $\mathcal{G} = \{\mathbb{1}(\cos(wz) \geq 0): w,z \in \mathbb{R}\}$ 具有无限 VC 维度。

给定任意 $d$，我们考虑 $\{z_j = 16^{-j}\pi: j = 1,\ldots,d\}$。令 $w = \sum_{j=1}^d(1-b_j)16^j$，其中 $b_j \in \{0,1\}$。容易验证 $\mathbb{1}(\cos(wz_j) \geq 0) = b_j$。因此该集合可以被 $\mathcal{G}$ 打散。

## 4.5 使用一致 L2 覆盖数的一致收敛

为了应用引理 4.8，我们需要估计对称化经验过程的一致收敛。我们在第 4.3 节中已经展示了可以使用经验 $L_1$ 覆盖数来获得这样的界。在下面的内容中，我们将展示使用经验 $L_2$ 覆盖数可以获得更精细的结果，这要借助一个称为链式技术（chaining）的重要方法。这种改进是通过考虑多个近似尺度而不是第 4.3 节（以及第 3 章）中使用的单一尺度来实现的。最终的公式通常以所谓的熵积分形式表示，这种形式最早由 Dudley (1984) 提出。

虽然可以直接使用经验 $L_2$ 覆盖数进行分析，但使用 Rademacher 复杂度和集中不等式（如第 6 章所述）会更方便。因此我们将把详细分析留到第 6 章，这里只列出其结果以便与前面介绍的 $L_1$ 覆盖数分析进行比较。

以下结果是推论 6.19（一致收敛结果）和推论 6.21（预言不等式）的直接推论，其中 Rademacher 复杂度是通过定理 6.25 中的 $L_2$ 经验覆盖数估计得到的。

**命题 4.20** 给定函数类 $\mathcal{G} \in [0,1]$，令

$$\tilde{R}(\mathcal{G},\mathcal{S}_n) = \inf_{\epsilon_0\geq 0}\left[4\epsilon_0 + 12\int_{\epsilon_0}^{\infty}\sqrt{\frac{\ln N(\epsilon',\mathcal{G},L_2(\mathcal{S}_n))}{n}}d\epsilon'\right]$$

那么以至少 $1-\delta$ 的概率，对所有 $w \in \Omega$ 都有：

$$\phi(w,\mathcal{D}) \leq \phi(w,\mathcal{S}_n) + 2\mathbb{E}_{\mathcal{S}_n}[\tilde{R}(\mathcal{G},\mathcal{S}_n)] + \sqrt{\frac{\ln(1/\delta)}{2n}}$$

这意味着对于近似 ERM 方法 (3.3)，我们以至少 $1-\delta$ 的概率有：

$$\phi(\hat{w},\mathcal{D}) \leq \inf_{w\in\Omega}\phi(w,\mathcal{D}) + \epsilon' + 2\mathbb{E}_{\mathcal{S}_n}[\tilde{R}(\mathcal{G},\mathcal{S}_n)] + 2\sqrt{\frac{\ln(2/\delta)}{2n}}$$

在命题 4.20 中，$L_2$ 熵的平均积分替代了定理 4.12 中的最坏情况 $L_1$ 熵。如果 $\mathcal{G}$ 的一致 $L_2$ 熵形如

$$\ln N_2(\epsilon,\mathcal{G},n) = O(d\ln(1/\epsilon))$$

如 VC 维度的情况（见定理 5.6），那么复杂度项

$$\mathbb{E}_{\mathcal{S}_n}[\tilde{R}(\mathcal{G},\mathcal{S}_n)] = O(1/\sqrt{n})$$

这消除了第 4.3 节中一致 $L_1$ 熵分析中的一个 $\ln n$ 因子。此外，如果 $\mathcal{G}$ 的一致 $L_2$ 熵形如

$$\ln N_2(\epsilon,\mathcal{G},n) = O(\epsilon^{-q})$$

其中 $q < 2$，那么复杂度项

$$\mathbb{E}_{\mathcal{S}_n}[\tilde{R}(\mathcal{G},\mathcal{S}_n)] = O(1/\sqrt{n})$$

满足 (4.3) 的函数类是 Donsker 类，对它们成立中心极限定理。

相比之下，如果我们考虑定理 4.12 中的一致 $L_1$ 覆盖数分析，并假设

$$\ln N_1(\epsilon,\mathcal{G},n) = O(\epsilon^{-q})$$

那么加性 Chernoff 界中的复杂度项为

$$\epsilon_n(\delta) = \inf_{\epsilon>0}O\left(\epsilon + \sqrt{\epsilon^{-q}/n}\right) = n^{-1/(q+2)}$$

这意味着收敛速率慢于 $1/\sqrt{n}$。

在方差条件下也可以获得快速收敛速率。这样的推导我们将留到第 6.5 节。

## 4.6 使用一致 L_\infty 覆盖数的一致收敛

$L_\infty$ 覆盖数分析已被用于研究训练损失和测试损失不同的大间隔方法。考虑函数类 $\mathcal{F} = \{f(w,x): w \in \Omega\}$ 和测试损失 $L(f(x),y)$。然而，我们不直接最小化测试损失，而是尝试最小化一个替代训练损失：

$$\frac{1}{n}\sum_{i=1}^n\tilde{L}(f(\hat{w},X_i),Y_i) \leq \inf_{w\in\Omega}\left[\frac{1}{n}\sum_{i=1}^n\tilde{L}(f(w,X_i),Y_i)\right] + \epsilon'$$

其中我们假设替代损失是在小的 $L_\infty$ 扰动（大小为 $\gamma > 0$）下训练损失的上界：

$$\tilde{L}(f,y) \geq \sup_{|f'-f|\leq\gamma}L(f',y)$$

在这种情况下，我们希望用替代训练损失来界定测试损失。对于二分类问题（$y \in \{\pm1\}$），一个例子是取测试损失为二分类错误 $L(f(x),y) \leq \mathbb{1}(f(x)y \leq 0)$，而 $\tilde{L}(f(x),y) = \mathbb{1}(f(x)y \leq \gamma)$ 作为间隔误差，其中 $\gamma > 0$。

$L_\infty$ 覆盖数可以用来获得类似于定理 4.12 的结果，证明方法也类似。

**定理 4.21** 假设对所有 $w$ 和 $(x,y)$ 都有 $\tilde{L}(f(w,x),y),L(f(w,x),y) \in [0,1]$，且 (4.4) 和 (4.5) 都成立。那么给定 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率，以下不等式对所有 $w \in \Omega$ 成立：

$$\mathbb{E}_{(X,Y)\sim\mathcal{D}}L(f(w,X),Y) \leq \frac{1}{n}\sum_{i=1}^n\tilde{L}(f(w,X_i),Y_i) + 3\sqrt{\frac{\ln(3N_\infty(\gamma/2,\mathcal{F},2n)/\delta)}{2n}}$$

此外，以至少 $1-\delta$ 的概率，以下不等式对所有 $w \in \Omega$ 成立：

$$(1-\gamma)^2\mathbb{E}_{(X,Y)\sim\mathcal{D}}L(f(w,X),Y) \leq \frac{1}{n}\sum_{i=1}^n\tilde{L}(f(w,X_i),Y_i) + \frac{(5-4\gamma)\ln(3N_\infty(\gamma/2,\mathcal{F},2n)/\delta)}{2\gamma n}$$

类似于推论 4.13，我们也可以从定理 4.21 获得预言不等式，这里我们不再详述。

**例 4.22** 考虑二分类问题，分类器 $f(w,X) \in \mathbb{R}$ 且 $Y \in \{\pm1\}$。分类损失为

$$L(f(X),Y) = \mathbb{1}(f(X)Y \leq 0)$$

对于 $\gamma > 0$，间隔损失为

$$\tilde{L}(f(X),Y) = \mathbb{1}(f(X)Y \leq \gamma)$$

定理 4.21 意味着

$$\mathbb{1}(f(X)Y \leq 0) \leq \frac{1}{n}\sum_{i=1}^n\mathbb{1}(f(w,X_i)Y_i \leq \gamma) + 3\sqrt{\frac{\ln(3N_\infty(\gamma/2,\mathcal{F},2n)/\delta)}{2n}}$$

因此如果函数类在尺度 $\gamma/2$ 处具有有限的 $L_\infty$ 范数，那么最小化间隔损失会导致训练损失的近似最小化。与 VC 维度不同，$L_\infty$ 覆盖对于具有适当正则化的无限维系统也可以很小。例如，如果我们考虑正则化线性函数类

$$\{f(w,x) = w^\top\psi(x): \|w\|_2 \leq A\}$$

且假设 $\|\psi(x)\|_2 \leq B$，那么定理 5.20 意味着

$$\ln N_\infty(\gamma/2,\mathcal{F},2n) = O\left(\frac{A^2B^2\ln(n + AB/\gamma)}{\gamma^2}\right)$$

这与 $w$ 的维度无关。相比之下，即使有正则化，VC 维度也依赖于 $w$ 的维度。这意味着对于高维问题，最大化间隔会导致更稳定的泛化性能。
