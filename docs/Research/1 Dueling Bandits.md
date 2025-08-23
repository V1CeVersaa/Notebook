# Achieving Nearly-Optimal Regret and Sample Complexity in Dueling Bandits with Applications in Online Recommendations

## 0 Most Important Things


## 3.2 RM is nearly-consistent with BAI in dueling bandits

关键点在于：

- 为了最小化累计遗憾，我们需要尽可能快的将 Condorcet Winner 找出来；
- BAI 也是希望尽快的将 Condorcet Winner 找出来，而比较两个摇杆的样本复杂度恰好是分别两个摇杆的概率的平方反比，这也要求我们将 Condorcet Winner 尽快找出来。

## 4 EXPERIMENTS

实验就不读了，这里的实验将 WSW-PE、BTW-PE、WSW-PE-EXP 和别的在 RM 或者 BAI 上面 SOTA 的算法进行了比较。设计了 synthetic 的数据集和 Realworld Online Recommendation 的测试。

这里的实验当然是好的。

## 5 RELATED WORK


## 6 CONCLUSION

核心思想还是 **RM and BAI can be nearly compatible in dueling bandits by reducing the BAI task to a noisy identification process.**

给出的算法满足累计 weak regret 对已知算法最优，但是 sample complexity 确是次优的，和理论最优差了一个 $\ln N$。



