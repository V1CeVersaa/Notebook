# Chapter 5: 稳定性

稳定性相关理论也称为扰动敏感性分析/Pertrubation Sensitivity。上一章介绍的泛化误差界主要基于不同的假设空间复杂度度量，比如增长函数、VC 维和 Rademacher 复杂度等，与具体的学习算法无关。这些泛化误差界保证了有限 VC 维学习方法的泛化性，但不能应用于无限 VC 维的学习方法。本章介绍一种新的分析工具：算法的稳定性/Stability。直观而言，稳定性刻画了训练集的扰动对算法结果的影响。

## 1. 基本概念

考虑样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$ 和标记空间 $\mathcal{Y} \subseteq \mathbb{R}$，假设 $\mathcal{D}$ 是空间 $\mathcal{X} \times \mathcal{Y}$ 上的一个联合分布。训练集 $D = \{(\boldsymbol{x}_1, y_1),(\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$ 基于分布 $\mathcal{D}$ 独立同分布采样所得。记 $\boldsymbol{z} = (\boldsymbol{x}, y)$ 和 $\boldsymbol{z}_i = (\boldsymbol{x}_i, y_i)$。在稳定性研究中，一般考虑训练集 $D$ 的两种扰动：移除样本和替换样本，其定义如下：

- $D^{\setminus i}$ 表示移除训练集 $D$ 中第 $i$ 个样本而得到的数据集，即

    $$D^{\setminus i} = \{\boldsymbol{z}_1, \boldsymbol{z}_2,\ldots,\boldsymbol{z}_{i-1},\boldsymbol{z}_{i+1},\ldots,\boldsymbol{z}_m\};$$

- $D^{i,\boldsymbol{z}^{\prime}}$ 表示将训练集 $D$ 中第 $i$ 个样本 $\boldsymbol{z}_i = (\boldsymbol{x}_i, y_i)$ 替换为 $\boldsymbol{z}_i^{\prime} = (\boldsymbol{x}_i^{\prime}, y_i^{\prime})$ 所得的数据集，即

    $$D^{i,\boldsymbol{z}^{\prime}} = \{\boldsymbol{z}_1, \boldsymbol{z}_2,\ldots,\boldsymbol{z}_{i-1},\boldsymbol{z}_i^{\prime}, \boldsymbol{z}_{i+1},\ldots,\boldsymbol{z}_m\}.$$

给定学习算法 $\mathfrak{L}$，令 $\mathfrak{L}_D : \mathcal{X} \mapsto \mathcal{Y}$ 表示 $\mathfrak{L}$ 基于训练集 $D$ 学习所得的**输出函数/Output Function**，本章考虑输出函数 $\mathfrak{L}_D$ 与训练集 $D$ 有关，但与 $D$ 中样本的顺序无关。对于分类问题，输出函数可以称为分类器或者假设。

为衡量输出函数 $\mathfrak{L}_D$ 在样本 $\boldsymbol{z} = (\boldsymbol{x}, y)$ 上的性能，如预测能力等，通常引入一个损失函数 $\ell$。针对不同的学习任务可考虑不同的损失函数 $\ell$，例如，对分类问题一般考虑 0/1 损失函数

$$\ell(\mathfrak{L}_D,\boldsymbol{z}) = \mathbb{I}(\mathfrak{L}_D(\boldsymbol{x}) \neq y);$$

对回归问题一般考虑平方函数

$$\ell(\mathfrak{L}_D,\boldsymbol{z}) = (\mathfrak{L}_D(\boldsymbol{x}) - y)^2.$$

通常假设损失函数 $\ell$ 是非负有上界的，即存在 $M > 0$，对任意数据集 $D$ 和样本 $\boldsymbol{z}$ 有 $\ell(\mathfrak{L}_D,\boldsymbol{z}) \in [0, M]$ 成立。

为衡量输出函数 $\mathfrak{L}_D$ 在数据集或数据分布下的性能，下面定义三种常用的风险/Risk：

- 函数 $\mathfrak{L}_D$ 在数据集 $D$ 上的性能被称为**经验风险/Empirical Risk**，即

    $$\widehat{R}(\mathfrak{L}_D) = \frac{1}{m}\sum_{i=1}^m \ell(\mathfrak{L}_D,\boldsymbol{z}_i).$$

- 函数 $\mathfrak{L}_D$ 在数据分布 $\mathcal{D}$ 上的性能被称为**泛化风险/Generalization Risk**，即

    $$R(\mathfrak{L}_D) = \mathbb{E}_{\boldsymbol{z}\sim\mathcal{D}}[\ell(\mathfrak{L}_D,\boldsymbol{z}).$$

- 给定数据集 $D$，**留一风险/Leave-One-Out Risk** 为

    $$R_{loo}(\mathfrak{L}_D) = \frac{1}{m}\sum_{i=1}^m \ell(\mathfrak{L}_{D^{\setminus i}},\boldsymbol{z}_i).$$

**引理 5.1**：对任意数据集 $D$ 和 $i \in [m]$，有

$$\begin{aligned}
\mathbb{E}_D[R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D)] &= \mathbb{E}_{D,\boldsymbol{z}_i^{\prime}}[\ell(\mathfrak{L}_D,\boldsymbol{z}_i^{\prime}) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z}_i^{\prime})],\\
\mathbb{E}_D[R(\mathfrak{L}_{D^{\setminus i}}) - R_{loo}(\mathfrak{L}_D)] &= 0,\\
\mathbb{E}_D[R(\mathfrak{L}_D) - R_{loo}(\mathfrak{L}_D)] &= \mathbb{E}_{D,\boldsymbol{z}}[\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{\setminus i}},\boldsymbol{z}_i)].
\end{aligned}$$

???- Info "证明"

    根据泛化风险可知

    $$\mathbb{E}_D[R(\mathfrak{L}_D)] = \mathbb{E}_{D,\boldsymbol{z}}[\ell(\mathfrak{L}_D,\boldsymbol{z})] = \mathbb{E}_{D,\boldsymbol{z}_i^{\prime}}[\ell(\mathfrak{L}_D,\boldsymbol{z}_i^{\prime})].$$

    根据经验风险可得

    $$\mathbb{E}_D[\widehat{R}(\mathfrak{L}_D)] = \frac{1}{m}\sum_{j=1}^m \mathbb{E}_D[\ell(\mathfrak{L}_D,\boldsymbol{z}_j)] = \mathbb{E}_D[\ell(\mathfrak{L}_D,\boldsymbol{z}_i)].$$

    将 $\boldsymbol{z}_i$ 替换为 $\boldsymbol{z}_i^{\prime}$，有

    $$\mathbb{E}_D[\widehat{R}(\mathfrak{L}_D)] = \mathbb{E}_{D,\boldsymbol{z}_i^{\prime}}[\ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z}_i^{\prime})].$$

    结合上述两式可得第一个等式。同理可证第二和第三个等式。

根据第一个和第三个式子，我们可以知道，经验风险和留一风险可看作泛化风险的经验估计。对于经验风险最小化的学习算法，其经验风险是泛化风险的一种较为乐观的估计。根据第二个式子可知留一风险是泛化风险的一种无偏估计，为使用留一法评估学习方法的泛化性提供了保障。

下面介绍不同的稳定性概念，主要包括均匀稳定性/Uniform Stability 和假设稳定性/Hypothesis Stability。

- **替换样本均匀稳定性**：对任意数据集 $D$ 和样本 $\boldsymbol{z},\boldsymbol{z}^{\prime} \in \mathcal{X} \times \mathcal{Y}$，若学习算法 $\mathfrak{L}$ 满足

    $$|\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}^{\prime}}},\boldsymbol{z})| \leq \beta \quad (i \in [m]),$$

    则称算法 $\mathfrak{L}$ 具有关于损失函数 $\ell$ 的替换样本 $\beta$-均匀稳定性。

- **移除样本均匀稳定性**：对任意数据集 $D$ 和样本 $\boldsymbol{z} \in \mathcal{X} \times \mathcal{Y}$，若学习算法 $\mathfrak{L}$ 满足

    $$|\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{\setminus i}},\boldsymbol{z})| \leq \gamma \quad (i \in [m]),$$

    则称算法 $\mathfrak{L}$ 具有关于损失函数 $\ell$ 的移除样本 $\gamma$-均匀稳定性。

- **替换样本假设稳定性**：若学习算法 $\mathfrak{L}$ 满足

    $$\mathbb{E}_{D,\boldsymbol{z}_i^{\prime}\sim\mathcal{D}^{m+1}}[|\ell(\mathfrak{L}_D,\boldsymbol{z}_i) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z}_i)|] \leq \beta \quad (i \in [m]),$$

    则称算法 $\mathfrak{L}$ 具有关于损失函数 $\ell$ 的替换样本 $\beta$-假设稳定性。

若算法 $\mathfrak{L}$ 具有移除样本 $\gamma$-均匀稳定性，则有

$$|\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}^{\prime}}},\boldsymbol{z})| \leq |\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{\setminus i}},\boldsymbol{z})| + |\ell(\mathfrak{L}_{D^{i,\boldsymbol{z}^{\prime}}},\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{\setminus i}},\boldsymbol{z})| \leq 2\gamma.$$

从而证明了算法 $\mathfrak{L}$ 具有替换样本 $2\gamma$-均匀稳定性。因此移除样本均匀稳定性可推导出替换样本均匀稳定性。

假设稳定性是对均匀稳定性的放松，均匀稳定性要求对任意的数据集 $D$ 和样本 $\boldsymbol{z}$ 有对应的不等式成立，这是一个较强的条件。我们适当放松这个条件：对数据集 $D$ 和样本 $\boldsymbol{z}$ 取期望，在期望条件下考虑训练集的扰动对算法输出函数的影响，就产生了假设稳定性。

一般而言，替换样本 $\beta$-均匀稳定性中的系数 $\beta$ 与训练集的大小 $m$ 相关，即 $\beta = \beta(m)$。若算法 $\mathfrak{L}$ 满足

$$\lim_{m\to\infty} \beta = \lim_{m\to\infty} \beta(m) = 0,$$

则称算法 $\mathfrak{L}$ 是稳定的/Stable。直观而言，均匀稳定性确保了当训练数据足够多时，替换一个样本对学习算法输出函数的影响较小。

## 2. 重要性质

### 2.1 稳定性和泛化性

泛化性研究通过训练数据学得的输出函数能否很好地适用于未见过的新数据，这是机器学习关心的根本问题。第 4 章主要从函数空间复杂度来研究泛化性，与具体学习算法无关。本节从算法稳定性的角度来研究泛化性，完全从算法自身的属性研究泛化性，与函数空间复杂度无关，因此本节的研究可用于无限函数空间复杂度的学习算法。

我们分别对具有均匀稳定性的学习算法和具有假设稳定性的学习算法给出泛化性分析。


**定理 5.1**：给定学习算法 $\mathfrak{L}$ 和数据集 $D = \{\boldsymbol{z}_1, \boldsymbol{z}_2,\ldots,\boldsymbol{z}_m\}$，假设损失函数 $\ell(\cdot,\cdot) \in [0, M]$，若学习算法 $\mathfrak{L}$ 具有替换样本 $\beta$-均匀稳定性，则对任意 $\delta \in (0,1)$，以至少 $1 - \delta$ 的概率有

$$R(\mathfrak{L}_D) \leq \widehat{R}(\mathfrak{L}_D) + \beta + (2m\beta + M)\sqrt{\frac{\ln(1/\delta)}{2m}};$$

若学习算法 $\mathfrak{L}$ 具有移除样本 $\gamma$-均匀稳定性，则对任意 $\delta \in (0,1)$，以至少 $1 - \delta$ 的概率有

$$R(\mathfrak{L}_D) \leq R_{loo}(\mathfrak{L}_D) + \gamma + (4m\gamma + M)\sqrt{\frac{\ln(1/\delta)}{2m}}.$$

???- Info "证明"

    首先设函数

    $$\Phi(D) = \Phi(\boldsymbol{z}_1,\boldsymbol{z}_2,\ldots,\boldsymbol{z}_m) = R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D).$$

    对任意 $i \in [m]$，根据引理 5.1 第一个式子可得

    $$\mathbb{E}_D[\Phi(D)] = \mathbb{E}_D[R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D)] = \mathbb{E}_{D,\boldsymbol{z}_i^{\prime}}[\ell(\mathfrak{L}_D,\boldsymbol{z}_i^{\prime}) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z}_i^{\prime})] \leq \beta.$$

    给定样本 $\boldsymbol{z}_i^{\prime} \in \mathcal{X} \times \mathcal{Y}$，有

    $$\left|\Phi(D) - \Phi(D^{i,\boldsymbol{z}_i^{\prime}})\right| \leq \left|R(\mathfrak{L}_D) - R(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}})\right| + \left|\widehat{R}(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}}) - \widehat{R}(\mathfrak{L}_D)\right|.$$

    对于替换样本 $\beta$-均匀稳定性的算法 $\mathfrak{L}$，有

    $$\begin{aligned}
        \left|\widehat{R}(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}}) - \widehat{R}(\mathfrak{L}_D)\right| &\leq \frac{\left|\ell(\mathfrak{L}_D,\boldsymbol{z}_i) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z}_i^{\prime})\right|}{m} + \sum_{j\neq i}\frac{\left|\ell(\mathfrak{L}_D,\boldsymbol{z}_j) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z}_j)\right|}{m} \leq \beta + M/m,
    \end{aligned}$$

    以及进一步有

    $$\left|R(\mathfrak{L}_D) - R(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}})\right| = \left|\mathbb{E}_{\boldsymbol{z}\sim\mathcal{D}}[\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_{D^{i,\boldsymbol{z}_i^{\prime}}},\boldsymbol{z})]\right| \leq \beta.$$

    将上述两式代入第三式可得

    $$\left|\Phi(D) - \Phi(D^{i,\boldsymbol{z}_i^{\prime}})\right| \leq 2\beta + M/m.$$

    结合 $\mathbb{E}_D[\Phi(D)] \leq \beta$ 和上式，将 McDiarmid 不等式应用于函数 $\Phi(D)$，对任意 $\epsilon > 0$ 有

    $$\begin{aligned}
        P(R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D) \geq \beta + \epsilon) &= P(\Phi(D) \geq \beta + \epsilon) \\ 
        &\leq P(\Phi(D) \geq \mathbb{E}[\Phi(D)] + \epsilon) \leq \exp\left(\frac{-2m\epsilon^2}{(2m\beta + M)^2}\right).
    \end{aligned}$$

    令 $\delta = \exp(-2m\epsilon^2/(2m\beta + M)^2)$，解出 $\epsilon = (2m\beta + M)\sqrt{\ln(1/\delta)/2m}$，代入上式可得，以至少 $1 - \delta$ 的概率有

    $$R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D) < \beta + (2m\beta + M)\sqrt{\frac{\ln(1/\delta)}{2m}},$$

    这就证明了第一部分，第二部分的证明思路类似。

上述定理给出了基于替换样本均匀稳定性的泛化界，类似可给出基于移除样本均匀稳定性的泛化界。

根据定理 5.1 第一式可知：

- 若 $\lim_{m\to\infty} m\beta = c \in (0,\infty)$，则有 $R(\mathfrak{L}_D) \leq \widehat{R}(\mathfrak{L}_D) + O(1/\sqrt{m})$ 成立，此时基于稳定性的泛化界与基于 VC 维或 Rademacher 复杂度的泛化界是一致的；
- 若 $\lim_{m\to\infty} m\beta = 0$，则有 $R(\mathfrak{L}_D) \leq \widehat{R}(\mathfrak{L}_D)$，从而保证了泛化风险不会超过在训练集上的经验风险；
- 若 $\lim_{m\to\infty} m\beta = \infty$，则不能对算法的泛化性能有任何保障。

下面我们探讨假设稳定性，给出替换样本假设稳定性的泛化性分析，类似可考虑移除样本假设稳定性。

**定理 5.2**：给定学习算法 $\mathfrak{L}$ 和训练集 $D = \{\boldsymbol{z}_1,\boldsymbol{z}_2,\ldots,\boldsymbol{z}_m\}$，假设损失函数 $\ell(\cdot,\cdot) \in [0, M]$，若学习算法 $\mathfrak{L}$ 具有替换样本 $\beta$-假设稳定性，则有

$$\mathbb{E}_{D\sim\mathcal{D}^m}[(R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D))^2] \leq 4M\beta + \frac{M^2}{m}.$$

???- Info "证明：不断利用独立同分布性质变换形式"

    根据泛化风险和经验风险的定义可知

    $$\begin{aligned}
    \mathbb{E}_D[(R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D))^2] &= \mathbb{E}_D\left[\left(R(\mathfrak{L}_D) - \frac{1}{m}\sum_{i=1}^m \ell(\mathfrak{L}_D,\boldsymbol{z}_i)\right)^2\right]\\
    &= \frac{1}{m^2}\sum_{i\neq j}\mathbb{E}_D[(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_i))(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_j))]\\
    &+ \frac{1}{m^2}\sum_{i=1}^m\mathbb{E}_D[(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_i))^2].
    \end{aligned}$$

    根据损失函数 $\ell(\cdot,\cdot) \in [0,M]$ 可得 $R(\mathfrak{L}_D) = \mathbb{E}_{\boldsymbol{z}\sim\mathcal{D}}[\ell(\mathfrak{L}_D,\boldsymbol{z})] \in [0,M]$，以及

    $$\frac{1}{m^2}\sum_{i=1}^m\mathbb{E}_D[(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_i))^2] \leq \frac{M^2}{m}.$$

    根据训练集 $D$ 的独立同分布假设有

    $$\begin{aligned}
    &\frac{1}{m^2}\sum_{i\neq j}\mathbb{E}_D[(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_i))(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_j))]\\
    &= (1-1/m)\mathbb{E}_D[(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_1))(R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D,\boldsymbol{z}_2))]\\
    &\leq \mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_D,\boldsymbol{z})\ell(\mathfrak{L}_D,\boldsymbol{z}') - \ell(\mathfrak{L}_D,\boldsymbol{z})\ell(\mathfrak{L}_D,\boldsymbol{z}_1)\\
    &\quad+\ell(\mathfrak{L}_D,\boldsymbol{z}_1)\ell(\mathfrak{L}_D,\boldsymbol{z}_2) - \ell(\mathfrak{L}_D,\boldsymbol{z}')\ell(\mathfrak{L}_D,\boldsymbol{z}_2)].
    \end{aligned}$$

    其中的不等式利用了 $1 - 1/m \leq 1$ 且

    $$R(\mathfrak{L}_D) - \ell(\mathfrak{L}_D, \boldsymbol{z}_1) = \mathbb{E}_{\boldsymbol{z}\sim\mathcal{D}}[\ell(\mathfrak{L}_D,\boldsymbol{z})] - \ell(\mathfrak{L}_D,\boldsymbol{z}_1) = \mathbb{E}_{\boldsymbol{z}\sim\mathcal{D}}[\ell(\mathfrak{L}_D,\boldsymbol{z}) - \ell(\mathfrak{L}_D,\boldsymbol{z}_1)]$$

    引入数据集 $D^{1,\boldsymbol{z}} = \{\boldsymbol{z},\boldsymbol{z}_2,\ldots,\boldsymbol{z}_n\}$，根据独立同分布假设有

    $$\mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_D,\boldsymbol{z})\ell(\mathfrak{L}_D,\boldsymbol{z}')] = \mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}_1)\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}')].$$

    进一步利用 $\ell(\cdot,\cdot) \in [0,M]$ 和替换样本 $\beta$-假设稳定性可得

    $$\begin{aligned}
    &\mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_D,\boldsymbol{z})\ell(\mathfrak{L}_D,\boldsymbol{z}') - \ell(\mathfrak{L}_D,\boldsymbol{z}')\ell(\mathfrak{L}_D,\boldsymbol{z}_1)]\\
    &= \mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}_1)\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}') - \ell(\mathfrak{L}_D,\boldsymbol{z}')\ell(\mathfrak{L}_D,\boldsymbol{z}_1)]\\
    &\leq \mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[|\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}')| \times |\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}_1) - \ell(\mathfrak{L}_D,\boldsymbol{z}_1)|]\\
    &+\mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[|\ell(\mathfrak{L}_D,\boldsymbol{z}_1)| \times |\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}}},\boldsymbol{z}') - \ell(\mathfrak{L}_D,\boldsymbol{z}')|] \leq 2M\beta.
    \end{aligned}$$

    引入数据集 $D^{1,\boldsymbol{z}'} = \{\boldsymbol{z}',\boldsymbol{z}_2,\ldots,\boldsymbol{z}_n\}$，同理可证

    $$\begin{aligned}
    &\mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_D,\boldsymbol{z}_1)\ell(\mathfrak{L}_D,\boldsymbol{z}_2) - \ell(\mathfrak{L}_D,\boldsymbol{z}')\ell(\mathfrak{L}_D,\boldsymbol{z}_2)]\\
    &= \mathbb{E}_{D,\boldsymbol{z},\boldsymbol{z}'}[\ell(\mathfrak{L}_{D},\boldsymbol{z}_1)\ell(\mathfrak{L}_{D},\boldsymbol{z}_2) - \ell(\mathfrak{L}_{D^{1,\boldsymbol{z}'}},\boldsymbol{z}_1)\ell(\mathfrak{L}_{D^{1,\boldsymbol{z}'}},\boldsymbol{z}_2)] \leq 2M\beta. 
    \end{aligned}$$

    结合上述式子，定理 5.2 得证。

过拟合/Overfitting 是泛化性研究中一个重要的概念。给定训练集 $D$，若算法 $\mathfrak{L}$ 输出函数的经验风险较小、而泛化风险较大，则称过拟合现象，即经验风险与泛化风险之间的差距 $\mathbb{E}_{D\sim\mathcal{D}^m}[R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D)]$ 较大。

稳定性研究训练集 $D$ 的扰动对算法 $\mathfrak{L}$ 输出函数的影响，稳定的算法要求 $|\ell(\mathfrak{L}_{D^{i,z'}}, z_i)-\ell(\mathfrak{L}_D, z_i)|$ 的值较小，其中 $D^{i,z'} = \{z_1,\ldots,z_{i-1}, z', z_{i+1},\ldots,z_m\}$ 与样本 $z_i$ 无关。此时 $\ell(\mathfrak{L}_{D^{i,z'}}, z_i)$ 可看作泛化风险，同理可将 $\ell(\mathfrak{L}_D, z_i)$ 看作经验风险。因此过拟合与稳定性之间存在一定的关系，有如下定理。

**定理 5.3**：数据集 $D = \{z_1, z_2,\ldots,z_m\}$ 和样本 $z'$ 都是基于分布 $\mathcal{D}$ 独立同分布采样所得，令 $\mathcal{U}(m)$ 表示在集合 $[m] = \{1, 2,\ldots,m\}$ 上的均匀分布，则对任何学习算法 $\mathfrak{L}$ 有

$$\mathbb{E}_{D\sim\mathcal{D}^m}[R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D)] = \mathbb{E}_{D,z'\sim\mathcal{D}^{m+1},i\sim\mathcal{U}(m)}[\ell(\mathfrak{L}_{D^{i,z'}}, z_i) - \ell(\mathfrak{L}_D, z_i)].$$

???- Info "证明"

    根据样本 $z'$ 和数据集 $D$ 的独立同分布假设可知

    $$\begin{aligned}
    \mathbb{E}_{D\sim\mathcal{D}^m}[R(\mathfrak{L}_D)] &= \mathbb{E}_{D,z'\sim\mathcal{D}^{m+1}}[\ell(\mathfrak{L}_D, z')]\\
    &= \mathbb{E}_{D,z'\sim\mathcal{D}^{m+1},i\sim\mathcal{U}(m)}[\ell(\mathfrak{L}_{D^{i,z'}}, z_i)].
    \end{aligned}$$

    另一方面有 $\mathbb{E}_{D\sim\mathcal{D}^m}[\widehat{R}(\mathfrak{L}_D)] = \mathbb{E}_{D\sim\mathcal{D}^m,i\sim\mathcal{U}(m)}[\ell(\mathfrak{L}_D, z_i)]$，定理得证。

根据定理 5.3 可知，不出现过拟合现象的充要条件是算法在期望情况下具有替换样本稳定性。当学习算法 $\mathfrak{L}$ 是稳定的，替换训练数据集的单个样本不会导致算法的输出函数发生较大变化，即 $\ell(\mathfrak{L}_{D^{i,z'}}, z_i) - \ell(\mathfrak{L}_D, z_i)$ 很小，因此其期望很小，这样我们就可以保证经验风险和泛化风险差的期望很小，由此不会发生过拟合现象，反之结论依然成立。

### 2.2 稳定性与可学性

本节研究经验风险最小化/ERM 算法的稳定性与可学性的关系。首先给出 ERM 算法的定义。

**定义 5.4**（ERM 算法）：给定函数空间 $\mathcal{H} = \{h: \mathcal{X} \mapsto \mathcal{Y}\}$ 和损失函数 $\ell$，对任意训练集 $D$，若学习算法 $\mathfrak{L}$ 在 $D$ 上学习得到的输出函数 $\mathfrak{L}_D$ 满足经验风险最小化，即

$$\mathfrak{L}_D \in \arg\min_{h\in\mathcal{H}} \widehat{R}_D(h),$$

则称算法 $\mathfrak{L}$ 满足经验风险最小化原则，简称 ERM 算法。

对 ERM 算法，稳定性与可学性有如下关系：

**定理 5.4**：若学习算法 $\mathfrak{L}$ 是 ERM 的、且具有替换样本 $\beta$-均匀稳定性 (其中 $\beta = 1/m$)，则 (学习算法 $\mathfrak{L}$ 所考虑的) 函数空间 $\mathcal{H}$ 是不可知 PAC 可学的。

???- Info "证明"

    令 $h^*$ 表示 $\mathcal{H}$ 中具有最小泛化风险的函数，即

    $$R(h^*) = \min_{h\in\mathcal{H}} R(h).$$

    为证明不可知 PAC 可学性，需验证：存在多项式函数 $\text{poly}(\cdot,\cdot,\cdot,\cdot)$，使得当训练集的个数 $m \geq \text{poly}(1/\epsilon, 1/\delta, d, \text{size}(c))$ 时，有

    $$P(R(\mathfrak{L}_D) - R(h^*) \leq \epsilon) \geq 1 - \delta.$$

    给定一个学习问题，参数 $d$ 和 size$(c)$ 根据学习问题变为确定的常数，因此只需证明存在多项式函数 poly($\cdot,\cdot$)，当 $m \geq \text{poly}(1/\epsilon, 1/\delta)$ 时有上式成立。首先有

    $$R(\mathfrak{L}_D) - R(h^*) = (R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D)) + (\widehat{R}(\mathfrak{L}_D) - \widehat{R}(h^*)) + (\widehat{R}(h^*) - R(h^*)).$$

    因为算法 $\mathfrak{L}_D$ 具有替换样本 $\beta$-均匀稳定性，其中 $\beta = 1/m$，根据定理 5.1 可知，对任意 $\delta \in (0,1)$，以至少 $1 - \delta/2$ 的概率有

    $$R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D) \leq \frac{1}{m} + (2 + M)\sqrt{\frac{\ln(2/\delta)}{2m}}.$$

    考虑到函数 $\mathfrak{L}_D$ 是在训练集 $D$ 上经验风险最小化所得，有

    $$\widehat{R}(\mathfrak{L}_D) \leq \widehat{R}(h^*).$$

    根据 Hoeffding 不等式可知，以至少 $1 - \delta/2$ 的概率有

    $$\widehat{R}(h^*) - R(h^*) \leq \sqrt{\frac{\ln(2/\delta)}{m}}.$$

    结合上述式子，根据联合界不等式可知，以至少 $1 - \delta$ 的概率有

    $$R(\mathfrak{L}_D) - R(h^*) \leq \frac{1}{m} + (2 + M)\sqrt{\frac{\ln(2/\delta)}{2m}} + \sqrt{\frac{\ln(2/\delta)}{m}}.$$

    不妨令

    $$\epsilon = \frac{1}{m} + (2 + M)\sqrt{\frac{\ln(2/\delta)}{2m}} + \sqrt{\frac{\ln(2/\delta)}{m}},$$

    从上式求解出 $m(\epsilon,\delta) = O(\frac{1}{\epsilon^2}\ln\frac{1}{\delta})$。因此当 $m \geq m(\epsilon,\delta)$ 时有

    $$P(R(\mathfrak{L}_D) - R(h^*) \leq \epsilon) \geq 1 - \delta.$$

    考虑到 $\ln(1/\delta) \leq 1/\delta$，因此存在多项式 poly$(1/\epsilon, 1/\delta) \geq m(\epsilon,\delta)$，使得当 $m \geq \text{poly}(1/\epsilon, 1/\delta)$ 时有上式成立，定理得证。
    
稳定性研究训练集的随机扰动对学习结果的影响，其本身与函数空间 $\mathcal{H}$ 无关，但一个问题的可学性与函数空间 $\mathcal{H}$ 相关。在定理 5.4 中稳定性与可学性通过经验风险最小化联系起来，从而将稳定性与函数空间 $\mathcal{H}$ 关联起来。

## 3. 分析实例

头三个例子是换汤不换药的，并且聚焦于均匀稳定性，只有最后一个例子是假设稳定性的分析。

### 3.1 支持向量机

考虑二分类支持向量机，给定样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$，标记空间 $\mathcal{Y} = \{-1,+1\}$，以及训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$，给定样本 $(\boldsymbol{x},y) \in \mathcal{X} \times \mathcal{Y}$ 和 $\boldsymbol{w} \in \mathbb{R}^d$，考虑 hinge 函数，有

$$\ell_{\text{hinge}}(\boldsymbol{w}, (\boldsymbol{x}, y)) = \max(0,1 - y\boldsymbol{w}^{\text{T}}\boldsymbol{x}).$$

为便于讨论，本节考虑未使用核函数的支持向量机，即目标函数为

$$F_D(\boldsymbol{w}) = \frac{1}{m}\sum_{i=1}^m \max(0,1 - y_i\boldsymbol{w}^{\text{T}}\boldsymbol{x}_i) + \lambda\|\boldsymbol{w}\|^2,$$   

其中 $\boldsymbol{w} \in \mathbb{R}^d$，$\lambda$ 为正则化参数。

关于支持向量机的稳定性，有如下定理：

**定理 5.5**：给定常数 $r > 0$，考虑样本空间 $\mathcal{X} = \{\boldsymbol{x} \in \mathbb{R}^d: \|\boldsymbol{x}\| \leq r\}$，以及上面定义的优化目标函数，则支持向量机具有替换样本 $\beta$-均匀稳定性，其中 $\beta = r^2/(\lambda m)$。

???- Info "证明"

    给定数据集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$，对任意 $k \in [m]$，令 $D' = D^{k,z_k'}$ 表示训练集 $D$ 中第 $k$ 个样本被替换为 $z_k' = (\boldsymbol{x}_k', y_k')$ 得到的数据集。令 $\boldsymbol{w}_D$ 和 $\boldsymbol{w}_{D'}$ 分别表示优化目标函数 $F_D(\boldsymbol{w})$ 和 $F_{D'}(\boldsymbol{w})$ 所得的最优解，即

    $$\boldsymbol{w}_D \in \underset{\boldsymbol{w}}{\arg\min} F_D(\boldsymbol{w}), \quad \boldsymbol{w}_{D'} \in \underset{\boldsymbol{w}}{\arg\min} F_{D'}(\boldsymbol{w}).$$

    对任意样本 $(\boldsymbol{x},y)$，根据 Cauchy-Schwarz 不等式有

    $$|\max(0,1 - y\boldsymbol{w}_D^{\text{T}}\boldsymbol{x}) - \max(0,1 - y\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x})| \leq |(\boldsymbol{w}_D - \boldsymbol{w}_{D'})^{\text{T}}\boldsymbol{x}| \leq r\|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|.$$

    由于任意凸函数加入正则项 $\lambda\|\boldsymbol{w}\|^2$ 变成 $2\lambda$-强凸函数，从目标函数可知函数 $F_D(\boldsymbol{w})$ 和 $F_{D'}(\boldsymbol{w})$ 是 $2\lambda$-强凸函数，进一步有

    $$\begin{aligned}
        F_D(\boldsymbol{w}_{D'}) &\geq F_D(\boldsymbol{w}_D) + \lambda \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|^2, \\
        F_{D'}(\boldsymbol{w}_D) &\geq F_{D'}(\boldsymbol{w}_{D'}) + \lambda \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|^2.
    \end{aligned}$$

    将上述两式相加可得

    $$\begin{aligned}
        \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\| &\leq \frac{1}{2\lambda}(F_D(\boldsymbol{w}_{D'}) - F_D(\boldsymbol{w}_D) + F_{D'}(\boldsymbol{w}_D) - F_{D'}(\boldsymbol{w}_{D'})) \\ 
        &= \frac{1}{2\lambda m}(\ell_{\text{hinge}}(\boldsymbol{w}_{D'}, (\boldsymbol{x}_k, y_k)) - \ell_{\text{hinge}}(\boldsymbol{w}_D, (\boldsymbol{x}_k, y_k)) + \ell_{\text{hinge}}(\boldsymbol{w}_D, (\boldsymbol{x}_k', y_k')) - \ell_{\text{hinge}}(\boldsymbol{w}_{D'}, (\boldsymbol{x}_k', y_k'))) \\ 
        &\leq \frac{r}{\lambda m} \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|.
    \end{aligned}$$

    因此

    $$\|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\| \leq r/(\lambda m).$$

    也就是

    $$|\ell_{\text{hinge}}(\boldsymbol{w}_D, (\boldsymbol{x}, y)) - \ell_{\text{hinge}}(\boldsymbol{w}_{D'}, (\boldsymbol{x}, y))| \leq r^2/(\lambda m).$$

    由此可知支持向量机具有替换样本 $\beta$-均匀稳定性，其中 $\beta = r^2/(\lambda m)$。

上述定理最重要的内容是下面这个式子：

$$|\ell_{\text{hinge}}(\boldsymbol{w}_D, (\boldsymbol{x}, y)) - \ell_{\text{hinge}}(\boldsymbol{w}_{D'}, (\boldsymbol{x}, y))| \leq r^2/(\lambda m).$$

其描述了支持向量机的稳定性性质。对于有界的 hinge 函数 $\ell_{\text{hinge}}(\cdot,\cdot) \in [0,M]$，基于稳定性我们可进一步推导支持向量机的泛化性。

**推论 5.1**：给定常数 $r > 0$，考虑样本空间 $\mathcal{X} = \{\boldsymbol{x} \in \mathbb{R}^d: \|\boldsymbol{x}\| \leq r\}$ 和 hinge 函数 $\ell_{\text{hinge}}(\cdot,\cdot) \in [0,M]$，令 $\boldsymbol{w}_D$ 表示优化目标函数 $F_D(\boldsymbol{w})$ 所得的最优解。对任意 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率有

$$R(\boldsymbol{w}_D) \leq \widehat{R}(\boldsymbol{w}_D) + \frac{r^2}{m\lambda} + \left(\frac{2r^2}{\lambda} + M\right)\sqrt{\frac{\ln(1/\delta)}{2m}}.$$


???- Info "证明"

    根据定理 5.5 和对应式子可知支持向量机具有替换样本 $\beta$-均匀稳定性，其中 $\beta = r^2/(\lambda m)$。对于有界的 hinge 函数 $\ell_{\text{hinge}}(\cdot,\cdot) \in [0,M]$，根据定理 5.1 将 $\beta = r^2/(\lambda m)$ 代入即可完成证明。


### 3.2 支持向量回归

支持向量回归/Support Vector Regression/SVR 是支持向量机用于回归任务的经典算法。考虑样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$，标记空间 $\mathcal{Y} \subseteq \mathbb{R}$，以及训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$。给定 $(\boldsymbol{x},y) \in \mathcal{X} \times \mathcal{Y}$ 和 $\boldsymbol{w} \in \mathbb{R}^d$，使用 $\epsilon$-不敏感函数/$\epsilon$-Insensitive Function：

$$\ell_{\epsilon}(\boldsymbol{w}, (\boldsymbol{x}, y)) = \begin{cases}
0 & \text{if } |\boldsymbol{w}^{\text{T}}\boldsymbol{x} - y| \leq \epsilon,\\
|\boldsymbol{w}^{\text{T}}\boldsymbol{x} - y| - \epsilon & \text{if } |\boldsymbol{w}^{\text{T}}\boldsymbol{x} - y| > \epsilon.\end{cases}$$

本节考虑未使用核函数的支持向量回归，即目标函数为

$$F_D(\boldsymbol{w}) = \frac{1}{m}\sum_{i=1}^m \ell_{\epsilon}(\boldsymbol{w}, (\boldsymbol{x}_i, y_i)) + \lambda\|\boldsymbol{w}\|^2,$$

其中 $\boldsymbol{w} \in \mathbb{R}^d$，$\lambda$ 为正则化参数。关于支持向量回归的稳定性，有如下定理：

**定理 5.6**：给定常数 $r > 0$，考虑样本空间 $\mathcal{X} = \{\boldsymbol{x} \in \mathbb{R}^d: \|\boldsymbol{x}\| \leq r\}$，以及优化目标函数，则支持向量回归具有替换样本 $\beta$-均匀稳定性。其中 $\beta = 2r^2/(\lambda m)$。

???- Info "证明"

    给定训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$，对任意 $k \in [m]$，令 $D' = D^{k,z_k'}$ 表示训练集 $D$ 中第 $k$ 个样本被替换为 $z_k' = (\boldsymbol{x}_k', y_k')$ 得到的数据集。令 $\boldsymbol{w}_D$ 和 $\boldsymbol{w}_{D'}$ 分别表示优化目标函数 $F_D(\boldsymbol{w})$ 和 $F_{D'}(\boldsymbol{w})$ 所得的最优解，即

    $$\boldsymbol{w}_D \in \underset{\boldsymbol{w}}{\arg\min} F_D(\boldsymbol{w}), \quad \boldsymbol{w}_{D'} \in \underset{\boldsymbol{w}}{\arg\min} F_{D'}(\boldsymbol{w}).$$

    对任意样本 $(\boldsymbol{x},y) \in \mathcal{X} \times \mathcal{Y}$，分下面四种情况讨论：

    - 若 $|\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| \leq \epsilon$ 且 $|\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y| \leq \epsilon$，则有

        $$|\ell_{\epsilon}(\boldsymbol{w}_D, (\boldsymbol{x},y)) - \ell_{\epsilon}(\boldsymbol{w}_{D'}, (\boldsymbol{x},y))| = 0 \leq r\|\boldsymbol{w}_{D'} - \boldsymbol{w}_D\|;$$

    - 若 $|\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| > \epsilon$ 且 $|\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y| > \epsilon$，则有

        $$\begin{aligned}
        |\ell_{\epsilon}(\boldsymbol{w}_D, (\boldsymbol{x},y)) - \ell_{\epsilon}(\boldsymbol{w}_{D'}, (\boldsymbol{x},y))| &= ||\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| - |\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y||\\
        &\leq |(\boldsymbol{w}_{D'} - \boldsymbol{w}_D)^{\text{T}}\boldsymbol{x}| \leq r\|\boldsymbol{w}_{D'} - \boldsymbol{w}_D\|;
        \end{aligned}$$

    - 若 $|\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| > \epsilon$ 且 $|\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y| \leq \epsilon$，则有

        $$\begin{aligned}
        |\ell_{\epsilon}(\boldsymbol{w}_D, (\boldsymbol{x},y)) - \ell_{\epsilon}(\boldsymbol{w}_{D'}, (\boldsymbol{x},y))| &= ||\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| - \epsilon| \leq |\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| - |\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y|\\
        &\leq |(\boldsymbol{w}_{D'} - \boldsymbol{w}_D)^{\text{T}}\boldsymbol{x}| \leq r\|\boldsymbol{w}_{D'} - \boldsymbol{w}_D\|;
        \end{aligned}$$

    - 若 $|\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| \leq \epsilon$ 且 $|\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y| > \epsilon$，同理可得

        $$\begin{aligned}
        |\ell_{\epsilon}(\boldsymbol{w}_D, (\boldsymbol{x},y)) - \ell_{\epsilon}(\boldsymbol{w}_{D'}, (\boldsymbol{x},y))| \leq r\|\boldsymbol{w}_{D'} - \boldsymbol{w}_D\|;
        \end{aligned}$$

    综合上述四种情况，对任意样本 $(\boldsymbol{x},y) \in \mathcal{X} \times \mathcal{Y}$，有

    $$|\ell_{\epsilon}(\boldsymbol{w}_D, (\boldsymbol{x},y)) - \ell_{\epsilon}(\boldsymbol{w}_{D'}, (\boldsymbol{x},y))| \leq r\|\boldsymbol{w}_{D'} - \boldsymbol{w}_D\|.$$

    根据支持向量回归目标函数有

    $$\begin{aligned}
        F_{D}(w_{D'}) - F_{D}(w_D) &= F_{D'}(w_{D'}) + (\ell_{\epsilon}(w_{D'}, (x_k, y_k)) - \ell_{\epsilon}(w_D, (x_k, y_k)))/m\\
        &\quad- F_{D'}(w_D) + (\ell_{\epsilon}(w_D, (x_k', y_k')) - \ell_{\epsilon}(w_{D'}, (x_k', y_k')))/m.
    \end{aligned}$$ 

    根据 $w_{D'} \in \underset{w}{\arg\min} F_{D'}(w)$ 有

    $$F_{D'}(w_{D'}) - F_{D'}(w_D) \leq 0.$$

    并且有

    $$\begin{aligned}
        |\ell_{\epsilon}(w_{D'}, (x_k, y_k)) - \ell_{\epsilon}(w_D, (x_k, y_k))| &\leq r\|w_{D'} - w_D\|,\\
        |\ell_{\epsilon}(w_D, (x_k', y_k')) - \ell_{\epsilon}(w_{D'}, (x_k', y_k'))| &\leq r\|w_{D'} - w_D\|.
    \end{aligned}$$

    将上述式子代入 $F_{D}(w_{D'}) - F_{D}(w_D)$ 可得

    $$F_{D}(w_{D'}) - F_{D}(w_D) \leq 2r\|w_{D'} - w_{D}\|/m.$$

    任意凸函数加入正则项 $\lambda\|w\|^2$ 变成 $2\lambda$-强凸函数，由此可知 $F_{D}(w)$ 是 $2\lambda$-强凸函数，进一步有

    $$F_{D}(w_{D'}) \geq F_{D}(w_D) + \lambda \|w_{D'} - w_D\|^2.$$

    因此可以得到

    $$\|w_{D'} - w_D\| \leq 2r/(m\lambda).$$

    对任意样本 $(x, y) \in \mathcal{X} \times \mathcal{Y}$，利用上述式子可得

    $$|\ell_{\epsilon}(w_D, (x, y)) - \ell_{\epsilon}(w_{D'}, (x, y))| \leq r\|w_{D'} - w_D\| \leq 2r^2/(m\lambda),$$

    因此支持向量回归具有替换样本 $\beta$-均匀稳定性，其中 $\beta = 2r^2/(\lambda m)$。

上述定理最重要的内容是下面这个式子：

$$|\ell_\epsilon(\boldsymbol{w}_D, (\boldsymbol{x}, y)) - \ell_\epsilon(\boldsymbol{w}_{D'}, (\boldsymbol{x}, y))| \leq 2r^2/(\lambda m).$$

其描述了支持向量回归的稳定性。同样，我们可以进一步推导支持向量回归的泛化性。

**推论 5.2**：给定常数 $r > 0$，考虑样本空间 $\mathcal{X} = \{\boldsymbol{x} \in \mathbb{R}^d: \|\boldsymbol{x}\| \leq r\}$ 和 $\epsilon$-不敏感函数 $\ell_{\epsilon}(\cdot,\cdot) \in [0,M]$，令 $\boldsymbol{w}_D$ 表示优化目标函数 $F_D(\boldsymbol{w})$ 所得的最优解。对任意 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率有

$$R(\boldsymbol{w}_D) \leq \widehat{R}(\boldsymbol{w}_D) + \frac{2r^2}{m\lambda} + \left(\frac{4r^2}{\lambda} + M\right)\sqrt{\frac{\ln(1/\delta)}{2m}}.$$

???- Info "证明"

    根据定理 5.6 可以知道支持向量回归具有替换样本 $\beta$-均匀稳定性，其中 $\beta = 2r^2/(\lambda m)$。对于有界的 $\epsilon$-不敏感函数 $\ell_{\epsilon}(\cdot,\cdot) \in [0,M]$，根据定理 5.1 将 $\beta = 2r^2/(\lambda m)$ 代入即可完成证明。

### 3.3 岭回归

岭回归/Ridge Regression 是一种常用的正则化回归算法，考虑样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$ 和标记空间 $\mathcal{Y} \subseteq \mathbb{R}$，以及训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$。对任意样本 $(\boldsymbol{x}, y) \in \mathcal{X} \times \mathcal{Y}$ 和 $\boldsymbol{w} \in \mathbb{R}^d$，考虑平方函数

$$\ell_2(\boldsymbol{w}, (\boldsymbol{x}, y)) = (\boldsymbol{w}^{\text{T}}\boldsymbol{x} - y)^2.$$

我们考虑线性岭回归，即目标函数为

$$F_D(\boldsymbol{w}) = \frac{1}{m}\sum_{i=1}^m (\boldsymbol{w}^{\text{T}}\boldsymbol{x}_i - y_i)^2 + \lambda\|\boldsymbol{w}\|^2.$$

其中 $\boldsymbol{w} \in \mathbb{R}^d$，$\lambda$ 为正则化参数。

关于岭回归的稳定性，有如下定理：

**定理 5.7**：给定常数 $r > 0$，考虑样本空间 $\mathcal{X} = \{\boldsymbol{x} \in \mathbb{R}^d: \|\boldsymbol{x}\| \leq r\}$，平方函数 $\ell_2(\cdot,\cdot) \in [0, M]$，以及优化目标函数，则岭回归具有替换样本 $\beta$-均匀稳定性，其中 $\beta = 4r^2M/(\lambda m)$。

???- Info "证明"

    给定训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$，对任意 $k \in [m]$，令 $D' = D^{k,z_k'}$ 表示训练集 $D$ 中第 $k$ 个样本被替换为 $z_k' = (\boldsymbol{x}_k', y_k')$ 得到的数据集。令 $\boldsymbol{w}_D$ 和 $\boldsymbol{w}_{D'}$ 分别表示优化目标函数 $F_D(\boldsymbol{w})$ 和 $F_{D'}(\boldsymbol{w})$ 所得的最优解，即

    $$\boldsymbol{w}_D \in \underset{\boldsymbol{w}}{\arg\min} F_D(\boldsymbol{w}), \quad \boldsymbol{w}_{D'} \in \underset{\boldsymbol{w}}{\arg\min} F_{D'}(\boldsymbol{w}).$$

    对任意样本 $(\boldsymbol{x}, y) \in \mathcal{X} \times \mathcal{Y}$ 和有界的平方函数 $\ell_2(\cdot,\cdot) \in [0, M]$ 有

    $$\begin{aligned}
        |(\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y)^2 - (\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y)^2| &\leq |(\boldsymbol{w}_D - \boldsymbol{w}_{D'})^{\text{T}}\boldsymbol{x}| (|\boldsymbol{w}_D^{\text{T}}\boldsymbol{x} - y| + |\boldsymbol{w}_{D'}^{\text{T}}\boldsymbol{x} - y|)\\
        &\leq 2\sqrt{M} |(\boldsymbol{w}_D - \boldsymbol{w}_{D'})^{\text{T}}\boldsymbol{x}|\\
        &\leq 2\sqrt{M} \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\| \|\boldsymbol{x}\| \leq 2r\sqrt{M} \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|.
    \end{aligned}$$

    任意凸函数加入正则项 $\lambda\|\boldsymbol{w}\|^2$ 变成 $2\lambda$-强凸函数，由此可知 $F_D(\boldsymbol{w})$ 是 $2\lambda$-强凸函数，有

    $$\begin{aligned}
        F_D(\boldsymbol{w}_{D'}) &\geq F_D(\boldsymbol{w}_D) + \lambda \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|^2, \\
        F_{D'}(\boldsymbol{w}_D) &\geq F_{D'}(\boldsymbol{w}_{D'}) + \lambda \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|^2.
    \end{aligned}$$

    将上述两式相加可得

    $$\begin{aligned}
        2\lambda \|\boldsymbol{w}_D - \boldsymbol{w}_{D'}\|^2 &\leq F_D(\boldsymbol{w}_{D'}) - F_D(\boldsymbol{w}_D) + F_{D'}(\boldsymbol{w}_D) - F_{D'}(\boldsymbol{w}_{D'}) \\
        &= \ell_2(\boldsymbol{w}_{D'}, (\boldsymbol{x}_k, y_k)) - \ell_2(\boldsymbol{w}_D, (\boldsymbol{x}_k, y_k)) + \ell_2(\boldsymbol{w}_D, (\boldsymbol{x}_k', y_k')) - \ell_2(\boldsymbol{w}_{D'}, (\boldsymbol{x}_k', y_k')) \\
    \end{aligned}$$

    使用刚才的不等式进行放缩，就有

    $$2\lambda \lVert \boldsymbol{w}_D - \boldsymbol{w}_{D'} \rVert^2 \leq 4r\sqrt{M} \lVert \boldsymbol{w}_D - \boldsymbol{w}_{D'} \rVert / m.$$

    从而得到

    $$\lVert \boldsymbol{w}_D - \boldsymbol{w}_{D'} \rVert \leq 2r^2\sqrt{M} / (\lambda m).$$

    因此，对任意样本 $(\boldsymbol{x}, y) \in \mathcal{X} \times \mathcal{Y}$，有

    $$|\ell_2(\boldsymbol{w}_D, (\boldsymbol{x}, y)) - \ell_2(\boldsymbol{w}_{D'}, (\boldsymbol{x}, y))| \leq 4r^2M / (\lambda m).$$

    由此可知岭回归具有替换样本 $\beta$-均匀稳定性，其中 $\beta = 4r^2M/(\lambda m)$。
        
上述定理最重要的内容是下面这个式子：

$$|\ell_2(\boldsymbol{w}_D, (\boldsymbol{x}, y)) - \ell_2(\boldsymbol{w}_{D'}, (\boldsymbol{x}, y))| \leq 4r^2M / (\lambda m).$$

其描述了岭回归的稳定性。同样，我们可以进一步推导岭回归的泛化性。

**推论 5.3**：给定常数 $r > 0$，考虑样本空间 $\mathcal{X} = \{\boldsymbol{x} \in \mathbb{R}^d: \|\boldsymbol{x}\| \leq r\}$ 和平方函数 $\ell_2(\cdot,\cdot) \in [0,M]$，令 $\boldsymbol{w}_D$ 表示优化目标函数 $F_D(\boldsymbol{w})$ 所得的最优解。对任意 $\delta \in (0,1)$，以至少 $1-\delta$ 的概率有

???- Info "证明"

    根据定理 5.7 可以知道岭回归具有替换样本 $\beta$-均匀稳定性，其中 $\beta = 4r^2M/(\lambda m)$。对于有界的平方函数 $\ell_2(\cdot,\cdot) \in [0,M]$，根据定理 5.1 将 $\beta = 4r^2M/(\lambda m)$ 代入即可完成证明。

### 3.4 k-近邻

$k$-近邻是机器学习中一种经典的分类方法，每一个训练集都可以看作 $k$-近邻方法的一个分类函数，因此 $k$-近邻的函数空间 VC 维是无限的，很难从函数空间复杂度角度来分析 $k$-近邻的泛化性。本节将从稳定性角度来分析 $k$-近邻的泛化性。

考虑样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$，标记空间 $\mathcal{Y} = \{-1,+1\}$，以及 $\mathcal{D}$ 是 $\mathcal{X} \times \mathcal{Y}$ 上的一个联合分布。训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$ 基于分布 $\mathcal{D}$ 独立同分布采样得到。给定样本 $\boldsymbol{x} \in \mathcal{X}$，令 $\pi_1(\boldsymbol{x}), \pi_2(\boldsymbol{x}),\ldots,\pi_m(\boldsymbol{x})$ 表示根据训练样本与 $\boldsymbol{x}$ 的距离重新进行了排列，即 $\|\boldsymbol{x} - \boldsymbol{x}_{\pi_i(\boldsymbol{x})}\| \leq \|\boldsymbol{x} - \boldsymbol{x}_{\pi_{i+1}(\boldsymbol{x})}\|$。因此 $k$-近邻算法返回的输出函数为

$$\mathfrak{L}_D^k(\boldsymbol{x}) = \begin{cases} +1 & \text{if } \sum_{i=1}^k y_{\pi_i(\boldsymbol{x})} \geq 0,\\ -1 & \text{if } \sum_{i=1}^k y_{\pi_i(\boldsymbol{x})} < 0. \end{cases}$$

考虑 0/1 损失函数

$$\ell(\mathfrak{L}_D^k, (\boldsymbol{x}, y)) = \mathbb{I}(\mathfrak{L}_D^k(\boldsymbol{x}) \neq y).$$

可以发现 $k$-近邻算法并不具有很好的替换均匀稳定性或移除均匀稳定性，因为无论有多少训练数据，当替换或移除一个样本时都可能改变 $k$-近邻算法预测的标记。下面研究 $k$-近邻算法的假设稳定性。

首先介绍如下引理：

**引理 5.2**：给定整数 $k > 0$，若随机变量 $X$ 满足

$$P(X = i) = \frac{1}{2^k}\binom{k}{i} \quad (i \in [k]),$$

则对任意正整数 $a$ 有

$$P\left(\left|X - \frac{k}{2}\right| \leq \frac{a}{2}\right) < \frac{2\sqrt{2a}}{\sqrt{\pi k}}.$$

关于 $k$-近邻的假设稳定性，有如下定理：

**定理 5.8**：考虑样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$ 和标记空间 $\mathcal{Y} = \{-1,+1\}$，则 $k$-近邻算法具有替换样本 $\beta$-假设稳定性。其中 $\beta = 2\sqrt{2k/\pi}/m$。

???- Info "证明"

    给定训练集 $D = \{(\boldsymbol{x}_1, y_1), (\boldsymbol{x}_2, y_2),\ldots,(\boldsymbol{x}_m, y_m)\}$，对任意 $i \in [m]$，令 $D^{i,z_i'}$ 表示训练集 $D$ 中第 $i$ 个样本被替换为 $z_i' = (\boldsymbol{x}_i', y_i')$ 得到的数据集。令 $\mathfrak{L}_D$ 和 $\mathfrak{L}_{D^{i,z_i'}}$ 分别表示 $k$-近邻算法在训练集 $D$ 和 $D^{i,z_i'}$ 学得的输出函数，则有

    $$\begin{aligned}
    P_{\boldsymbol{x}\sim\mathcal{D}_\mathcal{X}}(\mathfrak{L}_D(\boldsymbol{x}) \neq \mathfrak{L}_{D^{i,z_i'}}(\boldsymbol{x})) = \mathbb{E}_{\boldsymbol{x},\boldsymbol{x}_{\pi_{k+1}(\boldsymbol{x}),y_{\pi_{k+1}(\boldsymbol{x})}}}[P(\mathfrak{L}_D(\boldsymbol{x}) \neq \mathfrak{L}_{D^{i,z_i'}}(\boldsymbol{x})|\boldsymbol{x}, \boldsymbol{x}_{\pi_{k+1}(\boldsymbol{x})}, y_{\pi_{k+1}(\boldsymbol{x})})].
    \end{aligned}$$

    给定样本 $\boldsymbol{x}$ 和样本 $(\boldsymbol{x}_{\pi_{k+1}(\boldsymbol{x})}, y_{\pi_{k+1}(\boldsymbol{x})})$，令 $N_+$ 表示 $\boldsymbol{x}$ 的 $k$ 个近邻样本中的正样本数。若替换一个样本会改变样本 $\boldsymbol{x}$ 的预测标记，即 $\mathfrak{L}_D(\boldsymbol{x}) \neq \mathfrak{L}_{D^{i,z_i'}}(\boldsymbol{x})$，有：

    - 被替换的样本 $z_i$ 是 $\boldsymbol{x}$ 的 $k$ 个近邻样本之一，其发生的概率为 $k/m$；
    - 样本 $\boldsymbol{x}$ 的 $k$ 个近邻中正反样本个数相差不超过 1，即 $|N_+ - (k - N_+)| \leq 1$，等价于 $|N_+ - k/2| \leq 1/2$。

    于是有

    $$\begin{aligned}
    P_{\boldsymbol{x}\sim\mathcal{D}_\mathcal{X}}(\mathfrak{L}_D(\boldsymbol{x}) \neq \mathfrak{L}_{D^{i,z_i'}}(\boldsymbol{x})|\boldsymbol{x}, \boldsymbol{x}_{\pi_{k+1}(\boldsymbol{x})}, y_{\pi_{k+1}(\boldsymbol{x})}) &\leq \frac{k}{m}P(|N_+ - k/2| \leq 1/2|\boldsymbol{x}, \boldsymbol{x}_{\pi_{k+1}(\boldsymbol{x})}, y_{\pi_{k+1}(\boldsymbol{x})}) \\
    &\leq \frac{2}{m}\sqrt{\frac{2k}{\pi}}.
    \end{aligned}$$

    因此可以得到

    $$\begin{aligned}
    \mathbb{E}_{(\boldsymbol{x},y)\sim\mathcal{D}}[|\mathbb{I}(\mathfrak{L}_D(\boldsymbol{x}) \neq y) - \mathbb{I}(\mathfrak{L}_{D^{i,z_i'}}(\boldsymbol{x}) \neq y)|] &= P_{\boldsymbol{x}\sim\mathcal{D}_\mathcal{X}}(\mathfrak{L}_D(\boldsymbol{x}) \neq \mathfrak{L}_{D^{i,z_i'}}(\boldsymbol{x})) \\
    &\leq \frac{2\sqrt{2k}}{m\sqrt{\pi}},
    \end{aligned}$$

    从而证明了 $k$-近邻算法具有替换样本 $\beta$-假设稳定性，其中 $\beta = 2\sqrt{2k/\pi}/m$。

基于稳定性可以进一步得到 $k$-近邻的泛化性。

**推论 5.4**：考虑样本空间 $\mathcal{X} \subseteq \mathbb{R}^d$ 和标记空间 $\mathcal{Y} = \{-1,+1\}$，令 $\mathfrak{L}_D$ 表示 $k$-近邻算法基于数据集 $D$ 学习所得的输出函数，则有

$$\mathbb{E}_{D\sim\mathcal{D}^m}[(R(\mathfrak{L}_D) - \widehat{R}(\mathfrak{L}_D))^2] \leq \frac{8M\sqrt{2k}}{m\sqrt{\pi}} + \frac{M^2}{m}.$$

???- Info "证明"

    根据定理 5.8 可知 $k$-近邻算法具有替换样本 $\beta$-假设稳定性，其中 $\beta = 2\sqrt{2k/\pi}/m$。再根据定理 5.2 将 $\beta = 2\sqrt{2k/\pi}/m$ 代入 (5.27) 即可完成证明。
