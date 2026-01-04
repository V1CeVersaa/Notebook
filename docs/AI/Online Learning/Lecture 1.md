# Topic 1: Online Learning and Online Convex Optimization



## Expert Problem, Hedge and FTL

在线凸优化问题抽象如下：在每一个时间点，学习者 Learner 需要做出一个决策 $w_t\in S$，但是同时遭受一个凸损失 $f_t(w)\colon S\to \mathbb{R}$，我们将遗憾界写为

$$
\mathcal{R}_T = \sum_{t=1}^T f_t(w_t) - \min_{w\in S} \sum_{t=1}^T f_t(w)
$$


最 naive 的算法是 Follow the Leader/FTL，也就是每次选择在上一轮表现最好的策略进行输出，也就是我们将要输出 $w_t = \underset{w\in S}{\arg\min} \sum\limits_{s=1}^{t-1} f_s(w)$。


### .1 Recovering the Hedge

### .2 Online Gradient Descent

在下一个例子中，我们考虑一个任意的 OCO 问题，并选择 $\psi(w) = \frac{1}{2}\|w\|_2^2$。FTRL算法变为

$$w_t = \underset{w\in\Omega}{\text{argmin}} \sum_{\tau=1}^{t-1} f_\tau(w) + \frac{1}{2\eta}\|w\|_2^2 .$$

可以使用标准方法（近似地）解决这个凸优化问题。然而，事实证明，在不失一般性的情况下，可以假设 $f_t$ 是一个线性函数。要理解这一点，注意到由于凸性，遗憾可以被界定为

$$\begin{aligned}
    \mathcal{R}_T &= \max_{w\in\Omega} \sum_{t=1}^T (f_t(w_t) - f_t(w)) \leq \max_{w\in\Omega} \sum_{t=1}^T \langle \nabla f_t(w_t), w_t - w \rangle \\ 
    &= \sum_{t=1}^T \langle \nabla f_t(w_t), w_t\rangle - \min_{w\in\Omega} \sum_{t=1}^T \langle \nabla f_t(w), w\rangle
\end{aligned}$$

因此，我们可以想象损失函数实际上是一个线性函数 $f'_t(w) = \langle \nabla f_t(w_t), w\rangle$（这里的 $'$ 并不表示导数），对这个线性问题的遗憾界显然也是原始问题的遗憾界。通过这种简化，我们将上述FTRL重写为

$$\begin{aligned}
    w_t &= \underset{w\in\Omega}{\text{argmin}} \left\langle w, \sum_{\tau=1}^{t-1} \nabla f_\tau(w_\tau) \right\rangle + \frac{1}{2\eta}\|w\|_2^2 \\ 
    &= \underset{w\in\Omega}{\text{argmin}} \|w\|_2^2 + 2\eta \left\langle w, \sum_{\tau=1}^{t-1} \nabla f_\tau(w_\tau) \right\rangle +\eta^2 \left(\sum_{\tau=1}^{t-1} \nabla f_\tau(w_\tau)\right)^2 \\ 
    &= \underset{w\in\Omega}{\text{argmin}} \left\|w + \eta \sum_{\tau=1}^{t-1} \nabla f_\tau(w_\tau) \right\|_2^2
\end{aligned}$$

这意味着 $w_t$ 是 $u_t = -\eta\sum_{\tau=1}^{t-1} \nabla f_\tau(w_\tau)$ 在 $\Omega$ 上的 $L_2$ 投影。这个算法被称为**在线梯度下降/OGD**。要了解与常规梯度下降的联系，请注意OGD可以等价地写为

$$
u_{t+1} = u_t - \eta\nabla f_t(w_t); \quad w_{t+1} = \underset{w\in\Omega}{\text{argmin}} \|w - u_{t+1}\|
$$

而常规梯度下降则会执行

$$
u_{t+1} = w_t - \eta\nabla f_t(w_t); \quad w_{t+1} = \underset{w\in\Omega}{\text{argmin}} \|w - u_{t+1}\|
$$

实际上，这两种算法之间几乎没有真正的区别，并且可以为它们证明相同的界（One can prove the same guarantee for both of them）。下面我们应用一般的 FTRL 保证来证明遗憾界。

确实，可以很容易地验证 $\psi(w) = \frac{1}{2}\|w\|_2^2$ 相对于 $L_2$ 范数是强凸的。注意 $L_2$ 范数的对偶范数是它自身。因此，如果我们令 $G$ 是所有梯度的上界，即 $\|\nabla f_t(w_t)\|_2 \leq G$，那么 OGD 的遗憾被界定为

$$
\mathcal{R}_T \leq \frac{\max_{w\in\Omega} \|w\|_2^2}{2\eta} + \eta TG^2 = \mathcal{O}\left(\max_{w\in\Omega} \|w\|_2 G\sqrt{T}\right)
$$

其中最后一步是通过均值不等式选择最优的 $\eta$ 得到的。

## Follow the Perturbed Leader and Combinatorial Problems

正如我们所见，FTRL 使用正则化来稳定算法。在这里，我们介绍另一种非常不同的方法，即**扰动/Perturbation**。为了说明这种方法，我们考虑以下在线组合问题。

设 $S = \{v_1, \ldots, v_M\}$ 是一组组合动作，其中 $v_j \in \{0, 1\}^N$ 且对于某个整数 $m \leq N$ 和所有 $j \in [M]$，有 $\|v_j\|_1 \leq m$。学习者的决策空间是 $S$ 的凸包，即 $\Omega = \left\{\sum\limits_{j=1}^M p(j)v_j : p \in \Delta(M)\right\}$。因此，$\Omega$ 中的每一点都指定了这些组合动作的分布，也就是一个随机化策略。我们考虑线性损失函数，使得 $f_t(w) = \langle w, \ell_t \rangle$，其中 $\ell_t \in [0, 1]^N$。最后，为简单起见，我们将注意力限制在预先确定环境中，因此 $\ell_1, \ldots, \ell_T$ 在游戏开始前就已确定。

专家问题显然是一个特例，其中 $S$ 由 $\mathbb{R}^N$ 中的所有标准基向量组成，且 $m = 1$。另一个例子是当 $S = \{v \in \{0, 1\}^N : \|v\|_1 = m\}$，因此 $\Omega = \{w \in [0, 1]^N : \|w\|_1 = m\}$（回想第 1 讲中的多产品推荐示例）。

另一个重要的例子是在线最短路径问题。在这个问题中，给定一个有 $N$ 条边的有向无环图、一个源顶点和一个目标顶点。每一轮，玩家首先随机选择一条路径，然后每条边的损失（例如，延迟）被揭示，玩家遭受所选路径上所有边的总损失。这可以表述为上述组合问题的一个特例，方法是设定 $S$ 为从源点到目标点的所有路径的集合（即，路径由向量 $v \in \{0, 1\}^N$ 表示，其中每个坐标表示相应的边是否在路径上）。注意，$m$ 是最长路径的长度。

我们可以再次使用FTRL方法来解决这个问题，但通常不清楚如何解决FTRL中的优化问题。相反，我们考虑一种称为**跟随扰动领导者/FTPL** 的不同方法，它只需要在 $\Omega$ 上进行线性优化。具体来说，令 $\ell_0$ 是从 $[0, 1/\eta]^N$ 中均匀随机抽取的，其中 $\eta > 0$。然后在第 $t$ 轮，FTPL 执行

$$
w_t = \underset{w\in\Omega}{\text{argmin}} \left\langle w, \sum_{\tau=0}^{t-1} \ell_\tau \right\rangle
$$

换句话说，$w_t$ 是根据累积损失加上一些扰动 $\ell_0$ 确定的领导者。注意，由于线性性，这个领导者总是 $\Omega$ 中的某个点。此外，对于许多问题，这种线性优化有高效的算法。例如，对于专家问题，这可以通过选择最佳坐标来轻松解决。对于在线最短路径问题，可以通过诸如 Dijkstra 算法的最短路径算法来解决。

接下来需要证明FTPL的遗憾界。为此，我们首先证明扰动在期望上提供了稳定性。

**引理 1**（FTPL 的稳定性）：具有参数 $\eta$ 的 FTPL 确保

$$
\mathbb{E}[f_t(w_t) - f_t(w_{t+1})] \leq mN\eta
$$

其中期望是相对于 $\ell_0$ 取的。

???- Info "证明"

    为了明确依赖关系，定义 $h_t(\ell_0) = \left\langle \underset{w\in\Omega}{\text{argmin}}\langle w, \sum\limits_{\tau=1}^{t-1} \ell_\tau + \ell_0 \rangle, \ell_t \right\rangle$。那么我们有

    $$\begin{aligned}
    \mathbb{E}[f_t(w_t) - f_t(w_{t+1})] &= \mathbb{E}[h_t(\ell_0) - h_t(\ell_0 + \ell_t)] \\
    &= \eta^N \int_{\ell_0\in[0,1/\eta]^N} h_t(\ell_0) - h_t(\ell_0 + \ell_t)d\ell_0 \\
    &= \eta^N \left(\int_{\ell_0\in[0,1/\eta]^N} h_t(\ell_0)d\ell_0 - \int_{\ell_0\in[\ell_t,[0,1/\eta]^N} h_t(\ell_0)d\ell_0 \right) \\
    &\leq \eta^N \int_{\ell_0\in[0,1/\eta]^N \setminus \ell_t+[0,1/\eta]^N} h_t(\ell_0)d\ell_0 \\
    &\leq m\eta^N \int_{\ell_0\in[0,1/\eta]^N \setminus \ell_t+[0,1/\eta]^N} d\ell_0 \\
    &= m \cdot \text{Pr}(\exists i : \ell_0(i) \leq \ell_t(i)) \\
    &\leq m \sum_{i=1}^N \text{Pr}(\ell_0(i) \leq 1) \\
    &= mN\eta.
    \end{aligned}$$

    - 第二个不等式是因为 $h_t(\ell_0) \leq m$；
    - 第三个不等式是通过并集界和 $\ell_t(i) \leq 1$。

有了稳定性引理，我们可以使用与 FTRL 类似的论证来证明下面的界。

**定理 1**：具有参数 $\eta$ 的 FTPL 可以保证下面遗憾界：

$$\mathbb{E}[\mathcal{R}_T] \leq \frac{m}{2\eta} + mNT\eta$$

其中期望是相对于 $\ell_0$ 的随机性的。当 $\eta$ 最优地设置为 $\sqrt{1/(2NT)}$ 时，我们得到 $\mathbb{E}[\mathcal{R}_T] = \mathcal{O}(m\sqrt{TN})$。

???- Info "证明"

    注意，根据 BTL 引理，对于 $w^* = \underset{w\in\Omega}{\text{argmin}} \sum_{t=1}^T f_t(w)$，我们再次有

    $$\begin{aligned}
    \mathcal{R}_T &= \sum_{t=1}^T f_t(w_t) - \sum_{t=1}^T f_t(w^*) \\
    &\leq \sum_{t=1}^T f_t(w_t) - \sum_{t=0}^T f_t(w_{t+1}) + f_0(w^*) \\
    &= f_0(w^*) - f_0(w_1) + \sum_{t=1}^T (f_t(w_t) - f_t(w_{t+1})).
    \end{aligned}$$

    应用稳定性引理并注意到到 $\mathbb{E}[f_0(w^*) - f_0(w_1)] \leq \mathbb{E}[\langle \ell_0, w^* \rangle] = \langle \mathbb{E}[\ell_0], w^* \rangle \leq \frac{m}{2\eta}$ 完成证明。


注意，**这个上界在一般情况下是次优的**。例如，在专家问题中，它对 $N$ 有多项式依赖，而不是对数依赖。然而，使用更复杂的噪声分布（而不是均匀分布），遗憾界通常可以改进为最优。事实上，众所周知，在专家问题中，带有 Gumbel 噪声的 FTPL 等价于 Hedge。

为了处理非预先确定的环境，事实证明只需要在每轮开始时重新抽取一个新的 $\ell_0$ 样本。直觉是这将防止非预先确定的环境（其策略可能依赖于玩家的行动）逐渐弄清 $\ell_0$。

> 尽管 Hedge 在最差情况下是最优的，但是人们可能会想知道在处理实际问题时它的表现如何，因为实际问题可能不是最坏情况，甚至不是相对困难的情况。事实上，我们为 Hedge 证明的遗憾界仅表明对于所有问题实例，Hedge 的遗憾都被 $\mathcal{O}(\sqrt{T\ln N})$ 一致地界定。然而，理想情况下，我们希望有一个算法，在许多简单情况下具有更小的遗憾，但在最坏情况下仍然保证最小最大遗憾 $\mathcal{O}(\sqrt{T\ln N})$。推导自适应算法和自适应遗憾界正是实现这一目标的一种方式。

### .1 Small Loss Bounds

我们从可以说是最简单的自适应界开始，有时称为"小损失"界或一阶界。回想一下，我们为Hedge证明了以下中间界：

$$\mathcal{R}_T = \widetilde{L}_T - L_T(i^*) \leq \frac{\ln N}{\eta} + \eta\sum_{t=1}^T \sum_{i=1}^N p_t(i)\ell_t^2(i),$$

其中 $L_T$ 是累积损失向量，$i^*$ 是最佳专家，我们定义 $\widetilde{L}_T = \sum_{t=1}^T \langle p_t, \ell_t \rangle$ 为算法的累积损失。由于损失的有界性，上式最后一项可以被 $\eta\widetilde{L}_T$ 界定。如果 $\eta < 1$，那么重新排列得到

$$\mathcal{R}_T \leq \frac{1}{1-\eta}\left(\frac{\ln N}{\eta} + \eta L_T(i^*)\right).$$

因此，如果我们暂时假设我们提前知道 $L_T(i^*)$ 的值并且能够设置 $\eta = \min\left\{\frac{1}{2}, \sqrt{\frac{\ln N}{L_T(i^*)}}\right\}$，那么我们得到

$$\mathcal{R}_T \leq 2\left(\max\left\{2\ln N, \frac{\sqrt{(\ln N)/L_T(i^*)}}{\sqrt{(\ln N)/L_T(i^*)}}\right\} + \sqrt{\frac{\ln N}{L_T(i^*)}L_T(i^*)}\right) = \mathcal{O}\left(\sqrt{L_T(i^*)\ln N} + \ln N\right).$$

上面的最终界限就是所谓的"小损失"界，它本质上用最佳专家的损失 $L_T(i^*)$ 替代了极小极大界中的 $T$ 依赖性。注意，$L_T(i^*)$ 被 $T$ 界定，因此"小损失"界不会比极小极大界差。更重要的是，当最佳专家确实遭受很小的损失时，它可以比 $T$ 小得多。特别是，如果最佳专家没有犯任何错误并且所有损失都是 $\{0, 1\}$ 值，那么 $L_T(i^*) = 0$，此时"小损失"界仅为 $\mathcal{O}(\ln N)$，与 $T$ 无关。这是我们追求的自适应界的一个典型例子。

当然，上述推导中的一个明显问题是学习率必须根据未知量 $L_T(i^*)$ 来设置。事实上，在非预先确定环境中，这个问题变得更加严重，因为 $L_T(i^*)$ 可能依赖于算法的行为，从而依赖于 $\eta$，使得 $\eta$ 的定义变成循环的。

幸运的是，有许多不同的方法来解决这个问题，我们在这里探讨其中之一。这个想法是使用更自适应和随时间变化的学习率计划。具体来说，算法预测 $p_t(i) \propto \exp(-\eta_tL_{t-1}(i))$，其中

$$\eta_t = \sqrt{\frac{\ln N}{\widetilde{L}_{t-1} + 1}}.$$

注意，$\widetilde{L}_{t-1} = \sum_{\tau=1}^{t-1} \langle p_\tau, \ell_\tau \rangle$ 是算法到第 $t-1$ 轮的累积损失，因此在第 $t$ 轮开始时是可用的。这有时被称为"自信"学习率，因为算法相信其损失接近最佳专家的损失，因此将其用作最佳专家损失的代理来调整学习率。接下来我们证明这个算法确实提供了一个"小损失"界。

**定理1**：具有自适应学习率计划(1)的Hedge算法确保

$$\mathcal{R}_T \leq 3\sqrt{(L_T(i^*) + 1)\ln N} + 9\ln N.$$

**证明**：令 $\Phi_t(\eta) = \frac{1}{\eta}\ln\left(\frac{1}{N}\sum_{i=1}^N \exp(-\eta L_t(i))\right)$。在第2讲中我们已经证明

$$\Phi_t(\eta_t) - \Phi_{t-1}(\eta_t) \leq -\langle p_t, \ell_t \rangle + \eta_t \sum_{i=1}^N p_t(i)\ell_t^2(i).$$

对 $t$ 求和并重新排列得到

$$\begin{aligned}
\widetilde{L}_T &\leq \Phi_0(\eta_1) - \Phi_T(\eta_T) + \sum_{t=1}^T \eta_t \sum_{i=1}^N p_t(i)\ell_t^2(i) + \sum_{t=1}^{T-1} (\Phi_t(\eta_{t+1}) - \Phi_t(\eta_t)) \\
&\leq \frac{\ln N}{\eta_T} - \frac{1}{\eta_T}\ln(\exp(-\eta_T L_T(i^*))) + \sum_{t=1}^T \eta_t \langle p_t, \ell_t \rangle + \sum_{t=1}^{T-1} (\Phi_t(\eta_{t+1}) - \Phi_t(\eta_t)) \\
&= \sqrt{(\widetilde{L}_{T-1} + 1)\ln N} + L_T(i^*) + \sum_{t=1}^T \eta_t \langle p_t, \ell_t \rangle + \sum_{t=1}^{T-1} (\Phi_t(\eta_{t+1}) - \Phi_t(\eta_t)).
\end{aligned}$$

要界定项 $\sum_{t=1}^T \eta_t \langle p_t, \ell_t \rangle$，注意到

$$\begin{aligned}
\sum_{t=1}^T \frac{\langle p_t, \ell_t \rangle}{\sqrt{\widetilde{L}_{t-1} + 1}} &= \sum_{t=1}^T \frac{\widetilde{L}_t - \widetilde{L}_{t-1}}{\sqrt{\widetilde{L}_{t-1} + 1}} \\
&= \sum_{t=1}^T \frac{\widetilde{L}_t - \widetilde{L}_{t-1}}{\sqrt{\widetilde{L}_t + 1}} + \sum_{t=1}^T (\widetilde{L}_t - \widetilde{L}_{t-1})\left(\frac{1}{\sqrt{\widetilde{L}_{t-1} + 1}} - \frac{1}{\sqrt{\widetilde{L}_t + 1}}\right) \\
&\leq \sum_{t=1}^T \frac{\widetilde{L}_t - \widetilde{L}_{t-1}}{\sqrt{\widetilde{L}_t + 1}} + \sum_{t=1}^T \left(\frac{1}{\sqrt{\widetilde{L}_{t-1} + 1}} - \frac{1}{\sqrt{\widetilde{L}_t + 1}}\right) \quad (\widetilde{L}_t - \widetilde{L}_{t-1} \leq 1) \\
&\leq 1 + \sum_{t=1}^T \frac{\widetilde{L}_t - \widetilde{L}_{t-1}}{\sqrt{\widetilde{L}_t + 1}} \\
&\leq 1 + \int_{\widetilde{L}_0}^{\widetilde{L}_T} \frac{dx}{\sqrt{x + 1}} \\
&\leq 2\sqrt{\widetilde{L}_T + 1},
\end{aligned}$$

因此 $\sum_{t=1}^T \eta_t \langle p_t, \ell_t \rangle \leq 2\sqrt{(\widetilde{L}_T + 1)\ln N}$。

要界定 $\Phi_t(\eta_{t+1}) - \Phi_t(\eta_t)$，我们证明 $\Phi_t(\eta)$ 关于 $\eta$ 是递增的，因此 $\Phi_t(\eta_{t+1}) \leq \Phi_t(\eta_t)$。
只需要证明导数非负即可。事实上，直接计算表明，对于

$$p_{t+1}^\eta(i) \propto \exp(-\eta L_t(i)),$$

有

$$\begin{aligned}
\eta^2\Phi'_t(\eta) &= \eta^2\left(-\frac{1}{\eta^2}\ln\left(\frac{1}{N}\sum_{i=1}^N \exp(-\eta L_t(i))\right) - \frac{1}{\eta}\frac{\sum_{i=1}^N L_t(i)\exp(-\eta L_t(i))}{\sum_{i=1}^N \exp(-\eta L_t(i))}\right) \\
&= \ln N - \sum_{i=1}^N p_{t+1}^\eta(i)\left(\ln\left(\sum_{j=1}^N \exp(-\eta L_t(j))\right) + \eta L_t(i)\right) \\
&= \ln N - \sum_{i=1}^N p_{t+1}^\eta(i)\ln\left(\frac{\sum_{j=1}^N \exp(-\eta L_t(j))}{\exp(-\eta L_t(i))}\right) \\
&= \ln N - \sum_{i=1}^N p_{t+1}^\eta(i)\ln\frac{1}{p_{t+1}^\eta(i)} \geq 0,
\end{aligned}$$

其中最后一步是因为熵在均匀分布时达到最大值。总结一下，我们已经证明

$$\mathcal{R}_T = \widetilde{L}_T - L_T(i^*) \leq 3\sqrt{(\widetilde{L}_T + 1)\ln N}.$$

求解 $\sqrt{\widetilde{L}_T + 1}$ 得到

$$\sqrt{\widetilde{L}_T + 1} \leq \frac{3}{2}\sqrt{\ln N} + \sqrt{L_T(i^*) + 1} + \frac{9}{4}\ln N.$$

最后对两边平方并使用 $\sqrt{a + b} \leq \sqrt{a} + \sqrt{b}$ 得到

$$\widetilde{L}_T \leq 9\ln N + L_T(i^*) + 3\sqrt{(L_T(i^*) + 1)\ln N},$$

这就完成了证明。

□

除了享有更好的理论遗憾界外，这个算法在直觉上也更合理，因为它根据观察到的数据自适应地调整学习率。一般来说，学习率调整是机器学习中的一个重要话题，可能具有重要的实践意义。

### .2 Quantile Bounds

"小损失"界改进了极小极大遗憾界中对 $T$ 的依赖性，将其替换为 $L_T(i^*)$。那么，是否可能改进极小极大界中的另一项 $\ln N$ 呢？为了回答这个问题，我们再次考虑具有固定学习率的Hedge算法（为简单起见），并回顾我们在第2讲中证明的结果：

$$\widetilde{L}_T \leq \frac{\ln N}{\eta} - \frac{1}{\eta}\ln\left(\sum_{i=1}^N \exp(-\eta L_T(i))\right) + T\eta.$$

不失一般性，假设 $L_T(1) \leq \cdots \leq L_T(N)$，因此专家 $i$ 是第 $i$ 个最佳专家。之前我们通过下界 $\sum_{i=1}^N \exp(-\eta L_T(i)) \geq \max_i \exp(-\eta L_T(i)) = \exp(-\eta L_T(1))$ 得到最终的遗憾界。然而，一般来说，对于每个 $i$，我们有

$$\sum_{j=1}^N \exp(-\eta L_T(j)) \geq \sum_{j=1}^i \exp(-\eta L_T(j)) \geq i\exp(-\eta L_T(i)),$$

因此，我们对第 $i$ 个最佳专家有以下遗憾界：

$$\widetilde{L}_T - L_T(i) \leq \frac{\ln\left(\frac{N}{i}\right)}{\eta} + T\eta. \tag{2}$$

当 $\eta$ 最优地调整为 $\sqrt{\ln\left(\frac{N}{i}\right)/T}$ 时，界变为 $2\sqrt{T\ln\left(\frac{N}{i}\right)}$。这被称为**分位数界**，它表明算法对所有专家中除了 $i/N$ 比例的专家外，最多遭受这么多的遗憾。

当然，在一天结束时，我们真正关心的是算法的损失。假设我们暂时拥有 $\widetilde{L}_T$ 的知识，那么我们可以选择最优的 $\eta$ 来实现

$$\widetilde{L}_T \leq \min_{i\in[N]}\left(L_T(i) + 2\sqrt{T\ln\left(\frac{N}{i}\right)}\right), \tag{3}$$

这比 $L_T(1) + 2\sqrt{T\ln N}$ 是一个严格更好的界。为了理解这种改进，考虑当 $N$ 非常大但有许多相似的专家的情况，例如，前1%的专家都有相同的累积损失。那么界(3)最多为

$$L_T(1\% \times N) + 2\sqrt{T\ln\left(\frac{N}{1\%\times N}\right)} = L_T(1) + 2\sqrt{T\ln(100)},$$

这与 $N$ 无关。

正如之前讨论中的一个明显问题，界(3)的推导中学习率 $\eta$ 需要基于未知知识进行调整。为了解决这个问题，我们探索一种完全不同的方法。这个想法是让不同的Hedge实例以不同的学习率运行，并有一个"主"Hedge来组合这些"元专家"的预测。为此，我们用Hedge($\eta$)表示以学习率 $\eta$ 运行的Hedge实例。算法如下所示。



根据等式(2)，对于每个Hedge($\eta_j$)和每个专家 $i$，我们有

$$\sum_{t=1}^T \langle p_t^j, \ell_t \rangle - L_T(i) \leq \frac{\ln\left(\frac{N}{i}\right)}{\eta_j} + T\eta_j.$$

另一方面，对于主Hedge，我们对每个元专家 $j$ 有，

$$\sum_{t=1}^T \sum_{j=1}^M q_t(j)\langle p_t^j, \ell_t \rangle - C_T(j) \leq \frac{\ln M}{\eta} + T\eta.$$

注意，根据构造，我们有 $\sum_{j=1}^M q_t(j) \langle p_t^j, \ell_t \rangle = \langle p_t, \ell_t \rangle$ 和 $C_T(j) = \sum_{t=1}^T \langle p_t^j, \ell_t \rangle$。
因此，将上述两个不等式相加得到

$$\sum_{t=1}^T \langle p_t, \ell_t \rangle - L_T(i) \leq \frac{\ln\left(\frac{N}{i}\right)}{\eta_j} + T\eta_j + \frac{\ln M}{\eta} + T\eta = \frac{\ln\left(\frac{N}{i}\right)}{\eta_j} + T\eta_j + 2\sqrt{T\ln M},$$

其中最后一步是通过选择最优的 $\eta = \sqrt{\ln M/T}$ 得到的。注意，上述结果对所有 $j$ 和所有 $i$ 都成立。因此，假设我们有(a)对于每个 $i$，存在一个 $\eta_j$ 使得 $\frac{1}{\eta_j}\ln\left(\frac{N}{i}\right) + T\eta_j = \mathcal{O}\left(\sqrt{T\ln\left(\frac{N}{i}\right)}\right)$，以及(b) $M$ 远小于 $N$，那么我们就得到了界(3)。

设置 $M = N$ 和 $\eta_j = \sqrt{\ln\left(\frac{N}{j}\right)/T}$ 显然会满足(a)，但不满足(b)。幸运的是，事实证明只需要创建 $M \approx \ln N$ 个元专家就能满足(a)。具体来说，令

$$\eta_j = \frac{1}{2^{j-1}}\sqrt{\frac{\ln N}{T}} \quad \text{和} \quad M = \left\lceil\log_2\sqrt{\frac{\ln N}{\ln\left(\frac{N}{N-1}\right)}}\right\rceil + 1.$$

现在显然对于每个 $i \neq N$，存在一个 $j$ 使得 $\eta_j \leq \sqrt{\ln\left(\frac{N}{i}\right)/T} \leq 2\eta_j$，因此

$$
\begin{aligned}
\sum_{t=1}^T \langle p_t, \ell_t \rangle - L_T(i) &\leq \frac{\ln\left(\frac{N}{i}\right)}{\eta_j} + T\eta_j + 2\sqrt{T\ln M} \\
&\leq \frac{\ln\left(\frac{N}{i}\right)}{\frac{1}{2}\sqrt{\ln\left(\frac{N}{i}\right)/T}} + T \cdot 2\sqrt{\ln\left(\frac{N}{i}\right)/T} + 2\sqrt{T\ln M} \\
&= 3\sqrt{T\ln\left(\frac{N}{i}\right)} + 2\sqrt{T\ln M}
\end{aligned}
$$

剩下的是证明 $M$ 足够小。实际上，由于 $\ln(1 + x) \geq x/2, \forall x \leq 1$，我们有

$$\ln\left(\frac{N}{N-1}\right) = \ln\left(1 + \frac{1}{N-1}\right) \geq \frac{1}{2(N-1)},$$

因此 $M = \mathcal{O}(\ln(N\ln N))$。所以至少在 $N/i$ 大于 $\mathcal{O}(\ln(N\ln N))$ 的情况下，$\sqrt{T\ln M}$ 项被 $\sqrt{T\ln\left(\frac{N}{i}\right)}$ 在遗憾界中所支配。我们在以下定理中总结这一结果。

**定理2**：算法1，其中 $\eta = \sqrt{\frac{\ln N}{T}}$，$\eta_j = \frac{1}{2^{j-1}}\sqrt{\frac{\ln N}{T}}$ 和 $M = \left\lceil\log_2\sqrt{\frac{\ln N}{\ln\left(\frac{N}{N-1}\right)}}\right\rceil + 1$，确保

$$\widetilde{L}_T \leq \min_{i\neq N}\left(L_T(i) + 3\sqrt{T\ln\left(\frac{N}{i}\right)}\right) + \mathcal{O}(\sqrt{T\ln(\ln(N\ln N))}).$$

这种使用Hedge组合算法的思想对许多其他问题都很有用。它通常是一种快速简便的方法，用于在理论上验证某些遗憾界是否可能。然而，由此产生的算法可能不那么优雅和实用。在下一讲中，我们将研究一种不同的算法，它不仅保证分位数界（实际上比这里证明的更好），而且还具有几个更有用的性质。
 