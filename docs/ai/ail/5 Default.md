# 第五节：缺省逻辑

## 1. 缺省规则

缺省规则可以表示为 $\phi \colon \psi / \eta$，读作：如果可以证明 $\phi$ 且 $\psi$ 是一致的（也就是不能证明 $\neg \phi$，或者说例外 $\neg \psi$ 没有发生），那么可以推出 $\eta$。常见案例有原型推理和封闭世界推理：

- 原型推理：一个概念的大多数实例都具有某个特性，比如一般来说孩子都有父母可以表示为 $\text{child}(x) \colon \text{parent}(x) / \text{parent}(x)$；
- 封闭世界推理：如果一个句子为真，那么我们知道它为真，意思是不知道为真的句子都被假定为假的，可以表示为 $\top \colon \neg \phi / \neg \psi$。

## 2. 缺省逻辑的语法

**缺省逻辑的语言**：任何一阶语言都是缺省逻辑的语言，缺省逻辑中，所用到的项、公式等的定义与一阶语言里的相同。

**缺省规则**：缺省规则可以被形式化表示为 $\delta = \dfrac{\varphi \colon \psi}{\chi}$，其中 $\varphi$ 称为先决条件，为一阶逻辑公式；$\psi$ 称为缺省条件，为一阶逻辑公式；$\chi$ 称为 $\delta$ 的结论。使用 $\operatorname*{pre}(\delta)$ 表示 $\varphi$，$\operatorname*{cons}(\delta)$ 表示 $\chi$，$\operatorname*{just}(\delta)$ 表示 $\psi$。

给定一条缺省规则模式 $\delta = \varphi \colon \psi_1, \psi_2, \dots, \psi_n / \chi$，对于任何基代换 $\theta$，可以得到如下闭规则 $\delta \theta = \varphi \theta \colon \psi_1 \theta, \psi_2 \theta, \dots, \psi_n \theta / \chi \theta$。

**规范缺省规则**：当一条缺省规则的缺省条件和结论相同的时候，称之为规范的，形如 $\varphi \colon \chi / \chi$。

**缺省理论**：一个缺省理论是一个二元组 $T = \langle W, D \rangle$，其中 $W$ 是一个一阶逻辑公式集合，表示已经知道的或者约定的事实集合；$D$ 是一个可数的缺省规则集合。当 $D$ 中所有规则都是闭规则的时候，称 $T$ 是闭理论。

## 3. 缺省逻辑的语义

给定一个缺省理论，其语义指的是可以接受或者相信哪些语句，被接受或者相信的语句集合被称为外延。

### 3.1 外延的不动点定义

对于一个缺省理论，首先事实是可以相信的，如果一条缺省规则在某个背景下可以被应用，那么其结论也是可信的。如果相信了一组语句，那么我们也相信这组语句的所有演绎结果。除了上述三点，我们不相信其他无关的语句。

**缺省规则的应用**：

**极小扩充语句集合**：

**外延的不动点定义**：

**定理 1**：

**定理 2**：闭缺省理论 $T = \langle W, D \rangle$ 有不一致的外延当且仅当 $W$ 不一致。

**定理 3**：任何正规缺省理论都有一个外延。



### 3.2 外延的操作定义

给定一个缺省理论 $T = \langle W, D \rangle$，把一个缺省规则的序列记为 $\Pi = \left(\delta_1, \delta_2, \dots, \delta_n\right)$，其中每一条规则最多在 $\Pi$ 中出现一次，这个序列可以看作规则实施的顺序。

为了定义基于过程的外延，采用下面符号规定：

- 给定 $\Pi$，定义 $\Pi[k]$ 为 $\Pi$ 的长度为 $k$ 的初始段；
- 使用 $\operatorname*{In}(\Pi) = \operatorname*{Th}\left(W \cup \{ \operatorname*{cons}(\delta) \mid \delta \in \Pi \} \right)$ 表示实施 $\Pi$ 中的规则而得到的结论的集合；
- 使用 $\operatorname*{Out}(\Pi) = \left\{\neg \psi \mid \psi \in \operatorname*{just}(\delta), \delta \in \Pi \right\}$ 表示实施 $\Pi$ 的规则后不能为真的公式的集合。

**缺省规则的可应用性**：

**过程**：

**外延的操作定义**：设 $T = \langle W, D \rangle$ 是一个缺省理论，一组公式集合 $E$ 是 $T$ 的一个外延当且仅当存在一个成功且封闭的 $T$ 的过程 $\Pi$ 使得 $E = \operatorname*{In}(\Pi)$。

**过程树**：


## 4. 缺省证明

**规范缺省理论**：

**缺省证明**：

**定理 4**：




## 5. 怀疑的结论或轻信的结论

对于缺省理论 $T = \langle W, D \rangle$，使用 $\operatorname*{Ext}(T)$ 表示 $T$ 的所有外延的集合。

**怀疑与轻信**：设 $T = \langle W, D \rangle$ 是一个缺省理论，$\phi$ 为一个一阶命题，那么 $T$ 怀疑推出 $\phi$ 当且仅当对于 $T$ 的所有外延，$\phi$ 都在该外延中，也就是 $\phi \in \cap_{E\in \operatorname*{Ext}(T)} E$。$T$ 轻信推出 $\phi$ 当且仅当存在某一个外延 $E$ 使得 $\phi \in E$，也就是 $\phi \in \cup_{E\in \operatorname*{Ext}(T)} E$。
