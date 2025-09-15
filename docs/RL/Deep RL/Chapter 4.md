# Chapter 5: Policy Gradient Methods for Deep RL

## 5.1 Stochastic Policy Gradient

$$
V^\pi (s_0) = \int_{\mathcal{S}} \rho^{\pi} (s) \int_{\mathcal{A}} \pi (s, a) R^{\prime} \, \mathrm{d} a\, \mathrm{d} s, \tag{5.1}
$$

其中：

- $R^{\prime}(s, a) = \displaystyle\int_{s^{\prime} \in\mathcal{S}} T(s, a, s^{\prime}) R(s, a, s^{\prime})\,\mathrm{d}s^{\prime}$ 代表给定了 $(s, a)$ 之后的期望即时奖励；
- $\rho^{\pi} (s) = \displaystyle\sum\limits_{t=0}^{\infty} \gamma^t \cdot \mathbb{P} \left\{s_t = s \mid s_0, \pi\right\}$ 表示从状态 $s_0$ 出发，在策略 $\pi$ 下，带折扣地期望访问状态 $s$ 的次数。

因此可以见得，式 (5.1) 的内层积分就是在策略 $\pi$ 下，给定状态 $s$ 时，对所有可能采取的动作 $a$ 的期望即时奖励；而外层积分则是对所有可能被访问到的状态 $s$ 求期望，权重是访问频率 $\rho^{\pi}(s)$，这两次积分就确定出了从 $s_0$ 出发，遵循策略 $\pi$ 的期望折扣回报 $V^{\pi}(s_0)$。

$$
\nabla_w V^{\pi_w}(s_0) = \mathbb{E}_{s\sim \rho^{\pi_w}, a\sim \pi_w} \left[\nabla_w \log \pi_w(s,a) \cdot Q^{\pi_w}(s,a)\right]. \tag{5.4}
$$

<!--

- 段落 2（策略梯度定理，式 5.2）
  对于可微的策略 $\pi_w$，支撑这些算法的根本结果是策略梯度定理（Sutton et al., 2000）：
  $$
  \nabla_w V^{\pi^w}(s_0)
  = \int_{\mathcal S}\rho^{\pi^w}(s)\int_{\mathcal A}
  \nabla_w \pi_w(s,a)\, Q^{\pi^w}(s,a)\,da\,ds.
  \tag{5.2}
  $$
  该结果使我们能够基于经验来调整策略参数：$\Delta w \propto \nabla_w V^{\pi^w}(s_0)$。有趣的是，策略梯度并不依赖于状态分布的梯度（尽管你可能会预期它会依赖）。推导策略梯度估计器（即从经验估计 $\nabla_w V^{\pi^w}(s_0)$）的最简单方法，是使用记分函数（score function）梯度估计器，即众所周知的 REINFORCE 算法（Williams, 1992）。可以利用似然比技巧（likelihood-ratio trick）从期望中导出通用的梯度估计方法：
  $$
  \begin{aligned}
  \nabla_w \pi_w(s,a)
  &= \pi_w(s,a)\,\frac{\nabla_w \pi_w(s,a)}{\pi_w(s,a)}  \\
  &= \pi_w(s,a)\,\nabla_w \log \pi_w(s,a).
  \end{aligned}
  \tag{5.3}
  $$
  由式 (5.3) 可得
  $$
  \nabla_w V^{\pi^w}(s_0)
  = \mathbb{E}_{s\sim \rho^{\pi^w},\, a\sim \pi_w}
  \big[\,\nabla_w \log \pi_w(s,a)\, Q^{\pi^w}(s,a)\,\big].
  \tag{5.4}
  $$

- 段落 3（折扣与未折扣状态分布）
  请注意，在实践中，大多数策略梯度方法实际上使用未折扣的状态分布，而不会降低其性能（Thomas, 2014）。

- 段落 4（评估−改进两步）
  迄今为止，我们已经表明，策略梯度方法应包含一次策略评估，随后进行一次策略改进。一方面，策略评估估计 $Q^{\pi^w}$；另一方面，策略改进则采取一个梯度步，以相对于价值函数估计来优化策略 $\pi_w(s,a)$。直观地讲，策略改进步骤会按各动作的期望回报成比例地提高其被选中的概率。

- 段落 5（如何进行评估：蒙特卡洛与评论）
  尚需回答的问题是，智能体如何执行策略评估步骤，即如何得到 $Q^{\pi^w}(s,a)$ 的估计。估计梯度的最简单方法，是用整条轨迹的累计回报替代 $Q$ 函数的估计器。在蒙特卡洛策略梯度中，我们在按策略 $\pi_w$ 与环境交互的 rollout 中估计 $Q^{\pi^w}(s,a)$。当与神经网络策略的反向传播结合使用时，蒙特卡洛估计器是一个无偏且性质良好的估计器，因为它一直估计到轨迹末端（不会因自举引入的不稳定）。然而，主要缺点是该估计需要 on-policy 的 rollouts，且方差可能很高。为了得到良好的回报估计，通常需要多次 rollout。更高效的做法是改用基于价值的方法给出的回报估计，这将在 §5.3 的 actor-critic 方法中讨论。

- 段落 6（两点附加说明：熵正则与优势函数）
  我们再做两点补充。第一，为防止策略变为确定性的，通常会在梯度中加入一个熵正则项。借助这一正则器，学习到的策略可以保持随机性，从而确保策略持续探索。
  
  第二，可用优势函数 $A^{\pi^w}$ 替代式 (5.4) 中的 $Q^{\pi^w}$。在策略 $\pi_w$ 下，$Q^{\pi^w}(s,a)$ 概括了某状态下每个动作的表现；而优势函数
  $$
  A^{\pi^w}(s,a) = Q^{\pi^w}(s,a) - V^{\pi^w}(s)
  $$
  为每个动作相对该状态期望回报 $V^{\pi^w}(s)$ 提供了比较尺度。使用 $A^{\pi^w}(s,a)$ 通常具有比 $Q^{\pi^w}(s,a)$ 更小的幅值。这有助于在策略改进步骤中降低梯度估计器 $\nabla_w V^{\pi^w}(s_0)$ 的方差，同时不改变其期望。换言之，$V^{\pi^w}(s)$ 可被视为梯度估计器的基线（baseline）或控制变元（control variate）。在更新拟合策略的神经网络时，使用这样的基线可以提高数值效率——即用更少的更新达到既定性能——因为可以使用更大的学习率。

二) 讲解与补充

1. 记号与直觉
- 轨迹与回报：$\tau=(s_0,a_0,s_1,\dots)$，$R(\tau)=\sum_{t=0}^{T-1}\gamma^t r_t$。
- 折扣访问分布：$\rho^\pi(s)=\sum_t \gamma^t \Pr(s_t=s)$。很多实现直接用经验频次近似它，或用未折扣分布 $d^\pi(s)=\sum_t \Pr(s_t=s)$；两者只差与时间位置相关的权重，对梯度方向影响很小，且在理论上也可证明若采用 reward-to-go 形式并适当处理，性能不受影响（Thomas, 2014）。

1. 策略梯度定理的常见推导脉络（简要）
- 从性能目标出发：
  $$
  J(w)=\mathbb{E}_{\tau\sim \pi_w}[R(\tau)]
  =\sum_{t}\mathbb{E}_{s_t,a_t\sim \pi_w}[\gamma^t r_t].
  $$
- 使用对数导数技巧（likelihood-ratio trick）：
  $$
  \nabla_w \mathbb{E}_{x\sim p_w}[f(x)]
  =\mathbb{E}_{x\sim p_w}\!\left[f(x)\,\nabla_w \log p_w(x)\right].
  $$
- 将 $p_w$ 取为由策略诱导的动作序列分布，得到
  $$
  \nabla_w J(w)
  = \mathbb{E}\!\left[\sum_{t=0}^{T-1}\nabla_w \log \pi_w(a_t|s_t)\, G_t\right],
  $$
  其中 $G_t=\sum_{k=t}^{T-1}\gamma^{k-t} r_k$ 为“reward-to-go”。若再把 $G_t$ 换成 $Q^{\pi^w}(s_t,a_t)$ 的一致估计，就得到式 (5.4)。

1. REINFORCE 与 MC 策略梯度
- 纯 MC 估计器：
  $$
  \widehat{\nabla_w J}
  = \frac{1}{N}\sum_{i=1}^N \sum_{t=0}^{T_i-1}
    \nabla_w \log \pi_w(a_t^{(i)}|s_t^{(i)})\, G_t^{(i)}.
  $$
- 优点：无偏、实现简单、可直接反向传播。
- 缺点：需 on-policy 采样，方差高，对长时间跨度和稀疏奖励不友好。

1. 基线/优势与无偏性的证明要点
- 对任意仅依赖状态的函数 $b(s)$，
  $$
  \mathbb{E}_{a\sim \pi(\cdot|s)}\!\left[\nabla_w \log \pi(a|s)\, b(s)\right]
  = b(s)\,\nabla_w \sum_a \pi(a|s) = b(s)\,\nabla_w 1 = 0,
  $$
  因此替换 $G_t$ 为 $G_t - b(s_t)$ 不改变期望，只降低方差。令 $b(s)=V^{\pi}(s)$ 即得到优势 $A^\pi$。

1. 熵正则与实现
- 在目标中加入熵项：
  $$
  J_{\text{ent}}(w)= J(w)
  + \beta\,\mathbb{E}_{s\sim d^\pi}\big[ \mathcal H(\pi_w(\cdot|s))\big],
  \quad
  \mathcal H(\pi)=-\sum_a \pi(a|s)\log \pi(a|s),
  $$
  则更新中多出一项 $\beta\,\nabla_w \mathbb{E}[\mathcal H(\pi_w(\cdot|s))]$，以鼓励探索、避免过早确定性化。

1. 从 MC 到 Actor-Critic（为 §5.3 铺垫）
- 用一个“评论家”（Critic）学习 $V^{\pi_w}$ 或 $Q^{\pi_w}$（如 TD/TD(λ)/GAE），以较低方差估计优势：
  $$
  \widehat{A}_t \approx \text{GAE}_\lambda,
  \quad
  \widehat{\nabla_w J}=\frac{1}{N}\sum_{i,t}\nabla_w \log \pi_w(a_t^{(i)}|s_t^{(i)})\,\widehat{A}_t^{(i)}.
  $$
- 好处：样本效率更高，可与近端策略优化（PPO）等稳定化技术结合。

1. 实践要点
- 奖励/优势标准化：对每批次的 $\widehat{A}_t$ 做零均值、单位方差，有助于稳定训练。
- 学习率与批量：MC 方差高，通常需要较大的 batch 或小学习率；用基线/GAE 后可适当增大学习率。
- 熵系数调节：过大导致目标过于随机、学习慢；过小则易陷入确定性和早停探索。
- 不要对 $\rho^\pi$ 求梯度：实现中直接用采样状态的经验平均即可，策略梯度定理保证无须显式求 $\nabla \rho^\pi$。

总结
- 本节给出随机策略梯度的核心形式：通过对数导数技巧，把对性能目标的梯度转化为
  $$
  \nabla_w J = \mathbb{E}\big[\nabla_w \log \pi_w(a|s)\,Q^{\pi^w}(s,a)\big],
  $$
  并在实践中常用优势函数与熵正则改进稳定性与效率。
- 估计 $Q$ 的两条路径：蒙特卡洛（无偏但高方差、需 on-policy）与基于价值的评论家（Actor-Critic，更高效）。
- 基线/优势作为控制变元可显著降方差而不引入偏置；多数实现也使用未折扣的状态分布而不损失性能。
 -->

## 5.2 Deterministic Policy Gradient

$$
\pi_{k+1}(s)=\operatorname*{\arg\max}_{a\in\mathcal A} Q^{\pi_k}(s,a), \tag{5.5}
$$

但是在连续动作空间内，贪心的策略改进就会出现问题，因为其要求每一步都做全局最大化，但是这显然难以进行，因此我们把策略记为可微的确定性策略 $\pi_w(s)$，而此时，一个直接的想法就是做梯度上升，也就是沿着 $Q$ 的梯度方向移动策略，这就得到 [DDPG 算法](https://arxiv.org/abs/1509.02971)。

$$
\nabla_w V^{\pi_w}(s_0) = \mathbb{E}_{s\sim \rho^{\pi_w}} \! \left[\nabla_w \pi_w(s) \nabla_a Q^{\pi_w}(s,a)\big|_{a=\pi_w(s)}\right]. \tag{5.6}
$$

这实际上是一个链式法则，我们要求 $Q$ 关于 $w$ 的导数，因此先求 $Q$ 关于 $a$ 的导数，这时候注意到 $a = \pi_w(s)$，然后再求 $\pi_w$ 关于 $w$ 的导数就可以。

式子 (5.6) 意味着除了 $\nabla_w \pi_w$ 之外，我们还需要求出 $\nabla_a Q^{\pi_w}(s,a)$，这在实践中一般借助 Actor-Critic 方法来实现。

## 5.3 Actor-Critic Methods

使用神经网络的策略，无论是确定性的还是随机的，都可以通过梯度上升来更新策略。而无论如何，我们都需要当前策略的价值函数估计，一种常见的做法就是使用 Actor-Critic 架构，Actor 代表策略，Critic 代表价值函数（例如 Q Value）。在 Deep RL 中，Actor 和 Critic 都可以由非线性的神经网络表示。Actor 使用由策略梯度定理给出的梯度来调整策略参数 $w$，Critic 用参数 $\theta$ 来估计当前策略 $\pi$ 的近似价值函数 $Q(s,a;\theta) \approx Q^{\pi}(s,a)$。

### The Critic

从一组元组 $\langle s,a,r,s^{\prime} \rangle$ 出发，这组元组可能来自于经验回放池，Critic 不断将当前值函数 $Q(s,a;\theta)$ 向目标值更新。最简单的方法是使用纯自举的 $TD(0)$，即每次迭代把当前的 $Q(s,a;\theta)$ 向目标值

$$
Y^{Q}_{k}= r + \gamma Q \left(s^{\prime}, a=\pi(s^{\prime});\theta\right) \tag{5.7}
$$

更新。这样的方法简单，但是效率不高，因为其使用了纯自举技术，容易不稳定，并且回报沿时间反向传播很慢，类似可以使用更加复杂的多步自举技术。理想的架构应该满足下面条件：

- **样本高效/Sample Efficiency**：可以使用 off-policy 和 on-policy 的轨迹，比如可以使用经验回放池；
- **计算高效/Computational Efficiency**：可以从 on-policy 方法的稳定性和回报的快速反向传播中受益，同时也可以使用从近似 on-policy 行为策略收集到的样本。

有些架构可以将 off-policy 和 on-policy 的数据结合起来，比如 $\text{Retrace}(\lambda)$，其可以在不引入偏差/Bias 的情况下使用任何行为策略收集的样本，也可以高效利用近似于 on-policy 行为策略收集的样本。

一般来讲，使用经验回放池的算法样本效率高，而使用多步回报的算法计算效率高，多步回报也提升了学习稳定性，也加速了回报在时间上的反向传播。

### The Actor

从式 (5.4) 可以知道，随机策略在策略改进阶段的 off-policy 梯度可以写为

$$
\nabla_w V^{\pi^{w}}(s_0) = \mathbb{E}_{s\sim \rho^{\pi_\beta}, a\sim \pi_\beta} \left[\nabla_{w} (\log \pi_w (s, a)) \cdot Q^{\pi^{w}}(s,a)\right]. \tag{5.8}
$$

其中 $\pi_\beta$ 是行为策略，通常与 $\pi$ 不同，因此该梯度一般是**有偏**的。这种方法在时间之中表现良好，但是由于策略梯度估计/Policy Gradient Estimator 带偏，对收敛性的分析在没有 GLIE 假设的情况下是困难的。这里 GLIE 假设一般指的是 Greedy in the Limit with Infinite Exploration，也就是在在线学习的设定下，当 Agent 已经学到无限多的经验的时候，其行为策略应该变得贪心（也就是没有 Exploration）。

在 Actor-Critic 框架内，一种不使用经验回放而在 on-policy 上进行策略梯度的方法是使用异步方法，也就是熟悉的 A3C/Asynchronous Advantage Actor-Critic，其使用多个 Agent 并行训练，并行的 Agent 使得每一个 Agent 在同一时间步看到环境的不同部分，这样就可以使用 n 步回报而不引入偏差。这个简单的想法可以用于任何需要 on-policy 数据而又不需要维持回放池的算法。然而其并不是样本高效的。

另一个将 off-policy 的样本高效和 on-policy 的梯度估计稳定性结合起来的方法是 Q-Prop，其将 on-policy 和 off-policy 的样本结合起来，使用一个蒙特卡洛的策略梯度估计器，同时使用一个 off-policy 的 Critic 作为控制变量来降低方差。其一个局限是，为了估计策略梯度，它仍然需要 on-policy 的样本。

## 5.4 Natural Policy Gradients

自然策略梯度来自于自然梯度这一思想与方法，用于对策略进行更新。其使用 Fisher Information Metric 给出的最陡方向进行更新。这个度量利用了目标函数的流形。对于目标函数 $J(w)$，最简单的最陡上升形式是 $\Delta w \propto \nabla_w J(w)$。换言之，在对 $\lVert \Delta w\rVert_2$ 加约束的条件下，更新会沿着使 $J(w+\Delta w)-J(w)$ 最大的方向前进。若假设对 $\Delta w$ 的约束并非由 $L_2$ 度量给出，而是由另一种度量给出，则该带约束优化问题

$$
\max_{\Delta w}\; J(w+\Delta w) - J(w) \quad \text{s.t.}\quad \lVert \Delta w\rVert \le \delta
$$

的一阶解通常形如 $\Delta w \propto B^{-1}\nabla_w J(w)$，其中 $B$ 是 $n_w\times n_w$ 的矩阵。

在自然梯度中，范数使用 Fisher Information Metric 给出，其可以由 KL 散度 $D_{\mathrm{KL}} (\pi_{w} \| \pi_{w+\Delta w})$ 的局部二次近似得到，其中 KL 散度定义为 $D_{\mathrm{KL}} (p \| q) = {\displaystyle\int} p(x) \log \frac{p(x)}{q(x)} \, \mathrm{d} x$。改进策略 $\pi_w$ 的自然梯度上升为

$$
\Delta w \propto F_w^{-1} \, \nabla_w V^{\pi_w}(\cdot), \tag{5.9}
$$

其中 $F_w$ 为 Fisher 信息矩阵：

$$
F_w = \mathbb{E}_{\pi_w} \left[\nabla_w \log \pi_w(s,\cdot) \; \big(\nabla_w \log \pi_w(s,\cdot)\big)^{\top}\right]. \tag{5.10}
$$

使用正常梯度 $\nabla_w V^{\pi_w}(\cdot)$ 做策略梯度上升往往较慢，因为容易停在局部平台/Plateau 上。但是自然梯度并不沿参数空间的通常意义的欧式最陡方向，而是沿着 Fisher 度量意义下的最陡方向。另外，需要注意的是，自然梯度与普通梯度之间的夹角不超过 $90^\circ$，因此使用自然梯度时也能保证收敛。

但是，当使用大参数量的神经网络的时候，计算、存储和求逆 Fisher 信息矩阵往往是不切实际的，因此自然梯度在深度 RL 中很少直接使用。但是现代提出了很多解决方案，比如 TRPO 和 PPO，这些方法都受自然梯度的启发。

## 5.5 Trust Region Optimization

<!-- 下面先给出**逐段精确翻译**（含公式），随后是**细致讲解与补充**与**实用要点**。

---

# 5.5 信赖域优化（Trust Region Optimization）

## 原文精确翻译

**信赖域思路。**
作为对自然梯度方法的改造，基于**信赖域**的策略优化方法旨在在**可控**的方式下改进策略。这类带约束的策略优化方法专注于用**动作分布之间的 KL 散度**来限制策略的变化。通过给策略更新的幅度设定上界，信赖域方法也就对**状态分布的变化**给出了约束，从而保证策略性能的改进。

**TRPO。**
TRPO（Schulman *et al*., 2015）用带约束的更新与优势函数估计来执行更新，其得到如下等价的优化问题：

$$
\max_{\Delta w}\;
\mathbb{E}_{s\sim\rho^{\pi_w},\,a\sim\pi_w}\!
\left[\frac{\pi_{w+\Delta w}(s,a)}{\pi_w(s,a)}\;A^{\pi_w}(s,a)\right]
\tag{5.11}
$$

满足约束

$$
\mathbb{E}\, D_{\mathrm{KL}}\!\big(\pi_w(s,\cdot)\;\big\|\;\pi_{w+\Delta w}(s,\cdot)\big)\ \le\ \delta,
$$

其中 $\delta\in\mathbb{R}$ 是一个超参数。基于经验数据，TRPO 使用**共轭梯度**方法在 KL 约束下优化该目标。

**PPO。**
PPO（Schulman *et al*., 2017b）是 TRPO 的近似变体，它把约束改写为**惩罚项**或**截断形式的目标**，而不使用显式 KL 约束。不像 TRPO，PPO 通过修改目标函数来惩罚令

$$
r_t=\frac{\pi_{w+\Delta w}(s_t,a_t)}{\pi_w(s_t,a_t)}
$$

远离 1 的策略变化。PPO 最大化的截断目标为

$$
\mathbb{E}_{s\sim\rho^{\pi_w},\,a\sim\pi_w}\!
\Big[\,\min\big(r_t\,A^{\pi_w}(s,a),\ \mathrm{clip}(r_t,\,1-\epsilon,\,1+\epsilon)\,A^{\pi_w}(s,a)\big)\Big],
\tag{5.12}
$$

其中 $\epsilon\in\mathbb{R}$ 是超参数。该目标把概率比 $r_t$ **截断**在区间 $[\,1-\epsilon,\ 1+\epsilon\,]$ 内，以约束其变化幅度。

---

## 细致讲解与补充

### 1) 为何 (5.11) 是合理的“代理目标”（surrogate objective）

* 由**性能差分引理**与重要性采样可得：若只看一阶项，$J(\pi_{\text{new}})-J(\pi_{\text{old}})$ 可以被

  $$
  L_{\pi_{\text{old}}}(\pi_{\text{new}})=
  \mathbb{E}_{s\sim\rho^{\pi_{\text{old}}},\,a\sim\pi_{\text{old}}}\!
  \Big[\tfrac{\pi_{\text{new}}(a\mid s)}{\pi_{\text{old}}(a\mid s)}\,A^{\pi_{\text{old}}}(s,a)\Big]
  $$

  近似下界。于是最大化 $L$ 且**约束平均 KL** 足够小（$\le\delta$），就能保证**单调改进**。
* **信赖域**即“只在 KL 半径 $\delta$ 的球内信任线性近似”。

### 2) TRPO 的数值做法（骨架）

* 化为等价的二次规划：用 Fisher–向量积近似 $F_w$，解

  $$
  \max_{\Delta w}\ g^\top\Delta w\quad
  \text{s.t.}\ \tfrac12\,\Delta w^\top F_w\,\Delta w\le\delta,
  $$

  其解方向为自然梯度 $F_w^{-1}g$（与 §5.4 呼应），再配合**线搜索**确保实际 KL $\le\delta$。

### 3) PPO 的截断机制直觉（为什么用 $\min$）

* 令 $A_t>0$：希望**增大** $r_t$（抬高好动作的概率），但一旦 $r_t>1+\epsilon$ 就**不再奖励**（被 clip 项“截平”）⇒ 防止过冲。
* 令 $A_t<0$：希望**减小** $r_t$，但当 $r_t<1-\epsilon$ 时**不再进一步惩罚** ⇒ 防止过度下降。
* $\min(\cdot,\cdot)$ 选择对学习**更保守**的一边，从而近似了“KL 不要太大”的约束。
* 另一种 PPO 变体是**KL 惩罚版**：最大化 $L_{\text{PG}}-\beta\,\mathrm{KL}$ 并自适应调整 $\beta$ 以把 KL 调到目标值。

### 4) 实际 PPO 损失（常用完整式）

$$
\mathcal L_{\text{PPO}}
= \mathbb{E}\Big[
L_{\text{clip}}(\theta)
- c_v\,\big(V_\theta(s)-\hat V\big)^2
+ c_H\,\mathcal H\big(\pi_\theta(\cdot\mid s)\big)
\Big],
$$

其中 $L_{\text{clip}}$ 为 (5.12) 的截断项，$\hat V$ 是回报或 GAE 目标；$c_v,c_H$ 为系数。**GAE($\lambda$)** 常与 PPO 搭配，显著降方差并加快奖励传播。

### 5) “约束动作分布 ⇒ 约束状态分布”的含义

* 在马尔可夫链中，若每步的策略分布变化小（平均 KL 有界），可用耦合/扰动界证明**占用测度** $d^{\pi}$ 的变化也被控制，从而使性能的线性近似保持有效 → 单调改进保证成立。

---

## 实用要点（工程角度）

* **默认超参数**：$\epsilon\in[0.1,0.3]$，目标 KL $\approx 0.01\text{–}0.02$，每批次更新 $3\text{–}10$ 个 epoch；优势**标准化**有助稳定。
* **早停**：监控平均 KL，若超阈值则提前停止该轮更新。
* **值函数与熵**：值函数回归可加入**clip** 版本以防与策略步子不同步；熵奖励维持探索。
* **连续动作**：若用 $\tanh$ 高斯，计算 $\log\pi$ 要做**变量换元**（包含 $\tanh$ 的雅可比项），否则 $r_t$ 会错。
* **优势估计**：$\hat A_t=\mathrm{GAE}(\gamma,\lambda)$（典型 $\gamma=0.99,\lambda=0.95$）。

---

## 小练习

1. 从重要性采样恒等式 $\mathbb{E}_{a\sim\pi_{\text{new}}}[f]=\mathbb{E}_{a\sim\pi_{\text{old}}}[r_t f]$ 出发，推到式 (5.11)。
2. 画出 $A_t>0$ 与 $A_t<0$ 时 PPO 的分段目标关于 $r_t$ 的曲线，并解释为什么它是“保守”的。
3. 说明当 $\epsilon$ 太大或 epoch 太多时，为什么会破坏“近似信赖域”的假设，导致不稳定。
 -->

## 5.6 Combining Policy Gradient with Q-Learning

<!-- 下面是 **5.6 Combining policy gradient and Q-learning** 的**逐段精确翻译**，然后给出**推导与补充说明**（含式 (5.13) 来源与“用策略反推优势”的证明）。

---

# 5.6 结合策略梯度与 Q-learning

## 原文精确翻译

策略梯度是在强化学习中改进策略的高效技术。正如我们所见，它通常需要当前策略的一个价值函数估计；而一种样本高效的做法是使用能够处理 **off-policy** 数据的 **actor–critic** 架构。

与第 4 章基于 DQN 的方法不同，这些算法具有以下性质：

* **可处理连续动作空间。** 这在机器人等应用中尤为重要，因为力与力矩可以取连续值。
* **可表示随机策略。** 这便于构建能够显式探索的策略；在最优策略本身是随机的情形也很有用（例如多智能体中纳什均衡是随机策略的场景）。

然而，另一种方法是**直接把策略梯度与 off-policy Q-learning 结合**（O’Donoghue *et al*., 2016）。在某些具体设定下——取决于损失函数以及使用的熵正则——**基于价值的方法与基于策略的方法是等价的**（Fox *et al*., 2015；O’Donoghue *et al*., 2016；Haarnoja *et al*., 2017；Schulman *et al*., 2017a）。例如，当加入**熵正则**时，式 (5.4) 可以写成

$$
\nabla_w V^{\pi^w}(s_0)
=\mathbb{E}_{s,a}\!\big[\nabla_w \log \pi_w(s,a)\,Q^{\pi^w}(s,a)\big]
\;+\;\alpha\,\mathbb{E}_s\!\big[\nabla_w H^{\pi^w}(s)\big], \tag{5.13}
$$

其中 $H^{\pi^w}(s)=-\sum_{a}\pi_w(s,a)\log\pi_w(s,a)$。
由此可注意到，下式给出的策略满足最优性条件：

$$
\pi_w(s,a)=\exp\!\Big(\tfrac{1}{\alpha}A^{\pi^w}(s,a)\;-\;H^{\pi^w}(s)\Big).
$$

因此，我们可以用策略本身来构造一个**优势函数估计**：

$$
\hat A^{\pi^w}(s,a)=\alpha\big(\log \pi_w(s,a)+H^{\pi^w}(s)\big).
$$

由此，我们可以把所有**无模型（model-free）**方法视为**同一思想的不同侧面**。

仍存的一点限制是：无论基于价值还是基于策略的方法，都是**无模型**的，它们并未利用环境的任何模型。下一章将讨论基于模型的方法。

---

## 推导与补充

### A. 式 (5.13) 从何而来（把熵正则并入 PG）

在随机策略梯度目标中加入熵奖励：

$$
J_{\text{ent}}(w)\;=\;
\underbrace{\mathbb{E}_{s,a}[\log\pi_w(a\mid s)\,Q^{\pi^w}(s,a)]}_{\text{策略梯度 surrogate}}
\;+\;\alpha\,\underbrace{\mathbb{E}_{s}[H^{\pi^w}(s)]}_{\text{熵正则}}.
$$

对 $w$ 求梯度即可得到 (5.13)。第一项就是式 (5.4) 的期望形式；第二项是对熵的参数梯度 $\nabla_w H^{\pi^w}(s)$（通过 $\pi_w$ 反传）。

> 直觉：$\alpha>0$ 鼓励**高熵**，防止过早确定化；$\alpha\to 0$ 时退化回标准 PG。

### B. 用熵正则的极值条件推得 “Boltzmann/softmax” 策略

固定状态 $s$，考虑最大化

$$
\max_{\pi(\cdot\mid s)}\;
\sum_a \pi(a\mid s)\,Q(s,a)
\;+\;\alpha\,H(\pi(\cdot\mid s))
\quad
\text{s.t.}\ \sum_a \pi(a\mid s)=1. \tag{★}
$$

拉格朗日函数

$$
\mathcal L=\sum_a \pi(a)Q(s,a)-\alpha\sum_a \pi(a)\log\pi(a)+\lambda\!\left(\sum_a \pi(a)-1\right).
$$

对 $\pi(a)$ 的一阶条件：

$$
0=\partial_{\pi(a)}\mathcal L
=Q(s,a)-\alpha(1+\log\pi(a))+\lambda
\quad\Rightarrow\quad
\pi^\*(a\mid s)\ \propto\ \exp\!\Big(\tfrac{1}{\alpha}Q(s,a)\Big).
$$

若再用优势 $A(s,a)=Q(s,a)-V(s)$（其中 $V(s)=\sum_a \pi^\*(a)Q(s,a)$），则

$$
\pi^\*(a\mid s)\ \propto\ \exp\!\Big(\tfrac{1}{\alpha}A(s,a)\Big).
$$

把归一化常数写成 $e^{H(s)}$ 的形式，就得到书中表达：

$$
\boxed{\;\pi^\*(s,a)=\exp\!\Big(\tfrac{1}{\alpha}A(s,a)-H(s)\Big)\;}
$$

（因为 $\sum_a e^{A/\alpha - H}=1\Rightarrow H(s)=\log\!\sum_a e^{A/\alpha}$）。

### C. 由策略反推优势：$\hat A(s,a)=\alpha(\log\pi+H)$

在最优策略上，上一式两边取对数得

$$
\log \pi^\*(s,a)=\tfrac{1}{\alpha}A(s,a)-H(s)
\quad\Rightarrow\quad
A(s,a)=\alpha\big(\log\pi^\*(s,a)+H(s)\big).
$$

因此**若当前策略接近最优的熵正则形式**，就可用

$$
\boxed{\;\hat A^{\pi}(s,a)\;=\;\alpha\big(\log \pi(a\mid s)+H^{\pi}(s)\big)\;}
$$

当作优势的**无模型估计器**（其期望为 0，因为 $\mathbb{E}_a[\log\pi]=-H$）。

> 在最大熵 RL（如 **Soft Q-Learning / SAC**）中，这一思想更系统：
> $V_{\text{soft}}(s)=\alpha\log\sum_a \exp(Q(s,a)/\alpha)$，
> $\pi(a\mid s)\propto \exp(Q(s,a)/\alpha)$，
> $A_{\text{soft}}(s,a)=Q(s,a)-V_{\text{soft}}(s)=\alpha\log\pi(a\mid s)$（连续动作需加雅可比项）。

### D. “策略法 ≈ 价值法”的若干等价情形

* 以 **熵正则** 的目标 (★) 为中心：

  * **策略法**：最大化 $J_{\text{ent}}(w)$，直接优化 $\pi_w$。
  * **价值法**：学习满足软 Bellman 方程的 $Q$，再设 $\pi \propto \exp(Q/\alpha)$。
* 在兼容近似与合适的损失下，两者得到相同的固定点（文献中的“等价”即指此）。

---

## 实用提示

* 选 $\alpha$：越大探索越强、策略越“平滑”；越小越接近常规 RL。SAC 常把 $\alpha$ 自适应调到目标熵。
* 估计 $H(s)$：离散动作用显式和；连续动作用分布的解析熵（如高斯）或 Monte Carlo 估计。
* 用 $\hat A(s,a)=\alpha(\log\pi+H)$ 时，仍建议与 **GAE/TD** 等优势估计**混合或对比**，以免偏差过大。

---

## 小练习

1. 从 (★) 出发，用拉格朗日法严格推导 $\pi^\*(a\mid s)\propto\exp(Q/\alpha)$，再换成优势形式。
2. 证明 $\mathbb{E}_{a\sim\pi}[\log\pi(a\mid s)+H(s)]=0$，并解释为什么这使得 $\hat A$ 作为基线-中心化的优势是合理的。
3. 说明在连续动作、$\tanh$ 高斯策略下，$\log\pi$ 中必须包含**变量换元雅可比**，否则 $\hat A$ 会系统性偏差。
 -->

