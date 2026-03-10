# Part 4 Number Theory and Cryptography

!!! Info 

    不想写数论的内容了，这部分讲的又浅又快，没啥意义。

## 4.1 Divisibility and Modular Arithmetic

**Division**: An integer $a$ divides $b$ if and only if there exists an integer $c$ such that $b = ac$. We write $a|b$.

**Divisibility Properties**:

- If $a|b$ and $b|c$, then $a|c$.
- If $a|b$ and $a|c$, then $a|(bx + cy)$ for any integers $x$ and $y$.
- If $a|b$ and $a$ and $b$ are both positive, then $a \leq b$.

**The Division Algorithm/带余除法**: For any integers $a$ and $b$, with $b > 0$, there exist unique integers $q$ and $r$ such that $a = bq + r$ and $0 \leq r < b$. Here $a$ is called the dividend, $b$ is called the divisor, $q$ is the quotient and $r$ is the remainder.

**Congruence**: Let $a$, $b$ and $n$ be integers with $n > 0$. We say that $a$ is congruent to $b$ modulo $n$ if $n|(a - b)$. We write $a \equiv b \pmod{n}$.

The congruence relation has the following properties:

- If $a \equiv b \pmod{n}$, then $b \equiv a \pmod{n}$.
- $a \equiv a \pmod{n}$.
- If $a \equiv b \pmod{n}$ and $b \equiv c \pmod{n}$, then $a \equiv c \pmod{n}$
- If $a \equiv b \pmod{n}$ and $c \equiv d \pmod{n}$, then $a + c \equiv b + d \pmod{n}$ and $ac \equiv bd \pmod{n}$.

The first three properties show that the congruence relation is an equivalence relation. The last property shows that the congruence relation is compatible with addition and multiplication.

Moreover, $a \equiv b \pmod{n}$ if and only if $a\!\!\mod{n} = b\!\!\mod{n}$.

**Arithmetic Modulo $m$**: Define $\mathbb{Z}_m = \{0, 1, 2, \cdots, m - 1\}$. The operationn $+_m$ and $\times_m$ are defined as $a +_m b = (a + b)\!\!\mod{m}$ and $a \times_m b = (a \times b)\!\!\mod{m}$. Thry satisfy the following properties:

- **Closure**: If $a, b \in \mathbb{Z}_m$, then $a +_m b \in \mathbb{Z}_m$ and $a \times_m b \in \mathbb{Z}_m$.
- **Associativity**: For all $a, b, c \in \mathbb{Z}_m$, $(a +_m b) +_m c = a +_m (b +_m c)$ and $(a \times_m b) \times_m c = a \times_m (b \times_m c)$.
- **Commutativity**: For all $a, b \in \mathbb{Z}_m$, $a +_m b = b +_m a$ and $a \times_m b = b \times_m a$.
- **Identity**: The identity element for $+_m$ is $0$ and the identity element for $\times_m$ is $1$.
- **Additive Inverse**: For all $a \in \mathbb{Z}_m$, there exists $b \in \mathbb{Z}_m$ such that $a +_m b = 0$, and $b=m-a$.
- **Distributive Property**: For all $a, b, c \in \mathbb{Z}_m$, $a \times_m (b +_m c) = (a \times_m b) +_m (a \times_m c)$.
