# Elliptic Curve Cryptography

!!! Info
    本文主要讨论了椭圆曲线加密的基本知识，包括但不限于椭圆曲线的定义与椭圆曲线加密的攻击方式，全文均以教育为目的。

    参考：

    - [Stanford 大神的笔记](https://crypto.stanford.edu/pbc/notes/elliptic/)，简洁明了，仍未过时；
    - [梅老板的 ECC 笔记](https://note.shad0wash.cc/crypto/ECC)，讲解细致；
    - [GitHub 上经典攻击的实现](https://github.com/jvdsn/crypto-attacks/)，每个轮子都可以直接用，实现非常漂亮，磕了；
    - CryptoHack 的各路大神的 Writeup。

## 1 Elliptic Curves

### 1.1 Weierstrass Form

我们这里讨论的是 Weierstrass 形式的椭圆曲线，它的一般形式是：

$$Y^2 = X^3 + aX + b.$$

### 1.2 Montgomery Form


## 2 ECC

## 3 ECDSA

## 4 Attacks

### Pohlig-Hellman Algorithm

### Smart Attack

### Singular Curve Attack

正如前面所说，我们定义的曲线是没有尖点与孤立点，并且自相交的曲线，但是当参数没有选择好的时候，该曲线上的离散对数问题就会变得很容易甚至显然。这种情况下，我们可以通过 Singular Curve Attack 来解决这个问题。

考虑通过函数 $f = x^3 + ax + b$ 定义的曲线 $E\colon y^2 = f(x)$，


### MOV Attack

首先定义**嵌入度数**：当椭圆曲线定义在 $GF(p)$ 上时，曲线群的阶为 $n$ 的时候，定义曲线的嵌入度数为满足 $p^k \equiv 1 \pmod n$ 的最小的 $k$，这样 $k$ 就是通过 $p$ 生成子群的阶。

一般来说，我们希望椭圆曲线的嵌入度数越大越好，不然双线性配对就变得非常好计算，这样就衍生出了对低嵌入度曲线的 MOV 攻击：MOV 攻击之名取于发明者 Menezes, Okamoto 与 Vanstone 三人的首字母缩写，涉及的论文暂且不表，攻击的目标仍然是从某个生成元 $G$ 与生成的公钥 $P = d * G$ 中恢复私钥 $d$。攻击思想如下：

1. 选择一个双线性配对 $e$，这里一般选择 [Weil](https://crypto.stanford.edu/pbc/notes/elliptic/weil.html) 或 Tate 配对，下文实现就是基于 Weil 配对的；
2. $P$ 的阶为 $m$，选择一个阶同样为 $m$ 的点 $Q$，并且令 $Q$ 与 $P$ 互不相关（也就是不存在 $n$ 使得 $Q = n * P$）；
3. 这样 $e(G, Q)$ 和 $e(P, Q)$ 就都可以计算了，并且有 $e(G, Q) = e(d * G, Q) = e(G, Q)^d$，所以我们就将在椭圆曲线群上难以计算的 DLP 问题转化成了在 $GF(p^k)$ 上的 DLP 问题，这就好算了，调 `log` 就可以了。

??? Info "Implementation"

    ```python
    def MOV_attack(base, result, max_k=6, max_tries=10):
        """
        Solves the discrete logarithm problem using the MOV attack.
        More information: Harasawa R. et al., "Comparing the MOV and FR Reductions in Elliptic Curve Cryptography" (Section 2)
        :param base: the base point
        :param result: the point multiplication result
        :param max_k: the maximum value of embedding degree to try (default: 6)
        :param max_tries: the maximum amount of times to try to find l (default: 10)
        :return: l such that l * base == result, or None if l was not found
        """
        E = base.curve()
        q = E.base_ring().order()
        n = base.order()
        assert gcd(n, q) == 1, "[x] GCD of base point order and curve base ring order should be 1."

        print("[*] Calculating embedding degree...")
        k = get_embedding_degree(q, n, max_k)
        if k is None:
            return None

        print(f"[+] Found embedding degree {k}")
        Ek = E.base_extend(GF(q ** k))
        base_k = Ek(base)
        result_k = Ek(result)
        for i in range(max_tries):
            Q_ = Ek.random_point()
            m = Q_.order()
            d = gcd(m, n)
            Q = (m // d) * Q_
            if Q.order() != n:
                continue

            if (alpha := base_k.weil_pairing(Q, n)) == 1:
                continue

            beta = result_k.weil_pairing(Q, n)
            print(f"[*] Computing {beta}.log({alpha})...")
            l = beta.log(alpha)
            print(f"[+] Found discrete logarithm {l} on try {i + 1}")
            return int(l)

        return None
    ```


