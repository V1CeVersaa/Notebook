# Chapter 3: Uniform Convergence and Generalization Analysis

## 3.1 PAC 学习

## 3.3 经验过程

可实现 PAC 学习的分析可以推广到处理一般的非二值函数类，这些函数类可能包含无限多个函数。它也可以推广到处理不可实现的情况，即 $f_*(x) \notin \mathcal{C}$ 或当观测值 $Y$ 包含噪声的情况。对于这些情况，相应的分析需要用到**经验过程**这个技术工具。

为了简化记号，在一般设定下，我们可以将观测值表示为 $Z_i = (X_i,Y_i) \in \mathcal{Z} = \mathcal{X} \times \mathcal{Y}$，预测函数表示为 $f(X_i)$（通常是一个向量值函数），损失函数表示为 $L(f(X_i),Y_i)$。进一步假设 $f(x)$ 由参数 $w \in \Omega$ 参数化为 $f(w,x)$，假设空间为 $\{f(w,\cdot): w \in \Omega\}$。

设训练数据 $\mathcal{S}_n = \{Z_i = (X_i,Y_i): i = 1,\ldots,n\}$。在下文中，我们考虑 ERM 的一个更一般形式，即**近似 ERM**，它对某个 $\epsilon' > 0$ 满足如下不等式：

$$\frac{1}{n}\sum_{i=1}^n L(f(\hat{w},X_i),Y_i) \leq \inf_{w\in\Omega}\left[\frac{1}{n}\sum_{i=1}^n L(f(w,X_i),Y_i)\right] + \epsilon'$$

这里的量 $\epsilon' > 0$ 表示我们解决 ERM 问题的精确程度。我们引入以下简化记号，这些记号将贯穿全书使用。

**定义 3.8**：我们定义 $\displaystyle \phi(w,z) = L(f(w,x),y) - L_*(x,y)$，其中 $w \in \Omega$ 且 $z = (x,y) \in \mathcal{Z} = \mathcal{X} \times \mathcal{Y}$，这里的 $L_*(x,y)$ 是预先选定的、不依赖于 $w$ 的 $z = (x,y)$ 的函数。

对于训练数据 $\mathcal{S}_n = \{Z_i = (X_i,Y_i): i = 1,\ldots,n\}$，我们定义 $w \in \Omega$ 的**训练损失**为：

$$\phi(w,\mathcal{S}_n) = \frac{1}{n}\sum_{i=1}^n\phi(w,Z_i)$$

此外，对于 $\mathcal{Z}$ 上的分布 $\mathcal{D}$，我们定义 $w \in \Omega$ 的**测试损失**为：

$$\phi(w,\mathcal{D}) = \mathbb{E}_{Z\in\mathcal{D}}\phi(w,Z)$$

由于 $L_*(x,y)$ 不依赖于 $w$，因此关于损失 $L(\cdot)$ 的 ERM 解等价于关于 $\phi(w,\cdot)$ 的 ERM 解。因此在简化记号下，近似 ERM 方法是如下方法的特例：

$$\phi(\hat{w},\mathcal{S}_n) \leq \inf_{w\in\Omega}\phi(w,\mathcal{S}_n) + \epsilon'$$

一般情况下，我们可以简单地取 $L_*(x,y) = 0$。然而，对于某些应用，我们可能选择非零的 $L_*(x,y)$ 使得

$$L(f(w,x),y) - L_*(x,y)$$

具有较小的方差。对于最小二乘损失，这可以通过取 $L_*(x,y) = L(f_*(x),y)$ 来实现，其中 $f_*(x)$ 是最小化测试损失的最优预测函数，如下例所示。较小的方差结合 Bernstein 不等式意味着更好的泛化界（见 3.6 节）。

**例子 3.9** ：虑线性模型 $f(w,x) = w^\top x$，令 $L(f(w,x),y) = (w^\top x - y)^2$ 为最小二乘损失。那么当 $L_*(x,y) = 0$ 时，我们有 $\phi(w,z) = (w^\top x - y)^2$，其中 $z = (x,y)$。

如果我们进一步假设问题可以由线性模型实现，且 $w_*$ 是真实的权重向量：$\mathbb{E}[y|x] = w_*^\top x$。那么我们可以取 $L_*(x,y) = (w_*^\top x - y)^2$，此时

$$\phi(w,z) = (w^\top x - y)^2 - (w_*^\top x - y)^2$$

当 $w \approx w_*$ 时具有较小的方差，因为 $\lim\limits_{w\to w_*}\phi(w,z) = 0$。

我们现在假设训练数据 $Z_i$ 是从未知测试分布 $\mathcal{D}$ 中独立同分布采样的。类似于 PAC 学习分析，我们感兴趣的是用 ERM 方法的训练误差 $\phi(\hat{w},\mathcal{S}_n)$ 来界定测试误差 $\phi(\hat{w},\mathcal{D})$。

损失函数族形成了一个由 $w \in \Omega$ 索引的函数类 $\{\phi(w,z): w \in \Omega\}$。我们称 $\{\phi(w,\mathcal{S}_n): w \in \Omega\}$ 为由 $\Omega$ 索引的**经验过程**。类似 PAC 学习分析，我们需要界定对所有 $w \in \Omega$ 成立的训练误差到测试误差的一致收敛。这也被称为经验过程 $\{\phi(w,\mathcal{S}_n): w \in \Omega\}$ 的一致收敛。

**定义 3.10**（一致收敛）：给定模型空间 $\Omega$ 和分布 $\mathcal{D}$，设 $\mathcal{S}_n \sim \mathcal{D}^n$ 是从 $\mathcal{Z}$ 上的 $\mathcal{D}$ 采样的 $n$ 个独立同分布样本。如果对于所有 $\epsilon > 0$，有

$$\lim_{n\to\infty}\operatorname{Pr}\left(\sup_{w\in\Omega}|\phi(w,\mathcal{S}_n) - \phi(w,\mathcal{D})| > \epsilon\right) = 0$$

其中概率是对 $\mathcal{S}_n \sim \mathcal{D}^n$ 的独立同分布样本取的，则称 $\phi(w,\mathcal{S}_n)$ $(w \in \Omega)$ **依概率一致收敛**到 $\phi(w,\mathcal{D})$。

一致收敛也被称为大数定律的一致形式。它表明大数定律对所有可能依赖于训练数据 $\mathcal{S}_n$ 的 $\hat{w} \in \Omega$ 都成立。因此它可以应用于任何学习算法的输出。虽然定义中的双边一致收敛在文献中经常使用，但我们将采用单边一致收敛，因为这对于乘法界更方便。

类似于 PAC 学习的分析，一致收敛结果可以用来获得近似 ERM 解的预言不等式，如下面的引理所示。注意，对于 Chernoff 型界，我们可以取 $\alpha = \alpha' = 1$。然而，如果我们应用乘法 Chernoff 界或 Bernstein 不等式，那么我们通常选择乘法因子 $\alpha < 1$ 和 $\alpha' > 1$。

**引理 3.11**：假设对于任意 $\delta \in (0,1)$，以下一致收敛结果对某个 $\alpha > 0$ 成立（我们允许 $\alpha$ 依赖于 $\mathcal{S}_n$）。以至少 $1-\delta_1$ 的概率，

$$\forall w \in \Omega: \alpha\phi(w,\mathcal{D}) \leq \phi(w,\mathcal{S}_n) + \epsilon_n(\delta_1,w)$$

此外，对所有 $w \in \Omega$，以下不等式对某个 $\alpha' > 0$ 成立（我们允许 $\alpha'$ 依赖于 $\mathcal{S}_n$）。以至少 $1-\delta_2$ 的概率，

$$\phi(w,\mathcal{S}_n) \leq \alpha'\phi(w,\mathcal{D}) + \epsilon_n'(\delta_2,w)$$

那么以下陈述成立。以至少 $1-\delta_1-\delta_2$ 的概率，近似 ERM 方法满足预言不等式：

$$\alpha\phi(\hat{w},\mathcal{D}) \leq \inf_{w\in\Omega}[\alpha'\phi(w,\mathcal{D}) + \epsilon_n'(\delta_2,w)] + \epsilon' + \epsilon_n(\delta_1,\hat{w})$$

!!! Info "证明"
    考虑任意 $w \in \Omega$。以至少 $1-\delta_1$ 的概率，我们有：
    
    $$\begin{aligned}
    \alpha\phi(\hat{w},\mathcal{D}) &\leq \phi(\hat{w},\mathcal{S}_n) + \epsilon_n(\delta_1,\hat{w}) \\
    &\leq \phi(w,\mathcal{S}_n) + \epsilon' + \epsilon_n(\delta_1,\hat{w})
    \end{aligned}$$
    
    其中第一个不等式是由一致收敛得到的，第二个不等式是由近似 ERM 得到的。此外，以至少 $1-\delta_2$ 的概率，
    
    $$\phi(w,\mathcal{S}_n) \leq \alpha'\phi(w,\mathcal{D}) + \epsilon_n'(\delta_2,w)$$
    
    取这两个事件的并集界，我们得到以至少 $1-\delta_1-\delta_2$ 的概率，上述两个不等式同时成立。因此
    
    $$\begin{aligned}
    \alpha\phi(\hat{w},\mathcal{D}) &\leq \phi(w,\mathcal{S}_n) + \epsilon' + \epsilon_n(\delta_1,\hat{w}) \\
    &\leq \alpha'\phi(w,\mathcal{D}) + \epsilon_n'(\delta_2,w) + \epsilon' + \epsilon_n(\delta_1,\hat{w})
    \end{aligned}$$
    
    由于 $w$ 是任意的，我们令 $w$ 趋近于右端的最小值，就得到了所需的界。

我们观察到在引理 3.11 中，第一个条件要求对所有 $w \in \Omega$ 都有一致收敛。第二个条件不要求一致收敛，只要求第 2 章的尾概率界对所有单个 $w \in \Omega$ 成立即可。这里的结果表明经验过程的一致收敛可以用来推导 ERM 方法的预言不等式。

## 3.6 一致 Bernstein 不等式

**定义 3.16**（方差条件）：给定一个函数类 $\mathcal{G}$，如果存在常数 $c_0, c_1 > 0$ 使得对于所有 $\phi(z) \in \mathcal{G}$，满足：

$$\operatorname{Var}_{Z\sim \mathcal{D}}(\phi(Z)) \leq c_0^2 + c_1\mathbb{E}_{Z\sim \mathcal{D}}\phi(Z)$$

其中我们要求对于所有 $\phi \in \mathcal{G}$ 都有 $\mathbb{E}_{Z\sim \mathcal{D}}\phi(Z) \geq -c_0^2/c_1$，则称 $\mathcal{G}$ 满足方差条件。

在实际应用中，方差条件的以下变形形式通常更方便使用：

$$\mathbb{E}_{Z\sim \mathcal{D}}[\phi(Z)^2] \leq c_0^2 + c_1\mathbb{E}_{Z\sim \mathcal{D}}\phi(Z)$$

很容易看出，变形形式显然蕴含原始形式。如果 $\phi(Z)$ 是有界的，那么这两个条件是等价的。

**定理 3.21**： 假设对于所有 $\epsilon \in [0,\epsilon_0]$，函数类 $\mathcal{G} = \{\phi(w,z)\colon w \in \Omega\}$ 具有 $\epsilon$-下括号覆盖 $\mathcal{G}(\epsilon)$，其中覆盖的成员数为 $N_{LB}(\epsilon,\mathcal{G},L_1(\mathcal{D}))$，且 $\mathcal{G}(\epsilon)$ 满足方差条件。此外，假设对于所有 $\phi(z) = \phi(w,z) \in \mathcal{G} \cup \mathcal{G}(\epsilon)$ 作为 $z \in \mathcal{Z}$ 的函数，随机变量 $\phi(z)$ 满足 Bernstein 不等式对于随机变量的中心矩的条件，其中 $V = \operatorname{Var}(\phi(Z))$ 且 $\mathbb{E}_{Z\sim\mathcal{D}}\phi(Z) \geq 0$。那么对于所有 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率，对所有 $\gamma \in (0,1)$ 和 $w \in \Omega$ 都有：

$$(1-\gamma)\phi(w,\mathcal{D}) \leq \phi(w,S_n) + \epsilon_n^*(\delta,\mathcal{G},\mathcal{D})$$

其中

$$\begin{aligned}
    \epsilon_n^*(\delta,\mathcal{G},\mathcal{D}) = &\inf_{\epsilon\in[0,\epsilon_0]}\left[(1-\gamma)\epsilon + c_0\left(\frac{2\ln(N_{LB}(\epsilon,\mathcal{G},L_1(\mathcal{D}))/\delta)}{n}\right)^{1/2} \right.\\
    &+\left. \frac{(3c_1 + 2\gamma b)\ln(N_{LB}(\epsilon,\mathcal{G},L_1(\mathcal{D}))/\delta)}{6\gamma n}\right]
\end{aligned}$$

!!! Info "证明"
    对于任意 $\epsilon > 0$，令 $\mathcal{G}(\epsilon) = \{\phi_1(z),\ldots,\phi_N(z)\}$ 是 $\mathcal{G}$ 的 $\epsilon$-下括号覆盖，其中 $N = N_{LB}(\epsilon,\mathcal{G},L_1(\mathcal{D}))$。

    使用 Bernstein 不等式和并集界，我们可以得到以下结论。以至少 $1-\delta$ 的概率，对所有 $j$ 都有：

    $$\begin{aligned}
        \mathbb{E}_{Z\sim\mathcal{D}}\phi_j(Z) &\leq \frac{1}{n}\sum_{i=1}^n\phi_j(Z_i) + \sqrt{\frac{2\operatorname{Var}_{Z\sim\mathcal{D}}\phi_j(Z)\ln(N/\delta)}{n}} + \frac{b\ln(N/\delta)}{3n} \\
        &\leq \frac{1}{n}\sum_{i=1}^n\phi_j(Z_i) + \sqrt{\frac{2c_0^2\ln(N/\delta)}{n}} + \sqrt{\frac{2c_1\mathbb{E}_{Z\sim\mathcal{D}}\phi_j(Z)\ln(N/\delta)}{n}} + \frac{b\ln(N/\delta)}{3n} \\
        &\leq \frac{1}{n}\sum_{i=1}^n\phi_j(Z_i) + c_0\sqrt{\frac{2\ln(N/\delta)}{n}} + \gamma\mathbb{E}_{Z\sim\mathcal{D}}\phi_j(Z) + \frac{c_1\ln(N/\delta)}{2\gamma n} + \frac{b\ln(N/\delta)}{3n}
    \end{aligned}$$

    因此对于所有 $w \in \Omega$，令 $j = j(w)$，我们得到：

    $$\begin{aligned}
        (1-\gamma)\mathbb{E}_{Z\sim\mathcal{D}}\phi(w,Z) &\leq (1-\gamma)\mathbb{E}_{Z\sim\mathcal{D}}\phi_j(Z) + (1-\gamma)\epsilon \\
        &\leq \frac{1}{n}\sum_{i=1}^n\phi_j(Z_i) + c_0\left(\frac{2\ln(N/\delta)}{n}\right)^{1/2} + \frac{(3c_1 + 2\gamma b)\ln(N/\delta)}{6\gamma n} + (1-\gamma)\epsilon \\
        &\leq \frac{1}{n}\sum_{i=1}^n\phi(w,Z_i) + c_0\left(\frac{2\ln(N/\delta)}{n}\right)^{1/2} + \frac{(3c_1 + 2\gamma b)\ln(N/\delta)}{6\gamma n} + (1-\gamma)\epsilon
    \end{aligned}$$

    这就完成了证明。

**推论 3.22**：令 $w_* = \mathop{\arg\min}_{w\in\Omega}\mathbb{E}_{(X,Y)\sim\mathcal{D}}L(f(w,X),Y)$，并假设上面定理的条件对于 $\phi(w,z) = L(f(w,x),y)-L(f(w_*,x),y)$ 成立。那么，以至少 $1-\delta$ 的概率，近似 ERM 方法满足如下预言不等式：

$$\mathbb{E}_{(X,Y)\sim\mathcal{D}}L(f(\hat{w},X),Y) \leq \mathbb{E}_{(X,Y)\sim\mathcal{D}}L(f(w_*,X),Y) + 2(\epsilon_n^{1/2}(\delta,\mathcal{G},\mathcal{D}) + \epsilon^{\prime})$$

其中 $\epsilon_n^*(\delta,\mathcal{G},\mathcal{D})$ 由上一个定理给出。

!!! Info "证明"
    上一个定理蕴含以下结果。对于所有 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率有：

    $$(1-\gamma)\phi(\hat{w},\mathcal{D}) \leq \phi(\hat{w},S_n) + \epsilon_n^{\gamma}(\delta,\mathcal{G},\mathcal{D})$$

    由于我们定义的近似经验风险最小化器满足 $\phi(\hat{w},S_n) \leq \epsilon'$，我们得到：

    $$(1-\gamma)\phi(\hat{w},\mathcal{D}) \leq \epsilon' + \epsilon_n^{\gamma}(\delta,\mathcal{G},\mathcal{D})$$

    我们令 $\gamma = 1/2$ 就可以得到我们想要的界。

## 3.7 一般括号数

在某些应用中，我们对双边一致收敛感兴趣，它界定了如下误差：

$$\sup_{w\in\Omega}|\phi(w,\mathcal{S}_n) - \phi(w,\mathcal{D})|$$

为了获得这样的一致收敛结果，我们可以采用如下定义的双边括号覆盖。

**定义 3.27**（括号数）：设 $\mathcal{G} = \{\phi(w,\cdot): w \in \Omega\}$ 是具有伪度量 $d$ 的实值函数类，我们称

$$\mathcal{G}(\epsilon) = \{[\phi_1^L(z),\phi_1^U(z)],\ldots,[\phi_N^L(z),\phi_N^U(z)]\}$$

是 $\mathcal{G}$ 在度量 $d$ 下的一个 $\epsilon$-括号，如果对于所有 $w \in \Omega$，存在 $j = j(w)$ 使得对所有 $z$ 都有：

$$\phi_j^L(z) \leq \phi(w,z) \leq \phi_j^U(z),\quad d(\phi_j^L,\phi_j^U) \leq \epsilon$$

$\epsilon$-括号数是这样的 $\mathcal{G}(\epsilon)$ 的最小基数 $N_{[]}(\epsilon,\mathcal{G},d)$，$\ln N_{[]}(\epsilon,\mathcal{G},d)$ 被称为 $\epsilon$ 括号熵。

特别地，给定分布 $\mathcal{D}$ 和 $p \geq 1$，我们可以在函数空间中定义 $L_p$-半范数为：

$$\|f - f'\|_{L_p(\mathcal{D})} = [\mathbb{E}_{Z\sim\mathcal{D}}|f(Z) - f'(Z)|^p]^{1/p}$$

它诱导出一个伪度量，记为 $d = L_p(\mathcal{D})$，相应的括号数为 $N_{[]}(\epsilon,\mathcal{G},L_p(\mathcal{D}))$。

对于 $p = \infty$，$L_\infty(\mathcal{D})$-半范数定义为本质上确界半范数，导出的伪度量为：

$$d(f,f') = \inf\{\omega: \operatorname{Pr}_\mathcal{D}[|f(Z) - f'(Z)| \leq \omega] = 1\}$$

然而，当 $p = \infty$ 时，相比使用 $L_\infty$ 括号数，更常用的是等价的 $L_\infty$ 覆盖数概念，我们在下一章继续讨论覆盖数这个概念。

**命题 3.28**：对于所有 $p \geq 1$，我们有：

$$N_{LB}(\epsilon,\mathcal{G},L_1(\mathcal{D})) \leq N_{[]}(\epsilon,\mathcal{G},L_1(\mathcal{D})) \leq N_{[]}(\epsilon,\mathcal{G},L_p(\mathcal{D}))$$

此命题意味着对下括号数成立的命题，对不同范数下的 $L_p$ 括号数也成立。我们还有括号数的如下性质，它可以用来推导函数类组合的括号数。

**命题 3.29**：考虑函数类 $\mathcal{F}$ 和 $\mathcal{G}$。对于任意实数 $\alpha$ 和 $\beta$，定义函数类

$$\alpha\mathcal{F} + \beta\mathcal{G} = \{\alpha f(z) + \beta g(z): f \in \mathcal{F}, g \in \mathcal{G}\}$$

则有

$$\ln N_{[]}(\lvert\alpha\rvert\epsilon_1 + \lvert\beta\rvert\epsilon_2,\alpha\mathcal{F} + \beta\mathcal{G},L_p(\mathcal{D})) \leq \ln N_{[]}(\epsilon_1,\mathcal{F},L_p(\mathcal{D})) + \ln N_{[]}(\epsilon_2,\mathcal{G},L_p(\mathcal{D}))$$

此外，设 $\psi(a): \mathbb{R} \to \mathbb{R}$ 是一个 Lipschitz 函数：$|\psi(a) - \psi(b)| \leq \gamma|a - b|$。令 $\psi(\mathcal{F}) = \{\psi(f(z)): f \in \mathcal{F}\}$，则

$$\ln N_{[]}(\gamma\epsilon,\psi(\mathcal{F}),L_p(\mathcal{D})) \leq \ln N_{[]}(\epsilon,\mathcal{F},L_p(\mathcal{D}))$$

