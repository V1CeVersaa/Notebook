# Chapter 7: 贝叶斯分类器

## 1. 贝叶斯决策论

贝叶斯决策论是概率框架下实施决策的基本方法。对分类任务来说，在所有相关概率都已知的理想情形下，贝叶斯决策论考虑如何基于这些概率和误判损失来选择最优的类别标记。

假设有 $N$ 种可能的类别标记，即 $\mathcal{Y} = \{c_1, c_2, \ldots, c_N\}$，$\lambda_{ij}$ 是将一个真实**标记为** $c_i$ **的样本误分类为** $c_j$ **所产生的损失**。基于后验概率 $P(c_i \mid \boldsymbol{x})$ 可获得将样本 $\boldsymbol{x}$ 分类为 $c_j$ 所产生的期望损失，即样本 $\boldsymbol{x}$ 的**条件风险**：

$$R(c_i \mid \boldsymbol{x}) = \sum_{j=1}^N \lambda_{ij}P(c_j \mid \boldsymbol{x}).$$

我们的任务是寻找一个判定准则 $h: \mathcal{X} \mapsto \mathcal{Y}$ 以最小化总体风险：

$$R(h) = \mathbb{E}_{\boldsymbol{x}}[R(h(\boldsymbol{x}) \mid \boldsymbol{x})].$$

显然，对每个样本 $\boldsymbol{x}$，若 $h$ 能最小化条件风险 $R(h(\boldsymbol{x}) \mid \boldsymbol{x})$，则总体风险 $R(h)$ 也将被最小化。这就产生了**贝叶斯判定准则/Bayes Decision Rule**：为最小化总体风险，只需在每个样本上选择那个能使条件风险 $R(c \mid \boldsymbol{x})$ 最小的类别标记，即：

$$h^*(\boldsymbol{x}) = \underset{c\in\mathcal{Y}}{\arg\min} R(c \mid \boldsymbol{x}).$$

此时，$h^*$ 称为**贝叶斯最优分类器/Bayes Optimal Classifier**，与之对应的总体风险 $R(h^*)$ 称为**贝叶斯风险/Bayes Risk**。$1-R(h^*)$ 反映了分类器所能达到的最好性能，即通过机器学习所能产生的模型精度的理论上限。

若目标是最小化分类错误率，则误判损失 $\lambda_{ij}$ 可写为：

$$\lambda_{ij} = \begin{cases}
    0, & \text{if } i = j; \\
    1, & \text{otherwise},
\end{cases}$$

对应的条件风险和贝叶斯最优分类器为：

$$R(c \mid \boldsymbol{x}) = 1 - P(c \mid \boldsymbol{x}), \quad h^*(\boldsymbol{x}) = \underset{c\in\mathcal{Y}}{\arg\max} P(c \mid \boldsymbol{x}).$$

如果需要通过贝叶斯判定准则最小化决策风险，首先需要获得后验概率 $P(c \mid \boldsymbol{x})$，这在现实任务中是难以直接获得的，因此机器学习需要实现的目标是根据有限的样本集尽可能准确地估计出后验概率 $P(c \mid \boldsymbol{x})$。总的来说，有两种策略，对应两种模型：

- 判别式模型/Discriminative Models：直接对后验概率 $P(c \mid \boldsymbol{x})$ 建模，例如决策树、BP 神经网络、支持向量机等；
- 生成式模型/Generative Models：先对联合概率分布 $P(\boldsymbol{x},c)$ 建模，再由此获得 $P(c \mid \boldsymbol{x})$，例如朴素贝叶斯分类器；

生成式模型必然考虑：

$$P(c \mid \boldsymbol{x}) = \frac{P(\boldsymbol{x},c)}{P(\boldsymbol{x})} = \frac{P(c)P(\boldsymbol{x} \mid c)}{P(\boldsymbol{x})}.$$

其中：

- $P(c)$ 是类**先验/Prior** 概率；
- $P(\boldsymbol{x} \mid c)$ 是样本 $\boldsymbol{x}$ 相对于类标记 $c$ 的**类条件概率/Class-Conditional Probability**，或称为**似然/Likelihood**；
- $P(\boldsymbol{x})$ 是用于归一化的**证据/Evidence** 因子。

因此，估计 $P(c \mid \boldsymbol{x})$ 的问题就转化为如何基于训练数据 $D$ 来估计先验 $P(c)$ 和似然 $P(\boldsymbol{x} \mid c)$。类先验概率 $P(c)$ 表达了样本空间中各类样本所占的比例，根据大数定律，当训练集包含充足的独立同分布样本时，其可通过各类样本出现的频率来进行估计。对于类条件概率 $P(\boldsymbol{x} \mid c)$，由于它涉及关于 $\boldsymbol{x}$ 所有属性的联合概率，直接估计非常困难。

## 2. 极大似然估计

估计类条件概率的一种常用策略是先假定其具有某种特定的概率分布形式，再基于训练样本对概率分布的参数进行估计。具体地，记关于类别 $c$ 的类条件概率为 $P(\boldsymbol{x} \mid c)$，假设 $P(\boldsymbol{x} \mid c)$ 具有确定的形式并且被参数向量 $\boldsymbol{\theta}_c$ 唯一确定，则我们的任务就是利用训练集 $D$ 估计参数 $\boldsymbol{\theta}_c$。为明确起见，我们将 $P(\boldsymbol{x} \mid c)$ 记为 $P(\boldsymbol{x} \mid \boldsymbol{\theta}_c)$。

概率模型的训练过程就是参数估计/Parameter Estimation 过程。对于参数估计，统计学界的两个学派分别提供了不同的解决方案：

- 频率主义学派/Frequentist：认为参数虽然未知，但却是客观存在的固定值，因此，可通过优化似然函数等准则来确定参数值；
- 贝叶斯学派/Bayesian：认为参数是未观察到的随机变量，其本身也可有分布，因此，可假定参数服从一个先验分布，然后基于观测到的数据来计算参数的后验分布。

极大似然估计/Maximum Likelihood Estimation/MLE 就是来自频率主义学派的参数估计方法，它是根据数据采样来估计概率分布参数的经典方法。

令 $D_c$ 表示训练集 $D$ 中第 $c$ 类样本组成的集合，假设这些样本是独立同分布的，则参数 $\boldsymbol{\theta}_c$ 对于数据集 $D_c$ 的似然是

$$P(D_c \mid \boldsymbol{\theta}_c) = \prod_{\boldsymbol{x}\in D_c} P(\boldsymbol{x} \mid \boldsymbol{\theta}_c).$$

对 $\boldsymbol{\theta}_c$ 进行极大似然估计，就是去寻找能最大化似然 $P(D_c \mid \boldsymbol{\theta}_c)$ 的参数值 $\hat{\boldsymbol{\theta}}_c$。直观上看，极大似然估计是试图在 $\boldsymbol{\theta}_c$ 所有可能的取值中，找到一个能使数据出现的可能性最大的值。

上面的连乘操作易造成下溢，通常使用对数似然/Log-likelihood：

$$LL(\boldsymbol{\theta}_c) = \log P(D_c \mid \boldsymbol{\theta}_c) = \sum_{\boldsymbol{x}\in D_c} \log P(\boldsymbol{x} \mid \boldsymbol{\theta}_c).$$

此时参数 $\boldsymbol{\theta}_c$ 的极大似然估计为

$$\hat{\boldsymbol{\theta}}_c = \underset{\boldsymbol{\theta}_c}{\arg\max} LL(\boldsymbol{\theta}_c).$$

例如，在连续属性情形下，假设概率密度函数 $p(\boldsymbol{x} \mid c) \sim \mathcal{N}(\mu_c, \sigma_c^2)$，则参数 $\mu_c$ 和 $\sigma_c^2$ 的极大似然估计为

$$\begin{aligned}
    \mu_c &= \frac{1}{|D_c|}\sum_{\boldsymbol{x}\in D_c} \boldsymbol{x}, \\
    \sigma_c^2 &= \frac{1}{|D_c|}\sum_{\boldsymbol{x}\in D_c}(\boldsymbol{x} - \mu_c)(\boldsymbol{x} - \mu_c)^{\mathrm{T}}.
\end{aligned}$$

也就是说，通过极大似然法得到的正态分布均值就是样本均值，方差就是 $(\boldsymbol{x} - \mu_c)(\boldsymbol{x} - \mu_c)^{\mathrm{T}}$ 的均值。

需要注意，这样的参数化方法虽然让类条件概率估计变得相对简单，但估计结果的准确性**严重依赖于所假设的概率分布形式是否符合潜在的真实数据分布**。在现实应用中，欲做出能较好地将数据分布模拟出来的假设，往往需要在一定程度上利用关于应用任务本身的经验知识。

## 3. 朴素贝叶斯分类器

基于贝叶斯公式估计后验概率 $P(c \mid \boldsymbol{x})$ 的主要困难在于：类条件概率 $P(\boldsymbol{x} \mid c)$ 是所有属性上的联合概率，难以从有限的训练样本直接估计而得。为避开这个障碍，朴素贝叶斯分类器/Naïve Bayes Classifier 采用了**属性条件独立性假设/Attribute Conditional Independence Assumption**：对已知类别，假设所有属性相互独立。换言之，假设每个属性独立地对分类结果发生影响。

属性条件独立性假设允许我们将贝叶斯公式重写为：

$$P(c \mid \boldsymbol{x}) = \frac{P(c)P(\boldsymbol{x} \mid c)}{P(\boldsymbol{x})} = \frac{P(c)}{P(\boldsymbol{x})}\prod_{i=1}^d P(x_i \mid c),$$

其中 $d$ 为属性数目，$x_i$ 为 $\boldsymbol{x}$ 在第 $i$ 个属性上的取值。对所有类别来说 $P(\boldsymbol{x})$ 相同，因此基于贝叶斯判定准则有：

$$h_{nb}(\boldsymbol{x}) = \underset{c\in\mathcal{Y}}{\arg\max} P(c)\prod_{i=1}^d P(x_i \mid c).$$

这就是朴素贝叶斯分类器的表达式。

可以见得，朴素贝叶斯分类器的训练方式就是基于训练集 $D$ 来估计类先验概率 $P(c)$，并为每个属性估计条件概率 $P(x_i \mid c)$。对离散属性而言，类先验概率和条件概率的估计分别为：

$$P(c) = \frac{|D_c|}{|D|}, \quad P(x_i \mid c) = \frac{|D_{c,x_i}|}{|D_c|},$$

其中 $D_c$ 表示训练集 $D$ 中第 $c$ 类样本组成的集合，$D_{c,x_i}$ 表示 $D_c$ 中在第 $i$ 个属性上取值为 $x_i$ 的样本组成的集合。对连续属性，可考虑概率密度函数，假定 $p(x_i \mid c) \sim \mathcal{N}(\mu_{c,i}, \sigma_{c,i}^2)$，则有：

$$p(x_i \mid c) = \frac{1}{\sqrt{2\pi}\sigma_{c,i}}\exp\left(-\frac{(x_i - \mu_{c,i})^2}{2\sigma_{c,i}^2}\right).$$

在实践中可能出现一种情况，某个属性值在训练集中没有和某个类同时出现过，则直接基于上述估计会导致整个概率值为零，这显然是不合理的。为了避免其他属性携带的信息被训练集中未出现的属性抹去，在估计概率值时通常要进行平滑/Smoothing，常用**拉普拉斯修正/Laplacian Correction**。具体来说，令 $N$ 表示训练集 $D$ 中可能的类别数，$N_i$ 表示第 $i$ 个属性可能的取值数，则我们对类先验概率和条件概率进行修正：

$$\hat{P}(c) = \frac{|D_c| + 1}{|D| + N}, \quad \hat{P}(x_i \mid c) = \frac{|D_{c,x_i}| + 1}{|D_c| + N_i}.$$

这就避免了因训练集样本不充分而导致概率估值为零的问题，并且在训练集变大时，修正过程所引入的先验影响会逐渐变得可忽略，使得估值渐近于实际概率值。

## 4. 半朴素贝叶斯分类器

为了估计似然 $P(\boldsymbol{x} \mid c)$，朴素贝叶斯分类器采用了属性条件独立性假设，但在现实任务中这个假设往往很难成立。于是，人们尝试对属性条件独立性假设进行一定程度的放松，因此产生了**半朴素贝叶斯分类器/Semi-Naïve Bayes Classifier**。半朴素贝叶斯分类器的基本思想是适当考虑一部分属性间的相互依赖信息，从而既不需要进行完全联合概率计算，又不至于彻底忽略了比较强的属性依赖关系。

具体而言，半朴素贝叶斯分类器采用了**独依赖估计/One-Dependent Estimator/ODE** 策略，也就是假设每个属性在类别之外**最多仅依赖于一个其他属性**。这就允许我们产生如下估计：

$$P(c \mid \boldsymbol{x}) \propto P(c)\prod_{i=1}^d P(x_i \mid c, pa_i).$$

其中 $pa_i$ 为属性 $x_i$ 所依赖的属性，称为 $x_i$ 的父属性。此时，对每个属性 $x_i$，若其父属性 $pa_i$ 已知，则可以使用上一节中的方法来估计概率值 $P(x_i \mid c, pa_i)$。于是，问题的关键就转化为如何确定每个属性的父属性。不同的做法产生不同的半朴素贝叶斯分类器。

最直接的做法是假设所有属性都依赖于同一个属性，称为超父/Super-Parent，然后通过交叉验证等模型选择方法来确定超父属性，由此形成了 SPODE/Super-Parent ODE 方法。在下面图的 (b) 中，$x_1$ 是超父属性。

<img class="center-picture" src="./assets/7-1.webp" width="650" />

TAN/Tree Augmented Naïve Bayes 是在最大带权生成树/Maximum Weighted Spanning Tree 算法的基础上，通过计算任意两个属性之间的条件互信息来确定属性间依赖关系的网络结构。生成过程如下：

1. 计算任意两个属性之间的条件互信息 $I(x_i, x_j \mid y) = \sum_{x_i,x_j\in\mathcal{Y}} P(x_i,x_j \mid c)\log\dfrac{P(x_i,x_j \mid c)}{P(x_i \mid c)P(x_j \mid c)}$；
2. 以属性为结点构建完全图，任意两个结点之间边的权重设为 $I(x_i,x_j \mid y)$；
3. 构建此完全图的最大带权生成树，挑选根变量，将边置为有向；
4. 加入类别结点 $y$，增加从 $y$ 到每个属性的有向边。

需要注意，通过最大生成树算法，TAN 实际上仅保留了强相关属性之间的依赖性。

AODE/Averaged One-Dependent Estimator 基于继承学习，其尝试将每个属性作为超父来构建 SPODE，然后将那些具有足够训练数据支持的 SPODE 集成起来作为最终结果。

$$P(c \mid \boldsymbol{x}) \propto \sum_{i=1,|D_{x_i}|\geq m'}^d P(c,x_i)\prod_{j=1}^d P(x_j \mid c,x_i).$$

其中 $D_{x_i}$ 是在第 $i$ 个属性上取值为 $x_i$ 的样本集合，$m'$ 为阈值常数。显然，AODE 需估计 $P(c,x_i)$ 和 $P(x_j \mid c,x_i)$：

$$\hat{P}(c,x_i) = \frac{|D_{c,x_i}| + 1}{|D| + N_i}, \quad \hat{P}(x_j \mid c,x_i) = \frac{|D_{c,x_i,x_j}| + 1}{|D_{c,x_i}| + N_j}.$$

其中 $N_i$ 是第 $i$ 个属性可能的取值数，$D_{c,x_i}$ 是类别为 $c$ 且在第 $i$ 个属性上取值为 $x_i$ 的样本集合，$D_{c,x_i,x_j}$ 是类别为 $c$ 且在第 $i$ 和第 $j$ 个属性上取值分别为 $x_i$ 和 $x_j$ 的样本集合。

若期冀考虑属性间的高阶依赖来进一步提升泛化性能，也就是将父属性 $pa_i$ 推广成包含 $k$ 个属性的高阶依赖 $\boldsymbol{pa}_k$，从而将 ODE 推广为 $k$DE。然而，随着 $k$ 的增加，准确估计概率 $P(x_i \mid c,\boldsymbol{pa}_k)$ 所需的训练样本数量将以指数级增加。因此，若训练数据非常充分，泛化性能有可能提升；但在有限样本条件下，则又陷入估计高阶联合概率的泥潭。

## 5. 贝叶斯网

贝叶斯网/Bayesian Network 是一种经典的概率图模型。借助有向无环图/Directed Acyclic Graph 刻画属性之间的依赖关系，并使用条件概率表/Conditional Probability Table 描述属性的联合概率分布。

一个贝叶斯网 $B$ 由结构 $G$ 和参数 $\Theta$ 两部分构成，即 $B = \langle G,\Theta \rangle$；网络结构 $G$ 是一个有向无环图，其每个结点对应于一个属性，若两个属性有直接依赖关系，则它们由一条边连接起来；参数 $\Theta$ 定量描述这种依赖关系，假设属性 $x_i$ 在 $G$ 中的父结点集为 $\pi_i$，则 $\Theta$ 包含了每个属性的条件概率表 $\theta_{x_i|\pi_i} = P_B(x_i \mid \pi_i)$。

<img class="center-picture" src="./assets/7-2.webp" width="600" />

### 5.1 结构
 
给定父节点集，贝叶斯网假设每个属性与它的非后裔属性独立，给定 $B = \langle G,\Theta \rangle$，属性 $x_1,x_2,\ldots,x_d$ 的联合概率分布定义为：

$$P_B(x_1,x_2,\ldots,x_d) = \prod_{i=1}^d P_B(x_i \mid \pi_i) = \prod_{i=1}^d \theta_{x_i|\pi_i}.$$

上图的贝叶斯网定义了联合概率分布：

$$P(x_1,x_2,x_3,x_4,x_5) = P(x_1)P(x_2)P(x_3 \mid x_1)P(x_4 \mid x_1,x_2)P(x_5 \mid x_2).$$

显然，$x_3$ 和 $x_4$ 在给定 $x_1$ 的取值时独立，$x_4$ 和 $x_5$ 在给定 $x_2$ 的取值时独立，分别记为 $x_3 \perp x_4 \mid x_1$ 和 $x_4 \perp x_5 \mid x_2$。

注意到即使这样的联合概率分布定义直观上违背概率论中联合概率分布的定义，但是我们应用属性条件独立性假设（在给定父节点集的时候，每个属性和非后裔属性独立），可以验证这样的定义是妥当的。

<img class="center-picture" src="./assets/7-3.webp" width="600" />

上图显示出了贝叶斯网中三个变量之间的典型依赖关系，其中同父结构和顺序结构在联合概率分布的定义中已经有所体现。在同父结构中，给定父节点 $x_1$ 的取值，则 $x_3$ 和 $x_4$ 条件独立；在顺序结构中，给定 $x$ 的值，则 $y$ 和 $z$ 条件独立。V 型结构也称为冲撞结构，给定子节点 $x_4$ 的取值，$x_1$ 和 $x_2$ **必不独立**。奇妙的是，若 $x_4$ 的取值**完全未知**，则 V 型结构下 $x_1$ 和 $x_2$ 却是相互独立的。这样的独立性称为边际独立性/Marginal Independence，记为 $x_1 \parallel x_2$。

!!! Info "其实这个符号应该是 MnSymbol 宏包中的 \Vbar，但是 KaTeX 不支持这个宏包，所以这里用 \parallel 代替。"

事实上，一个变量取值的确定与否，能对另外两个变量的独立性发生影响，这个现象并非 V 型结构所特有。例如在同父结构中，条件独立性 $x_3 \perp x_4 \mid x_1$ 成立，但若 $x_1$ 的取值未知，则 $x_3$ 和 $x_4$ 就不独立，即 $x_3\parallel x_4$ 不成立；在顺序结构中，$y \perp z \mid x$ 成立，但 $y\parallel z$ 不成立。

为了分析有向图中变量间的条件独立性，可使用有向分离/D-separation。我们把有向图转换为一个无向图：

- 找出有向图中的所有 V 型结构，在 V 型结构的两个父结点之间加上一条无向边；
- 将所有有向边改为无向边。

由此产生的无向图称为道德图/Moral Graph，令父结点相连的过程称为道德化/Moralization。基于道德图可以直观、迅速地找到变量间的条件独立性。假定道德图中有变量 $x_i$ 和变量集合 $\boldsymbol{z} = \{z_i\}$，若变量 $x$ 和 $y$ 能在图上被 $\boldsymbol{z}$ 分开，即从图上将 $\boldsymbol{z}$ 结点去除后，$x$ 和 $y$ 分属两个连通分支，则称变量 $x$ 和 $y$ 被 $\boldsymbol{z}$ 有向分离。

<img class="center-picture" src="./assets/7-4.webp" width="400" />

在上述道德图中，从图中能容易地找出所有的条件独立关系：$x_3 \perp x_4 \mid x_1$，$x_4 \perp x_5 \mid x_2$，$x_3 \perp x_2 \mid x_1$，$x_3 \perp x_5 \mid x_1$，$x_3 \perp x_5 \mid x_2$ 等。

### 5.2 学习

若网络结构已知，也就是属性之间的依赖关系已知，则只需要对训练样本计数，并且估计出每个节点的条件概率表就可以了。当我们不知道网络结构的时候，我们往往采用评分搜索/Scoring Search 来找出结构最恰当的贝叶斯网。我们首先定义一个评分函数/Score Function，以此来评估贝叶斯网与训练数据的契合程度，然后基于这个评分函数来寻找结构最优的贝叶斯网。评分函数引入了关于我们希望获得什么样的贝叶斯网的归纳偏好。

常用评分函数通常基于信息论准则，此类准则将学习问题看作一个数据压缩任务，学习的目标是找到一个能以最短编码长度描述训练数据的模型，此时编码的长度包括了描述模型自身所需的字节长度和使用该模型描述数据所需的字节长度。

对贝叶斯网学习而言，模型就是一个贝叶斯网，同时，每个贝叶斯网描述了一个在训练数据上的概率分布，自有一套编码机制能使那些经常出现的样本有更短的编码。于是，我们应选择那个综合编码长度（包括描述网络和编码数据）最短的贝叶斯网，这就是最小描述长度/Minimal Description Length，简称 MDL 准则。

给定训练集 $D = \{\boldsymbol{x}_1,\boldsymbol{x}_2,\ldots,\boldsymbol{x}_m\}$，贝叶斯网 $B = \langle G,\Theta\rangle$ 在 $D$ 上的评分函数可写为：

$$s(B \mid D) = f(\theta)|B| - LL(B \mid D),$$

其中 $|B|$ 是贝叶斯网的参数个数，$f(\theta)$ 表示描述每个参数 $\theta$ 所需的字节数，$LL(B \mid D) = \sum\limits_{i=1}^m \log P_B(\boldsymbol{x}_i)$ 是贝叶斯网 $B$ 的对数似然。显然，评分函数 $s(B \mid D)$ 的第一项是计算编码贝叶斯网 $B$ 所需的字节数，第二项是计算 $B$ 所对应的概率分布 $P_B$ 需多少字节来描述 $D$。于是，学习任务就转化为一个优化任务，即寻找一个贝叶斯网 $B$ 使评分函数 $s(B \mid D)$ 最小。

- 如果 $f(\theta) = 1$，即每个参数用 1 字节描述，则得到 AIC/Akaike Information Criterion 评分函数：$\text{AIC}(B \mid D) = |B| - LL(B \mid D)$；
- 如果 $f(\theta) = \frac{1}{2}\log m$，即每个参数用 $\frac{1}{2}\log m$ 字节描述，则得到 BIC/Bayesian Information Criterion 评分函数：$\text{BIC}(B \mid D) = \frac{\log m}{2}|B| - LL(B \mid D)$。
- 若 $f(\theta) = 0$，即不计算对网络进行编码的长度，则评分函数退化为负对数似然，相应的，学习任务退化为极大似然估计。
- 若网络结构 $G$ 固定，则评分函数 $s(B \mid D)$ 的第一项为常数。此时，最小化 $s(B \mid D)$ 等价于对参数 $\Theta$ 的极大似然估计。

在计算对数似然的时候，参数 $\theta_{x_i|\pi_i}$ 可以直接在训练数据 $D$ 上通过经验估计得到，也就是

$$\theta_{x_i|\pi_i} = \hat{P}_D(x_i \mid \pi_i),$$

其中 $\hat{P}_D(\cdot)$ 是 $D$ 上的经验分布。因此，为了最小化评分函数 $s(B \mid D)$，只需对网络结构进行搜索，而候选结构的最优参数可直接在训练集上计算得到。

从可能的网络结构空间搜索最优贝叶斯网是一个 $\mathsf{NP}$ 难问题，有两种常用的策略能在有限时间内求得近似解：第一种是贪心法，例如从某个网络结构出发，每次调整一条边（增加、删除或调整方向），直到评分函数值不再降低为止；第二种是通过给网络结构施加约束来削减搜索空间，例如将网络结构限定为树形结构（TAN，半朴素贝叶斯分类器可以看作贝叶斯网的特例）等。
 
### 5.3 推断

贝叶斯网络训练好了之后就可以回答查询/Query，即通过一些属性变量的观测值来推测其他属性变量的取值。这种通过已知变量观测值来推测待查询变量的过程称为推断/Inference，已知变量观测值称为证据/Evidence。

最理想的是通过贝叶斯网定义的联合概率分布来精确计算后验概率，不幸的是，这样的精确推断已被证明是 $\mathsf{NP}$ 难的；换言之，当网络结点较多、连接稠密时，难以进行精确推断，此时需要借助近似推断，通过降低精度要求，在有限时间内求得近似解。在现实应用中，贝叶斯网的近似推断常使用吉布斯采样/Gibbs Sampling 来完成，这是一种随机采样方法。

记 $\mathbf{Q} = \{Q_1,Q_2,\ldots,Q_n\}$ 表示待查询变量，$\mathbf{E} = \{E_1,E_2,\ldots,E_k\}$ 为证据变量，已知其取值为 $\mathbf{e} = \{e_1,e_2,\ldots,e_k\}$。目标是计算后验概率 $P(\mathbf{Q} = \mathbf{q} \mid \mathbf{E} = \mathbf{e})$，其中 $\mathbf{q} = \{q_1,q_2,\ldots,q_n\}$ 是待查询变量的一组取值。以西瓜问题为例，我们希望在得知色泽为青绿、敲声为沉闷、根蒂为蜷缩的情况下，推断这是好瓜且甜度高的概率。

吉布斯采样算法的过程如下：先随机产生一个与证据 $\mathbf{E} = \mathbf{e}$ 一致的样本 $\mathbf{q}^0$ 作为初始点，然后每步从当前样本出发产生下一个样本。经过 $T$ 次采样得到的与 $\mathbf{q}$ 一致的样本共有 $n_q$ 个，则可近似估算出后验概率：

$$P(\mathbf{Q} = \mathbf{q} \mid \mathbf{E} = \mathbf{e}) \simeq \frac{n_q}{T}.$$

重点在于如何从当前样本出发产生下一个样本：在第 $t$ 次采样中，算法先假设 $\mathbf{q}^t = \mathbf{q}^{t-1}$，然后对非证据变量逐个进行采样改变其取值，采样概率根据贝叶斯网 $B$ 和其他变量的当前取值计算获得。这是一个马尔可夫链，无论从什么初始状态开始，马尔可夫链第 $t$ 步的状态分布在 $t \to \infty$ 时会收敛到后验概率分布（若贝叶斯网中存在极端概率 0 或者 1，则不能保证马尔可夫链存在平稳分布，这时候吉布斯采样会给出错误的结果）。

<img class="center-picture" src="./assets/7-5.webp" width="690" />

## 6. EM 算法

在前面的讨论中，我们一直假设训练样本本所有属性变量的值都已被观测到，即训练样本是完整的，但是在现实应用中往往会遇到不完整的训练样本，例如由于西瓜的根蒂已脱落，无法看出是蜷缩还是硬挺，这种在训练样本中的未观测变量称为隐变量/Latent Variable。令 $\mathbf{X}$ 表示已观测变量集，$\mathbf{Z}$ 表示隐变量集，$\Theta$ 表示模型参数。若欲对 $\Theta$ 做极大似然估计，则应最大化对数似然：

$$LL(\Theta \mid \mathbf{X}, \mathbf{Z}) = \ln P(\mathbf{X}, \mathbf{Z} \mid \Theta).$$

然而由于 $\mathbf{Z}$ 是隐变量，上式无法直接求解。此时我们可通过对 $\mathbf{Z}$ 计算期望，来最大化已观测数据的对数边际似然：

$$LL(\Theta \mid \mathbf{X}) = \ln P(\mathbf{X} \mid \Theta) = \ln \sum_{\mathbf{Z}} P(\mathbf{X}, \mathbf{Z} \mid \Theta).$$

EM/Epectation-Maximization 是常见的估计隐变量模型参数的方法。EM 算法是一个迭代式的方法，其基本思想是：若参数 $\Theta$ 已知，则可根据训练数据推断出最优隐变量 $\mathbf{Z}$ 的值；反之，若 $\mathbf{Z}$ 的值已知，则可方便地对参数 $\Theta$ 做极大似然估计。下面的过程就是 EM 算法的原型：

1. 初始化参数 $\Theta^0$；
2. 重复直至收敛：
    - 以当前参数 $\Theta^t$ 推断隐变量 $\mathbf{Z}$ 的期望，记为 $\mathbf{Z}^t$；
    - 基于仪观测变量 $\mathbf{X}$ 和隐变量 $\mathbf{Z}^t$，更新参数 $\Theta^{t+1}$。

若我们不是取 $\mathbf{Z}$ 的期望，而是基于 $\Theta^t$ 计算隐变量 $\mathbf{Z}$ 的概率分布 $P(\mathbf{Z} \mid \mathbf{X}, \Theta^t)$，则 EM 算法的两个步骤是：

- E 步/Expectation：以当前参数 $\Theta^t$ 推断隐变量分布 $P(\mathbf{Z} \mid \mathbf{X}, \Theta^t)$，并计算对数似然 $LL(\Theta \mid \mathbf{X}, \mathbf{Z})$ 关于 $\mathbf{Z}$ 的期望
    
    $$Q(\Theta \mid \Theta^t) = \mathbb{E}_{\mathbf{Z}|\mathbf{X},\Theta^t} LL(\Theta \mid \mathbf{X}, \mathbf{Z}) = \sum_{\mathbf{Z}} P(\mathbf{Z} \mid \mathbf{X}, \Theta^t) \ln P(\mathbf{X}, \mathbf{Z} \mid \Theta);$$

- M 步/Maximization：寻找参数最大化期望似然，即

    $$\Theta^{t+1} = \mathop{\arg\max}_{\Theta} Q(\Theta \mid \Theta^t).$$

EM 算法为一种非梯度优化方法，通过两个步骤交替计算，直至收敛到局部最优解，相对来说计算复杂度较低。
