#import "./template.typ": *

#show: template.with(
    title: "Advanced Probability",
    short_title: "Note of Probability: Theory and Examples by Rick Durrett",
    description: "Notes based on Book: Probability: Theory and Examples by Rick Durrett",
    paper_size: "a4",
    cols: 1,
    text_font: ("Palatino", "STIX Two Text", "Noto Serif SC"),
    code_font: ("Fira Code", "Monaspace Neon", "LXGW WenKai Mono"),
    accent: "#1A41AC",
    colortab: true,
    h1-prefix: "Chapter",
)

#pagebreak()

= Measure Theory

== Probability Spaces

一个 *概率空间/Probability Space* 是一个三元组 $(Omega, cal(F), P)$，其中 $Omega$ 是结果/Outcomes 的集合，$cal(F)$ 是事件/Events 的集合，而 $P: cal(F) arrow [0, 1]$ 是一个给事件分配概率的函数。我们假设 $cal(F)$ 是一个 *$sigma$-代数/$sigma$-Algebra*，即 $Omega$ 的子集的一个非空集合，满足对可数交、可数并和补集运算的封闭性。仅给定 $(Omega, cal(F))$，我们称之为 *可测空间/Measurable Space*，即我们可以通过其定义测度的空间，所谓测度是一个非负的、可数可加的函数，即一个函数 $mu: cal(F) arrow RR$，满足

- 对所有 $A in cal(F)$，$mu(A) >= mu(diameter) = 0$；
- 若 $A_i in cal(F)$ 是互不相交的集合序列，则 $mu(union.big_i A_i) = sum_i mu(A_i)$。

如果对于全集 $Omega$，$mu(Omega) = 1$，我们称 $mu$ 是一个 *概率测度/Probability Measure*。在本书中，概率测度通常用 $P$ 表示。

#theorem()[
    令 $mu$ 是 $(Omega, cal(F))$ 上的一个测度，则 $mu$ 满足下面性质：

    1. *单调性/Monotonicity*。如果 $A subset B$，则 $mu(A) <= mu(B)$；
    2. *次可加性/Subadditivity*。如果 $A subset union.big_(m=1)^infinity A_m$，则 $mu(A) <= sum_(m=1)^infinity mu(A_m)$；
    3. *下连续性/Continuity from below*。如果 $A_i arrow.t A$，换句话说 $A_1 subset A_2 subset ...$ 并且 $union.big_i A_i = A$，则 $mu(A_i) arrow.t mu(A)$；
    4. *上连续性/Continuity from above*。如果 $A_i arrow.b A$，换句话说 $A_1 supset A_2 supset ...$，$inter.big_i A_i = A$，且 $mu(A_1) < infinity$，则 $mu(A_i) arrow.b mu(A)$。
]

#proof()[
    1. 由于 $B = A union (B inter A^c)$，可以知道 $mu(B) = mu(A) + mu(B inter A^c) >= mu(A)$；
    2. 令 $A_n^prime = A_n inter A$，$B_1 = A_1^prime$，$B_n = A_n^prime - union.big_(m=1)^(n-1) A_m^prime$，则 $B_n$ 互不相交且 $union.big_m B_m = A$，还有 $B_n subset A_n$，所以 $mu(A) = sum_(m=1)^infinity mu(B_m) <= sum_(m=1)^infinity mu(A_m)$；
    3.
]

注意到，如果 $cal(F)_i$ 是一列 $sigma$-代数，那么其交 $inter.big_i cal(F)_i$ 也是一个 $sigma$-代数。如果我们给定一个集合 $Omega$ 和 $Omega$ 的子集的集合 $cal(A)$，那么存在包含 $cal(A)$ 的最小 $sigma$-代数。我们将此称为 *由 $cal(A)$ 生成的 $sigma$-代数* 并记为 $sigma(cal(A))$。

下面记 $bold(R)^d$ 为实数向量 $(x_1, dots x_d)$ 的集合，$cal(R)^d$ 为 Borel 集合，即包含开集的最小 $sigma$-代数。我们可以如下定义 Stieltjes 测度函数和 Lebesgue 测度：

#theorem()[
    在 $(bold(R), cal(R))$ 上定义的测度 $F$ 如果满足下面性质：
    - $F$ 是非减的；
    - $F$ 是右连续的，即 $lim_(y arrow.b x) F(y) = F(x)$；
    那么称 $F$ 是一个 *Stieltjes 测度函数/Stieltjes Measure Function*。与这个 Stieltjes 测度函数 $F$ 对应，在 $(bold(R), cal(R))$ 上存在唯一的测度 $mu$，满足 $mu((a, b]) = F(b) - F(a)$。当 $F(x) = x$ 时，产生的测度称为 *勒贝格测度/Lebesgue Measure*。
]

这个定理的难点在于，我们只知道测度在半开区间 $(a, b]$ 上的取值，但是测度的定义域是 $sigma$-代数，我们需要完成定义域的扩展，并且保证扩展后的测度唯一。证明这个定理的过程漫长而曲折，我们仅仅需要学习其主要思路。首先，我们需要知道为什么这里选择的是左开右闭区间。至于 *为什么是右闭*，是因为如果 $b_n arrow.b b$，则 $inter.big_n (a, b_n] = (a, b]$。至于 *为什么是左开*，我们将在下面的定义 *半代数/Semialgebra* 以及 *代数/Algebra* 中看到。

#definition("半代数/Semialgebra")[
    一个集合族 $cal(S)$ 如果满足下面性质，那么称 $cal(S)$ 是一个 *半代数/Semialgebra*。
    1. 对交运算封闭，即如果 $S, T in cal(S)$，那么 $S inter T in cal(S)$；
    2. 如果 $S in cal(S)$，则 $S^c$ 可以表示成 $cal(S)$ 中若干集合的有限个两两不交并。
]

#definition("代数/Algebra")[
    全集 $Omega$ 的子集的集合 $cal(A)$ 如果满足下面条件，那么称之为一个 *代数/Algebra*。
    1. 对补集运算封闭，即如果 $A in cal(A)$，那么 $A^c in cal(A)$；
    2. 对并运算封闭，即如果 $A, B in cal(A)$，那么 $A union B in cal(A)$。
    显然代数对交运算也封闭，因为 $A inter B = (A^c union B^c)^c$。
]

事实上，左开右闭区间 $(a, b]$ 构成了实数轴上的一个半代数。

/*
*例 1.1.5* $cal(S)_d$ 定义为：空集以及所有形如
$
  (a_1, b_1] × ⋯ × (a_d, b_d] ⊂ ℝ^d
$
的集合，其中 $-∞ ≤ a_i < b_i ≤ ∞$。

式（1.1.1）给出了 $mu$ 在半代数 $cal(S)_1$ 上的取值。要从半代数走向 σ-代数，我们需要一个中间步骤。若 $cal(A)$ 是 $Omega$ 的子集族，并满足：只要 $A, B ∈ cal(A)$，就有 $A^c ∈ cal(A)$ 且 $A ∪ B ∈ cal(A)$，则称 $cal(A)$ 为一个 *代数（algebra，或 field）*。由于
$
  A ∩ B = (A^c ∪ B^c)^c,
$
可知 $A ∩ B ∈ cal(A)$。显然，σ-代数必然是代数。反过来不成立的一个例子是：

*例 1.1.6* 令 $Omega = ℤ$（整数集）。令 $cal(A)$ 为所有满足“$A ⊂ ℤ$ 且 $A$ 或 $A^c$ 为有限集”的集合 $A$ 的全体，则 $cal(A)$ 是一个代数。

*引理 1.1.7* 若 $cal(S)$ 是一个半代数，则
$
  bar(S) = { text("由") cal(S) text("中的集合构成的有限个两两不交并") }
$
是一个代数，称为*由 $cal(S)$ 生成的代数*。

*证明* 设 $A = +_i S_i$ 且 $B = +_j T_j$，其中 $+$ 表示不交并，并且我们假设指标集是有限的。则
$
  A ∩ B = +_(i, j) (S_i ∩ T_j) ∈ bar(S).
$
再看补集：若 $A = +_i S_i$，则
$
  A^c = ⋂_i S_i^c.
$
由半代数 $cal(S)$ 的定义可知 $S_i^c ∈ bar(S)$。我们已说明 $bar(S)$ 对交封闭，因此可由归纳推出 $A^c ∈ bar(S)$。∎

*例 1.1.8* 令 $Omega = ℝ$ 且 $cal(S) = cal(S)_1$，则
$
  bar(S)_1
$
由空集以及所有形如
$
  ⋃_(i=1)^k (a_i, b_i]
$
的集合组成，其中 $-∞ ≤ a_i < b_i ≤ ∞$。

给定一个定义在 $cal(S)$ 上的集合函数 $mu$，我们可以把它扩展到 $bar(S)$ 上：若 $A_i$ 两两不交，则定义
$
  mu(+_(i=1)^n A_i) = sum_(i=1)^n mu(A_i).
$

所谓*代数 $cal(A)$ 上的测度*，指的是一个集合函数 $mu$，满足：

(i) 对所有 $A ∈ cal(A)$，$mu(A) ≥ mu(∅) = 0$；

(ii) 若 $A_i ∈ cal(A)$ 两两不交且它们的并仍属于 $cal(A)$，则
$
  mu(⋃_(i=1)^∞ A_i) = sum_(i=1)^∞ mu(A_i).
$

称 $mu$ 为 *σ-有限（σ-finite）*，若存在一列集合 $A_n ∈ cal(A)$ 使得 $mu(A_n) < ∞$ 且 $⋃_n A_n = Omega$。令 $A_1' = A_1$，并对 $n ≥ 2$ 令
$
  A_n' = ⋃_(m=1)^n A_m
  \quad text("或") \quad
  A_n' = A_n ∩ (⋂_(m=1)^(n-1) A_m^c) ∈ cal(A),
$
则不失一般性地，我们可以假设要么 $A_n ↑ Omega$，要么 $A_n$ 两两不交。

下面的结果帮助我们把定义在半代数 $cal(S)$ 上的测度扩展到它所生成的 σ-代数 $sigma(cal(S))$。

*定理 1.1.9* 设 $cal(S)$ 为半代数，且 $mu$ 定义在 $cal(S)$ 上并满足 $mu(∅) = 0$。假设：

(i) 若 $S ∈ cal(S)$ 可以写成有限个两两不交集合 $S_i ∈ cal(S)$ 的并，则 $mu(S) = sum_i mu(S_i)$；

(ii) 若 $S_i, S ∈ cal(S)$ 且 $S = +_(i ≥ 1) S_i$，则 $mu(S) ≤ sum_(i ≥ 1) mu(S_i)$。

则 $mu$ 存在唯一的扩展 $bar(mu)$，使其成为 $bar(S)$（由 $cal(S)$ 生成的代数）上的测度。若 $bar(mu)$ 是 σ-有限的，则还存在唯一的扩展 $nu$，使其成为 $sigma(cal(S))$ 上的测度。

在上面的 (ii) 中以及后文中，$i ≥ 1$ 表示可数个集合的并；而普通下标 $i$ 或 $j$ 表示有限个集合的并。定理 1.1.9 的证明较为复杂，故放在 A.1 节。为了检验定理中的条件 (ii)，下面的引理是有用的。

*引理 1.1.10* 仅假设定理 1.1.9 的 (i) 成立。

(a) 若 $A, B_i ∈ bar(S)$ 且 $A = +_(i=1)^n B_i$，则 $bar(mu)(A) = sum_i bar(mu)(B_i)$。

(b) 若 $A, B_i ∈ bar(S)$ 且 $A ⊂ ⋃_(i=1)^n B_i$，则 $bar(mu)(A) ≤ sum_i bar(mu)(B_i)$。

*证明* 注意到：若 $A = +_i B_i$ 是 $bar(S)$ 中集合的有限个两两不交并，并且 $B_i = +_j S_(i, j)$，则由定义可得
$
  bar(mu)(A) = sum_(i, j) mu(S_(i, j)) = sum_i bar(mu)(B_i).
$

为证明 (b)，先考虑 $n = 1$ 的情形，此时 $B_1 = B$。注意到
$
  B = A + (B ∩ A^c),
$
且 $B ∩ A^c ∈ bar(S)$，因此
$
  bar(mu)(A) ≤ bar(mu)(A) + bar(mu)(B ∩ A^c) = bar(mu)(B).
$

现在处理 $n > 1$。令
$
  F_k = B_1^c ∩ ⋯ ∩ B_(k-1)^c ∩ B_k,
$
并注意到
$
  ⋃_i B_i = F_1 + ⋯ + F_n,
$
以及
$
  A = A ∩ (⋃_i B_i) = (A ∩ F_1) + ⋯ + (A ∩ F_n).
$
于是利用 (a)、以及在 $n=1$ 的情形下的 (b)，再用一次 (a)，得到
$
  bar(mu)(A)
  = sum_(k=1)^n bar(mu)(A ∩ F_k)
  ≤ sum_(k=1)^n bar(mu)(F_k)
  = bar(mu)(⋃_i B_i).
$
∎

*定理 1.1.4 的证明* 令 $cal(S)$ 为半开区间 $(a, b]$（其中 $-∞ ≤ a < b ≤ ∞$）所构成的半代数。为在 $cal(S)$ 上定义 $mu$，先注意到
$
  F(∞) = lim_(x ↑ ∞) F(x)
  \quad text("与") \quad
  F(-∞) = lim_(x ↓ -∞) F(x)
$
都存在；并且对所有 $-∞ ≤ a < b ≤ ∞$，
$
  mu((a, b]) = F(b) - F(a)
$
都是有意义的，因为 $F(∞) > -∞$ 且 $F(-∞) < ∞$。

若
$
  (a, b] = +_(i=1)^n (a_i, b_i],
$
则在对区间重新编号后必有 $a_1 = a$、$b_n = b$，并且对 $2 ≤ i ≤ n$ 有 $a_i = b_(i-1)$，因此定理 1.1.9 的条件 (i) 成立。为检验 (ii)，先假设 $-∞ < a < b < ∞$，并且
$
  (a, b] ⊂ ⋃_(i ≥ 1) (a_i, b_i],
$
其中（不失一般性）$-∞ < a_i < b_i < ∞$。取 $δ > 0$ 使得 $F(a + δ) < F(a) + ε$，并取 $η_i$ 使得
$
  F(b_i + η_i) < F(b_i) + ε * 2^(-i).
$

开区间 $(a_i, b_i + η_i)$ 覆盖 $[a + δ, b]$，因此存在一个有限子覆盖 $(alpha_j, beta_j)$，$1 ≤ j ≤ J$。由于
$
  (a + δ, b] ⊂ ⋃_(j=1)^J (alpha_j, beta_j],
$
由引理 1.1.10 的 (b) 推出
$
  F(b) - F(a + δ)
  ≤ sum_(j=1)^J (F(beta_j) - F(alpha_j))
  ≤ sum_(i=1)^∞ (F(b_i + η_i) - F(a_i)).
$

因此由 $δ$ 与 $η_i$ 的选取可得
$
  F(b) - F(a) ≤ 2ε + sum_(i=1)^∞ (F(b_i) - F(a_i)).
$
由于 $ε$ 是任意的，我们就证明了在 $-∞ < a < b < ∞$ 情形下的结论。

为去掉最后的限制，注意到若 $(a, b] ⊂ ⋃_i (a_i, b_i]$ 且 $(A, B] ⊂ (a, b]$ 满足 $-∞ < A < B < ∞$，则有
$
  F(B) - F(A) ≤ sum_(i=1)^∞ (F(b_i) - F(a_i)).
$
由于该不等式对任意有限区间 $(A, B] ⊂ (a, b]$ 都成立，所求结论随之得到。∎

*/

== Distributions

== Random Variables

== Integration

== Properties of the Integral

== Expected Value

=== Inequalities

=== Integration to the Limit

=== Computing Expected Values

== Product Measures, Fubini's Theorem

= Laws of Large Numbers

== Independence

=== Sufficient Conditions for Independence

=== Independence, Distribution, and Expectation

=== Sums of Independent Random Variables

=== Constructing Independent Random Variables

== Weak Laws of Large Numbers

=== $L^2$ Weak Laws

=== Triangular Arrays

=== Truncation

== Borel-Cantelli Lemmas

== Strong Law of Large Numbers

== Convergence of Random Series\*

=== Rates of Convergence

=== Infinite Mean

== Renewal Theory\*

== Large Deviations\*

= Central Limit Theorems

== The De Moivre-Laplace Theorem

== Weak Convergence

== Characteristic Functions

=== Definition, Inversion Formula

=== Weak Convergence

=== Moments and Derivatives

=== Polya's Criterion\*

=== The Moment Problem\*

== Central Limit Theorems

=== i.i.d. Sequences

=== Triangular Arrays

=== Prime Divisors (Erdös-Kac)\*

=== Rates of Convergence (Berry-Esseen)\*

== Local Limit Theorems\*

== Poisson Convergence

=== The Basic Limit Theorem

=== Two Examples with Dependence

== Poisson Processes

=== Compound Poisson Processes

=== Thinning

=== Conditioning

== Stable Laws\*

== Infinitely Divisible Distributions\*

== Limit Theorems in $RR^d$

= Martingales

== Conditional Expectation

=== Examples

=== Properties

=== Regular Conditional Probabilities\*

== Martingales, Almost Sure Convergence

== Examples

=== Bounded Increments

=== Polya's Urn Scheme

=== Radon-Nikodym Derivatives

=== Branching Processes

== Doob's Inequality, Convergence in $L^p$, $p > 1$

== Square Integrable Martingales\*

== Uniform Integrability, Convergence in $L^1$

== Backwards Martingales

== Optional Stopping Theorems

=== Applications to Random Walks

== Combinatorics of Simple Random Walk\*

= Markov Chains

== Examples

== Construction, Markov Properties

== Recurrence and Transience

== Stationary Measures

== Asymptotic Behavior

== Periodicity, Tail $sigma$-Field\*

== General State Space\*

=== Recurrence and Transience

=== Stationary Measures

=== Convergence Theorem

=== GI/G/1 Queue
