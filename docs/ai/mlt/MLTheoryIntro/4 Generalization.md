# Chapter 4: 泛化界

## 1. 有限假设空间对应的泛化误差上界

### 1.1 问题可分

对于可分的有限假设空间 $\mathcal{H}$，目标概念 $c \in \mathcal{H}$，任何在训练集 $D$ 上犯错的假设都不是要找的目标概念。因此可以剔除这些在训练集 $D$ 上犯错的假设，最终剩下与 $D$ 一致的假设，目标概念一定存在于这些一致的假设中。如果 $D$ 足够大，则最终剩下的一致假设会很少，从而能够以较大的概率找到目标概念的近似。然而由于实际中数据集 $D$ 通常只包含有限数量的样本，所以假设空间 $\mathcal{H}$ 中会剩下不止一个与 $D$ 一致的等效假设，这些等效假设无法通过数据集 $D$ 再进行区分。一般来说，无法强求通过训练集 $D$ 能够确保找到目标概念 $c$。在 PAC 学习理论中，只要训练集 $D$ 的规模能使学习算法 $\mathfrak{L}$ 以至少 $1 - \delta$ 的概率找到目标概念的 $\epsilon$ 近似即可。当 $\mathcal{H}$ 为可分的有限假设空间时，有下面的定理成立：

**定理 1.1**：令 $\mathcal{H}$ 为可分的有限假设空间，$D$ 为从 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集，学习算法 $\mathfrak{L}$ 基于训练集 $D$ 输出与训练集一致的假设 $h \in \mathcal{H}$，对于 $0 < \epsilon,\delta < 1$，若 $m \geq \frac{1}{\epsilon}(\ln |\mathcal{H}| + \ln \frac{1}{\delta})$，则有

$$P(E(h) \leq \epsilon) \geq 1 - \delta,$$

即 $E(h) \leq \epsilon$ 以至少 $1 - \delta$ 的概率成立。

!!! Info "证明"

    学习算法 $\mathfrak{L}$ 输出与训练集一致的假设 $h \in \mathcal{H}$，该假设的泛化误差依赖于训练集 $D$，我们希望能够以较大的概率找到与目标概念 $c$ 近似的假设。若 $h$ 的泛化误差太大且与训练集一致，则这样的假设出现的概率可以表示为

    $$P(\exists h \in \mathcal{H} : E(h) > \epsilon \land \widehat{E}(h) = 0).$$

    下面只需证明这一概率至多为 $\delta$ 即可。通过计算可知

    $$P(\exists h \in \mathcal{H} : E(h) > \epsilon \land \widehat{E}(h) = 0) \leq \sum_{h\in\mathcal{H}} P(E(h) > \epsilon \land \widehat{E}(h) = 0)
    \leq |\mathcal{H}|(1-\epsilon)^m.$$

    第一个不等号是因为 $E(h) > \epsilon$ 表明 $h$ 犯错的概率大于 $\epsilon$，也就是预测正确率小于 $1-\epsilon$，而 $\widehat{E}(h) = 0$ 表明 $h$ 对 $m$ 个独立同分布采样得到的样本被 $h$ 均预测正确，这个事件的发生概率不大于 $(1 - \epsilon)^m$。

    因此只需要保证 $|\mathcal{H}|(1-\epsilon)^m$ 最右端不大于 $\delta$ 即可。由于 $(1-\epsilon)^m \leq e^{-\epsilon m}$，若 $m \geq \frac{1}{\epsilon}(\ln |\mathcal{H}| + \ln \frac{1}{\delta})$，则有

    $$|\mathcal{H}|(1-\epsilon)^m \leq |\mathcal{H}|e^{-\epsilon m} \leq \delta.$$

    从而可知 $P(E(h) \leq \epsilon) \geq 1 - \delta$，即 $P(E(h) \leq \epsilon) \geq 1 - \delta$，定理得证。


这个定理表明，当假设空间 $\mathcal{H}$ 是有限可分时，学习算法 $\mathfrak{L}$ 输出假设的泛化误差依赖于假设空间的大小 $|\mathcal{H}|$ 和训练集的大小 $m$，随着训练集中样本数目的逐渐增加，泛化误差的上界逐渐趋近于 0，收敛率是 $O(1/m)$。

### 1.2 问题不可分

在不可分情形时，目标概念不在假设空间中，假设空间中的每个假设都会或多或少地出现分类错误，我们不再着眼于找到目标概念的 $\epsilon$ 近似，而是希望找到假设空间中泛化误差最小假设的 $\epsilon$ 近似。对于学习算法输出的假设 $h$ 来说，泛化误差是其在未见数据上的预测能力，无法直接核测得到，但其在训练集上的经验误差是可以直接观测得到的。定理 2.1 探讨了泛化误差与经验误差之间的关系，表明当训练集中样本数目 $m$ 较大时，$h$ 的经验误差是泛化误差的较好近似。基于这一关系，可以给出下面的定理。

**定理 1.2**：令 $\mathcal{H}$ 为有限假设空间，$D$ 为从 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集，$h \in \mathcal{H}$，对于 $0 < \epsilon,\delta < 1$ 有

$$P(E(h) \leq \widehat{E}(h) + \sqrt{\frac{\ln |\mathcal{H}| + \ln(2/\delta)}{2m}}) \geq 1 - \delta.$$

!!! Info "证明"

    将 $\mathcal{H}$ 中的有限假设记为 $h_1,h_2,\ldots,h_{|\mathcal{H}|}$，通过计算和并集界定理可得

    $$\begin{aligned}
        P(\exists h \in \mathcal{H} : E(h) > \widehat{E}(h) + \epsilon)
        &= P\left(\left(E(h_1) > \widehat{E}(h_1) + \epsilon\right) \vee \cdots \vee \left(E(h_{|\mathcal{H}|}) > \widehat{E}(h_{|\mathcal{H}|}) + \epsilon\right)\right) \\
        &\leq \sum_{h\in\mathcal{H}} P\left(E(h) > \widehat{E}(h) + \epsilon\right).
    \end{aligned}$$

    基于引理 2.1，令 $2\exp(-2m\epsilon^2) = \delta/|\mathcal{H}|$ 可得

    $$\sum_{h\in\mathcal{H}} P\left(E(h) > \widehat{E}(h) + \epsilon\right) \leq \sum_{h\in\mathcal{H}} \delta/|\mathcal{H}| \leq |\mathcal{H}| \cdot \delta/|\mathcal{H}| = \delta.$$

    由 $2\exp(-2m\epsilon^2) = \delta/|\mathcal{H}|$ 可求解 $\epsilon = \sqrt{\frac{\ln |\mathcal{H}| + \ln(2/\delta)}{2m}}$，从而定理得证。

由于 $\sqrt{\frac{\ln |\mathcal{H}| + \ln(2/\delta)}{2m}} = O(1/\sqrt{m})$，所以在有限假设空间不可分情形下，泛化误差的收敛率为 $O(1/\sqrt{m})$。

## 2. 无限假设空间对应的泛化误差上界

### 2.1 有限 VC 维假设空间的泛化误差界

**引理 4.1**：对于假设空间 $\mathcal{H}$，$h \in \mathcal{H}$，$m \in \mathbb{N}$ 和 $0 < \epsilon < 1$，当 $m \geq 2/\epsilon^2$ 时有

$$P\left(|E(h) - \widehat{E}(h)| > \epsilon\right) < 4\Pi_{\mathcal{H}}(2m)\exp\left(-\frac{m\epsilon^2}{8}\right).$$

!!! Info "证明"

    考虑两个大小均为 $m$ 且分别从 $\mathcal{D}$ 独立同分布采样得到的训练集 $D$ 和 $D^{\prime}$。首先证明

    $$P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right) \geq \frac{1}{2}P\left(\sup_{h\in\mathcal{H}}|E(h) - \widehat{E}_D(h)| > \epsilon\right).$$

    令 $Q$ 表示集合

    $$\left\{D \sim \mathcal{D}^m\left|\sup_{h\in\mathcal{H}}|E(h) - \widehat{E}_D(h)| > \epsilon\right.\right\},$$

    其中 $D \sim \mathcal{D}^m$ 表示从 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集。计算可得

    $$\begin{aligned}
        P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right) &= \mathbb{E}_{D,D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right] \\
        &= \mathbb{E}_{D\sim\mathcal{D}^m}\left[\mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right]\right] \\
        &\geq \mathbb{E}_{D\in Q}\left[\mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right]\right].
    \end{aligned}$$

    第三行的不等式是因为 $\mathbb{E}_{D\notin Q}[\cdot] \geq 0$。对于任意 $D \in Q$，存在一个假设 $h_0 \in \mathcal{H}$ 使得 $|E(h_0) - \widehat{E}_D(h_0)| > \epsilon$。对于 $h_0$，计算可得

    $$\begin{aligned}
        \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right] &\geq \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(|\widehat{E}_D(h_0) - \widehat{E}_{D^{\prime}}(h_0)| \geq \frac{1}{2}\epsilon\right)\right] \\
        &= \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(|(\widehat{E}_D(h_0) - E(h_0)) - (\widehat{E}_{D^{\prime}}(h_0) - E(h_0))| \geq \frac{1}{2}\epsilon\right)\right] \\
        &\geq \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(|\widehat{E}_D(h_0) - E(h_0)| - |\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| \geq \frac{1}{2}\epsilon\right)\right].
    \end{aligned}$$

    这两个不等号分别利用了 $\sup$ 的性质和绝对值的性质。注意到 $|E(h_0) - \widehat{E}_D(h_0)| > \epsilon$，若 $|\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| \leq \frac{1}{2}\epsilon$，则 $|\widehat{E}_D(h_0) - E(h_0)| - |\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| \geq \frac{1}{2}\epsilon$ 成立。从而基于上面的不等式可得

    $$\begin{aligned}
        \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right] &\geq \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(|\widehat{E}_D(h_0) - E(h_0)| - |\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| \geq \frac{1}{2}\epsilon\right)\right] \\
        &\geq \mathbb{E}_{D^{\prime}\sim\mathcal{D}^m}\left[\mathbb{I}\left(|\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| \leq \frac{1}{2}\epsilon\right)\right] \\
        &= P\left(|\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| \leq \frac{1}{2}\epsilon\right) \\
        &= 1 - P\left(|\widehat{E}_{D^{\prime}}(h_0) - E(h_0)| > \frac{1}{2}\epsilon\right).
    \end{aligned}$$

    再有 Chebyshev 不等式：

    $$P\left(|\widehat{E}_{D'}(h_0) - E(h_0)| > \frac{1}{2}\epsilon\right) \leq \frac{4(1-E(h_0))E(h_0)}{\epsilon^2m} \leq \frac{1}{\epsilon^2m}.$$

    !!! Note "这里其实需要证明 $\mathbb{V}_{D^{\prime}}(\widehat{E}_{D^{\prime}}(h_0)) = E(h_0)(1-E(h_0))/m$，这里没证明，我也不知道怎么证明的。"

    当 $m \geq 2/\epsilon^2$ 时，$P\left(|\widehat{E}_{D'}(h_0) - E(h_0)| > \frac{1}{2}\epsilon\right) \leq 1/2$。于是可得

    $$P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D'}(h)| \geq \frac{1}{2}\epsilon\right) \geq \mathbb{E}_{D\in Q}\left[\frac{1}{2}\right] = \frac{1}{2}P\left(\sup_{h\in\mathcal{H}}|E(h) - \widehat{E}_D(h)| > \epsilon\right).$$

    这样，我们要证明的东西就成立了，我们下面对 $P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)$ 进行进一步的分析。

    由于 $D$ 和 $D^{\prime}$ 均为从 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集，则 $D$ 和 $D^{\prime}$ 一共包含 $2m$ 个样本（这 $2m$ 个样本有可能重复）。若令 $T_i$ 表示这 $2m$ 个样本上的置换，则有 $(2m)!$ 个 $T_i$。令 $T_iD$ 表示 $2m$ 个样本经过置换 $T_i$ 的前 $m$ 个样本，$T_iD^{\prime}$ 表示这 $2m$ 个样本经过置换 $T_i$ 的后 $m$ 个样本，则对于 $D$，$D^{\prime}$，$T_iD$ 和 $T_iD^{\prime}$ 有

    $$P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right) = P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right).$$

    因此有

    $$\begin{aligned}
        P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right) &= \mathbb{E}_{D,D^{\prime}}\left[\frac{1}{(2m)!}\sum_{i=1}^{(2m)!}\mathbb{I}\left(\sup_{h\in\mathcal{H}}|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right] \\
        &= \mathbb{E}_{D,D^{\prime}}\left[\frac{1}{(2m)!}\sum_{i=1}^{(2m)!}\sup_{h\in\mathcal{H}}\mathbb{I}\left(|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right] \\
        &\leq \mathbb{E}_{D,D^{\prime}}\left[\sum_{h\in\mathcal{H}_{\mid D+D^{\prime}}} \frac{1}{(2m)!}\sum_{i=1}^{(2m)!}\mathbb{I}\left(|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right)\right].
    \end{aligned}$$

    其中 $\mathcal{H}_{\mid D + D^{\prime}}$ 为 $\mathcal{H}$ 在训练集 $D + D^{\prime}$ 上的限制。接下来考虑

    $$\sum_{i=1}^{(2m)!}\mathbb{I}\left(|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right).$$

    这表示对于给定假设 $h$ 满足 $|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon$ 的置换数目。令 $l$ 表示 $h$ 在 $D + D^{\prime}$ 上预测正确的样本数目，有

    $$\begin{aligned}
        \frac{1}{(2m)!}\sum_{i=1}^{(2m)!}\mathbb{I}\left(|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD^{\prime}}(h)| \geq \frac{1}{2}\epsilon\right) = \sum_{\substack{k \in [l] \\ \text{s.t. } |2k/m - l/m| > \epsilon/2}} \frac{\binom{l}{k}\binom{2m - l}{m - k}}{\binom{2m}{m}} \leq 2\exp\left(-\frac{\epsilon^2m}{8}\right).
    \end{aligned}$$

    这个式子的两段我们一段一段仔细分解：

    - 第一个等号：显然最左侧的式子可以看作一个概率，正例的示性函数值为 1，负例的示性函数值为 0，所以求和的结果就是正例的个数所占的比例，在古典概型中，这个比例就是正例的概率。$k$ 表示 $T_iD$ 中被 $h$ 预测正确的样本数目，$m-k$ 表示 $T_iD$ 中被 $h$ 预测错误的样本数目，$\binom{l}{k}$ 表示从 $l$ 个预测正确的样本中选择 $k$ 个样本的种数，$\binom{2m-l}{m-k}$ 表示从 $2m-l$ 个预测错误的样本中选择 $m-k$ 个样本的种数，$\binom{2m}{m}$ 表示从 $2m$ 个样本中选择 $m$ 个样本构成 $T_iD$ 的种数。若 $|(m-k)/m - (m-l+k)/m| \geq \epsilon/2$，即 $|2k/m - l/m| \geq \epsilon/2$，这也就是 $|\widehat{E}_{T_iD}(h) - \widehat{E}_{T_iD'}(h)| \geq \frac{1}{2}\epsilon$。
    - 第二个小于等于号：被求和项看可以看作超几何分布的概率，内容是从 $2m$ 个样本中抽取 $m$ 个样本，其中有 $k$ 个是正确的，$m-k$ 个是错误的，将约束条件变形为 $\lvert k - l/2 \rvert > m\epsilon/4$，注意到抽取 $m$ 个样本中正确样本的期望值为 $l/2$，所以约束条件可以看作是正确样本数目偏离期望值的程度大于 $m\epsilon/4$，对其使用 Hoeffding 不等式可得不等式的结果。

    因此，我们需要求的概率转化为

    $$P\left(\sup_{h\in\mathcal{H}}|\widehat{E}_D(h) - \widehat{E}_{D'}(h)| \geq \frac{1}{2}\epsilon\right) \leq 2|\mathcal{H}_{\mid D+D^{\prime}}|\exp\left(-\frac{\epsilon^2m}{8}\right).$$

    根据增长函数的定义可知 $|\mathcal{H}_{\mid D+D^{\prime}}| \leq \Pi_{\mathcal{H}}(2m)$。再结合最初证明的不等式，对于任意假设 $h \in \mathcal{H}$ 可得

    $$P\left(|E(h) - \widehat{E}_D(h)| > \epsilon\right) \leq P\left(\sup_{h\in\mathcal{H}}|E(h) - \widehat{E}(h)| > \epsilon\right) \leq 4\Pi_{\mathcal{H}}(2m)\exp\left(-\frac{m\epsilon^2}{8}\right).$$

    这就完成了证明。

基于上述引理，再结合关于 VC 维与增长函数之间关系，有下面的定理。

**定理 4.3**：若假设空间 $\mathcal{H}$ 的有限 VC 维为 $d$，$h \in \mathcal{H}$，则对 $m > d$ 和 $0 < \delta < 1$ 有

$$P\left(|E(h) - \widehat{E}(h)| \leq \sqrt{\frac{8d\ln \frac{2em}{d} + 8\ln \frac{4}{\delta}}{m}}\right) \geq 1 - \delta.$$

!!! Info "证明"

    由定理 3.1 可知

    $$4\Pi_{\mathcal{H}}(2m)\exp\left(-\frac{m\epsilon^2}{8}\right) \leq 4\left(\frac{2em}{d}\right)^d \exp\left(-\frac{m\epsilon^2}{8}\right).$$

    令 $4\left(\frac{2em}{d}\right)^d \exp\left(-\frac{m\epsilon^2}{8}\right) = \delta$ 可得

    $$\epsilon = \sqrt{\frac{8d\ln \frac{2em}{d} + 8\ln \frac{4}{\delta}}{m}}.$$

    将上式带入引理 4.1，定理得证。

通过此定理，我们可以知道 $E(h) \leq \widehat{E}(h) + O\left(\sqrt{\frac{\ln(m/d)}{m/d}}\right)$ 以至少 $1 - \delta$ 的概率成立，泛化误差的收敛率为 $O\left(\sqrt{\frac{\ln(m/d)}{m/d}}\right)$。对于有限 VC 维的假设空间，泛化误差的收敛率与 VC 维的大小有关，VC 维越大，假设空间越复杂，泛化误差的收敛率也越慢。其次，有限 VC 维的不可分假设空间比有限不可分假设空间更难收敛，这也是无限假设空间与有限假设空间的区别。

### 2.2 基于 Rademacher 复杂度的泛化误差界

对于从 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集 $Z$，函数空间 $\mathcal{F}$ 关于 $Z$ 的经验 Rademacher 复杂度和关于 $\mathcal{D}$ 的 Rademacher 复杂度分别是 $\widehat{\mathfrak{R}}_Z(\mathcal{F})$ 和 $\mathfrak{R}_m(\mathcal{F})$，基于 $\widehat{\mathfrak{R}}_Z(\mathcal{F})$ 和 $\mathfrak{R}_m(\mathcal{F})$ 可以分析关于函数空间 $\mathcal{F}$ 的泛化误差界。

**定理 4.4**：对于实值函数空间 $\mathcal{F} : \mathcal{Z} \mapsto [0,1]$，从分布 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集 $Z = \{z_1,z_2,\ldots,z_m\}$，$z_i \in \mathcal{Z}$，$f \in \mathcal{F}$ 和 $0 < \delta < 1$，以至少 $1 - \delta$ 的概率有

$$\begin{aligned}
    E(f) &\leq \widehat{E}(f) + 2\mathfrak{R}_m(\mathcal{F}) + \sqrt{\frac{\ln(1/\delta)}{2m}},\\
    E(f) &\leq \widehat{E}(f) + 2\widehat{\mathfrak{R}}_Z(\mathcal{F}) + 3\sqrt{\frac{\ln(2/\delta)}{2m}}.
\end{aligned}$$

!!! Info "证明"

    首先定义下面两个量：

    $$\begin{aligned}
        \widehat{E}_Z(f) &= \frac{1}{m}\sum_{i=1}^m f(z_i),\\
        \Phi(Z) &= \sup_{f\in\mathcal{F}}\left(\mathbb{E}[f] - \widehat{E}_Z(f)\right).
    \end{aligned}$$

    $Z^{\prime}$ 为与 $Z$ 仅有一个样本不同的训练集，不妨设 $z_m \in Z$ 和 $z'_m \in Z'$ 为不同样本，可得

    $$\begin{aligned}
        \Phi(Z') - \Phi(Z) &= \sup_{f\in\mathcal{F}}\left(\mathbb{E}[f] - \widehat{E}_{Z'}(f)\right) - \sup_{f\in\mathcal{F}}\left(\mathbb{E}[f] - \widehat{E}_Z(f)\right)\\
        &\leq \sup_{f\in\mathcal{F}}\left(\widehat{E}_Z(f) - \widehat{E}_{Z'}(f)\right)\\
        &= \sup_{f\in\mathcal{F}}\frac{f(z_m) - f(z'_m)}{m} \leq \frac{1}{m}.
    \end{aligned}$$

    同样可以得到

    $$\Phi(Z) - \Phi(Z') \leq \frac{1}{m}.$$

    从而可知

    $$|\Phi(Z) - \Phi(Z')| \leq \frac{1}{m}.$$

    这就表明了 $\Phi(Z)$ 是关于 $Z$ 差有界的。根据 McDiarmid 不等式可知，对于 $0 < \delta < 1$，

    $$\Phi(Z) \leq \mathbb{E}_Z[\Phi(Z)] + \sqrt{\frac{\ln(1/\delta)}{2m}}$$

    以至少 $1 - \delta$ 的概率成立。下面估计 $\mathbb{E}_Z[\Phi(Z)]$ 的上界，在使用完 McDiarmid 不等式之后，我们可以不要求 $Z^{\prime}$ 与 $Z$ 仅有一个样本不同，这两个集合就变成了分别从 $\mathcal{F}$ 中独立同分布采样得到的两个训练集。

    $$\begin{aligned}
        \mathbb{E}_Z[\Phi(Z)] &= \mathbb{E}_Z\left[\sup_{f\in\mathcal{F}}\left(\mathbb{E}[f] - \widehat{E}_Z(f)\right)\right]\\
        &= \mathbb{E}_Z\left[\sup_{f\in\mathcal{F}}\mathbb{E}_{Z'}\left[\widehat{E}_{Z'}[f] - \widehat{E}_Z[f]\right]\right] \leq \mathbb{E}_{Z,Z'}\left[\sup_{f\in\mathcal{F}}\left(\widehat{E}_{Z'}[f] - \widehat{E}_Z[f]\right)\right]\\
        &= \mathbb{E}_{Z,Z'}\left[\sup_{f\in\mathcal{F}}\frac{1}{m}\sum_{i=1}^m\left(f(z'_i) - f(z_i)\right)\right] = \mathbb{E}_{\sigma,Z,Z'}\left[\sup_{f\in\mathcal{F}}\frac{1}{m}\sum_{i=1}^m \sigma_i\left(f(z'_i) - f(z_i)\right)\right]\\
        &\leq \mathbb{E}_{\sigma,Z'}\left[\sup_{f\in\mathcal{F}}\frac{1}{m}\sum_{i=1}^m \sigma_if(z'_i)\right] + \mathbb{E}_{\sigma,Z}\left[\sup_{f\in\mathcal{F}}\frac{1}{m}\sum_{i=1}^m -\sigma_if(z_i)\right]\\
        &= 2\mathbb{E}_{\sigma,Z}\left[\sup_{f\in\mathcal{F}}\frac{1}{m}\sum_{i=1}^m \sigma_if(z_i)\right]\\
        &= 2\mathfrak{R}_m(\mathcal{F}).
    \end{aligned}$$

    有下面几点需要注意：

    - 第二个等号是对 $Z^{\prime}$ 的期望，这里其实也可以看出来 $Z^{\prime}$ 不可能是与 $Z$ 仅有一个样本不同的集合。
    - 第二行的不等号来自于 Jensen 不等式，利用了 $\sup$ 的凸性。
    - 第三行第二个等号利用了对称化的想法，在「机器学习算法的数学分析」的笔记中有介绍，其中由于 $z_i$ 和 $z^\prime_i$ 是独立同分布的，所以 $f(z_i) - f(z^\prime_i)$ 的分布关于原点对称，再乘以一个 Rademacher 随机变量 $\sigma_i$，当然不应强分布和均值。
    - 后面的推导就是很自然的事情了。

    这样，对于任意的 $f\in \mathcal{F}$，有

    $$\mathbb{E}[f] - \widehat{E}_Z(f) \leq \sup_{f\in\mathcal{F}}\left(\mathbb{E}[f] - \widehat{E}_Z(f)\right) = \Phi(Z) \leq \mathbb{E}_Z[\Phi(Z)] + \sqrt{\frac{\ln(1/\delta)}{2m}} = 2\mathfrak{R}_m(\mathcal{F}) + \sqrt{\frac{\ln(1/\delta)}{2m}}.$$

    因此，我们要的第一个式子得证。再然后，我们知道改变训练集中的一个样本后经验 Rademacher 复杂度最多改变 $1/m$，即 $|\widehat{\mathfrak{R}}_Z(\mathcal{F}) - \widehat{\mathfrak{R}}_{Z'}(\mathcal{F})| \leq 1/m$。再根据 McDiarmid 不等式可知：

    $$\widehat{\mathfrak{R}}_Z(\mathcal{F}) \leq \widehat{\mathfrak{R}}_{Z'}(\mathcal{F}) + \sqrt{\frac{\ln(2/\delta)}{2m}}$$

    以至少 $1 - \delta/2$ 的概率成立。还有

    $$\Phi(Z) \leq \mathbb{E}_Z[\Phi(Z)] + \sqrt{\frac{\ln(2/\delta)}{2m}}$$

    以至少 $1 - \delta/2$ 的概率成立。将上面两个不等式带入到下面的式子中，利用联合界不等式可得：

    $$\Phi(Z) \leq 2\widehat{\mathfrak{R}}_Z(\mathcal{F}) + 3\sqrt{\frac{\ln(2/\delta)}{2m}}$$

    以至少 $1 - \delta$ 的概率成立，从而第二个式子得证。

定理 4.4 的适用范围是实值函数空间 $\mathcal{F} : \mathcal{Z} \mapsto [0,1]$，一般用于回归问题。对于分类问题有下面的定理。

**定理 4.5**：对于假设空间 $\mathcal{H} : \mathcal{X} \mapsto \{-1,+1\}$，从分布 $\mathcal{D}$ 独立同分布采样得到的大小为 $m$ 的训练集 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}$，$\boldsymbol{x}_i \in \mathcal{X}$，$h \in \mathcal{H}$ 和 $0 < \delta < 1$，以至少 $1 - \delta$ 的概率有

$$\begin{aligned}
    E(h) &\leq \widehat{E}(h) + \mathfrak{R}_m(\mathcal{H}) + \sqrt{\frac{\ln(1/\delta)}{2m}},\\
    E(h) &\leq \widehat{E}(h) + \widehat{\mathfrak{R}}_D(\mathcal{H}) + 3\sqrt{\frac{\ln(2/\delta)}{2m}}.
\end{aligned}$$

!!! Info "证明"

    对于二分类问题的假设空间 $\mathcal{H}$，令 $\mathcal{Z} = \mathcal{X} \times \{-1,+1\}$，$\mathcal{H}$ 中的假设 $h$ 可以变形为 $f_h(z) = f_h(\boldsymbol{x},y) = \mathbb{I}(h(\boldsymbol{x}) \neq y)$。于是值域为 $\{-1,+1\}$ 的假设空间 $\mathcal{H}$ 转化为值域为 $[0,1]$ 的函数空间 $\mathcal{F}_{\mathcal{H}} = \{f_h : h \in \mathcal{H}\}$。从 Rademacher 复杂度的定义可知

    $$\begin{aligned}
        \widehat{\mathfrak{R}}_Z(\mathcal{F}_{\mathcal{H}}) &= \mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{f_h\in\mathcal{F}_{\mathcal{H}}} \frac{1}{m}\sum_{i=1}^m \sigma_if_h(\boldsymbol{x}_i,y_i)\right] = \mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m \sigma_i\mathbb{I}(h(\boldsymbol{x}_i) \neq y_i)\right]\\
        &= \mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m \sigma_i\frac{1-y_ih(\boldsymbol{x}_i)}{2}\right] = \frac{1}{2}\mathbb{E}_{\boldsymbol{\sigma}}\left[\frac{1}{m}\sum_{i=1}^m \sigma_i + \sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m (-y_i\sigma_ih(\boldsymbol{x}_i))\right]\\
        &= \frac{1}{2}\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m (-y_i\sigma_ih(\boldsymbol{x}_i))\right] = \frac{1}{2}\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}} \frac{1}{m}\sum_{i=1}^m (\sigma_ih(\boldsymbol{x}_i))\right]\\
        &= \frac{1}{2}\widehat{\mathfrak{R}}_D(\mathcal{H}).
    \end{aligned}$$

    - 第一行和第二行的等号都是纯粹的代入；
    - 第三行的第一个等号利用了 $\sigma$ 的均匀分布的性质，第二个等号利用了 $-y_i\sigma_i$ 和 $\sigma_i$ 等价的性质；
    - 后面就自然了。

    同时对上式两边取期望可得

    $$\mathfrak{R}_Z(\mathcal{F}_{\mathcal{H}}) = \frac{1}{2}\mathfrak{R}_D(\mathcal{H}).$$

    将上式代入定理 4.4，定理得证。

## 3. 泛化误差下界

<!-- 

## 4.2 泛化误差下界

基于 VC 维也可以分析泛化误差下界，这一下界的意义在于指出对于任何学习算法存在某一数据分布，当样本数目有限时，学习算法不能以较大概率输出目标概念的近似，其中的要点是如何找到这样一种数据分布。下面将针对假设空间可分与不可分这两种情形分别进行讨论。

**可分情形**

首先分析可分情形下的泛化误差下界 [Ehrenfeucht et al., 1988]。

**定理 4.6**：若假设空间 $\mathcal{H}$ 的 VC 维 $d > 1$，则对任意 $m > 1$ 和学习算法 $\mathfrak{L}$，存在分布 $\mathcal{D}$ 和目标概念 $c \in \mathcal{H}$ 使得

$$P\left(E(h_D,c) > \frac{d-1}{32m}\right) \geq \frac{1}{100},$$ (4.41)

其中 $h_D$ 为学习算法 $\mathfrak{L}$ 基于大小为 $m$ 的训练集 $D$ 输出的假设。

**证明**：由于 VC 维 $d > 1$，不妨令 $S = \{\boldsymbol{x}_0,\ldots,\boldsymbol{x}_{d-1}\} \subset \mathcal{X}$ 表示能被 $\mathcal{H}$ 打散的集合。对于 $\epsilon > 0$，下面将构造一种数据分布 $\mathcal{D}$ 使得概率质量集中在 $S$ 上，并且较高的概率质量 $(1-8\epsilon)$ 集中在 $\boldsymbol{x}_0$ 上，而其余的概率质量平均分配在其他点上：

$$P_{\mathcal{D}}(\boldsymbol{x}_0) = 1-8\epsilon \wedge P_{\mathcal{D}}(\boldsymbol{x}_i) = \frac{8\epsilon}{d-1} \quad (i \in [d-1]).$$ (4.42)

根据以上构造过程，从分布 $\mathcal{D}$ 采样得到的数据集主要包含 $\boldsymbol{x}_0$。由于 $\mathcal{H}$ 将 $S$ 打散，因此对于 $S$ 中未出现的样本，任意学习算法 $\mathfrak{L}$ 的预测不会优于随机结果。

不失一般性，假设学习算法 $\mathfrak{L}$ 在 $\boldsymbol{x}_0$ 上预测正确。对于大小为 $m$ 的训练集 $D$，令 $\bar{D}$ 表示出现在 $\{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_{d-1}\}$ 中的样本集合，$A = \{D \sim \mathcal{D}^m|(|D| = m) \wedge (|\bar{D}| \leq (d-1)/2)\}$。对于给定的 $D \in A$，考虑来自均匀分布 $\mathcal{U}$ 的目标概念 $c : S \mapsto \{-1,+1\}$。由于 $S$ 可以被 $\mathcal{H}$ 打散，根据如上构造可得

$$\begin{aligned}
\mathbb{E}_{\mathcal{U}}[E(h_D,c)] &= \sum_c\sum_{\boldsymbol{x}\in S}\mathbb{I}(h_D(\boldsymbol{x}) \neq c(\boldsymbol{x}))P_{\boldsymbol{x}\sim\mathcal{D}}(\boldsymbol{x})P_{c\sim\mathcal{U}}(c)\\
&\geq \sum_c \sum_{\boldsymbol{x}\in S-\bar{D}-\{\boldsymbol{x}_0\}}\mathbb{I}(h_D(\boldsymbol{x}) \neq c(\boldsymbol{x}))P_{\boldsymbol{x}\sim\mathcal{D}}(\boldsymbol{x})P_{c\sim\mathcal{U}}(c)\\
&= \sum_{\boldsymbol{x}\in S-\bar{D}-\{\boldsymbol{x}_0\}}\left(\sum_c\mathbb{I}(h_D(\boldsymbol{x}) \neq c(\boldsymbol{x}))P_{c\sim\mathcal{U}}(c)\right)P_{\boldsymbol{x}\sim\mathcal{D}}(\boldsymbol{x})\\
&= \frac{1}{2}\sum_{\boldsymbol{x}\in S-\bar{D}-\{\boldsymbol{x}_0\}}P_{\boldsymbol{x}\sim\mathcal{D}}(\boldsymbol{x})\\
&\geq \frac{1}{2}\frac{d-1}{2}\frac{8\epsilon}{d-1} = 2\epsilon.\end{aligned}$$ (4.43)

由于 $\mathbb{E}_{\mathcal{U}}[E(h_D,c)] \geq 2\epsilon$ 对于任意 $D \in A$ 均成立，因此关于 $A$ 的期望也成立，即 $\mathbb{E}_{D\in A}[\mathbb{E}_{\mathcal{U}}[E(h_D,c)]] \geq 2\epsilon$。根据 Fubini 定理 [Stein and Shakarchi, 2009]：若函数 $f(x,y)$ 的期望 $\mathbb{E}_{x,y}[|f(x,y)|] < \infty$，则

$$\mathbb{E}_x[\mathbb{E}_y[f(x,y)]] = \mathbb{E}_y[\mathbb{E}_x[f(x,y)]],$$ (4.44)

可知交换期望计算顺序不等式依然成立，即有

$$\mathbb{E}_{\mathcal{U}}[\mathbb{E}_{D\in A}[E(h_D,c)]] \geq 2\epsilon.$$ (4.45)

由于期望的下界为 $2\epsilon$，必定存在一个目标概念 $c^* \in \mathcal{H}$ 满足 $\mathbb{E}_{D\in A}[E(h_D,c^*)] \geq 2\epsilon$，其中 $E(h_D,c^*) = \mathbb{E}_{\mathcal{D}}[\mathbb{I}(h_D(\boldsymbol{x}) \neq c^*(\boldsymbol{x}))]$。下面将该期望按照 $E(h_D,c^*)$ 的取值分解成如下两部分

$$\begin{aligned}
\mathbb{E}_{D\in A}[E(h_D,c^*)] &= \sum_{D:E(h_D,c^*)>\epsilon}E(h_D,c^*)P(D) + \sum_{D:E(h_D,c^*)\leq\epsilon}E(h_D,c^*)P(D)\\
&\leq P_{\boldsymbol{x}\sim\mathcal{D}}(\boldsymbol{x} \in (S-\{\boldsymbol{x}_0\}))P_{D\in A}(E(h_D,c^*) > \epsilon)\\
&\quad + \epsilon(1-P_{D\in A}(E(h_D,c^*) > \epsilon))\\
&= 8\epsilon P_{D\in A}(E(h_D,c^*) > \epsilon) + \epsilon(1-P_{D\in A}(E(h_D,c^*) > \epsilon))\\
&= \epsilon + 7\epsilon P_{D\in A}(E(h_D,c^*) > \epsilon).\end{aligned}$$ (4.46)

基于 (4.46) 和 $\mathbb{E}_{D\in A}[E(h_D,c^*)] \geq 2\epsilon$，可求解出

$$P_{D\in A}(E(h_D,c^*) > \epsilon) \geq \frac{1}{7\epsilon}(2\epsilon-\epsilon) = \frac{1}{7}.$$ (4.47)

因此，在所有大小为 $m$ 的样本集合 $\mathcal{D}^m$ 中，满足 $E(h_D,c^*) > \epsilon$ 的样本集出现的概率为

$$\begin{aligned}
P_{D\sim\mathcal{D}^m}(E(h_D,c^*) > \epsilon) &\geq P_{D\in A}(E(h_D,c^*) > \epsilon)P_{D\sim\mathcal{D}^m}(D \in A)\\
&\geq \frac{1}{7}P_{D\sim\mathcal{D}^m}(D \in A).\end{aligned}$$ (4.48)

接下来，只要找到 $P_{D\sim\mathcal{D}^m}(D \in A)$ 的下界即可证明定理。

令 $l_m$ 表示从 $S$ 中按分布 $\mathcal{D}$ 独立同分布采样 $m$ 个样本落在 $\{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_{d-1}\}$ 中的数目，根据 Chernoff 不等式 (1.26) 可知，对于 $\gamma > 1$，有

$$P_{D\sim\mathcal{D}^m}(l_m \geq 8\epsilon m(1+\gamma)) \leq e^{-8\epsilon m\frac{\gamma^2}{3}}.$$ (4.49)

令 $\epsilon = (d-1)/(32m)$，$\gamma = 1$，可得

$$\begin{aligned}
1 - P_{D\sim\mathcal{D}^m}(D \in A) &= P_{D\sim\mathcal{D}^m}\left(l_m \geq \frac{d-1}{2}\right)\\
&\leq e^{-(d-1)/12}\\
&\leq e^{-1/12}.\end{aligned}$$ (4.50)

令 $e^{-1/12} \leq 1 - 7\delta$，可得 $P_{D\sim\mathcal{D}^m}(D \in A) \geq 7\delta$，再根据

$$P_{D\sim\mathcal{D}^m}(E(h_D,c^*) > \epsilon) \geq \frac{1}{7}P_{D\sim\mathcal{D}^m}(D \in A)$$ (4.51)

可知

$$P_{D\sim\mathcal{D}^m}(E(h_D,c^*) > \epsilon) \geq \delta,$$ (4.52)

取 $\delta = \frac{1}{100}$，从而定理得证。 □

定理 4.6 表明对于任意学习算法 $\mathfrak{L}$，必存在一种"坏"分布 $\mathcal{D}$ 以及一个目标概念 $c^*$，使得 $\mathfrak{L}$ 输出的假设 $h_D$ 总会以较高概率（至少 1%）产生 $O(\frac{d}{m})$ 的错误。需要注意的是，定理 4.6 中数据分布 $\mathcal{D}$ 是与学习算法 $\mathfrak{L}$ 无关的，只与假设空间 $\mathcal{H}$ 有关。

**不可分情形**

对于不可分假设空间的泛化误差下界，主要比较学习算法 $\mathfrak{L}$ 的泛化误差与贝叶斯最优分类器 (Bayes' classifier) 泛化误差之间的关系。首先，需要先给出两个引理 [Mohri et al., 2018]。

**引理 4.2**：令 $\sigma$ 为服从 $\{-1,+1\}$ 上均匀分布的随机变量，对于 $0 < \alpha < 1$ 构造随机变量 $\alpha_{\sigma} = \frac{1}{2} + \frac{\alpha\sigma}{2}$，基于 $\sigma$ 构造 $X \sim \mathcal{D}_{\sigma}$，其中 $\mathcal{D}_{\sigma}$ 为伯努利分布 Bernoulli$(\alpha_{\sigma})$，即 $P(X = 1) = \alpha_{\sigma}$。令 $S = \{X_1,\ldots,X_m\}$ 表示从分布 $\mathcal{D}_{\sigma}^m$ 独立同分布采样得到的大小为 $m$ 的集合，即 $S \sim \mathcal{D}_{\sigma}^m$，则对于函数 $f : X^m \mapsto \{-1,+1\}$ 有

$$\mathbb{E}_{\sigma}[P_{S\sim\mathcal{D}_{\sigma}^m}(f(S) \neq \sigma)] \geq \Phi(2\lfloor m/2\rfloor,\alpha),$$ (4.53)

其中 $\Phi(m,\alpha) = \frac{1}{4}\left(1-\sqrt{1-\exp\left(-\frac{m\alpha^2}{1-\alpha^2}\right)}\right)$。

根据引理 4.2 进一步推导可知，为了确定 $\sigma$ 的取值，$m$ 至少应为 $\Omega(\frac{1}{\alpha^2})$。此外，还需要下面的引理以在推导过程中进行放缩。

**引理 4.3**：令 $Z$ 为取值范围为 $[0,1]$ 的随机变量，对于 $\gamma \in [0,1)$ 有

$$P(Z > \gamma) \geq \frac{\mathbb{E}[Z]-\gamma}{1-\gamma} \geq \mathbb{E}[Z]-\gamma.$$ (4.54)

**证明**：要点在于将 $Z$ 的取值范围按照 $\gamma$ 进行划分并分别进行放缩，考虑随机变量 $Z$ 的期望

$$\begin{aligned}
\mathbb{E}[Z] &= \sum_{z\leq\gamma}P(Z = z)z + \sum_{z>\gamma}P(Z = z)z\\
&\leq \sum_{z\leq\gamma}P(Z = z)\gamma + \sum_{z>\gamma}P(Z = z)\\
&= \gamma P(Z \leq \gamma) + P(Z > \gamma)\\
&= \gamma(1 - P(Z > \gamma)) + P(Z > \gamma)\\
&= (1-\gamma)P(Z > \gamma) + \gamma.\end{aligned}$$ (4.55)

整理化简可得

$$P(z > \gamma) \geq \frac{\mathbb{E}[Z]-\gamma}{1-\gamma} \geq \mathbb{E}[Z]-\gamma.$$ (4.56)

□

基于引理 4.2 和引理 4.3 可以分析不可分情形下的泛化误差下界 [Anthony and Bartlett, 2009]。

**定理 4.7**：若假设空间 $\mathcal{H}$ 的 VC 维 $d > 1$，则对任意 $m > 1$ 和学习算法 $\mathfrak{L}$，存在分布 $\mathcal{D}$ 使得

$$P_{Z\sim\mathcal{D}^m}\left(E(h_Z) - \inf_{h\in\mathcal{H}}E(h) > \sqrt{\frac{d}{320m}}\right) \geq \frac{1}{64}.$$ (4.57)

其中 $h_Z$ 为学习算法 $\mathfrak{L}$ 基于大小为 $m$ 的训练集 $Z$ 输出的假设。

**证明**：令 $S = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_d\} \subset \mathcal{X}$ 表示能被 $\mathcal{H}$ 打散的集合。对于 $\alpha \in [0,1]$ 和向量 $\boldsymbol{\sigma} = (\sigma_1;\cdots;\sigma_d) \in \{-1,+1\}^d$，在 $S \times \mathcal{Y}$ 上构造如下分布 $\mathcal{D}_{\sigma}$

$$P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,+1)) = \frac{1}{d}\left(\frac{1}{2} + \frac{\sigma_i\alpha}{2}\right) \quad (i \in [d]),$$ (4.58)

$$P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,-1)) = \frac{1}{d}\left(\frac{1}{2} - \frac{\sigma_i\alpha}{2}\right) \quad (i \in [d]).$$ (4.59)

令 $\inf_{h\in\mathcal{H}}E(h)$ 表示假设空间 $\mathcal{H}$ 所能达到的最优误差。不妨考虑一种极端情形，将 $\mathcal{H}$ 放松到所有假设空间，即达到贝叶斯最优分类器 $h_{\mathcal{D}_{\sigma}}^*$ 的泛化误差，其中 $h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = \arg\max_{y\in\{-1,+1\}}P(y|\boldsymbol{x}_i) = \text{sign}(\mathbb{I}(\sigma_i > 0) - 1/2)$，$i \in [d]$。因为 $S$ 能被 $\mathcal{H}$ 打散，可知 $h_{\mathcal{D}_{\sigma}}^* \in \mathcal{H}$。

对于 $h_{\mathcal{D}_{\sigma}}^*$ 计算可得

$$\begin{aligned}
E(h_{\mathcal{D}_{\sigma}}^*) &= \sum_{\boldsymbol{x}_i\in S}\left(P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,+1))\mathbb{I}(h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = -1)\right.\\
&\quad\left.+ P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,-1))\mathbb{I}(h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = +1)\right)\\
&= \sum_{\boldsymbol{x}_i\in S}\left(P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,+1))\mathbb{I}(\sigma_i < 0) + P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,-1))\mathbb{I}(\sigma_i > 0)\right)\\
&= \sum_{\boldsymbol{x}_i\in S}\frac{1}{d}\left(\frac{1}{2} - \frac{\alpha}{2}\right) = \frac{1}{2} - \frac{\alpha}{2}.\end{aligned}$$ (4.60)

对于任意 $h \in \mathcal{H}$ 计算可得

$$\begin{aligned}
E(h) &= \sum_{\boldsymbol{x}_i\in S}\left(P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,+1))\mathbb{I}(h(\boldsymbol{x}_i) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i))\mathbb{I}(h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = +1)\right.\\
&\quad + P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,+1))\mathbb{I}(h(\boldsymbol{x}_i) = h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i))\mathbb{I}(h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = -1)\\
&\quad + P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,-1))\mathbb{I}(h(\boldsymbol{x}_i) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i))\mathbb{I}(h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = -1)\\
&\quad + P_{\mathcal{D}_{\sigma}}(z = (\boldsymbol{x}_i,-1))\mathbb{I}(h(\boldsymbol{x}_i) = h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i))\mathbb{I}(h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i) = +1)\left.\right)\\
&= \sum_{\boldsymbol{x}_i\in S}\left(\frac{1+\alpha}{2d}\mathbb{I}(h(\boldsymbol{x}_i) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i)) + \frac{1-\alpha}{2d}\mathbb{I}(h(\boldsymbol{x}_i) = h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i))\right)\\
&= \frac{\alpha}{d}\sum_{\boldsymbol{x}_i\in S}\mathbb{I}(h(\boldsymbol{x}_i) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i)) + \frac{1}{2} - \frac{\alpha}{2}.\end{aligned}$$ (4.61)

从而可知

$$E(h) - E(h_{\mathcal{D}_{\sigma}}^*) = \frac{\alpha}{d}\sum_{\boldsymbol{x}_i\in S}\mathbb{I}(h(\boldsymbol{x}_i) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x}_i)).$$ (4.62)

令 $h_Z$ 表示算法 $\mathfrak{L}$ 基于从分布 $\mathcal{D}_{\sigma}$ 独立同分布采样得到的 $Z$ 而输出的假设，$|Z|_{\boldsymbol{x}}$ 表示样本 $\boldsymbol{x}$ 在 $Z$ 中出现的次数，$\mathcal{U}$ 为 $\{-1,+1\}^d$ 上的均匀分布，基于 (4.62) 计算可得：

$$\begin{aligned}
\mathbb{E}_{\boldsymbol{\sigma}\sim\mathcal{U},Z\sim\mathcal{D}_{\sigma}^m}\left[\frac{1}{\alpha}\left(E(h_Z) - E(h_{\mathcal{D}_{\sigma}}^*)\right)\right]
&= \frac{1}{d}\sum_{\boldsymbol{x}\in S}\mathbb{E}_{\boldsymbol{\sigma}\sim\mathcal{U},Z\sim\mathcal{D}_{\sigma}^m}\left[\mathbb{I}\left(h_Z(\boldsymbol{x}) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x})\right)\right]\\
&= \frac{1}{d}\sum_{\boldsymbol{x}\in S}\mathbb{E}_{\boldsymbol{\sigma}\sim\mathcal{U}}\left[P_{Z\sim\mathcal{D}_{\sigma}^m}\left(h_Z(\boldsymbol{x}) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x})\right)\right]\\
&= \frac{1}{d}\sum_{\boldsymbol{x}\in S}\sum_{n=0}^m\mathbb{E}_{\boldsymbol{\sigma}\sim\mathcal{U}}\left[P_{Z\sim\mathcal{D}_{\sigma}^m}\left(h_Z(\boldsymbol{x}) \neq h_{\mathcal{D}_{\sigma}}^*(\boldsymbol{x})||Z|_{\boldsymbol{x}} = n\right)P(|Z|_{\boldsymbol{x}} = n)\right]\\
&\geq \frac{1}{d}\sum_{\boldsymbol{x}\in S}\sum_{n=0}^m\Phi(2\lfloor n/2\rfloor,\alpha)P(|Z|_{\boldsymbol{x}} = n)\\
&\geq \frac{1}{d}\sum_{\boldsymbol{x}\in S}\sum_{n=0}^m\Phi(n+1,\alpha)P(|Z|_{\boldsymbol{x}} = n)\\
&\geq \frac{1}{d}\sum_{\boldsymbol{x}\in S}\Phi(m/d+1,\alpha) = \Phi(m/d+1,\alpha).\end{aligned}$$ (4.63)

由于上述关于 $\boldsymbol{\sigma}$ 期望的下界被 $\Phi(m/d+1,\alpha)$ 限制住，则必定存在 $\boldsymbol{\sigma}^* \in \{-1,+1\}^d$ 使得下式成立

$$\mathbb{E}_{Z\sim\mathcal{D}_{\sigma^*}^m}\left[\frac{1}{\alpha}\left(E(h_Z) - E(h_{\mathcal{D}_{\sigma^*}}^*)\right)\right] \geq \Phi(m/d+1,\alpha).$$ (4.64)

根据引理 4.3 可知，对于 $\boldsymbol{\sigma}^*$ 以及任意 $\gamma \in [0,1)$ 有

$$P_{Z\sim\mathcal{D}_{\sigma^*}^m}\left(\frac{1}{\alpha}\left(E(h_Z) - E(h_{\mathcal{D}_{\sigma^*}}^*)\right) > \gamma u\right) \geq (1-\gamma)u.$$ (4.65)

其中 $u = \Phi(m/d+1,\alpha)$。令 $\delta$ 与 $\epsilon$ 满足条件 $\delta \leq (1-\gamma)u$ 以及 $\epsilon \leq \gamma\alpha u$，则有

$$P_{Z\sim\mathcal{D}_{\sigma^*}^m}\left(E(h_Z) - E\left(h_{\mathcal{D}_{\sigma^*}}^*\right) > \epsilon\right) \geq \delta.$$ (4.66)

为了找到满足条件的 $\delta$ 与 $\epsilon$，令 $\gamma = 1-8\delta$，则

$$\begin{aligned}
\delta \leq (1-\gamma)u &\Longleftrightarrow u \geq \frac{1}{8}\\
&\Longleftrightarrow \frac{1}{4}\left(1-\sqrt{1-\exp\left(-\frac{(m/d+1)\alpha^2}{1-\alpha^2}\right)}\right) \geq \frac{1}{8}\\
&\Longleftrightarrow \frac{(m/d+1)\alpha^2}{1-\alpha^2} \leq \ln \frac{4}{3}\\
&\Longleftrightarrow \frac{m}{d} \leq \left(\frac{1}{\alpha^2}-1\right)\ln \frac{4}{3}-1.\end{aligned}$$ (4.67)

令 $\alpha = 8\epsilon/(1-8\delta)$，即 $\epsilon = \gamma\alpha/8$，可将 (4.67) 转换为

$$\frac{m}{d} \leq \left(\frac{(1-8\delta)^2}{64\epsilon^2}-1\right)\ln \frac{4}{3}-1.$$ (4.68)

令 $\delta \leq 1/64$，可得

$$\left(\frac{(1-8\delta)^2}{64\epsilon^2}-1\right)\ln \frac{4}{3}-1 \geq \left(\frac{7}{64}\right)^2\frac{1}{\epsilon^2}\ln \frac{4}{3}-\ln \frac{4}{3}-1.$$ (4.69)

(4.69) 右端为关于 $\frac{1}{\epsilon^2}$ 的函数 $f(\frac{1}{\epsilon^2})$，可寻找 $w$ 使得 $m/d \leq w/\epsilon^2$。令 $\epsilon \leq 1/64$，由 $\frac{w}{(1/64)^2} = f\left(\frac{1}{(1/64)^2}\right)$ 可得

$$w = (7/64)^2\ln(4/3) - (1/64)^2(\ln(4/3) + 1) \approx 0.003127 \geq 1/320.$$ (4.70)

因此，当 $\epsilon^2 \leq \frac{1}{320m/d}$ 时，满足 $\delta \leq (1-\gamma)u$ 以及 $\epsilon \leq \gamma\alpha u$。取 $\epsilon = \sqrt{\frac{d}{320m}}$ 和 $\delta = 1/64$，定理得证。 □

定理 4.7 表明对于任意学习算法 $\mathfrak{L}$，在不可分情形下必存在一种"坏"分布 $\mathcal{D}_{\sigma^*}$，使得 $\mathfrak{L}$ 输出的假设 $h_Z$ 的泛化误差以常数概率为 $O\left(\sqrt{\frac{d}{m}}\right)$。

## 4.3 分析实例

本节将分析支持向量机的泛化误差界。

支持向量机考虑的假设空间是线性超平面，定理 3.6 证明了 $\mathbb{R}^d$ 中线性超平面的 VC 维为 $d+1$，再结合定理 4.3 可以得到支持向量机基于 VC 维的泛化误差界：对于 $0 < \delta < 1$，以至少 $1-\delta$ 的概率有

$$E(h) \leq \widehat{E}(h) + \sqrt{\frac{8(d+1)\ln \frac{2em}{d+1} + 8\ln \frac{4}{\delta}}{m}}.$$ (4.71)

当样本空间的维数相对于样本的数目很大时，(4.71) 没有给出具有实际意义的信息。另外，定理 3.8 给出了一种不依赖样本空间维数的 VC 维的估计方法，但是需要限制样本的范数，使得 $\|\boldsymbol{x}\| \leq r$。因此当样本空间有界时，基于定理 3.8 和定理 4.3 也可以得到支持向量机基于 VC 维的泛化误差界。

然而在实际应用中，支持向量机通常会使用替代损失函数，例如 (1.72) 中提到的 hinge 损失函数。下面我们就来讨论使用替代损失函数的支持向量机的泛化误差界。考虑比 hinge 损失函数更具一般性的间隔损失函数：

**定义 4.1**：对于任意 $\rho > 0$，$\rho$-间隔损失 为定义在 $z,z' \in \mathbb{R}$ 上的损失函数 $\ell_{\rho} : \mathbb{R} \times \mathbb{R} \mapsto \mathbb{R}_+$，$\ell_{\rho}(z,z') = \Phi_{\rho}(zz')$，其中

$$\Phi_{\rho}(x) = \begin{cases}
0 & \rho \leq x\\
1-x/\rho & 0 \leq x \leq \rho\\
1 & x \leq 0
\end{cases}.$$ (4.72)

对于集合 $D = \{\boldsymbol{x}_1,\ldots,\boldsymbol{x}_m\}$ 与假设 $h$，经验间隔损失表示为

$$\widehat{E}_{\rho}(h) = \frac{1}{m}\sum_{i=1}^m \Phi_{\rho}(y_ih(\boldsymbol{x}_i)).$$ (4.73)

考虑到 $\Phi_{\rho}(y_ih(\boldsymbol{x}_i)) \leq \mathbb{I}_{y_ih(\boldsymbol{x}_i)\leq\rho}$，对于经验间隔损失，有

$$\widehat{E}_{\rho}(h) \leq \frac{1}{m}\sum_{i=1}^m \mathbb{I}_{y_ih(\boldsymbol{x}_i)\leq\rho}.$$ (4.74)

由经验间隔损失 (4.72) 可知 $\Phi_{\rho}$ 最多是 $\frac{1}{\rho}$-Lipschitz。引理 4.4 表明 Lipschitz 函数和假设空间 $\mathcal{H}$ 复合后的经验 Rademacher 复杂度可以基于假设空间 $\mathcal{H}$ 的经验 Rademacher 复杂度进行表示。

**引理 4.4**：若 $\Phi : \mathbb{R} \mapsto \mathbb{R}$ 为 $l$-Lipschitz 函数，则对于任意实值假设空间 $\mathcal{H}$ 有下式成立：

$$\widehat{\mathfrak{R}}_D(\Phi \circ \mathcal{H}) \leq l\widehat{\mathfrak{R}}_D(\mathcal{H}).$$ (4.75)

下面将给出基于间隔损失函数的二分类问题支持向量机的泛化误差界。

**定理 4.8**：令 $\mathcal{H}$ 为实值假设空间，给定 $\rho > 0$，对于 $0 < \delta < 1$ 和 $h \in \mathcal{H}$，以至少 $1-\delta$ 的概率有

$$E(h) \leq \widehat{E}_{\rho}(h) + \frac{2}{\rho}\mathfrak{R}_m(\mathcal{H}) + \sqrt{\frac{\ln \frac{1}{\delta}}{2m}},$$ (4.76)

$$E(h) \leq \widehat{E}_{\rho}(h) + \frac{2}{\rho}\widehat{\mathfrak{R}}_D(\mathcal{H}) + 3\sqrt{\frac{\ln \frac{2}{\delta}}{2m}}.$$ (4.77)

**证明**：构造 $\tilde{\mathcal{H}} = \{z = (x,y) \mapsto yh(\boldsymbol{x}) : h \in \mathcal{H}\}$，考虑值域为 $[0,1]$ 的假设空间 $\mathcal{F} = \{\Phi_{\rho} \circ f : f \in \tilde{\mathcal{H}}\}$，根据 (4.25) 可知对于所有 $g \in \mathcal{F}$，以至少 $1-\delta$ 的概率有

$$\mathbb{E}[g(z)] \leq \frac{1}{m}\sum_{i=1}^m g(z_i) + 2\mathfrak{R}_m(\mathcal{F}) + \sqrt{\frac{\ln \frac{1}{\delta}}{2m}}.$$ (4.78)

因此，对于 $h \in \mathcal{H}$，以至少 $1-\delta$ 的概率有

$$\mathbb{E}[\Phi_{\rho}(yh(\boldsymbol{x}))] \leq \widehat{E}_{\rho}(h) + 2\mathfrak{R}_m(\Phi_{\rho} \circ \tilde{\mathcal{H}}) + \sqrt{\frac{\ln \frac{1}{\delta}}{2m}}.$$ (4.79)

因为 $\mathbb{I}_{u\leq 0} \leq \Phi_{\rho}(u)$ 对任意 $u \in \mathbb{R}$ 成立，所以 $E(h) = \mathbb{E}[\mathbb{I}_{yh(\boldsymbol{x})\leq 0}] \leq \mathbb{E}[\Phi_{\rho}(yh(\boldsymbol{x}))]$，代入 (4.96) 可知

$$E(h) \leq \widehat{E}_{\rho}(h) + 2\mathfrak{R}_m(\Phi_{\rho} \circ \tilde{\mathcal{H}}) + \sqrt{\frac{\ln \frac{1}{\delta}}{2m}}$$ (4.80)

以至少 $1 - \delta$ 的概率成立。由于 $\Phi_{\rho}$ 是 $\frac{1}{\rho}$-Lipschitz，根据引理 4.4 可知

$$\mathfrak{R}_m(\Phi_{\rho} \circ \tilde{\mathcal{H}}) \leq \frac{1}{\rho}\mathfrak{R}_m(\tilde{\mathcal{H}}).$$ (4.81)

考虑到 $\mathfrak{R}_m(\tilde{\mathcal{H}})$ 可以重写为

$$\begin{aligned}
\mathfrak{R}_m(\tilde{\mathcal{H}}) &= \frac{1}{m}\mathbb{E}_{D,\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}}\sum_{i=1}^m \sigma_iy_ih(\boldsymbol{x}_i)\right]\\
&= \frac{1}{m}\mathbb{E}_{D,\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}}\sum_{i=1}^m \sigma_ih(\boldsymbol{x}_i)\right]\\
&= \mathfrak{R}_m(\mathcal{H}),\end{aligned}$$ (4.82)

基于 (4.81) 可得

$$\mathfrak{R}_m(\Phi_{\rho} \circ \tilde{\mathcal{H}}) \leq \frac{1}{\rho}\mathfrak{R}_m(\mathcal{H}).$$ (4.83)

将其代入 (4.80), 可知

$$E(h) \leq \widehat{E}_{\rho}(h) + \frac{2}{\rho}\mathfrak{R}_m(\mathcal{H}) + \sqrt{\frac{\ln \frac{1}{\delta}}{2m}}$$ (4.84)

以至少 $1 - \delta$ 的概率成立，从而 (4.76) 得证。

基于 (4.26) 可知

$$\mathbb{E}[g(z)] \leq \frac{1}{m}\sum_{i=1}^m g(z_i) + 2\widehat{\mathfrak{R}}_D(\mathcal{F}) + 3\sqrt{\frac{\ln \frac{2}{\delta}}{2m}}$$ (4.85)

以至少 $1 - \delta$ 的概率成立。通过类似于 (4.78)～(4.80) 的推导可知

$$E(h) \leq \widehat{E}_{\rho}(h) + 2\widehat{\mathfrak{R}}_D(\Phi_{\rho} \circ \tilde{\mathcal{H}}) + 3\sqrt{\frac{\ln \frac{2}{\delta}}{2m}}$$ (4.86)

以至少 $1 - \delta$ 的概率成立。

对于经验 Rademacher 复杂度，由于 $\Phi_{\rho}$ 是 $\frac{1}{\rho}$-Lipschitz，类似 (4.81) 可得

$$\widehat{\mathfrak{R}}_D(\Phi_{\rho} \circ \tilde{\mathcal{H}}) \leq \frac{1}{\rho}\widehat{\mathfrak{R}}_D(\tilde{\mathcal{H}}).$$ (4.87)

考虑到 $\widehat{\mathfrak{R}}_D(\tilde{\mathcal{H}})$ 可以重写为

$$\begin{aligned}
\widehat{\mathfrak{R}}_D(\tilde{\mathcal{H}}) &= \frac{1}{m}\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}}\sum_{i=1}^m \sigma_iy_ih(\boldsymbol{x}_i)\right]\\
&= \frac{1}{m}\mathbb{E}_{\boldsymbol{\sigma}}\left[\sup_{h\in\mathcal{H}}\sum_{i=1}^m \sigma_ih(\boldsymbol{x}_i)\right]\\
&= \widehat{\mathfrak{R}}_m(\mathcal{H}),\end{aligned}$$ (4.88)

结合 (4.86)～(4.88) 可知

$$E(h) \leq \widehat{E}_{\rho}(h) + \frac{2}{\rho}\widehat{\mathfrak{R}}_D(\mathcal{H}) + 3\sqrt{\frac{\ln \frac{2}{\delta}}{2m}}$$ (4.89)

以至少 $1 - \delta$ 的概率成立，从而 (4.77) 得证。 □

定理 4.8 中要求 $\rho$ 是事先给定的，下面给出的定理则可以对任意 $\rho \in (0,1)$ 均成立。

**定理 4.9** 令 $\mathcal{H}$ 为实值假设空间，对于 $0 < \delta < 1$，$h \in \mathcal{H}$ 以及任意 $\rho \in (0,1)$，以至少 $1 - \delta$ 的概率有

$$E(h) \leq \widehat{E}_{\rho}(h) + \frac{4}{\rho}\mathfrak{R}_m(\mathcal{H}) + \sqrt{\frac{\ln \log_2 \frac{2}{\rho}}{m}} + \sqrt{\frac{\ln \frac{2}{\delta}}{2m}},$$ (4.90)

$$E(h) \leq \widehat{E}_{\rho}(h) + \frac{4}{\rho}\widehat{\mathfrak{R}}_D(\mathcal{H}) + \sqrt{\frac{\ln \log_2 \frac{2}{\rho}}{m}} + 3\sqrt{\frac{\ln \frac{4}{\delta}}{2m}}.$$ (4.91)

由定理 3.7 可知 $\widehat{\mathfrak{R}}_D(\mathcal{H}) \leq \sqrt{\frac{r^2\Lambda^2}{m}}$，对其两边取期望可得 $\mathfrak{R}_m(\mathcal{H}) \leq \sqrt{\frac{r^2\Lambda^2}{m}}$，进一步结合定理 4.8 和定理 4.9 可得下面的两个推论。

**推论 4.1** 令 $\mathcal{H} = \{\boldsymbol{x} \mapsto \boldsymbol{w} \cdot \boldsymbol{x} : \|\boldsymbol{w}\| \leq \Lambda\}$ 且 $\|\boldsymbol{x}\| \leq r$，对于 $0 < \delta < 1$，$h \in \mathcal{H}$ 和固定的 $\rho > 0$，以至少 $1 - \delta$ 的概率有

$$E(h) \leq \widehat{E}_{\rho}(h) + 2\sqrt{\frac{r^2\Lambda^2/\rho^2}{m}} + \sqrt{\frac{\ln \frac{1}{\delta}}{2m}}.$$ (4.92)

**推论 4.2** 令 $\mathcal{H} = \{\boldsymbol{x} \mapsto \boldsymbol{w} \cdot \boldsymbol{x} : \|\boldsymbol{w}\| \leq \Lambda\}$ 且 $\|\boldsymbol{x}\| \leq r$，对于 $0 < \delta < 1$，$h \in \mathcal{H}$ 和任意 $\rho \in (0,1)$，以至少 $1 - \delta$ 的概率有

$$E(h) \leq \widehat{E}_{\rho}(h) + 4\sqrt{\frac{r^2\Lambda^2/\rho^2}{m}} + \sqrt{\frac{\ln \log_2 \frac{2}{\rho}}{m}} + \sqrt{\frac{\ln \frac{2}{\delta}}{2m}}.$$ (4.93)

由本章的内容可以发现，泛化界主要讨论的是学习算法 $\mathfrak{L}$ 输出假设 $h$ 的泛化误差与经验误差之间的关系，而第 2 章介绍的 PAC 学习理论要求的是找到假设空间中具有最小泛化误差假设的 $\epsilon$ 近似。若要实现这一目标，则需要引入经验风险最小化 (Empirical Risk Minimization)：

如果学习算法 $\mathfrak{L}$ 输出 $\mathcal{H}$ 中具有最小经验误差的假设 $h$，即 $\widehat{E}(h) = \min_{h'\in\mathcal{H}} \widehat{E}(h')$，则称 $\mathfrak{L}$ 为满足经验风险最小化原则的算法。

接下来我们讨论是否能够基于经验风险最小化原则找到假设空间中具有最小泛化误差假设的 $\epsilon$ 近似。假设 $\mathfrak{L}$ 为满足经验风险最小化原则的算法，令 $g$ 表示 $\mathcal{H}$ 中具有最小泛化误差的假设，即 $E(g) = \min_{h\in\mathcal{H}} E(h)$，对于 $0 < \epsilon,\delta < 1$，由引理 2.1 可知

$$P\left(|\widehat{E}(g) - E(g)| \geq \frac{\epsilon}{2}\right) \leq 2\exp\left(-\frac{m\epsilon^2}{2}\right).$$ (4.94)

令 $\delta' = \frac{\delta}{2}$，$\sqrt{\frac{\ln(2/\delta')}{2m}} \leq \frac{\epsilon}{2}$，由 (4.94) 可知

$$\widehat{E}(g) - \frac{\epsilon}{2} \leq E(g) \leq \widehat{E}(g) + \frac{\epsilon}{2}$$ (4.95)

以至少 $1 - \delta/2$ 的概率成立。令

$$\sqrt{\frac{8d\ln \frac{2em}{d} + 8\ln \frac{4}{\delta}}{m}} \leq \frac{\epsilon}{2},$$ (4.96)

由定理 4.3 可知

$$|E(h) - \widehat{E}(h)| \leq \frac{\epsilon}{2}$$ (4.97)

以至少 $1 - \delta/2$ 的概率成立。由 (4.95)、(4.97) 和联合界不等式 (1.19) 可知

$$\begin{aligned}
E(h) - E(g) &\leq \widehat{E}(h) + \frac{\epsilon}{2} - (\widehat{E}(g) - \frac{\epsilon}{2})\\
&= \widehat{E}(h) - \widehat{E}(g) + \epsilon\\
&\leq \epsilon\end{aligned}$$ (4.98)

以至少 $1 - \delta$ 的概率成立。因此，若学习算法 $\mathfrak{L}$ 输出 $\mathcal{H}$ 中具有最小经验误差的假设 $h$，其泛化误差 $E(h)$ 以至少 $1 - \delta$ 的概率不大于最小泛化误差 $E(g) + \epsilon$。

 -->


### 3.1 可分情景

### 3.2 不可分情景

## 4. 分析实例
