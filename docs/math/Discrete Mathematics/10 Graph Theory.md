# Part 10 Graph Theory

## 10.1 Graphs and Graph Models

**Graph**: A graph $G = (V, E)$ consists of a nonempty set of **Vertices/Nodes** $V$ and a set of **Edges** $E$. Each edge has either one or two vertices associated with it, called its **Endpoints**. An edge is said to **connect** its endpoints. If the edges connect only one vertex, it is called a **Loop**.

**Simple Gpaph**: A graph in which each edge connects two different vertices and no two edges connect the same pair of vertices.

**Multigraph**: A graph that may have multiple edges connecting the same vertices.

**Pseudograph**: A graph that may have loops, and possibly multiple edges connecting the same pair of vertices.

**Directed Graph/Digraph**: A graph $(V,E)$ consists of a nonempty set of vertices $V$ and a set of **Directed Edges/Arcs** $E$. Each directed edge is associated with ann ordered pair of vertices. The directed edge associated with the ordered pair $(u,v)$ is said to **start** at $u$ and **end** at $v$.

## 10.2 Graph Terminology and Special Types of Graphs

For an undirected graph $G = (V, E)$: 

- Two vertices, $u$ and $v$ in an undirected graph $G$ are called adjacent (or
neighbors) in $G$, if $\{u, v\}$ is an edge of $G$.
- An edge $e$ connecting $u$ and $v$ is called incident with vertices $u$ and $v$, or is
said to connect $u$ and $v$.
- The vertices $u$ and $v$ are called endpoints of edge $\{u, v\}$.
- The degree of a vertex in an undirected graph is the number of edges incident with it, except that a loop at a vertex contributes twice to the degree of that vertex. The degree of $v$ is denoted by $deg(v)$. If $\deg(v) = 0$, then $v$ is **isolated**. If $\deg(v) = 1$, then $v$ is **pendant**.
- The set of all neighbors of a vertex $v$ of $G$, denoted by $N(v)$, is called the neighborhood of $v$. If $A$ is a subset of $V$, we denote by $N(A)$ the set of all vertices in $G$ that are adjacent to at least one vertex in $A$. So, $N(A) = \cup_{v\in A} N(v)$.

**The Handshaking Theorem**: Let $G = (V, E)$ be an undirected graph with $e$ edges. Then

$$\sum_{v\in V}\deg(v) = 2e.$$

**Theorem 2**: An undirected graph has an even number of vertices of odd degree.

For a directed graph $G = (V, E)$:

- Let $(u, v)$ be an edge in $G$. Then $u$ is an initial vertex and is adjacent to $v$ and $v$ is a terminal vertex and is adjacent from $u$.
- The in degree of a vertex $v$, denoted $\deg^-(v)$ is the number of edges which terminate at $v$.
- Similarly, the out degree of $v$, denoted $deg^+(v)$, is the number of edges which initiate at $v$.

**Theorem 3**: Let $G = (V, E)$ be a directed graph. Then

$$\sum_{v\in V}\deg^-(v) = \sum_{v\in V}\deg^+(v) = |E|.$$

Some special simple graphs:

- **Complete Graph** - $K_n$: A simple graph with $n$ vertices and exactly one edge between each pair of distinct vertices.
- **Cycles** - $C_n$: A simple graph with $n$ vertices and $n$ edges that form a cycle.
- **Wheels** - $W_n$: Add one additional vertex to the cycle $C_n$ and add an edge from each vertex in $C_n$ to the new vertex to produce $W_n$.
- $n$-**Cubes** - $Q_n$: $Q_n$ is the graph with $2^n$ vertices representing bit strings of length $n$. An edge exists between two vertices that differ in exactly one bit position.
- **Bipartite Graph**: A graph $G = (V, E)$ is bipartite if $V$ can be partitioned into two disjoint sets $V_1$ and $V_2$ such that every edge in $E$ connects a vertex in $V_1$ to a vertex in $V_2$. There are no edges which connect vertices in the same set.
- **Complete Bipartite Graph** - $K_{m, n}$: The complete bipartite graph $K_{m, n}$ is the simple graph that has its vertex set partitioned into two disjoint subsets $V_1$ and $V_2$ of size $m$ and $n$ respectively, and every vertex in $V_1$ is adjacent to every vertex in $V_2$.
- **Regular Graph**: A graph in which each vertex has the same degree $n$ is called an $n$-regular graph.

**Theorem 4**: A simple graph is bipartite if and only if it is possible to assign one of two different colors to each vertex of the graph so that no two adjacent vertices have the same color.

**Matching**: A matching $M$ in a simple graph $G = (V, E)$ is a subset of $E$ such that no two edges are incident with the same vertex.

A **Maximum matching** is a matching with the largest number of edges.

We say that a matching $M$ in a bipartite graph $G = (V, E)$ with bipartition $(V_1, V_2)$ is a **complete matching from** $V_1$ to $V_2$ if every vertex in $V_1$ is an endpoint of an edge of the matching.

**Hall's Marriage Theorem**: The bipartite graph $G = (V, E)$ with bipartition $(V_1, V_2)$ has a complete matching from $V_1$ to $V_2$ if and only if $\vert N(A)\vert \geqslant \vert A\vert$ for all subsets $A$ of $V_1$. A vertex that is the endpoint of an edge of a matching $M$ is said to be **matched** by $M$. 

A good but long proof.

**Proof**:

- *If* part:
- *Only if* part:

For $G = (V, E)$ and $H = (W, F)$.

- $H$ is a **subgraph** of $G$ if $W \subseteq V$ and $F \subseteq E$.
- $H$ is a **proper subgraph** of $G$ if $H$ is a subgraph of $G$ and $H \neq G$.
- $H$ is a **spanning subgraph** of $G$ if $W = V$ and $F \subset E$.
- $H$ is a subgraph **induced** by a subset $W$ of $V$ if $F$ contains an edge in $E$ is and only if its endpoints are in $W$.
- The **union** of two graphs $G$ and $H$ is the simple graph $G\cup H$ with the vertex set $V \cup W$ and edge set $E \cup F$.

## 10.3 Representing Graphs and Graph Isomorphism

**Adjacency Matrix**: A simple graph $G = (V, E)$ with $n$ vertices $(v_1,v_2,\cdots, v_n)$ can be represented by its adjacency matrix, A, with respect to this listing of the vertices, where 

\[
    a_{ij} = \begin{cases} 1 & \text{if } \{v_i, v_j\} \text{ is an edge} \\
                           0 & \text{otherwise}  \end{cases}
\]

For multigraphs and pseudographs, the adjacency matrix is defined similarly, but the entries can't be just $0$ or $1$ anymore.

**Incidence Martix**: Let $G = (V, E)$ be an undirected graph. Suppose that $v_1, v_2, \cdots, v_n$ are the vertices and $e_1, e_2, \cdots, e_m$ are the edges of $G$. Then the incidence matrix with respect to this ordering of $V$ and $E$ is $n\times m$ matrix $M = [m_{ij}]_{n\times m}$, where

\[
    m_{ij} = 
    \begin{cases} 1 & \text{when edge } e_j \text{ is incident with } v_i \\
                  0 & \text{otherwise} \end{cases}
\]

**Isomorphism of Graphs**: Graphs with the same structure are said to be isomorphic. Formally, two simple graphs $G_1= (V_1, E_1)$ and $G_2= (V_2, E_2)$ are **isomorphic** if there is a $1-1$ and onto bijection $f$ from $V_1$ to $V_2$ such that for all $a$ and $b$ in $V_1$, $a$ and $b$ are adjacent in $G_1$ iff $f(a)$ and $f(b)$ are adjacent in $G_2$. Such a function $f$ is called an isomorphism.

In other words, when two simple graphs are isomorphic, there is a one-to-one correspondence between vertices of the two graphs that preserves the adjacency relationship.

**Important Invariants**: 

- The number of vertices;
- The number of edges;
- The degrees of the corresponding vertices;
- If one is bipartite, the other must be bipartite;
- If one is completed, the other must be complete;

## 10.4 Connectivity

A **path of length** $n$ in a simple path is a sequence of vertices $v_0, v_1, \cdots, v_n$ such that $\{v_0, v_1\}$, $\{v_1, v_2\}$, $\cdots$, $\{v_{n-1}, v_n\}$ are $n$ edges of the graph. 

The path is a **circuit** if the beginning and ending vertices are the same and the length of the path is greater than $0$.

A path is simple if it doesn't contain the same edge more than once.

A **path of length** $n$ in a **directed graph** is a sequence of vertices $v_0, v_1, \cdots, v_n$ such that $(v_0, v_1)$, $(v_1, v_2)$, $\cdots$, $(v_{n-1}, v_n)$ are $n$ edges of the graph. Circuits, cycles and simple paths are defined as before.

**Theorem 5**: The number of different paths of length $r$ from $v_i$ to $v_j$ is equal to the $(i, j)$ entry in the matrix $A^r$, where $A$ is the adjacency matrix of the graph. Easy to prove.

**Connected Graph**: An undirected graph is **connected** if there is a path between every pair of distinct vertices of the graph.

**Theorem 6**: There is a simple path between every pair of distinct vertices in a connected undirected graph. Just the definition.

**Components**: The maximally connected subgraphs of $G$ are called the **connected components** or just the components.

**Cut Vertex/Articulation Point**: A vertex is a **cut vertex** or **articulation point** if removing it and all edges incident with is results in more connected compotents than the original graph.

Similarly, if removal of an edge results in more connected components, then the edge is a **cut edge** or a **bridge**.

**Strongly Connected**: A directed graph is **strongly connected** if there is a directed path from $u$ to $v$ and a directed path from $v$ to $u$ for every pair of vertices $u$ and $v$ in the graph.

**Weakly Connected**: A directed graph is **weakly connected** if the underlying undirected graph is connected. Every strongly connected graph is weakly connected.

**Strongly Connected Components**: For a directed graph, the maximal strongly connected subgraphs are called the **strongly connected components**.

Left issues: Kosaraju's algorithm and Tarjan's algorithm.

**Some Other Invariants**:

- The number and size of connected components;
- Paths;
- Two graphs are isomorphic only if they have simple circuits of the same length;
- Two graphs are isomorphic only if they contain paths that go through vertices so that the corresponding vertices in the two graphs have the same degree.

## 10.5 Euler and Hamilton Paths

**Euler Path**: An **Euler Path** is a simple path containing every edge in $G$.

**Euler Circuit**: An **Euler Circuit** is not only an Euler path but also a circuit.

**Euler Graph**: A graph that contains an Euler circuit is called an **Euler graph**.

**Theorem 7**: A connected multigraph has an Euler circuit if and only if each of its vertices has even degree.

**Proof**:

- **Necessary Condition**:
- **Sufficient Condition**:

**Build and Find a Euler Circuit and Path**:

- Start from a vertex that has even degree.
- Add paths that from a circuit until you can't add any more.
- Ommitting all the edges that have been used, find a vertex that has an odd degree and repeat the process.

This will produce an Euler circuit, since every path is included and no edge is included more than once.

**Theorem 8**: A connected multigraph has an Euler path but not an Euler circuit if and only if it has **exactly two vertices of odd degree**.

**Theorem 9**: A **directed** multigraph having no isolated vertices has an Euler circuit if and only if the graph is weakly connected **and** the in-degree and out-degree of each vertex are equal.

> 所有顶点的出度入度相等的弱联通有向多图有欧拉回路。

**Theorem 10**: A directed multigraph having no isolated vertices has an Euler path but not an Euler circuit if and only if: 

- the graph is weakly connected; 
- the in-degree and out-degree of each vertex are equal **for all but two vertices**, one that has **in-degree** $1$ **larger** than its out-degree and the other that has **out-degree** $1$ **larger** than its in-degree.

> 没法翻译了，太抽象了。

**Hamilton Path**: A **Hamilton path** in a graph $G$ is a path which visits every vertex exactly once.

**Hamilton Circuit**: A **Hamilton circuit** is a circuit that visits every vertex exactly once except for the first vertex.

**Hamilton Graph**: A graph that contains a Hamilton circuit is called a **Hamilton graph**.

**Theorem 11** (DIRAC): If $G$ is a simple graph with $n$ vertices $(n \geqslant 3)$ and if the degree of each vertex is at least $n/2$, then $G$ has a Hamilton circuit.

**Theorem 12** (ORE): If $G$ is a simple graph with $n$ vertices $(n \geqslant 3)$ and if for every pair of nonadjacent vertices $u$ and $v$ of $G$, the sum of the degrees of $u$ and $v$ is at least $n$, i.e. $\deg(u) + \deg(v) \geqslant n$, then $G$ has a Hamilton circuit. 

**Necessary Condition for Hamilton Path and Halmiton Circuit**: For undirected graph: The necessary condition for the existence of Hamilton path:

- $G$ is connected;
- There are at most two vertices which degree are less than $2$. 

The necessary condition for the existence of Hamilton circuit:

1. The degree of each vertex is larger than $1$.

    Some properties:

    - If a vertex in the graph has degree two, then both edges that are incident with this vertex must be part of any Hamilton circuit.
    - When a Hamilton circuit is being constructed and this circuit has passed through a vertex, then all remaining edges incident with this vertex, other than the two used in the circuit , can be removed from consideration.

2. $G$ is a Hamilton graph, for any nonempty subset $S$ of set $V$, the number of connected components in $G-S$ does not exceed $\vert S\vert$.

## 10.6 Shortest Path Problems

**Weighted Graph**: $G = (V, E, W)$, where $W$ is a function that assigns a real number $W(e)$ to each edge $e$ in $E$. The number $W(e)$ is called the **weight** of edge $e$.

**Length of a Path**: The **length** of a path in a weighted graph is the sum of the weights of the edges in the path.

**Shortest Path**: The **shortest path** between two vertices $u$ and $v$ in a weighted graph is a path of minimum length between $u$ and $v$.

1. For **undirected graphs with positive graphs**: **Dijkstra's Algorithm**.

    **Theorem 13**: Dijkstra’s algorithm finds the length of a shortest path between two vertices in a connected simple undirected weighted graph. 

    **Theorem 14**: Dijkstra’s algorithm uses $O(n^2)$ operations (additions and comparisons) to find the length of the shortest path between two vertices in a connected simple undirected weighted graph.

2. **Floyd's Algorithm**: Allow negative weights but no negative cycles.

    ```plaintext
    Procedure Floyd(G: weighted simple graph):
        {G has vertices v_1, ..., v_n and weights w(v_i, v_j) with
         w(v_i, v_j) = infty if {v_i, v_j} is not an edge}
        for i := 1 to n:
            for j := 1 to n:
                d(v_i, v_j) := w(v_i, v_j)
        for i := 1 to n:
            for j := 1 to n:
                for k := 1 to n:
                    if d(v_j, v_i) + d(v_i, v_k) < d(v_j, v_k):
                        then d(v_j, v_k) := d(v_j, v_i) + d(v_i, v_k)
    {d(v_i, v_j) is the length of a shortest path between v_i and v_j}
    ```

## 10.7 Planar Graphs

**Planar Graphs**: A graph is called **planar** if it can be drawn in the plane without any edges crossing. Such a drawing is called a **planar representation** of the graph.

**Region**: A **region** is a part of the plane completely disconnected off from other parts of the plane by the edges of the graph. We have **Bounded Region** and **Unbounded Region**.

There is one unbounded region in a planar graph.

**Theorem 15** (Euler's Formula): Let $G$ be a **connected planar simple graph** with $e$ edges and $v$ vertices. Let $r$ be the number of regions in a planar representation of $G$. Then $r=e-v+2$.

**Proof**: **OMITTED**.

**Degree of a Region**:  Suppose $R$ is a region of a connected planar simple graph, the **number of the edges on the boundary** of $R$ is called the **Degree** of $R$, denoted by $\mathrm{Deg}(R)$. 

**Corollary**: If $G$ is a connected planar simple graph with $e$ edges and $v$ vertices where $v\geqslant 3$, then $e\leqslant 3v-6$. The equality holds if and only if every region has exactly three edges.

**Proof**: From $2e = \sum \mathrm{Deg}(R) > 3r$, we can derive $r \leqslant \dfrac{2e}{3}$. Under the Euler's formula, we have $r = e - v + 2$, so $e - v + 2 \leqslant \dfrac{2e}{3}$, which means $e \leqslant 3v - 6$.

**Corollary**: If $G$ is a connected planar simple graph, then $G$ has a vertex of degree not exceeding five.

**Corollary**:  If a connected planar simple graph has $e$ edges and $v$ vertices with $v\geqslant 3$ and no circuits of length $3$, then $e \leqslant 2v-4$. Generally, if every region of a connected planar simple graph has at least $k$ edges, then 

$$e \leqslant \frac{k(v - 2)}{k - 2}.$$

**Elementary Subdivision**: If a graph is planar, so will be any graph obtained by removing an edge $\{u, v\}$ and adding a new vertex $w$ together with edges $\{u, w\}$ and $\{w, v\}$. Such an operation is called an **elementary subdivision**. 

> 移除度为 2 的顶点或者在边上加一个顶点。

**Homeomorphic**: The graph $G_1=(V_1,E_1)$ and $G_2=(V_2,E_2)$ are called **homeomorphic** if they can be obtained from the same graph by a sequence of elementary subdivision.

**Theorem 16** (KURATOWSKI): A graph is nonplanar if and only if it contains a subgraph homeomorphic to $K_{3,3}$ or $K_5$.

## 10.8 Graph Coloring 

Each map in the plane can be represented by a graph, namely **the dual graph of the map**.

- Each region of the map is represented by a vertex.
- An edge connect two vertices if the regions represented by these vertices have a common border.
- Two regions that touch at only one point are not considered adjacent.

**Coloring**: A **coloring of a simple graph** is the assignment of a color to each vertex of the graph so that no two adjacent vertices are assigned the same color.

**Chromatic number/色数**: The **Chromatic number** of a graph is the **least number of colors needed** for a coloring of this graph, denoted by $x(G)$.


**The Four Color Theorem**: Every planar graph is $4$-colorable.

## 10.9 Netflow

**Flowgraph**: Directed graph with distinguished vertices s/source and t/sink.

**Capacities** on the edges: $:c(e) \geqslant 0$.

**Target**: Maximize the flow from $s$ to $t$ with the constraint that the flow on each edge does not exceed its capacity.

**Cut**: Partition of $V$ into disjoint sets $S$, $T$ with $s$ in $S$ and $t$ in $T$.

$Cap(S, T)$: Sum of the capacities of edges from $S$ to $T$.

$Flow(S, T)$: Net flow out of $S$, i.e. the sum of flows out of $S$ minus sum of flows into $S$.

**Residual Graph**: For flow graph $G$, the residual graph $G_f$ is defined as follows:

- $G$: Edge $e$ from $u$ to $v$ with capacity $c$ and flow $f$.
- $G_R$: Edge $e$ from $v$ to $u$ with capacity $f$.
- $G_R$: Edge $e$ from $u$ to $v$ with capacity $c-f$.

**Argumenting Path**: A path from $s$ to $t$ whose flow can be increased. Iff for all edges $f(u, v) < c(u, v)$ and $f(v, u) > 0$.

**Ford-Fulkerson Algorithm**: Build argument path until there is no forward path from source to sink.

**Augmenting path theorem**: Flow $f$ is a max flow iff there are no augmenting paths.

**Max-flow Min-cut Theorem**: The value of the max flow equals the capacity of the min cut.
