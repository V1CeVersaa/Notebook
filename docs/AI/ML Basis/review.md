# 复习总结

## Decision Trees

决策树学习的目的是为了产出一棵泛化能力强的决策树。关键在于如何选择最优划分属性，我们期望随着划分过程的不断进行，决策树分支节点所包含的样本尽可能属于同一类别，也就是纯度不断提升。典型的属性划分方法包括：信息增益、信息增益率和基尼指数。

- 信息增益：使用信息熵/Information Entropy 可以度量样本集合纯度，若每一类所占的比例为 $p_k$，则信息熵定义为 $\mathrm{Ent}(D) = - \displaystyle\sum_{k=1}^{\lvert \mathcal{Y} \rvert} p_k \log_2 p_k$，信息熵越小，纯度越高。信息增益含义为，划分前后信息熵的减少量，定义为 $\mathrm{Gain}(D, a) = \mathrm{Ent}(D) - \displaystyle\sum_{v=1}^{V} \frac{\lvert D^v \rvert}{\lvert D \rvert} \mathrm{Ent}(D^v)$，其中 $D^v$ 表示在属性 $a$ 上取值为 $a_v$ 的样本子集。信息增益越大，代表划分之后的信息熵下降越多，纯度提升越大，因此选择信息增益最大的属性进行划分，这就是 ID3 算法的划分准则。但是，**信息增益偏向于取值较多的属性**。
- 信息增益率：为了解决信息增益偏向取值较多属性的问题，引入了信息增益率/Information Gain Ratio 作为划分准则。其想法是将信息增益进行归一化处理，归一化量为信息的固有值/Intrinsic Value，定义为 $\mathrm{IV}(a) = - \displaystyle\sum_{v=1}^{V} \frac{\lvert D^v \rvert}{\lvert D \rvert} \log_2 \frac{\lvert D^v \rvert}{\lvert D \rvert}$，属性数目越多，固有值越大。信息增益率定义为 $\mathrm{Gain\_Ratio}(D, a) = \mathrm{Gain}(D, a) / \mathrm{IV}(a)$，但是，**信息增益率偏向于取值较少的属性**。C4.5 算法结合了信息增益和信息增益率的优点，先选出信息增益率高于平均水平的属性，再从中选择信息增益最大的属性进行划分。
- 基尼指数：首先需要定义基尼值/Gini Value，表示从样本集中随机抽取两个样本，它们属于不同类别的概率，定义为 $\mathrm{Gini}(D) = \displaystyle\sum_{k=1}^{\lvert \mathcal{Y} \rvert} p_k \cdot (1 - p_k) = 1 - \sum_{k=1}^{\lvert \mathcal{Y} \rvert} p_k^2$。基尼指数据此
