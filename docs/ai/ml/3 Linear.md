# Chapter 3: 线性模型

## 1. 基本形式

## 2. 线性回归

## 3. 对数几率回归

对于二分类问题，我们有：

$$\begin{aligned}
&p(y=1|x) = \frac{e^{w^\mathrm{T}x+b}}{1+e^{w^\mathrm{T}x+b}},\\ &p(y=0|x) = \frac{1}{1+e^{w^\mathrm{T}x+b}}.
\end{aligned}$$

于是，我们可以通过最大似然法/Maximum Likelihood Method 来估计 $w$ 和 $b$。给定数据集 $\{(x_i,y_i)\}_{i=1}^m$，对率回归模型最大化对数似然/log-Likelihood：

$$\ell(w,b) = \sum_{i=1}^m\ln p(y_i|x_i;w,b)$$

即令每个样本属于其真实标记的概率越大越好。为便于讨论，令 $\beta = (w;b)$，$\hat{x} = (x;1)$，则 $w^\mathrm{T}x+b$ 可简写为 $\beta^\mathrm{T}\hat{x}$。再令 $p_1(\hat{x};\beta) = p(y=1|\hat{x};\beta)$，$p_0(\hat{x};\beta) = p(y=0|\hat{x};\beta) = 1-p_1(\hat{x};\beta)$，则式(3.25)中的对数似然项可重写为：

$$p(y_i|x_i;w,b) = y_ip_1(\hat{x}_i;\beta) + (1-y_i)p_0(\hat{x}_i;\beta)$$

将式(3.26)代入(3.25)，并根据式(3.23)和(3.24)可知，最大化式(3.25)等价于最小化：

$$\begin{aligned}
    \ell(\beta) &= \sum_{i=1}^m\ln\left(y_ip_1(\hat{x}_i;\beta) + (1-y_i)p_0(\hat{x}_i;\beta)\right)\\
    &= \sum_{i=1}^m\left[\ln(y_ie^{\beta^\mathrm{T}\hat{x}_i} + (1-y_i)) - \ln(1+e^{\beta^\mathrm{T}\hat{x}_i})\right]\\
    &= \sum_{i=1}^m\left(-y_i\beta^\mathrm{T}\hat{x}_i + \ln(1+e^{\beta^\mathrm{T}\hat{x}_i})\right)
\end{aligned}$$

其中第一个等号和第二个等号都是通过直接带入对应定义得到的，第三个等号通过对 $y_i$ 取值的分析得到，考虑到 $y_i$ 只能取 0 或者 1:

- 当 $y_i=1$ 时，$\ln(y_ie^{\beta^\mathrm{T}\hat{x}_i} + (1-y_i)) = \ln(e^{\beta^\mathrm{T}\hat{x}_i}) = y_i\beta^\mathrm{T}\hat{x}_i$；
- 当 $y_i=0$ 时，$\ln(y_ie^{\beta^\mathrm{T}\hat{x}_i} + (1-y_i)) = \ln1 = 0 = y_i\beta^{T}\hat{x}_i$。

## 4. 线性判别分析

线性判别分析的思想非常朴素：将样例投影到一条直线上，使得同类样例的投影点尽可能接近，异类样例的投影点尽可能远离。对新的样本进行分类的时候，将其投影到直线上，再根据投影点的位置进行判别。

给定数据集 $D = \{(\boldsymbol{x}_i,y_i)\}_{i=1}^m$，$y_i \in \{0,1\}$，令：

- $\boldsymbol{X}_i$ 表示第 $i \in \{0,1\}$ 类示例的集合
- $\boldsymbol{\mu}_i$ 表示第 $i$ 类示例的均值向量
- $\boldsymbol{\Sigma}_i$ 表示第 $i$ 类示例的协方差矩阵

若将所有样本投影到直线 $\boldsymbol{w}$ 上：

- 两类样本的中心在直线上的投影分别为 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_0$ 和 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_1$
- 所有样本都投影到直线上后，两类样本的协方差分别为 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_0\boldsymbol{w}$ 和 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_1\boldsymbol{w}$
- 由于直线是一维空间，因此 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_0$、$\boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_1$、$\boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_0\boldsymbol{w}$ 和 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_1\boldsymbol{w}$ 均为实数。

我们一是希望同类样例的投影点尽可能接近，可以让同类样例的投影点的协方差尽可能小，也就是让 $\boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_0\boldsymbol{w} + \boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_1\boldsymbol{w}$ 尽可能小；二是希望异类样例的投影点尽可能远离，可以让两类样例的中心之间的距离尽可能大，也就是让 $\lVert\boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_0 - \boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_1\rVert^2_2$ 尽可能大。也就是希望最大化：

$$J = \frac{\lVert\boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_0 - \boldsymbol{w}^\mathrm{T}\boldsymbol{\mu}_1\rVert^2_2}{\boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_0\boldsymbol{w} + \boldsymbol{w}^\mathrm{T}\boldsymbol{\Sigma}_1\boldsymbol{w}} = \frac{\boldsymbol{w}^{\mathrm{T}} (\boldsymbol{\mu}_0 - \boldsymbol{\mu}_1)(\boldsymbol{\mu}_0 - \boldsymbol{\mu}_1)^\mathrm{T} \boldsymbol{w}}{\boldsymbol{w}^\mathrm{T} (\boldsymbol{\Sigma}_0 + \boldsymbol{\Sigma}_1) \boldsymbol{w}}$$

定义：

- 类内散度矩阵/Within-Class Scatter Matrix：$\boldsymbol{S}_w = \boldsymbol{\Sigma}_0 + \boldsymbol{\Sigma}_1 = \sum_{\boldsymbol{x}\in\boldsymbol{X}_0}(\boldsymbol{x}-\boldsymbol{\mu}_0)(\boldsymbol{x}-\boldsymbol{\mu}_0)^\mathrm{T} + \sum_{\boldsymbol{x}\in\boldsymbol{X}_1}(\boldsymbol{x}-\boldsymbol{\mu}_1)(\boldsymbol{x}-\boldsymbol{\mu}_1)^\mathrm{T}$
- 类间散度矩阵/Between-Class Scatter Matrix：$\boldsymbol{S}_b = (\boldsymbol{\mu}_0-\boldsymbol{\mu}_1)(\boldsymbol{\mu}_0-\boldsymbol{\mu}_1)^\mathrm{T}$

则优化目标可重写为：

$$\max_{\boldsymbol{w}} J(\boldsymbol{w}) = \frac{\boldsymbol{w}^\mathrm{T}\boldsymbol{S}_b\boldsymbol{w}}{\boldsymbol{w}^\mathrm{T}\boldsymbol{S}_w\boldsymbol{w}}$$

这就是 LDA 欲最大化的目标，即 $\boldsymbol{S}_b$ 与 $\boldsymbol{S}_w$ 的广义瑞利商/Generalized Rayleigh Quotient。




<!-- 
https://zhuanlan.zhihu.com/p/32658341
https://www.cnblogs.com/jerrylead/archive/2011/04/21/2024384.html-->

## 5. 多分类学习

## 6. 类别不平衡问题
