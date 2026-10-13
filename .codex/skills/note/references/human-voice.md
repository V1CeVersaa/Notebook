# Explanatory Voice Reference

This guide applies to drafting and revising notebook prose. The goal is **coherent explanation, complete coverage of the requested knowledge, and a length suited to the material**. Apply it to prose added or changed in the current task.

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

If the original contains a technical error, verify and correct it explicitly rather than making it sound more certain. When a source reports only an observation, do not supply an unsupported cause; when results are absent, do not present speculation as evidence. Retain explicit uncertainty where support is insufficient. For a voice-only edit, mention missing information in an editorial comment rather than forcing it into the notebook prose.

Nearby notes can demonstrate narrative rhythm and organization, but their technical claims still need checking against the sources used for the current task.

## Common AI Tells

These patterns usually mean a sentence was assembled rather than reasoned. None of the phrases is banned. Flag one when it carries no logical relationship or information, then replace it with the actual relationship or delete it.

- **Inflated significance**: 具有深远意义、奠定了基础、起到了关键作用、标志着……的里程碑. Say what the thing does.
- **Empty transitions**: 此外、不仅如此、值得注意的是、需要指出的是、不难发现、由此可见, used where the next sentence has no stated relation to the previous one.
- **Announcing instead of explaining**: 本节将介绍……、接下来我们将……、下面从 X、Y、Z 三个方面…… Start with the content itself.
- **Avoiding 是**: 起到了……的作用、扮演着……的角色、承担着……的功能, where 是 or 有 says the same thing.
- **Trailing clauses**: ……，从而……，进而体现了……，充分说明了……, chains that add claims without adding reasons.
- **Formula endings**: 综上所述、总而言之 followed by a restatement, or 相信随着研究的不断深入…… End when the explanation ends, or on a real limitation or connection.
- **Unsourced or promotional claims**: 研究表明、学界普遍认为、强大的、完美地、革命性的. Name the actual source or state the claim with its scope, and describe the technical property instead of praising it.
- **Padded structure**: points forced into threes, or bullet lists whose bold labels the item text merely repeats.
- **Narrating the book**: 书中 §x 讲了……; see Source Notes in [notebook-style.md](notebook-style.md).

## Calibration Excerpts

The excerpts below are quoted verbatim from notes the owner wrote before this skill existed. Line numbers are as of 2026-10-13, and "……" marks a cut. They show the owner's register and the order in which an explanation unfolds. Calibrate against them rather than copying their phrases, and do not use them as factual sources for other notes.

### Motivation Before the Goal

From `docs/cs/compilers/10_register.md:13`:

> 为什么要进行寄存器分配？原因在于程序使用无限多个临时的变量，抽象汇编也使用无限多个寄存器，但实际上真实的机器只有有限多个寄存器，就需要我们在保持程序语义不变的基础上，将临时值映射到寄存器上。同时也做一些性能的优化。

The paragraph opens with the reader's question, answers it with the constraint that creates the problem (unlimited temporaries, finite registers), and only then states the task together with its invariant: program semantics must not change. The secondary purpose gets one short sentence instead of a list.

### A Cost That Introduces the Next Concept

From `docs/cs/compilers/2_parse.md:135`:

> 问题在于复杂的回溯的代价太高，分析过程类似于 NFA，因此我们希望构建一个类似于 DFA 的分析方法。这样就产生了接受 LL(k) 文法的预测分析法/Predictive Parsing。其中 LL(k) 表示从左到右分析，最左推导，向前看 k 个 Token 来确定产生式。并且我们需要确定**文法加上什么限制可以保证没有回溯**。

The cost of the previous method motivates the new one, and the NFA/DFA analogy names the idea in terms the reader already knows. The new term arrives with its bilingual pair and an expansion of its name. The paragraph ends on the question the next section answers, so the transition comes from the content rather than from a connective.

### A Concrete Failure and Its Fixes

From `docs/cs/compilers/6_IR.md:180`, right after the loop translation it discusses:

> 这个问题在于对于 `hi` 为 `maxint` 的时候，`i + 1` 就会溢出，解决方法之一是将测试放在循环底部，在递增 `i` 之前检查 `i < hi`，而不是检查 `i <= hi`。另外一种方法是添加初始范围检查，检查 `lo <= hi`，如果初始条件不满足，就可以直接跳过整个循环。

Instead of warning that the translation "may have boundary issues", the passage names the exact input that breaks it, and describes each fix by what it checks. 另外 introduces a genuine alternative here, so it carries meaning. The paragraph stops once the fixes are given.

### Reasoning Between Formulas

From `docs/math/opt/3 Descent.md:9-21`:

> 我们尝试用一种“普遍”的推理推出这种方案：取定点 $x_0$，考虑函数 $f\in C^1(\mathbb{R}^n)$ 与其下面的近似：
>
> $$
> \phi_2(x) = f(x_0) + \langle\nabla f(x_0),x-x_0\rangle + \dfrac{1}{2h}\lVert x-x_0\rVert^2
> $$
>
> 其中参数 $h>0$ 是一个正数，根据一阶最优性条件，该函数的无约束极小点 $x_1^*$ 满足：
>
> $$
> \nabla\phi_2(x_1^*) = \nabla f(x_0)+\dfrac{1}{h}(x_1^*-x_0) = 0
> $$
>
> 所以就有 $x_1^* = x_0-h\nabla f(x_0)$，这就是我们梯度法的迭代方案。……

The first clause says what the derivation is for. Each formula is introduced with the condition it relies on (一阶最优性条件), and the result is tied back to the scheme stated just above. The source then turns to the upper-bound condition on $h$ and to convergence, which rely on the previous note, and closes with a forward reference in the same voice: 「记好这个 $\phi_2$，我们在拟牛顿法的比较中还会用到（虽然也就是提了一嘴）。」 A short aside like this is welcome when it tells the reader what is worth remembering.

### Established Results Versus Conjecture

From `docs/cs/computation/l_7.md:50`:

> 显然 $\mathbf{P} \subseteq \mathbf{BPP}$，因为确定性 TM 可以看作是 Probabilistic TM 的一个特例，即不使用随机比特串。$\mathbf{BPP} \subseteq \mathbf{EXP}$ 也比较显然，因为我们可以枚举所有可能的随机比特串，然后取多数结果作为最终结果，这样的时间复杂度是指数级的。但是至于 $\mathbf{P}$ 是不是严格包含于 $\mathbf{BPP}$，目前尚未有定论，但是大多猜测认为 $\mathbf{P} = \mathbf{BPP}$，也就是说随机化计算并没有增加计算能力，只是提高了计算效率而已，并且所有的多项式的随机算法都可以去随机，得到一个确定性的多项式算法。

Each established inclusion comes with a one-clause reason. The open question is labelled as open (目前尚未有定论) and the majority view as a conjecture (大多猜测). What follows is framed as a consequence of that conjecture, not as a result. Treat gaps in a source the same way: when a result, mechanism, or condition is missing, say so instead of filling it in.

## Review Before Delivery

Reread only the text written in this task: can the reader follow the concepts and derivations? Are the necessary knowledge and qualifications complete? Can any repetition be removed without harming understanding? Are added factual claims supported? Does a tell from the list above remain without a logical role? Correct concrete problems; leave clear, natural sentences unchanged.

For formatting and terminology conventions, see [notebook-style.md](notebook-style.md); for domain coverage, see [domain-patterns.md](domain-patterns.md). Blockquotes here distinguish excerpts from guidance. When writing notes, follow the target series's normal body formatting.
