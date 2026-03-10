# Topic 2: Multi-Armed Bandits

## 1 对抗多臂赌博机

到目前为止，我们讨论的所有主题都考虑了具有完整信息反馈的问题。从本讲开始，我们将转向更具挑战性的部分信息反馈设置。这类问题的经典例子是多臂赌博机问题，这里我们讨论对抗性版本。

该问题模拟了一个赌徒在赌场中连续拉动一台老虎机/Slot Machine 的手柄，希望最大化奖励的情况。一台老虎机有时被称为"单臂赌博机"，因此这个问题被称为多臂赌博机。形式上，学习者有 $K$ 个可用的臂/动作，在每个时间点 $t = 1, \ldots, T$，

1. 学习者选择一个动作 $a_t \in [K]$，同时环境决定损失向量 $\ell_t \in [0, 1]^K$，
2. 学习者随后遭受并观察损失 $\ell_t(a_t)$。

显然，这只是专家问题的部分信息版本，区别在于学习者必须在每轮实际选择一个动作，然后只观察该动作的损失，而不是整个损失向量 $\ell_t$。按照惯例，我们从记号 $i$ 和 $N$ 转换为 $a$ 和 $K$，分别表示特定动作和动作总数。

为简单起见，我们只考虑遗忘环境/Oblivious Environment，因此可以等价地认为损失向量是在游戏开始前生成的（尽管可能是随机生成的）。我们通过期望遗憾来衡量算法的性能

$$\mathbb{E}[\mathcal{R}_T] = \mathbb{E}\left[\sum_{t=1}^T \ell_t(a_t)\right] - \min_{a\in[K]} \sum_{t=1}^T \ell_t(a),$$

其中期望是相对于算法的随机性。

这个问题（或一般的部分信息问题）的挑战在于众所周知的**探索-利用权衡/Exploration-Exploitation Tradeoff**。一方面，选择之前遭受小损失的动作很诱人（利用），但另一方面，也有动机选择其他动作，看看它们是否能有更小的损失（探索）。

但由于这个问题与专家问题如此接近，让我们首先看看是否可以用专家算法来解决它。明显的障碍是我们没有完整的损失向量来输入专家算法。然而，假设我们根据分布 $p_t$ 选择 $a_t$，那么我们可以按以下方式构造损失向量的估计器

$$\hat{\ell}_t(a) = \frac{\ell_t(a)}{p_t(a)}\mathbf{1}\{a = a_t\} = \begin{cases}
\frac{\ell_t(a_t)}{p_t(a_t)} & \text{如果 } a = a_t, \\
0 & \text{否则}.
\end{cases}$$

这个简单技巧被称为**逆倾向得分加权/Inverse Propensity Score Weighting** 或简称为**重要性加权/Importance Weighting**。显然，这个估计器可以使用可用信息计算，更重要的是，它是无偏的：对于任何 $a \in [K]$，

$$\mathbb{E}_t[\hat{\ell}(a)] = (1 - p_t(a)) \times 0 + p_t(a)\frac{\ell_t(a)}{p_t(a)} = \ell_t(a)$$

其中 $\mathbb{E}_t[\cdot]$ 是给定过去的 $a_t$ 随机抽取的条件期望。因此，由于我们（至少现在）只关心期望遗憾，似乎我们可以简单地使用任意专家算法的预测 $p_t$ 来抽取 $a_t$，然后将 $\hat{\ell}_t$ 输入该算法。确实，对于任何 $a \in [K]$，我们有

$$\mathbb{E}\left[\sum_{t=1}^T \ell_t(a_t)\right] - \sum_{t=1}^T \ell_t(a) = \mathbb{E}\left[\sum_{t=1}^T \langle p_t, \hat{\ell}_t \rangle - \sum_{t=1}^T \hat{\ell}_t(a)\right]$$

其中最后一项正是专家算法的（期望）遗憾。我们已经证明专家问题的最优遗憾是 $\mathcal{O}(\sqrt{T \ln K})$。这是否意味着我们已经为多臂赌博机问题找到了一个具有 $\mathcal{O}(\sqrt{T \ln K})$ 遗憾的简单算法？

答案是否定的 —— 我们在上述论证中忽略的是，专家算法接收的损失范围不再是 $[0, 1]$！实际上，由于重要性加权，损失可能非常大，因此遗憾不再仅仅是 $\mathcal{O}(\sqrt{T \ln K})$。作为一个简单的修复，我们可以通过进行少量均匀探索来强制对重要性权重设置下界

$$p_t = (1 - \alpha)\hat{p}_t + \frac{\alpha}{K}\mathbf{1} \tag{1}$$

其中 $\hat{p}_t$ 现在是专家算法的预测，$\mathbf{1}$ 是全 1 向量，$\alpha$ 是稍后要指定的参数。那么显然我们有 $\hat{\ell}(a) \leq K/\alpha$，因此如果我们将 $\frac{\alpha}{K}\hat{\ell}_t \in [0, 1]^K$ 输入专家算法，我们有

$$\begin{aligned}
\mathbb{E}\left[\sum_{t=1}^T \langle p_t, \hat{\ell}_t \rangle - \sum_{t=1}^T \hat{\ell}_t(a)\right] &\leq \frac{\alpha}{K}\mathbb{E}\left[\sum_{t=1}^T \hat{\ell}_t(a_t)\right] + \mathbb{E}\left[\sum_{t=1}^T \langle \hat{p}_t, \hat{\ell}_t \rangle - \sum_{t=1}^T \hat{\ell}_t(a)\right] \\
&\leq \alpha T + \frac{K}{\alpha}\mathbb{E}\left[\sum_{t=1}^T \left\langle \hat{p}_t, \frac{\alpha}{K}\hat{\ell}_t \right\rangle - \sum_{t=1}^T \frac{\alpha}{K}\hat{\ell}_t(a)\right] \\
&= \mathcal{O}\left(\alpha T + \frac{K}{\alpha}\sqrt{T \ln K}\right)
\end{aligned}$$

其中第二步是由 $\mathbb{E}_t[\hat{\ell}_t(a_t)] = \sum_{a=1}^K p_t(a)\frac{\ell_t(a)}{p_t(a)} = \sum_{a=1}^K \ell_t(a) \leq K$，最后一步是通过应用专家算法的遗憾界。最后，通过选择最优的 $\alpha$，我们得到阶为 $\mathcal{O}(T^{\frac{2}{3}}K^{\frac{1}{3}}(\ln K)^{\frac{1}{3}})$ 的遗憾界，这比完整信息设置的最优界要大得多。因此，尽管重要性加权估计器是无偏的，而且我们只关心期望中的遗憾，但估计器的范围或实际上是方差仍然很重要。

### 1.1 Exp3 算法

### 1.2 FTPL & OMD

### 1.3 FTPL 的高概率上界

## 2 随机多臂赌博机

我们在前面讨论了 **对抗性多臂赌博机/Adversarial Multi-Armed Bandit** 问题的算法，这些赌博机对损失向量的生成方式没有任何假设。我们下面介绍 **随机多臂赌博机/Stochastic Multi-Armed Bandit** 问题，其中每个臂代表一个未知分布，每次拉动臂都会从相应的分布中生成一个独立样本。

虽然问题设定显然只是其对抗性版本的一个特例，但随机赌博机的目标通常是推导出依赖于分布的遗憾界，在某些情况下这些界比最坏情况的 $\mathcal{O}(\sqrt{TK})$ 界更强。此外，尽管在完整信息设置中，随机假设使问题变得更容易（实际上，FTL 已经可以解决问题），但在赌博机设置中，由于缺乏反馈，即使有随机假设，问题仍然相当具有挑战性。

形式上，我们假设对于每个动作 $a$，存在一个未知分布 $\mathcal{D}_a$，其均值为 $\mu(a)$，使得 $\ell_1(a), \ldots, \ell_T(a)$ 是 $\mathcal{D}_a$ 的独立样本。令 $a^* = \arg\min_a\mu(a)$ 为期望损失最小的最优动作。对于这个问题，我们通常关心一个稍微不同版本的遗憾，称为 **伪遗憾/Pseudo-regret**：

$$\overline{\mathcal{R}}_T = \mathbb{E}\left[\sum_{t=1}^T (\ell_t(a_t) - \ell_t(a^*))\right]$$

这是相对于固定动作 $a^*$ 的期望遗憾（而不是经验最佳动作 $\arg\min_a \sum_t \ell_t(a)$），其中期望是相对于环境和算法的随机性。显然，伪遗憾也可以简化为

$$\overline{\mathcal{R}}_T = \mathbb{E}\left[\sum_{t=1}^T (\mu(a_t) - \mu(a^*))\right] = \mathbb{E}\left[\sum_{t=1}^T \sum_{a=1}^K \Delta_a \mathbf{1}\{a_t = a\}\right] = \sum_{a:\Delta_a>0} \Delta_a \mathbb{E}[n_T(a)]$$

其中 $\Delta_a = \mu(a) - \mu(a^*)$ 被称为动作 $a$ 的 **次优性差距**，$n_t(a) = \sum_{\tau=1}^t \mathbf{1}\{a_\tau = a\}$ 是动作 $a$ 在第 $t$ 轮之前被拉动的次数。因此，要分析这种设置下的算法，归根结底就是要界定 $\mathbb{E}[n_T(a)]$ 这一项。

在随机设置中，探索与利用之间的权衡可能更加直观。令 $\hat{\mu}_t(a) = \frac{1}{n_t(a)}\sum_{\tau=1}^t \mathbf{1}\{a_\tau = a\}\ell_\tau(a)$ 为动作 $a$ 在第 $t$ 轮之前的经验均值。由于环境是随机的，如果 $n_t(a)$ 足够大，$\hat{\mu}_t(a)$ 可能是 $\mu(a)$ 的良好近似。因此，一方面我们想通过选择经验最佳动作 $\arg\min_a \hat{\mu}_t(a)$ 来进行利用，但另一方面我们也需要进行探索，以便所有动作都被足够频繁地选择，使 $\hat{\mu}_t(a)$ 真正成为 $\mu(a)$ 的良好近似。

### 2.1 Explore-then-Exploit 算法

平衡这种权衡的最简单策略是先进行一段时间的纯探索，然后进行纯利用并在剩余时间内一直坚持同一个动作。形式上，令 $T_0$ 为稍后要指定的探索轮数。先探索后利用策略如下：

1. 在前 $T_0$ 轮中，每个动作选择 $T_0/K$ 次（按任意顺序）；
2. 在剩余的 $T-T_0$ 轮中，始终选择 $\hat{a} = \arg\min_a \hat{\mu}_{T_0}(a)$。

然后可以证明以下遗憾界。

**定理 1**：先探索后利用策略的伪遗憾被界定为

$$\overline{\mathcal{R}}_T \leq \sum_{a:\Delta_a>0} \left(\frac{T_0}{K} + 2T\exp\left(-\frac{T_0\Delta_a^2}{8K}\right)\right) \Delta_a.$$

???- Info "Proof"

<!-- 对于所有 $\Delta_a > 0$ 的 $a$，只需证明 $\mathbb{E}[n_T(a)] \leq \frac{T_0}{K} + 2T\exp\left(-\frac{T_0\Delta_a^2}{8K}\right)$ 即可。根据算法，显然有

    $$\mathbb{E}[n_T(a)] = \frac{T_0}{K} + (T-T_0)\mathbb{E}[\mathbf{1}\{\hat{a} = a\}] = \frac{T_0}{K} + (T-T_0)\text{Pr}(\hat{a} = a),$$

    且 $\text{Pr}(\hat{a} = a) \leq \text{Pr}(\hat{\mu}_{T_0}(a) \leq \hat{\mu}_{T_0}(a^*))$。接下来注意，如果发生 $\hat{\mu}_{T_0}(a) \leq \hat{\mu}_{T_0}(a^*)$，那么以下两个罕见事件之一必须发生：

    $$\hat{\mu}_{T_0}(a) \leq \mu(a) - \Delta_a/2$$
    $$\hat{\mu}_{T_0}(a^*) \geq \mu(a^*) + \Delta_a/2$$

    因为否则 $\hat{\mu}_{T_0}(a) > \mu(a) - \Delta_a/2 = \mu(a^*) + \Delta_a/2 > \hat{\mu}_{T_0}(a^*)$。现在回想一下，$\hat{\mu}_{T_0}(a)$（$\hat{\mu}_{T_0}(a^*)$）是具有均值 $\mu(a)$（$\mu(a^*)$）的分布的 $T_0/K$ 个独立同分布样本的平均值，因此根据 Hoeffding 不等式（包含在本节末尾），我们知道上述两个事件中的每一个的概率都被 $\exp\left(-\frac{T_0\Delta_a^2}{8K}\right)$ 所界定。通过并集界，我们得到

    $$\text{Pr}(\hat{a} = a) \leq 2\exp\left(-\frac{T_0\Delta_a^2}{8K}\right),$$

    完成证明。□ -->

### 2.2 UCB 算法

随机多臂赌博机的经典算法是 **UCB/Upper Confidence Bound 算法**，尽管由于我们使用损失而不是奖励，我们在这里讨论的实际上是 **LCB/Lower Confidence Bound 算法**。为了方便起见，我们仍将其称为 UCB 算法。

UCB 应用了一个非常重要的原则，称为 **面对不确定性的乐观/Optimism in the Face of Uncertainty**，这在许多具有赌博机反馈的随机问题中都很有用。该原则的主要思想如下：**在所有与观察到的数据一致的合理环境中，假设最有利的环境是真实环境，并据此行动**。

让我们将这一原则应用于随机多臂赌博机。在时间 $t$，我们已经收集了每个动作 $a$ 的经验平均值 $\hat{\mu}_{t-1}(a)$。给定这些信息，根据 Hoeffding 不等式，均值 $\mu(a)$ 应该以高概率落在置信区间内（忽略常数和对数项）：

$$\left[\hat{\mu}_{t-1}(a) - 1/\sqrt{n_{t-1}(a)}, \hat{\mu}_{t-1}(a) + 1/\sqrt{n_{t-1}(a)}\right].$$

有了这些合理的环境，我们接下来要问哪一个是最有利的。由于我们的目标是尽可能少地遭受损失，最好的情况是当 $\mu(a)$ 恰好等于 $\hat{\mu}_{t-1}(a) - 1/\sqrt{n_{t-1}(a)}$（称为下置信界）时。最后，我们将乐观地假设这确实是真实环境，并据此行动，在这种情况下意味着选择具有最小下置信界的动作。

形式上，在仔细选择常数和对数项后，我们将动作 $a$ 在时间 $t$ 的下置信界定义为

$$\text{LCB}_t(a) = \hat{\mu}_{t-1}(a) - 2\sqrt{\frac{\ln T}{n_{t-1}(a)}}.$$

然后在时间 $t$，UCB 算法简单地选择

$$a_t = \arg\min_{a\in[K]} \text{LCB}_t(a).$$

首先，注意 $n_{t-1}(a)$ 最初为 0，导致 $\text{LCB}_t(a)$ 为负无穷，这意味着算法将在前 $K$ 轮中被迫选择每个动作一次。之后，$\text{LCB}_t(a)$ 中的两项本质上分别扮演着利用和探索的角色，因为它建议选择经验均值低但根据被选择的次数进行惩罚的动作。每当选择一个次优动作时，其下置信界很可能上升，因此在未来不太可能再次被选择，这意味着乐观驱动探索。（实际上，想想如果使用悲观策略选择具有最低上置信界的动作会发生什么）。

注意，与随机算法如 Exp3 相比，UCB 和先探索后利用策略都是确定性算法——算法本身没有随机性。重要的是，UCB 不需要知道差距 $\Delta_a$，是一个非常简单和实用的算法（实际上，$\text{LCB}_t(a)$ 中的 $\ln T$ 项可以替换为 $\ln t$，使算法真正无参数）。最后，我们证明 UCB 的以下界限，其精神与等式 (1) 相同。

**定理 2**：UCB 的伪遗憾被界定为

$$\overline{\mathcal{R}}_T \leq \sum_{a:\Delta_a>0} \left(\frac{16\ln T}{\Delta_a} + 2\Delta_a\right)$$

???- Info "Proof"

只需要证明 $\mathbb{E}[n_T(a)] \leq \frac{16\ln T}{\Delta_a} + 2\Delta_a$ 即可。直觉来看，前 $n$ 轮的

## 3. 随机线性赌博机

### 3.1 LinUCB 算法

## 4. 对抗线性赌博机

### 4.1 Exp2 算法

### 4.2 FTPL 与对抗线性赌博机

## 5. 赌博机凸优化

## 6. 上下文赌博机

### 6.1 Oracle-efficient 算法







