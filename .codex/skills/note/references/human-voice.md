# Human Voice Reference

This reference captures the AI writing patterns most likely to appear in technical Chinese notebook notes and how to fix them. Apply it as a final pass before delivering any note. The goal is prose that sounds like a person who actually understands the material, not a language model summarizing a lecture.

This guide is adapted from the [humanizer skill](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) for the specific register of V1CeVersa's notebook: Chinese body text, technical domain, student-to-future-self voice.

---

## Core Principle

Good technical notes have a human behind them. Removing AI patterns is only half the job. Voiceless, sterile writing is just as obvious as pattern-matched slop. The notebook voice should reflect genuine understanding, not transcription.

**Signs of soulless writing (even if technically clean):**

- Every sentence is the same length and cadence
- No opinions, just neutral reporting
- No acknowledgment of uncertainty or complexity
- Reads like a translated Wikipedia stub or textbook introduction
- Filler transitions glue paragraphs together without adding logic

**How to add voice:**

- Have opinions. "Pre-norm 目前是铁律。唯一的例外是 OPT-350M，大概率是个失误。" is more useful than neutrally listing both options.
- Vary rhythm. Short punchy sentences next to longer analytical ones. Not every sentence should be the same structure.
- Acknowledge complexity. "这个设计在理论上优雅，但工程上难以实现" beats "该设计有一定局限性".
- Use specific numbers and sources over vague claims. "Xiong 2020 发现 Post-norm 在初始化阶段梯度随层数增长而爆炸" beats "研究表明 Post-norm 存在训练不稳定的问题".
- Occasional first-person or student-voice asides are fine when they clarify: `"记好这个 φ₂，后面还会用到"`, `"直白说就是……"`.

---

## Chinese AI Writing Patterns

### 1. Significance Inflation (意义拔高)

**Characters to watch:** 具有深远意义、意义重大、奠定了基础、起到了关键作用、推动了X的发展、标志着X的重要里程碑、体现了X的核心价值

**Problem:** Chinese LLM output routinely inflates the importance of arbitrary facts with philosophical-sounding closing sentences.

**Before:**
> ReLU 激活函数的提出具有深远意义，奠定了深度学习快速发展的基础，推动了整个领域的重大进步。

**After:**
> ReLU 解决了 sigmoid 的梯度消失问题，让更深的网络训练变得可行。

---

### 2. Filler Transitions (无效过渡)

**Characters to watch:** 此外、另外、不仅如此、值得注意的是、需要指出的是、不难发现、综上所述、总体来看、由此可见、总而言之

**Problem:** These phrases glue paragraphs together without adding logic. They signal that the next sentence could be placed anywhere — it has no real connection to the previous one.

**Before:**
> Attention 机制的核心是计算 Query 和 Key 的相似度。此外，Value 的加权求和得到输出。另外，Multi-head Attention 允许模型关注不同的子空间。

**After:**
> Attention 的计算分三步：用 Query 和 Key 的点积算相似度，softmax 归一化，然后对 Value 加权求和。Multi-head 的意义在于允许模型同时关注不同子空间的信息。

---

### 3. Superficial -ing Analyses (悬挂分词短语)

**Problem:** AI appends present-participle phrases in Chinese form (`……，从而X`, `……，进而体现了Y`, `……，充分说明了Z`) as fake analytical depth. They add words without adding logic.

**Before:**
> Transformer 采用了 Self-Attention 机制，从而使模型能够捕捉长距离依赖关系，进而提升了序列建模的能力，充分体现了注意力机制的强大表达能力。

**After:**
> Transformer 用 Self-Attention 替代 RNN 的核心原因是：RNN 只能串行处理序列，长距离依赖容易衰减；Self-Attention 直接建模任意两个位置之间的关系，且可以并行计算。

---

### 4. Vague Attributions (无出处引用)

**Characters to watch:** 研究表明、有研究发现、学界普遍认为、专家指出、相关文献显示、实验证明

**Problem:** Claims attributed to unnamed research or experts are not useful. If the source is important, name it. If it is not, just state the claim directly.

**Before:**
> 研究表明，Batch Normalization 能够有效加速训练并提升模型稳定性。

**After:**
> Batch Normalization（Ioffe & Szegedy 2015）通过在每个 mini-batch 内归一化激活值，减少了内部协变量偏移，让更大的学习率成为可能。

---

### 5. Formulaic "Summary" Endings (套路式结尾)

**Characters to watch:** 综上所述、总结来说、本节介绍了……希望对读者有所帮助、……是X领域不可或缺的重要工具、相信随着研究的不断深入

**Problem:** Closing paragraphs that summarize what was just said without adding anything, or make optimistic noises about the future.

**Before:**
> 综上所述，本节介绍了 Transformer 架构的核心组成部分，包括 Self-Attention、位置编码和 FFN。Transformer 是现代深度学习不可或缺的重要基础，相信随着研究的不断深入，其应用将更加广泛。

**After:**
> (就此结束；如果有值得说的后续，例如与下一节的连接、已知的局限性、或开放问题，直接说出来，不要用套话代替。)

---

### 6. Meta-Commentary on the Note Itself (自指性说明)

**Characters to watch:** 本节将介绍……、接下来我们将讨论……、下面将从X、Y、Z三个方面分析……、本文首先……然后……最后……

**Problem:** Announcing what you are about to do instead of doing it. This is the Chinese equivalent of "let's dive in." It wastes space and signals the content was assembled rather than understood.

**Before:**
> 本节将从数学定义、几何意义和算法应用三个方面介绍凸函数的基本概念。

**After:**
> 凸函数的核心约束是弦在曲线上方：对任意 $x, y$ 和 $\lambda \in [0,1]$，有 $f(\lambda x + (1-\lambda)y) \leq \lambda f(x) + (1-\lambda)f(y)$。

---

### 7. Copula Avoidance (回避"是")

**Characters to watch:** 起到了X的作用、扮演着X的角色、承担着X的功能、作为X存在、发挥着X的职责

**Problem:** Using elaborate constructions instead of simple `是` or `有`.

**Before:**
> 残差连接在深度网络中起到了缓解梯度消失的重要作用，扮演着稳定训练过程的关键角色。

**After:**
> 残差连接的作用是在反向传播时提供梯度的直通路径，让 100 层以上的网络可以稳定训练。

---

### 8. Rule of Three Overuse (强制三元结构)

**Problem:** LLMs force ideas into groups of three to seem comprehensive.

**Before:**
> 该方法具有三个优点：一是计算效率高，二是内存占用低，三是易于实现。

**After:**
> 该方法的主要优势是计算效率：相比朴素实现，它把时间复杂度从 $O(n^2)$ 降到 $O(n \log n)$。内存开销也随之减少，不过实现上比朴素版本要复杂一些。

---

### 9. Inline-Header Bullet Lists (带粗体标题的列表)

**Problem:** Lists where every item starts with **bold header:** followed by a restatement of the header. This is a formatting tic, not structure.

**Before:**
> - **效率**：该算法的时间复杂度得到了显著提升，运行效率更高。
> - **精度**：通过优化损失函数，模型精度有所提升。
> - **稳定性**：改进的初始化策略使训练过程更加稳定。

**After:**
> 该改进主要体现在三点：时间复杂度从 $O(n^2)$ 降至 $O(n \log n)$；针对长尾分布优化了损失函数，top-1 精度提升 2.3%；换用 Xavier 初始化后训练曲线不再出现前期震荡。

---

### 10. Excessive Hedging (过度不确定)

**Characters to watch:** 或许可以认为、可能在某种程度上、不一定完全准确、在一定条件下也许

**Problem:** Over-qualifying claims that the source material actually states clearly.

**Before:**
> 这或许在某种程度上可以说明，卷积操作可能具有一定的平移不变性。

**After:**
> 卷积的平移不变性来自权重共享：同一个滤波器在输入的每个位置独立应用，所以输入平移后输出也相应平移，不改变检测到的特征。

---

### 11. Em Dash Overuse (破折号滥用)

**Problem:** Em dashes (——) used where a comma, period, or parenthesis would be cleaner.

**Before:**
> Attention 机制——尤其是 Multi-head Attention——是 Transformer 的核心——也是它与 RNN 本质上不同的地方。

**After:**
> Attention 机制（尤其是 Multi-head Attention）是 Transformer 的核心，也是它与 RNN 本质上不同的地方。

---

### 12. Promotional Language (宣传性语言)

**Characters to watch:** 强大的、卓越的、优秀的、完美地、极大地提升了、革命性的、突破性的（用于普通技术细节时）

**Problem:** Using advertising-copy vocabulary for technical description.

**Before:**
> GPT-3 拥有强大的语言生成能力，能够完美地完成各种自然语言处理任务，展现了大语言模型卓越的理解和推理能力。

**After:**
> GPT-3（175B 参数）在少样本场景下的表现首次接近了部分有监督基线，但在需要精确推理的任务上仍有明显差距。

---

## Final Anti-AI Pass

Before finishing any note, ask: *"What still makes this sound AI-generated?"*

Common remaining tells in Chinese technical notes:
- The rhythm is too uniform (every paragraph is 3–4 sentences, all roughly the same length)
- No genuine opinion or judgment is visible, only neutral reporting
- The closing paragraph summarizes what was just said
- Transitions are logical connectors without logical content
- Specific numbers are present but the reader cannot tell *why* they matter

Fix these, then deliver.

---

## What This Reference Does Not Replace

This reference handles *voice and anti-pattern checks*. It does not override:
- `notebook-style.md` for structural conventions (admonitions, anchors, math syntax, image format)
- Local series conventions (match adjacent files first)
- Domain explanation patterns (systems, theory, ML, math sequences from `notebook-style.md`)
