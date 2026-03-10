# Chapter 6: 一致性

一致性关注的是随着训练数据的增多，甚至趋于无穷的极限过程中，学习算法通过训练数据学习得到的分类器是否趋于贝叶斯最优分类器。

## 1. 基本概念

x

## 2. 替代函数



## 3. 划分机制



## 4. 分析实例

### 4.2 随机森林

<!-- ### 6.4.2 随机森林

随机森林 (Random Forest) [Breiman, 2001] 是一种重要的集成学习 (ensemble learning) 方法 [Zhou, 2012]，通过对数据集进行有放回采样 (bootstrap sampling) 产生多个训练集，然后基于每个训练集产生随机决策树，最后通过投票法对随机决策树进行集成。这些随机决策树是在决策树生成过程中，对划分结点、划分属性 (attribute) 及划分点引入随机选择而产生的。

对随机决策树，可以引入一个新的随机变量 $Z \in \mathcal{Z}$，用以刻画决策树的随机性，即用 $h_m(\boldsymbol{x}, Z)$ 表示随机决策树，这里 $m$ 表示训练集的大小。假设产生 $n$ 棵随机决策树

$$h_m(\boldsymbol{x}, Z_1), h_m(\boldsymbol{x}, Z_2), \ldots, h_m(\boldsymbol{x}, Z_n).$$

然后根据这些决策树进行投票，从而构成随机森林 $\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n)$，即

$$\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n) = \begin{cases}
+1 & \text{如果 } \sum_{i=1}^n h_m(\boldsymbol{x}, Z_i) \geq 0,\\
-1 & \text{如果 } \sum_{i=1}^n h_m(\boldsymbol{x}, Z_i) < 0.
\end{cases}$$

关于随机森林和随机决策树的一致性，有如下引理：

**引理 6.6** 对随机决策树 $h_m(\boldsymbol{x}, Z)$ 和随机森林 $\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n)$，有

$$\mathbb{E}_{Z_1,\ldots,Z_n}[R(\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n))] - R^* \leq 2(\mathbb{E}_Z[R(h_m(\boldsymbol{x}, Z))] - R^*).$$

**证明** 根据泛化风险 (6.2) 和贝叶斯最优风险 (6.6) 可知

$$\mathbb{E}_Z[R(h_m(\boldsymbol{x}, Z))] - R^*$$
$$= \mathbb{E}_{\boldsymbol{x}\sim\mathcal{D}_\mathcal{X}} [(1 - 2\eta(\boldsymbol{x}))\mathbb{I}(\eta(\boldsymbol{x}) < 1/2)P_Z(h_m(\boldsymbol{x}, Z) = 1)$$
$$+ (2\eta(\boldsymbol{x}) - 1)\mathbb{I}(\eta(\boldsymbol{x}) > 1/2)P_Z(h_m(\boldsymbol{x}, Z) = -1)],$$

进一步得到

$$\mathbb{E}_{Z_1,\ldots,Z_n}[R(\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n))] - R^*$$
$$= \mathbb{E}_{\boldsymbol{x}\sim\mathcal{D}_\mathcal{X}} [(1 - 2\eta(\boldsymbol{x}))\mathbb{I}(\eta(\boldsymbol{x}) < 1/2)P_{Z_1,\ldots,Z_n}(\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n) = 1)$$
$$+ (2\eta(\boldsymbol{x}) - 1)\mathbb{I}(\eta(\boldsymbol{x}) > 1/2)P_{Z_1,\ldots,Z_n}(\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n) = -1)].$$

对任意样本 $\boldsymbol{x} \in \mathcal{X}$，当 $\eta(\boldsymbol{x}) < 1/2$ 时有

$$P_{Z_1,\ldots,Z_n}(\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n) = 1)$$
$$= P_{Z_1,\ldots,Z_n}\left(\sum_{i=1}^n \mathbb{I}(h_m(\boldsymbol{x}, Z_i) = 1) \geq \frac{n}{2}\right)$$
$$\leq \frac{2}{n}\sum_{i=1}^n \mathbb{E}[\mathbb{I}(h_m(\boldsymbol{x}, Z_i) = 1)] = 2P(h_m(\boldsymbol{x}, Z) = 1).$$

同理可证 $\eta(\boldsymbol{x}) \geq 1/2$ 的情况，引理得证。 □

引理 6.6 表明，若随机决策树 $h_m(\boldsymbol{x}, Z)$ 具有一致性，则由随机决策树构成的随机森林 $\bar{h}_m(\boldsymbol{x}; Z_1,\ldots,Z_n)$ 也具有一致性。

给定训练集 $D_m = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$，下面考虑随机决策树 $h_m(\boldsymbol{x}, Z)$ 的构造方式：决策树中每个结点对应于一个区域，所有叶结点对应的区域构成样本空间 $\mathcal{X}$ 的一个划分。决策树的根结点是样本空间 $\mathcal{X}$ 本身，在构造决策树的每一轮迭代中：随机选择一个叶结点，然后在叶结点随机选择一种划分属性，在所选择的划分属性中随机选择一个划分点进行划分，将上述过程迭代 $k$ 次。完成划分后，在每一个区域内投票得到该区域样本的标记。

给定样本 $\boldsymbol{x}$，令 $\Omega(\boldsymbol{x})$ 表示样本 $\boldsymbol{x}$ 所在叶结点对应的区域，则随机决策树

$$h_m(\boldsymbol{x}, Z) = \begin{cases}
1 & \text{如果 } \sum_{\boldsymbol{x}_i \in \Omega(\boldsymbol{x})} y_i \geq 0,\\
-1 & \text{如果 } \sum_{\boldsymbol{x}_i \in \Omega(\boldsymbol{x})} y_i < 0.
\end{cases}$$

关于此随机决策树所集成的随机森林，有如下定理 [Biau et al., 2008]。

**定理 6.5** 当训练集规模 $m \to \infty$ 时，如果每棵随机决策树的迭代轮数 $k = k(m) \to \infty$ 且 $k/m \to 0$，则随机森林具有一致性。

**证明** 首先研究随机决策树的一致性，随机决策树本质上是基于划分机制的一种分类方法。考虑样本空间 $\mathcal{X} = [0,1]^d$，对任意 $\boldsymbol{x} \in \mathcal{X}$，令 $\Omega(\boldsymbol{x}, Z)$ 表示样本 $\boldsymbol{x}$ 所在的区域，$N(\boldsymbol{x}, Z)$ 表示落入 $\Omega(\boldsymbol{x}, Z)$ 中的训练样本数，即

$$N(\boldsymbol{x}, Z) = \sum_{i=1}^m \mathbb{I}(\boldsymbol{x}_i \in \Omega(\boldsymbol{x}, Z)).$$

首先证明当 $m \to \infty$ 时有 $N(\boldsymbol{x}, Z) \to \infty$ 依概率几乎处处成立。设 $\Omega_1, \Omega_2,\ldots,\Omega_{k+1}$ 为随机决策树通过 $k$ 轮迭代后得到的 $k + 1$ 个区域，且设 $N_1, N_2,\ldots,N_{k+1}$ 分别为训练集 $D_m$ 落入这些区域的样本数。给定训练集 $D_m$ 和随机变量 $Z$，样本 $\boldsymbol{x}$ 落入区域 $\Omega_i$ 的概率为 $N_i/m$。对任意给定 $t > 0$，有

$$P(N(\boldsymbol{x}, Z) < t) = \mathbb{E}[P(N(\boldsymbol{x}, Z) < t|D_m, Z)]$$
$$= \mathbb{E}\left[\sum_{i: N_i<t} \frac{N_i}{m}\right]$$
$$\leq (t - 1)\frac{k + 1}{m} \to 0.$$

其次证明当 $k \to \infty$ 时区域 $\Omega(\boldsymbol{x}, Z)$ 的直径 $\text{Diam}(\Omega(\boldsymbol{x}, Z)) \to 0$ 依概率几乎处处成立。令 $T_m$ 表示区域 $\Omega(\boldsymbol{x}, Z)$ 被划分的次数，根据随机决策树的构造可知 $T_m = \sum_{i=1}^k \xi_i$，其中 $\xi_i \sim \text{Bernoulli}(1/i)$。于是有

$$\mathbb{E}[T_m] = \sum_{i=1}^k \frac{1}{i} \geq \ln k,$$

$$\mathbb{V}(T_m) = \sum_{i=2}^k \frac{1}{i}\left(1 - \frac{1}{i}\right) \leq \ln k + 1.$$

根据 Chebyshev 不等式 (1.21) 可知，当 $k \to \infty$ 时有

$$P\left(|T_m - \mathbb{E}[T_m]| \geq \frac{\mathbb{E}[T_m]}{2}\right) \leq 4\frac{\mathbb{V}(T_m)}{\mathbb{E}[T_m]^2}$$
$$\leq 4\frac{\ln k + 1}{\ln^2 k} \to 0,$$

当 $k \to \infty$ 时，因此可得

$$P\left(T_m \geq \ln \frac{k}{2}\right) \to 1.$$

令 $L_j$ 表示区域 $\Omega(\boldsymbol{x}, Z)$ 中第 $j$ 个属性的边长，根据随机决策树的构造可知

$$\mathbb{E}[L_j] \leq \mathbb{E}\left[\mathbb{E}\left[\prod_{i=1}^{K_j} \max(U_i, 1 - U_i)\bigg|K_j\right]\right].$$

这里的随机变量 $K_j \sim \mathcal{B}(T_m, 1/d)$ 表示随机决策树构造中第 $j$ 个属性被选用划分的次数，随机变量 $U_i \sim \mathcal{U}(0,1)$ 表示第 $j$ 个属性被划分的位置。根据 $U_i \sim \mathcal{U}(0,1)$ 有

$$\mathbb{E}[\max(U_i, 1 - U_i)] = 2\int_{1/2}^1 U_i\text{d}U_i = \frac{3}{4},$$

由此可得

$$\mathbb{E}[L_j] = \mathbb{E}\left[\mathbb{E}\left[\prod_{i=1}^{K_j} \max(U_i, 1 - U_i)\bigg|K_j\right]\right] = \mathbb{E}[(3/4)^{K_j}].$$

再根据 $K_j \sim \mathcal{B}(T_m, 1/d)$ 有

$$\mathbb{E}[L_j] = \mathbb{E}[(3/4)^{K_j}]$$
$$= \mathbb{E}\left[\sum_{K_j=1}^{T_m} \left(\frac{3}{4}\right)^{K_j} \binom{T_m}{K_j}\left(\frac{1}{d}\right)^{K_j}\left(1 - \frac{1}{d}\right)^{T_m-K_j}\right]$$
$$= \mathbb{E}\left[\sum_{K_j=1}^{T_m} \binom{T_m}{K_j}\left(\frac{3}{4d}\right)^{K_j}\left(1 - \frac{1}{d}\right)^{T_m-K_j}\right]$$
$$= \mathbb{E}\left[\left(1 - \frac{1}{d} + \frac{3}{4d}\right)^{T_m}\right]$$
$$= \mathbb{E}\left[\left(1 - \frac{1}{4d}\right)^{T_m}\right].$$

结合 (6.96) 和 (6.100)，当 $k \to \infty$ 时有 $\mathbb{E}[L_j] \to 0$，进而有

$$\mathbb{E}[\text{Diam}(\Omega(\boldsymbol{x}, Z))] = \mathbb{E}[L_j]\sqrt{d} \to 0,$$

基于定理 6.2 可得随机决策树具有一致性，再 -->
