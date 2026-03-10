# Algorithms II

## 六、NP-Completeness

!!! Info "参考"

    - wyy 的 ADS 讲义；
    - [Lawrence 大学的相关讲义](https://www2.lawrence.edu/fast/GREGGJ/CMSC515/chapt07/NPC.html)。

### 1. 形式语言

为了形式化定义问题与计算模型，我们首先给出某种编码，这就是形式语言干的事情。

- **字母表/Alphabet**：一个**至多可数**的集合 $\Sigma$；
- **字符串/String**：某个字母表上有限个元素的有序连接，所有这样的字符串记作 $\Sigma^*$，注意到 $\Sigma^*$ 其实是一个可数的集合；
- **形式语言/Formal Language**：某个字母表 $\Sigma$ 上所有的字符串 $\Sigma^*$ 的一个子集 $L$。

!!! Info "和 PPT 的不同"
    这部分是按照 wyy 的讲义写的，而 PPT 对字母表的定义是一个**有限**的集合，这里是一个**至多可数**的集合。这样的定义在我们的语境下没有什么影响，而且至多可数和后面讨论的逻辑系统可以联系起来。

形式语言可以做衔接/Concatenation、并/Union、交/Intersection、补/Complement、闭包/Kleene star 等运算，同时补充定义空串 $\varepsilon$，空语言 $\varnothing$，则这些运算的定义如下：

- 交和并运算：$L_1 \cap L_2 = \{ x : x \in L_1 \text{ and } x \in L_2 \}$，$L_1 \cup L_2 = \{ x : x \in L_1 \text{ or } x \in L_2 \}$；
- 补运算：$\overline{L} = \Sigma^* - L = \{ x : x \in \Sigma^* \text{ and } x \notin L \}$；
- 衔接运算：$L = \{ x_1x_2 : x_1 \in L_1 \text{ and } x_2 \in L_2 \}$；
- 幂运算（基于衔接运算）：$L^k = \{ x_1x_2 \cdots x_k : x_i \in L \}$；
- Kleene 星运算：$L^* = \{ \varepsilon \} \cup L \cup L^2 \cup L^3 \cup \cdots$。

我们主要处理三种问题：

- 给定语言 $L$，判断某个字符串 $\omega$ 是否在 $L$ 中，这被称为判定问题/decision problem；
- 给定语言 $L$，寻找某个字符串 $\omega$ 使得 $\omega$ 在 $L$ 中，这被称为搜索问题/search problem；
- 给定语言 $L_1, L_2$，计算某个从 $L_1$ 到 $L_2$ 的函数。

我们给出一个将自然语言下的问题转化成形式语言的判定问题的例子，显然，能够翻译的问题只有那些答案是“是”或者“否”的问题。我们考虑哈密顿回路问题：给定一个图，判断其是否有 Hamilton 回路。

首先，我们注意到所有图构成的集合是可数的：显然图的顶点数目有限，固定顶点数目的图的数量有限，可数个有限集的并集是可数集，所以所有图构成的集合是可数集。

其次，我们构造一个字母表 $\Sigma$，使得 $\Sigma^*$ 包含所有图而不包含其他东西。由于所有图是可数的，我们建立一个图和自然数的编号，进而只需要考虑自然数和 $\Sigma^*$ 的映射问题。我们直接令 $\Sigma = \{1\}$，这样字符串由几个 1 组成就意味着它是编号为几的图。于是我们的形式语言 $L$ 就定义为所有有 Hamilton 回路的图对应的字符串构成的集合。令**谓词/Predicate** $Q(x)$ 表示“$x$ 是一个有 Hamilton 回路的图”，则我们的判定问题就是给定一个字符串 $x$，判断其是否在 $L$ 中。这样的形式语言就可以写成

$$
L = \{x \in \Sigma^* : Q(x)\}
$$

从 PPT 上的另一个例子看形式语言，我们定义抽象问题/Abstract Problem $Q$ 为问题实例的集合 $I$ 和问题解 $S$ 的二元关系，又由于所有像最短路问题的这种最优化问题都可以在多项式时间内转化成判定问题，所以我们只需要考虑判定问题，因此判定路径问题就转变成了：

- 实例为 $I = \{\langle G, u, v, k\rangle : G = (V, E) \text{ is an undirected graph, } u, v \in V, k \in \mathbb{N}\}$；
- 解为 $S = \{0, 1\}$；
- 对所有实例 $i \in I$，$\mathrm{PATH}(i) = 1 \text{ or } 0$。

我们将实例映射成字母表为 $\Sigma = \{0, 1\}$ 的字符串。

对于算法 $A$ 和形式语言的关系，我们有下面的内容：

- 对于一个字符串 $x\in \Sigma^*$，如果 $A(x) = 1$，就称 $A$ **接受**这个字符串 $x$；
- 如果对于一个字符串 $x$，$A(x) = 0$，就称 $A$ **拒绝**这个字符串 $x$；
- 如果每一个形式语言 $L$ 的字符串 $x$ 都可以被 $A$ 接受并且不在形式语言 $L$ 内的字符串都被 $A$ 拒绝，就称形式语言 $L$ 被算法 $A$ 判定；

有了问题实例到字符串的映射关系，我们就可以提前定义后来的 $\mathsf{P}$ 问题：

$$
\mathsf{P} = \{ L \subseteq \Sigma^* : \text{there exists a polynomial-time algorithm } A \text{ that decides } L \}.
$$

我们在之后会更形式化定义这些复杂度类，尤其是需要引入核心的图灵机模型。

### 2. 计算模型

**确定性图灵机**：考虑一个**双向无限**的磁带/Tape，将磁带划分成一个一个的方格/Cell，有一个磁头/Head，磁头中有一个有限状态机，其中包含有限个状态 $q \in Q$。每个方格要么是空的/$\square$，要么就写有某个有限的字符集 $S$ 的字符。在每一步操作中，它可以完成：

- 磁头内部状态的转变；
- 把扫描到的符号 $s$ 改写成 $s' \in S \cup \{\square\}$；
- 往左/L 或往右/R 移动磁头。

每一步的改变都是由一个**偏函数** $\delta : Q \times (S \cup \{\square\}) \to Q \times (S \cup \{\square\}) \times \{L, R\}$ 决定的，我们将这个偏函数称为**图灵程序/Turing program**。

每一个计算开始之前，我们都将磁头置于起始方格/Starting Cell，它是写有内容的最左侧方格，并让其处于起始状态/Starting State，然后将输入的所有内容放在起始方格右侧，并保证纸带其余部分为空。如果磁头抵达状态 $q_h \in Q$，称作停机状态/Halting State，则视作计算结束，并将磁带上从起始方格开始的内容视作输出。我们将图灵机的构型/Configuration 记作

$$
c = t_m t_{m-1} \cdots t_2 t_1 \underline{q_i} s_1 s_2 \cdots s_k
$$

其中 $s_i$ 和 $t_i$ 分别是一直到最右侧/最左侧的非空格子上的内容，$q_i$ 为当前磁头所处的状态，当前磁头指向 $s_1$ 所在的方格。如果磁头进入状态 $q \neq q_h$ 而 $\delta$ 未定义（不移动），则称计算中断，不将其视作停机。

所谓的**图灵计算/Turing Computation** 就指图灵机的一列构型 $c_0, c_1, \cdots, c_n$，它按照如上的叙述由一个图灵程序所描述。

**接受与拒绝**：在判定问题中，图灵机最终需要告诉我们是或者否。实际上图灵机最终会在磁带上留下一个 1 或者 0 代表是或者否，在有些图灵机的定义中，我们会规定写下 1 代表一个 $q_{\text{accept}}$ 状态表示接受，写下 0 代表一个 $q_{\text{reject}}$ 状态表示拒绝，实际上如果我们在进入接受和拒绝状态后再加一个转移函数到停机状态 $q_h$，就和我们的定义相容了。

**非确定性图灵机**：确定性图灵机和非确定性图灵机的唯一区别就在于偏函数。确定性图灵机的值域为 $Q \times (S \cup \{\square\}) \times \{L, R\}$，而非确定性图灵机的值域为其幂集 $\mathcal{P}(Q \times (S \cup \{\square\}) \times \{L, R\})$，也就是说，非确定性图灵机在每一步都有多种选择，而确定性图灵机只有一种选择。如果一条路径使得非确定性图灵机停机，那称非确定性图灵机会停机。在判定性问题中，**只要**有一条路径接受，整个图灵机就接受，只有所有路径都拒绝，整个图灵机才拒绝。换句话说，如果有一种路径可以让非确定型图灵机得到一个解，那么非确定性图灵机就一定会选择这个解。

!!! Note "注意"

    但是！非确定性图灵机**并不是下一步随机选择一个解**，更像是一个搜索算法。

**定理**：任何一个非确定性图灵机都可以被一个确定性图灵机模拟，也就是**这两类图灵机可以计算的函数是一致的**。

!!! Info "证明"
    为了实现模拟，我们的想法是：因为非确定性图灵机执行时每一步都会产生多种选择，因此所有路径会生成一棵树，确定性图灵机只需要 BFS 搜索这棵树就可以。

    使用一个三条纸带的图灵机模拟：第一条纸带放输入，第二条纸带模拟图灵机读到输入时候的状态和行动，第三条纸带记录 BFS 的进程，提示第二条纸带下一步该模拟哪条路径。只需要证明三条纸带的图灵机和一条纸带的图灵机是等价的，这一点其实是显然的，最简单的方法就是将纸带分成三个部分即可。

在知道这个结论之后，我们还需要意识到确定性图灵机模拟非确定性图灵机的时间复杂度是指数级别的，因为我们需要搜索所有的路径。

**猜想**（Church-Turing 论题）：存在一个现实可行的计算某个函数的方式当且仅当存在一个图灵机计算这个函数。

这个猜想的意义在于，**每一个算法都可以由一个图灵机实现**。其推广模式是现实可行的计算计算系统都可以被图灵机高效地模拟。这样我们发现，我们将两个最重要的问题给抽象化/形式化了：一个是计算问题，一个是计算模型，我们将计算问题转化成了形式语言，将计算模型/算法转化成了图灵机。

于是我们进行最后的形式化：一个形式语言 $L \subset \Sigma^*$ 可以被一个图灵机 $M$ 判定/Decide 当且仅当这个图灵机可以确定任何一个输入字符串 $\omega \in \Sigma^*$ 是否属于形式语言 $L$，其中**确定**的定义为图灵机可以停机并且接受或者拒绝这个字符串。

后面会出现一些形式语言和问题两个几乎一致的东西的混用，我们知道这两个东西的混用本质上是在说一件事就好。

有了计算模型之后，我们可以定义复杂度类了。我们考虑一族函数 $f(n)$，称一个问题是：

- $\mathsf{DTIME}(f(n))$ 的，如果求解规模为 $n$ 的问题的确定性图灵机能在 $f(n)$ 步之内停机；
- $\mathsf{NTIME}(f(n))$ 的，如果求解规模为 $n$ 的问题的非确定性图灵机能在 $f(n)$ 步之内停机。

其中一个形式语言的判定问题指的是输入的长度。有一个加速定理很有意义：

**定理**：如果 $f$ 可以被图灵机 $M$ 在 $T(n)$ 时间内计算，那么对于任意常数 $c \geq 1$，都有一个图灵机 $\overline{M}$ 能够在 $T(n)/c$ 的时间内完成同样的计算。

**证明梗概**：我们只证明 $c = 2$ 的情况，其余情况类似。我们将图灵机的磁头中的有限状态机的两步状态转移合并成一步转移，这样的话我们的字母表也需要同步拓宽，即将原先的字符（包括 $\square$）两两组合。显然我们的计算时间减半。

这个加速定理告诉我们，我们可以将一个图灵机的计算时间缩短任意的常数倍，但是并不能将一个 $O(n^2)$ 复杂度的算法变成 $O(n)$ 复杂度的算法——即便我们可以加速任意常数倍，但是我们不能改变算法复杂度的阶，而加速常数背的算法在这个定理下是毫无意义的。

除此之外，我们可以定义复杂度类了，后面的总结只不过是这个定义的自然语言阐述。

- $\mathsf{P} = \bigcup_{k \geq 1} \mathsf{DTIME}(n^k)$；
- $\mathsf{NP} = \bigcup_{k \geq 1} \mathsf{NTIME}(n^k)$；
- $\mathsf{EXP} = \bigcup_{k \geq 1} \mathsf{DTIME}(2^{nk})$；
- $\mathsf{NEXP} = \bigcup_{k \geq 1} \mathsf{NTIME}(2^{nk})$。

很简单就可以理解这里的定义，$\mathsf{P}$ 就是确定性图灵机能在多项式时间内停机解决的问题，其余类似。另一个平凡的性质是 $\mathsf{NP} \subset \mathsf{EXP}$，因为确定性图灵机模拟非确定性图灵机的开销是指数级别的。下面有一个关于 $\mathsf{NP}$ 类的等价定义。但是首先回忆一个语言是 $\mathsf{NP}$ 的定义：一个非确定性图灵机可以在多项式时间停机并且选择接受或者拒绝这个语言的任何一个字符串。

**定理**：一个语言 $L$ 是 $\mathsf{NP}$ 的当且仅当存在多项式 $p$ 和一个多项式时间的确定性图灵机 $M$，使得对于任意 $x$ 都有

$$
x \in L \Leftrightarrow \exists u \in \{0, 1\}^{p(|x|)}, \text{ s.t. } M(x, u) = 1
$$

其中 $u$ 被称为 $x$ 关于语言 $L$ 的证明/Certificate。所以上式的含义为 $x$ 在 $L$ 中当且仅当存在一个多项式长度的证明使得 $M$ 在多项式时间内接受。其实也就是使用一个确定性图灵机验证了这个解。

**证明梗概**：如果 $L$ 是 $\mathsf{NP}$ 的，那么给出一个非确定性图灵机的选择序列即可作为证明，并且这个序列长度一定是多项式规模的，因为非确定型图灵机在多项式时间内最多完成多项式次分支。而验证只需要一个确定性图灵机在这样的选择序列下执行就可以。如果存在这样的一个证明能被非确定性图灵机接受，那么非确定性图灵机只要不断分支，一定能在多项式时间内分支多项式次，进而凑出这样的一个证明。

最后，仍然需要注意我们引入指数复杂度类不是没有原因的：因为如果 $\mathsf{EXP} \neq \mathsf{NEXP}$，那么 $\mathsf{P} \neq \mathsf{NP}$。

再举一个密码学的例子，我们知道现在的 RSA 密码是基于大合数进行质因数分解的困难性的。所以我们定义语言 


$$
L = \{(m, r) : \exists s < r, s | m\}
$$

这个语言是 $\mathsf{NP}$ 的，这使用确定性图灵机多项式时间内验证就可以很轻松看出来，因为问题的输入是 $m$ 和 $r$，输入的规模就是 $\log_2 m + \log_2 r = \log_2mr$，证明的规模是 $O(\log_2s) = O(\log_2r)$ 的，然后我们就可以在多项式时间内验证这个证明。非确定性图灵机只需要第一次分支到 $s$ 就可以。

还可以通过形式语言的补运算来定义 co-$\mathsf{NP}$ 类：

**定义**：设 $C$ 是一个复杂度类，则 co-$C$ 称为它的补类/Complement Class，其中的语言定义为

$$
\text{co-}\mathsf{C} = \{L : \overline{L} \in \mathsf{C}\}
$$

注意到 co-$\mathsf{C}$ 并不意味着在所有问题意义上的补，而是其中所有语言的补。考虑一下一个语言的补代表什么：还是使用原来哈密顿回路的例子，我们让这个形式语言是所有有哈密顿回路的图，那么这个形式语言的补就是所有没有哈密顿回路的图，这个补类 $\mathcal{L}$ 就是 co-$\mathsf{NP}$。因为我们确实多项式时间内可以确定一个图是有哈密顿回路的（这也就是验证 $\omega \in \overline{\mathcal{L}}$），但是确实难以验证一个图没有哈密顿回路。

**定理**：$\mathsf{P} = \text{co-}\mathsf{P}$。证明显然，只需要将这个图灵机的接受和拒绝、属于和不属于调换就可以。

**定理**：一个语言是 co-$\mathsf{NP}$ 的当且仅当存在多项式 $p$ 和一个多项式时间的确定性图灵机 $M$，使得对于任意 $x$ 都有

$$
x \in L \Leftrightarrow \forall u \in \{0, 1\}^{p(|x|)}, \text{ s.t. } M(x, u) = 0
$$

这里将存在换成了对于任意，这从非确定图灵机的接受和拒绝定义就可以看出来，本定理本质是高中的谓词运算。

实际上 $\mathsf{P} \subset \mathsf{NP} \cap \text{co-}\mathsf{NP}$，进一步的，我们有 $\mathsf{P} = \mathsf{NP} \Rightarrow \mathsf{NP} = \text{co-}\mathsf{NP}$。

### 3. Karp 归约

**定义**：如果一个语言 $A$ 可以被多项式地规约到 $B$，如果存在一个可以在多项式时间内计算的函数 $f$ 使得

$$
x\in A \Leftrightarrow f(x) \in B
$$

记作 $A \leq_p B$。这也就是说，当我们使用解决问题 $B$ 的方法解决问题 $A$ 的时候，可以在多项式时间内完成问题的转化，并且保证问题的解是正确的。显然，规约关系是自反的和传递的。

**定义**：考了复杂度类 $\mathsf{C}$，如果问题 $P$ 满足 $\forall C \in \mathsf{C}, C \leq_p P$，则称 $P$ 是 $\mathsf{C}$-难的（$\mathsf{C}$-hard）；如果同时 $P \in \mathsf{C}$，则称 $P$ 是 $\mathsf{C}$-完全的（$\mathsf{C}$-complete）。

这也就是说，如果问题 $P$ 是 $\mathsf{C}$-难的，那么所有的 $\mathsf{C}$ 问题都可以在多项式时间内规约到问题 $P$，而 $\mathsf{C}$-完全的问题是 $\mathsf{C}$-难的问题中属于 $\mathsf{C}$ 的问题。

### 4. 总结

回忆本讲的核心概念：

- **可判定问题/Decidable Problem**：对于任意输入，确定性图灵机都会停机并且得到正确输出；换句话说，存在一个算法，可以在有限时间内给出正确的输出；
- **不可判定问题/Undecidable Problem**：对于某些输入，确定性图灵机会进入无限循环；换句话说，不存在一个算法，可以在有限时间内给出正确的输出。

典型的不可判定问题是停机问题/Halting Problem。提前说明，**不是所有的可判定问题都是 $\mathsf{NP}$ 的**，比如可以在多项式时间内判定一个图**没有**哈密顿环，但是我们很难在多项式时间内验证解的正确性，因为要验证的话就需要得到哈密顿环的一个解，但是[找到哈密顿环的解是一个 $\mathsf{NP}$ 完全问题](https://en.wikipedia.org/wiki/Hamiltonian_path_problem)。

- **P 问题**：由多项式时间算法可以解决的问题，也就是确定性图灵机可以在多项式时间内解决的问题；
- **NP 问题/Non-deterministic Polytime Problem**：非确定型图灵机在多项式时间内解决的问题，或者确定型图灵机在多项式时间内验证的问题，显然 $\mathsf{P}$ 问题是 $\mathsf{NP}$ 问题的子集。
- **NP 难问题/NP Hard Problem**：可以被任何 $\mathsf{NP}$ 中多项式时间规约到的问题，注意到**不一定是 $\mathsf{NP}$ 问题**；
- **NP 完全问题/NP Complete Problem**：$\mathsf{NP}$ 中的、可以被任何 $\mathsf{NP}$ 问题多项式规约到的问题；

$\mathsf{P}$ 问题显然是可判定问题；一些非 $\mathsf{P}$ 的问题，比如指数时间复杂度的问题也是可判定问题；所有的 $\mathsf{NP}$ 问题也是可判定问题：首先我们可以使用非确定性图灵机解决这些问题，然后可以使用确定性图灵机模拟非确定性图灵机，因此 $\mathsf{NP}$ 问题是可判定问题，值得额外注意的是，使用确定性图灵机模拟非确定性图灵机的过程最差需要指数级别的代价，所以 $\mathsf{NP}$ 问题不仅仅是可判定的，而且还是可以指数时间判定的问题。这其实就蕴含了不是所有的可判定问题都是 $\mathsf{NP}$ 的这件事。不可判定问题就和 $\mathsf{NP}$ 问题无关了。而 co-$\mathsf{NP}$ 问题是 $\mathsf{NP}$ 问题的补问题，对于一个问题的否答案，确定性图灵机可以在多项式时间内验证。这表明我们验证一个相反的解是很容易的。

### 5. 经典例子

一个经典的多项式时间规约的例子是将**哈密顿圈问题规约到旅行商问题**。哈密顿圈问题是给定一个图，判断其是否有哈密顿圈/经过所有节点的简单环，而旅行商问题是给定一个**加权完全**图和一个整数 $k$，判断其是否有长度不超过 $k$ 的哈密顿圈。这两个问题（HCP 和 TSP）都是经典的 $\mathsf{NP}$ 完全问题。

两个问题的差别几乎是对称的，哈密顿圈问题给定的图不一定是完全图，并且没有加权，而旅行商问题给定的图是完全图并且有加权。我们将待判断 HCP 的图取出来，将现有的边权全部设为 1，然后将其补成完全图，后补充的边权重设为 2。所以如果原图有哈密顿圈，那么新图有长度不超过 $n$ 的哈密顿圈，直接将 $k$ 设为 $n$ 即可。这就完成了规约。

第一个被证明是 $\mathsf{NP}$ 完全问题的问题是 3-SAT 问题，背后其实是 Satisfiability 问题/Circuit-SAT 问题：给定一个布尔表达式，判断其是否有令结果为 1 的解。这个问题是 Cook 在 1971 年证明是 $\mathsf{NP}$ 完全问题的，证明的方法是在非确定图灵机上解决了这个问题。寒假有时间再补充一下这个证明。

!!! Info "坑点"
    **判断**：If a problem can be solved by dynamic programming, it must be solved in polynomial time.

    **答案**：错误，比如最经典的 0-1 背包问题，其动态规划解法的时间复杂度为 $O(nC)$，其中 $n$ 为物品数量，$C$ 为背包容量，因此 0-1 背包问题是**伪多项式时间复杂度**的。回忆一下我们对时间复杂度的确切定义，我们考虑的是输入的**规模**而不是输入的**数值**，而我们输入的背包容量的规模实际上是其在内存中占用的位数 $N = \log_2 C$，因此 0-1 背包问题的时间复杂度实际上是 $O(n2^N)$，这是一个指数时间复杂度的问题。

另一个是将团问题/Clique Problem 规约到顶点覆盖问题：

- 团问题：给定无向图 $G=(V,E)$ 和整数 $K$，$G$ 是否存在一个（至少）包含 $K$ 个顶点的完全子图（团）；
- 顶点覆盖问题：给定无向图 $G=(V,E)$ 和整数 $K$，$G$ 是否存在一个顶点子集 $V'\subseteq V$，使得 $\lvert V'\rvert \leq K$ 且 $G$ 中的每条边上至少有一个顶点被包含在 $V'$ 中（顶点覆盖）。

我们这样描述问题：

$$\begin{aligned}
\text{CLIQUE} &= \{\langle G, K\rangle \colon\ G \text{ is a graph with a clique of size }K\} \\
\text{VERTEX-COVER} &= \{\langle G, K\rangle \colon\ G \text{ has a vertex cover of size }K\}
\end{aligned}$$

我们证明两件事：

1. 顶点覆盖问题是 $\mathsf{NP}$ 的，对于一个 Certificate $V'$，下面给出检查算法：
    - 检查是否满足 $\lvert V'\rvert = K$；
    - 检查是否 $\forall \text{edge } (u, v)$，使得 $u\in V'$ 或 $v\in V'$；
    - 计算时间复杂度：$O(N^3)$（遍历所有边（$N^2$）$\times$ 每条边至少检验其中一点是否在 $V'$ 内（$N$））；
2. 规约：证明 $G$ 有一个大小为 $K$ 的团的充要条件为 $\overline{G}$ 有一个大小为 $\lvert V\rvert - K$ 的顶点覆盖：
    
<!-- 

    - $\text{CLIQUE} \le_P \text{VERTEX-COVER}$，即证$G$有一个大小为$K$的**团**的充要条件为$\overline{G}$有一个大小为$|V| - K$的**顶点覆盖**
        - 充分性：
            - 令$(u, v)$为$\overline{E}$上的任意一边，可以得到以下结论
            - $u, v$中至少有一点不属于$V'$，且至少有一点属于$V - V'$
            - 每条在$\overline{G}$内的边，它的一个顶点在$V - V'$内
            - 因此大小为$|V| - K$的集合$V - V'$构成了$\overline{G}$的一个顶点覆盖
        - 必要性：
            - $\forall u, v \in V$，如果$(u, v) \notin E$，那么$u \in V'$或$v \in V'$，或两者皆满足
            - $\forall u, v \in V$，如果$u \notin V'$且$v \notin V'$，则$(u, v) \in E$
            - 所以$V - V'$是一个大小为$|V| - |V'| = K$的团 -->

## 七、Approximation Algorithm

!!! Note "注意"

    - 除非 $\mathsf{P} = \mathsf{NP}$，否则对于任意的 $k\geq 1$，旅行商问题不存在多项式时间的 $k$ 近似算法，将哈密顿回路问题规约到旅行商问题的 $k$ 近似问题就可以。
    - 同时注意，这样的构造是不满足三角不等式的，如果满足三角不等式，就可以通过最小生成图和深度优先搜索得到哈密顿回路，这样就得到 $2$ 近似算法了。
    - 对于 $k$-聚类问题，除非 $\mathsf{P} = \mathsf{NP}$，否则不存在多项式时间的近似比小于 $2$ 的近似算法。

### 1. 基本概念

**绝对近似比**：假设有某类问题 $\mathcal{I}$，其中一个实例记作 $I$，并且有一个复杂度为多项式的近似算法 $A$。定义：

- $A(I)$ 为算法 $A$ 在实例 $I$ 上得到的解；
- $\operatorname*{OPT}(I)$ 为实例 $I$ 的最优解。

由于 $\mathcal{I}$ 不一定是最小化还是最大化问题，我们对称的定义绝对近似比：

$$
\rho = \sup_{I} \left\{\frac{\operatorname*{OPT}(I)}{A(I)}, \frac{A(I)}{\operatorname*{OPT}(I)}\right\}
$$

**渐进近似比/Asymptotic Approximation Ratio**：如果对任意常数 $\alpha \geq 1$，对任意实例 $I$，存在一个常数 $k$，满足 $A(I) \leq \alpha \cdot \operatorname*{OPT}(I) + k$，称所有满足上式的 $\alpha$ 的下确界为 $A$ 的渐近近似比。

如果我们只关心那些 $\operatorname*{OPT}(I)$ 较大的实例，我们就引入渐进近似比这个概念。可以看出 $\alpha$ 决定了当 $\operatorname*{OPT}(I)$ 充分大时 $A(I)$ 与 $\operatorname*{OPT}(I)$ 的比值。$k$ 除了可以是某些固定的常数，也可以是 $o(\operatorname*{OPT}(I))$，只需要在 $\operatorname*{OPT}(I)$ 充分大时 $k/\operatorname*{OPT}(I) \to 0$ 即可。当 $k = 0$ 时渐近近似比就成了绝对近似比。

- $\mathsf{PTAS}$：多项式时间近似方案，存在算法 $A$ 使得对每一个固定的 $\varepsilon > 0$，对任意的实例 $I$，都有 $A(I) \leq (1 + \varepsilon) \cdot \mathsf{OPT}(I)$，且算法的运行时间以问题规模 $\lvert I\rvert$ 的多项式为上界。

    理论上，$A$ 在多项式时间内可以无限近似，但是对于不同的 $\varepsilon$，$A$ 的运行时间可能会有所不同。一般可以将 $\mathsf{PTAS}$ 的复杂度记作 $O(n^{f(1/\varepsilon)})$。

- $\mathsf{EPTAS}$：在 $\mathsf{PTAS}$ 的基础上要求算法的运行时间是 $O(\lvert I\rvert^c)$ 的，其中 $c$ 是一个和 $\varepsilon$ 无关的常数，可以将 $\mathsf{EPTAS}$ 的复杂度记作 $\lvert I\rvert^{O(1)}f(1/\varepsilon)$。
- $\mathsf{FPTAS}$：还要求算法的运行时间关于 $\varepsilon$ 也是多项式的，可以将 $\mathsf{FPTAS}$ 的复杂度记作 $\lvert I\rvert^{O(1)}\left(1/\varepsilon\right)^{O(1)}$。

> 很直观的想法，如果我们想要获得更好的近似比，那么我们显然需要更多的时间。PTAS 只要求长得像多项式，但是这个多项式可以和 $1/\varepsilon$ 有关，而 EPTAS 要求对规模 $n$ 是多项式的，后面乘上去的 $1/\varepsilon$ 的函数无所谓，而 FPTAS 要求对 $1/\varepsilon$ 也是多项式的，这就是完全多项式时间近似方案。

### 2. 最小化工时调度问题

### 3. 装箱问题

**一维装箱问题**：给定若干个带有尺寸的物品，将所有物品装到给定容量的箱子中，每个箱子不能超过容量，求最少的箱子数。模型化如下：给定 $n$ 个尺寸在 $(0, 1]$ 之间的物品 $a_1, a_2, \cdots, a_n$，使用数目尽可能少的单位容量的箱子装下所有物品，每个箱子的物品尺寸和都不超过 1。这个问题是 $\mathsf{NP}$ 完全的，甚至给定若干个物品，判定两个箱子是否可以装下都是 $\mathsf{NP}$ 完全的。

$\mathsf{NP}$ **完全性的证明**：首先我们要知道**划分问题/Partition Problem**，这是 Karp 的 21 个 $\mathsf{NP}$ 完全问题之一，表述为给定若干个正整数，判断是否可以将它们划分成两个和相等的集合。换言之，我们有 $S = \{c_i \mid i = 1, 2, \cdots, n\}$，判断是否存在一个 $S' \subseteq S$ 使得 $\sum\limits_{i\in S'}c_i = \sum\limits_{i\notin S'}c_i$。

我们的目标是将一维装箱问题规约到划分问题：对任何一个划分问题实例，我们可以构造一个装箱问题，令物品的尺寸为 $c_i/C$，其中 $C$ 为所有物品的尺寸之和 $\sum\limits_{i=1}^nc_i$，同时我们呢假设这些 $a_i\in (0, 1]$，那么显然这些物品可以使用两个大小为 1 的箱子装下当且仅当两个箱子完全装满。这个规约是多项式时间的，因此一维装箱问题是 $\mathsf{NP}$ 完全的。

下面证明，装箱问题的近似比下界：

**定理**：除非 $\mathsf{P} = \mathsf{NP}$，否则不存在一个多项式时间的算法，使得一维装箱问题的近似比小于 $3/2$。

!!! Info "Proof"

    反证法：假设存在一个近似比小于 $3/2$ 的多项式时间近似算法 $A$，那么我们可以直接使用其来判断物品是否可以由两个箱子装下：

    1. 如果确实可以由两个箱子装下，即 $\operatorname*{OPT}(I) = 2$，那么近似算法根据近似比要求返回的解必定是 $A(I) < 3$，但这一近似算法返回的值必定是整数，于是 $A(I) = 2$，于是近似算法直接就返回了正确答案；
    2. 如果 $\operatorname*{OPT}(I) \geq 3$，那么 $A(I) \geq 3$，此时因为近似比低于 $3/2$，表明最优解不可能是 2，所以通过近似算法的解我们也能判断出物品是否可由两个箱子装下。

    这样我们就回答了两个箱子的装箱问题，是通过多项式时间的归约（因为这里甚至不需要归约）到一个多项式时间的算法实现的。而它是一个 $\mathsf{NP}$ 完全问题，因此只可能有 $\mathsf{P} = \mathsf{NP}$。

对于装箱问题，如果所有的物品信息在开始装箱前都已知，那么这是一个离线问题，我们设计的是离线算法，比如下面的 FFD 算法；如果初始时物品信息并不全部给出，需要我们即时安排，对未到来的物品信息一无所知，这就是在线问题，下面的 NF 和 Any Fit 都是在线算法。我们一般使用竞争比/Competitive Ratio 这个概念。竞争比通常来自于对问题信息所知有限。

**Next Fit 算法**：

**Any Fit 方案**：当物品到达时，除非目前打开的所有箱子都无法装下该物品时，才允许打开一个新箱子，包含下面几种：

- **First Fit 算法**：选择**最早打开的箱子**优先填入；
- **Best Fit 算法**：选择**剩余空间最小**的箱子优先填入；
- **Worst Fit 算法**：选择**剩余空间最大**的箱子优先填入。

值得注意的是，Any Fit 的三种算法都满足相邻两个箱子物品尺寸之和大于 1，因此其均不会比 NF 差，所以 NF 的下界分析也适用于 Worst Fit，所以 WF 和 NF 一样差。改进方式是将当前物品放入能装下它的剩余空间第二大的箱子中，若这样的箱子不存在，就放入能装下它的剩余空间最大的箱子中，如果还装不下，就再开一个箱子。这样修正过的算法叫做 Almost Worst Fit 算法。

Almost Worst Fit 和 BF 与 FF 都被称为 Almost Any Fit 算法，因为满足下面的性质：设第 $k$ 个箱子是当前打开箱子中剩余空间最大且最晚打开的一个，亦即，第 $k$ 个打开的箱子剩余空间最大，和它有相同剩余空间的箱子打开得都比它早。那么除非当前物品无法装进前 $k − 1$ 个箱子里，否则它不会装进第 $k$ 个箱子里。满足此性质的算法称为 Almost Any Fit/AAF 算法。FF 和 BF 是 AAF 算法，而 NF 和 WF 不是。

有下面渐进比事实：**NF 和 WF 的渐进比都是 2，而任意的 AAF 算法都有渐进比 1.7**。

特别的，在 PPT 中特别提到：如果 $M$ 为最优装箱数目，那么 First Fit 得到的装箱数不会超过 $17M/10$，而存在一些序列使得 First Fit 使用 $17(M-1)/10$ 个箱子。这换过来表明了 FF 的竞争比为 $17/10$。FF 和 BF 的时间复杂度都是 $O(n\log N)$。

由于在线算法不知道输入什么时候结束（其实不知道未来的所有信息），所以在线算法永远得不到最优解，并且在装箱问题中，所有在线算法得到的近似解的数目至少是最优解的 5/3 倍。

下面讨论离线算法。**First Fit Decreasing 算法**：先按照物品尺寸降序排列，然后使用 FF 算法。**Best Fit Decreasing 算法**：先按照物品尺寸降序排列，然后使用 BF 算法。

FFD 的绝对近似比为 $3/2$，渐进近似比表示为 $\operatorname*{FFD}(I) \leq \frac{11}{9}\operatorname*{OPT}(I) + \frac{6}{9}$。

!!! Info "Proof"

### 4. 0-1 背包问题

分数背包问题非常简单：只需要按照单位价值排序，然后依次装入即可。但是这样的贪心算法不可以直接解决 0-1 背包问题。为了得到近似解仍然需要改进我们的算法：同时使用两个策略进行求解，分别为对单位重量价值进行贪心和对价值进行贪心，最后选择两个解中的最优解。这样的贪心算法实际上是一个 2-近似算法：

!!! Info "Proof"
    设分数背包问题的最优解为 $P_{frac}$，0-1 背包问题的最优解为 $P_{OPT}$，0-1 背包问题贪心解（即分数背包舍去选分数个的物品）为 $P_{greedy}$，所有装得下的物品中的最大价值为 $P_{max}$，那么我们有

    $$
    P_{max} \leq P_{greedy} \leq P_{OPT} \leq P_{frac}
    $$

    第一个不等式来自于我们的贪心解是取两种贪心策略的最优值，其中之一就是按照价值从大到小贪心选择的，因此贪心算法至少比这个价值大；第二个不等式来自于贪心策略是一个可行解，可行解一定小于等于最优解，同时我们的最优解一定小于分数背包问题的解。

    所以我们的近似比有上界

    $$
    \frac{P_{OPT}}{P_{greedy}} \leq \frac{P_{frac}}{P_{greedy}} \leq \frac{P_{OPT} + P_{max}}{P_{greedy}} = 1 + \frac{P_{max}}{P_{greedy}} \leq 2
    $$

    第二个不等式来自于分数背包问题和贪心解的差别：分数背包问题在选择**完整**装下单位重量价值最大的物品之后，只能装下剩下的单位价值最大的物品的一部分了，而剩下的单位价值最大的物品的价值不可能比最大价值还大，因此我们有 $P_{greedy} + P_{max} \geq P_{frac}$。

    还需要举一个例子证明 $2$ 是近似比：假设背包容量为 $4$，有三个物品，价值分别为 $2 − 2\varepsilon$, $2 − 2\varepsilon$, $4$，重量分别为 $2 − \varepsilon$, $2 − \varepsilon$, $4$，其中 $\varepsilon$ 是一个很小很小的正数。我们可以发现，贪心策略会选择第三个物品，而最优解是选择前两个物品，因此我们有近似比为 $2$，不可能进一步优化。

如果已知最优解中价值最大的前 $k$ 个，那么可以设计出近似比为 $\frac{k+1}{k}$ ​的算法。

背包问题还有一个更好的动态规划解：令 $W_{i, p}$ 为前 $i$ 个物品中总价值为 $p = \sum\limits_{k=1}^ip_k$ 时的最小重量，下面分类讨论：

- 如果选择第 $i$ 个物品：$W_{i, p} = w_i + W_{i-1, p-p_i}$；
- 如果不选择第 $i$ 个物品：$W_{i, p} = W_{i-1, p}$；
- 如果不可能得到价值 $p$：$W_{i, p} = \infty$。

状态转移方程如下：

$$
W_{i, p} = \begin{cases}
\infty & i = 0 \\
W_{i-1, p} & p_i > p \\
\min\{W_{i-1, p}, w_i + W_{i-1, p-p_i}\} & \text{otherwise}
\end{cases}
$$

其中，$i = 1, \cdots, n$，$p = 1, \cdots, np_{max}$，因此时间复杂度为 $O(n^2p_{max})$。值得注意的是，这样的动态规划解并不是一个多项式时间的解，因为输入是 $p_{max}$ 的二进制编码，这样看还是指数级别的。但如果知道 $p_{max}$ 的上界（甚至是关于 $n$ 的多项式上界），那么这个动态规划解就是一个多项式时间的解。

然而，通过将全体价值缩小一个比例，我们可以得到 0-1 背包问题的一个 $\mathsf{FPTAS}$ 解。

首先证明算法的正确性：设我们缩小的比例为 $b$，输入价值为 $v_1, \cdots, v_n$，缩小后的价值为 $v_1/b, \cdots, v_n/b$，将缩小后的价值向上取整：$\lceil v_1/b \rceil, \cdots, \lceil v_n/b \rceil$，这样我们就可以放进动态规划中运行了。显而易见，全体价值同时放缩一个比例 $b$，不会影响动态规划选择的最优物品集合，因此我们的动态规划算法选出的最优物品集合和当价值为 $\lceil v_1/b \rceil, \cdots, \lceil v_n/b \rceil$ 时的最优物品集合是一样的，只是后者的最优价值扩大了 $b$ 倍。我们记 $\lceil v_i/b \rceil$ 为 $v'_i$，那么显然 $v'_i$ 和原问题的 $v_i$ 差距应当不大，因此我们有理由相信 $v'_1, \cdots, v'_n$ 的最优解是 $v_1, \cdots, v_n$ 的最优解的一个近似。

形式化算法如下：

1. 给定我们想要达到的近似比率 $\varepsilon$（为了分析方便，我们假设 $1/\varepsilon$ 是整数，如果不是整数也可以向下找一个满足条件的数替代），令放缩比例 $b = \varepsilon v_{\max}/n$；
2. 将所有价值放缩为 $\lceil v_i/b\rceil$，然后运行动态规划算法得到最优解 $v$；
3. 然后将所有价值放大为 $v'_i = \lceil v_i/b\rceil b$，此时最优解为 $bv$，然后 $bv$ 就是我们的近似最优解了。

下面证明这是一个 $\mathsf{FPTAS}$：

!!! Info "Proof"

    时间复杂度是显然的，我们缩小价值后的动态规划算法是 $O(n^2v_{\max}/b) = O(n^3/\varepsilon)$ 的，因此是符合 $\mathsf{FPTAS}$ 的。接下来我们需要证明这一算法的近似比是符合 $\mathsf{FPTAS}$ 的。


### 5. K-聚类问题

给定 $n$ 个点 $s_1, \cdots, s_n$，在地图上选择 $K$ 个中心点 $c_1, \cdots, c_K$，使任意点到离它最近的中心点之间的距离中的最大值最小化。

困难之处在于我们可以选择的点的数目是无限多的。

最简单的贪心：直接放在一个最合适的位置上，也就是让第一个点和所有的点的最大距离最小化，但是这个贪心可以任意差。

2-近似的贪心，首先我们需要神谕 Oracle，先给定最优解 $r(C^*)$：

```C
Centers Greedy_2r(Sites S[], int n, int K, double r) {
    Sites S`[] = S[];  // S` is the set of the remaining sites
    Centers C[] = NULL;
    while (S`[] != NULL) {
        Select any s form S` and add it to C;
        Delete all s` from S` that are at dist(s`, s) <= 2r;
    } // end-while
    if (|C| <= K) 
        return C;
    else
        ERROR("No set of K centers with covering radius at most r");
}
```

随机选取点集中的一个点为第一个中心，然后删除该点为中心，删除所有距离小于 $2r$ 的点，然后重复这个过程直到所有点都被删除。这个算法的近似比是 2。

!!! Info "近似比的证明"

    因为每次都是删除选取的中心 $2r(C^*)$ 为半径的圆内所有点，所以如果算法能在 $K$ 步之内停止，那么得到的解一定是小于等于最优解的 2 倍，因此我们只需要证明算法能在 $K$ 步之内停止即可。根据我们前面的讨论，如果最优解是 $r(C^*)$，那么在上面的算法中，每次随机选择一个剩余的点作为中心，$2r(C^*)$ **为半径的圆至少会带走一个真正的最优解中的点为中心**（考虑圆和圆的相切就可以），$r(C^*)$ 为半径的圆内所有点，因此 $K$ 步之后必然最优解覆盖的所有点都被我们的算法覆盖，因此必然停止。

**定理**：假设该算法选择的中心点数超过 $K$，那么对于任意规模至多为 $K$ 的中心点集 $C^*$，覆盖半径为 $r(C^*) > r$。

!!! Info "带点解释的证明"

    其实就是反证法，这就是说如果我们在 $K$ 步内停止不了，这就是说最优解一定要大于 $r$。按照上面命题的证明就可以

    这其实是为了二分，我们总是假定我们有神谕，然后如果神谕是错的，我们就可以得到一个下界，然后我们就可以二分了。

这是一个换汤不换药的 2-近似算法，和上面的唯一区别就是我们要选择一个离中心点集中的点尽可能远的点。

```C
Centers Greedy_Kcenter(Sites S[], int n, int K) {
    Centers C[] = NULL;
    Select any s from S and add it to C;
    while (|C| < K) {
        Select s from S with maximum dist(s, C);
        Add s to C;
    }  // end-while
    return C;
}
```

??? Example "作业里的问题"

    Assume that you are a real world Chinese postman, which have learned an awesome course "Advanced Data Structures and Algorithm Analysis" (ADS). Given a 2-dimensional map indicating $N$ positions $p_i(x_i, y_i)$ of your post office and all the addresses you must visit, you'd like to find a shortest path starting and finishing both at your post office, and visit all the addresses at least once in the circuit. Fortunately, you have a magic item "Bamboo copter & Hopter" from "Doraemon", which makes sure that you can fly between two positions using the directed distance (or displacement).

    However, reviewing the knowledge in the ADS course, it is an NPC problem! Wasting too much time in finding the shortest path is unwise, so you decide to design a 2−approximation algorithm as follows, to achieve an acceptable solution.

    ```plaintext
    Compute a minimum spanning tree T connecting all the addresses.
    Regard the post office as the root of T.
    Start at the post office.
    Visit the addresses in order of a _____ of T.
    Finish at the post office.
    ```

    There are several methods of traversal which can be filled in the blank of the above algorithm. Assume that P≠NP, how many methods of traversal listed below can fulfill the requirement?

    - Level-Order Traversal
    - Pre-Order Traversal
    - Post-Order Traversal

    **Solution**：2。最优解应该构成一个图，首先证明这个图的权重和大于最小生成树的权重和：如果这个图里边有一个环，那么减去环中的某个边，仍然可以保持连通性，所以这个图的权重大于从这个图中规约后形成的树的权重和，因此大于最小生成树的权重和。
    
    前序遍历和后序遍历使得最小生成树的每个边最多被访问两次，而层序遍历就不能保证被访问次数的上界了，所以只有前序遍历和后序遍历可以保证近似比为 2。
    
## 八、Local Search

!!! Note

    - 对于一个优化问题，如果已知某个邻居的局部最优解是全局最优，那么也并**不意味着从邻居出发便能一步得到全局最优**。
    - 贪心算法不是局部搜索算法的一种特殊情况，因为贪心算法从无到有构造出来解，而局部搜索算法是从一个解出发，通过改变解的一部分来寻找更优解。
    - 二分图上的顶点覆盖：对于二分图上任意的匹配和顶点覆盖，顶点覆盖的顶点数**不小于**匹配的边数，**最大匹配的边数**等于**最小顶点覆盖**的顶点数。

### 1. 顶点覆盖问题

两种问法：

- **判定版本**：给定一个无向图 $G = (V, E)$ 和一个整数 $k$，判断是否存在一个顶点集合 $V' \subseteq V$，使得 $|V'| \leq k$，且 $G$ 中的每条边至少有一个端点在 $V'$ 中；
- **最优版本**：给定一个无向图 $G = (V, E)$，找到一个**最小的顶点集合** $S \subseteq V$，使得 $E$ 中的任意一条边 $(u, v)$，$u$ 和 $v$ 至少有一个属于 $S$。

定义一些量：

- 可行解集 $FS$：所有的顶点覆盖，显然是一个解；
- 成本函数 $cost(S)$：$S$ 的大小；
- 邻居关系 $S \sim S'$：每个顶点覆盖 $S$ 至多有 $|V|$ 个邻居。

搜索步骤：从 $S = V$ 开始，删除或增加一个节点得到新的顶点覆盖 $S'$，检查 $S'$ 的成本是否更低。

梯度下降算法：

```C
SolutionType Gradient_descent() {
    Start from a feasible solution S in FS;     // randomly
                                                // FS: the feasible solution set(for initialization)
    MinCost = cost(S);
    while (1) {
        S_ = Search(N(S));     // find the best S_ in N(S)
        CurrentCost = cost(S_);
        if (CurrentCost < MinCost) {
            MinCost = CurrentCost;
            S = S_;
        }
        else break;
    } 

    return S;
}
```

问题：容易陷入局部最优解，因此需要一些技巧来避免这种情况。

### 2. Metropolis 算法和模拟退火

```C
SolutionType Metropolis() {
    Define constants k and T;
    Start from a feasible solution S in FS;
    MinCost = cost(S);
    while (1) {
        S_ = Randomly chosen from N(S); // Adding is allowed
        CurrentCost = cost(S_);
        if (CurrentCost < MinCost) {
            MinCost = CurrentCost;
            S = S_;
        } else {
            With a probability exp(-(CurrentCost - MinCost) / (k * T)), let S = S_;     // Metropolis criterion
            otherwise break;
        }
    }

    return S;
}
```

Metropolis 算法的关键在于**温度**的设置，温度越高，接受概率越高，因此可以逃离局部最优解。

设计算法的难点在于寻找合适的温度值，我们采用模拟退火这个术语，表示让系统从很高的温度开始，这时很高概率逃离局部最优解，然后慢慢降温，使我们有充足的时间在一系列不断减小的中间温度值 $T = \{T_1, T_2, \cdots\}$ 中找到平衡点（即最优解）。

### 3. Hopfield 网络

我们期望讨论 Hopfield 神经网络的稳定构型，重要定义如下：

1. Hopfield 神经网络可以抽象为一个无向图 $G = (V, E)$，其中 $V$ 是神经元的集合，$E$ 是神经元之间的连接关系，并且每条边 $e$ 都有一个权重 $w_e$，这可能是正数或负数；
2. Hopfield 神经网络的一个**构型Configuration**是指对网络中每个神经元（即图的顶点）的状态的一个赋值，赋值可能为 1 或-1，我们记顶点 $u$ 的状态为 $s_u$；
3. 如果对于边 $e = (u, v)$ 有 $w_e > 0$，则我们希望 $u$ 和 $v$ 具有相反的状态；如果 $w_e < 0$，则我们希望 $u$ 和 $v$ 具有相同的状态；综合而言，我们希望 $w_e s_u s_v < 0$；
4. 如果 $w_e s_u s_v < 0$，我们称这条边是**好的/Good**，否则称为**坏的/Bad**；
5. 称一个点是**满意的/Satisfied**，当且仅当 $u$ 作为顶点的边中，好边的权重绝对值之和大于等于坏边的权重绝对值之和，即 $\sum\limits_{v: e = (u, v) \in E} w_e s_u s_v \leq 0$，反之，如果 $u$ 不满足这一条件，我们称 $u$ 是**不满意的/Unsatisfied**；
6. 我们称一个构型是**稳定的/Stable**，当且仅当所有的点都是满意的。

简单的 `State_flipping` 算法：

```C
ConfigType State_flipping() {
    Start from an arbitrary configuration S;
    while (!IsStable(S)) {
        u = GetUnsatisfied(S);
        s_u = -s_u;
    }

    return S;
}
```

**定理**：`State_flipping` 算法最多在翻转 $\sum\limits_{e\in E}\lvert w_e\rvert$ 次后停止。

!!! Info "Proof"

    取一个势能函数为 $\Phi(S) = \sum\limits_{e\in E \text{ and } e \text{ is good}}\lvert w_e\rvert$，显然对于任意的构型，$0\leq \Phi(S) \leq \sum\limits_{e\in E}\lvert w_e\rvert$。我们来观察一下当我们翻转一个不满意的点后势能函数的变化。设当前状态为 $S$，有一个不满意点 $u$，翻转 $u$ 的状态后得到 $S'$，那么我们有

    $$
    \Phi(S') - \Phi(S) = \sum\limits_{e=(u, v)\in E\text{, }e \text{ is bad}}\lvert w_e\rvert - \sum\limits_{e=(u, v)\in E\text{, }e \text{ is good}}\lvert w_e\rvert
    $$

    这是因为翻转后原先与 $u$ 相连的好边都变成了坏边，坏边都变成了好边，其余边没有变化。又因为 $u$ 是不满意的，因此与 $u$ 相连的坏边比好边权重绝对值之和大，所以上式大于 0，即 $\Phi(S') > \Phi(S)$。又因为势能函数只能取整数值，故 $\Phi(S') \geq \Phi(S) + 1$。这就意味着我们每次翻转一个不满意的点，势能函数就会增加至少 1。因为势能函数的取值范围是有限的（0 到所有边权重绝对值之和），所以我们的局部搜索算法一定会停止。

**定理**：对于构型 $S$，如果其势能 $\Phi(S)$ 是局部最大值，那么这个构型是一个稳定构型。

!!! Info "Proof"

    反正法很容易证明。

`state_flipping` 算法是一个伪多项式时间复杂度的算法，输入是每条边长度的二进制编码，所以时间复杂度是指数级别的。找到一个关于 $n$ 和 $\log W$ 的多项式时间复杂度的算法仍然是一个开放的问题。

### 4. 最大割问题

**题目**：给定一个正边权的无向图 $G = (V, E)$，将顶点集合 $V$ 分成两个集合 $A$ 和 $B$，使得割边的权重和最大，即最大化 $w(A, B) = \sum\limits_{(u, v)\in E, u\in A, v\in B}w_{uv}$。

这是一个经典的 $\mathsf{NP}$ 完全问题。但是可以和 Hopfield 神经网络上的问题建立联系：我们任意将这个图的点集分成两个集合 $A$ 和 $B$，将 $A$ 中的点赋状态 $-1$，$B$ 中的点赋状态 $1$，因为所有边的权重都是正数，所以最大化割边权重和对应于 Hopfield 神经网络将势能函数最大化的问题，因此我们可以使用 `State_flipping` 算法来找到局部最优解。对于近似比有下面的定理：

**定理**：设 $(A, B)$ 是局部搜索算法得出的一个局部最优解，$(A^*, B^*)$ 是最优解，则

$$
\frac{w(A, B)}{w(A^*, B^*)} \geq \frac{1}{2}
$$

!!! Info "Proof"
    
    记图 $G$ 中所有边的权重之和为 $W = \sum\limits_{(u, v)\in E}w_{uv}$。因为 $(A, B)$ 是一个局部最优解，即把 $u$ 放到 $B$ 中会使得割边权重和降低，即

    $$
    \sum\limits_{v\in A}w_{uv} \leq \sum\limits_{v\in B}w_{uv}
    $$
    
    这是因为把 $u$ 从 $A$ 换到 $B$ 后，割边总权重只是增加了不等式左边权重，减小了不等式右边权重。我们对所有的 $u\in A$ 都有这样的不等式，将这些不等式求和有

    $$
    \sum\limits_{u\in A}\sum\limits_{v\in A}w_{uv} \leq \sum\limits_{u\in A}\sum\limits_{v\in B}w_{uv}
    $$

    很显然，等式左边就是 $2$ 倍的 $A$ 中所有边的权重之和，因为每条边都被计算了两次，等式右边就是所有割边的权重之和，所以我们有

    $$
    2\sum\limits_{(u, v)\in A}w_{uv} = \sum\limits_{u\in A}\sum\limits_{v\in A}w_{uv} \leq \sum\limits_{u\in A}\sum\limits_{v\in B}w_{uv} = w(A, B)
    $$

    对称的，我们也有 $2\sum\limits_{(u, v)\in B}w_{uv} \leq w(A, B)$，并且由 $W = w(A, B) + \sum\limits_{(u, v)\in A}w_{uv} + \sum\limits_{(u, v)\in B}w_{uv}$，我们有

    $$
    W(A^*, B^*) \leq W = w(A, B) + \sum\limits_{(u, v)\in A}w_{uv} + \sum\limits_{(u, v)\in B}w_{uv} \leq 2w(A, B)
    $$

    这就完成了证明，值得注意的是，这就是博弈论中证明纳什均衡的无秩序代价的标准方法。

如果我们放弃对严格近似比的追求，控制迭代次数：当我们处于解 $w(A, B)$ 时，我们要求下一个解的权重至少要增大 $\frac{\varepsilon}{n}w(A, B)$，其中 $n$ 是图 $G$ 的顶点数。对于这一算法，我们有如下结论：

**定理**：设 $(A, B)$ 是上述算法给出的解，$(A^*, B^*)$ 是最优解，则

$$
\frac{w(A, B)}{w(A^*, B^*)} \geq \frac{1}{2 + \varepsilon}
$$

并且这一算法会在 $O(\dfrac{n}{\varepsilon}\log W)$ 次状态翻转后停止，其中 $W$ 是所有边的权重之和。

!!! Info "Proof"

    近似比的证明事实上非常简单，只需要对前一个近似比为 $2$ 的证明做一些修改即可。因为我们必须要一个 “比较大的改进” 才会继续搜索，所以当我们处于算法的结束状态时，我们的解 $(A, B)$ 应当满足，对于任意的 $u\in A$，我们有

    $$
    \sum\limits_{v\in A}w_{uv} \leq \sum\limits_{v\in B}w_{uv} + \frac{\varepsilon}{n}w(A, B)
    $$

    这是因为这时将 $u$ 从 $A$ 换到 $B$ 后，增加的割边权重和不会超过 $\frac{\varepsilon}{n}w(A, B)$。然后接下来所有的证明都基于此改进继续推进即可证明。

    考察时间复杂度：每次迭代都会使得割边权重和增加至少 $\frac{\varepsilon}{n}w(A, B)$，这也就是增加 $1 + \frac{\varepsilon}{n}$ 倍，因为 $(1 + \frac{1}{x})^x \geq 2$，也就是当目标函数变为原来的二倍需要的状态翻转的次数至多为 $\dfrac{n}{\varepsilon}$ 次，所以我们的算法在 $O(\dfrac{n}{\varepsilon}\log W)$ 次状态翻转后停止。

!!! Info "题目"

    Consider the maximum cut problem. Let $V$ be the set of vertices, let $n=\lvert V\rvert$, and let $W$ be the total edge weight. We have already learned a $(2+\varepsilon)$-approximation local search algorithm that needs $O(\dfrac{n}{\varepsilon}\log W)$ flips. In the following, we are trying to further reduce the number of flips by starting the algorithm with a good initial solution. Note that each vertex $v$ naturally forms a cut $(\{v\}, V-\{v\})$. Let $(\{v^*\}, V-\{v^*\})$ be the one with the largest weight among all such cuts. If we start the $(2+\varepsilon)$-approximation local search algorithm with $(\{v^*\}, V-\{v^*\})$, how many flips do we need in the worst case? ($O(\dfrac{n}{\varepsilon}\log n)$)。

    回忆一下我们采用搜索结果的条件：下一个解的权重至少增大 $\dfrac{2\varepsilon}{n}w(A, B)$，在最初的时候我们的 $W(A, B) = \sum\limits_{u\in V - \{v^*\}}w_{v^*u}$，且这时候 $W(A, B)$ 最小，我们根据这个进行放缩：

    $$
    \sum\limits_{u\in V}\sum\limits_{v\in V - \{v^*\}}w_{uv} = 2W \leq n\cdot \sum\limits_{u\in V - \{v^*\}}w_{v^*u} 
    $$

    所以我们从 $\sum\limits_{u\in V - \{v^*\}}w_{v^*u}$ 到最大值 $W$ 是需要翻转 $n/2$ 倍，查看上面的证明，我们翻了 $W$ 倍需要 $O(\dfrac{n}{\varepsilon}\log W)$ 次状态翻转，所以我们的答案是 $O(\dfrac{n}{\varepsilon}\log n)$。
