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

<!--
**自然策略梯度的动机。**
自然策略梯度源自“自然梯度”（natural gradient）这一思想，用于对策略进行更新。自然梯度可追溯至 Amari（1998）的工作，并被 Kakade（2001）引入到强化学习中。

**用 Fisher 信息度量定义最陡上升方向。**
自然策略梯度方法使用由 **Fisher 信息度量** 给出的最陡方向（steepest direction），该度量利用了目标函数所在的流形。对于目标函数 $J(w)$，最简单的最陡上升形式是

$$
\Delta w \propto \nabla_w J(w).
$$

换言之，在对 $\lVert \Delta w\rVert_2$ 加约束的条件下，更新会沿着使

$$
J(w+\Delta w)-J(w)
$$

最大的方向前进（原文处写作 $J(w)-J(w+\Delta w)$，应为笔误）。若假设对 $\Delta w$ 的约束并非由 $L_2$ 度量给出，而是由**另一种度量**给出，则该**带约束优化问题**的一阶解通常形如

$$
\Delta w \propto B^{-1}\nabla_w J(w),
$$

其中 $B$ 是 $n_w\times n_w$ 的矩阵。

---

## 要点补充（推导与实践）

1. **从带 KL 约束的最优步长得到自然梯度方向**
   令 $g=\nabla_w J(w)$，近似 $\mathrm{KL}(\pi^w\|\pi^{w+\Delta w})\approx \tfrac12 \Delta w^\top F_w \Delta w$。
   约束问题

   $$
   \max_{\Delta w}\; g^\top \Delta w \quad
   \text{s.t.}\quad \tfrac12 \Delta w^\top F_w \Delta w \le \delta
   $$

   的一阶解为

   $$
   \Delta w^\*=\alpha\,F_w^{-1}g,\quad
   \alpha=\sqrt{\tfrac{2\delta}{g^\top F_w^{-1}g}},
   $$

   即**方向**就是 $F_w^{-1}g$ —— 自然梯度。
 -->

## 5.5 Trust Region Optimization



## 5.6 Combining Policy Gradient with Q-Learning

