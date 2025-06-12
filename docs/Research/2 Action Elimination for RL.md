# Action Elimination and Stopping Conditions for the Multi-Armed Bandit and Reinforcement Learning Problems

!!! Abstract

    <img class="center-picture" src="../assets_2/abstract.webp" alt="abstract" width=580 />

    - Tag: Multi-Armed Bandit, Reinforcement Learning, PAC Learnable, Action Elimination. 
    - Journal of Machine Learning Research Volume 7 (2006) 1079–1105
    - [Origin Paper Link](https://jmlr.csail.mit.edu/papers/volume7/evendar06a/evendar06a.pdf)
    - 文中图片均来自论文
    - 主要看了关于 MAB 的算法，RL 的算法之后再说。

## 0 Most Important Things

## 1 Introduction

迄今为止的大多数工作都考虑的是期望遗憾/Expected Regret，我们的工作被设置到 PAC 框架下，目标是在至少 $1 - \delta$ 的概率下，算法可以输出一个 $\epsilon$-optimal 的摇臂。我们对复杂度的主要判别准则不仅仅有准确度，还有纯探索的步数/算法需要的步数。

简单来说，我们做的工作就是 $\delta$-PAC BAI。

MAB 问题更多对应的是环境是静态时的情况，我们可以进行多次重复决策。在现实中，模型应该呈现系统的状态随着时间变化的情形，这就是马尔科夫决策过程，并且这时候模型是未知的（如果已知就已经有很多方法了）。当模型未知的时候，我们就需要一个学习的机制，应运而生的就是 RL，这也是动态环境自适应控制的统一模型。很多 RL 算法的统一问题是收敛率很低，甚至对于很简单的小问题也是这样。随机逼近的统一收敛率和 Q-学习的收敛率都很令人失望，尽管这些收敛率被证明对于很多差的情境下都是几乎紧的。

我们提出的问题是：何时信息已经收集充分，智能体何时才可以使用合理的置信度声明已经发现的策略是最优的或者至少是近似最优的？因此我们需要为特定的 MDP 量身定制参数，令其显著提升对于特定问题的表现。

学习的停止性条件也是 RL 的基础问题之一。目前使用的停止规则多是启发式方法，很可能导致过早或者过晚的停止。

Action Elimination 的核心在于这样的想法：当确定一个状态的某一个动作确定不属于最优策略的时候，我们在计划和学习的时候就可以将其完全舍弃掉。AE 有两个作用，其一就是缩减每次迭代的搜寻空间，另一个就是在唯一最优策略存在的时候确定它。我们将在模型最初未知的情况下，在学习的语境下考虑 AE。

另一个 AE 的动机就是减少 RL 采样的数目。

在[第三节](#3-pac-bounds-for-mab-problems)我们将从 MAB 问题的一个简单算法开始，然后介绍两个改进的算法，分别是 **Successive Elimination** 和 **Median Elimination**。

- Successive Elimination：最优摇臂和次优摇臂之间的差距显著大于 $\epsilon$ 的时候，表现会更优；
- Median Elimination：改进了对摇臂数量的依赖，需要测试的数目减少到了 $O(n/\epsilon^2 \log(1/\delta))$。

## 2 Model and Preliminaries

### 2.1 Multi-Armed Bandit

一个摇臂的集合 $A$，包含 $n = \lvert A \rvert$ 个摇臂。对 $a \in A$ 采样的时候，我们会收到一个随机变量 $R(a) \in \{0,1\}$ 表示奖励。我们假设奖励是二元的，当然奖励只要是有界的时候，我们都可以将本文的结论推广过去。

摇臂记为 $a_1, a_2, \cdots, a_n$，且 $p_i = \mathbb{E}[R(a_i)]$。为简化表示，我们按照期望奖励对摇臂进行排序：$p_1 > p_2 > \cdots > p_n$。

- 存在一个最佳摇臂 $a^*$，其期望奖励 $r^*$ 被称为最优奖励；
- 其余期望奖励严格小于 $r^*$ 的摇臂被称为非最佳摇臂。
- 如果摇臂 $a$ 的期望奖励与最优奖励之差最多为 $\epsilon$，即 $\mathbb{E}[R(a)] \geq r^* - \epsilon$，则称该摇臂为 $\epsilon$-最优摇臂。

MAB 算法的每一步对一个摇臂 $a_i$ 进行采样，并收到一个奖励 $r_i$，奖励遵从 $R(a_i)$。

- $(\epsilon, \delta)$-PAC 算法：在样本复杂度为 $T$ 的时候，在至少 $1 - \delta$ 的概率下，算法可以输出一个 $\epsilon$-最优摇臂，当算法终止时，算法执行的步骤数不超过 $T$。
- 我们的算法考虑的是最差的情况，而非期望样本复杂度，期望样本复杂度不仅仅考虑了模型的随机性，也考虑了算法的随机性。

### 2.2 Markov Decision Process

<!--
## 2.2 马尔科夫决策过程

我们将MDP定义如下：

**定义3** 马尔科夫决策过程(MDP) $M$是一个4元组$(S,A,P,R)$，其中$S$是状态集，$A$是动作集，$P^a_{s,s'}$是在状态$s$执行动作$a \in A$时从状态$s$转移到状态$s'$的概率，$R(s,a)$是在状态$s$执行动作$a$时获得的奖励。

MDP的策略在每个时间$t$，为每个状态$s$赋予执行动作$a \in A$的概率，给定历史$F_{t-1} = \{s_1,a_1,r_1,...,s_{t-1},a_{t-1},r_{t-1}\}$，其中包含直到时间$t-1$观察到的状态、动作和奖励。当按照策略$\pi$时，我们在时间$t$在状态$s_t$执行动作$a_t$并观察到奖励$r_t$（根据$R(s_t,a_t)$分布），下一个状态$s_{t+1}$根据$P^{a_t}_{s_t,\cdot}$分布。我们将奖励序列合并为一个称为**回报**的单一值。我们的目标是最大化回报。在本研究中，我们关注**折扣回报**，其参数$\gamma \in (0,1)$，策略$\pi$的折扣回报为$V^\pi = \sum_{t=0}^{\infty} \gamma^t r_t$，其中$r_t$是在时间$t$观察到的奖励。我们也考虑**有限视界回报**，$V^\pi = \sum_{t=0}^H r_t$，其中$H$为给定视界。

我们假设$R(s,a)$是非负的且由$R_{max}$界定，即对于所有$s,a$：$0 \leq R(s,a) \leq R_{max}$。这意味着折扣回报由$V_{max} = R_{max}/(1-\gamma)$界定；对于有限视界，回报由$HR_{max}$界定。我们定义每个状态$s$在策略$\pi$下的值函数为$V^\pi(s) = \mathbb{E}^\pi[\sum_{t=0}^{\infty} r_t \gamma^t]$，其中期望是对于从状态$s$开始执行策略$\pi$的过程。我们进一步将状态-动作值函数定义为在状态$s$使用动作$a$然后遵循$\pi$：

$$Q^\pi(s,a) = R(s,a) + \gamma\sum_{s'} P^a_{s,s'} V^\pi(s')$$

类似地，我们定义有限视界模型的值函数。

令$\pi^*$是从任何起始状态最大化回报的最优策略。对于折扣回报标准，存在这样一个确定性且静态的策略（例如，见Puterman, 1994）。这意味着对于任何策略$\pi$和任何状态$s$，我们有$V^{\pi^*}(s) \geq V^\pi(s)$，且$\pi^*(s) = \arg\max_a (R(s,a) + \gamma\sum_{s'} P^a_{s,s'} V^*(s'))$。我们使用$V^*$和$Q^*$分别表示$V^{\pi^*}$和$Q^{\pi^*}$。如果$\|V^* - V^\pi\|_\infty \leq \epsilon$，我们称策略$\pi$为$\epsilon$-最优的。我们还定义$Greedy(Q)$策略为在每个状态执行最大化该状态$Q$函数的动作，即$\pi(s) = \arg\max_a Q(s,a)$。

对于给定轨迹，令$T^{s,a}$为我们在状态$s$执行动作$a$的时间集合，$T^{s,a,s'}$是$T^{s,a}$的子集，表示我们到达状态$s'$的时间。此外，$\#(s,a,t)$是直到时间$t$动作$a$在状态$s$中执行的次数，即$|T^{s,a} \cap \{1,2,3,...,t\}|$。我们类似地定义$\#(s,a,s',t)$为$|T^{s,a,s'} \cap \{1,2,3,...,t\}|$。接下来我们定义时间$t$的实证模型。给定$\#(s,a,t) > 0$，我们将时间$t$的实证下一状态分布定义为：

$$\hat{P}^a_{s,s'} = \frac{\#(s,a,s',t)}{\#(s,a,t)} \quad \text{且} \quad \hat{R}(s,a) = \frac{\sum_{t\in T^{s,a}} r_t}{\#(s,a,t)}$$

如果$\#(s,a,t) = 0$，则实证模型和奖励可以任意选择。我们定义实证模型的期望为$\hat{\mathbb{E}}_{s',s,a}[V(s')] = \sum_{s'\in S} \hat{P}^a_{s,s'} V(s')$。为简化表示，当明显时，我们在$\hat{\mathbb{E}}_{s'}$表示中省略$s,a$。
 -->

### 2.3 Concentration Bounds

**Lemma**（Hoeffding）：$X$ 为集合，$D$ 为 $X$ 上的概率分布，$f_1, \cdots, f_m$ 为定义在 $X$ 上的实值函数，其中 $f_i : X \rightarrow [a_i, b_i]$，$i = 1, \cdots, m$，$a_i$ 和 $b_i$ 是满足 $a_i < b_i$ 的实数。令 $x_1, \cdots, x_m$ 为来自 $D$ 的独立同分布样本。则我们有以下不等式：

$$\begin{aligned}
    \mathbf{P}\left[\frac{1}{m}\sum_{i=1}^m f_i(x_i) - \left(\frac{1}{m}\sum_{i=1}^m \int_{a_i}^{b_i} f_i(x)D(x)\right) \geq \epsilon\right] &\leq \exp\left\{-\frac{2\epsilon^2m^2}{\sum_{i=1}^m(b_i-a_i)^2}\right\} \\ 
    \mathbf{P}\left[\frac{1}{m}\sum_{i=1}^m f_i(x_i) - \left(\frac{1}{m}\sum_{i=1}^m \int_{a_i}^{b_i} f_i(x)D(x)\right) \leq -\epsilon\right] &\leq \exp\left\{-\frac{2\epsilon^2m^2}{\sum_{i=1}^m(b_i-a_i)^2}\right\}
\end{aligned}$$

其中有界性假设并非必要，某些时候可以放宽，使用 Relative Chernoff Bound 可以获得更紧的界。

## 3 PAC Bounds for MAB Problems

### 3.1 Naive Algorithm

完全基于 Hoeffding 不等式，对每个摇臂均重复多次采样，使用经验均值估计背后的期望均值，按照经验均值最优原则选择最优摇臂。

<img class="center-picture" src="../assets_2/alg-1.webp" alt="alg-1" width=580 />

**Theorem 1**：这个算法 $\mathrm{Naive}(\epsilon, \delta)$ 是一个 $(\epsilon, \delta)$-PAC 算法，其样本复杂度为 $O(n/\epsilon^2 \log(n/\delta))$。

证明很简单，考虑最终选中的摇臂非最优的必要条件即可。

### 3.2 Successive Elimination

我们尝试一个一个消除非最优的摇臂，并且对每一个摇臂采样次数最小。首先假设我们知道所有摇臂的期望奖励，但是不知道摇臂和期望奖励之间的对应关系。

基本想法：我们是用 $\Delta_i = p_1 - p_i > 0$ 衡量摇臂 $i$ 和最优摇臂 $1$ 的差距，目标是对每一个摇臂 $a_i$ 采样 $(1/\Delta_i^2)\log(n/\delta)$ 次。同时我们希望一个一个消除摇臂，而最差的摇臂只需要采样 $(1/\Delta_n^2)\log(n/\delta)$ 次，于是我们可以构建每轮采样 $\left(1/\Delta_{n-i}^2 - 1/\Delta_{n-i+1}^2\right)\log(n/\delta)$ 次的算法。

<img class="center-picture" src="../assets_2/alg-2.webp" alt="alg-2" width=580 />

**Theorem**：假设 $\Delta_i > 0$，则 Successive Elimination with Known Biases（已知偏差的连续消除）算法是一个 $(0, \delta)$-PAC 算法，其摇臂采样复杂度为：

$$O\left(\left(\sum_{i=2}^n \frac{1}{\Delta_i^2}\right) \log \frac{n}{\delta} \right)$$

??? Info "Proof"

    样本复杂度显而易见，我们其实采样了 $t_2 + \sum\limits_{i=2}^{n} t_i$ 次，这显然满足复杂度要求。

    我们现在证明算法以至少 $1-\delta$ 的概率是正确的：考虑简化的算法，假设每个摇臂都被拉动 $8/(\Delta_i^2)\log(2n/\delta)$ 次。对于每个 $2 \leq i \leq n-1$，我们定义事件

    $$E_i = \{\hat{p}_1^{t_j} \geq \hat{p}_i^{t_j} \vert \forall j \text{ s.t. } j \geq i\}$$

    其中 $\hat{p}_i^{t_j}$ 是摇臂 $i$ 摇动 $t_j$ 次的经验奖励均值。这个算法的含义是：最优摇臂的奖励均值在其参与的每一轮 Elimination 中都大于摇臂 $a_i$ 的奖励均值。如果对所有 $i > 1$ 事件 $E_i$ 都成立，则算法成功。

    我们计算 $\mathbf{P}[\text{not}(E_i)]$，即事件 $E_i$ 不成立的概率：

    $$\begin{aligned}
        \mathbf{P}[\text{not}(E_i)] &\leq \sum_{j=i}^n \mathbf{P}[\hat{p}_1^{t_j} < \hat{p}_i^{t_j}] \\ 
        &\leq \sum_{j=i}^n 2 \exp (-2(\Delta_i/2)^2 t_j) \\
        &\leq \sum_{j=i}^n 2 \exp (-2(\Delta_i/2)^2 8/(\Delta_j^2)\log(2n/\delta)) \\
        &\leq \sum_{j=i}^n 2 \exp (-\log(4n^2/\delta^2)) \\
        &\leq (n-i+1)\delta^2/n^2 \leq \delta/n
    \end{aligned}$$

    其中第一个不等式使用联合界不等式，第二个不等式需要仿照 Lemma 1 的必要条件使用 Hoeffding 不等式，然后将 $t_i$ 代入，后续就是水到渠成的。

    再使用所有 $E_i$ 的并集界，我们得到简化的算法以至少 $1-\delta$ 的概率满足所有 $E_i$。考虑原始设置。如果摇臂 $1$ 在时间 $t_j$ 被消除，则表明某个摇臂 $i < j$ 在时间 $t_j$ 具有更高的经验值。算法失败的概率由简化的设置中的失败概率界定。

我们放松对所有臂的期望奖励已知的假设，进而引入适用于任何偏差集合的连续消除算法。

<img class="center-picture" src="../assets_2/alg-3.webp" alt="alg-3" width=580 />

**Theorem**：假设 $\Delta_i > 0$，则 Successive Elimination with Unknown Biases（未知偏差的连续消除）算法是一个 $(0, \delta)$-PAC 算法，其摇臂采样复杂度为：

$$O\left(\sum_{i=2}^n \frac{1}{\Delta_i^2} \log \frac{n}{\delta\Delta_i}\right)$$

??? Info "Proof"

    在这种情况下，反而 PAC 是更容易证明的了。最重要的论证是，在任何时间 $t$ 和任意动作 $a$，观察到的概率 $\hat{p}_a^t$ 与真实概率 $p_a$ 的差距在 $\alpha_t$ 范围内。对于任何时间 $t$ 和动作 $a \in S_t$，我们有

    $$\mathbf{P}[|\hat{p}_a^t - p_a| \geq \alpha_t] \leq \exp(-2\alpha_t^2t) \leq \frac{2\delta}{cnt^2}$$

    通过取常数 $c$ 大于 4，并从并集界得出，对于任何时间 $t$ 和任何动作 $a \in S_t$，以至少 $1-\delta/n$ 的概率，$|\hat{p}_a^t - p_a| < \alpha_t$。因此，以概率 $1-\delta$，最佳摇臂永远不会被消除。此外，由于 $\alpha_t$ 随着 $t$ 的增加而趋向于零，最终每个非最佳摇臂都会被消除，而留下来的摇臂如果不是最佳摇臂，那么这就是整个 PAC 算法的 $\delta$ 的部分。这完成了算法是 $(0,\delta)$-PAC 的证明。

    剩下的是计算摇臂样本复杂度。要消除一个非最佳摇臂 $a_i$，我们需要达到时间 $t_i$，使得

    $$\hat{\Delta}_{t_i} = \hat{p}_{a_1}^{t_i} - \hat{p}_{a_i}^{t_i} \geq 2\alpha_{t_i}$$

    结合 $\alpha_t$ 的定义和假设 $|\hat{p}_a^t - p_a| \leq \alpha_t$，我们得到

    $$\Delta_i - 2\alpha_{t} = (p_1 - \alpha_{t}) - (p_i + \alpha_{t}) \geq \hat{p}_1 - \hat{p}_i \geq 2\alpha_{t}$$

    通过这个不等式以及 $\alpha_t$ 的定义，我们可以**验证** $t_i = O\left(\dfrac{\log(n/\delta\Delta_i)}{\Delta_i^2}\right)$。
 
可以很简单的放松条件到 $(\epsilon, \delta)$-PAC 的情况，只需要在只剩一个摇臂或当剩余的 $k$ 个摇臂都被采样 $O(\frac{1}{\epsilon^2}\log(\frac{k}{\delta}))$ 次时停止并且返回迄今为止表现最好的摇臂就可以了。这种情况下，我们的样本复杂度就变成了

$$O\left(\sum_{i:\Delta_i>\epsilon} \frac{\log(n/\delta\Delta_i)}{\Delta_i^2} + \frac{N(\Delta,\epsilon)}{\epsilon^2}\log\left(\frac{N(\Delta,\epsilon)}{\delta}\right)\right)$$

其中 $N(\Delta, \epsilon)$ 是 $\epsilon$-最优的摇臂数量。

### 3.3 Median Elimination

基本想法就是在每一轮迭代的时候消除最差的一半摇臂，我们也不希望最佳摇臂在经验上是最好的，只希望一个 $\epsilon$-最优摇臂位于中位数之上。

<img class="center-picture" src="../assets_2/alg-4.webp" alt="alg-4" width=580 />

**Theorem**：参数为 $(\epsilon, \delta)$ 的中位数消除算法是一个 $(\epsilon, \delta)$-PAC 算法，其摇臂样本复杂度为

$$O\left(\frac{n}{\epsilon^2}\log\left(\frac{1}{\delta}\right)\right)$$

首先我们先证明第 $\ell$ 阶段，$S_\ell$ 中最佳摇臂的期望奖励最多下降 $\epsilon_\ell$。

**Lemma**：对于参数为 $(\epsilon, \delta)$ 的中位数消除算法，对每一段 $\ell$ 都有：

$$\mathbf{P}[\max_{j\in S_\ell} p_j \leq \max_{i\in S_{\ell+1}} p_i + \epsilon_\ell] \geq 1-\delta_\ell$$

> 其实证明的是每一轮算法中，所谓 bad 的摇臂数量超过一半的概率有一个上界，这个上界是 $\delta_\ell$，其中所谓 bad 的摇臂定义为非 $\epsilon_\ell$-最优但在经验上优于最佳摇臂的摇臂。

???- Info "Proof"

    不失一般性，我们考察第一轮并假设 $p_1$ 是最佳摇臂的奖励。我们通过考察事件 $E_1 = \{\hat{p}_1 < p_1 - \epsilon_1/2\}$ 来界定失败概率，这个事件表明对最佳摇臂的经验估计过于悲观。由于我们已经进行了足够的采样，使用 Hoeffding 不等式，我们有 $\mathbf{P}[E_1] \leq \delta_1/3$。

    如果我们的估计还算乐观，也就是事件 $E_1$ 并不成立，我们计算一个非 $\epsilon_1$-最优摇臂 $j$ 在经验上优于最佳摇臂的概率：

    $$\mathbf{P}[\hat{p}_j \geq \hat{p}_1 \mid \hat{p}_1 \geq p_1 - \epsilon_1/2] \leq \mathbf{P}[\hat{p}_j \geq p_j + \epsilon_1/2 \mid \hat{p}_1 \geq p_1 - \epsilon_1/2] \leq \delta_1/3$$

    令 $\# \mathrm{bad}$ 为非 $\epsilon_1$-最优但在经验上优于最佳摇臂的摇臂数量。显然有 $\mathbb{E}[\# \mathrm{bad} \mid \hat{p}_1 \geq p_1 - \epsilon_1/2] \leq n\delta_1/3$。接下来我们应用马尔可夫不等式得到，

    $$\mathbf{P}[\# \mathrm{bad} \geq n/2 \mid \hat{p}_1 \geq p_1 - \epsilon_1/2] \leq \frac{n\delta_1/3}{n/2} = 2\delta_1/3$$

    使用一下并集界：

    $$\begin{aligned}
        \mathbf{P}[\# \mathrm{bad} \geq n/2] &= \mathbf{P}[\# \mathrm{bad} \geq n/2 \mid \neg E_1] \mathbf{P}[\neg E_1] + \mathbf{P}[\# \mathrm{bad} \geq n/2 \mid E_1] \mathbf{P}[E_1] \\
        &\leq \mathbf{P}[\# \mathrm{bad} \geq n/2 \mid \neg E_1] + \mathbf{P}[E_1] \\
        &\leq \frac{2\delta_1}{3} + \delta_1/3 = \delta_1
    \end{aligned}$$

    这就完成了证明。

**Lemma**：对于参数为 $(\epsilon, \delta)$ 的中位数消除算法，其样本复杂度为 $O(n/\epsilon^2 \log(1/\delta))$。

???- Info "Proof"

    第 $\ell$ 轮中的摇臂样本数为 $4 n_\ell \log(3/\delta_\ell)/\epsilon_\ell^2$。根据定义我们有

    1. $\delta_1 = \delta/2$；$\delta_\ell = \delta_{\ell-1}/2 = \delta/2^\ell$
    2. $n_1 = n$；$n_\ell = n_{\ell-1}/2 = n/2^{\ell-1}$
    3. $\varepsilon_1 = \varepsilon/4$；$\varepsilon_\ell = \frac{3}{4}\varepsilon_{\ell-1} = \left(\frac{3}{4}\right)^{\ell-1}\varepsilon/4$

    因此我们有

    $$\begin{aligned}
        \sum_{\ell=1}^{\log_2(n)} \frac{n_\ell\log(3/\delta_\ell)}{(\varepsilon_\ell/2)^2} &= 4 \sum_{\ell=1}^{\log_2(n)} \frac{n/2^{\ell-1}\log(2^\ell 3/\delta)}{((3/4)^{\ell-1}\varepsilon/4)^2} \\
        &= 64 \sum_{\ell=1}^{\log_2(n)} n\left(\frac{8}{9}\right)^{\ell-1}\left(\frac{\log(1/\delta)}{\varepsilon^2} + \frac{\log(3)}{\varepsilon^2} + \frac{\ell\log(2)}{\varepsilon^2}\right) \\
        &\leq 64\frac{n\log(1/\delta)}{\varepsilon^2} \sum_{\ell=1}^{\infty} \left(\frac{8}{9}\right)^{\ell-1}(\ell C^{\prime} + C) = O\left(\frac{n\log(1/\delta)}{\varepsilon^2}\right)
    \end{aligned}$$

因此我们关于算法复杂度和 PAC 性质的定理就很容易证明。

## 4 Learning in MDPs

## 5 Experiments

## 6 Future Directions
