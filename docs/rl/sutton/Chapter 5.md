# Chapter 5: Monte Carlo Methods

## 5.1 Monte Carlo Prediction

## 5.2 Monte Carlo Estimation of Action Values

## 5.3 Monte Carlo Control

## 5.4 Monte Carlo Control without Exploring Starts

避免试探性出发假设的唯一的一般性解决方法就是 Agent 可以持续不断选择所有的动作，有两种方式可以满足，分别被称为同轨策略/On-Policy 方法和离轨策略/Off-Policy 方法。在同轨策略方法中，用于生成采样数据序列的策略和用于实际决策的待评估的策略是同一个策略。在离轨策略方法中，用于生成采样数据序列的策略和用于实际决策的待评估的策略是不同的策略。也就是生成的数据离开了待优化的策略所决定的决策序列轨迹。

## 5.5 Off-Policy Prediction via Importance Sampling

所有的控制方法都面临这样的一个困境：他们希望学到的动作使得后续的行为都是最优的，但是为了保证找到最优的动作，其需要搜索所有的动作，因此就必须采取非最优的行为/Behave Non-Optimally。前面提到的同轨策略方法其实是一种妥协，进行学习的是一个 $\epsilon$-软策略，并不学习的是最优动作的动作值，而是学习一个接近最优但是仍可以进行试探的动作值。

一个更加直接的方法是采用两个策略，一个用来学习并最终成为最优策略，另一个更加有试探性，用来产生智能体的动作样本。用来学习的策略被称为**目标策略/Target Policy**，用来产生动作样本的策略被称为**行动策略/Action Policy**。学习所用的数据离开了待学习的目标策略，因此整个过程被称为**离轨策略/Off-Policy**学习。

