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


#proof()[
    我们先对所有有限矩形定义 $mu(A) = Delta_A F$，然后利用单调性把定义扩展到 $cal(S)_d$ 上。
]

/*
*证明* 我们先对所有有限矩形定义 $mu(A) = Δ_A F$，然后利用单调性把定义扩展到 $S_d$。为检验定理 1.1.9 的 (i)，称 $A = +_k B_k$ 为 $A$ 的一个*规则细分*（regular subdivision），若存在序列
$
a_i = alpha_(i,0) < alpha_(i,1) < ⋯ < alpha_(i,n_i) = b_i,
$
使得每个小矩形 $B_k$ 具有形式
$
(alpha_(1, j_1 - 1), alpha_(1, j_1)]
× ⋯ ×
(alpha_(d, j_d - 1), alpha_(d, j_d)],
\quad 1 ≤ j_i ≤ n_i.
$
不难看出，对于规则细分，有 $lambda(A) = sum_k lambda(B_k)$。（先考虑所有端点都有限的情形，然后取极限即可得到一般情形。）要把该结论推广到一般的有限细分 $A = +_j A_j$，只需进一步细分，使之成为规则细分即可。

(ii) 的证明几乎与定理 1.1.4 中的证明完全相同。为使书写更方便，并突出与定理 1.1.4 的类比，我们对 $x, y ∈ ℝ^d$ 定义
$
(x, y) = (x_1, y_1) × ⋯ × (x_d, y_d),
\quad
(x, y] = (x_1, y_1] × ⋯ × (x_d, y_d],
\quad
[x, y] = [x_1, y_1] × ⋯ × [x_d, y_d].
$

先假设 $-∞ < a < b < ∞$，这里的不等式表示每个分量都是有限的；并设
$
(a, b] ⊂ ⋃_(i ≥ 1) (a^i, b^i],
$
其中（不失一般性）$-∞ < a^i < b^i < ∞$。令 $bar(1) = (1, dots, 1)$，取 $delta > 0$ 使得
$
mu((a - delta bar(1), b]) > mu((a, b]) - epsilon.
$
并取 $eta_i$ 使得
$
mu((a^i, b^i + eta_i bar(1)]) < mu((a^i, b^i]) + epsilon 2^(-i).
$

开矩形 $(a^i, b^i + eta_i bar(1))$ 覆盖 $[a + delta bar(1), b]$，因此存在一个有限子覆盖 $(alpha^j, beta^j)$，$1 ≤ j ≤ J$。由于
$
(a + delta bar(1), b] ⊂ ⋃_(j=1)^J (alpha^j, beta^j],
$
由引理 1.1.10 的 (b) 可得
$
mu([a + delta bar(1), b])
≤ sum_(j=1)^J mu((alpha^j, beta^j])
≤ sum_(i=1)^∞ mu((a^i, b^i + eta_i bar(1)]).
$

因此由 $delta$ 与 $eta_i$ 的选取，
$
mu((a, b]) ≤ 2 epsilon + sum_(i=1)^∞ mu((a^i, b^i]),
$
而由于 $epsilon$ 任意，我们就证明了 $-∞ < a < b < ∞$ 的情形。其余部分与之前完全相同，从而证明完成。∎

*图 1.2* 将一个划分转换为规则划分。

*/
