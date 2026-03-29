# Chapter 3: 复杂度

对于有限维假设空间，我们可以直接使用假设的数目刻画空间的复杂度。但是，对于大多数学习问题来说，假设空间并非是有限的，因此无法直接使用假设的数目刻画空间复杂度，本节将介绍和数据分布 $\mathcal{D}$ 无关的 VC 维及其扩展 Natarajan 维，以及和数据分布 $\mathcal{D}$ 相关的 Rademacher 复杂度。

## 1. 数据分布无关

令 $\mathcal{H}$ 表示假设空间，其中的假设是从 $\mathcal{X}$ 到 $\mathcal{Y} = \{-1,+1\}$ 的映射，对于数据集 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\} \subset \mathcal{X}$，$\mathcal{H}$ 在数据集 $D$ 上的限制/Restriction 是从 $D$ 到 $\{-1,+1\}^m$ 的**一族映射**（也可以认为是 $m$ 维向量的集合）：

$$\mathcal{H}_{\mid D} = \{(h(\boldsymbol{x}_1),\ldots,h(\boldsymbol{x}_m))|h \in \mathcal{H}\},$$

其中 $h$ 在 $D$ 上的限制是一个 $m$ 维向量。

对于 $m \in \mathbb{N}$，假设空间 $\mathcal{H}$ 的**增长函数**/Growth Function $\Pi_{\mathcal{H}}(m)$ 表示为

$$\Pi_{\mathcal{H}}(m) = \max_{\{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}\subset\mathcal{X}}|\{(h(\boldsymbol{x}_1),\ldots,h(\boldsymbol{x}_m))|h \in \mathcal{H}\}|.$$

对于大小为 $m$ 的数据集 $D$，有

$$\Pi_{\mathcal{H}}(m) = \max_{|D|=m}|\mathcal{H}_{\mid D}|.$$

增长函数 $\Pi_{\mathcal{H}}(m)$ 表示假设空间 $\mathcal{H}$ 对 $m$ 个样本所能赋予标记的最大可能的结果数。$\mathcal{H}$ 对样本所能赋予标记的可能结果数越大，$\mathcal{H}$ 的表示能力越强，对学习任务的适应能力也越强。这样，增长函数就在一定程度上描述了假设空间 $\mathcal{H}$ 的表示能力，反映了假设空间的复杂程度。

<!-- 


假设空间 $\mathcal{H}$ 中不同的假设对 $D$ 中样本赋予标记的结果可能相同，也可能不同。尽管 $\mathcal{H}$ 可能包含无穷多个假设，但 $\mathcal{H}_{\mid D}$ 却是有限的，即 $\mathcal{H}$ 对 $D$ 中样本赋予标记的可能结果是有限的。例如对二分类问题，对 $m$ 个样本最多有 $2^m$ 个可能的结果。

对于二分类问题，假设空间 $\mathcal{H}$ 中的假设对 $D$ 中的样本赋予标记的每种可能结果称为对 $D$ 的一种划分/Dichotomy，这是因为该假设把 $D$ 中的样本分成了正例和反例两部分。若假设空间 $\mathcal{H}$ 能实现 $D$ 上的所有划分，即 $|\mathcal{H}_{\mid D}| = 2^m$，则称样本集 $D$ 能被假设空间 $\mathcal{H}$ 打散/Shattered，此时 $\Pi_{\mathcal{H}}(m) = 2^m$。

例如，令 $\mathcal{H}$ 表示 $\mathbb{R}$ 上的阈值函数构成的集合，其中的阈值函数表示为 $h_a(\boldsymbol{x}) = \text{sign}((\boldsymbol{x} < a) - 1/2)$，则 $\mathcal{H} = \{h_a : a \in \mathbb{R}\}$。令 $D = \{\boldsymbol{x}_1\}$，如果取 $a = \boldsymbol{x}_1 + 1$，则 $h_a(\boldsymbol{x}_1) = +1$；如果取 $a = \boldsymbol{x}_1 - 1$，则 $h_a(\boldsymbol{x}_1) = -1$。因此 $\mathcal{H}$ 能打散 $D = \{\boldsymbol{x}_1\}$。令 $D' = \{\boldsymbol{x}_1,\boldsymbol{x}_2\}$，不妨假设 $\boldsymbol{x}_1 < \boldsymbol{x}_2$，则易知同时将 $\boldsymbol{x}_1$ 分类为 $-1$ 但把 $\boldsymbol{x}_2$ 分类为 $+1$ 的结果不能被 $\mathcal{H}$ 中的任何阈值函数实现，这是因为如果 $h_a(\boldsymbol{x}_1) = -1$，则必有 $h_a(\boldsymbol{x}_2) = -1$。所以 $\mathcal{H}$ 不能打散 $D'$。

**定义 3.1**（VC 维 [Vapnik and Chervonenkis, 1971]）：假设空间 $\mathcal{H}$ 的 VC 维是能被 $\mathcal{H}$ 打散的最大样本集的大小，即

$$\text{VC}(\mathcal{H}) = \max\{m : \Pi_{\mathcal{H}}(m) = 2^m\}.$$ (3.4)

$\text{VC}(\mathcal{H}) = d$ 表明存在大小为 $d$ 的样本集能被假设空间 $\mathcal{H}$ 打散。注意：这并不意味着所有大小为 $d$ 的样本集都能被假设空间 $\mathcal{H}$ 打散。VC 维的定义与数据分布 $\mathcal{D}$ 无关！因此，在数据分布未知时仍能计算出假设空间 $\mathcal{H}$ 的 VC 维。

要证明一个具体的假设空间 $\mathcal{H}$ 的 VC 维为 $d$，需要证明两点：

- 存在大小为 $d$ 的样本集 $D$ 能被 $\mathcal{H}$ 打散；
- 任意大小为 $d + 1$ 的样本集 $D'$ 都不能被 $\mathcal{H}$ 打散。

下面给出两种假设空间的 VC 维：

阈值函数的 VC 维：令 $\mathcal{H}$ 表示所有定义在 $\mathbb{R}$ 上的阈值函数组成的集合 $\mathcal{H} = \{h_{a,b} : a,b \in \mathbb{R}, a < b\}$，其中 $h_{a,b}(\boldsymbol{x}) = \text{sign}((\boldsymbol{x} \in (a,b)) - 1/2)$。令 $D = \{1,2\}$，易知 $\mathcal{H}$ 能打散 $D$，因此 $\text{VC}(\mathcal{H}) \geq 2$。对于任意大小为 3 的样本集 $D' = \{\boldsymbol{x}_1,\boldsymbol{x}_2,\boldsymbol{x}_3\}$，不妨设 $\boldsymbol{x}_1 < \boldsymbol{x}_2 < \boldsymbol{x}_3$，则分类结果 $(+1,-1,+1)$ 不能被 $\mathcal{H}$ 中任何区间函数实现，因为当 $h_{a,b}(\boldsymbol{x}_1) = +1$ 且 $h_{a,b}(\boldsymbol{x}_2) = -1$ 时，必有 $h_{a,b}(\boldsymbol{x}_3) = -1$。所以 $\mathcal{H}$ 无法打散任何大小为 3 的样本集，于是根据 VC 维的定义可知 $\text{VC}(\mathcal{H}) = 1$。

区间函数的 VC 维：令 $\mathcal{H}$ 表示所有定义在 $\mathbb{R}$ 上的区间组成的集合 $\mathcal{H} = \{h_{a,b} : a,b \in \mathbb{R}, a < b\}$，其中 $h_{a,b}(\boldsymbol{x}) = \text{sign}((\boldsymbol{x} \in (a,b)) - 1/2)$。令 $D = \{1,2\}$，易知 $\mathcal{H}$ 能打散 $D$，因此 $\text{VC}(\mathcal{H}) \geq 2$。对于任意大小为 3 的样本集 $D' = \{\boldsymbol{x}_1,\boldsymbol{x}_2,\boldsymbol{x}_3\}$，不妨设 $\boldsymbol{x}_1 < \boldsymbol{x}_2 < \boldsymbol{x}_3$，则分类结果 $(+1,-1,+1)$ 不能被 $\mathcal{H}$ 中任何区间函数实现，因为当 $h_{a,b}(\boldsymbol{x}_1) = +1$ 且 $h_{a,b}(\boldsymbol{x}_2) = -1$ 时，必有 $h_{a,b}(\boldsymbol{x}_3) = -1$。所以 $\mathcal{H}$ 无法打散任何大小为 3 的样本集，于是根据 VC 维的定义可知 $\text{VC}(\mathcal{H}) = 2$。

令假设空间 $\mathcal{H}$ 为有限集合。对于任意数据集 $D$，有 $|\mathcal{H}_{\mid D}| \leq |\mathcal{H}|$。还知道当 $|\mathcal{H}| < 2^{|D|}$ 时，$\mathcal{H}$ 无法打散 $D$。因此，可得 $\text{VC}(\mathcal{H}) \leq \log_2 |\mathcal{H}|$。事实上，有限假设空间 $\mathcal{H}$ 的 $\text{VC}(\mathcal{H})$ 通常远小于 $\log_2 |\mathcal{H}|$。这意味着用 VC 维来衡量有限假设空间的复杂度更为准确。

由增长函数的定义可知，VC 维与增长函数关系密切，引理 3.1 [Sauer, 1972] 给出了二者之间的关系：
-->

**引理 3.1**：若假设空间 $\mathcal{H}$ 的 VC 维为 $d$，则对任意 $m \in \mathbb{N}$ 有

$$\Pi_{\mathcal{H}}(m) \leq \sum_{i=0}^d \binom{m}{i}.$$

令 $Q$ 表示能被 $\mathcal{H}_{D^{\prime}\mid D}$ 打散的集合，这里认为 $\mathcal{H}_{D^{\prime}\mid D}$ 为假设空间，给每一个 $\boldsymbol{x}_i$ 提供结果。也就是对于 $Q$ 的任意的二分类结果，都能在 $\mathcal{H}_{D^{\prime}\mid D}$ 中找到一个假设 $h$ 令其实现。并且由 $\boldsymbol{x}_m$ 与 $\mathcal{H}_{D^{\prime}\mid D}$ 的定义，$Q \cup \{\boldsymbol{x}_m\}$ 必能被 $\mathcal{H}_{D}$ 打散。若 $Q$ 的大小为 $k$，则 $k + 1 \leq \text{VC}(\mathcal{H}) = d$，因此 $\mathcal{H}_{D^{\prime}\mid D}$ 的 VC 维最大为 $d-1$，于是有

$$|\mathcal{H}_{D^{\prime}\mid D}| \leq \Pi_{\mathcal{H}}(m-1)\leq \sum_{i=0}^{d-1} \binom{m-1}{i}.$$

结合上面的推导，可得

$$\begin{aligned}
    \lvert \mathcal{H}_D \rvert &\leq \sum_{i=0}^d \binom{m-1}{i} + \sum_{i=0}^{d-1} \binom{m-1}{i} \\
    &= \sum_{i=0}^d \left(\binom{m-1}{i} + \binom{m-1}{i-1}\right) \\
    &= \sum_{i=0}^d \binom{m}{i}.
\end{aligned}$$

这就完成了证明。

<!-- **引理 3.1**：若假设空间 $\mathcal{H}$ 的 VC 维为 $d$，则对任意 $m \in \mathbb{N}$ 有

$$\Pi_{\mathcal{H}}(m) \leq \sum_{i=0}^d \binom{m}{i}.$$ (3.5)

**证明**：利用数学归纳法。当 $m = 1$，$d = 0$ 或 $d = 1$ 时，定理成立。假设定理对 $(m-1,d-1)$ 和 $(m-1,d)$ 成立。令 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}$，$D' = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_{m-1}\}$，

$$\mathcal{H}_{\mid D} = \{(h(\boldsymbol{x}_1),\ldots,h(\boldsymbol{x}_m))|h \in \mathcal{H}\},$$ (3.6)

$$\mathcal{H}|_{D'} = \{(h(\boldsymbol{x}_1),\ldots,h(\boldsymbol{x}_{m-1}))|h \in \mathcal{H}\},$$ (3.7)

分别为假设空间在 $D$ 和 $D'$ 上的限制。假设 $h \in \mathcal{H}$ 对 $\boldsymbol{x}_m$ 的分类结果为 +1 或 -1，因此任何出现在 $\mathcal{H}|_{D'}$ 的串都会在 $\mathcal{H}_{\mid D}$ 中出现一次或者两次。令 $\mathcal{H}_{D'|D}$ 表示 $\mathcal{H}_{\mid D}$ 中出现两次的 $\mathcal{H}|_{D'}$ 中串成的集合，即

$$\mathcal{H}_{D'|D} = \{(y_1,\ldots,y_{m-1}) \in \mathcal{H}|_{D'}|\exists h,h' \in \mathcal{H},
    (h(\boldsymbol{x}_i) = h'(\boldsymbol{x}_i) = y_i) \wedge (h(\boldsymbol{x}_m) \neq h'(\boldsymbol{x}_m)) \quad i \in [m-1]\}.$$ (3.8)

考虑到 $\mathcal{H}_{D'|D}$ 中的串在 $\mathcal{H}_{\mid D}$ 中出现了两次，但在 $\mathcal{H}|_{D'}$ 中仅出现了一次，有

$$|\mathcal{H}_{\mid D}| = |\mathcal{H}|_{D'}| + |\mathcal{H}_{D'|D}|.$$ (3.9)

因为 $D'$ 的大小为 $m-1$，根据归纳的前提假设可以得到

$$|\mathcal{H}|_{D'}| \leq \Pi_{\mathcal{H}}(m-1)
    \leq \sum_{i=0}^d \binom{m-1}{i}.$$ (3.10)
 -->

**定理 3.1**：若假设空间 $\mathcal{H}$ 的 VC 维为 $d$，则对任意整数 $m \geq d$ 有

$$\Pi_{\mathcal{H}}(m) \leq \left(\frac{e\cdot m}{d}\right)^d.$$

!!! Info "证明"

    根据引理 3.1，有

    $$\begin{aligned}
        \Pi_{\mathcal{H}}(m) &\leq \sum_{i=0}^d \binom{m}{i}\\
        &\leq \sum_{i=0}^d \binom{m}{i}\left(\frac{m}{d}\right)^{d-i}\\
        &= \left(\frac{m}{d}\right)^d \sum_{i=0}^d \binom{m}{i}\left(\frac{d}{m}\right)^i\\
        &\leq \left(\frac{m}{d}\right)^d \sum_{i=0}^m \binom{m}{i}\left(\frac{d}{m}\right)^i\\
        &= \left(\frac{m}{d}\right)^d \left(1+\frac{d}{m}\right)^m\\
        &\leq \left(\frac{e\cdot m}{d}\right)^d.
    \end{aligned}$$

    这就完成了证明。

当假设空间 $\mathcal{H}$ 的 VC 维无穷大时，任意大小的样本集 $D$ 都能被 $\mathcal{H}$ 打散，此时有 $\Pi_{\mathcal{H}}(m) = 2^m$，增长函数随着数据集大小的增长而呈指数级增长；当 VC 维有限为 $d$ 且 $m \geq d$ 时，由定理 3.1 可知增长函数随着数据集大小的增长而呈多项式级增长。

VC 维仅仅针对二分类问题定义，对于多分类问题，也可以有相应的假设空间复杂度刻画方法，即 Natarajan 维/Natarajan Dimension。在多分类问题中，假设空间 $\mathcal{H}$ 中的假设是 $\mathcal{X}$ 到 $\mathcal{Y} = \{0,\ldots,K-1\}$ 的映射，其中 $K$ 为类别数。多分类问题中也有相应的增长函数和打散的概念，Natarajan 维也依赖于打散这个概念定义。

多分类问题的增长函数表述与二分类问题一致：

$$\Pi_{\mathcal{H}}(m) = \max_{\{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}\subset\mathcal{X}}|\{(h(\boldsymbol{x}_1),\ldots,h(\boldsymbol{x}_m))|h \in \mathcal{H}\}|.$$

对于给定的集合 $D \subset \mathcal{X}$，若假设空间 $\mathcal{H}$ 中存在两个假设 $f_0,f_1 : D \mapsto \mathcal{Y}$ 满足以下两个条件：

- 对于任意 $\boldsymbol{x} \in D$，$f_0(\boldsymbol{x}) \neq f_1(\boldsymbol{x})$，也就是说 $f_0$ 和 $f_1$ 对 $D$ 中的任意样本都有不同的分类结果；
- 对于任意集合 $B \subset D$ 存在 $h \in \mathcal{H}$ 使得

    $$\forall \boldsymbol{x} \in B, h(\boldsymbol{x}) = f_0(\boldsymbol{x}) \enspace\text{and}\enspace \forall \boldsymbol{x} \in D\setminus B, h(\boldsymbol{x}) = f_1(\boldsymbol{x}),$$

则称集合 $D$ 能被假设空间 $\mathcal{H}$ 打散（多分类问题）。

**定义 3.2**（Natarajan 维）：对于多分类问题的假设空间 $\mathcal{H}$，Natarajan 维是能被 $\mathcal{H}$ 打散的最大样本集的大小，记作 $\text{Natarajan}(\mathcal{H})$，我也想记作 $\mathfrak{N}(\mathcal{H})$。

下面定理证明，二分类问题的 VC 维与 Natarajan 维相同。

**定理 3.2**：类别数 $K = 2$ 时，$\text{VC}(\mathcal{H}) = \text{Natarajan}(\mathcal{H})$。

!!! Info "证明"

    首先证明 $\text{VC}(\mathcal{H}) \leq \text{Natarajan}(\mathcal{H})$。令 $D$ 表示大小为 $\text{VC}(\mathcal{H})$ 且能被 $\mathcal{H}$ 打散的集合。取二分类问题打散定义中的 $f_0,f_1$ 为常值函数，即 $f_0 = 0,f_1 = 1$。由于 $D$ 能被 $\mathcal{H}$ 打散，则对于任意集合 $B \subset D$，存在 $h_B$ 使得 $\boldsymbol{x} \in B$ 时 $h_B(\boldsymbol{x}) = 0$，$\boldsymbol{x} \in D\setminus B$ 时 $h_B(\boldsymbol{x}) = 1$，这也就是可以实现任意的二分类结果。因此 $\mathcal{H}$ 可以在多分类意义下打散大小为 $\text{VC}(\mathcal{H})$ 的 $D$，于是有 $\text{VC}(\mathcal{H}) \leq \text{Natarajan}(\mathcal{H})$。

    再证明 $\text{VC}(\mathcal{H}) \geq \text{Natarajan}(\mathcal{H})$。令 $D$ 表示大小为 $\text{Natarajan}(\mathcal{H})$ 且在多分类问题中能被 $\mathcal{H}$ 打散的集合。对于 $D$ 上的任意一种对分 $g : D \to \mathcal{Y}$，令 $D^+ = \{\boldsymbol{x} \in D|g(\boldsymbol{x}) = 1\}$，$D^- = \{\boldsymbol{x} \in D|g(\boldsymbol{x}) = 0\}$，只需证明存在 $h \in \mathcal{H}$ 能实现这种分类，即 $\forall \boldsymbol{x} \in D$ 有 $h(\boldsymbol{x}) = g(\boldsymbol{x})$。当 $K = 2$ 时，$f_0,f_1 : D \mapsto \mathcal{Y}$。定义 $D_i^y = \{\boldsymbol{x} \in D \mid f_i(\boldsymbol{x}) = y\}$，$i \in \{0,1\}$，$y \in \mathcal{Y}$。取 $B = (D^+ \cap D_0^1) \cup (D^- \cap D_0^0)$，由多分类问题中的打散定义可知存在 $h \in \mathcal{H}$ 使得 $\forall \boldsymbol{x} \in B, h(\boldsymbol{x}) = f_0(\boldsymbol{x})$ 且 $\forall \boldsymbol{x} \in D\setminus B, h(\boldsymbol{x}) = f_1(\boldsymbol{x})$。由于 $\forall \boldsymbol{x} \in D$ 有 $f_0(\boldsymbol{x}) \neq f_1(\boldsymbol{x})$，通过计算可知，$\forall \boldsymbol{x} \in B, g(\boldsymbol{x}) = f_0(\boldsymbol{x})$ 且 $\forall \boldsymbol{x} \in D\setminus B, g(\boldsymbol{x}) = f_1(\boldsymbol{x})$。从而可得 $\forall \boldsymbol{x} \in D$ 有 $h(\boldsymbol{x}) = g(\boldsymbol{x})$，即 $\mathcal{H}$ 能打散大小为 $\text{Natarajan}(\mathcal{H})$ 的 $D$，于是有 $\text{VC}(\mathcal{H}) \geq \text{Natarajan}(\mathcal{H})$。定理得证。

    第二段也很直接，直接思考多分类问题语境下的二分类问题打散的本质：第一条定义指出我们可以使用两个映射覆盖任意样本的二分类结果，第二个定义指出我们可以拼凑出任意的二分类结果。

<!-- 

**证明**：首先证明 $\text{VC}(\mathcal{H}) \leq \text{Natarajan}(\mathcal{H})$。令 $D$ 表示大小为 $\text{VC}(\mathcal{H})$ 且能被 $\mathcal{H}$ 打散的集合。取多分类问题打散定义中的 $f_0,f_1$ 为常值函数，即 $f_0 = 0,f_1 = 1$。由于 $D$ 能被 $\mathcal{H}$ 打散，则对于任意集合 $B \subset D$，存在 $h_B$ 使得 $\boldsymbol{x} \in B$ 时 $h_B(\boldsymbol{x}) = 0$，$\boldsymbol{x} \in D\setminus B$ 时 $h_B(\boldsymbol{x}) = 1$，即 $\mathcal{H}$ 能打散（多分类问题）大小为 $\text{VC}(\mathcal{H})$ 的 $D$，于是有 $\text{VC}(\mathcal{H}) \leq \text{Natarajan}(\mathcal{H})$。

再证明 $\text{VC}(\mathcal{H}) \geq \text{Natarajan}(\mathcal{H})$。令 $D$ 表示大小为 $\text{Natarajan}(\mathcal{H})$ 且在多分类问题中能被 $\mathcal{H}$ 打散的集合。对于 $D$ 上的任意一种对分 $g : D \to \mathcal{Y}$，令 $D^+ = \{\boldsymbol{x} \in D|g(\boldsymbol{x}) = 1\}$，$D^- = \{\boldsymbol{x} \in D|g(\boldsymbol{x}) = 0\}$，只需证明存在 $h \in \mathcal{H}$ 能实现这种分类，即 $\forall \boldsymbol{x} \in D$ 有 $h(\boldsymbol{x}) = g(\boldsymbol{x})$。当 $K = 2$ 时，$f_0,f_1 \in \mathcal{Y}$。取 $B = (D^+ \cap D_0^1) \cup (D^- \cap D_0^0)$，由多分类问题中的打散定义可知存在 $h \in \mathcal{H}$ 使得 $\forall \boldsymbol{x} \in B, h(\boldsymbol{x}) = f_0(\boldsymbol{x})$ 且 $\forall \boldsymbol{x} \in D\setminus B, h(\boldsymbol{x}) = f_1(\boldsymbol{x})$。由于 $\forall \boldsymbol{x} \in D$ 有 $f_0(\boldsymbol{x}) \neq f_1(\boldsymbol{x})$，通过计算可知，$\forall \boldsymbol{x} \in B, g(\boldsymbol{x}) = f_0(\boldsymbol{x})$ 且 $\forall \boldsymbol{x} \in D\setminus B, g(\boldsymbol{x}) = f_1(\boldsymbol{x})$。从而可得 $\forall \boldsymbol{x} \in D$ 有 $h(\boldsymbol{x}) = g(\boldsymbol{x})$，即 $\mathcal{H}$ 能打散大小为 $\text{Natarajan}(\mathcal{H})$ 的 $D$，于是有 $\text{VC}(\mathcal{H}) \geq \text{Natarajan}(\mathcal{H})$。定理得证。 □

对于多分类问题，通过 Natarajan 维控制增长函数的增长速度，可得到下面的定理 [Natarajan, 1989]。

**定理 3.3**：若多分类问题假设空间 $\mathcal{H}$ 的 Natarajan 维为 $d$，类别数为 $K$，则对任意 $m \in \mathbb{N}$ 有

$$\Pi_{\mathcal{H}}(m) \leq m^d K^{2d}.$$ (3.17)

**证明**：利用数学归纳法。当 $m = 1$，$d = 0$ 或 $d = 1$ 时，定理显然成立。假设定理对 $(m-1,d-1)$ 和 $(m-1,d)$ 成立。对于 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}$，$\mathcal{Y} = \{0,\ldots,K-1\}$，令

$$\mathcal{H}_k = \{h \in \mathcal{H}_{\mid D}|h(\boldsymbol{x}_1) = k\} \quad (k \in \{0,\ldots,K-1\}).$$ (3.18)

基于 $\mathcal{H}_k$ 可以构造如下集合：

$$\mathcal{H}_{ij} = \{h \in \mathcal{H}_i|\exists h' \in \mathcal{H}_j, h(\boldsymbol{x}_l) = h'(\boldsymbol{x}_l), 2 \leq l \leq m\} \quad (i \neq j),$$ (3.19)

$$\bar{\mathcal{H}} = \mathcal{H}_{\mid D} - \cup_{i\neq j}\mathcal{H}_{ij}.$$ (3.20)

基于联合界不等式 (1.19) 可知

$$|\mathcal{H}_{\mid D}| \leq |\bar{\mathcal{H}}| + |\cup_{i\neq j}\mathcal{H}_{ij}|
    \leq |\bar{\mathcal{H}}| + \sum_{i\neq j} |\mathcal{H}_{ij}|.$$ (3.21)

基于 $\bar{\mathcal{H}}$ 的构造可知 $\bar{\mathcal{H}}$ 在 $D - \{\boldsymbol{x}_1\}$ 上无预测结果相同的假设，且 $\text{Natarajan}(\mathcal{H}) \leq d$。根据归纳的前提假设，可知

$$|\bar{\mathcal{H}}| \leq \Pi_{\mathcal{H}}(m-1) \leq (m-1)^d K^{2d}.$$ (3.22)

同时，$\mathcal{H}_{ij}$ 的 Natarajan 维最多为 $d-1$，否则 $\mathcal{H}$ 的 Natarajan 维将超过 $d$。同样根据 $\mathcal{H}_{ij}$ 在 $D$ 上无预测结果相同的假设和归纳的前提假设，有

$$|\mathcal{H}_{ij}| \leq \Pi_{\mathcal{H}_{ij}}(m) \leq m^{d-1} K^{2(d-1)} \quad (i \neq j).$$ (3.23)

综合 (3.21)～(3.23) 可得

$$|\mathcal{H}_{\mid D}| \leq |\bar{\mathcal{H}}| + \sum_{i\neq j} |\mathcal{H}_{ij}|
    \leq \Pi_{\mathcal{H}}(m-1) + \sum_{i\neq j} \Pi_{\mathcal{H}_{ij}}(m)
    \leq (m-1)^d K^{2d} + K^2 m^{d-1} K^{2(d-1)}
    \leq m^d K^{2d}.$$ (3.24)

由 $D$ 的任意性可知 (3.17) 成立，从而定理得证。
 -->

## 2. 数据分布相关

VC 维的定义与数据分布无关，因此基于 VC 维的分析结果是分布无关的。这使得基于 VC 维的分析结果具有一定的普适性，但是由于没有考虑数据自身，因此基于 VC 维的分析结果通常比较松，对那些与学习问题的典型情况相差较远的数据分布来说尤其如此。

???- Note "Rademacher 复杂度的来源"

    给定数据集 $D = \{(\boldsymbol{x}_1,y_1),\ldots,(\boldsymbol{x}_m,y_m)\}$，$h \in \mathcal{H}$ 的经验误差为

    $$\hat{E}(h) = \frac{1}{m}\sum_{i=1}^m \mathbb{I}(h(\boldsymbol{x}_i) \neq y_i)
        = \frac{1}{m}\sum_{i=1}^m \frac{1-y_ih(\boldsymbol{x}_i)}{2}
        = \frac{1}{2} - \frac{1}{2m}\sum_{i=1}^m y_ih(\boldsymbol{x}_i),$$

    其中 $\frac{1}{m}\sum_{i=1}^m y_ih(\boldsymbol{x}_i)$ 体现了预测值 $h(\boldsymbol{x}_i)$ 与样本真实标记记号 $y_i$ 之间的一致性。若 $\forall i \in [m], h(\boldsymbol{x}_i) = y_i$，则 $\frac{1}{m}\sum_{i=1}^m y_ih(\boldsymbol{x}_i)$ 取得最大值 1，也就是说具有最小经验误差的假设是

    $$\underset{h\in\mathcal{H}}{\arg\max} \frac{1}{m}\sum_{i=1}^m y_ih(\boldsymbol{x}_i).$$

    然而，现实任务中样本的标记有时会受到噪声的影响，即对某些样本 $(\boldsymbol{x}_i,y_i)$，标记 $y_i$ 或许已经受到随机因素的影响，不再是 $\boldsymbol{x}_i$ 的真实标记。在此情形下，选择假设空间 $\mathcal{H}$ 中在训练集上表现最好的假设，可能不知选择 $\mathcal{H}$ 中事先已考虑了噪声影响的假设。

给定数据集 $D = \{(\boldsymbol{x}_1,y_1),\ldots,(\boldsymbol{x}_m,y_m)\}$，$h \in \mathcal{H}$，考虑随机变量 $\sigma_i$，它以 0.5 的概率取值 $+1$，以 0.5 的概率取值 $-1$，称其为 Rademacher 随机变量。基于 $\sigma_i$ 可将 $h \in \mathcal{H}$ 的经验误差改写为 $\sup_{h\in\mathcal{H}} \frac{1}{m}\sum\limits_{i=1}^m \sigma_ih(\boldsymbol{x}_i)$。对 $\boldsymbol{\sigma} = (\sigma_1,\cdots,\sigma_m)$ 求期望得到：

$$\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m \sigma_ih(\boldsymbol{x}_i)\right].$$

这样的值和增长函数有着相似的作用，体现了假设空间在数据集 $D$ 上的表示能力，取值范围为 $[0,1]$。当这个值取值为 1 时，意味着对任意 $\boldsymbol{\sigma} = (\sigma_1,\cdots,\sigma_m)$，$\sigma_i \in \{-1,+1\}$，有

$$\sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m \sigma_ih(\boldsymbol{x}_i) = 1,$$

也就是说，存在 $h \in \mathcal{H}$ 使得 $h(\boldsymbol{x}_i) = \sigma_i$，即 $\Pi_{\mathcal{H}}(m) = 2^m$，$\mathcal{H}$ 能打散 $D$。总的来说，这个值越接近 1，假设空间的表示能力越强。

考虑实值函数空间 $\mathcal{F} : \mathcal{Z} \to \mathbb{R}$，令 $\mathcal{Z} = \{z_1,\ldots,z_m\}$，将上面的 $\mathcal{X}$ 和 $\mathcal{H}$ 替换为 $\mathcal{Z}$ 和 $\mathcal{F}$ 可得我们要的 Rademacher 复杂度。

**定义 3.3**：函数空间 $\mathcal{F}$ 关于 $Z$ 的**经验 Rademacher 复杂度**为

$$\hat{\mathfrak{R}}_{\mathcal{Z}}(\mathcal{F}) = \mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{f\in\mathcal{F}} \frac{1}{m}\sum_{i=1}^m \sigma_if(z_i)\right].$$

**定义 3.4**：函数空间 $\mathcal{F}$ 关于 $Z$ 在分布 $\mathcal{D}$ 的 **Rademacher 复杂度**为

$$\mathfrak{R}_{\mathcal{D}}(\mathcal{F}) = \mathbb{E}_{Z \subset \mathcal{Z} \colon \lvert Z \rvert = m}\left[\hat{\mathfrak{R}}_{\mathcal{Z}}(\mathcal{F})\right].$$

在经验 Rademacher 复杂度的定义中，$Z$ 是一个给定的集合。经验 Rademacher 复杂度体现了函数空间 $\mathcal{F}$ 在数据集 $Z$ 上的表示能力，在分布 $\mathcal{D}$ 上独立同分布采样 $m$ 个样本求期望就可以得到 Rademacher 复杂度。在经验 Rademacher 复杂度和 Rademacher 复杂度的定义中，$\sigma_i$ 是 $\{-1,+1\}$ 上服从均匀分布的随机变量，如果将均匀分布改为其他分布，会得到其他一些复杂度的定义，例如 Gaussian 复杂度：我们令随机变量 $\boldsymbol{g} = (g_1,\cdots,g_m)$ 服从高斯 $\mathcal{N}(0,1)$ 分布，即标准正态分布。

**定义 3.5**：函数空间 $\mathcal{F}$ 关于 $Z$ 的**经验 Gaussian 复杂度**为

$$\hat{\mathfrak{G}}_{\mathcal{Z}}(\mathcal{F}) = \mathbb{E}_{\boldsymbol{g}}\left[\sup_{f\in\mathcal{F}} \frac{1}{m}\sum_{i=1}^m g_if(z_i)\right].$$

**定义 3.6**：函数空间 $\mathcal{F}$ 关于 $Z$ 在分布 $\mathcal{D}$ 的 **Gaussian 复杂度**为

$$\mathfrak{G}_{\mathcal{D}}(\mathcal{F}) = \mathbb{E}_{Z \subset \mathcal{Z} \colon \lvert Z \rvert = m}\left[\hat{\mathfrak{G}}_{\mathcal{Z}}(\mathcal{F})\right].$$

Rademacher 复杂度与前面介绍的 VC 维用到的增长函数之间也有一定的关系，首先我们需要引入下面的定理。

**定理 3.4**：令 $A \subset \mathbb{R}^m$ 为有限集合且 $r = \max_{\boldsymbol{x}\in A}\|\boldsymbol{x}\|$，有

$$\mathbb{E}_{\boldsymbol{\sigma}}\left[\frac{1}{m} \sup_{\boldsymbol{x}\in A} \sum_{i=1}^m \sigma_i x_i\right] \leq \frac{r\sqrt{2\ln |A|}}{m},$$

其中 $\boldsymbol{x} = (x_1; \ldots; x_m)$，$\sigma_i$ 是 Rademacher 随机变量。

!!! Info "证明"

    对任意 $t > 0$ 使用 Jensen 不等式可得

    $$\begin{aligned}
    \exp\left(t\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{x}\in A}\sum_{i=1}^m \sigma_ix_i\right]\right)
    &\leq \mathbb{E}_{\boldsymbol{\sigma}}\left[\exp\left(t\sup_{\boldsymbol{x}\in A}\sum_{i=1}^m \sigma_ix_i\right)\right]\\
    &= \mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{x}\in A}\exp\left(t\sum_{i=1}^m \sigma_ix_i\right)\right]\\
    &\leq \sum_{\boldsymbol{x}\in A}\mathbb{E}_{\boldsymbol{\sigma}}\left[\exp\left(t\sum_{i=1}^m \sigma_ix_i\right)\right].
    \end{aligned}$$

    考虑随机变量 $\sigma_1,\ldots,\sigma_m$ 的独立性，并且使用 Hoeffding 不等式：

    $$\begin{aligned}
    \exp\left(t\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{x}\in A}\sum_{i=1}^m \sigma_ix_i\right]\right)
    &\leq \sum_{\boldsymbol{x}\in A}\prod_{i=1}^m \mathbb{E}_{\sigma_i}[\exp(t\sigma_ix_i)]\\
    &\leq \sum_{\boldsymbol{x}\in A}\prod_{i=1}^m \exp\left(\frac{t^2(2x_i)^2}{8}\right) = \sum_{\boldsymbol{x}\in A}\exp\left(\frac{t^2}{2}\sum_{i=1}^m x_i^2\right)\\
    &\leq \sum_{\boldsymbol{x}\in A}\exp\left(\frac{t^2r^2}{2}\right) = |A|\exp\left(\frac{t^2r^2}{2}\right).
    \end{aligned}$$

    对不等式的两边取对数可得

    $$\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{x}\in A}\sum_{i=1}^m \sigma_ix_i\right] \leq \frac{\ln|A|}{t} + \frac{tr^2}{2}.$$

    当 $t = \frac{\sqrt{2\ln|A|}}{r}$ 时，右侧取最小值，可得

    $$\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{x}\in A}\sum_{i=1}^m \sigma_ix_i\right] \leq r\sqrt{2\ln|A|}.$$

    两边同时除以 $m$，定理得证。

由定理 3.4 可得关于 Rademacher 复杂度与增长函数之间的关系。

**推论 3.1**：假设空间 $\mathcal{H}$ 的 Rademacher 复杂度 $\mathfrak{R}_m(\mathcal{H})$ 与增长函数 $\Pi_{\mathcal{H}}(m)$ 之间满足

$$\mathfrak{R}_m(\mathcal{H}) \leq \sqrt{\frac{2\ln\Pi_{\mathcal{H}}(m)}{m}}.$$

!!! Info "证明"

    对于 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}$，$\mathcal{H}_{\mid D}$ 为假设空间 $\mathcal{H}$ 在 $D$ 上的限制。由于 $h \in \mathcal{H}$ 的值域为 $\{-1,+1\}$，可知 $\mathcal{H}_{\mid D}$ 中的元素为模长 $\sqrt{m}$ 的向量。因此，由定理 3.4 可得

    $$\mathfrak{R}_m(\mathcal{H}) = \mathbb{E}_D\left[\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}_{\mid D}}\frac{1}{m}\sum_{i=1}^m \sigma_ih_i\right]\right]
    \leq \mathbb{E}_D\left[\frac{\sqrt{m}\sqrt{2\ln|\mathcal{H}_{\mid D}|}}{m}\right].$$

    又因为 $|\mathcal{H}_{\mid D}| \leq \Pi_{\mathcal{H}}(m)$，有

    $$\mathfrak{R}_m(\mathcal{H}) \leq \mathbb{E}_D\left[\frac{\sqrt{m}\sqrt{2\ln\Pi_{\mathcal{H}}(m)}}{m}\right] = \sqrt{\frac{2\ln\Pi_{\mathcal{H}}(m)}{m}},$$

    从而定理得证。

在下一章，我们就可以看见：基于 Rademacher 复杂度可以推导出比基于 VC 维更紧的泛化误差界。

## 3. 分析材料

### 3.1 线性超平面

### 3.2 支持向量机

<!-- ## 3. 分析实例

本节将以线性超平面为例来展示如何进行 VC 维和 Rademacher 复杂度分析，并以支持向量机和多层神经网络为例来进一步展示常用机器学习技术的 VC 维分析。

### 3.1 线性超平面

对于二分类问题，线性超平面的假设空间 $\mathcal{H}$ 可表示为

$$\left\{h_{\boldsymbol{w},b} : h_{\boldsymbol{w},b}(\boldsymbol{x}) = \text{sign}\left(\boldsymbol{w}^{\top}\boldsymbol{x} + b\right) = \text{sign}\left(\left(\sum_{i=1}^d w_ix_i\right) + b\right)\right\},$$ (3.41)

$b = 0$ 时称为齐次线性超平面。典型线性超平面是将 $\boldsymbol{w}$，$b$ 缩放后，满足 $\min_{\boldsymbol{x}}|\boldsymbol{w}^{\top}\boldsymbol{x} + b| = 1$ 的超平面。

**定理 3.5**：$\mathbb{R}^d$ 中由齐次线性超平面构成的假设空间 $\mathcal{H}$ 的 VC 维为 $d$。

**证明**：令 $\boldsymbol{e}_1,\ldots,\boldsymbol{e}_d$ 表示 $\mathbb{R}^d$ 中的 $d$ 个单位向量，集合 $D = \{\boldsymbol{e}_1,\ldots,\boldsymbol{e}_d\}$。对于任意 $d$ 个标记 $y_1,\ldots,y_d$，取 $\boldsymbol{w} = (y_1,\cdots,y_d)$，则有 $\boldsymbol{w}^{\top}\boldsymbol{e}_i = y_i$，所以 $D$ 能被齐次线性超平面构成的假设空间打散。

令集合 $D' = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_{d+1}\}$ 为 $\mathbb{R}^d$ 中任意的 $d + 1$ 个向量，则必存在不全为 0 的实数 $a_1,\ldots,a_{d+1}$ 使得 $\sum_{i=1}^{d+1} a_i\boldsymbol{x}_i = 0$。令 $I = \{i : a_i > 0\}$，$J = \{j : a_j < 0\}$，首先假设这两者都不为空集，则有

$$\sum_{i\in I} a_i\boldsymbol{x}_i = \sum_{j\in J} |a_j|\boldsymbol{x}_j.$$ (3.42)

下面采用反证法。假设 $D'$ 能被 $\mathcal{H}$ 打散，则存在向量 $\boldsymbol{w}$ 使得 $\boldsymbol{w}^{\top}\boldsymbol{x}_i > 0$，$i \in I$，且 $\boldsymbol{w}^{\top}\boldsymbol{x}_j < 0$，$j \in J$。此此可得

$$\begin{aligned}
0 &< \sum_{i\in I} a_i(\boldsymbol{x}_i^{\top}\boldsymbol{w})\\
&= \left(\sum_{i\in I} a_i\boldsymbol{x}_i\right)^{\top} \boldsymbol{w}\\
&= \left(\sum_{j\in J} |a_j|\boldsymbol{x}_j\right)^{\top} \boldsymbol{w}\\
&= \sum_{j\in J} |a_j|(\boldsymbol{x}_j^{\top}\boldsymbol{w}) < 0.
\end{aligned}$$ (3.43)

此式矛盾，即 $D'$ 能被 $\mathcal{H}$ 打散不成立。当 $I$，$J$ 只有一个不为空集时同理可证。

综上可知，$\text{VC}(\mathcal{H}) = d$，从而定理得证。 □

**定理 3.6**：$\mathbb{R}^d$ 中由非齐次线性超平面构成的假设空间 $\mathcal{H}$ 的 VC 维为 $d + 1$。

**证明**：由定理 3.5 的证明可知 $D = \{0,\boldsymbol{e}_1,\ldots,\boldsymbol{e}_d\}$ 能被非齐次线性超平面 $\mathcal{H}$ 打散。下面将非齐次线性超平面转化为齐次线性超平面：

$$\boldsymbol{w}^{\top}\boldsymbol{x} + b = \boldsymbol{w}'^{\top}\boldsymbol{x}' \quad (\boldsymbol{w} \in \mathbb{R}^d, \boldsymbol{x} \in \mathbb{R}^d, \boldsymbol{w}' \in \mathbb{R}^{d+1}, \boldsymbol{x}' \in \mathbb{R}^{d+1}),$$ (3.44)

其中 $\boldsymbol{w}' = (\boldsymbol{w};b)$，$\boldsymbol{x}' = (\boldsymbol{x};1)$。如果 $D' = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_{d+2}\}$ 能被 $\mathbb{R}^d$ 中非齐次线性超平面打散，则 $D'' = \{\boldsymbol{x}'_1,\ldots,\boldsymbol{x}'_{d+2}\}$ 能被 $\mathbb{R}^{d+1}$ 中齐次线性超平面打散，这与定理 3.5 矛盾。因此，非齐次线性超平面构成的假设空间 VC 维为 $d + 1$。 □

线性超平面构成的假设空间复杂度不仅可基于 VC 维进行刻画，还可基于 Rademacher 复杂度进行刻画。但 Rademacher 复杂度与数据分布相关，因此在计算 Rademacher 复杂度时需要将分布 $\mathcal{D}$ 限制在某一范围内。

**定理 3.7**：若 $\|\boldsymbol{x}\| \leq r$，$D$ 为大小为 $m$ 的数据集，则超平面族 $\mathcal{H} = \{\boldsymbol{x} \mapsto \boldsymbol{w}^{\top}\boldsymbol{x} : \|\boldsymbol{w}\| \leq \Lambda\}$ 的经验 Rademacher 复杂度满足

$$\hat{\mathfrak{R}}_D(\mathcal{H}) \leq \sqrt{\frac{r^2\Lambda^2}{m}}.$$ (3.45)

**证明**：

$$\begin{aligned}
\hat{\mathfrak{R}}_D(\mathcal{H}) &= \frac{1}{m}\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{w}}\sum_{i=1}^m \sigma_i\boldsymbol{w}^{\top}\boldsymbol{x}_i\right]\\
&= \frac{1}{m}\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{\boldsymbol{w}}\boldsymbol{w}^{\top}\sum_{i=1}^m \sigma_i\boldsymbol{x}_i\right]\\
&\leq \frac{\Lambda}{m}\mathbb{E}_{\boldsymbol{\sigma}}\left\|\sum_{i=1}^m \sigma_i\boldsymbol{x}_i\right\|\\
&\leq \frac{\Lambda}{m}\left[\mathbb{E}_{\boldsymbol{\sigma}}\left\|\sum_{i=1}^m \sigma_i\boldsymbol{x}_i\right\|^2\right]^{1/2}\\
&= \frac{\Lambda}{m}\left[\mathbb{E}_{\boldsymbol{\sigma}}\left[\sum_{i,j=1}^m \sigma_i\sigma_j(\boldsymbol{x}_i^{\top}\boldsymbol{x}_j)\right]\right]^{1/2}\\
&\leq \frac{\Lambda}{m}\left[\sum_{i=1}^m \|\boldsymbol{x}_i\|^2\right]^{1/2} \leq \sqrt{\frac{r^2\Lambda^2}{m}}.$$ (3.46)

从而定理得证。 □

不难发现，定理 3.7 只给出了 Rademacher 复杂度的上界。这是因为我们先前提到过的 Rademacher 复杂度依赖数据分布，使得计算 Rademacher 复杂度的具体数值相当困难。

### 3.2 支持向量机

由于原样本空间往往是线性不可分的，支持向量机通常需要将原样本空间映射到可分的高维空间，并在高维空间中进行分类。由定理 3.6 可知，若高维空间的维数为 $d$，则支持向量机考虑的假设空间 VC 维为 $d + 1$。在实际应用中，映射后的高维空间维数通常很大甚至无穷，使得依赖空间维数的 VC 维失去了实际意义。这时就需要采用一种与空间维数无关的 VC 维进行刻画。虽然这种刻画方法与空间维数无关，但仍需要对超平面加以限制，对于限制后的超平面可以得到下面的定理 [Vapnik, 1998]。

**定理 3.8**：若 $\|\boldsymbol{x}\| \leq r$，则超平面族 $\{\boldsymbol{x} \mapsto \text{sign}(\boldsymbol{w}^{\top}\boldsymbol{x}) : \min_{\boldsymbol{x}}|\boldsymbol{w}^{\top}\boldsymbol{x}| = 1 \wedge \|\boldsymbol{w}\| \leq \Lambda\}$ 的 VC 维 $d$ 满足

$$d \leq r^2\Lambda^2.$$ (3.47)

**证明**：令 $\{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_d\}$ 为能被超平面族打散的集合，则对于任意 $\boldsymbol{y} = (y_1,\cdots,y_d) \in \{-1,+1\}^d$ 存在 $\boldsymbol{w}$ 使得

$$y_i(\boldsymbol{w}^{\top}\boldsymbol{x}_i) \geq 1 \quad (i \in [d]).$$ (3.48)

对这些不等式求和可得

$$d \leq \boldsymbol{w}^{\top}\sum_{i=1}^d y_i\boldsymbol{x}_i \leq \|\boldsymbol{w}\|\left\|\sum_{i=1}^d y_i\boldsymbol{x}_i\right\| \leq \Lambda\left\|\sum_{i=1}^d y_i\boldsymbol{x}_i\right\|.$$ (3.49)

由于 (3.49) 对任意 $\boldsymbol{y} \in \{-1,+1\}^d$ 都成立，对其两边按 $y_1,\ldots,y_d$ 服从 $\{-1,+1\}$ 独立且均匀的分布取期望可得

$$d \leq \Lambda\mathbb{E}_{\boldsymbol{y}}\left\|\sum_{i=1}^d y_i\boldsymbol{x}_i\right\|
\leq \Lambda\left[\mathbb{E}_{\boldsymbol{y}}\left\|\sum_{i=1}^d y_i\boldsymbol{x}_i\right\|^2\right]^{1/2}
= \Lambda\left[\sum_{i,j=1}^d \mathbb{E}_{\boldsymbol{y}}[y_iy_j](\boldsymbol{x}_i^{\top}\boldsymbol{x}_j)\right]^{1/2}
= \Lambda\left[\sum_{i=1}^d(\boldsymbol{x}_i^{\top}\boldsymbol{x}_i)\right]^{1/2}
\leq \Lambda(dr^2)^{1/2}
= \Lambda r\sqrt{d},$$ (3.50)

从而可知 $\sqrt{d} \leq \Lambda r$，定理得证。 □ -->

### 3.3 多层神经网络

<!-- 
### 3.3 多层神经网络

在 3.1 节介绍了多分类问题中的增长函数，假设空间 $\mathcal{H}$ 中的假设是 $\mathcal{X}$ 到 $\mathcal{Y} = \{0,\ldots,K-1\}$ 的映射，其中 $K$ 为类别数。对于集合 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}$，由 (3.15) 可知假设空间 $\mathcal{H}$ 的增长函数可以表示为

$$\Pi_{\mathcal{H}}(m) = \max_{(\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m)\subset\mathcal{X}}|\{(h(\boldsymbol{x}_1),\ldots,h(\boldsymbol{x}_m))|h \in \mathcal{H}\}|
= \max_{D\subset\mathcal{X}}|\mathcal{H}_{\mid D}|,$$ (3.51)

易知 $\Pi_{\mathcal{H}}(m) \leq |\mathcal{Y}|^m$。

**引理 3.2**：令 $\mathcal{F}^{(1)} \subset \mathcal{Y}_1^{\mathcal{X}}$，$\mathcal{F}^{(2)} \subset \mathcal{Y}_2^{\mathcal{X}}$ 为两个函数族，$\mathcal{F} = \mathcal{F}^{(1)} \times \mathcal{F}^{(2)}$ 为它们的笛卡尔积，有

$$\Pi_{\mathcal{F}}(m) \leq \Pi_{\mathcal{F}^{(1)}}(m) \cdot \Pi_{\mathcal{F}^{(2)}}(m).$$ (3.52)

**证明**：对于大小为 $m$ 且独立同分布从 $\mathcal{X}$ 中采样得到的训练集 $D \subset \mathcal{X}$，根据笛卡尔积的定义可知

$$|\mathcal{F}|_D| = |\mathcal{F}^{(1)}_D| \cdot |\mathcal{F}^{(2)}_D|
\leq \Pi_{\mathcal{F}^{(1)}}(m) \cdot \Pi_{\mathcal{F}^{(2)}}(m).$$ (3.53)

由 $D$ 的任意性可知引理得证。 □

**引理 3.3**：令 $\mathcal{F}^{(1)} \subset \mathcal{Y}_1^{\mathcal{X}}$，$\mathcal{F}^{(2)} \subset \mathcal{Y}_2^{\mathcal{X}}$ 为两个函数族，$\mathcal{F} = \mathcal{F}^{(2)} \circ \mathcal{F}^{(1)}$ 为它们的复合函数族，有

$$\Pi_{\mathcal{F}}(m) \leq \Pi_{\mathcal{F}^{(2)}}(m) \cdot \Pi_{\mathcal{F}^{(1)}}(m).$$ (3.54)

**证明**：对于大小为 $m$ 且独立同分布从 $\mathcal{X}$ 中采样得到的训练集 $D \subset \mathcal{X}$，根据 $\mathcal{F}$ 的定义有

$$\mathcal{F}|_D = \{(f_2(f_1(\boldsymbol{x}_1)),\ldots,f_2(f_1(\boldsymbol{x}_m)))|f_1 \in \mathcal{F}^{(1)}, f_2 \in \mathcal{F}^{(2)}\}
= \bigcup_{\boldsymbol{u}_1\in\mathcal{F}^{(1)}_D}\{(f_2(\boldsymbol{u}_1),\ldots,f_2(\boldsymbol{u}_m))|f_2 \in \mathcal{F}^{(2)}\}.$$ (3.55)

因此有

$$|\mathcal{F}|_D| \leq \sum_{\boldsymbol{u}_1\in\mathcal{F}^{(1)}_D}|\{(f_2(\boldsymbol{u}_1),\ldots,f_2(\boldsymbol{u}_m))|f_2 \in \mathcal{F}^{(2)}\}|
\leq \sum_{\boldsymbol{u}_1\in\mathcal{F}^{(1)}_D} \Pi_{\mathcal{F}^{(2)}}(m)
= |\mathcal{F}^{(1)}_D| \cdot \Pi_{\mathcal{F}^{(2)}}(m)
\leq \Pi_{\mathcal{F}^{(2)}}(m) \cdot \Pi_{\mathcal{F}^{(1)}}(m).$$ (3.56)

根据 $D$ 的任意性可知引理得证。 □

一般来说，神经网络中的每个神经元 $v$ 计算一个函数 $\varphi(\boldsymbol{w}_v^{\top}\boldsymbol{x} - \theta_v)$，其中 $\varphi$ 被称为激活函数，$\boldsymbol{w}_v$ 是与神经元 $v$ 相关的权值参数，$\theta_v$ 是与神经元 $v$ 相关的阈值参数，$\varphi$ 以 $\boldsymbol{w}_v^{\top}\boldsymbol{x} - \theta_v$ 为输入，输出激活信号。本节主要考虑使用符号激活函数 $\varphi(t) = \text{sign}(t)$ 的多层神经网络。假设输入空间 $\mathcal{X} = \mathbb{R}^{d_0}$，一个 $l$ 层的多层网络可以简化为一系列映射的复合：

$$f_l \circ \cdots \circ f_2 \circ f_1(\boldsymbol{x}),$$ (3.57)

其中

$$f_i : \mathbb{R}^{d_{i-1}} \mapsto \{\pm1\}^{d_i} \quad (i \in [l-1]),$$
$$f_l : \mathbb{R}^{d_{l-1}} \mapsto \{\pm1\}.$$ (3.58)

$f_i$ 是一个多维到多维的映射，可以将其分解为若干个二值多元函数，对于 $f_i$ 的每个分量 $f_{i,j} : \mathbb{R}^{d_{i-1}} \mapsto \{\pm1\}$ 表示为 $f_{i,j}(\boldsymbol{u}) = \text{sign}(\boldsymbol{w}_{i,j}^{\top}\boldsymbol{u} - \theta_{i,j})$，其中 $\boldsymbol{w}_{i,j} \in \mathbb{R}^{d_{i-1}}$，$\theta_{i,j} \in \mathbb{R}$ 分别为关于第 $i$ 层第 $j$ 个神经元的权值参数与阈值参数。将多元函数 $f_{i,j}(\boldsymbol{u})$ 的函数族记为 $\mathcal{F}^{(i,j)}$，关于第 $i$ 层的函数族可以表示为

$$\mathcal{F}^{(i)} = \mathcal{F}^{(i,1)} \times \cdots \times \mathcal{F}^{(i,d_i)},$$ (3.59)

从而整个多层神经网络的函数族可以表示为

$$\mathcal{F} = \mathcal{F}^{(l)} \circ \cdots \circ \mathcal{F}^{(2)} \circ \mathcal{F}^{(1)}.$$ (3.60)

根据引理 3.1、引理 3.2、定理 3.1 和定理 3.6 可得

$$\Pi_{\mathcal{F}}(m) \leq \prod_{i=1}^l \Pi_{\mathcal{F}^{(i)}}(m)
\leq \prod_{i=1}^l \prod_{j=1}^{d_i} \Pi_{\mathcal{F}^{(i,j)}}(m)
\leq \prod_{i=1}^l \prod_{j=1}^{d_i} \left(\frac{e \cdot m}{d_{i-1}+1}\right)^{d_{i-1}+1}.$$ (3.61)

令 $N = \sum_{i=1}^l \sum_{j=1}^{d_i}(d_{i-1}+1)$ 表示整个多层神经网络的参数总目，可以将 (3.61) 化简为

$$\Pi_{\mathcal{F}}(m) \leq (e \cdot m)^N,$$ (3.62)

进一步可以计算出 $\mathcal{F}$ 的 VC 维的上界。

**定理 3.9**：令 $\mathcal{F}$ 表示对应多层神经网络的函数族，其 VC 维 $\text{VC}(\mathcal{F}) = O(N\log_2 N)$。

**证明**：假设能被 $\mathcal{F}$ 打散的最大样本集大小为 $d$，易知 $\Pi_{\mathcal{F}}(d) = 2^d$，由 (3.62) 可知

$$2^d \leq (de)^N,$$ (3.63)

化简可得 $d = O(N\log_2 N)$，从而定理得证。 □
 -->
