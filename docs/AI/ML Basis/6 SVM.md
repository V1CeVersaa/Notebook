# Chapter 6: 支持向量机

## 1. 间隔与支持向量

给定训练样本集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2), \ldots, (\boldsymbol{x}_m, y_m)\}$，其中 $\boldsymbol{x}_i \in \mathcal{X} \subseteq \mathbb{R}^n$，$y_i \in \mathcal{Y} = \{+1, -1\}$。分类学习最基本的想法是基于训练集 $D$ 在样本空间中找到一个划分超平面，将不同类别的样本分开。

直观上看，应该在两类训练样本正中间划分超平面，因为这样的超平面对于训练样本局部扰动的容忍度最好，对未见示例的泛化能力最强。在样本空间中，划分超平面可以由如下线性方程描述：

$$\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x} + b = 0.$$

其中 $\boldsymbol{w} = (w_1; w_2; \ldots; w_d)$ 为法向量，决定了超平面的方向；$b$ 为位移项，决定了超平面与原点之间的距离。显然，划分超平面可以由法向量 $\boldsymbol{w}$ 和位移 $b$ 确定。样本空间内任意点 $\boldsymbol{x}$ 到超平面 $(\boldsymbol{w}, b)$ 的距离可写为：

$$r = \frac{|\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x} + b|}{\lVert\boldsymbol{w}\rVert}.$$

假设超平面 $(\boldsymbol{w}, b)$ 能将训练样本正确分类，即对于 $(\boldsymbol{x}_i, y_i) \in D$，若 $y_i = +1$，则有 $\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b > 0$；若 $y_i = -1$，则有 $\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b < 0$。我们令

$$\begin{cases}
    \boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b \geq +1, & y_i = +1, \\
    \boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b \leq -1, & y_i = -1.
\end{cases}$$

只有距离超平面最近的几个训练样本使得上式的等号成立，它们被称为**支持向量/Supporting Vectors**。两个异类支持向量到超平面的距离之和为

$$\gamma = \frac{2}{\lVert\boldsymbol{w}\rVert}.$$

它被称为**间隔/Margin**。

<img class="center-picture" src="./assets/6-1.webp" width="550"/>

为了找到具有最大间隔的划分超平面，我们需要找到能满足上式约束的参数 $\boldsymbol{w}$ 和 $b$，使得 $\gamma$ 最大，即求解下面优化问题：

$$\begin{aligned}
    &\max_{\boldsymbol{w}, b} \frac{2}{\lVert\boldsymbol{w}\rVert}, \\
    &\text{s.t.} \quad y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b) \geq 1, \quad i = 1, 2, \ldots, m.
\end{aligned}$$

显然，为了最大化间隔，仅需最大化 $\lVert\boldsymbol{w}\rVert^{-1}$，等价于最小化 $\lVert\boldsymbol{w}\rVert^2$。于是，上面的优化问题可以重写为：

$$\begin{aligned}
    &\min_{\boldsymbol{w}, b} \frac{1}{2}\lVert\boldsymbol{w}\rVert^2, \\
    &\text{s.t.} \quad y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b) \geq 1, \quad i = 1, 2, \ldots, m.
\end{aligned}$$

这就是**支持向量机/Support Vector Machine**的基本型。

## 2. 对偶问题

对上述问题使用拉格朗日乘子法，为每条约束添加拉格朗日乘子 $\alpha_i \geq 0$，定义拉格朗日函数：

$$L(\boldsymbol{w}, b, \boldsymbol{\alpha}) = \frac{1}{2}\lVert\boldsymbol{w}\rVert^2 - \sum_{i=1}^{m}\alpha_i\left(y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b) - 1\right) = \frac{1}{2}\lVert\boldsymbol{w}\rVert^2 + \sum_{i=1}^{m}\alpha_i\left(1 - y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b)\right).$$

其中 $\boldsymbol{\alpha} = (\alpha_1; \alpha_2; \ldots; \alpha_m)$。这样我们的优化目标就变成了

$$\min_{\boldsymbol{w}, b} \max_{\boldsymbol{\alpha}} L(\boldsymbol{w}, b, \boldsymbol{\alpha}).$$

令 $L(\boldsymbol{w}, b, \boldsymbol{\alpha})$ 对 $\boldsymbol{w}$ 和 $b$ 的偏导为零可得：

$$\boldsymbol{w} = \sum_{i=1}^{m}\alpha_iy_i\boldsymbol{x}_i, \quad 0 = \sum_{i=1}^{m}\alpha_iy_i.$$

直接代入进去，将 $L(\boldsymbol{w},b,\boldsymbol{\alpha})$ 中的 $\boldsymbol{w}$ 和 $b$ 消去，我们就得到了对应拉格朗日函数的对偶问题：

$$\begin{aligned}
    &\max\limits_{\boldsymbol{\alpha}}\sum_{i=1}^{m}\alpha_i - \frac{1}{2}\sum_{i=1}^{m}\sum_{j=1}^m\alpha_i\alpha_jy_iy_j\boldsymbol{x}_i^{\mathrm{T}}\boldsymbol{x}_j \\ 
    &\text{s.t.} \quad \sum_{i=1}^{m}\alpha_iy_i = 0, \\
    &\qquad \enspace \alpha_i \geq 0, \quad i = 1, 2, \ldots, m.
\end{aligned}$$

解出拉格朗日乘子 $\boldsymbol{\alpha}$ 后，求出 $\boldsymbol{w}$ 与 $b$ 即可得到模型：

$$f(\boldsymbol{x}) = \boldsymbol{w}^{\mathrm{T}}\boldsymbol{x} + b = \sum_{i=1}^m \alpha_iy_i\boldsymbol{x}_i^{\mathrm{T}}\boldsymbol{x} + b.$$

上述过程需要满足 KKT/Karush-Kuhn-Tucker 条件：

$$\begin{cases}
    \alpha_i &\geq 0, \\
    y_i(f(\boldsymbol{x}_i)) - 1 = y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b) - 1 &\geq 0, \\
    \alpha_i(y_i(f(\boldsymbol{x}_i)) - 1) = \alpha_i(y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b) - 1) &= 0.
\end{cases}$$

因此，对任意训练样本 $(\boldsymbol{x}_i, y_i)$，总有 $\alpha_i = 0$ 或 $y_i(f(\boldsymbol{x}_i)) = 1$。若 $\alpha_i = 0$，则该样本将不会在模型中出现，因此不会对 $f(\boldsymbol{x})$ 有任何影响；若 $\alpha_i > 0$，则必有 $y_i(f(\boldsymbol{x}_i)) = 1$，所对应的样本点位于最大间隔边界上，是一个支持向量。

支持向量机的一个重要性质是：训练完成后，大部分的训练样本都不需要保留，最终模型仅与支持向量有关。

上面的对偶问题是一个二次规划问题，可以使用通用的二次规划算法求解。但是问题规模正比于训练样本数目，开销因此很大，下面简单介绍一下 SMO/Sequential Minimal Optimization 算法。

SMO 算法的基本思路是固定除了两个变量之外的所有变量，然后对其进行优化。在参数初始化之后，SMO 算法会不断执行以下两个步骤直到收敛：

- 选择一对需要更新的变量 $\alpha_i$ 和 $\alpha_j$；
- 固定其余变量，求解对偶问题，获得更新后的 $\alpha_i$ 和 $\alpha_j$。

仅仅优化两个变量的过程可以做到非常高效：对偶问题的约束条件可以重新写成：

$$\alpha_iy_i + \alpha_jy_j = c = -\sum_{k\neq i,j}\alpha_ky_k \text{, where } \alpha_i \geq 0, \alpha_j \geq 0.$$

使用上式消去变量 $\alpha_j$，就得到了一个关于 $\alpha_i$ 的单变量二次规划问题，仅有的约束是 $\alpha_i \geq 0$，这样的二次规划具有闭式解，于是不必调用数值算法就可以高效计算出 $\alpha_i$ 和 $\alpha_j$。

下面确定偏移量 $b$，注意到对任何支持向量 $(\boldsymbol{x}_s, y_s)$ 都有 $y_sf(\boldsymbol{x}_s) = 1$，也就是：

$$y_s\left(\sum_{i\in S}\alpha_iy_i\boldsymbol{x}_i^{\mathrm{T}}\boldsymbol{x}_s + b\right) = 1.$$

其中 $S = \{i \mid \alpha_i > 0, i = 1, 2, \ldots, m\}$ 为所有支持向量的下标集，理论上可以选择任意支持向量来求解 $b$，但是为了提高稳定性，我们选择所有支持向量的平均值：

$$b = \frac{1}{|S|}\sum_{i\in S}\left(y_i - \sum_{j\in S}\alpha_jy_j\boldsymbol{x}_j^{\mathrm{T}}\boldsymbol{x}_i\right).$$

SMO 算法还有一个问题：如何选取 $\alpha_i$ 和 $\alpha_j$ 使得算法高效？如果选取的 $\alpha_i$ 和 $\alpha_j$ 中有一个不满足 KKT 条件，那么目标函数就会在迭代后减小，直观上看，KKT 条件违反的程度越大，变量更新后可能导致的目标函数减小越大，因此我们先选择违反 KKT 条件最严重的 $\alpha_i$，然后选择使得目标函数减小最多的 $\alpha_j$。但是这样搜索复杂度太高，因此我们可以使用启发式方法，例如：使选取的两个变量对应的样本之间的距离最大。一种直观的解释是这样的两个变量会有很大的差别，与对两个相似的变量进行更新对比，对其更新会带给目标函数值更大的变化。

## 3. 核函数

前面我们一直假设训练样本是**线性可分**的，也就是存在一个划分超平面可以使得训练样本正确分类，但是很有可能原样本空间内不存在一个能正确划分两类样本的超平面，这时我们可以考虑将样本映射到一个更高维的特征空间，使得样本在特征空间中是线性可分的。

有一个重要性质：如果原始空间是有限维的，那么一定存在一个高维特征空间使得样本可分。

令 $\phi(\boldsymbol{x})$ 是将 $\boldsymbol{x}$ 映射后的特征向量，我们在特征空间划分超平面对应的模型可以表示为：

$$f(\boldsymbol{x}) = \boldsymbol{w}^{\mathrm{T}}\phi(\boldsymbol{x}) + b.$$

其中 $\boldsymbol{w}$ 和 $b$ 是模型参数，类似上一节的想法，我们可以得到优化问题：

$$\begin{aligned}
    &\min_{\boldsymbol{w}, b} \frac{1}{2}\lVert\boldsymbol{w}\rVert^2, \\
    &\text{s.t.} \quad y_i(\boldsymbol{w}^{\mathrm{T}}\phi(\boldsymbol{x}_i) + b) \geq 1, \quad i = 1, 2, \ldots, m.
\end{aligned}$$

其对偶问题是：

$$\begin{aligned}
    &\max_{\boldsymbol{\alpha}} \sum_{i=1}^m \alpha_i - \frac{1}{2}\sum_{i=1}^m\sum_{j=1}^m\alpha_i\alpha_jy_iy_j\phi(\boldsymbol{x}_i)^{\mathrm{T}}\phi(\boldsymbol{x}_j) \\
    &\text{s.t.} \quad \sum_{i=1}^m \alpha_iy_i = 0, \\
    &\qquad \enspace \alpha_i \geq 0, \quad i=1,2,\ldots,m.
\end{aligned}$$

求解这样的优化问题需要计算 $\phi(\boldsymbol{x}_i)^{\mathrm{T}}\phi(\boldsymbol{x}_j)$，这是样本 $\boldsymbol{x}_i$ 与 $\boldsymbol{x}_j$ 映射到特征空间之后的内积。由于特征空间维数可能很高，甚至可能是无穷维，因此直接计算 $\phi(\boldsymbol{x}_i)^{\mathrm{T}}\phi(\boldsymbol{x}_j)$ 通常是困难的。为了避开这个障碍，可以设想这样一个函数 $\kappa$，使得可以直接在原始空间通过 $\kappa(\cdot, \cdot)$ 计算两个样本在特征空间的内积：

$$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \langle\phi(\boldsymbol{x}_i),\phi(\boldsymbol{x}_j)\rangle = \phi(\boldsymbol{x}_i)^{\mathrm{T}}\phi(\boldsymbol{x}_j).$$

因此我们的优化问题的目标函数可以重写为：

$$\max_{\boldsymbol{\alpha}} \sum_{i=1}^m \alpha_i - \frac{1}{2}\sum_{i=1}^m\sum_{j=1}^m\alpha_i\alpha_jy_iy_j\kappa(\boldsymbol{x}_i,\boldsymbol{x}_j).$$

求解后即可得到：

$$f(\boldsymbol{x}) = \boldsymbol{w}^{\mathrm{T}}\phi(\boldsymbol{x}) + b = \sum_{i=1}^m \alpha_iy_i\phi(\boldsymbol{x}_i)^{\mathrm{T}}\phi(\boldsymbol{x}) + b = \sum_{i=1}^m \alpha_iy_i\kappa(\boldsymbol{x}_i,\boldsymbol{x}) + b.$$

我们设想的函数 $\kappa(\cdot, \cdot)$ 称为**核函数/Kernel Function**。上式显示出模型最优解可以通过训练样本的核函数展开，这样的展开式也称为**支持向量展式/Support Vector Expansion**。

下面定理解决了现实问题中，核函数是否一定存在，以及什么样的函数能做核函数的问题：

**定理**：令 $\mathcal{X}$ 为输入空间，$\kappa(\cdot, \cdot)$ 为定义在 $\mathcal{X} \times \mathcal{X}$ 上的对称函数，则 $\kappa$ 为核函数当且仅当对于任意数据 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2), \ldots, (\boldsymbol{x}_m, y_m)\}$，对应的核矩阵 $\boldsymbol{K}$ 是半正定的：

$$\boldsymbol{K} = \begin{bmatrix}
    \kappa(\boldsymbol{x}_1, \boldsymbol{x}_1) & \kappa(\boldsymbol{x}_1, \boldsymbol{x}_2) & \cdots & \kappa(\boldsymbol{x}_1, \boldsymbol{x}_m) \\
    \kappa(\boldsymbol{x}_2, \boldsymbol{x}_1) & \kappa(\boldsymbol{x}_2, \boldsymbol{x}_2) & \cdots & \kappa(\boldsymbol{x}_2, \boldsymbol{x}_m) \\
    \vdots & \vdots & \ddots & \vdots \\
    \kappa(\boldsymbol{x}_m, \boldsymbol{x}_1) & \kappa(\boldsymbol{x}_m, \boldsymbol{x}_2) & \cdots & \kappa(\boldsymbol{x}_m, \boldsymbol{x}_m)
\end{bmatrix}.$$

下面是常见的核函数：

- 线性核：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \boldsymbol{x}_i^{\mathrm{T}}\boldsymbol{x}_j$；
- 多项式核：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = (\boldsymbol{x}_i^{\mathrm{T}}\boldsymbol{x}_j + 1)^d$，其中 $d\geq 1$ 为多项式的次数；
- 高斯核/RBF：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \exp\left(-\|\boldsymbol{x}_i - \boldsymbol{x}_j\|^2/2\sigma^2\right)$，其中 $\sigma > 0$ 为高斯核的带宽参数；
- 拉普拉斯核：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \exp\left(-\|\boldsymbol{x}_i - \boldsymbol{x}_j\|/\sigma\right)$，其中 $\sigma > 0$；
- Sigmoid 核：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \tanh(\beta\boldsymbol{x}_i^{\mathrm{T}}\boldsymbol{x}_j + \theta)$，其中 $\beta > 0, \theta < 0$。

核函数还可以通过组合得到，例如：

- 线性组合保持核函数的性质：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \sum_{k=1}^n\alpha_k\kappa_k(\boldsymbol{x}_i, \boldsymbol{x}_j)$；
- 直积保持核函数性质：$\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = \kappa_1\otimes\kappa_2(\boldsymbol{x}_i, \boldsymbol{x}_j)= \kappa_1(\boldsymbol{x}_i, \boldsymbol{x}_j)\kappa_2(\boldsymbol{x}_i, \boldsymbol{x}_j)$；
- 若 $\kappa_1$ 为核函数，对于任意函数 $g$，函数 $\kappa(\boldsymbol{x}_i, \boldsymbol{x}_j) = g(\boldsymbol{x}_i)\kappa_1(\boldsymbol{x}_i, \boldsymbol{x}_j)g(\boldsymbol{x}_j)$ 也是核函数。

## 4. 软间隔与正则化

前面讨论中，我们一直假定训练样本在样本空间或者特征空间中是线性可分的，但是在现实任务中很难找到合适的核函数是的训练样本在特征空间中线性可分，即使我们找到了某个核函数使得训练集在特征空间中线性可分，也很难说这个核函数是不是过拟合得到的。

一种方法是允许支持向量机在一些样本中出错，因此要引入软间隔/Soft Margin 的概念：

在软间隔的概念下，优化目标可以写为：

$$\min_{\boldsymbol{w}, b} \frac{1}{2}\|\boldsymbol{w}\|^2 + C\sum_{i=1}^m\ell_{0/1}\left(y_i(\boldsymbol{w}^{\mathrm{T}}\boldsymbol{x}_i + b)\right),$$

其中 $C > 0$ 是一个常数，$\ell_{0/1}$ 是 0/1 损失函数，即：

$$\ell_{0/1}(z) = \begin{cases}
    0, & z \geq 0, \\
    1, & z < 0.
\end{cases}$$

当 $C$ 趋近于无穷大时，软间隔问题就退化为硬间隔问题，迫使所有样本都满足约束，当 $C$ 取有限值的时候，就允许一些样本违反约束。

但是 0/1 损失函数非凸、不连续，数学性质不太好，因此我们可以使用一些别的函数代替 0/1 损失函数，称为替代损失/Surrogate Loss，这些函数通常是凸的连续函数，并且为 $\ell_{0/1}$ 的上界，例如：

- Hinge 损失：$\ell_{\text{hinge}}(z) = \max(0, 1 - z)$；
- 指数损失/Exponential Loss：$\ell_{\text{exp}}(z) = \exp(-z)$；
- 对率损失/Logistic Loss：$\ell_{\text{log}}(z) = \log(1 + \exp(-z))$。

## 5. 支持向量回归

## 6. 核方法

**定理（表示定理）**：令 $\mathbb{H}$ 为核函数 $\kappa$ 对应的再生核希尔伯特空间，$\lVert h\rVert_{\mathbb{H}}$ 为 $\mathbb{H}$ 空间中关于 $h$ 的范数，对于任意单调递增函数 $\Omega : [0, \infty] \mapsto \mathbb{R}$ 和任意非负损失函数 $\ell : \mathbb{R}^m \mapsto [0, \infty]$，优化问题

$$\min_{h\in\mathbb{H}} \enspace \Omega\left(\lVert h\rVert_{\mathbb{H}}\right) + \ell(h(\boldsymbol{x}_1), h(\boldsymbol{x}_2), \ldots, h(\boldsymbol{x}_m))$$

的解 $h^*$ 可以表示为

$$h^*(\boldsymbol{x}) = \sum_{i=1}^m\alpha_i\kappa(\boldsymbol{x}_i, \boldsymbol{x}),$$

表示定理对损失函数没有限制，对正则化项只限制为单调递增，甚至不要求凸函数，这意味着对于一般的损失函数和正则化项，上面的优化问题的最优解都可以表示成核函数 $\kappa(\boldsymbol{x}_i, \boldsymbol{x})$ 的线性组合。这就显示出核函数的巨大威力。因此人们发展出一系列根据核函数的学习方法，统称为核方法。最常见的就是通过引入核函数/核化将线性学习器拓展为非线性学习器。下面以核线性判别分析/Kernelized Linear Discriminant Analysis 为例，简单介绍核方法。
