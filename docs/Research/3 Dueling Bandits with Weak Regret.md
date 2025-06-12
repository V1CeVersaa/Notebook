# Dueling Bandits with Weak Regret

!!! Abstract

    <img class="center-picture" src="../assets_3/abstract.webp" alt="abstract" width=500 />

    - Tag: Dueling Bandits, Weak Regret, Winner Stays.
    - Proceedings of the 34 th International Conference on Machine Learning, Sydney, Australia, PMLR 70, 2017.
    - [Origin Paper Link](https://proceedings.mlr.press/v70/chen17c/chen17c.pdf)
    - 文中图片均来自论文。


## 0 Most Important Things

## 1 Introduction

背景故事：考虑在个性化推荐内容中的老虎机学习问题，其中反馈是通过隐式的成对比较获得的。我们向用户提供成对的项目，记录关于哪个提供的项目更受偏好的隐性反馈，旨在快速了解用户对项目的偏好，同时确保我们未能提供高质量项目的时间比例很小。

形式化看，我们可能提供给用户的项目被称为摇臂/Arms，通过一系列决斗/Duels 来了解这些摇臂，在每次决斗中，我们拉动两个摇臂，并从用户那里接收带噪声的反馈，告知哪个摇臂更受偏好。当一个摇臂在决斗中被偏好时，我们称该摇臂赢得了决斗。

弱后悔对应于只要将孔多塞赢家选为决斗中的任何一个臂即可避免后悔，比如 Grubhub 和 UberEATS 这样的食品配送服务提供的应用内餐馆推荐，只有当用户最偏好的餐馆没有被推荐的时候，用户才会遭受后悔。例子还包括在 Twitch 等平台上推荐在线主播等。

## 2 Related Work

迄今为止的大多数工作都关注强遗憾/Strong Regret，我们已经知道，对于任何算法，到时间 $T$ 为止的最坏情况累积期望强遗憾是 $\Omega(N\log(T))$。在 Finite-Horizon 设定和孔多塞赢家假设下，已经提出了一些能够达到此下界的算法：Interleaved Filter (IF) 和 Beat the Mean (BTM)。Relative Upper Confidence Bound (RUCB) 也在 Horizonless 设定下达到了此下界。Relative Minimum Empirical Divergence (RMED) 是第一个其遗憾界与此下界相匹配的算法。Copeland Confidence Bound (CCB) 和 Scalable Copeland Bandits (SCB) 是两个在不存在孔多塞赢家的情况下达到最优遗憾界的算法。

利用强遗憾严格大于弱遗憾的事实，可以设计出弱遗憾界为 $O(N\log(T))$ 的算法。

使用成对比较的主动学习/Active Learning 也与我们的工作密切相关。Query Selection Algorithm (QSA) 使用期望 $d\log(N)$ 次操作来排序 $N$ 个臂，其中 $d$ 是臂嵌入空间的维度。使用自适应成对比较可以进行 top-k 元素选择，有一种通用的 Racing 算法，专注于最小化样本复杂度。

## 3 Problem Formulation

对于 $N$ 个摇臂，在每个时间点 $t=1, 2, \dots$，系统在两个摇臂之间进行一次决斗/Duel。用户随后提供二元反馈，决定哪个摇臂赢得决斗。这个二元反馈是随机的，并且在给定展示的臂对的条件下，与所有过去的交互是条件独立的。我们令 $p_{i,j}$ 表示当展示臂 $i$ 和 $j$ 时，用户给出偏好臂 $i$ 反馈的概率。如果用户偏好臂 $i$ 胜过臂 $j$，我们假设 $p_{i,j} > 0.5$。我们也假设对称性：$p_{i,j} = 1 - p_{j,i}$。

我们假设臂 1 是一个**孔多塞赢家/Condorcet Winner**，即对于 $i=2, \dots, N$，有 $p_{1,i} > 0.5$。在一些结果中，我们还考虑臂具有**全序/Total Order** 的设定，即臂可以被排序，使得对于所有 $i < j$，都有 $p_{i,j} > 0.5$。全序假设蕴含了传递性。

我们令 $p = \min\limits_{p_{i,j}>0.5} p_{i,j} > 0.5$ 为用户选择更优臂的概率的一个下界。

我们考虑二元形式的弱遗憾和强遗憾。在某时间点产生的单周期弱遗憾定义为：如果我们选择的两个臂中**没有**包含最佳臂，则 $r(t) = 1$，否则 $r(t) = 0$。单周期强遗憾定义为：如果我们**没有**两次都选择最佳臂，则 $r(t) = 1$，否则 $r(t) = 0$。后面也会定义 Utility-Based 的弱遗憾和强遗憾。注意我们使用相同的符号 $r(t)$ 来表示强遗憾和弱遗憾，并依赖上下文来区分这两种情况。在这两种情况下，我们将直到时间 $T$ 的**累积遗憾/Cumulative Regret** 定义为 $R(T) = \sum_{t=1}^T r(t)$。我们通过算法的期望累积遗憾来衡量其性能。

## 4 Winner Stays

### 4.1 Winner Stays with Weak Regret

定义 $q_{i,j}(t)$ 为在时间 $t$ 以及之前决斗中，臂 $i$ 击败臂 $j$ 的**次数**，定义 $C(t,i) = \sum_{j \neq i} (q_{i,j}(t) - q_{j,i}(t))$。$C(t,i)$ 是截至时间 $t$ 臂 $i$ 赢得的决斗次数与输掉的决斗次数之差，也就是所谓的净胜场数。

<img class="center-picture" src="../assets_3/alg-1.webp" alt="4.1" width=550 />

选择策略为：在每一个时间点都选择当前 $C(t-1, \cdot)$ 值最高的两个臂 $i_t$ 和 $j_t$ 进行决斗。另一个关键点在于打破平局的规则：在选择参与决斗的臂的时候，都优先选择上一轮参与决斗的臂（只要其是得分最高的摇臂之一），并且算法倾向于在接下来的一小段时间点都选择这两个摇臂（只要它们仍然是得分最高的摇臂之一）。

WS-W 的选择过程可以被组织成迭代/Iteration 和轮/Round，每一个迭代由一系列对同一对摇臂的选择组成，而每一轮由一系列迭代组成，其中在某一次迭代中失败的摇臂不会在后续的迭代中被选择，直到下一轮开始。

Winner Stays 的特性使得 WS-W 的过程由一系列的轮组成，每一轮都是 $N-1$ 次迭代的序列，并且在一个迭代中失败的臂直到下一轮才会被重新访问。比如在第一轮结束之后，最终的胜者 $Z(1)$ 将会有 $C(t, Z(1)) = N-1$，而所有其他臂 $j \neq Z(1)$ 则有 $C(t, j) = -1$。

<img class="center-picture" src="../assets_3/fig-1.webp" alt="4.1" width=650 />

### 4.2 Analysis of WS-W

对于第 $\ell$ 轮的开始，记其时间点为 $t_{\ell}$，前一轮的胜者为 $Z(\ell-1)$，且其净胜点为 $C(t_{\ell}-1, Z(\ell-1)) = (N - 1)(\ell - 1)$，并且对于所有 $j \neq Z(\ell-1)$，有 $C(t_{\ell}-1, j) = -\ell + 1$。同时定义在第 $\ell$ 轮的第 $k$ 次迭代开始的时间点，也就是在第 $\ell$ 轮中第一次拉动第 $k$ 对不同臂的时间点，记为 $t_{\ell,k}$，并且定义 $T_{\ell,k}$ 为这次迭代中连续拉动这对臂的次数。

定义术语：在一对臂 $i$ 和 $j$ 的决斗中，如果 $p_{i,j} > 0.5$，则称 $i$ 为较好臂，$j$ 为较差臂。我们称在第 $\ell$ 轮的第 $k$ 次迭代开始时，得分 $C(t_{\ell,k}-1, i) > 0$ 的臂 $i$ 为擂主/Incumbent，另一个臂 $j$ 为挑战者/Challenger。

**Lemma 1**：第 $\ell$ 轮的第 $k$ 次迭代的长度 $T_{\ell,k}$ 的期望上界如下界定：如果擂主比挑战者差，则上界为 $\frac{N(l-1)+k}{2p-1}$，如果擂主比挑战者好，则上界为 $\frac{1}{2p-1}$。

**Lemma 2**：在全序关系的假设下，给定到时间点 $t_{\ell, k}$ 为止的历史信息，该时间点未来的迭代中，擂主比挑战者差的迭代的数量的上界为 $\frac{2p^2}{(2p-1)^3}\left(\log(N) + 1\right)$。

**Lemma 3**：令 $L$ 为最小的 $\ell$，使得在此之后没有擂主比挑战者更差的轮，则 $P(L \ge \ell) \le ((1 - p) / p)^{\ell}$。

由于 $p > 0.5$，所以 $\frac{1-p}{p} < 1$，因此该引理其实表明了随着对决轮数的增加，擂主比挑战者更差的情况会越来越少。

定义如下示性函数：

- $B(\ell, k)$ 为 1 当且仅当在第 $\ell$ 轮的第 $k$ 次迭代中，擂主比挑战者好，$\overline{B}(\ell, k) = 1 - B(\ell, k)$；
- $D(\ell)$ 为 1 当且仅当第一个摇臂（最优的摇臂）是第 $\ell$ 轮第 1 次迭代的擂主，$\overline{D}(\ell) = 1 - D(\ell)$；
- $V(\ell, k)$ 为 1 当且仅当 $D(\ell) = 1$ 且最优摇臂在第 $\ell$ 轮的第 $k$ 次迭代之前输掉了（在第 1 轮到第 $k-1$ 次迭代中输掉了）。

在第 $\ell$ 轮的第 $k$ 次迭代中，只有 $\overline{D}(l) = 1$ 或者对某个 $k^{\prime} < k$ 有 $V(l,k^{\prime}) = 1$ 时，才会产生弱遗憾。

**Lemma 4**：在全序关系及孔多塞赢家设定下：

$$\begin{aligned}
    \mathbb{E}[\overline{D}(\ell) B(\ell, k) T_{\ell, k}] &\leq \frac{1}{2p - 1}\left(\frac{1 - p}{p}\right)^{\ell - 1} \\ 
    \mathbb{E}[V(\ell, k) B(\ell, k) T_{\ell, k}] &\leq \frac{1}{2p - 1}\left(\frac{1 - p}{p}\right)^{\ell}
\end{aligned}$$

在将所有的迭代分为擂主优于挑战者和擂主劣于挑战者这两种情况下，这恰好就是擂主优于挑战者且产生弱遗憾的两种情况（如果擂主优于挑战者，那么所有产生弱遗憾的情况都满足上面两个情况之一，考虑某一轮使得 $\overline{D}(l) = 1$ 且 $B(l,k) = 1$ 那么或许在某一次迭代中，最优臂成为了擂主或者挑战者，这样弱遗憾就消除了，但是我们将其使用仍然产生弱遗憾 bound 住）。

**Lemma 5**：在全序关系设置下：

- $\mathbb{E}[\sum_{k=1}^{N-1} \overline{D}(\ell) \overline{B}(\ell, k) T_{\ell, k}]$ 上界为 $((1 - p) / p)^{\ell - 1} \frac{2 N \ell p^2}{(2p-1)^4} \left(\log(N) + 1\right)$；
- $\mathbb{E}[\sum_{k=1}^{N-1} V(\ell, k) \overline{B}(\ell, k) T_{\ell, k}]$ 上界为 $((1 - p) / p)^{\ell} \frac{2N \ell p^2}{(2p-1)^4} (\log(N) + 1)$。

**Theorem 1**：在全序关系设置下，WS-W 的累积期望弱遗憾上界为 $\left[\frac{2p^{3}}{(2p-1)^{6}}N(\log(N)+1)+\frac{N}{(2p-1)^{2}}\right]$。

???- Info "Proof Sketch"

**Theorem 2**：在孔多塞赢家设置下，WS-W 的累积期望弱遗憾上界为 $\left[\frac{N}{(2p-1)^{2}}+\frac{pN^{2}}{(2p-1)^{3}}\right]$。

???- Info "Proof Sketch"


### 4.3 Winner Stays with Strong Regret

WS-S 将 WS-W 的算法作为子程序，并且使用一个机制来保证强遗憾在一定范围内。具体而言，WS-S 的每一轮都分为 Exploration 和 Exploitation 两个阶段，在 Exploration 阶段，WS-S 会使用 WS-W 的算法来选择臂，而在 Exploitation 阶段，WS-S 会连续摇动选择的最佳摇臂 $\beta$ 的指数次，调整 $\beta$ 的大小平衡了这两个阶段的长度。

<img class="center-picture" src="../assets_3/alg-2.webp" alt="4.3" width=550 />

**Theorem 3**：在全序关系设置下，WS-S 的累积期望强遗憾上界为 $\left[\frac{2p^{3}}{(2p-1)^{6}}N(\log(N)+1)+\frac{N \log_{\beta}(T (\beta - 1))}{2p-1}\right]$，其中 $1 < \beta \leq \frac{p}{1-p}$。

???- Info "Proof Sketch"

<!-- 好的，以下是 Theorem 1 和 Theorem 3 的内容及其证明的原文和中文翻译：

---

**Theorem 1 (WS-W 弱遗憾 - 全序)**

**原文内容 (Statement):**
> [source: 129] Theorem 1. The expected cumulative weak regret of WS-W under the total order assumption is bounded by $[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N}{(2p-1)^{2}}]$.

**中文翻译 (内容):**
> **定理 1.** 在**全序关系 (total order)** 假设下，WS-W 算法的**累积期望弱遗憾 (expected cumulative weak regret)** 由 $[\frac{2p^{3}}{(2p-1)^{6}}N(\log(N)+1)+\frac{N}{(2p-1)^{2}}]$ 界定。

---

**原文证明 (Proof):**
> [source: 130] Proof. Iterations can be divided into two types: those in which the incumbent is better than the challenger, and those where the incumbent is worse. [source: 131] We first bound expected total weak regret incurred in the first type of iteration, and then below bound that incurred in the second type.
> [source: 132] In this first bound, observe that we incur weak regret during round l if $\overline{D}(l)=1$ or if $D(l)=1$ but arm 1 loses to some other arm during this round. [source: 133] Under the second scenario, we do not incur any regret until arm 1 loses to another arm. [source: 134] Thus, the expected weak regret incurred during iterations with a better incumbent is bounded by
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}\overline{D}(l)+\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}V(l,k)]$
>
> The first part of this summation can be bounded by the first inequality in Lemma 4 to obtain
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}\overline{D}(l)]$
> $\le\sum_{l=1}^{\infty}(\frac{1-p}{p})^{l-1}\frac{N}{2p-1}=\frac{pN}{(2p-1)^{2}}.$
>
> The second part of this summation can be bounded by the second inequality in Lemma 4 to obtain
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}V(l,k)]$
> $\le\sum_{l=1}^{\infty}\frac{N}{2p-1}(\frac{1-p}{p})^{l}=\frac{N(1-p)}{(2p-1)^{2}}.$
>
> Thus, the cumulative expected weak regret incurred during iterations with a better incumbent is bounded by $\frac{N}{(2p-1)^{2}}$. [source: 135]
> Now we bound the expected weak regret incurred during iterations where the incumbent is worse than the challenger. [source: 136] This is bounded by
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}\overline{D}(l)+\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}V(l,k)].$
>
> The first term in the summation can be bounded by the first inequality of Lemma 5 to obtain
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}\overline{D}(l)]$
> $\le\sum_{l=1}^{\infty}\frac{2Nlp(1-p)}{(2p-1)^{4}}(log(N)+1)(\frac{1-p}{p})^{l-1}$
> $=\frac{2Np^{4}}{(2p-1)^{6}}(log(N)+1)$
>
> The second term in the summation can be bounded by the [second] inequality of Lemma 5 to obtain [Note: The text says "first inequality" again, likely a typo, should be the second inequality of Lemma 5]
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}V(l,k)]$
> $\le\sum_{l=1}^{\infty}\frac{2Nlp^{2}}{(2p-1)^{4}}(log(N)+1)(\frac{1-p}{p})^{l}$
> $=\frac{2p^{3}(1-p)}{(2p-1)^{6}}N(log(N)+1).$
>
> Thus, the cumulative expected weak regret incurred during iterations with a worse incumbent is bounded by $\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)$.
> [source: 137] Summing these two bounds, the cumulative expected weak regret is bounded by $\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N}{(2p-1)^{2}}\rfloor$

**中文翻译 (证明):**
> **证明.** 迭代 (Iterations) 可以分为两种类型：在位者 (incumbent) 比挑战者 (challenger) 好的迭代，以及在位者比挑战者差的迭代。我们首先界定第一种类型迭代中产生的总期望弱遗憾，然后在下面界定第二种类型迭代中产生的遗憾。
>
> 对于第一种类型的界限，观察到我们在第 $l$ 轮产生弱遗憾，当且仅当 $\overline{D}(l)=1$（最优臂不是初始在位者），或者 $D(l)=1$ 但最优臂 (臂 1) 在这一轮中输给了某个其他臂。在后一种情况下，直到臂 1 输给另一个臂之前，我们不会产生任何遗憾。因此，在位者较好的迭代期间产生的期望弱遗憾由以下公式界定：
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}\overline{D}(l)+\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}V(l,k)]$
>
> 这个求和的第一部分可以通过 **Lemma 4 的第一个不等式** 来界定，得到：
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}\overline{D}(l)]$
> $\le\sum_{l=1}^{\infty}(\frac{1-p}{p})^{l-1}\frac{N}{2p-1}=\frac{pN}{(2p-1)^{2}}.$
>
> 这个求和的第二部分可以通过 **Lemma 4 的第二个不等式** 来界定，得到：
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}B(l,k)T_{l,k}V(l,k)]$
> $\le\sum_{l=1}^{\infty}\frac{N}{2p-1}(\frac{1-p}{p})^{l}=\frac{N(1-p)}{(2p-1)^{2}}.$
>
> 因此，在位者较好的迭代期间产生的累积期望弱遗憾由 $\frac{N}{(2p-1)^{2}}$ 界定。
>
> 现在我们界定在位者比挑战者差的迭代期间产生的期望弱遗憾。这由以下公式界定：
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}\overline{D}(l)+\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}V(l,k)].$
>
> 求和中的第一项可以通过 **Lemma 5 的第一个不等式** 来界定，得到：
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}\overline{D}(l)]$
> $\le\sum_{l=1}^{\infty}\frac{2Nlp(1-p)}{(2p-1)^{4}}(log(N)+1)(\frac{1-p}{p})^{l-1}$
> $=\frac{2Np^{4}}{(2p-1)^{6}}(log(N)+1)$
>
> 求和中的第二项可以通过 **Lemma 5 的第二个不等式** 来界定（原文此处误写为第一个不等式），得到：
>
> $\mathbb{E}[\sum_{l=1}^{\infty}\sum_{k=1}^{N-1}\overline{B}(l,k)T_{l,k}V(l,k)]$
> $\le\sum_{l=1}^{\infty}\frac{2Nlp^{2}}{(2p-1)^{4}}(log(N)+1)(\frac{1-p}{p})^{l}$
> $=\frac{2p^{3}(1-p)}{(2p-1)^{6}}N(log(N)+1).$
>
> 因此，在位者较差的迭代期间产生的累积期望弱遗憾由 $\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)$ 界定。
>
> 将这两个界限相加，累积期望弱遗憾由 $\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N}{(2p-1)^{2}}$ 界定。

---

**Theorem 3 (WS-S 强遗憾 - 全序)**

**原文内容 (Statement):**
> [source: 149] Theorem 3. If there is a total order among arms, then for $1<\beta<\frac{p}{1-p},$ the expected cumulative strong regret of WS-S is bounded by $[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N~log_{\beta}(T(\beta-1))}{2p-1}]$.

**中文翻译 (内容):**
> **定理 3.** 如果臂之间存在**全序关系 (total order)**，那么对于 $1<\beta<\frac{p}{1-p}$，WS-S 算法的**累积期望强遗憾 (expected cumulative strong regret)** 由 $[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N~log_{\beta}(T(\beta-1))}{2p-1}]$ 界定。

---

**原文证明 (Proof):**
> [source: 150] Proof. Suppose at time T, we are in round l. [source: 151] Then $\beta+\cdot\cdot\cdot+\beta^{l-1} \le T$. Solving for l, we obtain $l\le log_{\beta}(T(\beta-1)+1)$. [Slight correction based on geometric series sum: $\sum_{i=1}^{l-1} \beta^i = \frac{\beta(\beta^{l-1}-1)}{\beta-1} \le T$, implies $\beta^l \approx T(\beta-1)$ asymptotically, so $l \approx \log_{\beta}(T(\beta-1))$ is a reasonable approximation for large T].
> [source: 152] We bound the expected strong regret up to time T. The expected regret can be divided in two parts: the regret occuring during the exploration phase; [source: 153] and the regret occuring during the exploitation phase.
>
> First we focus on regret incurred during exploration. [source: 154] We never pull the same arm twice during this phase, and so regret is incurred in each time period. [source: 155] To bound regret incurred during exploration, we bound the length of time spent in this phase. [source: 156] The length of time spent in exploration up to the end of round l with a better incumbent is bounded by $\frac{(N-1)l}{2p-1}.$ The length of time spent with a worse incumbent, based on the proof of Theorem 1, is bounded by $\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)$. [source: 157]
>
> Now we focus on regret incurred during exploitation. The probability we have identified the wrong arm at the end of the $i^{th}$ round is less than $(\frac{1-p}{p})^{i}$ . [source: 158] Thus, the expected regret incurred during this phase up until the end of the $l^{th}$ round is bounded by $\sum_{i=1}^{l}(\frac{1-p}{p})^{i}\times\beta^{i}$. [This sum requires $\beta < p/(1-p)$ to converge nicely, the proof simplifies this bound to just $l$ which is a loose bound, but sufficient for the final O-notation].
>
> Overall, this implies that the strong expected regret up to time T (recall that T is in round l) is bounded by
>
> $[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+l+\frac{(N-1)l}{2p-1}]$ [The $l$ term comes from the simplified bound on exploitation regret]
> $\le[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N~log_{\beta}(T(\beta-1))}{2p-1}]$ [Substituting $l \approx \log_{\beta}(T(\beta-1))$ and combining terms, $(N-1)/(2p-1) + 1 \approx N/(2p-1)$].
> [source: 159] Thus, the expected strong regret up to time T is $O(N~log(T)+N~log(N))$. [source: 160] Π

**中文翻译 (证明):**
> **证明.** 假设在时间 $T$ 时，算法处于第 $l$ 轮。那么之前所有利用阶段的总时长 $\sum_{i=1}^{l-1} \beta^i \le T$。解出 $l$，我们得到 $l \le \log_{\beta}(T(\beta-1)+1)$ [注：原文此处关于 $l$ 的解算略有简化，但对于 $T$ 很大时的渐近分析是足够的，得到 $l$ 大约是 $\log_{\beta}(T(\beta-1))$]。
> 我们来界定截至时间 $T$ 的期望强遗憾。期望遗憾可以分为两部分：**探索阶段 (exploration phase)** 产生的遗憾；以及 **利用阶段 (exploitation phase)** 产生的遗憾。
>
> 首先关注探索阶段产生的遗憾。在这个阶段，我们从不选择同一个臂两次，因此每个时间步都会产生强遗憾（遗憾值为 1）。为了界定探索阶段产生的遗憾，我们界定在这个阶段花费的时间长度。到第 $l$ 轮结束时，在位者较好的探索迭代总时长由 $\frac{(N-1)l}{2p-1}$ 界定。根据 **定理 1 的证明**，在位者较差的探索迭代总时长由 $\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)$ 界定。
>
> 现在关注利用阶段产生的遗憾。在第 $i$ 轮结束时，我们错误地识别了最优臂的概率小于 $(\frac{1-p}{p})^{i}$ （基于 Lemma 3 的思想）。因此，到第 $l$ 轮结束时，利用阶段产生的期望遗憾由 $\sum_{i=1}^{l}(\frac{1-p}{p})^{i}\times\beta^{i}$ 界定。当 $\beta < p/(1-p)$ 时，这个级数可以被简单地用 $l$ 来界定（这是一个较宽松的界，但足以推导出最终的 $O$ 符号表示）。
>
> 总的来说，这意味着截至时间 $T$（我们假设 $T$ 发生在第 $l$ 轮）的期望强遗憾由以下公式界定：
>
> $[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+l+\frac{(N-1)l}{2p-1}]$
> $\le[\frac{2p^{3}}{(2p-1)^{6}}N(log(N)+1)+\frac{N~log_{\beta}(T(\beta-1))}{2p-1}]$ [将 $l \approx \log_{\beta}(T(\beta-1))$ 代入并合并 $l$ 的系数]。
>
> 因此，截至时间 $T$ 的期望强遗憾是 $O(N~log(T)+N~log(N))$。Π

--- -->


### 4.4 Extension to Utility-Based Regret

## 5 Numerical Experiments

## 6 Conclusion

