# Introduction to Online Learning

## Table of Contents

- [ ] [Lecture 1: Online Learning and Online Convex Optimization](./Lecture%201.md)
- [ ] [Lecture 2: Multi-Armed Bandits](./Lecture%202.md)

## Introduction

下面是几个在线学习的例子：

- 序贯投资/Sequential Investment：初始资金为 $W_1$，在每一天 $t = 1, 2, \ldots,$
    - 决定 $p_t \in \Delta(N) \overset{\text{def}}{=} \{ p \in \mathbb{R}^N_{+} \mid \sum_{i=1}^N p(i) = 1 \}$，并且在 $i$ 上投资 $W_{t-1} p_t(i)$
    - 在当天的最后观察到价格 $r_t \in \mathbb{R}^N$，并且计算当天的财富为 $W_{t+1} = W_t \langle p_t, r_t \rangle$

所有这些问题本质上都可以通过一个称为在线凸优化/Online Convex Optimization/OCO 的学习模型来捕捉。OCO 可以被视为学习者/玩家与环境/对手之间的博弈。在游戏开始前，玩家被给定一个固定的紧凸集 $\Omega$ 作为动作空间。然后游戏进行 $T$ 轮，其中 $T$ 是某个整数。在每一轮 $t = 1, \ldots, T$ 中，

1. 玩家首先选择一个点 $w_t \in \Omega$；
2. 环境然后选择一个凸损失函数 $f_t : \Omega \to [0, 1]$；
3. 玩家遭受损失 $f_t(w_t)$，并观察关于 $f_t$ 的一些信息。

根据环境的能力，有几种可能的设置：

- 随机设置/Stochastic Setting：$f_1, \ldots, f_T$ 是固定分布的独立同分布样本；
- 遗忘对手/Oblivious Adversary：$f_1, \ldots, f_T$ 是任意的，但在游戏开始前就已确定（即独立于玩家的行动）；
- 非遗忘/自适应对手/Non-oblivious/Adaptive Adversary：对于每个 $t$，$f_t$ 依赖于 $w_1, \ldots, w_t$。

根据反馈模型，也有几种可能的设置：

- 完整信息设置/Full Information Setting：玩家观察到 $f_t$（或有时仅观察到（次）梯度 $\nabla f_t(w_t)$）；
- 赌博机设置/Bandit Setting：玩家仅观察到 $f_t(w_t)$；
- 其他部分信息设置/Other Partial Information Settings。






