# Part 2: Circuit and Computation

!!! Info "Outline"

    - 任何有限函数都可以被布尔电路计算，电路的规模可能是指数级别的，这个界确实是紧的。
    - 我们可以将有限函数对应的程序/电路表示为字符串，从而证明存在一个通用程序，可以对别的电路进行求值/模拟，其规模是被求值的程序的规模的多项式级别。
        - 通用电路的规模必须大于其评估的电路，后面需要引入图灵机等内容，一方面是绕过规模问题，另一方面是处理无限域函数。
        - 而在图灵机的世界内，我们确实存在一台 UTM，起可以接受另一台图灵机 $M$ 的编码作为输入，然后逐步模拟 $M$ 的计算过程，两台图灵机 $M$ 和 $U( \langle M \rangle, \cdot)$ 在同一状态下停机且输出一致。

## NAND-CIRC Interpreter for NAND-CIRC Programs

宏观上看，程序只不过是一串符号，每一个符号都可以编码成由 0 和 1 组成的字符串。因此我们可以把每一个 NAND-CIRC 程序——当然一般的布尔电路也可以，由于 NAND-CIRC 只由一种门组成，因此编码更加简单——表示为一个二进制字符串。这就意味着我们可以将电路或者 NAND-CIRC 程序既当作执行计算的指令，从而可以当做被其他计算用作输入的程序。这是一个很大的想法：程序是一段文本，因此可以作为输入被其他程序读取。代码和数据之间的对应关系是计算的核心之一，支撑了通用计算机的概念，这种计算机并不只能执行单一任务，而具有更大的灵活性。

!!! Danger "Theorem: Programs as Strings"

    存在一个常数 $c$，对于每一个函数 $f \in \mathit{SIZE}(s)$，都存在一个计算 $f$ 的 NAND-CIRC 程序 $P$，其字符串表示的长度不超过 $c s \log s$（也就是 $O(s \log s)$）。

这个构造是直接的：由于所有 NAND-CIRC 程序都可以写成这样：

```py
temp_0 = NAND(X[0],X[1])
temp_1 = NAND(X[0],temp_0)
temp_2 = NAND(X[1],temp_0)
Y[0] = NAND(temp_1,temp_2)
```

每一行最多只出现三个变量，而所有门都是 NAND 门，因此我们只需要记录每一行的输出变量和两个输入变量就可以了，由于 NAND-CIRC 程序的变量名并不影响其功能，因此我们可以将所有的变量都命名为 `temp_0`、`temp_1`、`temp_2` 等等。假设程序有 $s$ 行，那么我们最多只需要使用 $3s$ 个变量，输入和输出的变量的索引也不超过 $3s$。因此每一个变量的索引可以使用 $O(\log s)$ 位来表示（更确切的说是 $\lceil \log_{10}(3s+1) \rceil$ 位）。 因此每一个 $s$ 行的程序可以使用 $O(s \log s)$ 位来表示。关于函数和程序的对应关系就不用多讲了。

这就很艺术了，一方面我们可以将程序表示成字符串，进而作为另一个程序的输入，另一方面，由于一个电路/程序只能计算一个函数，那么这个定理实际上给出了规模为 $s$ 的电路可计算的函数的数量上界：$2^{O(s \log s)}$。实际上就可以证明上一节提到的电路规模问题的紧性：

!!! Info "Corollary: Counting Programs"

    对于任意的 $s, n, m \in \mathbb{N}$，有 $\lvert \mathit{SIZE}_{n,m}(s) \rvert \leq 2^{O(s \log s)}$。这意味着最多有 $2^{O(s \log s)}$ 个函数可以由规模不超过 $s$ 的 NAND-CIRC 程序计算出来。

直接使用几何级数求和就可以。定义一个映射 $E$，其将 $f$ 映射为计算 $f$ 的最小程序的表示，由于 $f \in \mathit{SIZE}(s)$，因此 $E(f)$ 的长度不超过 $c s \log s$。映射 $f\mapsto E(f)$ 是一个单射，因为对于不同的 $f, f' : \{0,1\}^n \rightarrow \{0,1\}^m$，一定存在某一个输入 $x$，使得 $f(x) \neq f'(x)$，因此计算 $f$ 和 $f'$ 的最小程序也一定不同，因此 $E(f) \neq E(f')$。因此我们有：

!!! Danger "Theorem: Tightness of Circuit Size Bound"

    存在一个常数 $\delta > 0$，对于每一个充分大的 $n$，存在一个函数 $f:\{0,1\}^n \rightarrow \{0,1\}$，使得 $f \notin \mathit{SIZE}_n\left(\tfrac{\delta 2^n}{n}\right)$。也就是计算 $f$ 的最短 NAND-CIRC 程序需要超过 $\delta \cdot 2^n/n$ 行。

证明也很简单，令 $c$ 为使得 $\lvert \mathit{SIZE}_{n,1}(s) \rvert \leq 2^{c s \log s}$ 成立的常数，令 $\delta = 1/c$，设 $s = \delta 2^n/n$，那么我们有：

$$
\lvert \mathit{SIZE}_n(\frac{\delta 2^n}{n}) \rvert \leq 2^{c \tfrac{\delta 2^n}{n} \log s} < 2^{c \delta 2^n} = 2^{2^n}
$$

这是因为 $s < 2^n$ 且 $\log s < n$。规模为 $\delta 2^n/n$ 的程序计算的函数的数量小于所有从 $n$ 位到 1 位的函数的数量，因此一定存在某一个函数不在 $\mathit{SIZE}_n(\delta 2^n/n)$ 中，这就证明了定理。

之前看到，任何从 $\{0,1\}^n$ 到 $\{0,1\}$ 的函数都可以被一个 $O(2^n/n)$ 行的程序计算出来。因此这个界一定是紧的。

回到 Code as Data 的主题，由于可以将程序表示为字符串，因此我们可以将程序作为函数的输入。
