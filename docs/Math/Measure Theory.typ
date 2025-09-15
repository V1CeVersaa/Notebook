#import "./template.typ": *

#show: template.with(
    title: "Measure Theory",
    short_title: "Note of Measure Theory by Donard Cohn",
    description: "Notes based on Book: Measure Theory by Donald L. Cohn",
    paper_size: "a4",
    cols: 1,
    text_font: ("Palatino", "STIX Two Text", "Noto Serif SC"),
    code_font: ("Fira Code", "Monaspace Neon", "LXGW WenKai Mono"),
    accent: "#1A41AC",
    colortab: true,
    h1-prefix: "Chapter",
)

#pagebreak()

= Measures

$X$ 是一个集合，$f:X -> bb(R)$ 是一个我们希望进行积分的函数，因此我们需要处理 $X$ 的子集的大小，因此在这一章，我们需要引入测度，测度是处理这类集合大小问题的基本工具。

这章的前两节是抽象但是基础的内容，分别介绍了 $sigma$-代数和测度，我们对 $sigma$-代数内的集合讨论测度。第三节介绍了构造测度的一般技术，第四节介绍了 Lebesgue 测度的基本性质。最后在第五节和第六节，我们将介绍一些处理测度与 $sigma$-代数的额外基础技巧。

== Algebras and Sigma-Algebras

#definition("Algebra")[
    令 $X$ 为任意集合。若 $X$ 的*子集族* $cal(A)$ 满足下列条件，则称 $cal(A)$ 为 $X$ 上的一个 *代数/Algebra*：
    - $X in cal(A)$；
    - 对每个 $A in cal(A)$，其补集 $A^c in cal(A)$；
    - 对任意有限列 $A_1, dots, A_n in cal(A)$，有 $union.big_(i=1)^n A_i in cal(A)$；
    - 对任意有限列 $A_1, dots, A_n in cal(A)$，有 $inter.big_(i=1)^n A_i in cal(A)$。
]

当然，在后三条，我们也要求了 $cal(A)$ 在取补、有限并与有限交下封闭。利用 $inter.big_(i=1)^n A_i = ( union.big_(i=1)^n A_i^c )^c$，我们可以知道 取补和有限并封闭蕴含有限交封闭，因此*可以只通过前三条定义代数*。

#definition("Sigma-Algebra")[
    令 $X$ 为任意集合。若 $X$ 的*子集族* $cal(A)$ 满足下列条件，则称 $cal(A)$ 为 $X$ 上的一个 *$sigma$-代数/$sigma$-Algebra*：
    - $X in cal(A)$；
    - 对每个 $A in cal(A)$，其补集 $A^c in cal(A)$；
    - 对任意可数列 $\{A_i\}$（$forall A_i, A_i in cal(A)$），有 $union.big_(i=1)^oo A_i in cal(A)$；
    - 对任意可数列 $\{A_i\}$（$forall A_i, A_i in cal(A)$），有 $inter.big_(i=1)^oo A_i in cal(A)$。
]

因此，$X$ 上的 $sigma$-代数就是一个包含 $X$ 的子集族，且要求在取补、可数并与可数交下封闭。与代数情形相同，也可仅用前三条或者第一、二、四条下等价定义。下面陈述是显然的：

- 每个 $X$ 上的 $sigma$-代数都是 $X$ 上的代数，因为有限并可视为特殊构造下的可数并。
- 可以将上述两个定义的第一条改成 $diameter in cal(A)$，因为 $diameter in cal(A) arrow.l.r.double.long X in cal(A)$。
- 对于所有 $X$ 上的非空的、在取补以及有限并下封闭的子集族 $cal(A)$，有 $X in cal(A)$，这是因为 $X = A union A^c$，因此也可以使用 $cal(A)$ 非空替代条件 $X in cal(A)$。

若 $cal(A)$ 是 $X$ 上的 $sigma$-代数，有时把集合 $E in X$ 称为 *$cal(A)$-可测/$cal(A)$-measurable*。

#example("Some Families that are or are not Algebras or Sigma-Algebras")[
    - $X$ 为无限集，令 $cal(A)$ 为 $X$ 的所有满足 $A$ 或 $A^c$ 有限的 $X$ 的子集全体。则 $cal(A)$ 是 $X$ 上的代数，但不是 $sigma$-代数。
        - $cal(A)$ 是 $X$ 上的代数，这点非常好验证，因为有限并并不改变任何性质；
        - $cal(A)$ 不是 $sigma$-代数，如果我取一堆 $X$ 的子集，其分别只有一个元素，那么显然其可数并不是有限的，且其可数并的补集并不能确定一定是有限的，可以在自然数集中找到反例。
    - $X$ 为不可数集，令 $cal(A)$ 为 $X$ 的所有可数子集全体。则 $cal(A)$ 不含 $X$，且在取补下不封闭；因此不是代数。
    - 令 $cal(A)$ 为所有可表示为有限个 $RR$ 上区间的并构成的集合，区间类型为 $(a,b]$、$(a, +oo)$ 或 $(-oo, b]$。则很容易检验 $cal(A)$ 是 $RR$ 上的代数，但不是 $sigma$-代数。
        - 可以证明有界开区间 $(a, b)$ 是 $cal(A)$ 中集合的可数并，但是本身并不在 $cal(A)$ 中。
]

下面考虑一下构造 $sigma$-代数的方法。

#proposition()[
    令 $X$ 为一个集合，则 $X$ 上任意的非空 $sigma$-代数族的*交*仍是 $X$ 上的一个 $sigma$-代数。
]

#proof("Proof of Proposition 1.1")[
    令 $cal(C)$ 为 $X$ 上一个非空的 $sigma$-代数族，令 $cal(A)$ 为它们的交。显然 $X in cal(A)$，因为显然每一个 $sigma$-代数都包含 $X$；若 $A in cal(A)$，则每个属于 $cal(C)$ 的 $sigma$-代数都含有 $A$，因而含有 $A^c$，故 $A^c in cal(A)$；若 $\{A_i\}$ 是 $cal(A)$ 中的序列，则 $union.big_i A_i$ 属于 $cal(C)$ 中每个 $sigma$-代数，从而也属于 $cal(A)$。
]

但是，需要注意的是，一族 $sigma$-代数的*并*未必是 $sigma$-代数。先证

#corollary()[
    令 $X$ 为一个集合，$cal(F)$ 为 $X$ 的子集族。则存在包含 $cal(F)$ 的 $X$ 上 *最小* 的 $sigma$-代数。
]

如果要说明 $cal(A)$ 是 $X$ 上包含 $cal(F)$ 的最小 $sigma$-代数，我们需要说明 $cal(A)$ 首先是一个包含 $cal(F)$ 的 $sigma$-代数，其次要说明所有包含 $cal(F)$ 的 $sigma$-代数都包含 $cal(A)$，且如果 $cal(A)_1$ 和 $cal(A)_2$ 都是 $X$ 上包含 $cal(F)$ 的最小的 $sigma$-代数，则 $cal(A)_1 = cal(A)_2$，这样就可以说明包含 $cal(F)$ 的最小 $sigma$-代数是唯一的。这个 $sigma$-代数就称作是 $cal(F)$ *生成* 的 $sigma$-代数，记作 $sigma(cal(F))$。

#proof("Proof of Corollary 1.1")[
    令 $cal(C)$ 为所有包含 $cal(F)$ 的 $X$ 上 $sigma$-代数的全体，则 $cal(C)$ 非空，因为幂集本身即为 $sigma$-代数。由 Proposition 1.1 可以知道，$cal(C)$ 中所有 $sigma$-代数的交为一个 $sigma$-代数；它包含 $cal(F)$，且被每一个包含 $cal(F)$ 的 $sigma$-代数所包含。这样得到的结果就很强了，结论已经不言自明。
]

现在据此定义一个重要的 $sigma$-代数族。$RR^d$ 上的 *Borel $sigma$-代数* 定义为由 $RR^d$ 的所有*开集*生成的 $sigma$-代数，记为 $cal(B)(RR^d)$。属于 $cal(B)(RR^d)$ 的集合称为 $RR^d$ 的 *Borel 集*。当 $d=1$ 时，通常记为 $cal(B)(RR)$，而不是 $cal(B)(RR^1)$。

#proposition()[
    实数轴上的 Borel $sigma$-代数 $cal(B)(RR)$ 可分别由下列任一集合族生成：
    - $RR$ 的所有闭集的集合族；
    - 形如 $(-oo, b]$ 的所有半无界子区间族；
    - 形如 $(a, b]$ 的所有半开子区间族。
]

#proof("Proof of Proposition 1.2")[
    设 $cal(B)_1, cal(B)_2, cal(B)_3$ 分别为由这三条描述的集合族生成的 $sigma$-代数。先证 $cal(B)(RR) supset.eq cal(B)_1 supset.eq cal(B)_2 supset.eq cal(B)_3$，再证 $cal(B)_3 supset.eq cal(B)(RR)$，这样就可以证明 $cal(B)(RR) = cal(B)_1 = cal(B)_2 = cal(B)_3$。

    - 由于 $cal(B)(RR)$ 包含所有开集且在取补下封闭，它包含所有闭集，因而包含由闭集生成的 $cal(B)_1$。
    - 集合 $(-oo,b]$ 为闭集，故属于 $cal(B)_1$，从而 $cal(B)_1 supset.eq cal(B)_2$。
    - 又因 $(a,b] = (-oo,b] inter (-oo,a]^c$，每个 $(a,b]$ 均在 $cal(B)_2$ 中，故 $cal(B)_2 supset.eq cal(B)_3$。
    - 最后，每个开区间 $(a,b)$ 都是一列 $(a,b]$ 型集合的并，而每个开集是开区间的并，因此每个开集属于 $cal(B)_3$，从而 $cal(B)_3 supset.eq cal(B)(RR)$。
]

在后续内容中，我们应该注意到 $cal(B)(RR)$ 的如下性质：
- 其包含了分析中关心的每一个 $RR$ 的子集；
- 其又足够小，以至于可以使用构造性的方法来处理。

#proposition()[
    $RR^d$ 上的 Borel $sigma$-代数 $cal(B)(RR^d)$ 可以被下面任何一个集合族生成：
    - $RR^d$ 的所有闭集的集合族；
    - $RR^d$ 中所有形如 $\{(x_1, dots, x_d): x_i <= b\}$ 的闭半空间的集合族，其中 $i$ 是某个坐标指标，$b in RR$；
    - $RR^d$ 中所有“矩形”之集合族，它们形如 $\{ (x_1, dots, x_d) : a_i < x_i <= b_i, text("for") i = 1, dots, d \}$。
]

证明基本可以沿用 Proposition 1.2 的论证，因此大部分略去，只需要注意到形如 $\{ (x_1, dots, x_d) : a_i < x_i <= b_i, text("for") i = 1, dots, d \}$ 的矩形可以写成两个半空间的差就可以了。

更细致地看 $cal(B)(RR^d)$ 中的一些集合。设 $cal(G)$ 或者 $cal(G)(RR^d)$ 为 $RR^d$ 的开集全体，$cal(F)$ 或者 $cal(F)(RR^d)$ 为闭集全体。记 $cal(G)_delta$ 为 $cal(G)$ 中*序列的交*所得的全体集合，$cal(F)_sigma$ 为 $cal(F)$ 中*序列的并*所得的全体集合，这两个又被称为 $G_delta$ 类和 $F_sigma$ 类，其名称中的 $G$ 与 $F$ 分别来自德语 Gebiet 与法语 fermé，而下标 $sigma, delta$ 分别来自德语 Summe 与 Durchschnitt 的首字母。我们有下面命题：

#proposition()[
    $RR^d$ 的每个闭集都是 $G_delta$ 集；而 $RR^d$ 的每个开集都是 $F_sigma$ 集。
]

#proof("Proof of Proposition 1.4")[
    假设 $F$ 为闭集。我们需要构造开集序列 $\{U_n\}$ 使 $F = inter.big_n U_n$。令 $U_n$ 按照如下方式进行定义：
    $ U_n colon.eq { x in RR^d : exists y in F, ||x - y|| < 1/n } $
    当 $F$ 为空集时，$U_n$ 为空集；否则每个 $U_n$ 显然是开集，且 $F subset.eq inter.big_n U_n$。对于反方向的结果，注意到在度量空间里，闭集等价于包含其所有收敛序列的极限点。因此对于任意的 $x in inter.big_n U_n$，其都是一个 $F$ 内收敛点列的极限点，由闭集的性质可以得到 $x in F$。因此 $F = inter.big_n U_n$。

    如果 $U$ 是开集，则其补 $U^c$ 为闭集，从而 $U^c$ 是 $G_delta$，即存在开集列 $U_n$ 使 $U^c = inter.big_n U_n$。于是 $U = union.big_n U_n^c$，其中每个 $U_n^c$ 闭，因此 $U$ 为 $F_sigma$。
]

单纯纠结于符号的含义是没有意义的，这个命题的含义是：$RR^d$ 的每个闭集都可以通过开集的序列的交得到，而每个开集都可以通过闭集的序列的并得到。

更一般地，给定任意集合族 $cal(S)$，定义 $cal(S)_sigma$ 为 $cal(S)$ 中序列的并得到的全体集合，$cal(S)_delta$ 为 $cal(S)$ 中序列的交得到的全体集合。我们可以迭代 $sigma, delta$ 这两个操作，得到链 $cal(S)_(sigma, delta)$ 等等。

我们讲一个序列 ${A_n}$ 称为是递增的，当其满足 $A_i subset.eq A_(i+1)$，同理可以定义递减的序列。

#proposition()[
    设 $X$ 为一个集合，$cal(A)$ 为 $X$ 上的一个代数。若满足下述任一条件，则 $cal(A)$ 为 $sigma$-代数：
    - $cal(A)$ 在递增序列的并下封闭；
    - $cal(A)$ 在递减序列的交下封闭。
]

#proof("Proof of Proposition 1.5")[
    先假设第一条成立，由于 $cal(A)$ 已是代数，我们只需验证它在可数并下封闭即可。设 ${A_i}$ 为 $cal(A)$ 中的任意序列。对任意的 $n$，定义 $B_n = union.big_(i=1)^n A_i$。则 ${B_n}$ 为递增列，且每个 $B_n in cal(A)$。由第一条成立知 $union.big_n B_n in cal(A)$。但 $union.big_n B_n = union.big_i A_i$，故 $cal(A)$ 在可数并下封闭，即为 $sigma$-代数。

    假设第二条成立，只需要验证其可以推出第一条就可以。设 ${A_i}$ 为 $cal(A)$ 中的递增数列，则 ${A_i^c}$ 为递减数列，且每个 $A_i^c in cal(A)$。由第二条成立知 $inter.big_i A_i^c in cal(A)$。于是 $union.big_i A_i = ( inter.big_i A_i^c )^c in cal(A)$。故 $cal(A)$ 在可数并下封闭，即为 $sigma$-代数。
]

== Measures

令 $X$ 为一个集合，$cal(A)$ 为 $X$ 上的一个 $sigma$-代数。对一个从定义域 $cal(A)$ 到扩展半轴 $[0,+oo]$ 的函数 $mu$ 而言，如果对一个 $cal(A)$ 上的互不相交的序列 ${A_i}$ 满足

$ mu(union.big_(i=1)^oo A_i) = sum_(i=1)^oo mu(A_i) $

那么称其为 *可数可加/Countably Additive* 的函数。这里由于 $mu(A_i) >= 0$，右端的求和总共是存在，要么其为一个整数，要么其为 $+oo$。

#definition("Measure")[
    一个 $cal(A)$ 上的*测度* $mu: cal(A) -> [0,+oo]$ 是一个满足 $mu(diameter)=0$ 的可数可加函数。
]

我们也对 *有限可加/Finitely Additive* 的函数进行定义，一个有限可加的函数 $mu: cal(A) -> [0,+oo]$ 是一个满足

$ mu(union.big_(i=1)^n A_i) = sum_(i=1)^n mu(A_i) $

的函数。很容易检查，每一个可数可加的测度都是有限可加的，这只需要将可数列的后面一些项都取为空集，并且利用 $mu(diameter)=0$ 即可。从另一方面来看，有限可加的测度并不一定是可数可加的，可以很容易举出反例来。

相比于可数可加性，有限可加性更像是一个更加自然的性质。但是一方面看，可数可加性对于几乎所有的应用都足够了，并且支持很多更加强大的积分理论。因此我们更加致力于研究可数可加测度。接下来提到的没有任何特别说明的测度都指的是可数可加的测度。

#definition("Measure Space")[
    对于一个集合 $X$，$cal(A)$ 为 $X$ 上的一个 $sigma$-代数，$mu$ 为 $cal(A)$ 上的一个测度，则三元组 $(X,cal(A),mu)$ 称为一个 *测度空间/Measure Space*。若只给定 $(X,cal(A))$，则称其为一个 *可测空间/Measurable Space*，对于一个测度空间，一般也称 $mu$ 为 可测空间 $(X,cal(A))$ 上的一个测度，如果 $cal(A)$ 于上下文清楚，则也称 $mu$ 为 $X$ 上的一个测度。
]

#example()[
    - *计数测度*：令 $X$ 为任意集合，$cal(A)$ 为 $X$ 上的 $sigma$-代数。定义 $mu: cal(A) -> [0,+oo]$ 为 $A$ 含有的元素的个数，如果 $A$ 为空集，则 $mu(A)=0$，如果 $A$ 为无限集，则 $mu(A)=+oo$。这一定义给出一个测度；常称为 $(X,cal(A))$ 上的 *计数测度/Counting Measure*。
    - *狄拉克测度*：令 $X$ 为任意非空集合，$cal(A)$ 为 $X$ 上的 $sigma$-代数，且取定 $x in X$。定义 $mu_delta: cal(A) -> [0,+oo]$ 为 $mu_delta(A) = 1$ 当且仅当 $x in A$，否则 $mu_delta(A) = 0$。这一定义给出一个测度；常称为 $(X,cal(A))$ 上的集中于 $x$ 的 *狄拉克测度/Dirac Measure* 或者 *点质量测度/Point Mass Measure*。
]

#example("Con'd")[
    - 令 $X$ 为正整数集，$cal(A)$ 为 $X$ 上的所有满足 *$A$ 或 $A^c$ 有限* 的子集全体，则 $cal(A)$ 是一个代数，但是不是 $sigma$-代数。定义 $mu: cal(A) -> [0,+oo]$ 为 $mu(A) = 1$ 当且仅当 $A$ 为无限集，否则 $mu(A) = 0$。这一定义给出一个有限可加的测度，但是并不能拓展到一个 $cal(A)$ 生成的 $sigma$-代数上的可数可加测度。
    - 令 $X$ 为任意集合，$cal(A)$ 为 $X$ 上的任意一个 $sigma$-代数。定义 $mu: cal(A) -> [0,+oo]$ 为 $mu(A) = +oo$ 当且仅当 $A eq.not diameter$，否则 $mu(A) = 0$。这一定义给出一个可数可加测度。
    - 令 $X$ 至少含两个元素，$cal(A)$ 为 $X$ 的幂集。定义 $mu: cal(A) -> [0,+oo]$ 为 $mu(A) = 1$ 当且仅当 $A eq.not diameter$，否则 $mu(A) = 0$。这一定义给出的函数不是测度，甚至不是一个有限可加测度。如果我们取 $A_1, A_2$ 两两不交且各非空，则 $mu(A_1 union A_2) = 1$，而 $mu(A_1)+mu(A_2)=2$。
]

#proposition()[
    令 $(X,cal(A),mu)$ 为一个测度空间，$A, B in cal(A)$ 且 $A subset.eq B$。则 $mu(A) <= mu(B)$，如果 $mu(A) < +oo$，则 $mu(B-A) = mu(B) - mu(A)$。
]

#proof("Proof of Proposition 1.2.1")[
    集合 $A$ 与 $B-A$ 两两不交，且 $B = A union (B-A)$。由可列可加性可以得到
    $ mu(B) = mu(A) + mu(B-A) $
    由于 $mu(B-A) >= 0$，所以 $mu(B) >= mu(A)$。如果 $mu(A) < +oo$，则 $mu(B-A) = mu(B) - mu(A)$。
]

令 $mu$ 为可测空间 $(X,cal(A))$ 上的一个测度，如果 $mu(X) < +oo$，则称 $mu$ 为 *有限测度/Finite Measure*，如果存在序列 ${A_i}$ 满足 $X = union.big_i A_i$ 且 $mu(A_i) < +oo$，则称 $mu$ 为 *$sigma$-有限测度/Sigma-Finite Measure*。更一般地来看，如果 $E in cal(A)$ 可以表示为 $cal(A)$ 下有限测度集合的可数并，则称 $E$ 在 $mu$ 下 $sigma$-有限。如果测度空间 $(X,cal(A),mu)$ 满足 $mu$ 是有限的或者 $sigma$-有限的，则称这个测度空间是有限的或者 $sigma$-有限的。

我们讲的大多数性质和构造都适用于所有的测度，但是有一些重要的定理需要用到有限性或者 $sigma$-有限性。

#proposition("Countable Subadditivity")[
    令 $(X,cal(A),mu)$ 为一个测度空间，${A_k}$ 为 $cal(A)$ 中的任意序列，那么我们有下面 *可数次可加性/Countable Subadditivity*：
    $ mu(union.big_(k=1)^oo A_k) <= sum_(k=1)^oo mu(A_k). $
]

#proof("Proof of Proposition 1.2.2")[
    按照如下方式定义 ${B_k}$：$B_1 = A_1$，$B_k = A_k - (union.big_(i=1)^(k-1) A_i)$，那么每一个 $B_k$ 都属于 $cal(A)$，且两两不交，$union.big_k B_k = union.big_k A_k$，还满足 $mu(B_k) <= mu(A_k)$。这样我们就可以得到：
    $ mu(union.big_k A_k) = mu(union.big_k B_k) = sum_k mu(B_k) <= sum_k mu(A_k). $
]

这个定理告诉我们，可数可加性可以推出可数次可加性。

#proposition()[
    令 $(X,cal(A),mu)$ 为一个测度空间：
    - 如果 ${A_k}$ 是 $cal(A)$ 中的递增序列，则 $mu(union.big_k A_k) = lim_k mu(A_k)$；
    - 如果 ${A_k}$ 是 $cal(A)$ 中的递减序列，且对某个 $n$ 有 $mu(A_n) < +oo$，则 $mu(inter.big_k A_k) = lim_k mu(A_k)$。
]

#proof("Proof of Proposition 1.2.3")[
    先证第一条。按如下方式定义序列 ${B_k}$：$B_1 = A_1$，$B_k = A_k - A_(k-1)$，那么每一个 $B_k$ 都属于 $cal(A)$，且两两不交，$union.big_k B_k = A_k$，因此就得到
    $
        mu(union.big_k A_k) = mu(union.big_k B_k) = sum_k mu(B_k) = lim_k sum_(i=1)^k mu(B_i) = lim_k mu(union.big_(i=1)^k B_i) = lim_k mu(A_k).
    $

    再证第第二条，我们不妨假设对于 $n=1$ 有 $mu(A_1) < +oo$，按照下面方式定义 ${C_k}$：$C_k = A_1 - A_k$，那么 ${C_k}$ 是一个 $cal(A)$ 中的递增序列，且满足 $union.big_k C_k = A_1 - inter.big_k A_k$，因此就得到
    $ mu(A_1 - inter.big_k A_k) = mu(union.big_k C_k) = lim_k mu(C_k) = lim_k mu(A_1 - A_k) $
    在 Proposition 1.2.1 中我们知道如果 $mu(A_1) < +oo$，则 $mu(A_1 - inter.big_k A_k) = mu(A_1) - mu(inter.big_k A_k)$，因此就得到 $mu(inter.big_k A_k) = lim_k mu(A_k)$。
]

#proposition()[
    令 $(X,cal(A))$ 为一个可测空间，$mu$ 为 $(X,cal(A))$ 上的一个有限可加测度，如果其满足下面两条之一，那么 $mu$ 就是一个测度：
    - $lim_k mu(A_k) = mu(union.big_k A_k)$ 对每一个 $cal(A)$ 中的递增序列 ${A_k}$ 成立；
    - $lim_k mu(A_k) = 0$ 对每一个 $cal(A)$ 中的递减序列 ${A_k}$ 成立，且恒有 $inter.big_k A_k = diameter$。
]

#proof("Proof of Proposition 1.2.4")[
    我们其实需要验证的就是可数可加性，令 ${B_j}$ 为 $cal(A)$ 中的两两不交的序列，我们需要证明的是 $mu(union.big_j B_j) = sum_j mu(B_j)$。

    首先假设第一条成立，对每一个 $k$，定义 $A_k = union.big_(j=1)^k B_j$，则通过有限可加性可以得到 $mu(A_k) = sum_(j=1)^k mu(B_j)$，再由第一条成立知
    $ mu(union.big_(j=1)^oo B_j) = mu(union.big_(j=1)^oo A_j) = lim_k mu(A_k) = sum_(j=1)^oo mu(B_j) $
    因此就知道 $mu$ 是可数可加的。

    再假设第二条成立，令 $A_k = union.big_(j=k)^oo B_j$，这样 $A_k$ 是一个递减序列，然后根据有限可加性可以得到
    $ mu(union.big_(j=1)^oo B_j) = sum_(i=1)^k mu(B_i) + mu(A_(k+1)) $
    再由第二条成立知 $lim_k mu(A_(k+1)) = 0$，因此就得到 $mu(union.big_(j=1)^oo B_j) = sum_(j=1)^oo mu(B_j)$，也就证明了可数可加性。
]

这一节的最后我们介绍一些术语：

#definition("Borel Measure")[
    在 $(RR^d, cal(B)(RR^d))$ 上的测度常称为 $RR^d$ 上的 *Borel 测度/Borel Measure*。更一般地，若 $X subset RR^d$ 为 Borel 集，$cal(A)$ 为包含在 $X$ 内的 Borel 子集所成的 $sigma$-代数，则 $(X, cal(A))$ 上的测度称为 $X$ 上的 *Borel 测度/Borel Measure*。
]

#definition("Continuous and Discrete Measure")[
    令 $(X,cal(A),mu)$ 为一个测度空间，如果对每个 $x in X$ 均有 $mu({x})=0$，则称 $mu$ 为 *连续测度/Continuous Measure*，如果存在一个至多可数集 $D subset X$ 使 $mu(D^c)=0$，则称 $mu$ 为 *离散测度/Discrete Measure*。
]

连续测度意味着所有单点集的测度都为 0，意味着整个集合的测度均匀分布。离散测度意味着一个集合的测度集中在一个至多可数集上面，意味着这个测度可以表示成一个狄拉克测度的可数并。

== Outer Measures

== Lebesgue Measure

== Completeness and Regularity

== Dynkin Classes

= Functions and Integrals

== Measurable Functions

== Properties That Hold Almost Everywhere

== The Integral

== Limit Theorems

== The Riemann Integral

== Measurable Functions Again, Complex-Valued Functions, and Image Measures

= Convergence

== Modes of Convergence

== Normed Spaces

== Definition of $cal(L)_p$ and $cal(L)_p$

== Properties of $cal(L)_p$ and $cal(L)_p$

== Dual Spaces

= Signed and Complex Measures

== Signed and Complex Measures

== Absolute Continuity

== Singularity

== Functions of Finite Variation

== The Duals of the $cal(L)_p$ Spaces

= Product Measures

== Constructions

== Fubini's Theorem

== Applications

= Differentiation

== Change of Variable in $bb(R)^d$

== Differentiation of Measures

== Differentiation of Functions

= Measures on Locally Compact Spaces

== Locally Compact Spaces

== The Riesz Representation Theorem

== Signed and Complex Measures; Duality

== Additional Properties of Regular Measures

== The $mu^*$-Measurable Sets and the Dual of $L^1$

== Products of Locally Compact Spaces

== The Daniell–Stone Integral

= Polish Spaces and Analytic Sets

== Polish Spaces

== Analytic Sets

== The Separation Theorem and Its Consequences

== The Measurability of Analytic Sets

== Cross Sections

== Standard, Analytic, Lusin, and Souslin Spaces

= Haar Measure

== Topological Groups

== The Existence and Uniqueness of Haar Measure

== Properties of Haar Measure

== The Algebras $L^1(G)$ and $M(G)$
