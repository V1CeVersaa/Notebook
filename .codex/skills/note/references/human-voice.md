# Explanatory Voice Reference

This guide applies to drafting and revising notebook prose. The goal is **coherent explanation, complete coverage of the requested knowledge, and a length suited to the material**. Apply it only to text added or changed in the current task. Mechanical edits need no voice review, and this guide does not authorize rewriting untouched paragraphs.

## Develop Reasoning the Reader Can Follow

Start from what the reader already understands, explain the problem at hand, and introduce the concepts needed to address it. Near each definition, explain the symbols, constraints, and their meaning. As the mechanism unfolds, show how it addresses the earlier problem and under what conditions it works. Briefly refer back to familiar premises; expand new steps that are essential to understanding.

Organize each paragraph around one main question, with genuine causal, deductive, or conditional relationships between sentences. A question left by one concept can introduce the next, but independent topics need no forced connection. Narrative comes from how the knowledge develops; it does not require inventing a history, failed attempts, or a discovery process.

Use connected prose for explanations. Lists or tables suit algorithm steps, parallel conditions, interface references, and comparisons; headings distinguish actual conceptual levels. Do not fragment a complete argument into a sentence-by-sentence checklist or hide its steps merely to maintain long paragraphs.

## Balance Completeness and Brevity

Judge completeness against the requested scope: do not drop conditions on definitions, mechanisms, essential derivation steps, or limits on conclusions to shorten the text. Every concept need not receive the same background, examples, counterexamples, evaluation, and summary. Allocate space according to where the reader is most likely to need help.

Once an example explains the mechanism, additional examples that merely change the numbers are unnecessary. Remove repetition that adds no information, while retaining explanations that bridge reasoning steps. A key conclusion may deserve a brief restatement, especially after a long proof; judge it by whether it helps the reader understand or use the result, not by whether it ends a paragraph.

Natural questions, transitions, and occasional conversational phrasing are welcome. Do not mandate particular connectors, a ratio of short sentences, paragraph lengths, or the author's habitual expressions. Explaining a definition requires no accompanying opinion. When evaluating a method, support the judgment with evidence and applicable conditions.

## Preserve Facts During Voice Edits

**Polishing must preserve facts, formulas, causal relationships, scope, and uncertainty.** Do not add numbers, complexity bounds, experimental results, citations, or claims of field-wide consensus merely to sound concrete. Explanatory additions must follow from premises already stated. When external facts are needed, verify them first and treat the addition as a content revision.

If the original contains a technical error, verify and correct it explicitly rather than making it sound more certain. When a source reports only an observation, do not supply an unsupported cause; when results are absent, do not present speculation as evidence. Retain explicit uncertainty where support is insufficient.

Nearby notes can demonstrate narrative rhythm and organization, but their technical claims still need checking against the sources used for the current task. The examples below illustrate explanatory techniques. They are neither fixed sentence templates nor factual sources for other notes. They remain in Chinese to demonstrate the language of the notebook artifacts.

## Example: Give a Formal Definition Meaning

This is a self-contained teaching example. All premises appear in the passage, and its numbers illustrate the definition rather than report experimental data.

> 对整数 $a\leq b$，我们用 半开区间/half-open interval $[a,b)$ 表示满足 $a\leq i<b$ 的整数位置。区间非空时从左端点开始，右端点用来标记停止的位置，因此区间内共有 $b-a$ 个整数。例如，$[2,5)$ 包含 $2,3,4$，而 $[2,2)$ 为空。
>
> 这个表示也便于切分区间：取整数 $m$ 满足 $a\leq m\leq b$，可以把 $[a,b)$ 分成 $[a,m)$ 和 $[m,b)$。前一段在 $m$ 之前结束，后一段从 $m$ 开始、到 $b$ 之前结束；两段没有重叠，合起来仍是原来的区间。取 $m=a$ 或 $m=b$ 时，其中一段为空。

The passage gives a definition, explains it through boundaries and examples, then derives a use. If the surrounding material needs only interval notation, the first paragraph is enough; include the second only when splitting intervals is relevant.

## Example: Explain the Reasoning Between Formulas

This example adapts the explanation of minimizing a local quadratic model in `docs/math/opt/3 Descent.md`, retaining only a derivation that can be checked within the passage. It is not a verbatim excerpt and does not carry over the original's claims about convergence of the iteration.

> 给定可微函数 $f:\mathbb{R}^n\to\mathbb{R}$，在当前点 $x_0$ 处，一阶近似告诉我们函数沿各个方向如何变化。但如果梯度非零，单独最小化这个线性模型会沿下降方向无限走远。我们给位移加上一个二次惩罚，得到
>
> $$
> q(x)=f(x_0)+\langle\nabla f(x_0),x-x_0\rangle+\frac{1}{2h}\lVert x-x_0\rVert^2,\qquad h>0.
> $$
>
> $h$ 控制位移惩罚的强弱：$h$ 越小，离开 $x_0$ 的代价越高。这个二次模型严格凸，令梯度为零就能找到唯一极小点：
>
> $$
> \nabla q(x)=\nabla f(x_0)+\frac{x-x_0}{h}=0
> \quad\Longrightarrow\quad x_1=x_0-h\nabla f(x_0).
> $$
>
> 这样得到了梯度更新的形式。不过，当前最小化的是 $q$；要保证这一步也降低原函数 $f$，还需要控制模型误差与步长，单凭这个推导不能得出下降或收敛结论。

The explanation connects why the quadratic term is needed, what the parameter controls, how to obtain the update, and what has actually been established. The final qualification adds information and should remain. There is no need to repeat the same explanation after each line of algebra.

## Example: Connect an Explanation Without Inventing Evidence

Assume the source provides only these facts: the system caches query results by key; a hit returns the cached value; a miss queries the data source and writes the result to the cache; updates to the data source do not automatically refresh the cache. The passage below only reorganizes these given facts.

> 系统先按键查找缓存。命中时直接返回缓存值；未命中时才查询数据源，并把结果写入缓存，供之后的查询使用。
>
> 这个流程还留下一个问题：数据源更新后，缓存不会自动刷新，后续查询可能继续读到旧值。因此，理解该系统时还需要检查它如何让缓存失效或更新；给定材料没有说明这一部分。

The question in the second paragraph follows from the mechanism in the first. There is no need to invent a hit rate, latency improvement, or consistency guarantee, or to supply an invalidation scheme absent from the source. For a voice-only edit, mention missing information in an editorial comment when appropriate rather than forcing it into the notebook prose.

## Review Before Delivery

Reread only the text written in this task: can the reader follow the concepts and derivations? Are the necessary knowledge and qualifications complete? Can any repetition be removed without harming understanding? Are added factual claims supported? Correct concrete problems; leave clear, natural sentences unchanged.

For formatting and terminology conventions, see [notebook-style.md](notebook-style.md); for domain coverage, see [domain-patterns.md](domain-patterns.md). Blockquotes here distinguish examples from guidance. When writing notes, follow the target series's normal body formatting.
