# Chapter 1 Introduction

## 1. Standard Model for Supervised Learning

监督学习：

- 观察一个输入的随机变量/特征向量 $X \in \mathbb{R}^d$，表示已知信息；
- 观察一个输出变量/标签 $Y$，表示我们想要预测的未知信息；
- 目标是基于 $X$ 预测 $Y$；

**预测规则/Prediction Rules** 是由参数化函数 $f(w, \cdot): \mathbb{R}^d \rightarrow \mathbb{R}^k$ 得到的，其中 $w \in \Omega$ 是可以在训练数据上学习的模型参数。对于 $k$-类分类问题，其中 $Y \in \{1, \ldots, k\}$，我们使用以下预测规则预测 $Y$，给定函数 $f(w, x) = [f_1(w, x), \ldots, f_k(w, x)] \in \mathbb{R}^k$：

$$
q(x) = \operatorname*{\arg\max}\limits_{\ell \in \{1, \ldots, k\}} f_{\ell}(w, x).
$$

预测质量由**损失函数/Loss Function** $L(f(x), y)$ 来衡量：损失越小，预测准确性越高。

监督学习是的目标基于观察/标记的历史数据 $\mathcal{S}_n = \{(X_1, Y_1), \ldots, (X_n, Y_n)\}$ 估计 $\hat{w} \in \Omega$，有了这个参数，我们就可以确定参数化的预测规则，进而给出我们的预测。监督学习算法 $\mathcal{A}$ 接受训练数据集 $\mathcal{S}_n$ 作为输入，并输出一个函数 $f(\hat{w}, \cdot)$，其中 $\hat{w} = \mathcal{A}(\mathcal{S}_n) \in \Omega$。最常见的算法是**经验风险最小化/ERM**：

$$
\hat{w} = \mathop{\arg\min}\limits_{w \in \Omega} \frac{1}{n} \sum_{i=1}^{n} L(f(w, X_i), Y_i).
$$

可以看到，我们学习到的参数就是使得训练数据上的损失最小的参数。在标准的理论模型中，我们假设训练数据 $\{(X_i, Y_i) : i = 1, \ldots, n\}$ 是**独立同分布/iid/Independent and Identically Distributed**，服从某个未知的底层分布 $\mathcal{D}$。分类器 $\hat{f}(x) = f(\hat{w}, x)$ 在训练数据上的损失就是训练误差：

$$
\mathop{\text{training-loss}}(\hat{w}) = \frac{1}{n} \sum_{i=1}^{n} L(f(\hat{w}, X_i), Y_i).
$$

同样，我们也假设测试数据（未来未见数据） $(X, Y)$ 也服从同一个分布 $\mathcal{D}$，我们感兴趣的是在测试数据上的**泛化误差**，定义为：

$$
\mathop{\text{test-loss}}(\hat{w}) = \mathbb{E}_{(X, Y) \sim \mathcal{D}}[L(f(\hat{w}, X), Y)].
$$

由于我们只观测到了 $\hat{f} = f(\hat{w}, \cdot)$ 的训练误差，

<!-- Since we only observe the training error of
f= f( ˆ w,·), a major goal is to
ˆ
estimate the test error (i.e. generalization error) of
f based on its training error,
referred to as generalization bound, which is of the following form. Given ϵ≥0,
we want to determine δn(ϵ) so that
Pr E(X,Y)∼DL(f( ˆ w,X),Y) ≥
n
n
i=1
L(f( ˆ w,Xi),Yi) + ϵ ≤δn(ϵ),
where the probability is with respect to the randomness over the training data
Sn. In general, δn(ϵ) →0 as n→∞.
In the literature, this result is often stated in the following alternative form,
where we want to determine a function ϵn(δ) of δ, so that with probability at
least 1−δ (over the random sampling of the training data Sn):
1
E(X,Y)∼DL(f( ˆ w,X),Y) ≤
n
L(f( ˆ w,Xi),Yi) + ϵn(δ). (1.2)
n
i=1
We want to show that ϵn(δ) →0 as n→∞.
Another style of theoretical result, often referred to as oracle inequalities, is to
show that with probability at least 1−δ (over the random sampling of training
data Sn):
E(X,Y)∼DL(f( ˆ w,X),Y) ≤inf
E(X,Y)∼DL(f(w,X),Y) + ϵn(δ). (1.3)
w∈Ω
This shows that the test error achieved by the learning algorithm is nearly as
small as that of the optimal test error achieved by f(w,x) with w ∈Ω. We say
the learning algorithm is consistent if ϵn(δ) →0 as n→0. Moreover, the rate of
convergence refers to the rate of ϵn(δ) converging to zero when n→∞.
Chapter 2 and Chapter 3 establish the basic mathematical tools in empirical
processes for analyzing supervised learning. Chapter 4, Chapter 5, and Chap-
ter 6 further develop the techniques. Chapter 7 considers a diﬀerent analysis
that directly controls the complexity of a learning algorithm using stability. This
analysis is gaining popularity due to its ability to work directly with algorith-
mic procedures such as SGD. Chapter 8 introduces some standard techniques for
model selection in the supervised learning setting. Chapter 9 analyzes the ker-
nel methods. Chapter 10 analyzes additive models with a focus on sparsity and
boosting. Chapter 11 investigates the analysis of neural networks. Chapter 12
discusses some common techniques and results for establishing statistical lower
bounds.
1.2 Online Learning and Sequential Decision-Making
In online learning, we consider observing (Xt,Yt) one by one in a time sequence
from t= 1,2,.... An online algorithm Alearns a model parameter ˆ wt at time t
based on previously observed data (X1,Y1),...,(Xt,Yt):
ˆ
wt = A({(X1,Y1),...,(Xt,Yt)}). -->
