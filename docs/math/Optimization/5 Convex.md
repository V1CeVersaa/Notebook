# Topic 4：一般凸方法

## 凸函数的定义与性质

**定义**：函数 $f$ 称为凸函数/Convex Function，如果其定义域为凸集，且对 $\forall \boldsymbol{x}, \boldsymbol{y} \in \mathrm{dom}\;f$，$\alpha \in [0, 1]$，有如下不等式成立：

$$
f(\alpha \boldsymbol{x} + (1 - \alpha) \boldsymbol{y}) \le \alpha f(\boldsymbol{x}) + (1 - \alpha) f(\boldsymbol{y})
$$

这里的凸函数定义完全不依赖于可微性，而前面我们得到的优化算法都是基于光滑函数的梯度，因此我们必须找到一个能替代梯度的东西，后面我们会看到次梯度的概念。

**定理**：函数 $f$ 是凸函数，当且仅当其上境图/Epigraph $\mathrm{epi}\;(f)$ 是凸集，这里的上境图定义如下：

$$
\mathrm{epi}\;(f) = \{(\boldsymbol{x}, t) \in \mathrm{dom}\; f \times \mathbb{R} \;|\; t \ge f(\boldsymbol{x})\}
$$

**定理**：如果 $f$ 是凸函数，那么 $f$ 的所有次水平集/Sublevel Set $\mathcal{L}_f(\beta)$ 要么是空集要么是凸集，这里的次水平集定义如下：

$$
\mathcal{L}_f(\beta) = \{\boldsymbol{x} \in \mathrm{dom}\;f \;|\; f(\boldsymbol{x}) \le \beta\}
$$

**性质**：对任何收敛到点 $\bar{\boldsymbol{x}} \in \mathrm{dom}\; f$ 的序列 $\{\boldsymbol{x}_k\} \subset \mathrm{dom}\; f$，有：$\mathop{\lim\inf}\limits_{k\to\infty} f(\boldsymbol{x}_k) \geqslant f(\bar{\boldsymbol{x}})$，这个结论也就是说 $f$ 是下半连续的；

???- Info "证明"
    注意到，序列 $\{(\boldsymbol{x}_k, f(\boldsymbol{x}_k))\}$ 属于闭集 $\mathrm{epi}\;(f)$，我们分为其有子序列收敛于

**性质**：对任何收敛到点 $\bar{\boldsymbol{x}} \notin \mathrm{dom}\;f$ 的序列 $\{\boldsymbol{x}_k\} \subset \mathrm{dom}\;f$，有 $\lim\limits_{k\to\infty} f(\boldsymbol{x}_k) = +\infty$；

???- Info "证明"
    我们对 $\{f(\boldsymbol{x}_k)\}$ 的子序列进行考察，证明其没有有界子序列。使用反证法：若其有有界子序列 $\{f(\boldsymbol{x}_{k_j})\}$，考察点列 $\{(\boldsymbol{x}_{k_j}, \tau)\}$，其中 $\tau$ 是 $\{f(\boldsymbol{x}_{k_j})\}$ 的上确界（或者干脆足够大），这个点列属于 $\mathrm{epi}\;(f)$，因此收敛到 $\mathrm{epi}\;(f)$ 内（这是由于 $\mathrm{epi}\; f$ 是闭集）。但是考虑条件 $\lim\limits_{j\to\infty} \boldsymbol{x}_{k_j} = \bar{\boldsymbol{x}}\notin \mathrm{dom}\;f$，说明 $\{(\boldsymbol{x}_{k_j}, \tau)\}$ 不可能收敛到 $\mathrm{epi}\;(f)$ 内，这就产生了矛盾。

    因此，$\{f(\boldsymbol{x}_k)\}$ 没有有界子序列，即 $\lim\limits_{k\to\infty} f(\boldsymbol{x}_k) = +\infty$。

**定理**：令函数 $\phi(\boldsymbol{y}),\; \boldsymbol{y} \in \mathbb{R}^m$ 在集合 $S$ 上是闭凸的，考虑一个线性运算：$\mathcal{A}(\boldsymbol{x}) = \boldsymbol{A}\boldsymbol{x} + \boldsymbol{b}:\; \mathbb{R}^n \mapsto \mathbb{R}^m$，那么函数 $f(\boldsymbol{x}) = \phi(\mathcal{A}(\boldsymbol{x}))$ 在集合 $S$ 的逆像集 $Q = \{\boldsymbol{x} \in \mathbb{R}^n \;|\; \mathcal{A}(\boldsymbol{x}) \in S\}$ 上是凸的。

这个定理表明凸性在仿射变换下是不变的。

???- Info "证明"
    下面证明 $f$ 的上境图是闭的：考虑序列 $\{(\boldsymbol{x}_k, t_k)\} \subset \mathrm{epi}\;(f)$，其中 $\lim\limits_{k\to\infty} (\boldsymbol{x}_k, t_k) = (\bar{\boldsymbol{x}}, \bar{t})$。由于 $\mathcal{A}$ 是线性的，令 $\mathcal{A}(\boldsymbol{x}_k) = \boldsymbol{y}_k$,我们有 $\lim\limits_{k\to\infty} \mathcal{A}(\boldsymbol{x}_k) = \mathcal{A}(\bar{\boldsymbol{x}}) = \bar{\boldsymbol{y}}$。

    $$
    \begin{aligned}
        \bar{t} = \lim_{k\to\infty} t_k \geq \mathop{\lim\inf}\limits_{k\to\infty}\; \phi(\mathcal{A}(\boldsymbol{x}_k))
        = \mathop{\lim\inf}\limits_{k\to\infty}\; \phi(\boldsymbol{y}_k) \geq \phi(\bar{\boldsymbol{y}}) = f(\bar{\boldsymbol{x}})
    \end{aligned}
    $$  

    这就说明了 $\mathrm{epi}\;(f)$ 是闭的，也就是 $f$ 是闭的。

**定理**：设有集合 $\Delta$，且 $f(\boldsymbol{x}) = \sup\limits_{\boldsymbol{y}\in\Delta} \phi(\boldsymbol{x}, \boldsymbol{y})$，假设对于任意固定的 $\boldsymbol{y}\in\Delta$，$\phi(\boldsymbol{x}, \boldsymbol{y})$ 在集合 $Q$ 上对于 $\boldsymbol{x}$ 是闭凸函数，那么在集合 $\hat{Q} = \{\boldsymbol{x}\in Q\;|\;\sup\limits_{\boldsymbol{y}}\phi(\boldsymbol{x}, \boldsymbol{y}) < +\infty\}$ 上，$f(\boldsymbol{x})$ 是一个闭凸函数。

???- Info "证明"
    如果 $\boldsymbol{x}\in\hat{Q}$，那么 $f(\boldsymbol{x}) < +\infty$，因此 $\hat{Q}\subseteq \mathrm{dom}\;f$。
    
    进一步，显然 $(\boldsymbol{x}, t)\in \mathrm{epi}_{\hat{Q}}\; (f)$ 当且仅当对所有 $\boldsymbol{y}\in\Delta$ 有 $\boldsymbol{x}\in Q,\; t\ge \phi(\boldsymbol{x}, \boldsymbol{y})$。
    
    这说明 $\mathrm{epi}_{\hat{Q}}(f) = \bigcap\limits_{\boldsymbol{y}\in\Delta}\mathrm{epi}_Q(\phi(\cdot, \boldsymbol{y}))$；由于每个 $\mathrm{epi}_Q(\phi(\cdot, \boldsymbol{y}))$ 都是闭凸的，因此 $\mathrm{epi}_{\hat{Q}}(f)$ 也是闭凸的。（无限个凸集的交集是凸的；无限个闭集的交集是闭的。）


<!-- 对任何收敛到点 \bar{\boldsymbol{x}}\in\mathrm{dom}\; f 的序列 \{\boldsymbol{x}_k\}\subset\mathrm{dom}\; f ，
有： \begin{align}\mathop{\lim\inf}_{k\to\infty}f(\boldsymbol{x}_k)\ge f(\bar{\boldsymbol{x}})\end{align} （该结
论也就是说 f 是下半连续的）；
• 对任何收敛到点 \bar{\boldsymbol{x}}\not\in\mathrm{dom}\;f 的序列 \{\boldsymbol{x}_k\}\subset\mathrm{dom}\;f
，有 \begin{align} \lim_{k\to\infty}f(\boldsymbol{x}_k)=+\infty \end{align} ；
• f 的次⽔平集要么是空集，要么是闭凸的；
• 设 f 是在 Q 上的闭凸函数，且在 Q 上的次⽔平集有界，则 \begin{align} \min_{\boldsymbol{x}\in Q}f(\boldsymbol{x}) \end{align} 是可解的；
• 设 f 是在 Q 上的闭凸函数，且最优集 \begin{align}X^*=\mathop{\arg\min}_{\boldsymbol{x}\in Q}f(\boldsymbol{x})\end{align} ⾮空有界，那么 Q 上函数 f 的所有⽔平集都是空的或者有界的。
其中 \lim\inf 代表下极限，有 \begin{align} \liminf_{k\to\i -->

## 连续性与可微性

## 分离定理

## 次梯度

## 一般复杂度下界

## 性能估计

## 次梯度方法

## 有限维优化算法

