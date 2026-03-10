# 第二部分 经典演绎逻辑

## 1 命题逻辑

### 1.1. 命题逻辑

真值联结词可以按照联结词表达的语义分为五种：

- 否定词：
- 合取词：
- 析取词：
- 蕴含词：蕴含词表示一个充分条件假言推理中的"如果...那么..."，通过蕴含词联结的两个命题分别称为前件和后件。对于一个蕴含命题，只有当其前件为真后件为假的时候，其才为假，具有这一性质的蕴含也称为**实质蕴含**。
    - 蕴含怪论：一个假命题可以蕴含任何命题，一个真命题可以被任意命题蕴含，两个命题之间可以毫无关联或者违反自然语言逻辑。
- 等价词：

### 1.2. 命题语言

命题语言 $\mathcal{L}^p$ 包含一下三类符号：

- 第一类：一个无限序列的命题符号，用于表示原子命题，我们是用小写拉丁文字母 $p$，$q$，$r$（或加其他记号）表示任何命题符号，同时使用 $\top$ 和 $\bot$ 表示永真命题和永假命题。
- 第二类：五个联结符号 $\neg$，$\land$，$\lor$，$\rightarrow$，$\leftrightarrow$，分别表示并非、并且、或者、蕴涵和等值五种联结词。
- 第三类：标点符号：左括号和右括号。

用上述符号可以形成各种符号串，如 $(p \land q)$，$(p \lor ( \neg q \rightarrow r))$，$(p \rightarrow \neg q)$ 等。我们把有限的符号串称为**表达式**。为了使用表达式来表示命题，需要运用一定的语法规则对符号的组合方式进行限制。把由命题符号、联结符号和标点符号按照特定语法规则构成的表达式称作**命题公式**，简称公式。

我们**形式化定义命题公式**如下：命题公式按照下面被递归定义：

- 命题符号是公式，称为原子公式。
- 如果 $\phi$ 和 $\psi$ 是公式，那么 $(\neg \phi)$，$(\phi \land \psi)$，$(\phi \lor \psi)$，$(\phi \rightarrow \psi)$，$(\phi \leftrightarrow \psi)$ 也是公式。
- 只有有限次使用 (1) (2) 条款所组成的符号串是公式。

也可以使用 BNF 形式表达如下：

$$
\phi ::= p \mid (\neg \phi) \mid (\phi \land \psi) \mid (\phi \lor \psi) \mid (\phi \rightarrow \psi) \mid (\phi \leftrightarrow \psi)
$$

这里的联结词也被我们称为**主联结词**。我们也约定，公式的最外层括号可以省略，联结词的结合力强弱分别为 $\neg$，$\land$，$\lor$，$\rightarrow$，$\leftrightarrow$。

### 1.3. 语义

公式本身用于表示命题，命题有真假，公式本身没有真假，其真假值由如下两方面确定。

- 对于原子公式，其真假值又取决于其代表的原子命题的真假值，可以把原子公式所要表示的原子命题的真假值指派给它。
- 给定原子公式的真假值，其他公式的真值由联结符号的含义来确定。

对于第一个方面，我们可以定义**真假赋值**：真假赋值是以所有命题符号的集为定义域，以真假值 $\{1, 0\}$ 为值域的函数。

我们用斜体小写拉丁文字母 $v$ 表示任何真假赋值。真假赋值 $v$ 给公式 $p$ 指派的值记作 $p^v$。在此之上，对于第二个方面，给定原子公式的真假赋值，其他公式的真值通过联结符号的含义来确定，联结符号与联结词相对应，参照联结词的上述真值表，我们如下定义公式的真值：

真假赋值 $v$ 给公式 $p$ 指派的真值递归地定义如下：

- $p^v \in \{1, 0\}$；
- $(\neg \phi)^v = \begin{cases} 1, & \text{如果} \phi^v = 0 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \land \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = 1 \text{且} \psi^v = 1 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \lor \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = 1 \text{或} \psi^v = 1 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \rightarrow \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = 0 \text{或} \psi^v = 1 \\ 0, & \text{否则} \end{cases}$；
- $(\phi \leftrightarrow \psi)^v = \begin{cases} 1, & \text{如果} \phi^v = \psi^v \\ 0, & \text{否则} \end{cases}$。

我们因此可以验证，公式的真值要么是 1，要么是 0。给定一组公式集合 $\Phi$，对于某一个真假赋值 $v$，使用 $\Phi^v$ 表示对所有 $\phi \in \Phi$，$\phi^v = 1$。

- **重言式**：一个命题公式在任何真假赋值下均为真，比如 $q \rightarrow (p \rightarrow q)$；
- **矛盾式**：一个命题公式在任何真假赋值下均为假，比如 $p \land (\neg p)$；
- **可满足式**：一个命题公式在至少一个真假赋值下为真，比如 $p \lor (\neg p)$。

### 1.4. 逻辑推论

**逻辑推论**：给定一组公式集合 $\Phi$ 和公式 $\phi$，$\Phi \models \phi$ 当且仅当对于任意真假赋值 $v$，如果 $\Phi^v = 1$，则 $\phi^v = 1$。

这其实是用来形式化推理的，比如：我们希望使用 $p$ 代表鲁迅是革命家，$\neg q$ 代表鲁迅不喜欢封建制度，则 $p \rightarrow \neg q$ 代表如果鲁迅是革命家，则他不喜欢封建制度。我们要证明 $\{p, p \rightarrow \neg q\} \models \neg q$，这其实就是推理：如果鲁迅是革命家，则他不喜欢封建制度；鲁迅是革命家；所以，鲁迅不喜欢封建制度。

设 $\mathrm{KB} = \{\phi_1, \phi_2, \cdots, \phi_n\}$ 是一个由 $n$ 个公式组成的知识库，$\phi$ 是一个公式。当 $\mathrm{KB} \models \phi$ 成立时，如果 $\phi_1, \phi_2, \cdots, \phi_n$ 所表示的命题为真，那么 $\phi$ 所表示的命题也为真，而如果 $\phi_1, \phi_2, \cdots, \phi_n$ 所表示的命题中有些不为真，那么 $\phi$ 的真假赋值不一定为真。

**有效性**：对于 $\Phi \models \phi$，如果 $\Phi$ 是空集，则 $\models \phi$ 当且仅当对于任意真假赋值 $v$，$\phi^v = 1$，即 $\phi$ 是重言式，我们称 $\phi$ 是有效的。

**定理 1**：$\{\phi_1, \phi_2, \cdots, \phi_n\} \models \phi$ 当且仅当 $\models (\phi_1 \land \phi_2 \land \cdots \land \phi_n \rightarrow \phi)$。

**定理 2**：设 $\phi$ 是命题公式。那么 $\phi$ 是可满足的当且仅当 $\neg \phi$ 不是有效的；$\phi$ 是有效的当且仅当 $\neg \phi$ 不是可满足的。

**定理 3**：$\Phi \models \phi$ 当且仅当 $\Phi \cup \{\neg \phi\}$ 是不可满足的，也就是 $\Phi \cup \{\neg \phi\} \models \bot$。

**语义等价性**：设 $\phi$ 和 $\psi$ 是命题公式。我们说 $\phi$ 和 $\psi$ 语义等价，记作 $\phi \equiv \psi$，当且仅当 $\phi \models \psi$ 且 $\psi \models \phi$。

!!! Info "这里其实不应该是 $\equiv$，而是一个双向的 $\models$，但是 KaTeX 太垃圾了，所以用 $\equiv$ 表示"

**定理 4**：常见的语义等价关系：

- $\neg \neg \phi \equiv \phi$
- $\phi \leftrightarrow \psi \equiv (\phi \rightarrow \psi) \land (\psi \rightarrow \phi)$
- $\phi \rightarrow \psi \equiv \neg \phi \lor \psi$
- $\neg (\phi \land \psi) \equiv \neg \phi \lor \neg \psi$
- $\neg (\phi \lor \psi) \equiv \neg \phi \land \neg \psi$
- $\phi \land (\psi \lor \chi) \equiv (\phi \land \psi) \lor (\phi \land \chi)$
- $\phi \lor (\psi \land \chi) \equiv (\phi \lor \psi) \land (\phi \lor \chi)$

**定理 5**：给定 $\phi \equiv \psi$，且 $\phi$ 是 $\varphi$ 的一部分。把 $\varphi$ 中的 $\phi$ 替换成 $\psi$ 得到 $\varphi'$。我们有 $\varphi \equiv \varphi'$。

这是根据公式的递归定义，对于一个公式来说，由它的主联结词联结的各个部分也是公式。通过把这些部分替换为与之语义等价的公式，得到的新公式与原公式语义等价。

**定理 6**：语义等价关系满足自反性、对称性和传递性，即命题公式的语义等价关系是一种等价关系。

### 1.5. 范式

命题公式的语义等价关系将所有的命题公式划分为等价类，因此，如果在每一个等价类内可以找到一个形式上满足某种标准的公式，就可以在推理的时候使用这个公式。

**合取范式**：命题公式 $\phi$ 称为命题公式 $\psi$ 的合取范式，如果 $\phi \equiv \psi$，且 $\phi$ 呈如下形式：

$$D_1 \land D_2 \land \cdots \land D_m$$

其中，$D_i (i = 1,2,\ldots,m)$ 称为 $\phi$ 的子句，它们形如 $L_1 \lor L_2 \lor \cdots \lor L_n$。$L_j (j = 1,2,\ldots,n)$ 为原子公式或原子公式的否定，称 $L_j$ 为子句的文字。

析取范式的定义与合取范式的定义类似，不同的是：

1. $\phi$ 的形式为 $D_1 \lor D_2 \lor \cdots \lor D_m$，
2. $D_i$ 的形式为 $L_1 \land L_2 \land \cdots \land L_n$。

**定理 7**：任何命题公式与它的合取范式（析取范式）等价。

### 1.6. 形式推演

从知识的表示与推理的角度看，给定一个数据库 $\mathrm{KB} = \{\phi_1,\ldots,\phi_n\}$ 和一个公式 $\phi$，我们希望有一个过程来判断 $\mathrm{KB} \models \phi$ 是否成立。我们希望建立一个基于规则的推理系统，这个系统从一组前提出发，通过不断应用规则就可以得到结论。我们称这样的规则为**推理规则**。最典型的规则称为**肯定前件规则/MP 规则**：由 $\phi$ 及 $\phi \rightarrow \psi$ 可得到 $\psi$。MP 也被称为**蕴涵消去**。

**例题**：设有两个命题：

- $p$: 下雨。
- $p \rightarrow q$: 如果下雨，则地湿。

其中，$q$ 表示"地湿"。现在，如果我们知道下雨，而且知道如果下雨则地湿，那么把这两个信息结合起来，我们可以得到地湿的结论。

现在，我们用"蕴涵消去"规则来说明如何构造一个证明过程。

<img class="center-picture" src="./assets/2-1.webp" alt="2-1" width=550 />

我们也将这样的形式推演称为一个证明，记作 $\{p, p \rightarrow q, p \rightarrow (q \rightarrow r)\} \vdash r$。在这个证明中，每一步都包括三个部分：**序号、结论和获得结论的依据**。其中，第 1-3 步的结论都是依据前提通过应用自反规则获得的；第 4 步的结论是依据第 1、3 步的结论应用蕴涵规则获得的。第 5、6 步与第 4 步类似。第 6 步的结论就是证明的最后结论。

**形式可推演**：给定一组前提集合 $\Phi = \{\phi_1, \phi_2, \phi_3, \ldots, \phi_n\}$ 和一个结论 $\psi$，其中 $\phi_i$ 和 $\psi$ 都是公式。我们说从这组前提到这个结论是形式可推演的，记作 $\Phi \vdash \psi$，如果存在一个证明：

$$\begin{aligned}
    1 \qquad& \psi_1 \\
    2 \qquad& \psi_2 \\
    3 \qquad& \psi_3 \\
    \ldots \qquad& \ldots \\
    m \qquad& \psi_m
\end{aligned}$$

使得 $\psi_m = \psi$。其中，每个 $\psi_i (i = 1,2,3,\ldots,m)$ 要么属于 $\{\phi_1, \phi_2, \phi_3, \ldots, \phi_n\}$，要么依据 $\{\psi_1, \ldots, \psi_{i-1}\}$ 中的公式通过应用一条推理规则得到。

由定义可知，给定一组前提集合和一个结论，它们之间是否具有形式可推演关系，取决于是否可以构造一个证明。

**推理系统的可靠性和完备性**：设 $\vdash_R$ 是由一组形式推演规则集合 $R$ 构成的推理系统，称为自然演绎系统。对于任意公式集合 $\Phi$ 和公式 $\psi$，我们说：

- $\vdash_R$ 是可靠的，当且仅当如果 $\Phi \vdash_R \psi$，则 $\Phi \models \psi$。
- $\vdash_R$ 是完备的，当且仅当如果 $\Phi \models \psi$，则 $\Phi \vdash_R \psi$。

因此，如果一个推理系统是可靠的，那么它**从一组真命题出发，通过形式推演得到的结论也是真的**。这一点确保了推理系统的**正确性**。另一方面，如果一个推理系统是完备的，那么**从一组真命题出发，可以推出这组真命题所蕴涵的所有结论**。这一点确保了推理系统的推理能力。

### 1.7. 消解原理

根据形式可推演的定义，为了实现一个形式推演系统，需要考虑规则的选择和应用问题。规则的应用与其所涉及公式的形式有关。当规则越多，公式的形式越多样，在形式推演的各个步骤进行规则选择的难度就越大。为了提高系统的可实现性，一方面可以考虑减少公式的形式，另一方面可以考虑减少规则的数量，这就是消解原理的想法。

首先，任何命题公式都具有等价的合取范式，因此，在进行形式推演之前，把相关公式转化为合取范式。

为了方便，采用子句公式来表示合取范式。在一个子句中，任何命题符号不需要重复出现，且文字的顺序变化也不造成影响。因此，可以把一个子句看成是一个文字的集合。同样，在一个合取范式中，没有子句需要出现多次，且子句的顺序变化没有影响。因此，可以把一个合取范式看成是子句的集合。

**字句公式**：子句公式是子句的集合，可理解为子句的合取。子句是文字的集合，可理解为文字的析取。

为了区分这两种集合，我们把文字的集合表示为 $[L_1, L_2, \ldots, L_n]$，等价于一个析取式 $L_1 \lor L_2 \lor \cdots \lor L_n$，其中 $L_i (i = 1,2, \ldots, n)$ 是文字；把子句的集合表示为 $\{D_1, D_2, \ldots, D_m\}$，等价于 $D_1 \land D_2 \land \cdots \land D_m$，其中 $D_i (i = 1,2, \ldots, m)$ 是子句。

用 $[]$ 表示空子句，$\{ \}$ 表示空公式。空子句可被理解为永假命题 $\bot$，空公式可被理解为永真命题 $\top$。$\{[]\}$ 与 $\{ \}$ 不同。

**例题**：考虑一个合取范式 $(p \lor \neg r \lor s) \land (p \lor r \lor s) \land \neg p$。我们可以把它表示为如下子句公式：$\{[p, \neg r, s], [p, r, s], [\neg p]\}$。

消解推演采用子句公式作为前提，推理规则只有一条，称为消解规则。

**消解规则**：给定两个子句，推出一个新子句：从子句 $D_1 \cup \{L\}$ 和 $D_2 \cup \{\overline{L}\}$ 推出子句 $D_1 \cup D_2$。其中，$D_1$ 和 $D_2$ 可为空集。$D_1 \cup D_2$ 称为输入子句关于 $L$ 的**消解式**。其中，$\overline{L}$ 称为 $L$ 的补。对于任意原子命题 $p$：$\overline{p} = \neg p$，$\overline{\neg p} = p$。

**例题**：从子句 $[w, r, q]$ 和 $[w, s, \neg r]$ 可以得到 $[w, q, s]$。子句 $[p, q]$ 和 $[\neg p, \neg q]$ 有两个消解：关于 $p$ 的消解 $[q, \neg q]$ 和关于 $q$ 的消解 $[p, \neg p]$。特例：$[p]$ 和 $[\neg p]$ 的消解是 []。

消解规则定义中的消解推演规则也可表示为：

$$\frac{D_1 \lor L \quad D_2 \lor \overline{L}}{D_1 \lor D_2}$$

下面是两种特殊情况：

$$\frac{D \lor L \quad \overline{L}}{D}$$

$$\frac{L \quad \overline{L}}{\bot}$$

**消解推演**：从一个集合 $\Phi$ 推出一个子句 $D$ 的推演，记作 $\Phi \vdash_{\text{Res}} D$，是一个子句序列 $D_1, D_2, \ldots, D_n$，其中 $D_n = D$，并且对于每个 $D_i$，要么 $D_i \in \Phi$，要么 $D_i$ 是该推导中前面两个子句的消解式。

接下来，我们来讨论命题消解推演系统的可靠性和完备性。

**定理 8**：设有两个子句 $D_1 \cup \{L\}$ 和 $D_2 \cup \{\overline{L}\}$，则 $D_1 \cup \{L\}, D_2 \cup \{\overline{L}\} \models D_1 \cup D_2$。

???- Info "Proof"
    设 $v$ 是任一真假赋值，使得 $(D_1 \cup \{L\})^v = 1$ 且 $(D_2 \cup \{\overline{L}\})^v = 1$。用反证法。设 $(D_1 \cup D_2)^v = 0$。于是，$(D_1)^v = 0$ 并且 $(D_2)^v = 0$。于是，$L^v = 1$ 并且 $(\overline{L})^v = 1$。矛盾。原命题得证。

**定理 9**：如果 $\Phi \vdash_{\text{Res}} D$ 则 $\Phi \models D$（可靠性）；反之（完备性），不成立。

???- Info "Proof"

    1. 可靠性：如果 $\Phi \vdash_{\text{Res}} D$ 则 $\Phi \models D$。对消解推演的结构作归纳：

        - 基始：对于每个 $D_i (i = 1,2, \ldots, n)$，如果 $D_i \in \Phi$，显然有 $\Phi \models D_i$。
        - 归纳步骤：如果 $\Phi \models D_i$ 且 $\Phi \models D_j$，且 $D_k$ 是 $D_i$ 和 $D_j$ 的消解式，其中 $i,j,k \in \{1,2, \ldots, n\}$，则依据定理3.9，$\Phi \models D_k$。

    2. 完备性：如果 $\Phi \models D$ 则 $\Phi \vdash_{\text{Res}} D$。这个不成立。例如，设 $\Phi = \{[\neg p]\}$，$D = [\neg q, q]$。显然，$\Phi \models D$，但从 $\Phi$ 出发无法构造一个消解推演 $D_1, D_2, \ldots, D_n$ 使得 $D_n = D$。

上述定理表明，消解推理系统是可靠的，但不是完备的。不过，重要的是，当 $D$ 是空子句时，消解推演既是可靠的，又是完备的。

我们说一个证明系统 $R$ 是完备的，如果每个逻辑推论都有一个证明，即如果 $\Phi \models \phi$ 则 $\Phi \vdash_R \phi$。对于消解系统来说，它是**否证完备**的，即：从一组有穷的前提集 $\Phi$ 出发，如果没有 $\bot$ 的证明，那么 $\Phi$ 是**可满足的**。反之，如果 $\Phi$ 是**不可满足的**，那么就有从 $\Phi$ 到 $\bot$ 的证明，即 $\Phi \vdash_{\text{Res}} \bot$。

**定理 10**：消解系统是一个完备的否证系统，即：从一组有穷的前提集 $\Phi$ 出发，如果不存在 $\bot$ 的证明，那么 $\Phi$ 是可满足的。

依据消解原理，为了确定 $\mathrm{KB} \models \phi$ 是否成立，只要通过把 $\mathrm{KB}$ 和 $\neg \phi$ 转化为合取范式来获得 $\Phi$，然后检查 $\Phi \vdash_{\text{Res}} \bot$ 是否成立。

依据上述消解方法，可以产生一个算法来决定一个子句集合 $\Phi$ 是否可满足：

1. 检查 [] 是否在 $\Phi$ 中。如果是，那么返回 "不可满足"。
2. 检查 $\Phi$ 中是否存在两个子句使得它们发生消解而得到一个不在 $\Phi$ 中的子句。如果没有，那么返回可满足。
3. 把这个新子句加入 $\Phi$ 并返回 (1)。

消解算法在速度上可能非常慢。尽管通过选择一些方法可以提高算法的计算效率，但仍然存在局限性。Haken 于 1985 年提出了消解算法复杂性的如下结果：

**定理11**：存在一个数字 $c > 1$ 使得对于每个 $n$，存在一个不可满足的公式，该公式包括 $n$ 个命题符号，其最小的消解否证包含至少 $c^n$ 个步骤。

### 1.8. 霍恩字句逻辑

### 1.9. SAT

## 2 一阶逻辑

### 2.1. 谓词和量词

抽象的看，世界由对象及其关系构成，所有被讨论对象的集合称为**论域**，论域中的元素称为**个体**，个体可以通过常元和变元来描述。常元是用于表示确定对象的符号，变元是用于表示给定论域上的任意一个对象的符号。给定一个论域，从一组个体到一个个体的映射关系可以用**函词**来描述。

比如，我们可以用 $\mathrm{ZS}$ 表示张三，给定总定义域，语句 $x$ 是学生，中的 $x$ 是一个变元，表示任意一个学生，可以用 $g(\mathrm{ZS})$ 表示张三的哥哥，其中 $g$ 是 $x$ 的函词，表示“$x$ 的哥哥”。

一般地，把个体常元和个体变元统称**项**。进一步地，如果 $t_1,\ldots,t_n$ 是项，$f$ 是 $n$ 元函词，那么 $f(t_1,\ldots,t_n)$ 也是项。这样，个体可以用项来表达。

个体之间的关系使用谓词来表达，每个谓词附带着可以放置所讨论对象的位置，称为**空位**。把谓词携带空位的数目称为谓词的元数。用一元谓词表示的关系也称为个体的**性质**。

把谓词、常元、函词等结合在一起可以表示一些命题。命题“张三的哥哥是学生”可以表示为 "$F(g(\mathrm{ZS}))$"。

量词分为两类：**全称量词**和**存在量词**。前者用于描述某个变元的取值范围涵盖一整个论域，记作 $\forall x$，读作“对于所有的 $x$”；后者用于描述在给定论域中存在某个个体，记作 $\exists x$，读作“存在 $x$”。在上述例子中，命题“每位学生都读过一些书”可以表示为"$\forall x(F(x) \rightarrow \exists y(G(y) \land H(x,y)))$"。其中，谓词 $G$ 表示"... 是一本书"，$H$ 表示"... 读过 ..."。

### 2.2. 一阶语言

一阶语言 $\mathcal{L}$ 含七类符号。

1. 第一类是个体常元，通常用正体小写拉丁文字母（或加其他记号）$a \quad b \quad c$ 表示任何个体常元。
2. 第二类是个体变元，通常用正体小写拉丁文字母（或加其他记号）$x \quad y \quad z$ 表示任何个体变元。
3. 第三类是函数符号，对应于自然语言语句中的函词，通常用正体小写拉丁文字母（或加其他记号）$f \quad g \quad h$ 表示任何函数符号。任何函数符号 $f$ 有确定的元数 $m \geq 1$，称元数为 $m$ 的 $f$ 为 $m$ 元函数符号。
4. 第四类是关系符号，对应于自然语言语句中的谓词，通常用正体大写拉丁文字母（或加其他记号）$F \quad G \quad H$ 表示任何关系符号。任何关系符号 $F$ 有确定的元数 $n \geq 1$，称元数为 $n$ 的 $F$ 为 $n$ 元关系符号。等于符号 $\equiv$ 是一种特殊的关系符号。
5. 第五类是量词符号 $\forall$ 和 $\exists$，第六类是联结符号，与命题逻辑的相同。第七类是标点符号，包括左括号、右括号和逗号。

接下来定义一阶语言的项和公式。

**项**：项可以递归定义如下：

1. 变元和常元是项。
2. 如果 $t_1,\ldots,t_m$ 是项，$f$ 是 $m$ 元函数符号，则 $f(t_1,\ldots,t_m)$ 是项。
3. 只有有限次使用 (1)(2) 条款生成的符号串才是项。

不含自由变元的项称为基项，比如 $g(\mathrm{ZS})$ 和 $\mathrm{ZS}$ 是基项。

**公式**：公式可以递归定义如下：

1. 原子公式：如果 $t_1,\ldots,t_n$ 是项，$F$ 是 $n$ 元关系符号，则 $F(t_1,\ldots,t_n)$ 是原子公式。
2. 如果 $t_1$ 和 $t_2$ 是项，那么 $(t_1 \equiv t_2)$ 是原子公式。
3. 如果 $\phi$ 和 $\psi$ 是公式，则 $(\neg\phi)$，$(\phi \wedge \psi)$，$(\phi \vee \psi)$，$(\phi \rightarrow \psi)$，$(\phi \leftrightarrow \psi)$ 是公式。
4. 如果 $\phi$ 是公式，$x$ 是变元，则 $(\forall x\phi)$ 和 $(\exists x\phi)$ 是公式。
5. 只有有限次使用 (1)(2)(3) 条款生成的符号串才是公式。

分别使用 BNF 形式定义如下：

$$\begin{aligned}
    t &::= x \mid a \mid f(t,\ldots,t) \\
    \phi &::= F(t_1,\ldots,t_n) \mid (t_1 \equiv t_2) \mid (\neg\phi) \mid (\phi \wedge \phi) \mid (\phi \vee \phi) \mid (\phi \rightarrow \phi) \mid (\phi \leftrightarrow \phi) \mid \forall x\phi \mid \exists x\phi
\end{aligned}$$

**代换**：代换 $\theta$ 是一个有限的对子集合 $\{x_1/t_1,\ldots,x_n/t_n\}$，其中 $x_i$ 是变元，$t_i$ 是项。若 $\phi$ 是一个公式，$\theta$ 是一个代换，则 $\phi\theta$ 是一个公式。在该公式中，所有 $x_i$ 的出现都被替换为 $t_i$。我们也将单个的代换 $\theta\{x/t\}$ 记作 $\theta_{t}^{x}$。

### 2.3. 语义

在命题逻辑中，可以使用真值表或真假赋值来计算一个公式的真假值。其中，只需要关注命题符号的含义以及命题联结词的含义。在一阶逻辑中，还需要考虑关系符号、函数符号、变元符号、个体符号的含义。

这些符号的含义与论域有关。给定论域 $D$，解释是一个映射，把个体符号映射为 $D$ 中的对象，把 $n$ 元函数符号映射为从 $D^n$ 到 $D$ 的函数，把 $n$ 元关系符号映射为 $D$ 上的 $n$ 元关系。另一方面，对于每个自由变元，可以把论域中的对象指派给它。因此，指派也是一个映射。在本门课中，把解释和指派统称作赋值，记作 $v$。

**解释/指派**：给定论域 $D$，我们有：

- 对于个体常元 $a$，把它解释为论域中的个体，记作 $v(a) \in D$。
- 对于 $n$ 元函数符号 $f$，把它解释为从 $D^n$ 到 $D$ 的函数，记作 $v(f): D^n \mapsto D$。
- 对于 $n$ 元谓词符号 $F$，把它解释为 $D$ 上的 $n$ 元关系，记作 $v(F) \subseteq D^n$。
- 对于自由变元 $x$，给它指派 $D$ 中的个体，记作 $v(x) \in D$。

通常把 $v(a)$, $v(f)$, $v(F)$, $v(x)$ 分别记作 $a^v$, $f^v$, $F^v$, $x^v$。

**项的值**：一阶逻辑语言的项在以 $D$ 为论域的赋值 $v$ 之下的值递归地定义如下：

1. $a^v, x^v \in D$。
2. $f(t_1, \ldots, t_n)^v = f^v(t_1^v, \ldots, t_n^v)$。

约定符号：设 $v$ 是以 $D$ 为论域的赋值，$a \in D$，$x$ 是自由变元符号。我们用 $v(x/a)$ 表示一个以 $D$ 为论域的赋值，它除了 $x^{v(x/a)} = a$ 之外，和 $v$ 完全相同。

**公式的值**：一阶公式的真假值可递归地定义如下：

- $F(t_1, \ldots, t_n)^v = \begin{cases} 1 \text{, if } \langle t_1^v, \ldots, t_n^v \rangle \in F^v \\ 0\text{, otherwise}. \end{cases}$；
- $(t_1 \equiv t_2)^v = \begin{cases} 1\text{, if } t_1^v \text{ and } t_2^v \text{ are the same element in } D \\ 0\text{, otherwise}. \end{cases}$；
- $(\neg\phi)^v = \begin{cases} 1\text{, if } \phi^v = 0 \\ 0\text{, otherwise}. \end{cases}$；
- $(\phi \wedge \psi)^v = \begin{cases} 1\text{, if } \phi^v = \psi^v = 1 \\ 0\text{, otherwise}. \end{cases}$；
- $(\phi \vee \psi)^v = \begin{cases} 1\text{, if } \phi^v = 1 \text{ or } \psi^v = 1 \\ 0\text{, otherwise}. \end{cases}$；
- $(\phi \rightarrow \psi)^v = \begin{cases} 1\text{, if } \phi^v = 0 \text{ or } \psi^v = 1 \\ 0\text{, otherwise}. \end{cases}$；
- $(\phi \leftrightarrow \psi)^v = \begin{cases} 1\text{, if } \phi^v = \psi^v \\ 0\text{, otherwise}. \end{cases}$；
- $\forall x\phi^v = \begin{cases} 1\text{, if } \phi^{v(x/a)} = 1\text{, for any } a \in D \\ 0\text{, otherwise}. \end{cases}$；
- $\exists x\phi^v = \begin{cases} 1\text{, if there exists } a \in D\text{, such that } \phi^{v(x/a)} = 1 \\ 0\text{, otherwise}. \end{cases}$。

**例题**：给定公式 $\forall x (F(x) \rightarrow \exists y(G(y) \land H(x, y)))$ 和 $F(g(\mathrm{ZS}))$，设 $D = \{s_1, s_2, s_3, b_1, b_2, b_3\}$。构造一个赋值 $v$，使得：

- $\mathrm{ZS}^v = s_1$；
- $g^v = \{(s_1, s_2), (s_2, s_3)\}$；
- $F^v = \{s_1, s_2, s_3\}$；
- $G^v = \{b_1, b_2, b_3\}$；
- $H^v = \{(s_1, b_1), (s_1, b_2), (s_2, b_1), (s_3, b_3)\}$；
- $g(\mathrm{ZS})^v = g^v(\mathrm{ZS}^v) = g^v(s_1) = s_2$；
- $F(g(\mathrm{ZS}))^v = F^v(s_2) = 1$；

### 2.4. 逻辑推论

和命题逻辑对应，给定一组一节公式集合 $\Phi$ 作为前提，我们希望知道 $\Phi$ 是否在逻辑上蕴涵某个结论 $\phi$。

**逻辑推论**：设 $\Phi$ 是一组一阶公式集合，$\phi$ 是一个一阶公式。逻辑推论 $\Phi \models \phi$ 成立，当且仅当对于任意非空论域 $D$ 下的赋值 $v$，如果 $\Phi^v = 1$ 则 $\phi^v = 1$。

???- Info "例题"

    <img class="center-picture" src="./assets/2-2.webp" width=500 />

**可满足性和有效性**：设 $\psi$ 是一个一阶公式。

- $\psi$ 是有效的，即 $\models \psi$，当且仅当对于任何论域 $D$ 下任何赋值 $v$，$\psi^v = 1$。
- $\psi$ 是可满足的，当且仅当存在某个论域 $D$ 下的赋值 $v$ 使得 $\psi^v = 1$。

**定理**：常见的语义等价关系：

- $\neg \forall x \phi \models \exists x \neg \phi$
- $\neg \exists x \phi \models \forall x \neg \phi$
- $\forall y \phi \models \forall x \phi_x^y$ (设 $x$ 不在 $\phi$ 中出现)
- $\exists y \phi \models \exists x \phi_x^y$ (设 $x$ 不在 $\phi$ 中出现)
- $\phi \land \forall x \psi \models \forall x(\phi \land \psi)$ (设 $x$ 不在 $\phi$ 中出现)
- $\phi \land \exists x \psi \models \exists x(\phi \land \psi)$ (设 $x$ 不在 $\phi$ 中出现)
- $\phi \lor \forall x \psi \models \forall x(\phi \lor \psi)$ (设 $x$ 不在 $\phi$ 中出现)
- $\phi \lor \exists x \psi \models \exists x(\phi \lor \psi)$ (设 $x$ 不在 $\phi$ 中出现)

### 2.5. 前束范式

在将一阶逻辑的公式转化为范式的时候，我们先把其变成语义上等价的前束范式：

**前束范式**：称一阶逻辑公式 $\phi$ 为前束范式，当且仅当它有如下的形式：

$$Q_1x_1 \ldots Q_nx_n\phi^{\prime}$$

其中的 $Q_1 \ldots Q_n$ 是 $\forall$ 或 $\exists$，并且 $\phi^{\prime}$ 不含量词。

称 $Q_1x_1 \ldots Q_nx_n$ 为前束词，称 $\phi^{\prime}$ 为母式。

**例子**：比如我们可以将 $[\neg \exists x_1F(x_1) \lor \forall x_2G(x_2)] \land [F(x_3) \rightarrow \forall x_4H(x_4)]$ 变换为 $\forall x_1 \forall x_2 \forall x_4\{[\neg F(x_1) \lor G(x_2)] \land [\neg F(x_3) \lor H(x_4)]\}$。

### 2.6. 消解原理

在一阶逻辑中，我们需要处理公式中的变元和量词，和命题逻辑类似，我们也需要将公式转化为等价的子句形式。对于包含自由变元的字句进行消解的时候，如果这些字句都是全称量化的，那么我们可以去掉量词，因此，我们先考虑不包含量词的前束范式：

比如，$\{[P(x), \neg R(a, f(b, x))], [Q(x, y)]\}$ 表示的是 $\forall x \forall y \{[P(x) \lor \neg R(a, f(b, x))] \land Q(x, y)\}$。

**一阶消解推演规则**：给定两个子句 $c_1 \cup \{L_1\}$ 和 $c_2 \cup \{\overline{L_2}\}$，如果其没有公共变元，并且存在一个代换 $\theta$，使得 $L_1 \theta = L_2 \theta$，那么可以推出子句 $(c_1 \cup c_2) \theta$。这时我们说 $\theta$ 是 $L_1$ 和 $L_2$ 的合一。

运用这条规则，消解推演的定义和命题逻辑的相同，且 $\Phi \models_{\text{Res}} \bot$ 当且仅当 $\Phi \models_{\text{Res}} \bot$。

???- Info "例题"

    <img class="center-picture" src="./assets/2-3.webp" width=500 />

如果出现存在量化，也就是我们考虑对于包含存在量词的公式，我们之前没有办法将其转化为字句公式，那么我们可以引入斯科伦常元和斯科伦函数来解决这个问题。

**斯科伦常元/斯科伦函词**：如果我们考虑 $\exists x \phi(x)$，那么 $\phi$ 是可满足的，当且仅当对于某一个具体的 $a$，$\phi(a)$ 是可满足的。在这里，$a$ 是未出现过的新常元，称为**斯科伦常元**。另外，对于 $\forall x \exists y \phi(x, y)$，我们可以用 $f(x)$ 来代替 $y$，这样，$\forall x \exists y \phi(x, y)$ 是可满足的，当且仅当 $\forall x \phi(x, f(x))$ 是可满足的。在这里，$f$ 是未出现过的新函词，称为**斯科伦函词**。

**斯科伦化**：把 $\forall x_1 \forall x_2 \ldots \forall x_n \exists y \phi(x_1, x_2, \ldots, x_n, y)$ 变换为 $\forall x_1 \forall x_2 \ldots \forall x_n \phi(x_1, x_2, \ldots, x_n, f(x_1, x_2, \ldots, x_n))$。

如果 $\phi$ 是原有公式，$\phi^{\prime}$ 是包含斯科伦化的子句，那么 $\phi$ 在逻辑上不等值于 $\phi^{\prime}$。不过，$\phi$ 是可满足的，当且仅当 $\phi^{\prime}$ 是可满足的。这也是消解所真正需要的。

**定理**：这里 $a$ 是 $\phi$ 中未出现过的新常元，$f$ 是 $\phi$ 中未出现过的新 $n$ 元函词。

1. $\exists x \phi$ 是可满足的，当且仅当 $\phi_a^{x}$ 是可满足的；
2. $\forall x_1 \forall x_2 \ldots \forall x_n \exists y \phi$ 是可满足的，当且仅当 $\forall x_1 \forall x_2 \ldots \forall x_n \phi_{f(x_1, x_2, \ldots, x_n)}^{y}$ 是可满足的。

???- Info "证明"

    第一部分证明是简单的。对于第二部分，我们仅仅考虑 $n = 1$ 的情况，更一般的情况同理可证。

    设 $v$ 是以某个非空集合 $D$ 为论域的赋值，使得 $\forall x \exists y \phi$ 为真。那么，对于任意 $a \in D$，$(\exists y \phi)^{v/a} = 1$。从而，对于每一 $a$，存在 $a^{\prime} \in D$，使得 $\phi^{v(x/a, y/a^{\prime})} = 1$。现作 $D$ 上的函数 $f$，使得对于每一 $a \in D$，$f(a)$ 为使 $\phi^{v(x/a, y/a^{\prime})} = 1$ 的 $a^{\prime}$ 中的一个。考虑论域 $D$ 下的赋值 $v^{\prime}$，使得 $f^{v^{\prime}} = f$，而对其他符号，$v^{\prime}$ 与 $v$ 相同。显然，对于任意 $a \in D$，$\phi^{v^{\prime}(x/a, y/f(a))} = 1$。于是，我们有 $(\phi_{f(x)}^{y})^{v^{\prime}/a} = 1$ 对于任意 $a \in D$ 均成立，即 $\forall x \phi_{f(x)}^{y}$ 可满足。

    反之，如果有以 $D$ 为论域的赋值 $v$ 使得 $(\forall x \phi_{f(x)}^{y})^{v} = 1$，设 $f^v = f$ 为 $D$ 上的函数，那么，对于每一 $a \in D$，$(\phi_{f(x)}^{y})^{v(x/a)} = 1$ 或 $\phi^{v(x/a, y/f(a))} = 1$。换言之，对于每一 $a \in D$，$(\exists y \phi)^{v(x/a)} = 1$。从而，我们有 $(\forall x \exists y \phi)^{v} = 1$，即 $\forall x \exists y \phi$ 可满足。

### 2.7. 赫布兰德定理

**赫布兰德域**：给定一个子句集合 $S$，该集合的赫布兰德域（简称 H-域）是所有基项的集合：集合 $H$ 称为子句集 $S$ 的 H-域，如果 $H = \cup_{i=0}^{\infty}H_i$。其中，$H_i$ 递归地确定如下：

- $H_0 = \begin{cases}
\{a\}, & \text{当}S\text{中无任何常元出现时}，\\
\{c \mid c\text{为}S\text{中出现的常元}\}, & \text{否则}.
\end{cases}$
- $H_{i+1} = H_i \cup \{f(t_1,\ldots,t_n) \mid t_1,\ldots,t_n \in H_i, f\text{为}S\text{中出现的函数}\}$.

**赫布兰德基底**：给定一个子句集合 $S$，该集合的赫布兰德基底（简称 H-基底）是所有形如 $c\theta$ 的基原子公式的集合，其中 $c \in S$，$\theta$ 给 $c$ 中的变元指派 H-域中的元素。

???- Info "例题"

    <img class="center-picture" src="./assets/2-4.webp" width=500 />

**赫布兰德定理**：设 $S$ 是子句集。$S$ 是可满足的当且仅当它的 H-基底是可满足的。

### 2.8. Prolog
