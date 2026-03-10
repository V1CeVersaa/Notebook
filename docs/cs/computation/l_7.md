# Part 7: Randomized Computation

对随机化计算的建模比较简单，我们可以在任意的 NAND-TM、NAND-CIRC 模型中添加下面操作：$\mathit{foo} = \mathrm{RAND}()$，该操作会返回一个均匀分布在 $\{0, 1\}$ 上的随机的随机比特，这样扩展之后的模型分别称为 RNAND-TM 和 RNAND-CIRC。我们也可以定义 Probabilistic Turing Machine，其和一般的图灵机类似，根据当前状态和读入符号确定下一个状态 $q$、写入符号 $b$ 和读写头方向 $d$，但是这里的转移函数是一个随机的映射，变为

$$
\delta(p, a) = \begin{cases} (q_1, b_1, d_1) & \text{with probability } 1/2 \\ (q_2, b_2, d_2) & \text{with probability } 1/2 \end{cases}
$$

也就是说，对于某一个状态和读入字符，可以有两个以等概率选取的转移结果，这就是 Probabilistic Turing Machine。

然后我们就可以定义函数类 $\mathbf{BPP}$/Bounded-Error Probabilistic Polynomial Time，表示可以被 RNAND-TM 在多项式时间内以至少 $2/3$ 的概率正确计算出来的函数集合，形式化定义如下：

$$
\begin{aligned}
\mathbf{BPP} = \big\{ &F: \{0, 1\}^* \to \{0, 1\} \mid \exists \text{ RNAND-TM } M \text{ and polynomial } p(\cdot), \\  
&\text{ s.t. } \forall x \in \{0, 1\}^*, M \text{ halts within } p(\lvert x\rvert) \text{ steps and } \mathbb{P}[M(x) = F(x)] \geq 2/3 \big\}
\end{aligned}
$$

这个常数 $2/3$ 可以被任意的常数 $> 1/2$ 所替代，因为我们可以通过多次运行 RNAND-TM，然后对结果进行投票来将错误概率降低到任意小的值，这个过程称为概率放大/Probability Amplification。

!!! Info "Lemma: Amplification Lemma"

    令 $F: \{0, 1\}^* \to \{0, 1\}$ 是一个布尔函数，如果存在一个多项式时间的 RNAND-TM $P$，使得对于任意输入 $x \in \{0, 1\}^*$，都有 $\mathbb{P}[P(x) = F(x)] \geq 1 - \delta$，其中 $0 < \delta < 1/2$ 是一个常数，那么存在一个多项式时间的 RNAND-TM $Q$，使得对于任意输入 $x \in \{0, 1\}^*$，都有 $\mathbb{P}[Q(x) = F(x)] \geq 1 - 2^{-p(\lvert x \rvert)}$，其中 $p(\cdot)$ 是任意给定的多项式。

**Proof**：
构造比较简单，重复 $P$ 的结果就可以，重复线性多次就可以使得错误概率指数级下降。$Q$ 的 routine 大概是：先跑 $P$ 共 $2k$ 次，返回出现次数较多的结果作为最终结果。进行一些概率计算就可以：

$$
\begin{aligned}
\mathbb{P}[Q \text{ fails}] &= \mathbb{P}\left[P \text{ fails at least } k \text{ times out of } 2k\right] \\
&= \sum_{i=k}^{2k} \binom{2k}{i} \delta^i (1 - \delta)^{2k - i} \\
&\leq \sum_{i=k}^{2k} \binom{2k}{i} \delta^k (1 - \delta)^{k} \\
&\leq 2^{2k} \delta^k (1 - \delta)^{k} \\
&= (4 \delta (1 - \delta))^k \\
&\rightarrow_{k \to \infty} 0
\end{aligned}
$$

Probabilistic TM 的随机性来自其内部的随机比特串，我们可以将这些随机比特串看作是 TM 的一个额外输入，而将生成随机比特串的过程转化为读取输入的比特串的过程，进而将内部算法/计算的随机性转化为输入的随机性，就将 Probabilistic TM 和正宗的 Turing Machine 联系了起来，就有下面的 Lemma：

!!! Info "Lemma: Probabilistic TM as Deterministic TM with Random Input"

    $F: \{0, 1\}^* \to \{0, 1\}$ 是一个布尔函数，其属于 $\mathbf{BPP}$ 当且仅当存在一个 $G \in \mathbf{P}$，使得对于任意的输入 $x \in \{0, 1\}^*$，都有

    $$
    \mathbb{P}_{r \sim \{0, 1\}^{p(\lvert x \rvert)}}[G(x, r) = F(x)] \geq 2/3
    $$

显然 $\mathbf{P} \subseteq \mathbf{BPP}$，因为确定性 TM 可以看作是 Probabilistic TM 的一个特例，即不使用随机比特串。$\mathbf{BPP} \subseteq \mathbf{EXP}$ 也比较显然，因为我们可以枚举所有可能的随机比特串，然后取多数结果作为最终结果，这样的时间复杂度是指数级的。但是至于 $\mathbf{P}$ 是不是严格包含于 $\mathbf{BPP}$，目前尚未有定论，但是大多猜测认为 $\mathbf{P} = \mathbf{BPP}$，也就是说随机化计算并没有增加计算能力，只是提高了计算效率而已，并且所有的多项式的随机算法都可以去随机，得到一个确定性的多项式算法。

如果一个随机算法的随机性比较弱，也就是说它只需要少量的随机比特串就可以完成计算，比如我最终需要的随机字符串长度只需要 $\log n$，那么我们就可以枚举所有可能的随机比特串，毕竟只有多项式个，然后取多数结果作为最终结果，这样就去随机了。

!!! Info "Theorem: $\mathbf{BPP}$ and $\mathbf{P}_{/\mathrm{poly}}$"

    $\mathbf{BPP} \subseteq \mathbf{P}_{/\mathrm{poly}}$。

证明梗概如下：由于 $F \in \mathbf{BPP}$，根据 Lemma，我们知道存在一个多项式时间的确定性 TM $G$，使得对于任意输入 $x \in \{0, 1\}^*$，都有

$$
\mathbb{P}_{r \sim \{0, 1\}^{p(\lvert x \rvert)}}[G(x, r) = F(x)] \geq 2/3
$$

然后将其放大到一个充分接近于 1 的概率，比如 $1 - 1/2^{n+1}$，对应的 TM 为 $Q$，固定 $\lvert x \rvert = n$，我们的目标是找到一个万能的钥匙 $r$，使得对于任意的 $x \in \{0, 1\}^n$，都有 $G(x, r) = F(x)$。考虑下面的概率

$$
\begin{aligned}
\mathbb{P}_{r \sim \{0, 1\}^{p(n)}}[Q(x, r) = F(x), \forall x \in \{0, 1\}^n] &= 1 - \mathbb{P}_{r \sim \{0, 1\}^{p(n)}}[\exists x \in \{0, 1\}^n, Q(x, r) \neq F(x)] \\
&\geq 1 - \sum_{x \in \{0, 1\}^n} \mathbb{P}_{r \sim \{0, 1\}^{p(n)}}[Q(x, r) \neq F(x)] \geq 0
\end{aligned}
$$

这个概率为正的表明，存在一个随机比特串 $r$，使得对于任意的 $x \in \{0, 1\}^n$，都有 $Q(x, r) = F(x)$。我们将这个随机比特串 $r$ 硬编码进电路中，就得到了一个多项式规模的电路族，从而证明了 $F \in \mathbf{P}_{/\mathrm{poly}}$。

现在尝试证明 $\mathbf{BPP} = \mathbf{P}$ 的路径是找一个伪随机数生成器/Pseudo-Random Number Generator：

!!! Info "Definition: Pseudo-Random Number Generator"

    一个函数 $G: \{0, 1\}^l \to \{0, 1\}^{m}$ 称为一个 $(T, \epsilon)$-伪随机数生成器，如果对每一个 $m$ 个输入、一个输出的最多有 $T$ 个门的d电路 $C$，都有

    $$
    \left| \mathbb{P}_{r \sim \{0, 1\}^m}[C(r) = 1] - \mathbb{P}_{s \sim \{0, 1\}^l}[C(G(s)) = 1] \right| \leq \epsilon
    $$

最理想情况是，我希望做到 $m = 2^l$ 且 $\epsilon = 2^{-l}$，也就是说使用 $l$ 个随机比特串就可以生成 $2^l$ 个随机比特串，且正确性可以忽略不计，如果存在这样的一个 Optimal PRNG，那么就可以证明 $\mathbf{BPP} = \mathbf{P}$。

另外，可以证明如果 $\mathbf{P} = \mathbf{NP}$，那么 $\mathbf{BPP} = \mathbf{P}$。证明略过不表。
