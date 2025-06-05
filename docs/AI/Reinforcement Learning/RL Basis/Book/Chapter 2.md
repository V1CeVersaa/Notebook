# Chapter 2: Multi-armed Bandits

将时刻 $t$ 时选择的动作记为 $A_t$，对应的收益记为 $R_t$，则任一动作 $a$ 的价值 $q_*(a) = \mathbb{E}[R_{t} | A_t = a]$ 为给定动作 $a$ 时，奖励 $R_{t}$ 的期望。

## 2.6 Optimistic Initial Values

对于简单的 $\varepsilon$-greedy 算法，使用乐观初始值的方法在最开始表现差一点，因为这种方法需要探索更多次，但是最终探索的次数减少，因此表现的更好，选择最优动作的次数更多。这种鼓励探索的方法被称为是乐观初始值，其对于稳定问题比较有效，但不是普遍有用的方法，对于非稳定问题就不适用了。

## 2.7 Upper-Confidence-Bound Action Selection

## 2.9 Associative Search (Contextual Bandits)

一般的强化学习任务中，很可能有不止一个情境，这时候的目标就变成了学习一个策略，这里的策略指的是一个从情境/Situation 到该情境中的最优动作/Action 的映射。具体到赌博机问题，我们假设面对的是多个不同的赌博机，每个赌博机有不同的动作价值，但是我们在面对每一个赌博机的时候，我们得到一个提示/Clue/Oracle，这个提示告诉我们当前的赌博机是哪一个，但是不会告诉我赌博机的动作价值。

这就是关联搜索/Associative Search 问题，我们这么叫是因为这个问题不仅需要采用试错学习来寻找最优动作，还需要将最优动作和其表现为最优的情境关联起来。我们也将关联搜索问题称为上下文赌博机/Contextual Bandits 问题，其介于纯粹的多臂赌博机问题和完整强化学习之间。更一般的，如果动作可以影响下一个情景和奖励，那么这个问题就变成了一个完整强化学习问题。

## 2.10 Summary

贝叶斯方法假定已知动作价值的初始分布，也假定真实的动作价值是平稳的，在每一步之后更新分布。虽然更新过程有时候会很复杂，但是我们就很可以根据成为最优动作的后验概率进行动作选择，这种方法我们称为后验采样/Posterior Sampling 或者汤普森采样/Thompson Sampling，和我们在本章中提出的无分布方法的最优性能相近。

Gittins-index 方法是贝叶斯方法的一个实例。

贝叶斯方法甚至可以计算出探索和利用的最佳平衡，也将一个赌博机问题有效转化成了一个完整强化学习的一个实例，我们也可能使用近似强化学习方法逼近最优解，但是这已经成为科研问题了。

> One can compute for any possible action the probability of each possible immediate reward and the resultant posterior distributions over action values. This evolving distribution becomes the information state of the problem. 
