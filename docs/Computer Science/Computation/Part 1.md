# Part 1: Encoding and Representation

!!! Info "Outline"

    - 如果我们可以将类型为 $T$ 的对象编码成字符串，那么就可以将类型为 $T$ 的元组/列表编码成一个字符串；
    - 如果 $E$ 是类型 $T$ 的 Prefix-Free 编码，那么就可以将类型 $T$ 的元组/列表以直接拼接的方式编码成一个字符串；
    - 我们可以付出 $O(n)$ 的代价任何一个编码变成 Prefix-Free 的编码；
    - $\{0, 1\}^*$ 是可数的，因此我们可以将任何可数集合编码成 $\{0, 1\}^*$ 的字符串，从而可数性和可编码性是等价的；

## String & Encoding

在计算机里，我们存储的所有内容其实都只是存储内容的一种 **表示/Representation** 或者 **编码/Encoding**。一个 Representation Scheme 就是将一个对象 $x$ 映射为一个二进制字符串 $E(x) \in \{0,1\}^*$。比如对自然数的一个 Representation Scheme 就是一个 Encoding Function $E:\mathbb{N} \rightarrow \{0,1\}^*$。我们的编码函数需要满足下面的一个条件，最好可以最大化两个性质：

- 无歧义（必须满足）：编码函数 $E$ 应该是一个**单射**。换句话说，如果两个自然数 $x$ 和 $x'$ 不同，那么它们在 Representation Scheme 下的表示也不同。
- 高效简洁：对被编码内容 $x$ 来讲，编码字符串 $E(x)$ 的长度应该尽可能短。
- 可扩展：如果 $X$ 是可以被 $E$ 编码的集合，那么最好 $X^*$ 也是可以被 $E$ 编码的集合。

## Encoding for Natural/Rational Numbers

对自然数的编码是比较简单的，最经典就是二进制编码，其可以正式定义为下面函数：

$$
\operatorname*{NtS}(n) = \begin{cases}
            0    &  n=0 \\
            1    &  n=1 \\
            \operatorname*{NtS}(\lfloor n/2 \rfloor) \operatorname*{parity}(n) & n>1
\end{cases}
$$

其中 $\operatorname*{parity}(n)$ 为 $1$ 当且仅当 $n$ 为奇数。$\operatorname*{NtS}$ 是一个递归定义的函数，我们也可以非递归地定义它。事实上，在本门课中，如何将自然数编码成二进制字符串并不重要，甚至我们可以将 $n$ 直接编码为长度为 $n$ 的全 $0$ 字符串，我们只需要知道有这样的一个编码就可以。

对于整数来讲，我们或许可以通过补码进行编码，这是在计算机系统课上学到的内容，但是对于一个无限长的 01 字符串来讲，补码编码并不适用，只需要考虑 -1 的补码编码并不唯一就可以。然而，我们可以利用一个单独的前缀符号位表示正负，这就将自然数的编码扩展到了整数：

$$
\operatorname*{ZtS}(m) = \begin{cases}
            0\; \operatorname*{NtS}(m) & m \geq 0  \\
            1\; \operatorname*{NtS}(-m) & m < 0
\end{cases}
$$

这个编码函数显然是一个单射，但是并不是满射，因为 $10$ 字符串没有被编码，但这仍然是一个很好的编码。

对于有理数来讲，我们可以将形如 $a/b$ 的有理数看作 $(a, b)$ 这样一个二元组。最简单的编码方式是直接将 $a$ 和 $b$ 的编码拼接起来，但这样会导致歧义，比如 $10110$ 可以翻译成 $10/110$（$2/6$） 也可以翻译成 $101/10$（$5/2$）。为了解决这个问题，我们可以使用一个分隔符来分隔两个字符的编码，比如使用 $10\|110$ 来表示 $2/6$。换句话说，存在从**一个字符串对** $x, y \in \{0,1\}^*$ 到**一个 $\Sigma = \{0,1,\| \}$ 上的字符串 $z$** 的单射映射 $F$，而代价只是增加一点冗余。算法描述如下：

- 将一个可能为负的有理数 $r$ 看成一个整数的二元组 $(a, b)$，使得 $r = a/b$；
- 将 $a$ 和 $b$ 分别编码为二进制字符串 $x$ 和 $y$；
- 使用分隔符，这个有理数可以被编码为 $\{0,1,\| \}$ 上的字符串 $z$，即 $z = x\|y$；
- 将 $\Sigma = \{0,1,\| \}$ 上的字符串 $z$ 编码为 $\{0,1\}^*$ 上的字符串 $w$。

比如我们编码 $-1/2$，$-1$ 被编码为 $11$，$2$ 被编码为 $010$，$\Sigma$ 上的编码为 $11\|010$，使用映射 $0\mapsto 00$，$1\mapsto 11$，$|\mapsto 01$，我们就将这个有理数编码为 $111101001100$。

这个例子背后的思想是：**如果我们可以将类型为 $T$ 的对象编码成字符串，那么就可以将类型为 $T$ 的元组/列表编码成一个字符串**，进而还可以编码这类对象的列表的列表，子子孙孙无穷匮也。

## Prefix-Free Encoding

我们发现一件事情，在上面的例子之中，无法直接将编码得到的字符串拼接起来的原因实际是：字符串 $a$ 实际上是另一个字符 $a'$ 的编码字符串的前缀，而拼接起来的字符串的相对于 $a'$ 的剩下部分是另一个字符 $b'$ 的编码字符串。如果我们完全杜绝这件事情，那么或许就可以直接将编码得到的字符串拼接起来，形成对元组的简单编码。刚才的例子实际上就是这种 Prefix-Free 思想的一个例子，如果我们在每一个整数的编码后面加入一个终止符，代表对这个数字的编码已经结束，那么这样每一个数字的编码就永远不会成为另一个数字的前缀，就杜绝了前缀带来的歧义。

在这一节，我们将证明下面结论：如果 $T$ 类型的对象存在一个 Prefix-Free 的编码，那么就可以通过链接编码的方式将 $T^*$ 类型的对象进行编码。

!!! Info "Prefix-Free Encoding"
    对于两个字符串 $y, y'$，如果 $y$ 的长度小于 $y'$ 的长度，即 $\lvert y \rvert \leq \lvert y' \rvert$，且对于每一个 $i < \lvert y \rvert$，都有 $y'_i = y_i$，那么我们就称 $y$ 是 $y'$ 的一个前缀。

    设 $\mathcal{O}$ 是一个非空集合，$E:\mathcal{O} \rightarrow \{0,1\}^*$ 是一个函数，如果对于每一个 $o \in \mathcal{O}$，都有 $E(o)$ 非空，且不存在两个不同的对象 $o, o' \in \mathcal{O}$，使得 $E(o)$ 是 $E(o')$ 的一个前缀，那么我们就称 $E$ 是 **Prefix-Free** 的编码（显然 Prefix-Free 性质可以推出单射性质）。

有些编码先天就是 Prefix-Free 的，比如固定长度的编码，因为对于一个字符串 $x$，它只能是一个长度相等的字符串 $x'$ 的前缀，如果 $x$ 和 $x'$ 不相同，那么它们就一定不相同。

对于每一个集合 $\mathcal{O}$，$\mathcal{O}^*$ 表示所有 $\mathcal{O}$ 内的元素构成的有限长的元组/列表。下面定理表明：**如果 $E$ 是 $\mathcal{O}$ 的 Prefix-Free 编码，那么就可以通过链接编码的方式得到的一个 $\mathcal{O}^*$ 的有效编码**。

!!! Danger "Theorem: Prefix-Free Implies Tuple Encoding"
    设 $E:\mathcal{O} \rightarrow \{0,1\}^*$ 是 $\mathcal{O}$ 的 Prefix-Free 编码，对于每一个 $(o_0,\ldots,o_{k-1}) \in \mathcal{O}^*$，我们定义
    
    $$
    \overline{E}(o_0,\ldots,o_{k-1}) = E(o_0)E(o_1) \cdots E(o_{k-1}) \;.
    $$

    这个映射 $\overline{E}:\mathcal{O}^* \rightarrow \{0,1\}^*$ 是一个单射，因此是 $\mathcal{O}^*$ 的有效编码。

**Proof：**
使用反证法：假设存在两个不同的元组 $(o_0,\ldots,o_{k-1})$ 和 $(o'_0,\ldots,o'_{k'-1})$，使得

$$
\overline{E}(o_0,\ldots,o_{k-1}) = \overline{E}(o'_0,\ldots,o'_{k'-1}) = \overline{x}.
$$

令 $i$ 为第一个使得 $o_i \neq o'_i$ 的索引。如果这样的索引不存在，这意味着对于所有的 $i$，都有 $o_i = o'_i$，由于我们假设这两个元组是不同的，那么这两个元组的长度必然不相同，因此我们假设 $k' > k$。因此这样的索引不存在的原因就必然是一个元组消耗掉了所有的所有的字符，这种情况下就有

$$\begin{aligned}   
\overline{x} &= E(o_0) \cdots E(o_{k-1}) \\
&= E(o'_0) \cdots E(o'_{k-1}) E(o'_k) \cdots E(o'_{k'-1}) \\
&= E(o_0) \cdots E(o_{k-1}) E(o'_k) \cdots E(o'_{k'-1})
\end{aligned}
$$

这就意味着 $E(o'_k) \cdots E(o'_{k'-1})$ 就一定是空字符串，这与 $E$ 是 Prefix-Free 编码矛盾。因此我们假设不成立，即 $\overline{E}$ 是单射。

这就到了索引 $i$ 存在的情况，对于所有 $j < i$，都有 $o_j = o'_j$，因此就有

$$
\overline{x} = x_1 \cdots x_{i-1} E(o_i) \cdots E(o_{k-1}) = x_1 \cdots x_{i-1} E(o'_i) E(o'_{i+1}) \cdots E(o'_{k'-1})
$$

这就意味着将 $x_1 \cdots x_{i-1}$ 从 $\overline{x}$ 中去掉之后，剩下的字符串 $\overline{y}$ 可以被写成两种不同的形式，只考察 $\overline{y}$ 的第一个字符，首先一定 $E(o_i) \neq E(o'_i)$，因此这两个字符串一定只是在长度上不相同，无论这两个哪一个长哪一个短，短的那个就一定是长的那个的前缀，这就和 $E$ 是 Prefix-Free 编码矛盾。因此我们假设不成立，即 $\overline{E}$ 是单射。证明完毕。

我们已经看到，一个 $S$ 上的 Prefix-Free 的编码可以将编码扩展为 $S^*$ 上的有效编码，但是这个 $S^*$ 上的编码并不是 Prefix-Free 的，很容易证明这一点。但是 Prefix-Free 性质又十分强大，因此我们需要考虑如何将任何一个编码变成 Prefix-Free 的编码。其想法和我们对有理数的编码基本一样，可以通过添加一个终止符来解决。

下面引理表明，**我们可以付出 $O(n)$ 的代价任何一个编码变成 Prefix-Free 的编码**。

!!! Info "Lemma: Prefix-Free Transformation"
    设 $E:\mathcal{O} \rightarrow \{0,1\}^*$ 是一个编码函数，那么存在一个 Prefix-Free 的编码 $\overline{E}:\mathcal{O} \rightarrow \{0,1\}^*$，使得对于每一个 $o \in \mathcal{O}$，都有 $|\overline{E}(o)| \leq 2|E(o)|+2$。

**Proof**：
想法是对原来的字母表扩充一个终止符，可以得到字母表 $\Sigma = \{0,1,\| \}$，对字母表 $\Sigma$ 进行 0-1 编码，每一个字符需要两位：$0 \mapsto 00$，$1 \mapsto 11$，$|\mapsto 01$。这就是我们的方法。对于原来的字符串编码，使用该映射将原字符串 $x$ 内的每一个位翻倍，然后通过在后面链接一个 $01$ 来表示终止。这就可以确保 $x$ 的编码永远不会是不同字符串 $x'$ 的编码的前缀。形式化地，我们定义函数 $PF:\{0,1\}^* \rightarrow \{0,1\}^*$ 为

$$
PF(x) = x_0 x_0 x_1 x_1 \cdots x_{n-1} x_{n-1} 01
$$

对于每一个 $x \in \{0,1\}^*$，如果 $E:\mathcal{O} \rightarrow \{0,1\}^*$ 是 $\mathcal{O}$ 的编码，那么我们定义 $\overline{E}:\mathcal{O} \rightarrow \{0,1\}^*$ 为 $\overline{E}(o) = PF(E(o))$。

我们需要证明 $\overline{E}$ 是一个 Prefix-Free 的编码，由我在 Prefix-Free 编码的定义的评述，这就只需要证明 $\overline{E}$ 是 Prefix-Free 的即可。设 $o \neq o'$ 是 $\mathcal{O}$ 中的两个不同的对象，我们证明 $\overline{E}(o)$ 不是 $\overline{E}(o')$ 的前缀。令 $x = E(o)$ 和 $x' = E(o')$，由于 $E$ 是单射，因此 $x \neq x'$，我们只需要证明 $PF(x)$ 不是 $PF(x')$ 的前缀。我们分三种情况讨论：

1. 如果 $|x| < |x'|$，那么 $PF(x)$ 的第 $2|x| + 1$ 位和 $2|x| + 2$ 位是 $01$，而 $PF(x')$ 的第 $2|x| + 1$ 位和 $2|x| + 2$ 位是 $00$ 或 $11$，因此 $PF(x)$ 不是 $PF(x')$ 的前缀。
2. 如果 $|x| = |x'|$，令 $i$ 为第一个使得 $x_i \neq x'_i$ 的索引，那么 $PF(x)$ 和 $PF(x')$ 的第 $2i + 1$ 位和 $2i + 2$ 位是不同的，因此 $PF(x)$ 不是 $PF(x')$ 的前缀。
3. 如果 $|x| > |x'|$，那么显然 $|PF(x)| > |PF(x')|$，因此 $PF(x)$ 不是 $PF(x')$ 的前缀。

这就证明了 $\overline{E}$ 是一个 Prefix-Free 的编码。证明完毕。

这就可以得到本节最重要的结论：**如果我们可以对 $A$ 进行编码，那么就可以对 $A^*$ 进行编码**。重要性不言而喻，比如我们可以对自然数做编码，就可以对自然数的向量做编码，然后可以对矩阵做编码......

## Countable and Encodable

首先，关于可数性，下面几条等价：

- 集合 $A$ 是可数的；
- $A$ 是有限集或者存在一个 $A$ 和 $\mathbb{N}$ 之间的一一对应；
- 存在一个从 $A$ 到 $\mathbb{N}$ 的单射（这说明 $\operatorname*{card}(\mathbb{N}) \geq \operatorname*{card}(A)$）；
- 存在一个从 $\mathbb{N}$ 到 $A$ 的满射（这说明 $\operatorname*{card}(A) \leq \operatorname*{card}(\mathbb{N})$）。

接下来我们考虑编码得到的字符串集合是否是可数的，因而有下面引理：

!!! Info "Lemma: The Countability of Encoded Strings"
    $\{0, 1\}^*$ 是可数的。

**Proof**：
这里给出一个构造形式的证明：我们将 $\{0, 1\}^*$ 中的字符串按照长度从小到大排序，看作 ${0, 1} \cup \{0, 1\}^2 \cup \{0, 1\}^3 \cup \cdots$ 的形式，那么对于任意的 $x \in \{0, 1\}^*$，我们定义一个函数

$$
f(x) = \begin{cases}
    0 & x = \varepsilon \\
    2^{|x|} + \operatorname*{StN}(x) & \lvert x \rvert > 0
\end{cases}
$$

其中 $\operatorname*{StN}(x)$ 表示二进制表示 $x$ 的十进制数字。这个函数是一个 $\{0, 1\}^*$ 到 $\mathbb{N}$ 的单射，因此 $\{0, 1\}^*$ 是可数的。证明完毕。

这个定理意味着：**存在一个 $\{0, 1\}^*$ 和 $\mathbb{N}$ 之间的一一对应**。进而我们可以得到**可数和可编码的等价性**：

!!! Info "Theorem: Countable and Encodable"
    $A$ 是可数的当且仅当存在一个单射 $E:A \rightarrow \{0, 1\}^*$。

**Proof**：
集合 $A$ 可数 $\Leftrightarrow$ 存在一个单射 $E:A \rightarrow \mathbb{N}$ $\Leftrightarrow$ 存在一个单射 $E:A \rightarrow \{0, 1\}^*$，第二个等价是从 $\{0, 1\}^*$ 到 $\mathbb{N}$ 是一一对应的可以得出的。

在计算机中，由于我们需要将研究的对象都进行编码，所以我们研究的问题的输入和输出都应该是编码后的对象，也就是 $\{0, 1\}^*$ 的字符串。于是我们需要研究的函数就是 $\{0, 1\}^* \rightarrow \{0, 1\}^*$ 的函数。任何不可编码的对象都不是我们的研究对象，比如实数就不可数，因此不可编码，所以我们考虑的问题和实数没啥关系。

在后面我们将要讨论具体的、计算 $\{0, 1\}^* \rightarrow \{0, 1\}^*$ 的函数的计算模型。
