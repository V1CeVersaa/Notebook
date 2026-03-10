# Part 9 Relations

## 9.1 Relations and Their Properties

**Binary Relations**: A **binary relation** $R$ from a set $A$ to a set $B$ is a subset $R\subset A\times B$. We can represent 

Example: Let $A = \{0, 1, 2\}$ and $B = \{a, b\}$, then $\{(0, a), (0, b), (1, a), (2, b)\}$ is a relation from $A$ to $B$.

**Reflexive Relations/自反关系**: A relation $R$ on a set $A$ is **reflexive** if and only if for all $a\in A$, $(a, a)\in R$. Written symbolically, $R$ is reflexive if and only if 

$$\forall x[x\in U \rightarrow (x, x)\in R].$$

**Symmetric Relations/对称关系**: A relation $R$ on a set $A$ is **symmetric** if and only if for all $a, b\in A$, if $(a, b)\in R$, then $(b, a)\in R$. Written symbolically, $R$ is symmetric if and only if

$$\forall x\forall y[(x, y)\in R \rightarrow (y, x)\in R].$$

**Antisymmetric Relations/反对称关系**: A relation $R$ on a set $A$ is **antisymmetric** if and only if for all $a, b\in A$, if $(a, b)\in R$ and $(b, a)\in R$, then $a = b$. Written symbolically, $R$ is antisymmetric if and only if

$$\forall x\forall y[(x, y)\in R \land (y, x)\in R \rightarrow x = y].$$

**Transitive Relations/传递关系**: A relation $R$ on a set $A$ is **transitive** if and only if for all $a, b, c\in A$, if $(a, b)\in R$ and $(b, c)\in R$, then $(a, c)\in R$. Written symbolically, $R$ is transitive if and only if

$$\forall x\forall y\forall z[(x, y)\in R \land (y, z)\in R \rightarrow (x, z)\in R].$$

**Composition**: The **composition** of relations $R$ and $S$ is the relation $T$ such that $(a, c)\in T$ if and only if there exists an element $b$ such that $(a, b)\in R$ and $(b, c)\in S$.

**Powers of a Relation**: Let $R$ be a binary relation on a set $A$. The $n$th power of $R$ is the relation $R^n$ defined recursively as follows:

- Basis Step: $R^1 = R$.
- Inductive Step: $R^{n+1} = R^n \circ R$.

**Theorem 1**: The relation $R$ is transitive if and only if $R^n\subseteq R$.

- If Part: $R^n\subseteq R$, and $R^2\subseteq R$. If $(a, b)\in R$ and $(b, c)\in R$, then $(a, c)\in R^2\subseteq R$. Thus, $R$ is transitive.
- Only If Part: If $R$ is transitive and $(a, c)\in R^2$, then there exists a $b$ such that $(a, b)\in R$ and $(b, c)\in R$, hence $(a, c)\in R^2\subseteq R$. And induction completes the proof.

**Inverse Relation**: The **inverse** of a relation $R$ is the relation $R^{-1}$ such that $(b, a)\in R^{-1}$ if and only if $(a, b)\in R$.

$$R^{-1} = \{(b, a)|(a, b)\in R\}.$$

For a set with $n$ elements, there are $2^{n^2}$ possible relations, $2^{n(n+1)/2}$ possible symmetric relations, $2^{n}3^{n(n-1)/2}$ possible antisymmetric relations, $3^{n(n-1)/2}$ asymmetric relations, $2^{n(n-1)}$ irreflexive relations, $2^{n(n-1)/2}$ reflexive and symmetric relations, $2^{n^2}-2^{n(n-1)+1}$ neither reflexive nor irreflexive relations.

**Combining Relations**: Given two relations $R_1$ and $R_2$, we can combine them using basic set operations to form new realtions such as $R_1\cup R_2$, $R_1\cap R_2$, $R_1 - R_2$, $R_1\oplus R_2$.

## 9.3 Representing Relations

**Matrix Representation**: A relation $R$ between finite sets can be represented using a zero-one matrix. The matrix $M$ representing the relation $R$ is defined as follows: Suppose $R$ is a relation from $A=\{a_1, a_2, \ldots, a_m\}$ to $B=\{b_1, b_2, \ldots, b_n\}$, then the matrix $M$ representing $R$ is an $m\times n$ matrix such that $M[i, j] = 1$ if $(a_i, b_j)\in R$ and $M[i, j] = 0$ otherwise.

If $R$ is reflexive, then all the elements on the diagonal of $M_R$ are $1$. If $R$ is symmetric, then $M_R$ is symmetric, i.e. $m_{ij} = 1$ if and only if $m_{ji} = 1$. $R$ is antisymmetric if and only if $m_{ij} = 0$ or $m_{ji} = 0$ for all $i\neq j$.

**Graph Representation**: A **directed graph**, or **digraph**, consists of a set $V$ of **vertices/nodes** together with a set $E$ of **edges/arcs**, where each edge is an ordered pair of vertices. The vertex $a$ is called the **initial vertex** of the edge $(a, b)$, and the vertex $b$ is called the **terminal vertex** of the edge $(a, b)$. An edge of the form $(a, a)$ is called a **loop**. Then we can draw a graph to represent a relation.

**Reflexivity**: A relation $R$ on a set $A$ is reflexive if and only if there is a loop at each vertex in the graph representing $R$.

**Symmetry**: A relation $R$ on a set $A$ is symmetric if and only if $(a, b)$ is in the graph representing $R$ whenever $(b, a)$ is in the graph.

**Antisymmetry**: A relation $R$ on a set $A$ is antisymmetric if and only if $(y, x)$ is not an edge when $(x, y)$ with $x\neq y$ is an edge. In other words, whenever there is an edge from one vertex to another, there is no edge comming back.

**Transitivity**: A relation $R$ on a set $A$ is transitive if and only if whenever $(a, b)$ and $(b, c)$ are edges in the graph representing $R$, then $(a, c)$ is also an edge.

**Reverse in the Version of Relation Representation**: For matrix representation, the inverse relation is the transpose of the matrix. For graph representation, the inverse relation is the graph with all the edges reversed.

**Properties of Relation Operations**: Suppose $R$ and $S$ are the relations from $A$ to $B$, $T$ is the relation from $B$ to $C$, $P$ is the relation from $C$ to $D$, then

- $(R\cup S)^{-1} = R^{-1}\cup S^{-1}$.
- $(R\cap S)^{-1} = R^{-1}\cap S^{-1}$.
- $(R - S)^{-1} = R^{-1} - S^{-1}$.
- $(\overline{R})^{-1} = \overline{R^{-1}}$.
- $(A\times B)^{-1} = B\times A$.
- $\overline{R} = A\times B - R$.
- $(S\circ T)^{-1} = T^{-1}\circ S^{-1}$.
- $(R\circ T)\circ P = R\circ (T\circ P)$.
- $(R\cup S)\circ T = (R\circ T)\cup (S\circ T)$.

## 9.4 Closures of Relations

**Closure**: The **Closure** of a relation $R$ with respect to the property $P$ is the relation obtained by add the **minimum** numnber of ordered pairs to $R$ to satisfy property $P$.

**Reflexive Closure**: $r(R) = R\cup \Delta$ where $\Delta = \{(a, a)\vert a\in A\}$.

**Symmetric Closure**: $S(R) = R\cup R^{-1}$.

**Transitive Closure**: $T(R) = R\cup R^2\cup R^3\cup \cdots = \cup_{n=1}^{\infty}R^n$. To get this, we need some lemmas:

- Lemma 1: Let $R$ be a relation on a set $A$, there is a path of length $n$ from $a$ to $b$ in $R$ if and only if $(a, b)\in R^n$.
- Connectivity Relation: $R^* = R\cup R^2\cup R^3\cup \cdots$ is called the connectivity relation of $R$, which consists of all the $(a, b)$ such as there is a path from $a$ to $b$ in $R$.
- Lemma 2: The transitive closure of a relation $R$ is the connectivity relation of $R$.
    1. $R\subseteq R^*$. is obvious by definition.
    2. $R^*$ is transitive: If $(a, b)\in R^*$ and $(b, c)\in R^*$, then there is a path from $a$ to $b$ and a path from $b$ to $c$, then there is a path from $a$ to $c$, hence $(a, c)\in R^*$.
    3. $R^*$ is minimum: If $S$ is also a transitive relation containing $R$, then $R^*\subseteq S$. Because $S^* = S$ and $R\subseteq S$, then $R^*\subseteq S^*$, then $R^*\subseteq S$.

Lemma 3: A is a set consisting of $n$ elements, $R$ is a relation on $A$. If there is a path from $a$ to $b$ in $R$, then there is a path of length not exceeding $n$. If $a\neq b$, then such path has length not exceeding $n-1$.

From Lemma 3, we can see $t(R) = \cup_{i=1}^{n}R^i$ or $t(R) = \cup_{i=1}^{n-1}R^i\cup \Delta$.

Moreover, $M_{R^*} = M_R\lor M_{R^2}\lor M_{R^3}\lor \cdots\lor M_{R^n}$.

**Warshall's Algorithm**: The transitive closure $T$ of a relation $R$ on a set $A$ can be computed using Warshall's algorithm. The algorithm is as follows:

```C
for (k = 1; k <= n; k++)
    for (i = 1; i <= n; i++)
        for (j = 1; j <= n; j++)
            T[i][j] = T[i][j] || (T[i][k] && T[k][j]);
```

## 9.5 Equivalence Relations

**Equivalence Relation**: A relation $R$ on a set $A$ is an **equivalence relation** if and only if $R$ is reflexive, symmetric, and transitive. And we denote $a\sim b$ for $(a, b)\in R$ or $aRb$.

**Equivalence Class**: The **equivalence class** of an element $a\in A$ with respect to an equivalence relation $R$ is the set of all elements in $A$ that are related to $a$, and $a$ is called the representative of the equivalence cass $[a]_R$.

$$[a]_R = \{x\in A\vert xRa\}.$$

Theorem 1: Let $R$ be an equivalence relation on a set $A$. Then the statements for elements $a$ and $b$ of $A$ are equivalent:

- $aRb$.
- $[a]_R = [b]_R$.
- $[a]_R\cap [b]_R\neq \emptyset$.

**Partition**: A **partition** $\mathit{pr}(A) = \{A_i\vert i\in I\}$ of a set $A$ is a collection of disjoint nonempty subsets of $A$ whose union is $A$. In other words, the collection of subsets $A_i$ where $i\in I$ ($I$ is an index set), forms a partition of $A$ if and only if

- $A = \cup_{i\in I}A_i$.
- $A_i\neq \emptyset$ for all $i\in I$.
- $A_i\cap A_j = \emptyset$ for all $i\neq j$.

Theorem 2: Let $R$ be an equivalence relation on a set $A$. Then the equivalence classes of $R$ form a partition of $A$. Conversely, given a partition $\mathit{pr}(A) = \{A_i\vert i\in I\}$ of the set $A$, there is an equivalence relation $R$ on $A$ such that the equivalence classes of $R$ are the sets in the partition.

Let $R$ and $S$ be equivalence relations on the set $A$, then $R\cap S$ is also an equivalence relation on $A$.

- Reflexive: $(a, a)\in R$ and $(a, a)\in S$, then $(a, a)\in R\cap S$.
- Symmetric: Since $R^{-1} = R$ and $S^{-1} = S$, then $(R\cap S)^{-1} = R^{-1}\cap S^{-1} = R\cap S$.
- Transitive: Since $R$ and $S$ are transitive, then $R^2\subseteq R$ and $S^2\subseteq S$, then $(R\cap S)^2 = R^2 \cap R\circ S\cap S \circ R \cap R^2 \subseteq R\cap S$. Then $R\cap S$ is transitive.

However, $R\cup S$ is not necessarily an equivalence relation. It is indeed reflexive and symmetric. And $(R\cup S)^*$ is an equivalence relation.

## 9.6 Partial Orderings

**Partial Ordering**: A relation $R$ on a set $A$ is called a **partial ordering** or **partial order** if and only if $R$ is reflexive, antisymmetric and transitve. A set with a partial ordering is called a **partially ordered set** or **poset** and denoted by $(A, R)$.

**Comparability**: The elements $a$ and $b$ of a poset $(S, \leq)$ are **comparable** if and only if either $a\leq b$ or $b\leq a$. Otherwise, $a$ and $b$ are **incomparable**.

**Total Ordering**: A partial ordering $R$ on a set $A$ is called a **total ordering** or **total order** if and only if for all $a, b\in A$, either $aRb$ or $bRa$. A totally ordered set is called a **chain**.

**Well-ordered**: A set $A$ with a partial ordering $R$ is called **well-ordered** if and only if $R$ is totally ordered and every nonempty subset of $A$ has a least element.

**Lexicographic Order**

**Hasse Diagram**: A **Hasse diagram** is a visual representation of a partial ordering that leaves out edges that must be present because of the reflexive and transitive properties.

**Hasse Diagram Terminology**: $a$ is a **maximal** in $(A, \leq)$ if there is no $b\in A$ such that $a\leq b$. 