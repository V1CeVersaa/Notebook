# 下降方法

## 梯度方法

所以就有了下面的方案：

$$\boxed{ \begin{array}{l}\Large\textbf{梯度方法}\\ \rule[4pt]{9.5cm}{0.05em}\\ \text{选择 }x_0 \in\mathbb{R}^n\\ \text{迭代 } x_{k+1}=x_{k}-h_k\nabla f(x_k),\; k=0,1,\dots \end{array}}$$

我们尝试用一种“普遍”的推理推出这种方案：取定点 $x_0$，考虑函数 $f\in C^1(\mathbb{R}^n)$ 与其下面的近似：

$$
\phi_2(x) = f(x_0) + \langle\nabla f(x_0),x-x_0\rangle + \dfrac{1}{2h}\lVert x-x_0\rVert^2
$$

其中参数 $h>0$ 是一个正数，根据一阶最优性条件，该函数的无约束极小点 $x_1^*$ 满足：

$$
\nabla\phi_2(x_1^*) = \nabla f(x_0)+\dfrac{1}{h}(x_1^*-x_0) = 0
$$

所以就有 $x_1^* = x_0-h\nabla f(x_0)$，这就是我们梯度法的迭代方案。同时注意到如果 $h\in \left( 0,\frac{1}{L} \right]$，那么函数 $\phi_2$ 就是 $f$ 的全局上近似，即：

$$
f(x) \leqslant \phi_2(x),\; \forall x\in\mathbb{R}^n
$$

这就保证了梯度法的全局收敛性。记好这个 $\phi_2$，我们在拟牛顿法的比较中还会用到（虽然也就是提了一嘴）。

学习率其实也是一种超参数，这是一种和神经网络的参数性质不同的参数，因为它不是通过训练得到的，而是需要人为设定的。如果学习率过小，有可能就会令学习花费更多时间，或者是没怎么更新就结束了；但是如果学习率过大，就有可能会导致学习发散而不能正确进行。

学习率的序列 $\left\{h_k \right\}_{k = 1}^{\infty}$ 有这样几种选择：

- 预先选择序列：
    - $h_k = h > 0$ （固定步长）
    - $h_k = \dfrac{h}{\sqrt{k+1}}$ （带有学习率衰减）
- $h_k = \operatorname*{\arg\min}\limits_{h\ge 0}f(x_k-h\nabla f(x_k))$ （精确线搜索）
- Armijo-Goldstein 准则。

Armijo-Goldstein 准则的含义为：寻找一个 $x_{k+1}=x_k-h\nabla f(x_k)$ ，使得：

$$
\begin{gather}
\alpha\langle f(x_k),x_k-x_{k+1}\rangle \leqslant f(x_k)-f(x_{k+1})\\
\beta\langle f(x_k),x_k-x_{k+1}\rangle \geqslant f(x_k)-f(x_{k+1})
\end{gather}
$$

其中 $\alpha,\beta\in(0,1)$ 为固定的参数。我们可以对 Armijo-Goldstein 准则进行几何解释：固定 $x\in\mathbb{R}^n$ ，考虑单变量函数 $\phi(h) = f(x-h\nabla f(x)),\; h>0$ ，Armijo-Goldstein 准则可接受的步长值对应于 $\phi$ 的图像的特定部分，该部分位于两个线性函数之间：

$$
\begin{gather}
\phi_1(h)=f(x)-\alpha h\lVert\nabla f(x)\rVert^2\\
\phi_2(h)=f(x)-\beta h\lVert\nabla f(x)\rVert^2
\end{gather}
$$

注意到 $\phi(0)=\phi_1(0)=\phi_2(0)$ ，以及 $\phi'(0)<\phi_2'(0)<\phi_1'(0)<0$ ，因此除非 $\phi$ 没有下界，否则可接受的步长总是存在的，也就是 $\phi$ 和 $\phi_1$ 与 $\phi_2$ 都一定会有第二个交点。有许多快速确定满足该条件的点的一维搜索算法。


<!-- 
将这些策略相比较，可以看到：预先选择序列的方法最简单，函数的行为也比其他情况更容易预
测；精确线搜索（也称“全松弛（f
ull relaxation） ”）是一种精确步长的想法，不过想想也知道在实
践中不会使用这种方式，因为其开销太大，甚至无法在有限时间内找到最小值，实际中我们经常根
据某些准则采用非精确线搜索，称作称“回溯线搜索（Backtracking line search, BLS） ”；Armijo-
Goldstein 准则是实际经常使用的准则，我们这里详细介绍一下。
Armijo-Goldstein 准则（或称 Armijo 准则）的含义为：寻找一个 \bm x_{k+1}=\bm x_k-h\nabla
f(\bm x_k) ，使得：
\begin{gather} \alpha\langle f(\bm x_k),\bm x_k-\bm x_{k+1}\rangle \le f(\bm x_k)-f(\bm
x_{k+1})\\ \beta\langle f(\bm x_k),\bm x_k-\bm x_{k+1}\rangle \ge f(\bm x_k)-f(\bm x_{k+1})\\
我们从几何角度对其进行解释。固定 \bm x\in\mathbb{R}^n ，考虑单变量函数 \phi(h) =
f(\bm x-
h\nabla f(\bm x)),\; h>0 ，Armijo-Goldstein 准则可接受的步长值对应于 \phi 的图像的特定部分，
该部分位于两个线性函数之间：
\begin{gather} \phi_1(h)=
f(\bm x)-\alpha h\lVert\nabla f(\bm x)\rVert^2\\ \phi_2(h)=
f(\bm x)-
\beta h\lVert\nabla f(\bm x)\rVert^2\\ \end{gather}
注意到 \phi(0)=\phi_1(0)=\phi_2(0) ，以及 \phi'(0)<\phi_2'(0)<\phi_1'(0)<0 ，因此除非 \phi 没有
下界，否则可接受的步长总是存在的。有许多快速确定满足该条件的点的一维搜索算法 。 -->

## 梯度方法的性能估计

总的来说，我们考虑的是对不同类型的函数，梯度方法对下面的优化问题的性能：

$$
\underset{\boldsymbol{x}\in\mathbb{R}^n}{\operatorname{argmin}}f(\boldsymbol{x})
$$

### 连续函数类

### 凸函数类

### 强凸函数类


<!-- 性能估计
我们接下来对梯度方法的性能进行估计。考虑问题：
\begin{align}\min_{\bm x\in\mathbb{R}^n}f(\bm x)\end{align}
连续函数类
首先设 f\in C_L ^{1,1}(\mathbb{R}^n) ，并总假设 f 有下界。考虑 \bm y = \bm x-h\nabla f(\bm x)
，我们知道 Lipschitz 连续能够给出一个上界：
\begin{align} f(\bm y)&\le f(\bm x)+\langle \nabla f(\bm x),\bm y-\bm x\rangle +\frac{L}{2}\lVert
\bm y-\bm x\rVert^2\\ &=
f(\bm x)-h\lVert\nabla f(\bm x)\rVert^2+\frac{h^2}{2}L\lVert\nabla
f(\bm x)\rVert^2 \\ &=
f(\bm x)-h\left(1-\frac{h}{2}L\right)\lVert\nabla f(\bm x)\rVert^2
\end{align}
我们希望一次梯度下降能够使得函数值下降，即 f(\bm y) < f(\bm x) ，这就要求
\begin{align}h\left(1-\frac{h}{2}L\right)>0\end{align} ，即 \begin{align}h\in(0,\frac{2}
{L})\end{align} 。而根据二次函数 \begin{align}\Delta h = h\left(1-\frac{h}{2}L\right)\end{align} ，
我们初中就已经知道它在 \begin{align}h = \frac{1}{L}\end{align} 处取得最大值；由此可以得出在
梯度法 中一步下降的上界：
\begin{align} f(\bm y)\le f(\bm x)-\frac{1}{2L}\lVert\nabla f(\bm x)\rVert^2 \end{align} -->


## 一般下降方法

我们已经介绍了梯度下降，也就是下降的方向是梯度的反方向，同样也证明了梯度下降确实下降最快（真的对吗？）。但是我们也希望考察是否有一种一般的下降方向：

我们讲的**下降方向/Descent Direction** 有如下定义：$\boldsymbol{d}$ 是 $f$ 在 $x$ 处的一个下降方向，如果对于任意足够小的 $t>0$ 有 $f(x+t\boldsymbol{d})<f(x)$。并且也很轻松得到下面的命题：如果 $f$ 在 $x$ 的一个邻域内连续可微，那么任意使得 $\boldsymbol{d}^T\nabla f(x)<0$ 的 $\boldsymbol{d}$ 都是下降方向。

$f$ 在 $x$ 处沿着方向 $\boldsymbol{v}\in\mathbb{R}^n$ 的变化率可以用方向导数衡量：

$$
\nabla_{\boldsymbol{v}}f(x) = \lim_{\varepsilon\to 0}\dfrac{f(x+\varepsilon\boldsymbol{v})-f(x)}{\varepsilon} = \langle \boldsymbol{v},\nabla f(x)\rangle
$$

而 $f$ 在 $x$ 处关于范数 $\lVert\cdot\rVert$ 的最速的下降方向为：

$$
\Delta_{\lVert\cdot\rVert}x = \operatorname*{argmin}_{\boldsymbol{v}}\langle \boldsymbol{v},\nabla f(x)\rangle
$$

这里我们需要通过一个范数 $\lVert\cdot\rVert$ 来约束 $\boldsymbol{v}$ 的长度，这个范数很重要，因为选定不同的范数，可以得到不同的最速下降方向。假定 $\nabla f(x)\neq 0$，有：

$$
\begin{align}
\Delta_{\lVert\cdot\rVert_2}x &= -\lVert\nabla f(x)\rVert_2^{-1}\nabla f(x)\\
\Delta_{\lVert\cdot\rVert_1}x &= -\operatorname*{sign}\left(\dfrac{\partial f(x)}{\partial x_l}\right)\cdot\boldsymbol{e}_l,\; l = \operatorname*{argmax}_{i\in1,\dots,n}\left\lvert\dfrac{\partial f(x)}{\partial x_i}\right\rvert\\
\Delta_{\lVert\cdot\rVert_{\boldsymbol{A}}}x &= -\lVert\nabla f(x)\rVert_{\boldsymbol{A}^{-1}}^{-1}\boldsymbol{A}^{-1}\nabla f(x)
\end{align}
$$

其中 $\boldsymbol{A}$ 是正定对称方阵；$\boldsymbol{A}$ 范数 $\lVert\cdot\rVert_{\boldsymbol{A}}$ 定义为 $\lVert\boldsymbol{v}\rVert_{\boldsymbol{A}} = \sqrt{\boldsymbol{v}^T \boldsymbol{\boldsymbol{A}} \boldsymbol{v}}$。这就发现了一个神奇的事实，在不同范数下，我们确实得到了不同的最速下降方向，回头看我们在上一节[光滑优化基础](./2%20Smooth.md)提到的梯度下降是局部最速下降的陈述，现在我们就可以看到这个陈述更严谨的叙述了：

- $f$ 在 $x$ 处的 $2$ 范数下的最速下降方向为 $d_{gd} = -\nabla f(x)$，这就是我们所说的梯度下降；
- $f$ 在 $x$ 处的 $1$ 范数下的最速下降方向为 $d_{cd}=-\dfrac{\partial f(x)}{\partial x_l}\boldsymbol{e}_l,\; l = \operatorname*{argmax}_{i\in1,\dots,n}\left\lvert\dfrac{\partial f(x)}{\partial x_i}\right\rvert$，这叫做坐标下降/Coordinate Descent，即每次下降都依次沿坐标轴的方向最小化目标函数值；
- $f$ 在 $x$ 处的 $\boldsymbol{A}$ 范数下的最速下降方向为 $d_{\boldsymbol{A}}=-\boldsymbol{A}^{-1}\nabla f(x)$；如果我们选择 $\boldsymbol{A}$ 为 Hessian 矩阵，那么得到的方法便是马上就要介绍的牛顿法。

此外，还有随机选择下降方向的策略，之需要满足下降方向的期望是负梯度方向即可。以坐标下降为例，$f$ 在 $x$ 处的下降方向是随机选择的，由下式给出：

$$
d_{cd-rand} = -\nabla f(x)\boldsymbol{e}_{i_k}
$$

这里的 $i_k$ 每次从 $\{1,2,\dots,n\}$ 中均匀随机选择；也就是说，在所有是下降方向的坐标轴方向之中，均匀随机选择一个方向。可以证明这种方法的期望正是负梯度方向。

总而言之，对于一种随机梯度方法，$f$ 在 $x$ 处的梯度由下式给出：

$$
d_{sgc} = -g(x_k,\xi_k)
$$

其中 $\xi_k$ 是随机变量，使得 $\mathbb{E}_{\xi_k}g(x_k,\xi_k)=\nabla f(x_k)$，即 $g(x_k,\xi_k)$ 是对负梯度方向的无偏估计/Unbiased Estimation。

## 牛顿法

牛顿法基于线性逼近，其最出名的应用就是寻找但变量函数的零点。令 $\phi(t):\mathbb{R}\mapsto\mathbb{R}$ ，考虑问题 $\phi(t^*)=0$，我们找到了某个足够逼近 $t^*$ 的 $t$，注意到：

$$
\begin{align}
\phi(t+\Delta t) &= \phi(t)+\phi'(t)\Delta t+o(\lvert\Delta t\rvert)
\end{align}
$$

并且我们预估 $t+\Delta t$ 为 $t^*$，那么由 $\phi(t+\Delta t)=0$ 可以得到 $\phi(t)+\phi'(t)\Delta t=0$，即 $\Delta t = -\dfrac{\phi(t)}{\phi'(t)}$，我们可以认为 $\Delta t$ 是对最优位移 $t^*-t$ 的一个足够好的近似，也就是说在 $t$ 处的下降步长应该是 $-\dfrac{\phi(t)}{\phi'(t)}$。将这个想法转化为算法的形式，就可以得到：

$$
t_{k+1} = t_k-\dfrac{\phi(t_k)}{\phi'(t_k)}
$$

可以证明，如果函数是连续的，并且待求的零点是孤立的，那么在零点周围存在一个区域，只要初始值位于这个邻近区域内，那么牛顿法必定收敛，这保证了牛顿法的有效性。我们也可以将牛顿法推广到求解非线性方程组的问题，即 $F(\boldsymbol{x})=\boldsymbol{0}$，其中 $\boldsymbol{x}\in\mathbb{R}^n$，$F:\mathbb{R}^n\mapsto\mathbb{R}^n$。这种情况下，我们需要定义一个增量 $\Delta\boldsymbol{x}$，作为如下线性方程组的解：

$$
F(\boldsymbol{x})+J_F(\boldsymbol{x})\Delta\boldsymbol{x} = \boldsymbol{0}
$$

其中 $J_F(\boldsymbol{x})$ 是雅各比矩阵/Jacobian Matrix，如果其是非退化的/Nondegenerate，即矩阵是满秩的，那么我们可以计算出位移 $\Delta\boldsymbol{x} = -J_F(\boldsymbol{x})^{-1}F(\boldsymbol{x})$，迭代过程为：

$$
\boldsymbol{x}_{k+1} = \boldsymbol{x}_k-J_F(\boldsymbol{x}_k)^{-1}F(\boldsymbol{x}_k)
$$

考虑一个连续可微函数 $f$ 的一阶条件，我们可以将无约束最小化问题转换成求解线性系统/Linear System $\nabla f(\boldsymbol{x})=\boldsymbol{0}$ 的解，注意到梯度的雅各比矩阵正是 Hessian 矩阵，那么此时的牛顿系统为 $\nabla f(\boldsymbol{x})+\nabla^2 f(\boldsymbol{x})\Delta\boldsymbol{x}=\boldsymbol{0}$，因此，应用牛顿法求解该优化问题，迭代形式应为：

$$
\boldsymbol{x}_{k+1} = \boldsymbol{x}_k-\left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\nabla f(\boldsymbol{x}_k)
$$

这样我们就得到了牛顿法的一般形式，下面我们将对牛顿法进行详细的讨论。

### 基本形式

换种方式重新推导：对于二阶连续可微函数 $f$，考虑其在 $\boldsymbol{x}_k$ 点处的二阶近似 $\phi_1$：

$$
\phi_1(\boldsymbol{x}) = f(\boldsymbol{x}_k)+\langle\nabla f(\boldsymbol{x}_k),\boldsymbol{x}-\boldsymbol{x}_k\rangle+\dfrac{1}{2}\left\langle\nabla^2 f(\boldsymbol{x}_k)(\boldsymbol{x}-\boldsymbol{x}_k),\boldsymbol{x}-\boldsymbol{x}_k\right\rangle
$$

设 $\nabla^2 f(\boldsymbol{x})\succ 0$，也就是 $f$ 为凸函数，我们可以选择二次函数 $\phi_1$ 的极小点作为 $\boldsymbol{x}_{k+1}$，即：

$$
\nabla\phi_1(\boldsymbol{x}_{k+1}) = \nabla f(\boldsymbol{x}_k)+\nabla^2 f(\boldsymbol{x})(\boldsymbol{x}_{k+1}-\boldsymbol{x}_k) = \boldsymbol{0}
$$

此即牛顿法的迭代形式。在严格局部极小点的一个邻域内，牛顿法的收敛速度是非常快的，几次迭代就到了。但是牛顿法有一些严重的缺点：

- 要求目标函数存在 Hessian 矩阵，且 Hessian 矩阵必须可逆；
- 牛顿法有可能会发散，理论上只有在 $\boldsymbol{x}^*$ 很近的位置才会收敛；
- 虽然收敛更快，但牛顿法的计算较复杂，除需计算梯度而外，还需计算 Hessian 矩阵和其逆矩阵，对计算量、存储量都有要求，当维数很大时这个问题更加突出，尤其是计算逆矩阵的开销达到了 $O(n^3)$。

下面有一个牛顿法发散的例子：考虑单变量函数 $\phi(t) = \dfrac{t}{\sqrt{1+t^2}}$ 的零点 $t^*$，显然 $t^*=0$；由 $\phi'(t) = \dfrac{1}{(1+t^2)^{\frac{3}{2}}}$，则牛顿法的迭代步骤为：

$$
t_{k+1} = t_k-\dfrac{\phi(t)}{\phi'(t)} = t_k-\dfrac{t_k}{\sqrt{1+t_k^2}}(1+t_k^2)^{\frac{3}{2}} = -t_k^3
$$

因此，如果 $\lvert t_0\rvert<1$，那么牛顿法会迅速收敛；如果 $\lvert t_0\rvert=1$，那么牛顿法会在 $\pm 1$ 处反复震荡；如果 $\lvert t_0\rvert>1$，那么牛顿法震荡且迅速发散。在实践中，为了防止发散，会采用阻尼牛顿法/Damped Newton Method，即为牛顿法添加一个步长 $h_k > 0$：

$$
\boldsymbol{x}_{k+1} = \boldsymbol{x}_k-h_k\left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\nabla f(\boldsymbol{x}_k)
$$

在阻尼牛顿法的初始阶段可以使用与梯度方法相同的步长；后续阶段应当令 $h_k=1$，即进入满足牛顿法的邻域之后，使用纯牛顿法快速下降。

### 收敛分析

简单说来，当起始点与局部极小点足够接近的时候，牛顿法的收敛速率是平方收敛/Qudratic Convergence，可以总结成以下定理：

**定理**：设 $f(\boldsymbol{x})$ 满足 $f\in C_M^{2,2}(\mathbb{R}^n)$，且 $\nabla^2 f(\boldsymbol{x})\succeq l\boldsymbol{I}_n$，且初始点 $\boldsymbol{x}_0$ 与 $\boldsymbol{x}^*$ 足够接近，即 $\lVert\boldsymbol{x}_0-\boldsymbol{x}^*\rVert \leqslant \bar{r} = \dfrac{2l}{3M}$，那么对于 $\lVert\boldsymbol{x}_k-\boldsymbol{x}^*\rVert<\bar{r}$，牛顿法以平方速率收敛：

$$
\lVert\boldsymbol{x}_{k+1}-\boldsymbol{x}^*\rVert \leqslant \dfrac{M\lVert\boldsymbol{x}_k-\boldsymbol{x}^*\rVert^2}{2(l-M\lVert\boldsymbol{x}_k-\boldsymbol{x}^*\rVert)}
$$

忘掉这个定理，我们开始推导一下平方收敛是如何得出的，这里我们有两个任务：首先是得到 $\lVert\boldsymbol{x}_{0} - \boldsymbol{x}^*\rVert$ 的上界，这规定了我们在什么情况下才适合使用牛顿法；其次是得到 $\lVert\boldsymbol{x}_{k+1} - \boldsymbol{x}^*\rVert$ 与 $\lVert\boldsymbol{x}_{k} - \boldsymbol{x}^*\rVert$ 之间的关系，这表示了我们的收敛速率。

???+ note "推导"
    我们考虑牛顿法的迭代过程：

    $$
    \boldsymbol{x}_{k+1} = \boldsymbol{x}_k-\left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\nabla f(\boldsymbol{x}_k)
    $$

    有：

    $$
    \begin{align}
    \boldsymbol{x}_{k+1}-\boldsymbol{x}^* &= \boldsymbol{x}_k-\boldsymbol{x}^*-\left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1} (\nabla f(\boldsymbol{x}_k) - 0)\\
    &= \boldsymbol{x}_k-\boldsymbol{x}^*-\left(\nabla^2 f(\boldsymbol{x})\right)^{-1}\int_0^1\nabla^2 f(\boldsymbol{x}^*+\tau(\boldsymbol{x}_k-\boldsymbol{x}^*))(\boldsymbol{x}_k-\boldsymbol{x}^*)\,\mathrm{d}\tau\\
    &= \left(\nabla^2 f(\boldsymbol{x_k})\right)^{-1} \cdot (\boldsymbol{x}_k - \boldsymbol{x}^*) \cdot \int_0^1 \left(\nabla^2 f(\boldsymbol{x}_k) - \nabla^2 f(\boldsymbol{x}^*+\tau(\boldsymbol{x}_k-\boldsymbol{x}^*))\right)\,\mathrm{d}\tau\\
    &= \left(\nabla^2 f(\boldsymbol{x_k})\right)^{-1} G_k \cdot (\boldsymbol{x}_k - \boldsymbol{x}^*) 
    \end{align}
    $$

    其中我们希望 $\boldsymbol{x}_k - \boldsymbol{x}^*$ 到 $\boldsymbol{x}_{k+1}-\boldsymbol{x}^*$ 的变换是一个压缩映射，因此需要考察作用在其上的算子 $\left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}G_k$；这说明 $\left(\nabla^2 f(\boldsymbol{x}_k\right)^{-1}$ 和 $G_k$ 都需要考察。

    回忆我们在[光滑优化基础](./2%20Smooth.md)在可微函数类一节的最后一个推论，有：

    $$
    \nabla^2 f(\boldsymbol{x}) - M\lVert y - x\rVert \boldsymbol{I}_n \preceq \nabla^2 f(\boldsymbol{y}) \preceq \nabla^2 f(\boldsymbol{x}) + M\lVert y - x\rVert \boldsymbol{I}_n
    $$

    利用这个推论，记 $r_k = \lVert\boldsymbol{x}_k-\boldsymbol{x}^*\rVert$，我们有：

    $$
    \begin{align}
    \lVert G_k\rVert &= \left\lVert\int_0^1\left(\nabla^2 f(\boldsymbol{x}_k)-\nabla^2 f(\boldsymbol{x}^*+\tau(\boldsymbol{x}_k-\boldsymbol{x}^*))\right)\,\mathrm{d}\tau\right\rVert\\
    &\leqslant \int_0^1\left\lVert \nabla^2 f(\boldsymbol{x}_k)-\nabla^2 f(\boldsymbol{x}^*+\tau(\boldsymbol{x}_k - \boldsymbol{x}^*))\right\rVert\,\mathrm{d}\tau\\
    &\leqslant \int_0^1 M(1-\tau)r_k\,\mathrm{d}\tau = \dfrac{r_k}{2}M
    \end{align}
    $$

    另一方面，还是根据这个推论，有：

    $$
    \nabla^2 f(\boldsymbol{x}_k)\succeq \nabla^2 f(\boldsymbol{x}^*)-Mr_k\boldsymbol{I}_n\succeq (l-Mr_k)\boldsymbol{I}_n
    $$

    因此，如果 $r_k<\dfrac{l}{M}$，那么 $\nabla^2 f(\boldsymbol{x}_k)$ 是正定的，有：

    $$
    \left\lVert \left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\right\rVert \leqslant (l-Mr_k)^{-1}
    $$

    所以得到了 $\left\lVert \left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\right\rVert \leqslant (l-Mr_k)^{-1}$，总结我们得到的条件：

    - $r_{k+1} = \left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}G_kr_k$
    - $\lVert G_k\rVert \leqslant \dfrac{r_k}{2}M$
    - $\left\lVert \left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\right\rVert \leqslant (l-Mr_k)^{-1}$

    所以

    $$
    \begin{align}
    r_{k+1} = \lVert x_{k+1}-x^*\rVert &= \left\lVert \left(\nabla^2 f(\boldsymbol{x}_k)\right)^{-1}\right\rVert \cdot \lVert G_k\rVert \cdot \lVert x_k - x^*\rVert\\
    &\leqslant \left(l - Mr_k\right)^{-1} \cdot \dfrac{r_k}{2}M \cdot r_k\\
    &= \dfrac{M}{2(l-Mr_k)}r_k^2
    \end{align}
    $$

    我们还希望这个结论再紧凑一些，也就是说，我们希望估计 $r_{k+1}$ 得到的上界是小于 $r_k$ 的，所以就得到了

    $$
    r_{k+1} \leqslant \dfrac{M}{2(l-Mr_k)}r_k^2 < r_k \Rightarrow r_k < \dfrac{2l}{3M}
    $$

    总结上述推导，就得到了牛顿法的平方收敛性质。

## 拟牛顿法

我们已经介绍过，牛顿法最吸引人的是迭代次数非常少，下降非常快，但是每次迭代的开销非常大，其中每次计算逆矩阵的复杂度就要达到大约 $O(n^3)$。我们希望能够找到一个 $f(\boldsymbol{x})$ 的近似，其比梯度下降法使用到的逼近 $\phi_2$ 要好，而又比牛顿法的二次逼近 $\phi_1$ 开销更低。

思路很直接，既然求 Hessian 矩阵的复杂度是大头，那么我们可以用其他方式逼近 Hessian 矩阵的逆，如果我们的逼近复杂度不高且逼近效果很好，那么我们就可以“替代”牛顿法了。令 $\boldsymbol{G}$ 是一个对称正定 $n\times n$ 矩阵，记

$$
\phi_{\boldsymbol{G}}(\boldsymbol{x}) = f(\boldsymbol{x}_k)+\langle \nabla f(\boldsymbol{x}_k),\boldsymbol{x}-\boldsymbol{x}_k \rangle+\dfrac{1}{2}\langle \boldsymbol{G}(\boldsymbol{x}-\boldsymbol{x}_k),\boldsymbol{x}-\boldsymbol{x}_k \rangle
$$

通过计算该式的极小值点，有更新公式：$\boldsymbol{x}_{k+1} = \boldsymbol{x}_{\boldsymbol{G}}^* = \boldsymbol{x}_k-\boldsymbol{G}^{-1}\nabla f(\boldsymbol{x}_k)$。如果我们能够有一系列逼近 $\nabla^2 f(\boldsymbol{x})$ 的矩阵：$\{\boldsymbol{G}_k\}:\;\boldsymbol{G}_k\to \nabla^2 f(\boldsymbol{x})$；或者一系列逼近 $\left(\nabla^2 f(\boldsymbol{x})\right)^{-1}$ 的矩阵：$\{\boldsymbol{H}_k\}:\;\boldsymbol{H}_k\equiv\boldsymbol{G}_k^{-1}\to \left(\nabla^2 f(\boldsymbol{x})\right)^{-1}$，那么就可以以更小的代价替代牛顿法了。

上述的方法叫做拟牛顿法/Quasi-Newton Method，也称为变尺度法/Variable Metric Method。拟牛顿法的关键是获取矩阵 $\boldsymbol{G}_k$ 或者 $\boldsymbol{H}_k$ 序列，不管这个问题，我们先介绍拟牛顿法的一般形式：

$$
\boxed{\begin{array}{l} \Large \textbf{拟牛顿法}\\ \rule[4pt]{12.5cm}{0.05em}\\ 0.\; 选择\;\boldsymbol{x}_0\in\mathbb{R}^n,\; 令\;\boldsymbol{H}_0 = \boldsymbol{I}_n,\; 计算\;f(\boldsymbol{x}_0)\;和\;\nabla f(\boldsymbol{x}_0)\\ 1.\; 第 \;k\; 次迭代:\;(k\ge 0)\\ 
\quad (a).\; 令\; \boldsymbol{p}_k = \boldsymbol{H}_k\nabla f(\boldsymbol{x}_k);\\ 
\quad (b).\;找到\; \boldsymbol{x}_{k+1} = \boldsymbol{x}_k - h_k\boldsymbol{p}_k;\\ 
\quad (c).\; 计算\;f(\boldsymbol{x}_{k+1})\;和\;\nabla f(\boldsymbol{x}_{k+1});\\
\quad (d).\; 由矩阵\;\boldsymbol{H}_k\;更新\; \boldsymbol{H}_{k+1}.\end{array}}
$$

其中 $\boldsymbol{p}_k$ 就是下降方向；$h_k$ 是步长，其选择规则可以看第一节的内容。拟牛顿法与牛顿法最不一样的地方就在与步骤 $1(d)$ 中：对序列 $\{\boldsymbol{H}_k\}$ 进行更新需要用到步骤 $1(c)$ 中的信息，更新 $\boldsymbol{H}_{k}$ 的方法虽然有很多，但是需要满足一个统一的规则——**拟牛顿规则/Quasi-Newton Rule**：

$$
\boldsymbol{H}_{k+1}(\boldsymbol{x}_{k+1}-\boldsymbol{x}_k) = \nabla f(\boldsymbol{x}_{k+1})-\nabla f(\boldsymbol{x}_k)
$$

这个规则的想法来自于对于二次函数的讨论：对于二次函数 $f(\boldsymbol{x}) = \alpha+\langle\boldsymbol{a},\boldsymbol{x}\rangle+\dfrac{1}{2}\langle\boldsymbol{A}\boldsymbol{x},\boldsymbol{x}\rangle$，$\forall\boldsymbol{x},\boldsymbol{y}\in\mathbb{R}^n$，有 $\nabla f(\boldsymbol{y})-\nabla f(\boldsymbol{x}) = \boldsymbol{A}(\boldsymbol{y}-\boldsymbol{x})$；我们也希望拟牛顿法构造出的 Hessian 逆近似满足这样的关系。并且我们可以证明：在严格局部极小点的邻域内，一般拟牛顿法局部收敛并且收敛速率为超线性，也就是

$$
\lVert \boldsymbol{x}_{k+1}-\boldsymbol{x}^*\rVert \leqslant C \cdot \lVert \boldsymbol{x}_k-\boldsymbol{x}^*\rVert \cdot \lVert \boldsymbol{x}_{k-n} - \boldsymbol{x}^*\rVert
$$

往回看：我们想知道为什么拟牛顿法被称为变尺度法。简而言之，拟牛顿法是在范数 $\lVert\cdot\rVert_{\boldsymbol{H}_k^{-1}}$ 下的最速下降法，我们下面仔细解释一下这个说法：

<!-- 我们也可以从另一个角度考察更新公式 \bm x_{k+1} = \bm x_k-\bm G^{-1}\nabla f(\bm x_k) ；之
前我们都是使用 2 范数 以及向量空间标准内积，而我们在上一篇文章中介绍了 \bm A -范数（它
也被叫做椭球范数） 。类似的也可以定义 \bm A 内积 ；对于正定对称方阵 \bm A ， \forall \bm
x,\bm y\in\mathbb{R}^n ，记
\langle\bm x,\bm y\rangle_A=\langle A\bm x,\bm y\rangle,\qquad \lVert \bm
x\rVert_A=\sqrt{\langle A\bm x,\bm x\rangle}
不过，从拓扑上讲， \bm A 范数和我们之前的二范数 是等价的，设 \lambda_1 和 \lambda_{max}
分别是 \bm A 最小和最大的特征值 ，根据 Rayleigh-Ritz 定理，有
\begin{align} \lambda_1\lVert\bm x\rVert\le \lVert\bm x\rVert_{\bm{A}}\le
\lambda_{max}\lVert\bm x\rVert \end{align}
然而，关于新内积计算的 Hessian 和梯度是不同的，
\begin{align} f(\bm x+h)&=
f(\bm x)+\langle \nabla f(\bm x),h\rangle +\frac{1}
{2}\left\langle\nabla^2 f(\bm x)h,h\right\rangle+o(\lVert h\rVert)\\ &=
f(\bm x)+\langle\bm
A^{-1}\nabla f(\bm x),h\rangle_{\bm A}+\frac{1}{2}\langle\bm A^{-1}\nabla^{2}f(\bm
x)h,h\rangle_{\bm A}+o(\lVert h\rVert_{\bm A}) \end{align}
因此 \nabla_{\bm A}f(\bm x)=\bm A^{-1}\nabla f(\bm x) 是一种新的梯度。我们在牛顿法中下降的
方向 \left(\nabla^2f(\bm x)\right)^{-1}\nabla f(\bm x) 可以视作是由 \bm A=\nabla^2 f(\bm x) 所
定义的梯度。另外，f 在 \bm x 处的由 \bm A =\nabla^2 f(\bm x) 定义的 Hessian 正是单位矩阵
\bm I_n 。更一般的情况下， \bm A = \bm H ，可以不等于 \nabla^2 f(\bm x) 。在拟牛顿法中，每
次迭代时的 \bm H_k 都会变化，那么度量下降方向 \bm H_k\nabla f(\bm x_k) 的范数也会随之变
化，可以说拟牛顿法是在 ||·||_{\bm H_k^{-1}}下的最速下降法 ，这就是为何拟牛顿法也被称为变
尺度法。 -->

<!-- 

其中 \bm p_k 即是下降方向。不过，如何对序列 \{\bm H_k\} 进行更新呢？这里有多种不同的方
法，也有很多研究和讨论。简而言之，这个更新过程需要用到步骤 1(c) 中的积累新信息。我们知
道，对于二次函数\begin{align} f(\bm x)=\alpha+\langle\bm a,\bm x\rangle+\frac{1}{2}\langle \bm
A\bm x,\bm x\rangle \end{align} ， \forall\bm x,\bm y\in\mathbb{R}^n ，有 \nabla f(\bm y)-\nabla
f(\bm x)=\bm A(\bm y-\bm x) ；根据这个性质，我们有如下关于 \{\bm H_k\} 的规则，
\bm H_{k+1}\big(\nabla f(\bm x_{k+1})-\nabla f(\bm x_k)\big)=\bm x_{k+1}-\bm x_k
这被称为拟牛 顿规则 （Quasi-­ Newton rule） 。只要满足这个规则就可以达到我们的要求。记
\Delta\bm H_k = \bm H_{k+1}-\bm H_k ， \bm\gamma _k = \nabla f(\bm x_{k+1})-\nabla f(\bm
x_{k}) ， \bm \delta_k = \bm x_{k+1}-\bm x_{k} ，以下更新规则都满足拟牛顿规则
• Rank-one correction scheme，也称 Symmetric rank-one (SR1)： \begin{align} \Delta\bm H_k
= \frac{(\bm \delta_k-\bm H_k \bm \gamma_k)(\bm \delta_k-\bm H_k \bm \gamma_k)^\top}
{\langle \bm \delta_k-\bm H_k\bm \gamma_k,\bm \gamma_k\rangle} \end{align} ；
• Davidon-Fletcher-Powell scheme (DFP)： \begin{align} \Delta \bm H_k=\frac{\bm
\delta_k\bm \delta_k^\top}{\langle \bm \gamma _k,\bm \delta_k\rangle}-\frac{\bm
H_k\bm\gamma _k\bm\gamma _k^\top\bm H_k}{\langle \bm H_k\bm\gamma _k,\bm
\gamma_k\rangle} \end{align} ；
• Broyden： \begin{align} \Delta\bm H_k = \frac{\langle \bm \delta_k-\bm
H_k\bm\gamma_k,\bm\delta_k\rangle\bm H_k}{\langle\bm
H_k\bm\gamma_k,\bm\delta_k\rangle} \end{align} ；
• Broyden-Fletcher-Goldfarb-Shanno scheme (BFGS)： \begin{align} \Delta \bm H_k =
\beta_k\frac{\bm \delta_k\bm \delta_k^\top}{\langle \bm \gamma _k,\bm \delta_k\rangle}-
\frac{\bm H_k\bm\gamma _k\bm \delta_k^\top+\bm \delta_k\bm\gamma _k^\top\bm H_k}
{\langle \bm \gamma _k,\bm \delta_k\rangle} \end{align} ，其中 \begin{align}\beta_k =
1+\frac{\langle\bm H_k\bm\gamma _k,\bm\gamma _k\rangle}{\langle \bm\gamma _k,\bm
\delta_k\rangle}\end{align} ；或者，记 \begin{align} \rho_k = \frac{1}{\langle \bm \gamma
_k,\bm \delta_k\rangle} \end{align} ，上式可以重写成 \begin{align} \bm H_{k+1}=(\bm I_n-
\rho_{k}\bm \delta_{k}\bm \gamma_{k}^{\top })\bm H_{k}(\bm I_n- \rho _{k}\bm
\gamma_{k}\bm \delta_{k}^{\top })^\top+ \rho_{k}\bm \delta_{k}\bm \delta_{k}^{\top }
\end{align} 。
当然还有其它可能的算法。其中，一般认为 BFGS 是最稳定的算法，也是最为流行的算法。
对于二次函数，拟牛顿法通常至多迭代 n 次；可以证明，在严格局部极小点的邻域内，拟牛顿法是
超线性（super-linear）的，即存在常数 N ，使得对于 \forall k > N ，有
\lVert\bm x_{k+1}-\bm x^*\rVert\le \text{const}\;\cdot\;\lVert\bm x_k-\bm
x^*\rVert\;\cdot\;\lVert\bm x_{k-n}-\bm x^*\rVert
但就最坏情况下而言，该方法并不比梯度下降法好。对拟牛顿法敛散性的证明比较冗长且
technical，我们这里不再赘述。
我们可以发现，拟牛顿法的每一步都需要存储并更新一个 n\times n 的矩阵，因此每次迭代都需要
O(n^2) 次运算，这是拟牛顿法的主要缺点之一。在 BFGS 之后，又出现了 Limited-memory BFGS
(L-BFGS) 算法，其基本思想是仅保存最近 m 次的 \bm \delta_k 和 \bm \gamma_k 用于计算 \bm
H_k ，从而减低内存消耗。不过，我们接下来介绍的是名叫共轭梯度法的算法，其每次迭代的复杂
度都要低得多。 -->



## 拟牛顿规则分析


## 共轭梯度法

共轭梯度法最早由 Hestenes 和 Stiefel 在 1952 年提出来作为解线性方程组的方法，由于解线性方程组等价于优化一个正定的二次函数，所以 1964 年 Fletcher 和 Reeves 提出了无约束极小化的共扼梯度法。下面针对二次函数的情况介绍共轭梯度法，并且给出一般情况下的共轭梯度法。

### 方法引入

简单来讲，先前的下降方法的所有的 $\boldsymbol{x}_k$ 都来自 $\operatorname*{Lin}\{\boldsymbol{x}_0,\nabla f(\boldsymbol{x}_i),i=1,\dots,k-1\}$，其中符号 $\operatorname*{Lin}$ 表示线性张成/Linear Span 的空间，在其他材料中也经常记作 $\operatorname*{span}$。与其从 $\mathbb{R}^n$ 里寻找一个 $\boldsymbol{x}_k$，我们希望将搜索的范围缩小到一个简单求解的子空间之中，这个子空间我们将优化为 Krylov 子空间/Krylov Subspace。

<!-- 在我们之前的章节中， 所有的 \bm x_k 都来自 \mathrm{Lin}\{\bm x_0,\nabla f(\bm x_i),
i=1,\dots,k-1\} ，其中符号 \mathrm{Lin} 表示线性张成（linear span）的空间，在其他材料中也经
常记作 \mathrm{span} 。不过，这个条件也并非必需。与其从 \mathbb{R}^n 里寻找一个 \bm x_k
，我们是否也可以从 \mathbb{R}^n 的一个子空间之中去寻找呢？
我们首先需要感谢阿列克谢·克雷洛夫（Aleksey Krylov） ，他是一名俄国海军工程师；在 1931 年，
他提出了著名的 Krylov 子空间（Krylov subspace） ，这是一种求解大型稀疏矩阵方程的方法：
\begin{align} \bm A\bm x = \bm b,\;\bm A = \mathbb{R}^{n\times n},\bm b \in\mathbb{R}^n
\end{align}
求解 \bm A^{-1} 可能十分困难，不过对于稀疏矩阵 \bm A ，假设其特征多项式 为 χ_{\bm A}
(\lambda) ，根据哈密顿-凯莱定理， \chi_{\bm A}(\bm A) = 0 ，即， \chi_{\bm A}(\bm A)=\bm
A^{n}+c_{n-1}\bm A^{n-1}+\cdots +c_{1}\bm A+c_{0}\bm I_{n} = 0 ，那么有
\begin{align} \bm A^{-1} = \frac{1}{c_{0}}\bm A^{n-1}+\frac{c_{n-1}}{c_0}\bm A^{n-2}+\cdots
+\frac{c_1}{c_0}\bm I_n \end{align}
不过，直接在 \begin{align}\mathrm{Lin}\{\bm I_n,\bm A,\dots,\bm A^{n-1}\}\end{align} 空间中求
解 \bm A^{-1} 的代价太高，我们可以在其低维子空间中寻求近似解，即：
\begin{align} \bm A^{-1} \approx\sum_{i=1}^{r-1}\beta_i\bm A^i\end{align}
其中 \beta_i 是待定的系数，通常 r 是远低于矩阵维数的一个值。 （ r 阶） Krylov 子空间定义为
{\mathcal {K}}_{r}(\bm A,\bm b)=\mathrm{Lin} \,\{\bm b,\bm A\bm b,\bm A^{2}\bm b,\ldots ,\bm
A^{r-1}\bm b\} 。这种类型的方法也被视为投影方法，即找到真解在某个子空间中的投影（可以是
正交投影，也可以是斜投影） 。
（Krylov, A. N. (1931)."О численном решении уравнения, которым в технических вопросах
определяются частоты малых колебаний материальных систем"）
Krylov 子空间可以在许多方法中用作目标子空间（例如 Arnoldi、Lanczos、共轭梯度法、
GM
RES） 。
1952 年，Hestense和 Stiefel 提出了共轭梯度法，最初是用于线性方程组的数值求解。1964 年，
Fletcher 和 Reeves 将共轭梯度法应用到求解二次函数的局部极小点问题中，这通常被认为是求解
无约束优化问题的非线性共轭梯度法的开端；共轭梯度法由于只是需要一阶导数 信息，所以具有
存贮量小的特点，比较适合求解大型无约束优化问题。
• Hestenes, M.R., & Stiefel, E. (1952). Methods of conjugate gradients for solving linear
systems. Journal of research of the National Bureau of Standards, 49, 409-435.
• Fletcher, R., & Reeves, C.M. (1964). Function minimization by conjugate gradients. Comput.
J., 7, 149-154.
举一个例子，考虑最小化二次函数的问题： \begin{align} \min_{\bm x\in\mathbb{R}^n}f(\bm x)
\end{align} ，其中 \begin{align} f(\bm x)=\alpha+\langle\bm a,\bm x\rangle+\frac{1}{2}\langle
\bm A\bm x,\bm x\rangle \end{align} ，其中 \bm A 是正定对称方阵；我们已经知道它的最优解是
\bm x^*=-\bm A^{-1}\bm a ，因此可以将目标函数改写为：
\begin{align} f(\bm x)&=\alpha +\langle\bm a,\bm x\rangle+\frac{1}{2}\langle \bm A\bm x,\bm
x\rangle\\ &= \alpha -\langle \bm A\bm x^*,\bm x\rangle+\frac{1}{2}\langle \bm A\bm x,\bm
x\rangle\\ &= \alpha - \frac 12\langle \bm A\bm x^*,\bm x^*\rangle +\frac{1}{2}\langle \bm A(\bm
x-\bm x^*),\bm x-\bm x^*\rangle \end{align}
让上式第三项为 0 ，可以得到 \begin{align} f^* = \alpha - \frac{1}{2}\langle\bm A\bm x^*,\bm
x^*\rangle \end{align} ，且 \nabla f(\bm x) = \bm A(\bm x-\bm x^*) 。我们可以把这个例子扩展
到更一般的情况。 -->

对于二次函数 $f(\boldsymbol{x}) = \alpha+\langle\boldsymbol{a},\boldsymbol{x}\rangle+\dfrac{1}{2}\langle\boldsymbol{A}\boldsymbol{x},\boldsymbol{x}\rangle$ 与最小化问题 $\min\limits_{\boldsymbol{x}\in\mathbb{R}^n}f(\boldsymbol{x})$，设起始点为 $\boldsymbol{x}_0\in\mathbb{R}^n$，考虑如下 Krylov 子空间：

$$
\mathcal{L}_k = \operatorname*{Lin}\{\boldsymbol{A}(\boldsymbol{x}_0-\boldsymbol{x}^*),\dots,\boldsymbol{A}^k(\boldsymbol{x}_0-\boldsymbol{x}^*)\},\; k\geqslant 1
$$

那么，**共轭梯度法/Conjugate Gradient Method** 生成如下序列 $\{\boldsymbol{x}_k\}$：

$$
\boldsymbol{x}_k = \operatorname*{\arg\min}\{f(\boldsymbol{x})\;\vert\;\boldsymbol{x}\in\boldsymbol{x}_0+\mathcal{L}_k\},\; k\geqslant 1
$$

这个定义符合我们对共轭梯度法的期待，但是并不是很自然，也没有描述成下降算法的样子，并且下降方向也不是很明确。记每一步的下降方向为 $\boldsymbol{p}_k$，我们希望共轭梯度法的样子是：

- 要像一个下降算法，也就是对于 $k=1,2,\dots$，$\alpha_k>0$，有

    $$
    \begin{align}
    &\boldsymbol{x}_k = \boldsymbol{x}_{k-1}+\alpha_{k-1}\boldsymbol{p}_{k-1} \\ 
    \Rightarrow \;& (\boldsymbol{A}\boldsymbol{x}_k+\boldsymbol{a}) = (\boldsymbol{A}\boldsymbol{x}_{k-1}+\boldsymbol{a})+\alpha_{k-1}\boldsymbol{A}\boldsymbol{p}_{k-1} \\
    \Rightarrow \;& \nabla f(\boldsymbol{x}_k) = \nabla f(\boldsymbol{x}_{k-1})+\alpha_{k-1}\boldsymbol{A}\boldsymbol{p}_{k-1}\qquad\qquad(*)
    \end{align}
    $$

- 下降方向应当只根据梯度和最后一次下降方向进行更新；设 $\beta_k>0$，$\boldsymbol{p}_0=\nabla f(\boldsymbol{x}_0)$，对于 $k=1,2,\dots$ 有

    $$
    \boldsymbol{p}_k = \nabla f(\boldsymbol{x}_k)-\beta_{k-1}\boldsymbol{p}_{k-1}
    $$

### 基础理论

根据上面的想法，我们有下面的引理：

<!-- 基础理论
根据上面的两个想法，有下述引理：
引理 1：有
\begin{align} &\mathcal{L}_k = \mathrm{Lin}\{\bm A(\bm x_0-\bm x^*),\bm A^2(\bm x_0-\bm
x^*),\dots,\bm A^k(\bm x_0-\bm x)\}\\ \equiv\;& \mathcal{R}_k = \mathrm{Lin}\{\nabla f(\bm
x_0),\nabla f(\bm x_1),\dots,\nabla f(\bm x_{k-1})\} \end{align}
以及
\begin{align} &\mathcal{L}_k = \mathrm{Lin}\{\bm A(\bm x_0-\bm x^*),\bm A^2(\bm x_0-\bm
x^*),\dots,\bm A^k(\bm x_0-\bm x)\}\\ \equiv\;& \mathcal{P}_k = \mathrm{Lin}\{\bm p_0,\bm
p_1,\dots,\bm p_{k-1}\} \end{align}
证明如下：
使用归纳法 ， k=1 时式一和式二都显然成立，因为 \nabla f(\bm x_0)=\bm A(\bm x_0-\bm
x^*)=\bm p_0 ，即 \mathcal{L}_1=\mathcal{R}_1=\mathcal{P}_1 。我们假设对于 k\ge 1 有
\mathcal{L}_k=\mathcal{R_k} 且 \mathcal{L}_k=\mathcal{P}_k ；
首先检查 \mathcal{R}_{k+1} 中的 \nabla f(\bm x_k) 和 \mathcal{L}_{k+1} 中的 \bm A^{k+1}(\bm
x_0-\bm x^*) ，根据前面推导得到的 (*) 式，
\begin{align} \nabla f(\bm x_{k})&=\nabla f(\bm x_{k-1})+\alpha_{k-1}A\bm p_{k-1}\\ &\in
\mathcal{R}_k\cup A\mathcal{P_k}\\ &= \mathcal{L}_k\cup A\mathcal{L}_k\\ &=
\mathcal{L}_{k+1} \end{align}
\begin{align} \bm A^{k+1}(\bm x_0-\bm x^*)&=\bm A\left(\bm A^k(\bm x_0-\bm x^*)\right)\\
&\in \bm A\mathcal{L}_k\\ &= \bm A\mathcal{P}_k \\ &= \mathrm{Lin}\{\bm A\bm p_0,\bm A\bm
p_1,\dots,\bm A\bm p_{k-1}\}\\ &=\mathrm{Lin}\left\{\frac{1}{\alpha_0}(\nabla f(\bm x_1)-\nabla
f(\bm x_0)),\dots,\frac{1}{\alpha_{k-1}}(\nabla f(\bm x_k)-\nabla f(\bm x_{k-1}))\right\}\\ &=
\mathrm{Lin}\{\nabla f(\bm x_0),\nabla f(\bm x_1),\dots,\nabla f(\bm x_k)\}\\ &=
\mathcal{R}_{k+1} \end{align}
即 \nabla f(\bm x_k)\in\mathcal{L}_{k+1} 且 \bm A^{k+1}(\bm x_0-\bm x^*)\in\mathcal{R}_{k+1}
，因此我们得到了 \mathcal{R}_{k+1}=\mathcal{L}_{k+1} 。完全类似可以证明
\mathcal{L}_{k+1}=\mathcal{P}_{k+1} 。
引理 2：对 \forall k,i>0 ， k\ne i ，有 \langle \nabla f(\bm x_k),\nabla f(\bm x_i)\rangle=0
证明：
我们之前已经给出 \begin{align} \bm x_k=\mathop{\arg\min}\{f(\bm x)\;\vert\;\bm x\in\bm
x_0+\mathcal{L}_k\},\; k \ge 1 \end{align} ，也就是说，对于所有 \bm\lambda \in \mathcal{L}_k
，
一定存在一个 \bm\lambda^* 使得 \bm x_k 最优。根据引理 1，有下面的结论：
令 k>i ，考虑函数
\begin{align} \phi(\bm\lambda)=
f\left(\bm x_0+\sum_{j=1}^k\lambda^{(j)}\nabla f(\bm x_{j-
1})\right),\;\bm\lambda\in\mathbb{R}^k \end{align}
则存在一个 \bm \lambda^*\in\mathbb{R}^n ，使得 \begin{align} \bm x_k=\bm
x_0+\sum_{j=1}^k{\lambda^*}^{(j)}\nabla f(\bm x_{j-1}) \end{align} 。不过，根据共轭梯度法的
迭代点关系式， \bm x_{k} 是 f 在 \bm x_0+\mathcal{L}_k 上的极小值点，故 \nabla \phi(\bm
\lambda^*) = 0 ，计算梯度的分量，有
\begin{align} 0=\frac{\partial \phi(\bm\lambda^*)}{\partial {\lambda^*}^{(j)}}=\langle \nabla
f(\bm x_k),\nabla f(\bm x_{j-1})\rangle,\; j=1,\dots,k \end{align}
推论 1：共轭梯度法求解最小化二次函数问题时，生成的子序列是有限的。 （因为 \mathbb{R}^n 中
的非零正交向量不会超过 n 个。 ）
推论 2：对 \forall \bm p\in\mathcal{L}_k ， k\ge 1 ，都有 \langle \nabla f(\bm x_k),\bm p\rangle
= 0 。 （因为 \mathcal{L}_k=\mathcal{P}_k ， \nabla f(\bm x_k)\in\mathcal{L}_{k+1} 且 \nabla
f(\bm x_k)\not\in \mathcal{L}_k 。 ）(也就是说我们第 k 次得到的搜索方向正交于前面 k-1 次搜索方
向张成的线性空间 。 )
下面一个引理解释了“共轭梯度法”名字的由来。
引理 3：令 \delta_i=\bm x_{i+1}-\bm x_i，对于 \forall k\neq i ，有 \begin{align} \langle \bm A\bm
\delta_k,\bm \delta_i\rangle = 0 \end{align} 。
（这样的一组方向成为关于 \bm A 的共轭方 向 。该引理说明我们所有的搜索方向都是共轭的。 ）
不失一般性，假设 k>i ，由于 \bm\delta_i=\alpha_i\bm p_i ，显然有
\mathcal{L}_k=\mathrm{Lin}\{\bm \delta_0,\bm\delta_1,\dots,\bm\delta_{k-1}\}，则\bm
\delta_i=\bm x_{i+1}-\bm x_i\in\mathcal{L}_{i+1}\subseteq\mathcal{L}_k，结合推论 2 有
\begin{align} \langle\bm A\bm \delta_k,\bm \delta_i\rangle =\langle \bm A(\bm x_{k-1}-\bm
x_k),\bm \delta_i\rangle =\langle \nabla f(\bm x_{k+1})-\nabla f(\bm x_k),\bm \delta_i\rangle =0
\end{align} -->

### 共轭梯度算法分析

