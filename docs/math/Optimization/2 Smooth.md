# 光滑优化基础

## 松弛和近似

### 概念

对于一般的非光滑优化，我们最常见的方法就是松弛/Relaxation 和近似/Approximation 两个方法，松弛的思想如下：

考虑一个无约束优化问题 $\displaystyle \min_{x\in\mathbb{R}^n} f(x)$，其中 $f$ 是一个光滑函数，我们希望找到一个单调非增的序列 $\left\{f(x_k)\right\}_{k=0}^\infty$，满足 $f(x_{k+1}) \leqslant f(x_k)$，若 $f$ 在 $\mathbb{R}^n$ 上有下界，那么这个函数值序列当然收敛，这个序列就称为松弛序列。但是松弛序列有可能不收敛到全局最优，也不一定收敛到局部最优。

近似就是使用一个性质更加接近的、更简单的对象来替代原来的复杂的对象。非线性优化一般基于非线性函数可微性的局部近似，常见的是一阶近似和二阶近似。

### 一阶近似

若 $f(x)$ 在 $\bar{x}\in\mathbb{R}^n$ 上可微，那么对于 $y\in \mathbb{R}^n$，我们有：

$$f(y) = f(\bar{x}) + \langle \nabla f(\bar{x}), y - \bar{x}\rangle + o(\Vert y - \bar{x}\Vert_2).$$

一眼看上去就是泰勒展开，$f(\bar{x}) + \langle \nabla f(\bar{x}), y - \bar{x}\rangle$ 就称为 $f$ 在 $\bar{x}$ 处的线性近似。

首先考虑给出两个记号：

- $f$ 的次水平集：$\mathcal{L}_f(\alpha) = \{x \in\mathbb{R}^n|\; f(x) \leqslant \alpha\}$；
- 在 $\bar{x}$ 处与 $\mathcal{L}_f f(\bar{x})$ 相切的方向集：$S_f(\bar{x}) = \left\{s \in \mathbb{R}^n\;\vert\; s = \lim_{x_k\to\bar{x} \atop f(x_k) = f(\bar{x})}\frac{x_k-\bar{x}}{\lVert x_k - x\rVert}\right\}$

这个集合是全部和 $\nabla f(\bar{x})$ 垂直的向量集合，也就是说对任意的 $s\in S_f(\bar{x})$，我们有 $\langle \nabla f(\bar{x}), s\rangle = 0$。

???+ note "证明"
    因为 $f(x_k) = f(\bar{x})$，有

    $$f(\bar{x}) = f(x_k) = f(\bar{x}) + \langle\nabla f(\bar{x}), x_k - \bar{x}\rangle + o(\lVert x_k-\bar{x}\rVert)$$

    那么 $\langle\nabla f(\bar{x}), x_k-\bar{x}\rangle + o(\lVert x_k-\bar{x}\rVert) = 0$，两边同除以 $\lVert x_k-\bar{x}\rVert$，令 $x_k\to\bar{x}$ 即得。

**定理**：梯度的反方向 $-\nabla f(\bar{x})$ 是 $f(x)$ 在 $\bar{x}$ 处下降最快的方向。

???+ note "证明"
    令 $s\in\mathbb{R}^n$ 是一个方向，$\lVert s\rVert = 1$，那么 $f(x)$ 在 $\bar{x}$ 处沿着 $s$ 的局部下降是

    $$\displaystyle\Delta(s) = \lim_{\alpha\downarrow 0}\frac{1}{\alpha}\big(f(\bar{x}+\alpha s)-f(\bar{x})\big).$$

    注意到局部性与 $f(\bar{x}+\alpha s)-f(\bar{x})=\alpha \langle\nabla f(\bar{x}), s\rangle + o(\alpha\lVert s\rVert)$，因此 $\Delta(s) = \langle \nabla f(\bar{x}), s\rangle$；而根据柯西-施瓦茨不等式
    
    $$\displaystyle\Delta(s)=\langle\nabla f(\bar{x}), s\rangle \geqslant -\lVert \nabla f(\bar{x})\rVert\lVert s\rVert = -\lVert \nabla f(\bar{x})\rVert,$$
    
    其在 $\nabla f(\bar{x})$ 和 $s$ 反向，即 $s = -\dfrac{\nabla f(\bar{x})}{\lVert \nabla f(\bar{x})\rVert}$ 时取等。我们这就得到了局部下降最快的方向，即切线方向的反方向。这也符合直觉。 

**定理**：假设 $x^*$ 是可微函数 $f(x)$ 的局部最优点，那么 $\nabla f(x^*) = 0$。

证明和一维函数的情况类似，故略。

可微函数的梯度为零是局部最优的必要条件而非充分条件，我们称所有满足 $\nabla f(x^*) = 0$ 的点为驻点。值得注意的是，上述条件后边一般称为一阶优化条件/一阶最优条件。

在加入约束的情况下，最优解的情况很容易会发生改变，我们并不能保证这时候的点梯度仍然为零，而是得到了另一个新的条件。

**定理**：令 $x^*$ 是可微函数 $f(x)$ 的局部最优点，同时满足线性等式约束 $\displaystyle x\in X = \{x\in\mathbb{R}^n\;\vert\; Ax = b\} \neq \emptyset$，其中 $A$ 是 $m \times n$ 矩阵， $b \in \mathbb{R}^m$，$m < n$。我们有如下结论：存在一个向量 $\lambda^*$ 满足 $\nabla f(x^*) = A^\top{\lambda}^*$，亦即，$\nabla f(x^*)$ 属于 $A$ 的行空间。

???+ note "证明"
    假设 $A$ 的零空间的所有基为 $u_i,\;i=1,\dots,k$，那么对于任意 $x\in\{x \in \mathbb{R}^n \;\vert\; Ax = b\}$，$x$ 可以表述为

    $$x = x(y) \equiv x^*+ \sum_{i=1}^ky^{(i)} u_i,\; y\in\mathbb{R}^k.$$

    这是因为 $x^*$ 和 $x\in X$ 显然都满足线性约束，由于 $y = 0$ 是函数 $\phi(y) = f(x(y))$ 的局部最优点（因为 $x(0) = x^*$），那么

    $$\frac{\partial\phi(0)}{\partial y^{(i)}}=\frac{\partial\phi(0)}{\partial x(y)}\cdot \frac{\partial x(y)}{\partial y^{(i)}} = \langle\nabla f(x^*), u_i\rangle = 0,\; i=1,\dots,k.$$

    考虑到行空间和零空间互为正交补，得证。

### 二阶近似

<!--
二阶近似
设 f( x) 在 \bar{ x} 处二阶可微，那么有
\begin{align} f( y)=
f(\bar{ x})+\langle \nabla f(\bar{ x}), y-\bar{ x}\rangle
+\frac{1}{2}\langle \nabla^2 f(\bar{ x})( y-\bar{ x}), y-\bar{ x}\rangle +
o(\lVert y-\bar{ x}\rVert^2) \end{align}
（即二阶泰勒展开 :-）我们称二次函数 f(\bar{ x})+\langle\nabla f(\bar{ x}), y-\bar{
x}\rangle +\frac{1}{2}\langle \nabla^2 f(\bar{ x})( y-\bar{ x}), y-\bar{ x}\rangle
是 f 在 \bar{ x} 处的二阶近似（或者说二 次近似 ） 。
我们可以给出局部最优点的必要条件：
定理：假设  x^* 是二阶可微函数 f( x) 的局部最优点，那么 -->

<!-- 下面的所有数学公式都不需要多余的 { 和 }，也不要有 \bm 命令，并且要做好空格 -->

**定理**：$x^*$ 是二阶可微函数 $f(x)$ 的严格局部最优点的充分条件是 $\nabla f(x^*) = 0$ 且 $\nabla^2 f(x^*)\succ 0$。

???+ note "证明"
    我们有 $f(x^\prime) = f(x^*) +\dfrac{1}{2}\langle \nabla^2 f(x^*)(x^\prime - x^*), x^\prime - x^*\rangle+o(\lVert x^\prime - x^*\rVert^2)$，令 $r = \lVert x^\prime - x^*\rVert$，那么当 $r^2\downarrow 0$ 时有 $\dfrac{o(r^2)}{r^2}\to 0$，所以存在 $\bar{r}$ 使得对于所有 $r\in[0,\bar{r}]$，有 
    
    $$|o(r^2)|\leqslant \dfrac{r^2}{4}\lambda_1 \ \text{即}\ o(r^2)\geqslant -\dfrac{r^2}{4}\lambda_1=-\dfrac{1}{4}\lambda_1\lVert x^\prime - x^*\rVert^2.$$

    其中 $\lambda_1$ 是矩阵 $\nabla^2 f(x^*)$ 的最小特征值。而我们又有

    $$\begin{aligned} \langle\nabla^2 f(x^*)(x^\prime - x^*), x^\prime - x^*\rangle &= (x^\prime - x^*)^\top \nabla^2 f(x^*)(x^\prime - x^*) \\ &\geqslant \lambda_1 (x^\prime - x^*)^\top(x^\prime - x^*) \\ &= \lambda_1\lVert x^\prime - x^*\rVert^2,\end{aligned}$$

    其中不等式来自于 Rayleigh-Ritz 定理。我们结合上两式，就可以得到

    $$\begin{aligned} f(x^\prime) &= f(x^*) +\dfrac{1}{2}\langle \nabla^2 f(x^*)(x^\prime - x^*), x^\prime - x^*\rangle+o(\lVert x^\prime - x^*\rVert^2 ) \\ &\geqslant f(x^*)+\dfrac{1}{2}\lambda_1\lVert x^\prime - x^*\rVert^2- \dfrac{1}{4}\lVert x^\prime - x^*\rVert^2\\ &= f(x^*)+\dfrac{1}{4}\lambda_1\lVert x^\prime - x^*\rVert^2 > f(x^*), \end{aligned}$$

这样我们就证明了严格局部最优值的充分条件，严格体现在这个 Hessian 矩阵是正定的，也就是 $\nabla^2 f(x^*)\succ 0$。但是这个严格是不能去诶到的，因为如果 $\nabla^2 f(x^*)\succeq 0$，那么 $\lambda_1 \geqslant 0$，在 $\lambda_1 = 0$ 的情况下无法推导出 $|o(r^2)|\leqslant \dfrac{r^2}{4}\lambda_1$。而且这也并非是必要条件，有的点可能是严格最小值点，但该点处的 Hessian 矩阵不是正定；例如，$x = 0$ 是 $f(x) = (x^\top x)^2$ 的严格局部最小点，但其 Hessian 矩阵为零矩阵。

## 可微函数类

只假设函数的可微性并不能保证极小化过程中的所有合理性质，我们更多是要求函数满足一定阶导数的 Lipschitz 条件。记 $Q$ 是 $\mathbb{R}^n$ 的一个子集，$C_{L}^{k,p}(Q)$ 代表有下列性质的一类函数：

- 在 $Q$ 上 $k$ 阶连续可微；
- 在 $Q$ 上的 $p$ 阶导数关于常数 $L$ 是 Lipschitz 连续的，即对于 $\forall x, y \in Q$，有 $\lVert \nabla^pf(x)-\nabla^pf(y)\rVert\leqslant L\lVert x-y\rVert$。

直接来说，$C_{L}^{k,p}(Q)$ 是在 $Q$ 上 $k$ 次连续可微，且其 $p$ 阶导数关于常数 $L$ 是 Lipschitz 连续的函数组成的集合，这些函数一定有如下性质成立：

- $p\leqslant k$ 显然成立；
- 如果 $q\geqslant k$，那么 $C_{L}^{q,p}(Q)\subseteq C_{L}^{k,p}(Q)$；
- 如果 $f_1\in C_{L_1}^{k,p}(Q)$，$f_2\in C_{L_2}^{k,p}(Q)$，$\alpha, \beta \in \mathbb{R}$，那么对于 $L_3 = |\alpha|L_1+|\beta|L_2$，有 $\alpha f_1+\beta f_2 \in C_{L_3}^{k,p}(Q)$。

<!-- 下面的所有数学公式都不需要多余的 { 和 }，也不要有 \bm 命令，并且要做好空格 -->

考察最简单的 $C_L^{1,1}(\mathbb{R}^n)$，由定义有 $\left\lVert\nabla f(x) - \nabla f(y)\right\rVert \leqslant L\lVert x-y\rVert$。例如，二次函数 $\displaystyle f_2(x) = \alpha + \langle a, x\rangle + \frac{1}{2}\langle Ax, x\rangle$，其中 $A = A^\top$，我们有 $\nabla f_2(x) = a + Ax$，$\nabla^2 f(x) = A$，因此 $f_2(x)\in C_L^{1,1}(\mathbb{R}^n)$，其中 $L = \lVert A\rVert$。

<!-- 
这可能是我们第一次接触矩阵的范数，在此补充一下，矩阵 \bm A 的 \ell_p 范数是一种算子范数
，可以由对应的向量范数诱导而来，定义为 \begin{align} \lVert \bm A\rVert_p = \sup_{\bm
x\ne\bm 0}\frac{\lVert \bm A\bm x\rVert_p}{\lVert \bm x\rVert_p} \end{align} ，可参阅
en.wikipedia.org/wiki/M... 或者张贤达《矩阵分析与应用》1.4.5. p.45 等等。可以证明，矩阵的 2
范数 \lVert\bm A\rVert = \sqrt{\lambda_{max}} ，其中 \lambda_{max} 是 \bm A^\top \bm A 最大
的特征值；矩阵的 2 范数又称谱范数 ，矩阵特征值 绝对值的最大值又称该矩阵的谱半径
（spectral radius） 。这些都是很基本的内容，我们不展开介绍。
-->

**引理**：函数 $f(x)\in C_{L}^{2,1}(\mathbb{R}^n)\subset C_{L}^{1,1}(\mathbb{R}^n)$ 当且仅当 $\left\lVert\nabla^2 f(x)\right\rVert\leqslant L$，即函数的 Lipschitz 性质对应的是更高一阶的导数的界。

???+ note "证明"
    - 必要性：对于任意 $x, y\in\mathbb{R}^n$，有 

        $$\nabla f(y) = \nabla f(x) + \int_0^1\nabla^2 f(x+\tau(y-x))(y-x)\mathrm{d}\tau = \nabla f(x) + (y-x)\int_0^1\nabla^2 f(x+\tau(y-x))\mathrm{d}\tau.$$

        因此

        $$\begin{align} \Vert f(y) - f(x) &= \left\lVert (y-x)\int_0^1\nabla^2 f(x+\tau(y-x))\mathrm{d}\tau \right\rVert \\ &\leqslant \lVert y-x\rVert\cdot \left\lVert \int_0^1\nabla^2 f(x+\tau(y-x))\mathrm{d}\tau\right\rVert \\ &\leqslant \int_0^1\lVert \nabla^2 f(x+\tau(y-x))\rVert\mathrm{d}\tau\cdot \lVert y-x\rVert \leqslant L\lVert y-x\rVert. \end{align}$$

        第二行的不等式来自 Cauchy-Schwarz 不等式，第三行的不等式就是三角不等式的积分形式，所以完成了必要性的证明。

    - 充分性：如果 $f(x)\in C_{L}^{2,1}(\mathbb{R}^n)$，那么对于任意 $s\in\mathbb{R}^n$，$\alpha > 0$，有

        $$\left\lVert \left(\int_0^\alpha\nabla^2 f(x+\tau s)\mathrm{d}\tau\right)\cdot s\right\rVert = \lVert \nabla f(x+\alpha s) - \nabla f(x)\rVert \leqslant \alpha L\lVert s\rVert.$$

        令 $\displaystyle\Phi(\alpha) = \int_0^\alpha\nabla^2 f(x+\tau s)\mathrm{d}\tau$，那么将上式不等号两边同除以 $\alpha$，令 $\alpha\downarrow 0$，有

        $$\left\lVert \left(\lim_{\alpha\downarrow 0}\dfrac{\Phi(\alpha)}{\alpha}\right)\cdot s\right\rVert = \left\lVert \left(\lim_{\alpha\downarrow 0}\dfrac{\Phi(\alpha)-\Phi(0)}{\alpha-0}\right)\cdot s\right\rVert = \lVert \nabla\Phi(0)\cdot s\rVert \leqslant L\lVert s\rVert.$$

        即，$\dfrac{\lVert \nabla\Phi(0)\cdot s\rVert}{\lVert s\rVert}\leqslant L$，所以对矩阵 $\nabla\Phi(0)$ 有 $\lVert \nabla\Phi(0)\rVert = \sup_{s\neq 0}\dfrac{\lVert \nabla\Phi(0)\cdot s\rVert}{\lVert s\rVert}\leqslant L$，那么自然有 $\lVert\nabla^2 f(x)\rVert = \lVert \nabla \Phi(0)\rVert\leqslant L$。

    这就完成了证明。


## 凸函数

对于一个目标函数是光滑的无约束优化问题 $\displaystyle \min\limits_{x\in \mathbb{R}^n}f(x)$，其实想要进行优化是很困难的，一不能保证优化算法收敛到局部最优值，也不能保证优化算法复杂度上届，所以我们需要引入一些新的假设：

- 对研究的某类函数 $\mathcal{F}$，我们希望 $\mathcal{F}$ 内的任意函数均能使的一阶最优条件成为极小化问题的解；

进一步，我们还希望这个函数类很“大”，至少很容易判断，并且也具有线性函数作为基元素，对一些简单的运算封闭：

- 如果 $f_1$ 和 $f_2$ 属于 $\mathcal{F}$，$\alpha, \beta \geqslant 0$，那么 $\alpha f_1 + \beta f_2 \in \mathcal{F}$；
- $\mathcal{F}$ 中包含线性函数 $l(x) = \alpha + \langle a, x\rangle$。

<!-- 考虑一个无约束优化问题\begin{align} \min_{\bm x \in \mathbb{R}^n}f(\bm x) \end{align} ，其中
目标函数 是光滑的。这种情况下我们其实做不了什么⸺既不能保证优化算法 收敛到局部最优
值，也不能保证优化算法复杂度 上界。为了使问题更加容易处理，我们得引入一些新的假设。
可以得出结论：之所以出现这种情况，主要原因是一阶优化条件 太弱了。我们希望的性质是，有
这样一类函数 \mathcal{F} ，对于任意 f\in\mathcal{F} ，
一 阶最优条件足 以令一 个点成为上述问
题的解 （假设一） 。此时通过局部最优性就可以得到全局最优性 ，这是我们研究凸优化问题的最重
要原因。该特点在组合优化 中有时被称作“精确邻域 （exact neighborhood） ”。
进一步，我们还应该能够比较容易地判断某一个函数 f 是否属于 \mathcal{F} ；通常情况下，这种
结构有一些基元素 （就像向量空间中的基） ，以及对与该元素的封闭运算（即运算结果仍在
\mathcal{F} 中） 。假设 \mathcal{F} 对于加法是封闭的，即如果 f_1,f_2\in\mathcal{F} ，
\alpha,\beta\ge 0 ，那么 \alpha f_1+\beta f_2 \in \mathcal{F} （假设二） 。同样，注意到线性函数
符合假设二，我们为 \mathcal{F} 中加入线性函数作为基元素，即，任意的线性函数 l(\bm
x)=\alpha + \langle \bm a,\bm x\rangle\in\mathcal{F} （假设三） 。 -->



<!-- 
考虑 f\in\mathcal{F} ，固定 \bm x_0\in\mathbb{R}^n ，考察如下函数
\begin{align} \phi(\bm y)=
f(\bm y)-\langle\nabla f(\bm x_0),\bm y\rangle \end{align}
根据假设二和三， \phi(\bm y)\in \mathcal{F} ，注意到 \nabla \phi(\bm x_0) = 0 ，根据假设一
，
\bm x_0 应该是 \phi 的全局最优点；因此，对于 \forall \bm y \in \mathbb{R}^n ，有
\begin{align} \phi(\bm y)\ge\phi(\bm x_0)=
f(\bm x_0)-\langle\nabla f(\bm x_0),\bm x_0\rangle
\end{align} -->

### 凸函数的定义

<!-- 虽然我们一般在 \mathbb{R}^n 上研究凸函数的，但是凸函数也可以有有限的定义域，不过这个定
义域必须是凸集（Convex set） ；关于这点我们不做赘述，下面的定义和讨论都是假设函数定义域
为 \mathbb{R}^n 。
关于凸集和更一般的（可能非光滑的）凸函数的定义和介绍，请见第 9 篇文章：
凸函数的定义（1） ：一个连续可微函数 f(\bm x) 被称作 \mathbb{R}^n 上的凸函数，如果对于
\forall \bm x,\bm y\in\mathbb{R}^n ，有
f(\bm y)\ge f(\bm x)+\langle \nabla f(\bm x),\bm y -\bm x\rangle
即， f(\bm x) 始终不小于其线性逼近 ；我们记作 f(\bm x)\in \mathcal{F}^1(\mathbb{R}^n) 。反
过来，如果 -f(\bm x) 是凸函数，那么我们称它是凹函数（concave f
unction ） 。另外，如果上述不
等式对于 \bm y\neq\bm x 都严格取 > ，称函数为严格凸函数。
上述这种定义并不多见，在多数教材上我们看到的往往是与其等价的另一种定义：
凸函数的定义（2） ：一个连续可微函数 f(\bm x) 是 \mathbb{R}^n 上的凸函数，当且仅当对 \forall
\bm x,\bm y \in \mathbb{R}^n ， \alpha \in [0,1] ，有
f(\alpha \bm x+(1-\alpha)\bm y)\le \alpha f(\bm x)+(1-\alpha)f(\bm y)
我们现在证明定义（1）和（2）等价。
（1） \Rightarrow （2） ：已知 f(\bm y)\ge f(\bm x)+\langle \nabla f(\bm x),\bm y -\bm x\rangle
，那么对 \alpha \in [0,1] 有
\begin{align} f(\alpha \bm x+(1-\alpha)\bm y)\le\; & f(\bm y)+\langle \nabla f(\alpha \bm x+(1-
\alpha)\bm y),\bm y -(\alpha \bm x+(1-\alpha)\bm y)\rangle \\ =\;& f(\bm y)+\alpha \langle \nabla
f(\alpha \bm x+(1-\alpha)\bm y),\bm y - \bm x\rangle \\ f(\alpha \bm x+(1-\alpha)\bm y)\le\;&
f(\bm x)+\langle\nabla f( \alpha \bm x+(1-\alpha)\bm y),\bm x-(\alpha \bm x+(1-\alpha)\bm
y)\rangle \\ =\;& f(\bm x)-(1-\alpha)\langle \nabla f( \bm x+(1-\alpha)\bm y),\bm y - \bm x\rangle
\end{align}
第一个不等式乘以 (1-\alpha) ，第二个不等式乘以 \alpha ，相加即证。
（2） \Rightarrow （1） ：已知对 \alpha \in [0,1] ，有 f(\alpha \bm x+(1-\alpha)\bm y)\le \alpha
f(\bm x)+(1-\alpha)f(\bm y)
我们选择一个 \alpha \in [0,1) ，则
\begin{align} f(\bm y)&\ge \frac{1}{1-\alpha}(f(\alpha \bm x+(1-\alpha)\bm y)-\alpha f(\bm x)) \\
&=
f(\bm x)+\frac{1}{1-\alpha}(f(\alpha \bm x+(1-\alpha)\bm y)-f(\bm x))\\ &=
f(\bm x)+\frac{1}{1-\alpha}\big(f(\bm x+(1-\alpha)(\bm y - \bm x))-f(\bm x)\big) \end{align}
注意到最后一个等式第二项是方向导数的表达，令 \alpha\to 1 即证。 （ s 方向上的方向导数表示为
\langle \nabla f(\bm x), \bm s\rangle 。 ）
有时候，我们可能会觉得“凸”和“凹”在语义上很模糊，为什么向下凸起就叫“凸”，向上凸起就叫
“凹”呢？由于这种模糊性，因此有些人也会将其分别称作“上凸 ”和“下凸”。
根据凸函数的定义（2） ，可以从几何角度理解：对于凸函数而言，连接其上两点 (\bm x_1,f(\bm
x_1)) 和 (\bm x_2, f(\bm x_2)) ，那么得到的弦总是在函数图像上方。
凸函数定义（3） ：一个连续可微函数 f(\bm x) 是 \mathbb{R}^n 上的凸函数，当且仅当对 \forall
\bm x,\bm y\in \mathbb{R}^n ，有
\begin{align} \langle \nabla f(\bm x)-\nabla f(\bm y),\bm x-\bm y\rangle\ge 0 \end{align}
我们接下来证明定义（3）与定义（1）等价。
（1） \Rightarrow （3） ：已知对于 \forall \bm x,\bm y\in\mathbb{R}^n ，有 f(\bm y)\ge f(\bm
x)+\langle \nabla f(\bm x),\bm y -\bm x\rangle ，那么
\begin{align} f(\bm y)\ge f(\bm x)+\langle \nabla f(\bm x),\bm y -\bm x\rangle\\ f(\bm x)\ge f(\bm
y)+\langle \nabla f(\bm y),\bm x -\bm y\rangle\\ \end{align}
将上两式相加即证。
（3） \Rightarrow （1） ：已知对 \forall \bm x,\bm y\in \mathbb{R}^n ，有 \begin{align} \langle
\nabla f(\bm x)-\nabla f(\bm y),\bm x-\bm y\rangle\ge 0 \end{align} ，那么
\begin{align} f(\bm y) &=
f(\bm x)+\int_0^1\big\langle \nabla f(\bm x+\tau(\bm y-\bm x)),\bm y-
\bm x\big\rangle \mathrm{d}\tau\\ &=
f(\bm x)+\langle \nabla f(\bm x),\bm y-\bm x\rangle
+\int_0^1\big\langle \nabla f(\bm x+\tau(\bm y-\bm x))-\nabla f(\bm x),\bm y-\bm
x\big\rangle\mathrm{d}\tau\\ &=
f(\bm x)+\langle \nabla f(\bm x),\bm y-\bm x\rangle
+\int_0^1\frac{1}{\tau}\underbrace{\boxed{\big\langle \nabla f(\bm x+\tau(\bm y-\bm x))-\nabla
f(\bm x),(\bm x+\tau(\bm y-\bm x))-\bm x\big\rangle}}_{\ge 0}\mathrm{d}\tau\\ &\ge f(\bm
x)+\langle \nabla f(\bm x),\bm y-\bm x\rangle \end{align}
即证。该定义说明 \bm x\mapsto\nabla f(\bm x) 构成了一个单调映射 （monotonic mapping） 。 -->


在某些地方，会将凸函数定义为 $\displaystyle\frac{1}{2}\left(f(x) + f(y)\right)\geqslant f\left(\frac{x+y}{2}\right)$，这也是凸函数最早的定义，我们特别将其称为中点凸函数。直接来讲，凸函数一定是中点凸函数，反之中点凸函数不一定都是凸函数。在某些条件下，中点凸函数和凸函数是等价的。例如，如果函数在定义域上连续，则中点凸等价于凸函数。也可以证明有界的中点凸函数连续，因此有界的中点凸函数也等价于凸函数。

在更强的条件下，我们还有：

- 如果函数 $f(x)$ 是中点凸函数并且 Lebesgue 可测，那么 $f(x)$ 是凸函数；
- 如果函数 $f(x)$ 是中点凸函数，且在一个正测度集上有界，则 $f(x)$ 是凸函数。

### 凸函数的性质

我们发现凸函数非常好，完美满足了我们想要的性质：

- 如果 $f\in\mathcal{F}^1(\mathbb{R}^n)$，且 $\nabla f(x^*) = 0$，那么 $x^*$ 就一定是 $f(x)$ 在 $\mathbb{R}^n$ 上的全局最优点；
- 如果 $f_1,f_2\in\mathcal{F}^1(\mathbb{R}^n)$ 且 $\alpha,\beta\geqslant 0$ ，则 $f =\alpha f_1+\beta f_2$ 也属于 $\mathcal{F}^1(\mathbb{R}^n)$。

这两个性质在凸函数的第一种定义下都是显然的。

<!-- 根据定义（1） ，这两个结论都是显然的。
此外，我们有下面的结论，
• （仿射复合）如果 f\in\mathcal{F}^1(\mathbb{R}^n) ， \bm b\in\mathbb{R}^m ， \bm
A\in\mathbb{R}^{m\times n} ，有 \phi(\bm x)=
f(\bm A\bm x+\bm
b)\in\mathcal{F}^1(\mathbb{R}^n) 。
证明也很简单，设 \bm x,\bm y\in\mathbb{R}^n ， \bar{\bm x}=\bm A\bm x+\bm b
， \bar{\bm
y}=\bm A\bm y+\bm b ，有 \nabla \phi(\bm x)=\bm A^\top \nabla f(\bm A\bm x+\bm b)=\bm
A^\top \nabla f(\bar{\bm x}) ，我们有
\begin{align} \phi(\bm y)=
f(\bar{\bm y})&\ge f(\bar{\bm x})+\langle \nabla f(\bar{\bm x}),\bar{\bm
y}-\bar{\bm x}\rangle\\ &= \phi(\bm x)+\langle \nabla f(\bar{\bm x}),\bm A(\bm y-\bm x)\rangle \\
&= \phi(\bm x)+\bm A^\top\langle \nabla f(\bar{\bm x}),\bm y-\bm x\rangle \\ &=\phi(\bm
x)+\langle \nabla \phi(\bm x),\bm y-\bm x\rangle \end{align}
• （逐点最大值和上确界 ）如果 f_i (\bm x)\in\mathcal{F}^1(\mathbb{R}^n), \;i\in I ，那么
\begin{align} g(\bm x)=\max_{i\in I}f_i(\bm x)\in \mathcal{F}^1(\mathbb{R}^n) \end{align} 。
即，若干个凸函数组合起来取最大值，得到的函数也是凸函数。该性质可以扩展到无穷集上的逐点
上确界（pointwise supremum） ，设 f(\bm x, \omega) 对于 \bm x 是凸函数，那么对于 \omega \in
\Omega ， \begin{align} g(\bm x) = \sup_{\omega \in \Omega}f(\bm x,\omega) \end{align} 也是
凸函数。
• （单调函数复合）如果 f\in\mathcal{F}^1(\mathbb{R}^n) ，h\in\mathcal{F}^1(\mathbb{R}) ，
且 h 是单调非减（non­ -decreasing）函数，那么 \begin{align} g(\bm x)=h(f(\bm
x))\in\mathcal{F}^1(\mathbb{R}^n) \end{align} ；进一步，如果 f_i\in\mathcal{F}
(\mathbb{R}^n),\; i = 1,\dots,m ， H(y_1,\dots,y_m) 是凸函数且对于每个参数都单调非减，那么
g(\bm x)=H(f_1(\bm x),\dots,f_m(\bm x)) 也是凸函数。
• （部分最小化）如果 f(\bm x,\bm y) 对于 \bm x,\bm y\in\mathbb{R}^n 是凸函数， Y 是一个凸
的非空集，那么 \begin{align} g(\bm x)=\inf_{y\in Y}f(\bm x,\bm y) \end{align} 也是凸函数。
上面三个性质不再具体证明，读者可参阅 Boyd, S. & Vandenberghe, L., (2004). Convex
optimiza
tion, Cambridge university press. Chapter 3. （Stephen Boyd《凸优化》(2013). 王书宁
，许鋆，黄晓霖译，清华大学出版社，第 3 章.） -->

另外一个重要的性质也可以视为凸函数的一个定义，不过是从二阶导数的角度来看的。我们先前已经了解过，判断 $f(x)$ 是凸函数只需判断 $f''(x)\geqslant 0$。定理如下：

**定理/定义**：一个二阶可微函数 $f\in\mathcal{F}^2(\mathbb{R}^n)$ 是凸函数，当且仅当对 $\forall x\in \mathbb{R}^n$，有 $\nabla^2 f(x)\succeq 0$。

???+ note "证明"
    - 必要性：假设 $f(x)\in C^2(\mathbb{R}^n)$ 是凸函数，令 $x_\tau = x+\tau s$，$\tau > 0$，我们有如下等式

        $$\begin{align} \nabla f(x_\tau) - \nabla f(x) &= \int_0^1\nabla^2 f(x+p(x_\tau-x))(x_\tau-x)\mathrm{d}p \\ &= \int_0^1\nabla^2 f(x+\dfrac{\lambda}{\tau}(x_\tau-x))(x_\tau-x)\mathrm{d}\dfrac{\lambda}{\tau} \\ &= \int_0^\tau\nabla^2 f(x+\lambda s)s\mathrm{d}\lambda.\end{align}$$

        根据凸函数的第三种定义及上式，我们有

        $$\begin{align} 0 &\leqslant \dfrac{1}{\tau^2}\left\langle\nabla f(x_{\tau})-\nabla f(x), x_{\tau}-x\right\rangle = \dfrac{1}{\tau}\left\langle \nabla f(x_\tau)-\nabla f(x), s\right\rangle \\ &= \dfrac{1}{\tau}\left\langle\int_0^\tau\nabla^2(x+\lambda s)s\mathrm{d}\lambda, s\right\rangle = \dfrac{1}{\tau}\int_0^\tau\left\langle\nabla^2 f(x+\lambda s)s, s\right\rangle\mathrm{d}\lambda. \end{align}$$

        设 $\Phi(y) = \displaystyle\int_0^{y}\left\langle\nabla^2 f(x+\lambda s)s, s\right\rangle\mathrm{d}\lambda$，那么在上式中令 $\tau\to 0$，有

        $$\begin{align} \lim_{\tau\to 0}\dfrac{1}{\tau}\int_0^\tau\left\langle\nabla^2 f(x+\lambda s)s, s\right\rangle\mathrm{d}\lambda &= \lim_{\tau\to 0}\dfrac{1}{\tau}\left.\left(\int_0^{y+\tau}\left\langle\nabla^2 f(x+\lambda s)s, s\right\rangle\mathrm{d}\lambda - \int_0^{y}\left\langle\nabla^2 f(x+\lambda s)s, s\right\rangle\mathrm{d}\lambda \right)\right|_{y=0}\\ &= \lim_{\tau\to 0}\left.\dfrac{\Phi(y+\tau)-\Phi(y)}{\tau}\right|_{y=0} = \Phi^\prime(y)\big|_{y=0}\\ &= \left\langle\nabla^2 f(x+\lambda s)s, s\right\rangle\big|_{\lambda = 0} = \left\langle\nabla^2 f(x)s, s\right\rangle \geqslant 0. \end{align}$$

        这就得到了 $\left\langle\nabla^2 f(x)s, s\right\rangle\geqslant 0$，即 $\nabla^2 f(x)\succeq 0$。

    - 充分性：设对于 $\forall x\in\mathbb{R}^n$，有 $\nabla^2 f(x)\succeq 0$，设单变量函数 $\Psi(t) = f(x+t(y - x))$，那么考察 $\Psi$ 函数，就有

        $$\begin{align} \Psi(t) = \Psi(0) + \int_0^t\Psi^\prime(\tau)\mathrm{d}\tau = \Psi(0) + \int_0^t\Psi^\prime(0)\mathrm{d}\tau + \int_0^t\int_0^\tau\Psi^{\prime\prime}(\lambda)\mathrm{d}\lambda\mathrm{d}\tau. \end{align}$$

        于是，我们得到

        $$\begin{align} f(y) = \Psi(1) &= \Psi(0) + \int_0^1\Psi^\prime(0)\mathrm{d}\tau + \int_0^1\int_0^\tau\Psi^{\prime\prime}(\lambda)\mathrm{d}\lambda\mathrm{d}\tau\\ &= f(x) + \langle\nabla f(x), y-x\rangle + \int_0^1\int_0^\tau\underbrace{\left\langle\nabla^2 f\big(x+\lambda(y - x)\big)(y-x), y-x\right\rangle}_{\geqslant 0}\mathrm{d}\lambda\mathrm{d}\tau\\ &\geqslant f(x) + \langle\nabla f(x), y-x\rangle. \end{align}$$

    这就完成了证明。

## 光滑凸函数

就像上面我们在可微函数类提到的，我们希望函数的导数在一定阶下是 Lipschitz 连续的，这样我们就可以得到更多的性质。所以我们引入符号 $\mathcal{F}_{L}^{k, p}(\mathbb{R}^n)$，其代表满足下述性质的一类函数：

- 在 $\mathbb{R}^n$ 上是凸函数；
- 属于 $C_{L}^{k,p}(\mathbb{R}^n)$；即 $k$ 阶连续可微且 $p$ 阶导数关于常数 $L$ 是 Lipschitz 连续的。

最重要的一类函数是 $\mathcal{F}^{1,1}_L(\mathbb{R}^n)$，即具有 Lipschitz 连续梯度的一类凸函数，下面证明这类函数的性质。

**定理**：对于 $\forall x, y\in \mathbb{R}$，$\alpha\in[0,1]$，对于 $f\in C_{L}^{1,1}(\mathbb{R}^n)$，有：$f\in\mathcal{F}_{L}^{1,1}(\mathbb{R}^n)$ 与下面六个表述都等价：

1. $\displaystyle 0\leqslant f(y)-f(x) - \langle\nabla f(x), y-x\rangle \leqslant \dfrac{L}{2}\lVert y-x\rVert^2$；
2. $\displaystyle f(x) + \langle\nabla f(x), y-x\rangle + \dfrac{1}{2L}\lVert\nabla f(y)-\nabla f(x)\rVert^2 \leqslant f(y)$；
3. $\displaystyle \dfrac{1}{L}\lVert\nabla f(y)-\nabla f(x)\rVert^2 \leqslant \langle\nabla f(y)-\nabla f(x), y-x\rangle$；
4. $\displaystyle 0\leqslant \langle\nabla f(y)-\nabla f(x), y-x\rangle \leqslant L\lVert y-x\rVert^2$；
5. $\displaystyle \alpha f(x) + (1-\alpha)f(y) - f(\alpha x+(1-\alpha)y) \geqslant \dfrac{\alpha(1-\alpha)}{2L}\lVert\nabla f(y)-\nabla f(x)\rVert^2$；
6. $\displaystyle \alpha f(x) + (1-\alpha)f(y) - f(\alpha x+(1-\alpha)y) \leqslant \dfrac{\alpha(1-\alpha)L}{2}\lVert y-x\rVert^2$。

???+ note "证明"
    - (1) $\iff$ 凸性：几乎是显然的，左面的不等式来自于凸函数的定义，右侧的不等式来自于可微函数类的第二个引理。值得一提的是，$f(y)-f(x) - \langle\nabla f(x), y-x\rangle$ 被称为布雷格曼散度，描述了函数在某个点和其一阶线性近似的差值，原来对于一般的函数的引理给出了布雷格曼散度的下界为 $\displaystyle -\dfrac{L}{2}\lVert y-x\rVert^2$，这里的凸性把下界提升到了零。
    - (1) $\Rightarrow$ (2)：首先固定 $x_0 \in \mathbb{R}^n$，考虑函数 $\displaystyle \phi(y) = f(y) - \langle\nabla f(x_0), y\rangle$，注意到由于 $f\in\mathcal{F}^{1,1}_L(\mathbb{R}^n)$，有 $\phi \in \mathcal{F}^{1,1}_L(\mathbb{R}^n)$，又由于 $\nabla \phi(x_0) = 0$，那么 $\phi$ 的最优点就是 $y^* = x_0$，由式 (1)，

        $$\begin{align} \phi(y^*)&\leqslant \phi(y-\dfrac{1}{L}\nabla \phi(y)) \\ &\leqslant \phi(y)+\left\langle\nabla \phi(y), y - \left(y - \dfrac{1}{L}\nabla \phi(y)\right)\right\rangle+\dfrac{1}{2L}\lVert\nabla \phi(y)\rVert^2 \\ &= \phi(y)-\dfrac{1}{2L}\lVert\nabla \phi(y)\rVert^2 \end{align}$$

        由 $\nabla \phi(y) = \nabla f(y)-\nabla f(x_0)$，代换掉上式的 $\phi$，有

        $$\begin{align} &\phi(y^*)&\leqslant& \phi(y)-\dfrac{1}{2L}\lVert\phi(y)\rVert^2\\ \Rightarrow& f(x_0)-\langle\nabla f(x_0), x_0\rangle &\leqslant& f(y)-\langle\nabla f(x_0), y\rangle -\dfrac{1}{2L}\lVert\phi(y)\rVert^2 \end{align}$$
    - (2) $\Rightarrow$ (3)：将 (2) 中的 $x$ 和 $y$ 互换并与原式相加就可得证。
    - (3) $\Rightarrow$ $\mathcal{F}_{L}^{1,1}(\mathbb{R}^n)$：凸性显然，Lipschitz 连续性只需要 Cauchy-Schwarz 不等式即可得证：

        $$\dfrac{1}{L}\lVert\nabla f(y)-\nabla f(x)\rVert^2 \leqslant \langle\nabla f(y)-\nabla f(x), y-x\rangle \leqslant \lVert\nabla f(y)-\nabla f(x)\rVert\lVert y-x\rVert.$$
    - (1) $\Rightarrow$ (4)：将 (1) 中的 $x$ 和 $y$ 互换并与原式相加就可得证。
    - (4) $\Rightarrow$ (1)：直接积分估计就可得证：

        $$\begin{align} f(y)-f(x) - \langle\nabla f(x), y-x\rangle &= \int_0^1\left\langle\nabla f(x+\tau(y-x))-\nabla f(x), y-x\right\rangle\mathrm{d}\tau \\ &\leqslant \int_0^1\tau L\lVert y-x\rVert^2\mathrm{d}\tau = \dfrac{L}{2}\lVert y-x\rVert^2. \end{align}$$
    - (2) $\Rightarrow$ (5)：根据 (2) 我们有

        $$\begin{align} &f(x) \geqslant f(\alpha x+(1-\alpha)y)+\langle\nabla f(\alpha x+(1-\alpha)y), (1-\alpha)(x-y)\rangle +\dfrac{1}{2L}\lVert\nabla f(x)-\nabla f(\alpha x+(1-\alpha)y)\rVert^2\\  &f(y) \geqslant f(\alpha x+(1-\alpha)y)+\langle \nabla f(\alpha x+(1-\alpha)y), \alpha(y-x)\rangle +\dfrac{1}{2L}\lVert\nabla f(y) - \nabla f(\alpha x+(1-\alpha)y)\rVert^2 \end{align}$$

        使用 $\alpha$ 和 $1 - \alpha$ 配凑系数并且相加就可以得到 

        $$\begin{align} &\alpha f(x) + (1-\alpha)f(y) - f(\alpha x+(1-\alpha)y) \\ &\geqslant \dfrac{\alpha}{2L}\lVert\nabla f(x) - \nabla f(\alpha x+(1-\alpha)y)\rVert^2 + \dfrac{(1-\alpha)}{2L}\lVert\nabla f(y) - \nabla f(\alpha x+(1-\alpha)y)\rVert^2.\end{align}$$

        再使用不等式

        $$\begin{align} \alpha \lVert a\rVert^2 + (1-\alpha)\lVert b\rVert^2 &= (\alpha\lVert a\rVert)^2 + ((1-\alpha)\lVert b\rVert)^2 + \alpha(1-\alpha)(\lVert a\rVert^2 + \lVert b\rVert^2) \\ &\geqslant 2\alpha(1-\alpha)\lVert a\rVert\lVert b\rVert + \alpha(1-\alpha)(\lVert a\rVert^2 + \lVert b\rVert^2) \\ &= \alpha(1-\alpha)(\lVert a\rVert + \lVert b\rVert)^2 \\ &\geqslant \alpha(1-\alpha)\lVert a-b\rVert^2 \end{align}$$

        就可完成证明。
    - (5) $\Rightarrow$ (2)：根据下面的推导则可完成证明，最后一步是令 $\alpha\to 1$：   

        $$\begin{align} &\alpha f(x) + (1-\alpha)f(y) - f(\alpha x+(1-\alpha)y) \geqslant \dfrac{\alpha(1-\alpha)}{2L}\lVert\nabla f(y)-\nabla f(x)\rVert^2 \\ &\Rightarrow f(y) \geqslant \dfrac{f(\alpha x+(1-\alpha)y)-\alpha f(x)}{1-\alpha} + \dfrac{\alpha}{2L}\lVert\nabla f(y)-\nabla f(x)\rVert^2 \\ &\Rightarrow f(y) \geqslant f(x) + \langle\nabla f(x), y-x\rangle + \dfrac{1}{2L}\lVert\nabla f(y)-\nabla f(x)\rVert^2. \end{align}$$
    - (1) $\Rightarrow$ (6)：还是配凑系数，两个式子分别乘以 $\alpha$ 和 $1-\alpha$，然后相加即可得到 (6)。

        $$\begin{align} &0\leqslant f(x) - f(\alpha x+(1-\alpha)y) - \langle\nabla f(\alpha x+(1-\alpha)y), (1-\alpha)(x-y)\rangle \leqslant \dfrac{L}{2}\lVert (1-\alpha)(x-y)\rVert^2 \\ &0\leqslant f(y) - f(\alpha x+(1-\alpha)y) - \langle\nabla f(\alpha x+(1-\alpha)y), \alpha(y-x)\rangle \leqslant \dfrac{L}{2}\lVert \alpha(y-x)\rVert^2 \end{align}$$
    - (6) $\Rightarrow$ (1)：也是令 $\alpha\to 1$ 即可得证。

        $$\begin{align} &\alpha f(x) + (1-\alpha)f(y) - f(\alpha x+(1-\alpha)y) \leqslant \dfrac{\alpha(1-\alpha)L}{2}\lVert y-x\rVert^2 \\ &\Rightarrow f(y) \leqslant \dfrac{f(\alpha x+(1-\alpha)y)-\alpha f(x)}{1-\alpha} + \alpha\dfrac{L}{2}\lVert y-x\rVert^2 \\ &\Rightarrow f(y) \leqslant f(x) + \langle\nabla f(x), y-x\rangle + \dfrac{L}{2}\lVert y-x\rVert^2. \end{align}$$

    这就完成了证明。

我们同样需要研究 $\mathcal{F}^{2,1}_L(\mathbb{R}^n)$ 的特征，有下面的定理：

**定理**：假设二阶连续可微函数 $f\in\mathcal{F}^{2,1}_L(\mathbb{R}^n)$，当且仅当对 $\forall x\in\mathbb{R}^n$，有 $0\preceq \nabla^2 f(x) \preceq LI_n$，其中 $I_n$ 代表单位矩阵。

???+ note "证明"
    根据凸函数的第四种定义可以直接得到 $0\preceq \nabla^2 f(x)$ 等价于 $f\in\mathcal{F}^{2}(\mathbb{R}^n)$，所以我们只需要证明 $\nabla^2 f(x)\preceq L I_n$。

    设 $x_\tau = x+ \tau s$，$\lVert s\rVert = 1$，根据刚刚证明的式 (4)，我们有

    $$L\geqslant \dfrac{1}{\tau}\langle \nabla f(x_\tau)-\nabla f(x), s\rangle = \dfrac{1}{\tau} \langle \nabla f(x+\lambda s), s\rangle\Big|^\tau_{\lambda = 0} = \dfrac{1}{\tau}\int_0^1\langle \nabla^2 f(x+\lambda s)s, s\rangle\mathrm{d}\lambda$$

    在凸函数的第四种定义中，我们已经证明

    $$\lim_{\tau\to 0}\dfrac{1}{\tau}\int_0^\tau\left\langle \nabla^2 f(x+\lambda s)s, s\right\rangle\mathrm{d}\lambda = \left\langle\nabla^2f(x)s, s \right\rangle,$$

    这就说明 $\left\langle\nabla^2f(x)s, s \right\rangle \le L$，即 $\nabla^2 f(x)\preceq L I_n$。

## 强凸函数

虽然凸函数已经有非常好的性质了，但是我们并不清楚函数凸的程度，我们一方面希望函数的最优点是唯一的，另一方面希望在应用基于梯度下降方法的算法时能够达到线性收敛速率。这就引入了强凸函数的概念。

### 强凸函数的定义

**定义**：称连续可微函数 $f$ 在 $\mathbb{R}^n$ 上是强凸的，如果存在常数 $\mu \geqslant 0$，使得对于任意 $x, y\in\mathbb{R}^n$，有

$$f(y)\geqslant f(x)+\langle\nabla f(x), y-x\rangle + \dfrac{1}{2}\mu\lVert y-x\rVert^2.$$

我们将这样的函数记作 $f\in\mathcal{S}^1_\mu(\mathbb{R}^n)$，常数 $\mu$ 称作 $f$ 的凸参数（convexity parameter）。这个定义说明关于该强凸函数的布雷格曼散度（Bregman divergence）$D_f(x, y)$ 不小于 $\dfrac{1}{2}\mu\lVert y-x\rVert^2$。可以看到当 $\mu = 0$ 时强凸函数就退化成了凸函数，我们可以将上面的式子变形：

$$\begin{align} f(y) &\geqslant f(x)+\langle\nabla f(x), y-x\rangle + \dfrac{1}{2}\mu\lVert y-x\rVert^2 \\ &= f(x) + \langle\nabla f(x) +\dfrac{1}{2}\mu(y-x), y-x\rangle. \\ &= f(x) + \langle\nabla f(x) - \mu x + \dfrac{1}{2}\mu(y+x), y-x\rangle \\ &= f(x) + \langle\nabla f(x) - \mu x, y-x\rangle + \dfrac{1}{2}\mu\left(\lVert y^2 \rVert - \lVert x^2 \rVert\right). \end{align}$$

因此可以得到 $f$ 是强凸函数当且仅当 $f(x)-\dfrac{\mu}{2}\lVert x\rVert^2$ 是凸函数。这样立刻就可以得到强凸函数的第二种定义：

**定义**：称连续可微函数 $f$ 在 $\mathbb{R}^n$ 上是强凸的，如果存在常数 $\mu \geqslant 0$，使得对于任意 $x, y\in\mathbb{R}^n$，$\alpha\in[0,1]$，有

$$\alpha f(x)+(1-\alpha)f(y)\geqslant f(\alpha x+(1-\alpha)y)+\alpha(1-\alpha)\dfrac{\mu}{2}\lVert y-x\rVert^2.$$

根据 $\displaystyle \alpha(f(x) - \dfrac{\mu}{2}\lVert x\rVert^2) + (1-\alpha)(f(y) - \dfrac{\mu}{2}\lVert y\rVert^2) \geqslant f(\alpha x+(1-\alpha)y) - \dfrac{\mu}{2}\lVert \alpha x+(1-\alpha)y\rVert^2$ 就可以得到证明。


强凸函数也可以通过对梯度的估计来定义，这类似于凸函数的第二种定义：

**定理**：连续可微函数 $f$ 在 $\mathbb{R}^n$ 是强凸函数的充要条件是存在常数 $\mu \geqslant 0$，使得对于任意 $x, y\in\mathbb{R}^n$ 有、

$$\langle\nabla f(y)-\nabla f(x), y-x\rangle\geqslant \mu\lVert y-x\rVert^2.$$

证明根据强凸函数的第一种定义就可以直接得到：

$$\begin{align} \text{强凸函数定义(1)} &\iff f(x)-\dfrac{\mu}{2}\lVert x\rVert^2\text{ 是凸函数} \\ &\iff \langle(\nabla f(y) - \mu y)-(\nabla f(x)-\mu x), y - x\rangle \geqslant 0 \\ &\iff \text{强凸函数定义(3)} \end{align}$$

### 强凸函数的性质

- 强凸函数的第一种定义，对于 $f\in\mathcal{S}^1_\mu(\mathbb{R}^n)$，$\nabla f(x^*) = 0$，有

    $$f(x)\geqslant f(x^*)+\dfrac{1}{2}\mu\lVert x-x^*\rVert^2.$$

- 如果 $f_1\in\mathcal{S}^1_{\mu_1}(\mathbb{R}^n)$，$f_2\in\mathcal{S}^1_{\mu_2}(\mathbb{R}^n)$，$\alpha,\beta\geqslant 0$，那么 $f = \alpha f_1+\beta f_2 \in \mathcal{S}^1_{\alpha\mu_1+\beta\mu_2}(\mathbb{R}^n)$。

    证明非常简单直接，只需要乘以常数再加起来就好了。这个性质非常有用，注意到 $f\in \mathcal{S}_0^1 \iff f \in \mathcal{F}^1$，那么一个强凸函数与一个凸函数相加，得到的还是强凸函数，且其凸参数不变。在机器学习中 @TODO:过拟合

<!-- 这个结论是很有用的。例如在机器学习中，我们为了防止过拟合 ，会在经验风险 \begin{align}
R_{emp}=\frac{1}{N}\sum_{i=1}^N L(h(\bm x_i),\bm y_i)\end{align} 上增加一个 \ell_2正则化项
（regularizer） ，构成结构化风险 \begin{align}R_{emp}+\lambda\rVert\theta\lVert^2\end{align}
；例如岭回归（Ridge regression，也称脊回归 ）就是如此。由于 \lambda\lVert\theta\rVert^2 便
是一个强凸函数，若 R_{emp} 是一个凸函数，那么我们的目标函数 就变成了强凸函数，拥有良好
的性质，也一定存在一个唯一解。 -->

- 如果 $f\in\mathcal{S}^1_\mu(\mathbb{R}^n)$，那么对任意的 $x, y\in \mathbb{R}^n$，有

    $$f(y)\leqslant f(x)+\langle\nabla f(x), y-x\rangle + \dfrac{1}{2\mu}\lVert\nabla f(x)-\nabla f(y)\rVert^2.$$

    ???+ note "证明"
        继续考虑函数 $\phi(y) = f(y) - \langle\nabla f(x), y-x\rangle$，那么 $\phi(y)\in\mathcal{S}^1_\mu(\mathbb{R}^n)$，且 $\nabla\phi(x) = 0$，所以 $x$ 是 $\phi$ 的全局最优点，根据凸函数定义，对于 $\forall y\in\mathbb{R}^n$，有

        $$\begin{align} \phi(x) &= \min\limits_{v}\phi(v) \\ &\geqslant \min\limits_{v}\left(\phi(y) + \langle \nabla\phi(y), v-y \rangle + \dfrac{1}{2}\mu\lVert v-y \rVert^2\right) \\ &= \phi(y) - \dfrac{1}{2\mu}\lVert \nabla\phi(y) \rVert^2\end{align}.$$

        最后一行是考虑令 $\nabla_v\left(\phi(y) + \langle \nabla\phi(y), v-y \rangle + \dfrac{1}{2}\mu\lVert v-y \rVert^2\right) = 0$，解得 $v = y - \dfrac{1}{\mu}\nabla\phi(y)$，代入即可。

- 如果 $f\in\mathcal{S}^1_\mu(\mathbb{R}^n)$，那么对任意的 $x, y\in \mathbb{R}^n$，有

    $$\langle \nabla f(y)-\nabla f(x), y-x\rangle \leqslant \dfrac{1}{\mu}\lVert\nabla f(x)-\nabla f(y)\rVert^2.$$

    这个证明和上面光滑凸函数的的定理三的证明是一样的，都是交换 $x$ 和 $y$ 之后相加。

同样，类似于凸函数的梯度定义，我们也可以得到强凸函数的梯度定义：

**定理**：二阶连续可微函数 $f\in\mathcal{S}^2_\mu(\mathbb{R}^n)$ 当且仅当对 $\forall x\in\mathbb{R}^n$，有 $\nabla^2 f(x)\succeq \mu I_n$。 

???+ note "证明"
    根据强凸函数的第三条性质，我们有 $\langle \nabla f(x + \tau s) - \nabla f(x), \tau s\rangle \geqslant \mu\lVert \tau s\rVert^2$，所以可以得到 

    $$\dfrac{\langle \nabla f(x + \tau s) - \nabla f(x), s\rangle}{\tau\lVert s\rVert^2} \geqslant \mu.$$

    令 $\tau\to 0$，我们有 $\dfrac{\nabla f(x + \tau s) - \nabla f(x)}{\tau}\to\nabla^2 f(x)s$，所以 $\dfrac{\langle \nabla^2 f(x)s, s\rangle}{\lVert s\rVert^2} \geqslant \mu.$

    因此

    $$\langle \nabla^2 f(x)s, s\rangle \geqslant \mu\lVert s\rVert^2 = \langle \mu I_n s, s\rangle.$$

<!-- 来看几个强凸函数的例子，
• \begin{align}f(\bm x) = \frac{1}{2}\lVert\bm x\rVert\end{align} 属于
\mathcal{S}_1^2(\mathbb{R}) ，因为 \nabla^2f(\bm x) = \bm I_n ；
• 假设对称矩阵 \bm A 满足条件 \mu \bm I_n\preceq \bm A\preceq L\bm I_n （即， \mu 和 L 分
别是 \bm A 最小和最大的特征值 ） ，则有
\begin{align} f(\bm x)=\alpha +\langle \bm a,\bm x\rangle +\frac{1}{2}\langle \bm A\bm x,\bm
x\rangle \in\mathcal{S}_{\mu,L}^{\infty,1}(\mathbb{R}^n)\subset \mathcal{S}_{\mu,L}^{1,1}
(\mathbb{R}^n) \end{align}
• 负熵函数 \begin{align} f(\bm x)=\sum_{i=1}^nx^{(i)}\log(x^{(i)}) \end{align} ， 0<x^{(i)}\le
M,\;i=1,\dots,n 是强凸的，凸参数为 1/M ；证明见math.stackexchange.com/...。 -->

## 光滑强凸函数

符号 $\mathcal{S}_{\mu,L}^{k,p}(\mathbb{R}^n)$ 代表满足 Lipschitz 连续梯度的一类强凸函数，具体来说满足：

- 在 $\mathbb{R}^n$ 上是强凸函数，凸参数为 $\mu$；
- 在 $\mathbb{R}^n$ 上 $k$ 阶连续可微，且 $p$ 阶导数关于常数 $L$ 是 Lipschitz 连续的。

同样我们也非常感兴趣 $\mathcal{S}_{\mu,L}^{1,1}(\mathbb{R}^n)$，设 $f\in\mathcal{S}_{\mu,L}^{1,1}(\mathbb{R}^n)$，根据强凸函数的定义与 Lipschitz 连续，有

$$\mu\lVert y-x\rVert^2\leqslant \langle\nabla f(y)-\nabla f(x), y-x\rangle \leqslant L\lVert y-x\rVert^2.$$

这就给 $\langle \nabla f(y)-\nabla f(x), y-x\rangle$ 一个上界和下界，这个性质非常有用，我们可以定义 $Q_f = \dfrac{L}{\mu}>1$ 为 $f$ 的条件数（condition number），其可以衡量函数 $f$ 的稳定性，即对输入变化的敏感程度。假设 $f$ 还满足二阶可微，易知 $\mu I_n\preceq\nabla^2 f(x)\preceq L I_n$，且 $\mu$ 和 $L$ 是 $\nabla^2 f(x)$ 最小和最大的特征值。另外，条件数这个名词来自于非奇异矩阵 $A$ 的条件数的定义：其为该矩阵最大和最小特征值绝对值之比。当 $Q_f$ 很大的时候，说明 $f$ 的黑塞矩阵特征值相差过大（呈现扁椭圆状，也就是函数在某些方向的变化比在其他方向上快很多，尤其在特征值大的方向上，函数变化非常剧烈，表现出陡峭的曲面），那么在进行梯度下降时可能会呈现锯齿效应，收敛很慢。

继续来说，对于 $\mathcal{S}_{\mu,L}^{1,1}(\mathbb{R}^n)$ 而言，强凸性和 Lipschitz 连续可以分别为其给出一个上界和下界。其下界优于 $\mathcal{F}_{L}^{1,1}(\mathbb{R}^n)$ 给出的下界。

$$f(x)+\langle\nabla f(x), y-x\rangle+\dfrac{\mu}{2}\lVert y-x\rVert^2\leqslant f(y)\leqslant f(x)+\langle\nabla f(x), y-x\rangle+\dfrac{L}{2}\lVert y-x\rVert^2.$$

除此之外，强凸函数还有一个性质，同样对 $\langle\nabla f(y)-\nabla f(x), y-x\rangle$ 给出了很好的下界估计：

**定理**：对 $\forall x, y\in\mathbb{R}^n$，有

$$\langle \nabla f(y)-\nabla f(x), y-x\rangle\geqslant \dfrac{\mu L}{\mu+L}\lVert y-x\rVert^2+\dfrac{1}{\mu+L}\lVert\nabla f(y)-\nabla f(x)\rVert^2.$$

???+ note "证明"
    记 $\phi(x) = f(x) - \dfrac{1}{2}\mu\lVert x\rVert^2$，那么 $\nabla\phi(x) = \nabla f(x) - \mu x$；我们已经知道 $\phi$ 属于凸函数，事实上，根据

    $$\begin{align} \phi(y)-\phi(x)-\langle\nabla\phi(x), y-x\rangle &= \left(f(y)-\dfrac{1}{2}\mu\lVert y\rVert^2\right) - \left(f(x)-\dfrac{1}{2}\mu\lVert x\rVert^2\right) - \langle \nabla f(x)-\mu x, y-x\rangle \\ &= \underbrace{f(y)-f(x)-\langle f(x), y-x\rangle}_{\leqslant \frac{L}{2}\lVert y-x\rVert^2} - \dfrac{\mu}{2}\underbrace{\left(\lVert y\rVert^2-\lVert x\rVert^2+2\langle x, y-x\rangle\right)}_{=\lVert y-x\rVert^2} \\ &\leqslant \dfrac{L}{2}\lVert y-x\rVert^2 - \dfrac{\mu}{2}\lVert y-x\rVert^2 \\ &= \dfrac{L-\mu}{2}\lVert y-x\rVert^2 \end{align}$$

    有 $\phi(x)\in\mathcal{F}^{1,1}_{L-\mu}(\mathbb{R}^n)$。如果 $\mu = L$，就有 $\langle\nabla f(y)-\nabla f(x), y-x\rangle = L\lVert y-x\rVert^2$，那么根据强凸函数定义（3）以及光滑凸函数的性质 (3)

    $$L\lVert y-x\rVert^2 = \langle\nabla f(y)-\nabla f(x), y-x\rangle \geqslant \dfrac{1}{L}\lVert \nabla f(y)-\nabla f(x)\rVert^2.$$

    配凑系数就可以立即得到式 (3)。如果 $\mu < L$，同样有根据光滑凸函数的性质 (3)

    $$\begin{align} &\langle \nabla \phi(y)-\nabla\phi(x), y-x\rangle \geqslant \dfrac{1}{L-\mu}\lVert \nabla \phi(y)-\nabla \phi(x)\lVert^2 \\ \Rightarrow &\langle \nabla f(y)-\nabla f(x), y-x\rangle-\mu\lVert y-x\rVert^2 \geqslant \dfrac{1}{L-\mu}\left(\lVert\nabla f(y)-\nabla f(x) \rVert^2+\mu^2\lVert y-x\rVert^2 - 2\mu\langle\nabla f(y)-\nabla f(x), y-x\rangle \right) \\ \Rightarrow &\dfrac{L+\mu}{L-\mu}\langle\nabla f(y)-\nabla f(x), y-x\rangle\geqslant \dfrac{\mu L}{L-\mu}\lVert y-x\rVert^2+\dfrac{1}{L-\mu}\lVert\nabla f(y)-\nabla f(x) \rVert^2 \end{align}$$

    这就完成了证明。

## 总结

Lipschitz 连续、凸性、强凸性三种性质分别从上界和下界的角度给出了一个连续可微函数的性质，简单对比可以得到下面信息：

- 考虑 $\langle \nabla f(y)-\nabla f(x), y-x\rangle$，Lipschitz 连续性给出了上界，凸性给出了下界，强凸性给出了更好的下界，也就是
  
    $$
    \underbrace{0\leqslant}_{\text{凸性}}\quad \underbrace{\mu\lVert y-x\rVert^2\leqslant}_{\text{强凸性}}\quad \langle \nabla f(y)-\nabla f(x), y-x\rangle \quad \underbrace{\leqslant L\lVert y-x\rVert^2}_{\text{Lipschitz}}
    $$

- 考虑 $\nabla^2 f(x)$，同样是 Lipschitz 连续性给出了上界，凸性给出了下界，强凸性给出了更好的下界，也就是

    $$
    \underbrace{0\preceq}_{\text{凸性}}\quad \underbrace{\mu I_n\preceq}_{\text{强凸性}}\quad \nabla^2 f(x) \quad \underbrace{\preceq L I_n}_{\text{Lipschitz}}
    $$

除了上面列出的条件之外，我们还可能看见下面的条件，这些条件对某些算法也有很好的性质：

- Weak Strong Convexity (WSC)：
- Restricted Secant Inequality (RSI)：
- Polyak-Łojasiewicz (PL)：
- Error Bounds (EB)：
- Quadratic Growth (QG)：

