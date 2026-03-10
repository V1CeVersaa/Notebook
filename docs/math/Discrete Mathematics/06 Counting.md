# Part 6 Counting

## 6.1 The Basics of Counting

**The Product Rule**: A procedure can be broken down into a sequence of two tasks. There are $n_1$ ways to do the first task and $n_2$ ways to do the second task. Then there are $n_1*n_2$ ways to do the procedure.

**The Product Rule in Terms of Sets**: If $A_1$, $A_2$, $\cdots$, $A_m$ are all finite sets, then the number of elements in the Cartesian product $A_1 \times A_2 \times \cdots \times A_m$ is $|A_1| * |A_2| * \cdots * |A_m|$.

**The Sum Rule**: If a task can be done either in one of $n_1$ ways or in one of $n_2$ ways to do the second task, where none of the set of $n_1$ ways is the same as any of the set of $n_2$ ways, then there are $n_1 + n_2$ ways to do the task.

**The Sum Rule in Terms of Sets**: If $A$ and $B$ are disjoint sets, then $|A \cup B| = |A| + |B|$.

## 6.2 The Pigeonhole Principle

**The Pigeonhole Principle**: If $k$ is a positive integer and $k+1$ or more objects are placed into $k$ boxes, then there is at least one box containing two or more of the objects.

Corolary: A function $f$ from a set with $k+1$ elements to a set with $k$ elements is not one-to-one.

**Generalized Pigeonhole Principle**: If $N$ objects are placed into $k$ boxes, then there is at least one box containing at least $\lceil N/k \rceil$ objects.

## 6.3 Permutations and Combinations

I assume everyone has learned about permutations and combinations during high school period, so I omitted most of this part.

**Generalized Combinational Numbers**: If $n\geq 0$ and $n\geq m$, then the **Generalized Combinational Number** $\binom{m}{n} = C^n_m$ is defined as

$$\binom{m}{n} = C^m_m = \frac{\prod\limits_{i = m-n+1}^{m}i}{n!}.$$

**Combinatorial Proofs**: A **combinatorial proof** of an identity is a proof thar uses one of the following methods:

- A **Double Counting Proof** uses counting arguments to prove that both sides of an identity count the same objects but in different ways.
- A **Bijective Proof** shows that there is a bijection between the sets of objects counted by the two sides of the identity.

## 6.4 Binomial Coefficients and Identities

**Binomial Expression**: A binomial expression is the sum of two terms, such as $x + y$.

**Binomial Theorem**: Let $x$ and $y$ be variables and $n$ be a nonnegative integer. Then

$$(x + y)^n = \sum_{k=0}^{n} \binom{n}{k}x^{n-k}y^k = \binom{n}{0}x^n + \binom{n}{1}x^{n-1}y + \cdots + \binom{n}{n-1}xy^{n-1} + \binom{n}{n}y^n.$$

Corollary 1: For all nonnegative integers $n$,

$$\sum_{k=0}^{n} \binom{n}{k} = 2^n.$$

Corollary 2: For all positive integers $n$,

$$\sum_{k=0}^{n} (-1)^k\binom{n}{k} = 0.$$

**Pascal's Identity**: If $n$ and $k$ are integers with $0 \leq k \leq n$, then

$$\binom{n+1}{k} = \binom{n}{k-1} + \binom{n}{k}.$$

**Vandermonde's Identity**: If $m$, $n$, and $r$ are nonnegative integers with $r \leq m$ and $r \leq n$, then

$$\binom{m+n}{r} = \sum_{k=0}^{r} \binom{m}{k}\binom{n}{r-k}.$$

We only need to consider choosing $r$ elements from two sets $A$ and $B$ with $m$ and $n$ elements respectively.

Corollary 4: If $n$ is a nonnegative integer, then

$$\binom{2n}{n} = \sum_{k=0}^{n} \binom{n}{k}^2.$$

**Identity**: Let $n$ and $r$ be nonnegative integers with $r \leq n$. Then

$$\binom{n+1}{r+1} = \sum_{j=r}^{n}\binom{j}{r}.$$

Consider choosing $r+1$ elements from a set with $n+1$ elements, and the RHS sets the last element be the $j$th element, from the $r+1$th to the $n+1$th.

## 6.5 Generalized Permutations and Combinations

**Permutations with Repetition**: The number of r-permutations of a set with n elements, where repetition is allowed, is $n^r$.

**Combinations with Repetition**: The number of r-combinations of a set with n elements, where repetition is allowed, is $\binom{n+r-1}{r}$.

**Permutations with Indistinguishable Objects**: The number of different permutations of n objects, where $n_1$ are of one type, $n_2$ are of a second type, $\cdots$, and $n_k$ are of a $k$th type, is $\frac{n!}{n_1!n_2!\cdots n_k!}.$

## 6.6 Generating Permutations and Combinations

**Lexicographic Order**: The permutation $a_1a_2\cdots a_n$ precedes the permutation $b_1b_2\cdots b_n$ in lexicographic order if there is an integer $j$ with $1 \leq j \leq n$ such that $a_i = b_i$ for $i = 1, 2, \cdots, j-1$ and $a_j < b_j$.

**Find the Next Permutation**: If $a_1a_2\cdots a_n$ is a permutation of $1, 2, 3, \cdots, n$, then the next permutation in lexicographic order is obtained by:

- Locate the integers $a_j$ and $a_{j+1}$ with $a_j < a_{j+1}$ and $a_{j=1} > a_{j+2} > \cdots > a_n$.
- Put in the smallest integer that is larger than $a_j$ in the position $j$.
- List in increasing order the remaining integers $a_j$, $a_{j+1}$, $\cdots$, $a_n$ in the positions $j+1$, $j+2$, $\cdots$, $n$.

**Find the Next Combination**: If $S_j\in S = \{1, 2, 3, \cdots, n\}$ is the $j$th element in a combination of $r$ elements from $S$, then the next combination in lexicographic order is obtained by:

- Locate the **last** element $a_i$ in the sequence such that $a_i\neq n-r+i$.
- Then replace $a_i$ by $a_i + 1$ and $a_j = a_i +j - i +1$ for $j = i+1, i+2, \cdots, r$.