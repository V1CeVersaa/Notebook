# Explanatory Voice Reference

This guide applies to drafting and revising notebook prose. The goal is **coherent explanation, complete coverage of the requested knowledge, and a length suited to the material**. Apply it to prose added or changed in the current task.

## Develop Reasoning the Reader Can Follow

Start from what the reader already understands, explain the problem at hand, and introduce the concepts needed to address it. Near each definition, explain the symbols, constraints, and their meaning. As the mechanism unfolds, show how it addresses the earlier problem and under what conditions it works. Briefly refer back to familiar premises; expand new steps that are essential to understanding.

Organize each paragraph around one main question, with genuine causal, deductive, or conditional relationships between sentences. A question left by one concept can introduce the next, but independent topics need no forced connection. Narrative comes from how the knowledge develops; it does not require inventing a history, failed attempts, or a discovery process.

Use connected prose for explanations. Lists or tables suit algorithm steps, parallel conditions, interface references, and comparisons; headings distinguish actual conceptual levels. When a paragraph enumerates several parallel axes, rules, or cases, each about a sentence long, give a one-sentence lead-in and a list. Keep the reasoning that connects them in prose before or after the list, as in `docs/cs/pl/python/1_ds.md:170`. Do not fragment a complete argument into a sentence-by-sentence checklist, and do not hide its steps merely to keep paragraphs long.

## Balance Completeness and Brevity

Judge completeness against the requested scope: do not drop conditions on definitions, mechanisms, essential derivation steps, or limits on conclusions to shorten the text. Every concept need not receive the same background, examples, counterexamples, evaluation, and summary. Allocate space according to where the reader is most likely to need help.

Once an example explains the mechanism, additional examples that merely change the numbers are unnecessary. Remove repetition that adds no information, while retaining explanations that bridge reasoning steps. A key conclusion may deserve a brief restatement, especially after a long proof; judge it by whether it helps the reader understand or use the result, not by whether it ends a paragraph.

Questions and transitions are welcome where the content actually turns. Conversational phrasing stays occasional and inside the written register described in Target Register below. Do not mandate particular connectors, a ratio of short sentences, paragraph lengths, or the author's habitual expressions. Explaining a definition requires no accompanying opinion. When evaluating a method, support the judgment with evidence and applicable conditions.

## Target Register

The target is written Chinese that stays easy to follow. The revised Python notes quoted first under Calibration Excerpts are the reference.
- The base is 书面语: compact, mostly declarative sentences with precisely used terms.
- Wherever one exists, give the concrete fact: the code point, the encoding, the version, the exact input that fails.
- Write 我们 only when the reader is actually doing something, such as calling, inspecting, or implementing.
- Use a connective only where a real causal, contrastive, or conditional relation exists.

There are two ways to miss the target. Both appeared while the Python notes were revised in October 2026, and the owner rejected each.

- **Too colloquial**: fillers and figures of speech that make the prose chatty without adding precision, such as 根本表示不了、反倒是、数一数、只要写……就行、走捷径、照顾到了、先起个名字再用、读起来像在猜谜. Use the plain written form instead: 无法表示、而、统计、可以写成、兼顾、给切片命名.
- **Too stiff**: the register of an impersonal reference text. It shows up as five habits:
  - vague hedges where a concrete fact exists: 在某些单字节编码中可能占一个字节, where naming Latin-1 is possible;
  - evaluative closers that carry no information: 这个分离是理解 Python 3 文本模型的核心;
  - stacked abstract nouns: 显示形式偏向 ASCII、常见方式包括;
  - statements from the negative side (不意味着……) where the positive one is available;
  - English terms left unpaired: buffer protocol instead of 缓冲协议/Buffer Protocol.

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

### Structural Tells

These come from how sentences are built, not from particular phrases, so a word list will not catch them. They show up most after a review or fact-check, when every finding gets written into the prose. [SKILL.md](../SKILL.md) says where each kind of detail belongs.

- **Stacked qualifications**: one sentence carries the rule, an exception, a parenthetical, and a version note, as in ……只是按惯例……（交互式控制台还会……）；只有在……才…… State the rule first. Give a real exception its own sentence, and move the rest into a collapsible block or a comment.
- **Semicolon chains**: several parallel facts strung together with 分号 into one long sentence. Split them into sentences, or into a short list when they really are parallel.
- **Verification in the prose**: phrases like 实测、当前文档推荐、在 3.14 和 3.15 中已经没有了、按 PEP 412 的描述. The reader needs the fact, not how it was checked. Put the evidence in an HTML comment.
- **Carrying over the source's rhetoric**: setups like 这也回答了“为什么……”, paired clauses like 作为最一般的……作为最特化的……, or closing on the aphorism the author used. These translate the author's argument. Say the point in your own order instead.
- **Definitions without reasoning**: the paragraph is a sequence of impersonal definitions. Nothing shows why one fact leads to the next, or what problem the concept answers. The fix is to make the causal step visible (因为……所以……、这样……、因此……). Adding 我们 or conversational turns does not fix it; 我们 belongs only where the reader is acting. Calibrate against the excerpts below rather than reusing their phrases. Repeating an owner phrase as a habit is its own tell.
- **Colloquial drift**: the fillers listed under Target Register. They appear most when a revision tries to sound like a person rather than to explain.
- **A rhetorical question as a link**: 为什么……？因为……, used mid-paragraph to restate what the next clause says anyway. A question that opens a section by naming its motivation is fine; see the register-allocation excerpt. A question inserted between two sentences should become a statement, as in `Any` 之所以能关闭检查，是因为…….
- **Edge cases before the rule**: exceptions arrive while the main mechanism is still unexplained. Finish the main explanation first.

## Calibration Excerpts

The excerpts below are quoted verbatim from the owner's notes, and "……" marks a cut. Calibrate against them rather than copying their phrases, and do not use them as factual sources for other notes.
- **The first group** sets the target register. The owner edited and approved it on 2026-10-14; line numbers are as of that date.
- **The remaining groups** were written before this skill existed; line numbers are as of 2026-10-13. They show the order in which an explanation unfolds. Their register is at times more conversational than the target.

### Target Register: Revised Python Notes

In these excerpts, `` `#!python ...` `` is the inline-highlight prefix that the Python series puts on every inline code span.

From `docs/cs/pl/python/1_ds.md:170-173`:

> Python 标准库里有很多用 C 实现的序列类型，可以从两个角度给它们分类。
>
> - 从元素如何存储来看：**容器序列/Container Sequence** 存的是对象的引用，所以可以放不同类型的元素，也可以嵌套别的容器，比如 `#!python list`、`#!python tuple`、`#!python collections.deque`。**扁平序列/Flat Sequence** 把值本身直接存在自己的内存里，只能放字符、字节、数字这类简单的值，比如 `#!python str`、`#!python bytes`、`#!python array.array`。扁平序列要紧凑得多：Python 里每个对象都带着引用计数、类型指针这样的元数据，一个装着浮点数的 `#!python tuple` 存的是指向一个个 `#!python float` 对象的指针，`#!python array` 则直接存一串机器层面的浮点数。
> - 从可变性来看：**可变序列/Mutable Sequence** 如 `#!python list`、`#!python bytearray`、`#!python array.array`、`#!python deque` 可以原地插入、删除和替换元素；**不可变序列/Immutable Sequence** 如 `#!python tuple`、`#!python str`、`#!python bytes` 不行，“修改”它们只会得到一个新对象，或者报错。

A one-sentence lead-in introduces two parallel axes, and each axis gets a list item. Each term pair is bolded where it is defined. The reason follows in the same item (所以……、扁平序列要紧凑得多：……), so the list still carries reasoning rather than bare labels.

From `docs/cs/pl/python/1_ds.md:229`:

> 不过元组的“不可变”只作用在元组持有的引用上，不会递归冻结被引用对象。下面两个元组一开始相等，修改 `#!python b` 最后一个位置上的列表以后，元组本身的位置引用没有变化，但最后一个位置引用的列表内容变化了，所以元组的值也变了：

The limit of the rule is stated exactly: what is affected, and what is not. The example's outcome is then explained step by step, ending in 所以. There is no filler, and no figure of speech.

From `docs/cs/pl/python/1_ds.md:332`:

> 增强赋值 `#!python +=` 和 `#!python *=` 依赖 `#!python __iadd__` 与 `#!python __imul__`。如果左操作数支持原地方法，比如 `#!python list`，就原地修改，对象身份通常不变；如果不支持，比如 `#!python tuple`，`#!python a += b` 就退化成 `#!python a = a + b`，先创建一个新对象，再把 `#!python a` 重新绑定过去。所以在循环里反复拼接元组这类不可变序列很慢，每次都要把整个序列复制一遍。而字符串是个例外：`#!python s += t` 太常见，CPython 专门做了优化。

The paragraph moves in four steps: the rule, then its two conditional branches, each with a concrete type, then the consequence, then the one real exception. The semicolon separates the two branches of a single condition. That is not a chain of unrelated facts.

From `docs/cs/pl/python/1_ds.md:450`:

> 但是注意，构造时传入的 `#!python default_factory` 仅为 `#!python __getitem__` 方法提供默认值，只在 `#!python dd[k]` 这种写法里起作用，对不存在的 `#!python k`，`#!python dd.get(k)` 还是返回 `#!python None`，`#!python k in dd` 还是 `#!python False`。

但是注意 marks a real turn: the mechanism just described has a boundary. The boundary is named precisely (仅为 `__getitem__` 提供默认值), and its observable consequences follow.

From `docs/cs/pl/python/1_ds.md:545`:

> **集合/Set** 是唯一元素的无序集合，最直接、最基本的用途是去重和快速成员测试。`#!python set` 可变，`#!python frozenset` 不可变。集合元素必须可哈希，而 `#!python set` 本身不可哈希，因此 `#!python set` 不能包含 `#!python set`，但可以包含 `#!python frozenset`。

A definition with its bolded pair comes first, then the purpose, then the variants. The restriction is derived rather than asserted: 必须可哈希，而……不可哈希，因此…….

From `docs/cs/pl/python/1_ds.md:574`:

> Python 3 把文本和二进制数据明确分开：`#!python str` 是 Unicode 码位/Code Point 的序列，`#!python bytes` 和 `#!python bytearray` 是 0 到 255 的整数序列。码位是字符的标识，即 0 到 1,114,111 之间的一个整数，在 Unicode 标准里写成 `#!python U+` 加 4 到 6 位十六进制数。编码/Encoding 是把码位转换成字节序列，解码/Decoding 是把字节序列转换回码位：

The section heading is only `str 与 bytes`, and the first sentence states the contrast the heading leaves open. A new term gets its numeric range and notation. The two operations are defined in parallel, each with its pair.

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

### A Language Rule Explained Through Its Error

The next four excerpts come from the Python notes as committed in `dfefb38` (2026-03-29), before this skill existed. Read them with `git show dfefb38:<path>`. Lightly corrected versions of them are back in the working copy's 9.1–9.3. These excerpts show causal order and the participant 我们 at the conversational end of the owner's range. For register, prefer the revised notes above.

From `docs/cs/pl/python/2_func.md:149`, right after the code that fails:

> 对于函数 `f1`，Python 判断 `b` 是局部变量，因为在函数内对其进行了赋值，因此会尝试从局部作用域中获取 `b`，但是发现 `b` 没有绑定值，于是抛出 `UnboundLocalError` 错误。而使用 `global` 声明的 `b` 被解释器认为是全局变量，并且对其分配一个新值。

From `docs/cs/pl/python/2_func.md:197`:

> 这里对于 `averager` 中的 `count` 和 `total` 使用 `nonlocal` 声明是必要的，因为 `count += 1` 实际上是 `count = count + 1`，对 `count` 进行了重新赋值，会按照局部变量进行处理，因此如果没有 `nonlocal` 声明，就会出现 `Reference before assignment` 错误。

Each paragraph follows the interpreter's decision in one causal chain (因为……因此……于是……) and stops at the error the reader actually sees. The contrasting case (`global`, or adding `nonlocal`) gets one clause. The paragraph does not restate the rule afterward, list related cases, or add version notes.

### Observing Behavior, Then Moving to the Fix

From `docs/cs/pl/python/2_func.md:81`:

> 这时，如果我们调用 `target()`，实际上输出的是 `running inner()`，如果我们在控制台检查 `target`，那么会得到 `<function __main__.decorate.<locals>.inner()>`，意味着其实 `target` 现在只是 `inner` 函数的一个引用。

From `docs/cs/pl/python/2_func.md:234`, between the first `clock` decorator and the `functools.wraps` version:

> 但是注意，我们现在实现的装饰器不支持关键字参数，而且遮盖了被装饰函数的 `__name__` 和 `__doc__` 属性。我们可以使用 `functools.wraps` 装饰器来修复这个问题：

The reader is a participant: 我们调用, 我们在控制台检查, 我们现在实现的. The first excerpt reports what is observed and draws the conclusion from it (意味着). The second names the two concrete shortcomings of the previous code in one sentence and turns straight to the fix, with the code following. 但是注意 marks a real turn from what works to what does not.

## Review Before Delivery

Reread only the text written in this task, as the future reader: can the reader follow the concepts and derivations? Are the necessary knowledge and qualifications complete? Does each sentence help that reader understand or use the material, or does it record how the material was checked? Does the register stay written without turning stiff? Check for colloquial fillers on one side, and on the other for vague hedges, evaluative closers, and terms left unpaired or unbolded where they are defined. Can any repetition be removed without harming understanding? Are added factual claims supported? Does a tell from the lists above remain without a logical role? Correct concrete problems; leave clear, natural sentences unchanged.

For formatting and terminology conventions, see [notebook-style.md](notebook-style.md); for domain coverage, see [domain-patterns.md](domain-patterns.md). Blockquotes here distinguish excerpts from guidance. When writing notes, follow the target series's normal body formatting.
