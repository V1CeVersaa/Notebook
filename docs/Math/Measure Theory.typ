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

#takeaway("Takeaway for Section 1.1")[
    - $sigma$-代数是一个集合的子集族，要求在取补、可数并与可数交下封闭。
    - $sigma$-代数族的交仍然是一个 $sigma$-代数，因此对于任意集合 $X$ 的子集族 $cal(F)$，都存在包含 $cal(F)$ 的 $X$ 上的最小 $sigma$-代数，称为 $cal(F)$ *生成* 的 $sigma$-代数。
]

== Measures

令 $X$ 为一个集合，$cal(A)$ 为 $X$ 上的一个 $sigma$-代数。对一个从定义域 $cal(A)$ 到扩展半轴 $[0,+oo]$ 的函数 $mu$ 而言，如果对一个 $cal(A)$ 上的互不相交的序列 ${A_i}$ 满足

$ mu(union.big_(i=1)^oo A_i) = sum_(i=1)^oo mu(A_i) $

那么称其为 *可数可加/Countably Additive* 的函数。这里由于 $mu(A_i) >= 0$，右端的求和总共是存在，要么其为一个整数，要么其为 $+oo$。

#definition("Measure")[
    一个 $cal(A)$ 上的 *测度/Measure* $mu: cal(A) -> [0,+oo]$ 是一个满足 $mu(diameter)=0$ 的可数可加函数。
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
]<Proposition-1-2-3>

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

#pagebreak()

== Outer Measures

在本章，我们开始介绍构造测度的一种标准方法，之后我们使用这种方法来构造 $RR^d$ 上的勒贝格测度。

#definition("Outer Measure")[
    令 $X$ 为一个集合，记 $cal(P)(X)$ 为 $X$ 的所有子集的全体。$X$ 上的一个 *外测度/Outer Measure* 是一个函数 $mu^*: cal(P)(X) -> [0,+oo]$，其满足下面三条性质：
    - $mu^*(diameter) = 0$；
    - 若 $A subset.eq B subset.eq X$，则 $mu^*(A) <= mu^*(B)$；
    - *可数次可加性*：若 $\{A_n\}$ 是 $X$ 的子集的一个可数序列，则 $mu^*(union.big_n A_n) <= sum_(n=1)^oo mu^*(A_n)$。
]

也就是说，$X$ 上的外测度是一个从 $X$ 的所有子集的全体到 $[0,+oo]$ 的，单调的、可数次可加的函数，在 $diameter$ 处的取值为 $0$。注意到一个测度可以不是外测度，只有当其定义域是 $cal(P)(X)$ 时，$X$ 上的一个测度才是一个外测度。另一方面，外测度一般都不满足测度的可数可加性，因此一般都不是测度。

接下来我们的目标之一就是证明：对于 $X$ 上的每一个外测度 $mu^*$，在 $X$ 上面存在一个比较自然的 $sigma$-代数 $cal(M)_(mu^*)$，使得 $mu^*$ 在 $cal(M)_(mu^*)$ 的限制是可数可加的，进而是一个测度。按照这种方式，可以从外测度构造出很多重要的测度。

#example()[
    - 令 $X$ 为任意集合，在 $cal(P)(X)$ 上定义 $mu^*$ 为：当 $A$ 可数时取 $0$，当 $A$ 不可数时取 $1$。则 $mu^*$ 是一个外测度。
    - 令 $X$ 为任意集合，在 $cal(P)(X)$ 上定义 $mu^*$ 为：当 $A$ 有限时取 $0$，当 $A$ 无限时取 $1$。则 $mu^*$ 不是一个外测度，这是因为其不能满足可数次可加性。
    - *Lebesgue Outer Measure*：对于 $RR$ 上的每一个子集 $A$，令 $cal(C)_A$ 为所有有界开区间序列 ${a_i, b_i}$ 的集合，使得 $A subset.eq union.big_i (a_i, b_i)$。定义 $lambda^*: cal(P)(RR) -> [0,+oo]$ 为
    $ lambda^*(A) = inf { sum_i (b_i - a_i) : { (a_i,b_i) } in cal(C)_A } $
]

下面我们将验证 $lambda^*$ 是一个外测度。

#proposition()[
    $RR$ 上的 Lebesgue 外测度 $lambda^*$ 是一个外测度；并且它把 $RR$ 的每个子区间的的 Lebesgue 外测度赋为该区间的长度。
]

#proof("Proof of Proposition 1.3.1")[
    我们首先验证其是一个外测度：首先 $lambda^*(diameter) = 0$ 显然成立，因为对于任意正数 $epsilon$，总存在一个有界开区间序列 ${(a_i, b_i)}$ 使得其交包含 $diameter$，使得 $sum_i (b_i - a_i) < epsilon$。其次，对于单调性，注意到如果 $A subset.eq B$，每一个包含 $B$ 的有界开区间序列总会包含 $A$。

    最后只需要考虑可数次可加性了。令 ${A_n}_(n=1)^oo$ 为 $RR$ 的子集的一个可数序列，如果 $sum_(n=1)^oo lambda^*(A_n) = +oo$，则自然有 $lambda^*(union.big_n A_n) <= sum_(n=1)^oo lambda^*(A_n)$。于是可以假设 $sum_(n=1)^oo lambda^*(A_n) < +oo$，再令 $epsilon > 0$。对于每一个 $n$，选取一个有界开区间序列 ${(a_(n,i), b_(n,i))}_(i=1)^oo$ 使得其并包含 $A_n$，且满足
    $ sum_(i=1)^oo (b_(n,i) - a_(n,i)) < lambda^*(A_n) + epsilon / 2^n $
    我们将这些序列合并为一个序列 ${(a_j, b_j)}_(j=1)^oo$，则合并后的序列显然满足 $union.big_j A_j subset.eq union.big_j (a_j, b_j)$，且
    $ sum_(j=1)^oo (b_j - a_j) < sum_(n=1)^oo (lambda^*(A_n) + epsilon / 2^n) = sum_(n=1)^oo lambda^*(A_n) + epsilon $
    由于 $epsilon$ 任意，因此就得到了 $lambda^*(union.big_n A_n) <= sum_(n=1)^oo lambda^*(A_n)$。
    因此就知道 $lambda^*$ 是一个外测度。

    最后我们计算 $RR$ 上子区间的外测度：首先考虑一个有界闭区间 $[a,b]$，显然有 $lambda^*([a,b]) <= b-a$，只需要使得构造出来的开区间序列为第一个开区间稍大于 $[a,b]$，其余开区间长度极小即可。接下来证明反向不等式，令 ${(a_i, b_i)}_(i=1)^oo$ 为一个有界开区间序列，其并包含 $[a,b]$。由于 $[a,b]$ 是紧的，因此存在一个正整数 $n$ 使得 $[a,b] subset.eq union.big_(i=1)^n (a_i, b_i)$，很容易知道 $b-a <= sum_(i=1)^n (b_i - a_i)$，因此就得到了 $b-a <= sum_(i=1)^oo (b_i - a_i)$。由于 ${(a_i, b_i)}_(i=1)^oo$ 任意，因此就得到了 $lambda^*([a,b]) >= b-a$，因此就得得到了 $lambda^*([a,b]) = b-a$。

    最后的最后，由于任意有界区间 $I$ 都包含于且被任意接近于其长度的有界闭区间所夹，因此任意有界区间的外测度都等于其长度。无界区间的外测度为 $+oo$，因为它包含任意长的闭有界区间。
]

按照相同的方式可以定义 $RR^d$ 上的勒贝格外测度 $lambda^*$，其将每个 $d$ 维区间的外测度赋为其*体积*。

#proposition()[
    可以按照如下方式定义 $RR^d$ 上的勒贝格外测度 $lambda^*_d$：$RR^d$ 上一个 $d$ 维区间是形如 $I_1 times dots.c times I_d$ 的集合，其中每一个 $I_i$ 为 $RR$ 的子区间，每一个区间都可以是可开可闭的，这里的 $I_1 times dots.c times I_d$ 按照如下方式给出：
    $ I_1 times dots.c times I_d = { (x_1, dots, x_d) : x_i in I_i text("for") i = 1, dots, d } $
    定义 $d$ 维区间的体积 $op("vol")(I_1 times dots.c times I_d)$ 为各 $I_i$ 长度的乘积。对于 $RR^d$ 的任意子集 $A$，令 $cal(C)_A$ 为所有有界 $d$ 维开区间序列 ${R_i}$ 的集合，使得 $A subset.eq union.big_(i=1)^oo R_i$。定义 $lambda^*_d: cal(P)(RR^d) -> [0,+oo]$ 为1
    $ lambda^*_d (A) = inf { sum_(i=1)^oo op("vol")(R_i) : {R_i} in cal(C)_A } $
    则 $lambda^*_d$ 是一个外测度，并且它将每个 $d$ 维区间的外测度赋为其*体积*。
]

#proof("Proof of Proposition 1.3.2")[
    证明与 Proposition 1.3.1 的相仿，这里大部分略去。注意到，如果 $K$ 是一个 $d$ 维紧区间，且 ${R_i}_(i=1)^oo$ 为 $d$ 维有界开区间序列，满足 $K subset.eq union.big_(i=1)^oo R_i$，则存在正整数 $n$ 使得 $K subset.eq union.big_(i=1)^n R_i$，且 $K$ 可以分解为有限族 $d$ 维区间 ${K_j}$ 的并，他们只在边界处重叠，且对于每一个 $K_j$，都存在一个 $R_i$ 使得 $K_j$ 的内部包含于 $R_i$。于是
    $ op("vol")(K) = sum_j op("vol")(K_j) <= sum_i op("vol")(R_i) $
    因此就有 $op("vol")(K) <= lambda^*_d(K)$。剩下的证明与 Proposition 1.3.1 的相仿，从 $RR$ 到 $RR^d$ 的修改细节略去。
]

#definition($mu^*$ + "-Measurable and Lebesgue Measurable")[
    令 $X$ 为一个集合，$mu^*$ 为 $X$ 上的外测度。若 $B subset.eq X$ 满足：对 $X$ 的*每个*子集 $A$ 都有
    $ mu^*(A) = mu^*(A inter B) + mu^*(A inter B^c) $
    则称 $B$ 是 *$mu^*$-可测* 的，或者说是关于 $mu^*$ 可测的。

    一个 $RR$ 上或者 $RR^d$ 上 *Lebesgue 可测/Lebesgue Measurable* 的集合就是关于一个 Lebesgue 外测度可测的集合。
]

$mu^*$ 可测的子集可以将 $X$ 的每个子集按照一种自然的方式分成两块，使得这两块的测度可以正确相加。而外测度 $mu^*$ 的次可加性意味着 $mu^*(A) <= mu^*(A inter B) + mu^*(A inter B^c)$，因此为了检验 $B$ 的 $mu^*$-可测性，我们只需验证 $mu^*(A) >= mu^*(A inter B) + mu^*(A inter B^c)$ 对 $X$ 的每个子集 $A$ 都成立。如果 $mu^*(A) = +oo$，上面的式子显然成立，只需要验证 $mu^*(A) < +oo$ 的 $A$ 即可。

#proposition()[
    设 $X$ 为集合，$mu^*$ 为 $X$ 上的外测度。若 $B subset.eq X$ 满足 $mu^*(B)=0$ 或 $mu^*(B^c)=0$，则 $B$ 是 $mu^*$-可测的。
]

#proof("Proof of Proposition 1.3.3")[
    设 $mu^*(B)=0$ 或 $mu^*(B^c)=0$。按上文所述，我们需要验证：对每个 $A subset X$，
    $ mu^*(A) >= mu^*(A inter B) + mu^*(A inter B^c). $
    然而关于 $B$ 的假设与 $mu^*$ 的*单调性*意味着，该不等式右端的两项之一为 $0$，而另一项至多为 $mu^*(A)$；因此所需不等式成立。
]

这个命题意味着对于每一个外测度，$diameter$ 和 $X$ 都是可测的。

下面我们将介绍一个关键定理，其将是我们构造出很多测度的关键工具。

#theorem("Carathéodory's Theorem")[
    设 $X$ 为集合，$mu^*$ 为 $X$ 上的外测度，记 $cal(M)_(mu^*)$ 为 $X$ 的所有 $mu^*$-可测子集的全体。则
    - $cal(M)_(mu^*)$ 是一个 $sigma$-代数；
    - $mu^*$ 在 $cal(M)_(mu^*)$ 上的限制是一个测度。
]

#proof("Proof of Carathéodory's Theorem")[
    我们从证明 $cal(M)_(mu^*)$ 是一个*代数*开始。首先注意到 Proposition 1.3.3 表明 $X in cal(M)_(mu^*)$。还需要注意到 $mu^*(A) = mu^*(A inter B) + mu^*(A inter B^c)$ 在 $B$ 与 $B^c$ 互换时不变，因此 $B$ 可测蕴含 $B^c$ 可测，故 $cal(M)_(mu^*)$ 在取补下封闭。接下来说明 $cal(M)_(mu^*)$ 在有限并下封闭，我们只用证明如果 $B_1,B_2$ 都是 $mu^*$-可测的，那么 $B_1 union B_2$ 也是 $mu^*$-可测的。为此，任取 $X$ 的子集 $A$，由 $B_1$ 和 $B_2$ 的可测性有
    $
        mu^*(A inter (B_1 union B_2)) & = mu^*(A inter (B_1 union B_2) inter B_1) + mu^*(A inter (B_1 union B_2) inter B_1^c) \
                                      & = mu^*(A inter B_1) + mu^*(A inter B_1^c inter B_2)
    $
    使用这个等式以及 $(B_1 union B_2)^c = B_1^c inter B_2^c$，我们得到
    $
        mu^*(A inter (B_1 union B_2)) + mu^*(A inter (B_1 union B_2)^c) &= mu^*(A inter B_1) + mu^*(A inter B_1^c inter B_2) + mu^*(A inter B_1^c inter B_2^c)\
        &= mu^*(A inter B_1) + mu^*(A inter B_1^c)\
        &= mu^*(A)
    $
    其中第二个等号是因为 $B_2$ 可测。这样，由于 $A$ 是 $X$ 的任意子集，$B_1 union B_2$ 可测，因此 $cal(M)_(mu^*)$ 在有限并下封闭，所以是一个代数。

    接下来假设 ${B_i}$ 为一个两两不交的 $mu^*$-可测集的序列，我们将用归纳法证明：对每个 $A subset X$ 与正整数 $n$，有
    $ mu^*(A) = sum_(i=1)^n mu^*(A inter B_i) + mu^*(A inter (inter.big_(i=1)^n B_i^c)) $<1-3-Equation-1>
    成立。当 $n=1$ 时，这个式子就是 $B_1$ 可测性的重述。设 $n$ 时这个式子成立，注意到 $B_(n+1)$ 的可测性以及 ${B_i}$ 两两不交，我们就能得到
    $
        mu^*(A inter (inter.big_(i=1)^n B_i^c)) &= mu^*(A inter (inter.big_(i=1)^n B_i^c) inter B_(n+1)) + mu^*(A inter (inter.big_(i=1)^n B_i^c) inter B_(n+1)^c)\
        &= mu^*(A inter B_(n+1)) + mu^*(A inter (inter.big_(i=1)^(n+1) B_i^c))
    $
    因此
    $
        mu^*(A) = sum_(i=1)^n mu^*(A inter B_i) + mu^*(A inter B_(n+1)) + mu^*(A inter (inter.big_(i=1)^n B_i^c) inter B_(n+1)^c)
    $
    于是归纳法就完成了。注意到如果我们将 @1-3-Equation-1 右侧的 $mu^*(A inter (inter.big_(i=1)^n B_i^c))$ 改成 $mu^*(A inter (inter.big_(i=1)^oo B_i^c))$，不会使右端变大；令 $n$ 在和式中趋于无穷，再根据外测度的次可加性，得到
    $
        mu^*(A) & >= sum_(i=1)^oo mu^*(A inter B_i) + mu^*(A inter (union.big_(i=1)^oo B_i)^c) \
                & >= mu^*(A inter (union.big_(i=1)^oo B_i)) + mu^*(A inter (union.big_(i=1)^oo B_i)^c) \
                & >= mu^*(A)
    $<1-3-Equation-2>
    这就表明上面每一个不等号都必须是等号，这就表明 $union.big_(i=1)^oo B_i$ 是 $mu^*$-可测的，因此 $cal(M)_(mu^*)$ 在可数不交并下封闭。很容易证明任何一个序列 ${B_i}$ 的并都是一个序列不交并，从而很容易就知道 $cal(M)_(mu^*)$ 是一个 $sigma$-代数。

    最后，我们证明 $mu^*$ 在 $cal(M)_(mu^*)$ 上的限制是一个测度，只需要证明可数可加性就可以。如果 ${B_i}$ 是 $cal(M)_(mu^*)$ 中两两不交的序列，则把 @1-3-Equation-2 中的 $A$ 换成 $union.big_(i=1)^oo B_i$ 可得
    $ mu^*(union.big_(i=1)^oo B_i) >= sum_(i=1)^oo mu^*(B_i) + 0 $
    反向不等式显然成立，事实上上面的不等式在 @1-3-Equation-2 下面就是一个等式，于是 $mu^*$ 在 $cal(M)_(mu^*)$ 上的限制满足可数可加性，因此就是一个测度。
]

下面我们讨论 Carathéodory 定理的应用，开始讨论 Lebesgue 测度。我们将 $RR$ 上 Lebesgue 可测的集合记为 $cal(M)_(lambda^*)$。

#proposition()[
    $RR$ 的每个 Borel 集都是 Lebesgue 可测的。
]

#proof("Proof of Proposition 1.3.4")[
    首先验证所有形如 $(-oo, b]$ 的区间都是 Lebesgue 可测的。令 $B$ 为这样的一个区间，我们只需要检查 $lambda^*(A) >= lambda^*(A inter B) + lambda^*(A inter B^c)$ 对任意满足 $lambda^*(A) < +oo$ 的 $A subset RR$ 都成立即可。取任意 $epsilon > 0$，并取一列开区间 ${(a_n, b_n)}$ 覆盖 $A$ 且满足 $sum_(n=1)^oo (b_n - a_n) < lambda^*(A) + epsilon$。对于每一个 $n$，集合 $(a_n, b_n) inter B$ 与 $(a_n, b_n) inter B^c$ 是两两不交的区间（其中一个可能为空），其并为 $(a_n, b_n)$，因此
    $ b_n - a_n = lambda^*((a_n, b_n)) = lambda^*((a_n, b_n) inter B) + lambda^*((a_n, b_n) inter B^c) $<1-3-Equation-5>
    这两个等式都是因为括号里面的集合是区间，因此其外测度等于其长度。由于序列 ${(a_n, b_n) inter B}$ 覆盖 $A inter B$，序列 ${(a_n, b_n) inter B^c}$ 覆盖 $A inter B^c$，根据单调性和可数次可加性，我们有
    $
        lambda^*(A inter B) + lambda^*(A inter B^c) &<= sum_n lambda^*((a_n, b_n) inter B) + sum_n lambda^*((a_n, b_n) inter B^c) \
        &= sum_n (b_n - a_n) < lambda^*(A) + epsilon
    $
    由于 $epsilon$ 的任意性，这就得到了 $lambda^*(A) >= lambda^*(A inter B) + lambda^*(A inter B^c)$，因此 $B$ 是 Lebesgue 可测的。

    根据 Carathéodory 定理，Lebesgue 可测集全体 $cal(M)_(lambda^*)$ 是 $RR$ 上的一个 $sigma$-代数，并且包含每个形如 $(-oo,b]$ 的区间；而 $cal(B)(RR)$ 是包含所有这类区间的最小 $sigma$-代数，于是 $cal(B)(RR) subset.eq cal(M)_(lambda^*)$。命题得证。
]

对于 $RR^d$ 上的 勒贝格外测度 $lambda^*_d$，我们也可以按照相同的方式定义 $RR^d$ 上的勒贝格可测集的全体 $cal(M)_(lambda^*_d)$，并且也可以证明 $RR^d$ 的每一个 Borel 集都是 Lebesgue 可测的，只需要修改对于 $RR$ 的证明中的一些细节就可以了。

将 Lebesgue 外测度限制在 $cal(M)_(lambda^*)$ 上的测度称为 $RR$/$RR^d$ 上的 *Lebesgue 测度/Lebesgue Measure*，记为 $lambda$/$lambda_d$。我们可以通过上下文指明具体的版本，比如称 $(RR, cal(M)_(lambda^*))$ 上的勒贝格测度，或者 $(RR^d, cal(M)_(lambda^*_d))$ 上的勒贝格测度，大多数的时候，我们处理的都是 Borel 集上的 Lebesgue 测度，其与别的版本的 Lebesgue 测度的关系可以见 @Section-1-5。

由此立刻出现几个问题，都是有关与 Lebesgue 可测集的范围的：是否每一个 $RR$/$RR^d$ 的子集都是 Lebesgue 可测的？另一个就是上面两个命题的反向，是否每一个 Lebesgue 可测集都是 Borel 集？这些问题的答案都是否定的，可以见 @Section-1-4 与 @Section-2-1。

在本节的最后，我们讨论一下 $(RR, cal(B)(RR))$ 上测度与分布函数的关系，下面两个命题给出了在 $(RR, cal(B)(RR))$ 上构造和表示测度的重要方法。

#proposition()[
    令 $mu$ 为 $(RR, cal(B)(RR))$ 上的一个有限测度，令 $F_mu: RR -> RR$ 按照如下方式定义 $F_mu (x) = mu(( -oo, x ])$。则 $F_mu$ 有界、单调不减、右连续，并满足 $lim_(x->-oo) F_mu (x) = 0$。
]

#proof("Proof of Proposition 1.3.5")[
    由测度的单调性可以得知，$0 <= mu((-oo, x]) <= mu(RR)$ 对每一个 $x in RR$ 都成立，且 $mu((-oo, x]) <= mu((-oo, y])$ 对每一个 $x <= y$ 都成立，因此我们就知道 $F_mu$ 其实是有界且单调不减的。下面我们来验证右连续性：令 $x in RR$，取一个定义为 $x_n = x + 1/n$ 的正实数数列 ${x_n}$ ，于是 $(-oo, x] = inter.big_(n=1)^oo (-oo, x_n]$，由 @Proposition-1-2-3 指出的连续性可以得到
    $
        F_mu (x) = mu((-oo, x]) = mu(inter.big_(n=1)^oo (-oo, x_n]) = lim_(n -> oo) mu((-oo, x_n]) = lim_(n -> oo) F_mu (x_n)
    $
    由于 $F_mu$ 是一个单调不减的函数，对于 $x < y < x_n$，显然成立 $|F_mu (y) - F_mu (x)| <= |F_mu (x_n) - F_mu (x)|$，夹一夹就得出了 $F_mu$ 的右连续性。

    也很容易使用相同的方法验证 $lim_(x->-oo) F_mu (x) = 0$，这里可以构造出 ${(-oo, -n]}_(n=1)^oo$ 的数列，然后使用连续性和单调性证明。
]

令 $mu$ 和 $F_mu$ 为上面描述的测度与函数，由于 $mu((-oo, b])$ 有界，于是
$ mu((a, b]) = mu((-oo, b]) - mu((-oo, a]), $<1-3-Equation-3>
因此，
$ mu((a, b]) = F_mu (b) - F_mu (a). $<1-3-Equation-4>
由于 $F_mu$ 有界且单调不减，对每一个 $x in RR$，当 $t$ 从左侧趋向 $x$ 时，$F_mu (t)$ 的极限存在，其值为 $sup {F_mu (t) : t < x}$，记为 $F_mu (x-)$。

令 ${a_n}$ 为一个递增趋近于 $b$ 的数列，对每一个区间 $(a_n, b]$ 都有 $mu((a, b]) = F_mu (b) - F_mu (a_n)$，取一个交集的极限就可以发现 $mu({b}) = F_mu (b) - F_mu (b-)$，因此如果 $F_mu$ 连续，则 $mu({b}) = 0$，因此 $mu$ 是一个连续测度；如果 $F_mu$ 在 $b$ 处有一个跳跃，则 $mu({b})$ 就等于这个跳跃的大小，因此 $mu$ 就不是一个连续测度。

@1-3-Equation-3 和 @1-3-Equation-4 允许我们借助 $F_mu$ 恢复 $mu$ 在某些集合上的取值，不过下面的命题说明：事实上 *$mu$ 在 每个 $RR$ 上的 Borel 集上的取值都由 $F_mu$ 唯一决定*。

#proposition()[
    对于每一个有界、单调不减、右连续的函数 $F: RR -> RR$，且满足 $lim_(x->-oo) F(x) = 0$，都存在唯一的一个 $(RR, cal(B)(RR))$ 上的有限测度 $mu$，使得 $F(x) = mu(( -oo, x ])$ 对 $RR$ 上的每一个 $x$ 都成立。
]

#proof("Proof of Proposition 1.3.6")[
    令 $F$ 为满足题目要求的函数，我们首先证明存在性，先构造出一个满足要求的测度 $mu$，首先定义一个函数 $mu^*: cal(P)(RR) -> [0,+oo]$ 为
    $ mu^*(A) = inf { sum_(n=1)^oo ( F(b_n) - F(a_n) ) : A subset.eq union.big_(n=1)^oo (a_n, b_n] } $
    也就是说，这里对所有可以覆盖 $A$ 的半开区间序列 ${(a_n, b_n]}$ 遍历，取这些序列上求和的下确界。这样就很容易检验其是一个 $RR$ 上的外测度。下面我们验证 $mu^*((-oo, x]) = F(x)$。手法还是证明两个方向的不等式：

    首先可以验证 $mu^*((-oo, x]) <= F(x)$，这是因为 $(-oo, x]$ 可以被区间序列 ${(x-n, x-n+1]}_(n=1)^oo$ 覆盖，对于这个区间序列，我们有 $sum_(n=1)^oo (F(x-n+1) - F(x-n)) = F(x)$，下确界保证了 $mu^*((-oo, x]) <= F(x)$。对于反方向的不等式，令 ${(a_n, b_n]}$ 为一列覆盖 $(-oo,x]$ 的半开区间，并取任意 $epsilon > 0$。由 $lim_(t->-oo) F(t) = 0$，我们可以取一个 $t < x$ 使得 $F(t) < epsilon$；再由 $F$ 的右连续性，对于每一个 $n$，我们可以取一个 $delta_n > 0$，使得
    $ F(b_n + delta_n) < F(b_n) + epsilon / 2^n $
    根据区间 $[t,x]$ 的紧性，每一个区间 $(a_n, b_n + delta_n)$ 是开的，且 $[t, x] subset.eq union.big_(n=1)^oo (a_n, b_n + delta_n)$，以及 $sum_n (F(b_n + delta_n) - F(a_n)) <= sum_n (F(b_n) - F(a_n)) + epsilon$。存在正整数 $N$ 使得 $[t,x] subset.eq union.big_(n=1)^N (a_n, b_n + delta_n)$。因此 $(t,x]$ 可以表示
    为有限个两两不交区间 $(c_j, d_j]$ 的并，每一个 $(c_j, d_j]$ 都包含于某一个 $(a_n, b_n + delta_n)$ 中。于是
    $
        F(x) - F(t) = sum_j (F(d_j) - F(c_j)) <= sum_(n=1)^oo (F(b_n + delta_n) - F(a_n)) <= sum_(n=1)^oo (F(b_n) - F(a_n)) + epsilon
    $
    根据 $F(t) < epsilon$，我们因此有
    $ F(x) - epsilon <= sum_(n=1)^oo (F(b_n) - F(a_n)) + F(t) <= sum_(n=1)^oo (F(b_n) - F(a_n)) + epsilon $
    由于 $epsilon$ 与覆盖序列 ${(a_n, b_n]}$ 都是任意的，不等式 $F(x) - epsilon <= mu^*((-oo,x])$ 成立，因此 $F(x) <= mu^*((-oo,x])$。

    证明区间 $(-oo, b]$ $mu^*$-可测的过程是简单的，和前面的证明类似，这里略去不表，因此就可以得知，每一个 $RR$ 的 Borel 集都是 $mu^*$-可测的。

    令 $mu$ 为 $mu^*$ 在 $cal(B)(RR)$ 上的限制。由前述步骤与 Carathéodory 定理，$mu$ 是一个测度，且满足 $mu((-oo, x]) = F(x)$ 对每个 $x$ 成立，由于 $F$ 有界，而 $mu(RR) = lim_(n->oo) mu((-oo, n]) = lim_(n->oo) F(n)$，故 $mu$ 为有限测度。

    最后验证 $mu$ 的唯一性，令 $mu$ 如上构造，设 $nu$ 是另一个满足 $nu((-oo, x]) = F(x)$ 的测度，我们首先证明 $nu(A) <= mu(A)$ 对每一个 $RR$ 上的 Borel 集 $A$ 都成立。若 ${(a_n, b_n]}$ 为满足 $A subset.eq union.big_n (a_n, b_n]$ 的半开区间序列，则由 $nu$ 的可数次可加性可知
    $ nu(A) <= sum_n nu((a_n, b_n]) = sum_n (F(b_n) - F(a_n)) $
    由于 $mu(A)$ 被定义为上式右侧所有可能的和式的下确界，因此 $nu(A) <= mu(A)$。将这个不等式用于 $A$ 与 $A^c$，并使用 $mu(RR) = nu(RR) < +oo$，就可以得知
    $ nu(RR) = nu(A) + nu(A^c) <= mu(A) + mu(A^c) = mu(RR) $
    因此，$nu(A) + nu(A^c) = mu(A) + mu(A^c)$，从而不可能有 $nu(A) < mu(A)$，因此 $nu(A) = mu(A)$。由于 $A$ 是任意的 Borel 集，因此 $nu = mu$, 唯一性得证。
]

这一节完成的最重要的事情就是 *给出了 Carathéodory 定理*，并且使用该定理 *构造出了 Lebesgue 测度*。其方法是，使用半开矩形对 $RR^d$ 上的集合进行覆盖，取这些覆盖的体积之和的下确界，得到一个外测度，然后使用 Carathéodory 定理得到一个测度空间，其测度就是 Lebesgue 测度。最后我们考虑 Lebesgue 可测的集合的范围，定理表明，$RR^d$ 上的所有 Borel 集都是 Lebesgue 可测的。这就允许我们有一个相当大的测度空间，对我们需要使用的几乎所有的集合都可以讨论测度。

#pagebreak()

== Lebesgue Measure <Section-1-4>

本节包含了 $RR^d$ 的 Lebesgue 测度的一些基本性质。如果需要希望快速了解关于 @Section-2 讲的函数和积分的内容，可以将注意力限制在 @Proposition-1-4-1、@Proposition-1-4-3 以及 @Theorem-1-4-1 之上就可以，这三个结果分别表明 Lebesgue 测度的正则性、平移不变性以及非 Lebesgue 可测集的存在性。

#proposition()[
    令 $A$ 为 $RR^d$ 的一个 Lebesgue 可测子集。则
    - $lambda (A) = inf{ lambda(U) : U text("is open and") A subset.eq U }$；
    - $lambda (A) = sup{ lambda(K) : K text("is compact and") K subset.eq A }$。
]<Proposition-1-4-1>

简单来说，这个 Proposition 说明 Lebesgue 测度是 *正则的/regular*，我们在 @Section-1-5 与 @Section-7 会深入介绍正则性。

#proof("Proof of Proposition 1.4.1")[
    注意到 $lambda$ 的单调性可以保证
    $
        lambda(A) <= inf{ lambda(U) : U text("is open and") A subset.eq U }\
        lambda(A) >= sup{ lambda(K) : K text("is compact and") K subset.eq A }.
    $
    因此我们只需要证明反向不等式成立就可以。

    首先证明第一个反向不等式：如果 $lambda(A) = +oo$，那么所需不等式显然成立，所以我们可以假设 $lambda(A) < +oo$。取任意 $epsilon > 0$，由 Lebesgue 测度的定义，存在一个 $d$ 维开区间序列 ${R_i}$，这里这个开区间序列并未限定为互不相交，使得 $A subset.eq union.big_i R_i$ 且 $sum_i op("vol")(R_i) < lambda(A) + epsilon$。令 $U = union.big_i R_i$ 则 $U$ 为开集，$A subset.eq U$，且
    $ lambda(U) <= sum_i lambda(R_i) = sum_i op("vol")(R_i) < lambda(A) + epsilon. $
    由于 $epsilon$ 任意，所需要的反向不等式因此成立。

    接下来证明第二个反向不等式：首先处理 $A$ 有界的情形，令 $C$ 为含有 $A$ 的有界闭集，并取任意的 $epsilon > 0$，利用第一部分的结论，可以选择一个包含 $C - A$ 的开集 $U$，使得
    $ lambda(U) < lambda(C - A) + epsilon. $
    令 $K = C - U$。则 $K$ 是 $A$ 的一个有界闭集，因此 $K$ 也是一个紧集。此外，由于 $C subset.eq K union U$，因此
    $ lambda(C) <= lambda(K) + lambda(U). $
    且根据 $lambda(C - A) = lambda(K) = lambda(C) - lambda(A)$，我们可以得到
    $ lambda (C) - lambda (K) <= lambda (U) < lambda (C - A) + epsilon = lambda (C) - lambda (A) + epsilon. $
    因此，$lambda (A) - epsilon < lambda (K)$，因此，$A$ 有界时的不等式成立。

    最后处理无界时候的情况，假设 $b$ 是任意一个小于 $lambda(A)$ 的实数，我们下面构造出一个 $A$ 的紧子集 $K$ 使得 $b < lambda(K)$。取一列递增的 $A$ 的有界可测子集 ${A_j}$，满足 $A = union_j A_j$，对于测度空间，我们可以知道 $lambda(A) = lim_j lambda(A_j)$，所以我们可以选择一个 $j_0$ 使得 $lambda(A_(j_0)) > b$。现在对于 $A_j_0$ 应用就在刚刚证明了的东西，我们可以给出一个 $A_j_0$ 的紧子集 $K$ 使得 $lambda(K) > b$，因此 $K$ 也是 $A$ 的紧子集。由于 $b$ 是任意小于 $lambda(A)$ 的数，因此所需不等式成立。
]

我们下面考虑处理一些具有特定形式的半开立方体，首先证明下面引理：

#lemma()[
    每一个 $RR^d$ 的开子集都可以表示成可数个两两不相交的半开立方体的并，每一个立方体都可以表示下述形式：
    $ {(x_1,dots, x_d) : j_i * 2^(-k) <= x_i < (j_i+1) * 2^(-k), text("for") i=1,dots,d }, $ <1-4-Equation-1>
    这里 $j_1, dots, j_d$ 为若干整数，$k$ 为某个正整数。
]<Lemma-1-4-1>

#proof("Proof of Lemma 1.4.1")[]

/*
#proof("Proof of Lemma 1.4.2")[
    对每个正整数 $k$，令 $cal(C)_k$ 表示所有具有如下形式的立方体的全体：
    $
        {(x_1,ldots,x_d) : j_i 2^{-k} le x_i < (j_i+1)2^{-k} quad text(for } i=1,ldots,dtext{)},
    $
    其中 $j_1,ldots,j_d$ 为任意整数。容易看出：
    - $(a)$ 每个 $cal(C)_k$ 都是 $\RR^d$ 的一个可数划分；
    - $(b)$ 若 $k_1 < k_2$，则 $cal(C)_(k_2)$ 中的每个立方体都包含在 $cal(C)_(k_1)$ 的某个立方体中。

    读者在检验下面定义的集合 $cal(D)$ 具有所声称性质时，应牢记关于族 ${cal(C)_k}$ 的以上事实。

    设 $U$ 是 $\RR^d$ 的一个开子集。我们按如下方式构造一组立方体 $cal(D)$：从 $cal(D)$ 为空开始，然后在第 $k$ 步（$k=1,2,ldots$），把 $cal(C)_k$ 中那些包含在 $U$ 内、且与之前步骤已放入 $cal(D)$ 的所有立方体两两不交的立方体加入 $cal(D)$。显然，$cal(D)$ 是一族可数两两不交的立方体，它们的并包含于 $U$。剩下只需验证其并包含 $U$。取 $x in U$。由于 $U$ 为开集，包含 $x$ 的 $cal(C)_k$ 中的立方体在 $k$ 充分大时也包含于 $U$。令 $k_0$ 为满足该性质的最小 $k$。则包含 $x$ 的 $cal(C)_(k_0)$ 中的立方体属于 $cal(D)$，从而 $x$ 属于 $cal(D)$ 中立方体的并。 ▢
]
*/

#proposition()[
    Lebesgue 测度是 $(RR^d, cal(B)(RR^d))$ 上唯一一个可以将每一个 $d$ 维区间、甚至于任何一个形为 @1-4-Equation-1 的半开立方体赋以其体积的测度。
]<Proposition-1-4-2>

#proof("Proof of Proposition 1.4.2")[]

/*
#proof("Proof of Proposition 1.4.3")[
    Lebesgue 测度确实把每个 $d$ 维区间的体积赋值为其体积，这是在 1.3 节中完成的。因此我们只需假设 $mu$ 是 $(RR^d, cal(B)(RR^d))$ 上的某个测度，它把式 (3) 中给出的每个立方体 $C$ 的体积都赋为其体积，并证明 $mu = lambda$。

    首先设 $U$ 为 $\RR^d$ 的开子集。由 Lemma 1.4.2，存在一列两两不交的、具有式 (3) 形式的半开立方体 ${C_j}$，其并为 $U$，于是
    $
        mu(U) = sum_j mu(C_j) = sum_j lambda(C_j) = lambda(U);
    $
    因而 $mu$ 与 $lambda$ 在 $\RR^d$ 的开子集上相一致。接着设 $A$ 为任意 Borel 子集。若 $U$ 是包含 $A$ 的 $\RR^d$ 开子集，则 $mu(A) le mu(U) = lambda(U)$；进而
    $
        mu(A) le inf{ lambda(U) : U text( is open) quad and quad A subseteq U }.
    $
    现在由 $lambda$ 的正则性（Proposition 1.4.1）可得
    $
        mu(A) le lambda(A). quad (4)
    $

    我们需要把该不等式提升为等式。先设 $A$ 为 $\RR^d$ 的有界 Borel 子集，且 $V$ 为包含 $A$ 的有界开集。将不等式 $(4)$ 分别应用于集合 $A$ 与 $V-A$，得到
    $
        mu(V) = mu(A) + mu(V - A) le lambda(A) + lambda(V - A) = lambda(V);
    $
    由于该不等式两端的极端项相等，且 $mu(A)$ 与 $mu(V-A)$ 分别不大于 $lambda(A)$ 与 $lambda(V-A)$，于是 $mu(A)$ 与 $lambda(A)$ 相等。最后，$\RR^d$ 的任意 Borel 子集 $A$ 都可表示为一列两两不交的有界 Borel 集的并，故必有 $mu(A) = lambda(A)$。 ▢
]
*/

下面我们讨论 Lebesgue 测度的*平移不变性*，对于 $RR^d$ 的每个元素 $x$ 与子集 $A$，我们用 $A + x$ 表示集合 $A + x = { y in RR^d : y = a + x text("for some") a in A }$，这个集合称为 $A$ 在 $x$ 处的 *平移/translate*。

#proposition()[
    $RR^d$ 上的 Lebesgue 外测度在平移下不变：若 $x in RR^d$ 且 $A subset RR^d$，则 $lambda^*(A) = lambda^*(A + x)$。此外，$B subset RR^d$ 是 Lebesgue 可测的，当且仅当 $B + x$ 是 Lebesgue 可测的。
]<Proposition-1-4-3>

这个命题是对 Lebesgue 外测度的平移不变性的描述，很容易知道，显然 Lebesgue 测度也是平移不变的。

#proof("Proof of Proposition 1.4.3")[]

/*
#proof("Proof of Proposition 1.4.4")[
    $lambda^*(A)$ 与 $lambda^*(A+x)$ 的相等性由 $lambda^*$ 的定义以及 $d$ 维区间体积对平移不变的事实推出。第二个断言由第一个断言与可测性的定义共同推出——注意到集合 $B$ 满足
    $
        lambda^*(A - x) = lambda^*(((A - x) cap B)) + lambda^*(((A - x) cap B^c))
    $
    对于所有集合 $A - x$ 等价于 $B + x$ 满足
    $
        lambda^*(A) = lambda^*(A cap (B + x)) + lambda^*(A cap (B + x)^c)
    $
    对于所有集合 $A$。 ▢
]
*/

下面是一个更一般的结论：

#proposition()[
    设 $mu$ 是 $(RR^d, cal(B)(RR^d))$ 上的一个非零的满足平移不变性的测度，并且在 $RR^d$ 上的有界 Borel 子集上有限。则存在一个常数 $c$，对每一个 $A in cal(B)(RR^d)$ 都有 $mu(A) = c lambda(A)$。
]<Proposition-1-4-4>

这个命题成立的前提是可测空间 $(RR^d, cal(B)(RR^d))$ 上的测度 $mu$ 平移不变性的的定义是有意义的，这就需要 $RR^d$ 上的 Borel $sigma$-代数必须是平移不变的，也就是若 $A in cal(B)(RR^d)$ 且 $x in RR^d$，则 $A + x in cal(B)(RR^d)$。要验证 $cal(B)(RR^d)$ 的平移不变性，只需要注意 ${A subset.eq RR^d : A + x in cal(B)(RR^d)}$ 是一个包含开集的 $sigma$-代数，因此包含 $cal(B)(RR^d)$。

#proof("Proof of Proposition 1.4.4")[]

/*
#proof("Proof of Proposition 1.4.5")[
    注意：为了使关于 $(RR^d, cal(B)(RR^d))$ 上测度的平移不变性概念有意义，$\RR^d$ 上的 Borel $sigma$-代数必须在平移下不变，也即若 $A in cal(B)(RR^d)$ 且 $x in RR^d$，则 $A + x in cal(B)(RR^d)$。要检验 $cal(B)(RR^d)$ 的此平移不变性，注意到
    $
        { A subseteq RR^d : A + x in cal(B)(RR^d) }
    $
    是一个包含开集、从而包含 $cal(B)(RR^d)$ 的 $sigma$-代数。

    令 $C = {(x_1,ldots,x_d): 0 le x_i < 1 text{ for each } i}$，并令 $c = mu(C)$。由于 $mu$ 在有界 Borel 集上有限，$c$ 有限；并且 $c > 0$（若 $c=0$，则 $\RR^d$ 作为 $C$ 的平移的可数并，将具有测度 $0$，与 $mu$ 为非零矛盾）。定义一个在 $cal(B)(RR^d)$ 上的测度 $nu$，令
    $
        nu(A) = (1/c) mu(A)
    $
    对每个 $A in cal(B)(RR^d)$ 成立。于是 $nu$ 在平移下不变，且它把上面定义的集合 $C$ 的测度赋为其 Lebesgue 测度，即 $1$。若 $D$ 是具有式 (3) 形式且边长为 $2^{-k}$ 的半开立方体，则 $C$ 是 $2^{dk}$ 个 $D$ 的平移的并，从而
    $
        2^{dk} , nu(D) = nu(C) = lambda(C) = 2^{dk} , lambda(D);
    $
    据此 $nu$ 与 $lambda$ 在所有此类立方体上一致。由 Proposition 1.4.3 知 $nu = lambda$，故 $mu = c lambda$。 ▢
]

*/

#example("Cantor Set / Cantor 三分集")[]<Example-1-4-1>

/*
#example("The Cantor Set")[
    我们需要注意一些关于 *Cantor 集* 的事实；该集在后文中会成为一个有用的例子来源。回忆其构造如下。令 $K_0$ 为区间 $[0,1]$。从 $K_0$ 中去掉区间 $(1/3, 2/3)$ 得到 $K_1$。于是 $K_1 = [0,1/3] cup [2/3,1]$。继续此过程，形成 $K_n$：从 $K_{n-1}$ 的每个闭区间中去掉其中开的中间三分之一。于是 $K_n$ 是 $2^n$ 个两两不交闭区间的并，每个区间长度为 $(1/3)^n$。*Cantor 集*（我们暂记作 $K$）即为保留下来的点的集合；于是 $K = inter_n K_n$。

    当然，$K$ 是闭且有界的。此外，$K$ 没有内点：若有某个开区间包含于 $K$，则对每个 $n$ 都会包含于组成 $K_n$ 的某个闭区间中，而其长度至少为 $(1/3)^n$，矛盾。$K$ 的基数是连续统的基数：容易检验，将序列 ${z_n}$（每个 $z_n$ 取 $0$ 或 $1$）映到实数 $sum_{n=1}^oo z_n / 3^n$ 的映射在所有此类序列的集合与 $K$ 间给出一个双射；因此 $K$ 的基数与所有 $0/1$ 序列的集合相同，也即与连续统的基数相同（见附录 A）。
]<Example-1-4-6>
*/

#proposition()[
    Cantor 集是一个紧集；它的基数为连续统，但其 Lebesgue 测度为零。
]<Proposition-1-4-5>

#proof("Proof of Proposition 1.4.5")[]

#example("A Nonmeasurable Set")[]<Example-1-4-2>

#theorem()[]<Theorem-1-4-1>

#proof("Proof of Theorem 1.4.1")[]

#proposition()[]<Proposition-1-4-6>

#proof("Proof of Proposition 1.4.6")[]

#proposition()[]<Proposition-1-4-7>

#proof("Proof of Proposition 1.4.7")[]

/*
#proof("Proof of Proposition 1.4.7")[
    我们已经指出 Cantor 集（再记作 $K$）是紧的，且具有连续统基数。要计算 $K$ 的测度，注意对每个 $n$，$K$ 都包含在先前构造的集合 $K_n$ 中，且 $lambda(K_n) = (2/3)^n$。因此 $lambda(K) le (2/3)^n$ 对每个 $n$ 都成立，于是 $lambda(K)$ 必为 $0$。（另一种证明是，检验在 $[0,1]$ 上构造 $K$ 的过程中所移除的各个开区间的测度之和等于几何级数
    $
        1/3 + (2/3) cdot 1/3 + (2/3)^2 cdot 1/3 + (2/3)^3 cdot 1/3 + dots,
    $
    从而等于 $1$。） ▢
]

#example("A Nonmeasurable Set")[
    现在回到 1.3 节中做过的一个承诺：我们将证明 $RR$ 的一个子集中存在不是 Lebesgue 可测的集合。注意我们的证明使用了选择公理。该公理是否必需，曾经是直到 20 世纪 60 年代中期仍然开放的问题；当时 R.M. Solovay 证明：若某个集合论中的一致性假设成立，则在不使用选择公理的 Zermelo–Fraenkel 公理体系中，不能证明存在一个不是 Lebesgue 可测的 $RR$ 子集（见附录 A 的 A.12 与 A.13；Solovay 的文献见 [110]）。
]

#theorem()[
    存在 $RR$ 的一个子集，实际上在区间 $(0,1)$ 中就存在一个不是 Lebesgue 可测的子集。
]<Theorem-1-4-9>

#proof("Proof of Theorem 1.4.9")[
    在 $RR$ 上定义关系 $x sim y$ 当且仅当 $x - y$ 为有理数。容易检验 $sim$ 为等价关系：反身（$x sim x$ 对每个 $x$ 成立）、对称（$x sim y$ 蕴含 $y sim x$）以及传递（$x sim y$ 与 $y sim z$ 蕴含 $x sim z$）。注意 $sim$ 下的每个等价类均具有 $QQ + x$ 的形式，对某个 $x$ 成立，并且在 $RR$ 中稠密。由于这些等价类彼此不交，且每个都与区间 $(0,1)$ 相交，我们可用选择公理从 $(0,1)$ 中取出一个子集 $E$，它恰好从每个等价类中取一个元素。我们将证明该集合 $E$ 不是 Lebesgue 可测的。

    令 ${r_n}$ 为区间 $(-1,1)$ 内有理数的一个枚举；对每个 $n$ 令 $E_n = E + r_n$。我们将验证：
    - $(a)$ 集合 $E_n$ 两两不交；
    - $(b)$ $union_n E_n subset (-1,2)$；
    - $(c)$ 区间 $(0,1)$ 包含于 $union_n E_n$。

    为验证 $(a)$，注意：若某些 $m
e n$ 使 $E_m cap E_n
eq emptyset$，则存在 $E$ 中的元素 $e, e'$，使得 $e + r_m = e' + r_n$；于是 $e sim e'$，从而 $e = e'$ 并且 $m = n$。因此 $(a)$ 成立。断言 $(b)$ 来自包含关系 $E subseteq (0,1)$ 以及序列 ${r_n}$ 的每一项均属于 $(-1,1)$ 的事实。现在考虑断言 $(c)$。取 $x$ 为 $(0,1)$ 的任一元素，并令 $e$ 为满足 $x sim e$ 的 $E$ 中元素。则 $x - e$ 为有理数，且属于 $(-1,1)$（回忆 $x$ 与 $e$ 都属于 $(0,1)$），故其等于某个 $r_n$。因此 $x in E_n$，$(c)$ 得证。

    假设集合 $E$ 是 Lebesgue 可测的。于是对每个 $n$，集合 $E_n$ 可测（Proposition 1.4.4），并由 $(a)$ 得
    $
        lambda(union_n E_n) = sum_n lambda(E_n).
    $
    又由 $lambda$ 的平移不变性知，对每个 $n$ 都有 $lambda(E_n) = lambda(E)$。因此，若 $lambda(E) = 0$，则 $lambda(union_n E_n) = 0$，与上面的 $(c)$ 矛盾；若 $lambda(E)
e 0$，则 $lambda(union_n E_n) = +oo$，与 $(b)$ 矛盾。由此，从 $E$ 可测的假设得出矛盾，证明完成。 ▢
]

现在取 $A subset RR$。定义 $diff(A)$ 为 $RR$ 的如下子集：
$
    diff(A) = { x - y : x in A text(" and ") y in A }.
$
关于此类集合的下述事实有时很有用。

#proposition()[
    设 $A$ 为 $RR$ 的 Lebesgue 可测子集，且 $lambda(A) > 0$。则 $diff(A)$ 含有一个包含 $0$ 的开区间。
]<Proposition-1-4-10>

#proof("Proof of Proposition 1.4.10")[
    依 Proposition 1.4.1，存在 $A$ 的一个紧子集 $K$ 使 $lambda(K) > 0$。由于 $diff(K) subseteq diff(A)$，只需证明 $diff(K)$ 含有一个包含 $0$ 的开区间。注意：实数 $x$ 属于 $diff(K)$ 当且仅当 $K$ 与 $x + K$ 相交；因此只需证明当 $abs(x)$ 充分小时，$K$ 与 $x + K$ 相交。

    用 Proposition 1.4.1 选取开集 $U$，使 $K subseteq U$ 且 $lambda(U) < 2 lambda(K)$。集合 $K$ 中点与 $U$ 外点之间的距离都离 $0$ 有界（因为从 $U$ 中点 $x$ 到 $U$ 的补集的距离是 $x$ 的连续且严格正的函数，并在紧集 $K$ 上有正的最小值；见 D.27 与 D.18）。因此存在正数 $eps$，使当 $abs(x) < eps$ 时，$x + K subseteq U$。若 $abs(x) < eps$ 但 $x + K$ 与 $K$ 不相交，则由 $lambda$ 的平移不变性与 $K subseteq U$ 可得
    $
        2 lambda(K) = lambda(K) + lambda(x + K) = lambda(K cup (x + K)) le lambda(U).
    $
    然而这与不等式 $lambda(U) < 2 lambda(K)$ 矛盾，于是 $K$ 与 $x + K$ 不可能不相交。因此 $(-eps, eps) subseteq diff(K)$，进而包含于 $diff(A)$。 ▢
]

我们可以使用 Proposition 1.4.10，再对 Theorem 1.4.9 的证明做一个改动，以得到如下更强结论（见本节末尾的备注与 Proposition 1.5.4 之后的结果）。

#proposition()[
    存在 $RR$ 的一个子集 $A$，使得包含在 $A$ 内或包含在 $A^c$ 内的每个 Lebesgue 可测子集的测度都为零。
]<Proposition-1-4-11>

#proof("Proof of Proposition 1.4.11")[
    在 $RR$ 中定义子集
    $
        G = { x : x = r + n sqrt(2) text(" for some ") r in QQ text(" and ") n in ZZ },
    $
    $
        G_0 = { x : x = r + 2n sqrt(2) text(" for some ") r in QQ text(" and ") n in ZZ },
    $
    $
        G_1 = { x : x = r + (2n + 1) sqrt(2) text(" for some ") r in QQ text(" and ") n in ZZ }.
    $
    容易看出 $G$ 与 $G_0$ 都是（关于加法的）$RR$ 的子群，$G_0$ 与 $G_1$ 不相交，且 $G_1 = G_0 + sqrt(2)$，并且 $G = G_0 cup G_1$。在 $RR$ 上定义关系 $x sim y$ 当 $x - y in G$；于是 $sim$ 是一个等价关系。用选择公理取 $RR$ 的一个子集 $E$，它在 $sim$ 的每个等价类中都恰取一个代表。令 $A = E + G_0$（即 $A$ 由所有形如 $e + g_0$ 的点组成，其中 $e in E$, $g_0 in G_0$）。

    我们现在证明：$A$ 的每个 Lebesgue 可测子集 $B$ 都满足 $lambda(B) = 0$。为此，假设存在这样的 $B$ 使得 $lambda(B) > 0$，并导出矛盾。Proposition 1.4.10 蕴含存在某个区间 $(-eps, eps) subseteq diff(B)$，从而 $(-eps, eps) subseteq diff(A)$。由于 $G_1$ 在 $RR$ 中稠密，它与区间 $(-eps, eps)$ 相交，因而也与 $diff(A)$ 相交。然而，这是不可能的，因为 $diff(A)$ 的每个元素都可写成 $e_1 - e_2 + g_0$（其中 $e_1, e_2 in E$, $g_0 in G_0$），从而不可能属于 $G_1$（若有 $e_1 - e_2 + g_0 = g_1$，则意味着 $e_1 = e_2$ 且 $g_0 = g_1$，与 $G_0$ 与 $G_1$ 不相交矛盾）。这就完成了对 $A$ 的每个可测子集必须测度为零的证明。

    容易检验 $A^c = E + G_1$，从而 $A^c = A + sqrt(2)$。因此，$A^c$ 的每个 Lebesgue 可测子集都具有 $B + sqrt(2)$ 的形式，其中 $B$ 是 $A$ 的某个 Lebesgue 可测子集。由于 $A$ 没有正测度的可测子集，$A^c$ 也没有；证毕。 ▢

    注意 Proposition 1.4.11 中的 $A$ 并非 Lebesgue 可测：若它可测，则 $A$ 与 $A^c$ 都将包含（实际上本身就是）正测度的 Lebesgue 可测集合。如此我们本可以把 Theorem 1.4.9 作为 Proposition 1.4.11 的推论来陈述。（当然，Theorem 1.4.9 的证明比 Propositions 1.4.10 与 1.4.11 联合起来的证明更简短，并且是经典且众所周知的论证；因此仍将其单独给出。）
]

*/

#pagebreak()

== Completeness and Regularity <Section-1-5>

#pagebreak()

== Dynkin Classes <Section-1-6>

#pagebreak()

= Functions and Integrals <Section-2>

== Measurable Functions <Section-2-1>

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

= Measures on Locally Compact Spaces <Section-7>

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
