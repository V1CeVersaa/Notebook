# Notebook Style Guide

This reference captures the durable conventions of V1CeVersa's Notebook. Apply it after checking nearby notes in the target series.

## Repository Shape

The notebook is a MkDocs Material site. Notes live under `docs/` and are grouped by subject: `docs/ai/`, `docs/cs/`, `docs/math/`, `docs/system/`, `docs/rl/`, and `docs/varia/`. A single Markdown file is usually one lecture, chapter, or focused technical topic. Assets normally live in a sibling `assets/` directory near the note.

When creating a new directory, a multi-file topic, or an `index.md`, inspect `mkdocs.yml` before choosing paths. The `nav` tree is the notebook's public map: it usually points a topic label to `path/index.md`, then lists child notes as sibling Markdown files under the same directory. Preserve the repo's actual path casing, spaces, underscores, hyphens, and numbering style instead of inventing a cleaner convention. Course/book series often use files such as `1 Intro.md`, `Chapter 1.md`, or `topic1.md`; framework/tool topics often use lowercase slugs such as `einx/vectorization.md`.

Do not rewrite unrelated `mkdocs.yml` navigation. If the user asks for a new navigable multi-file topic, or if you are generating a new directory of notes meant to appear in the notebook, patch only the smallest matching nav subtree and make every nav path match an actual file. Do not create new `index.md` files unless requested.

## Language And Voice

Body text is Chinese. Code identifiers, APIs, algorithm names, and standard English acronyms stay English. On first formal introduction of a technical concept, use a bilingual pair, such as `策略梯度/Policy Gradient` or `静态单赋值/Static Single Assignment/SSA`. Everyday CS terms such as 缓存、寄存器、变量、函数 do not need forced English pairing.

The voice is a student explaining to a future self: precise, compact, and willing to use natural remarks when they actually clarify the point. Avoid academic-paper phrasing such as “本文提出” or “我们的方法”. Avoid generic summaries where every sentence could fit any topic.

Do not let the note explain its own bookkeeping. Visible prose should not say things like “this directory only keeps the reading route”, “the following checkbox means completion”, “these details are placed in child notes”, or “read these in this order”. Orientation is useful only when it names the technical content itself: which primitive is introduced, what mechanism a section explains, and what boundary or failure mode the reader should remember.

## Structure

Use exactly one H1. Topic `index.md` pages have a stricter contract than ordinary content notes:

```markdown
# [Topic Title]

!!! info

    一两句话说明这个主题的技术核心、关键 primitives 或内容地图。不要给 admonition 加标题，也不要解释目录组织逻辑。

## Table of Contents

- [ ] [Child Note Title](./child-note.md)
- [x] [Completed Child Note](./completed-note.md)

## Introduction

最简洁地说明这个主题的核心问题、技术分层和关键判断。
```

The task-list checkbox in the table of contents marks whether the linked note is complete enough to use, but do not explain that convention in visible note prose. Arrange child links by conceptual structure, not by a narrated reading sequence. Keep `index.md` lean and do not put installation walkthroughs, long examples, full derivations, or detailed summaries there. Move those into child files and link them from the table of contents.

Ordinary substantial notes should include an outline admonition after the H1 or after a short opening paragraph:

```markdown
!!! Abstract "Outline"

    一句话概括本讲核心内容和脉络。

    - [x] [1. Finished Section](#1-finished-section)
    - [ ] [2. Planned Section](#2-planned-section)
```

The outline sentence should explain the note's conceptual arc, not merely list topics. Mark `[x]` only for sections that are actually written.

H2 conventions vary by series. Common patterns are `## 1. Section Name`, `## 十一、Python 风格对象`, and `## Lecture 7: ...`. Match adjacent files first. H3 sections are normally numbered within the parent, such as `### 1.1 ...`, unless the local series uses short unnumbered helper headings.

For notes with outlines or durable internal links, prefer explicit heading anchors using the MkDocs `attr_list` syntax. This avoids fragile generated anchors for Chinese text, punctuation, repeated headings, or inline code:

```markdown
## 七、函数是一等对象 { #chapter-7 }

### 7.1 函数对象与高阶函数 { #chapter-7-first-class }
```

Point outline links at the explicit IDs. In book/course series, keep the scheme predictable within the series, such as `#chapter-7` for chapter-level headings and either descriptive subsection anchors like `#chapter-7-first-class` or compact numbered anchors like `#chapter-7-1`. If a note already has explicit anchors that work, preserve them unless the task is specifically an anchor normalization pass.

## Admonitions And Blocks

Use MkDocs admonitions rather than Markdown blockquotes for callouts:

```markdown
!!! Danger "Theorem Title"
!!! Info "Side Note"
!!! Note "Caveat"
!!! Example "Worked Example"
???+ Abstract "Outline of Chapter N"
???- Info "Code"
???- Info "证明"
```

Use collapsible blocks for long code, long proofs, raw extracted text, or content that would interrupt the main explanation. Use visible prose for the conceptual path.

## Math

Use `$...$` inline and `$$...$$` display. Prefer `\mathrm{}` for text inside math, `\boldsymbol{}` for vectors, `\lVert \rVert` for norms, and `\operatorname*{}` for operators such as `argmin`.

Do not dump derivations as isolated formula blocks. Put short Chinese commentary between steps explaining what changed, why the manipulation is valid, and what the result means.

## Code

Use fenced code blocks with language tags: `py`, `cpp`, `rust`, `C`, `txt`, `bash`, etc. Inline language-specific highlighting appears in the repo, for example `` `#!cpp std::optional` `` and `` `#!py torch.no_grad()` ``. Use it when it improves readability and matches the local file.

Long code should go under `???- Info "Code"` unless the code itself is the current object of explanation. After code, explain the important lines; do not assume the code speaks for itself.

## Images

Use this image form:

```markdown
<img class="center-picture" src="./assets/filename.webp" width=550 />
```

Keep image paths relative to the note. Use width around `550` by default; ML notes with wide architecture diagrams or dense screenshots use `600`; narrow diagrams that need less horizontal space use `400`–`500`. Add `alt` text only if nearby files do so consistently; when used, name the concept the figure illustrates rather than describing layout.

**Naming**: files go in `assets/` next to the note and follow `{index}-{number}[-{topic}].webp`, with hyphens as separators. The `index` is the lecture or chapter number (e.g. `15`) or a topic slug (e.g. `AVL`); `number` is the sequential count within that note starting at 1; `topic` is an optional short English slug added when it clarifies the subject (e.g. `15-2-attention.webp`). Large series may use numbered asset subdirectories (`assets_1/`, `assets_2/`) or named subdirectories (`assets/6 IR/`); match the local series convention.

**Density**: Images carry irreplaceable value for spatial, structural, and sequential information — not for decoration. CV, perceptual ML, and RL notes are image-heavy; math, probability, TCS, and PL notes are image-sparse; systems and algorithms notes sit in between. As a rough baseline, two to three images per thousand words fits a balanced note, adjusted by domain.

For the complete image pipeline — PDF extraction with ffmpeg, crop/rotate processing, cwebp conversion, conda MISC environment — see `references/image-workflow.md`.

## Source Notes And References

External references, slide origins, URLs, paper metadata, and extraction notes should usually be kept in HTML comments:

```markdown
<!-- Source: ... -->
```

Do not put visible “generated from PPT” or placement commentary into the note body unless the user asks for that provenance to be visible.

## Vocabulary and Register

**Definition markers**: In math and theory notes, use bold prose markers — `**定义**：`, `**定理**：`, `**性质**：`, `**Proof：**` — rather than admonitions for every single definition. Reserve `!!! Danger "Theorem Title"` for named theorems that are central enough to warrant extra visual weight.

**Bilingual pairs**: Use `概念/Concept` on the first formal introduction of a technical term. After that first use, English or Chinese alone is fine depending on what reads more naturally. Everyday CS terms (缓存、寄存器、变量、函数) do not need bilingual pairing even on first mention.

**Student-voice asides**: Occasional colloquial remarks are part of the register — they signal genuine understanding rather than transcription. Examples from the notes: `"记好这个 φ₂，我们后面还会用到（虽然也就是提了一嘴）"`, `"直白点说就是访问内存的速度比较慢"`, `"Pre-norm 目前是铁律。唯一的例外是 OPT-350M，大概率是个失误。"`. Use these when they actually clarify, not as decoration.

**ML consensus vocabulary**: When writing about architectural or training choices in ML/LM notes, classify each choice explicitly with one of these phrases: `"目前是铁律"` (settled, all modern models agree), `"大多数现代 [X] 使用"` (mainstream with known exceptions), `"仍有争议"` (actively contested). These three levels are the notebook's standard vocabulary for consensus status — use them verbatim rather than paraphrasing.

## Explanation Patterns by Domain

These are the explanation structures that appear consistently across mature notes in each series. They describe *what to cover and in what order*, not decoration. Series-local conventions (admonition types, outline formats, collapsible placement) still follow "match adjacent files" above.

### Systems and Compilers

The core question for every systems concept is: *what hardware cost or access-pattern failure forced this design?* Structure explanations around:

1. **Limitation**: What does the naive approach fail at? (miss rate too high, memory traffic, stall cycles)
2. **Mechanism**: What invariant or transformation does this design maintain?
3. **Design-space tradeoff**: When alternatives exist (direct-mapped vs. set-associative; static vs. dynamic scheduling; write-through vs. write-back), state the tradeoff explicitly — what each option costs and gains — before naming the winner.
4. **Concrete anchor**: Name the actual hardware, ISA, or calling convention. `x86-64` front-six argument registers `%rdi %rsi %rdx %rcx %r8 %r9` is more useful than "the first few registers." Quote the Intel Pentium cache parameters or the RISC-V pipeline stages when the source gives them.

Compilers notes additionally pair **code and its compiled output** side-by-side when showing a transformation. Name each compiler phase and state its input and output representation, not just its task.

### CS Theory and Algorithms

Theory notes follow a **definition → intuition → theorem → proof-in-collapsible** rhythm:

1. Formal definition first, in a `!!! Info` admonition or as `**定义**：` prose.
2. Intuition immediately after: what the formal constraints *mean*, why this definition and not a simpler one.
3. Key theorem with its consequence stated in plain language before or after the formal statement.
4. Full proofs under `???- Info "证明"`. Inside a proof, explain the strategy before executing it: "使用反证法：假设……" or "我们对子序列进行考察……".
5. Close with the computational consequence: "这说明 X 不可能在多项式时间内解决" or "因此 Y 可以作为 Z 的子程序".

Algorithm notes lead with the **invariant or core idea**, then walk through operations, then state complexity. For amortized analysis, name the method (聚合/核算/势能) and state the potential function explicitly before doing the accounting.

### Math and Optimization

Optimization notes use **definition → geometric reading → theorem → collapsible proof → algorithm consequence**:

1. Display the formal definition with `$$...$$`, using `\boldsymbol{}` for vectors and `\lVert\rVert` for norms.
2. Geometric or intuitive reading immediately after: what does the condition look like in $\mathbb{R}^n$? What does the inequality enforce?
3. Theorems as `**定理**：` prose. Name the theorem if it has a name.
4. Full proof in `???- Info "证明"`, with **Chinese commentary between derivation steps** explaining which manipulation was applied and why it is valid — not just symbols.
5. Connect the result forward: "这就保证了梯度法的全局收敛性" or "因此步长可以选为 $h \in (0, 1/L]$".

Collapsed commentary from the original source (raw OCR or notes) belongs in `<!-- ... -->` HTML comments, not in the visible body.

### AI and ML

ML notes organize around **design decisions**, not narrative flow. For each architectural or training choice:

1. **Baseline**: What did the original design do? State the formula if it differs.
2. **Variant**: What exactly changed? Give the formula with `$$...$$`.
3. **Motivation**: Hardware cost, training stability, or empirical evidence. Cite paper and year parenthetically when the note includes it: "Xiong 2020 发现 Post-norm 在初始化阶段梯度随层数增长而爆炸".
4. **Consensus status**: Use the standard vocabulary — `"目前是铁律"`, `"大多数现代 [模型/Transformer]"`, `"仍有争议"`. Do not paraphrase these.
5. Cross-reference: If the same mechanism appears in nearby notes or model families, name them.

For ML notes covering algorithms (attention, backprop, training loops), pair code with narrative. Collapse long implementation examples under `???- Info "Code"` so the conceptual path stays readable.

## Common Failure Modes To Avoid

Do not turn every paragraph into bullets. Bullets are good for definitions, cases, algorithm steps, and compact comparisons; conceptual explanation should be prose.

Do not preserve a PPT's slide order when it obscures the idea. Slides are presentation artifacts; notebook notes need a durable concept hierarchy.

Do not add emoji to notes. Do not use decorative metaphors when a direct technical explanation is clearer.

Do not silently invent missing details. If the source is ambiguous, state the uncertainty in the working response or ask the user, and keep unsupported claims out of the note.

Do not write self-referential directory prose. Replace it with direct technical mapping: "Vectorization separates elementary operation from vectorized axes" is useful; "this directory is organized as a reading path" is not.

Do not flatten series-local conventions into domain-wide ones. The `??? Info "高僧预测"` collapsible is a CAQA-series convention; the boxed pseudocode `$$\boxed{...}$$` is an optimization-series convention; the simple `!!! Abstract "Table of Contents"` outline without a one-sentence arc appears in the CV series. Observe the local series before imposing a pattern from another.

Do not produce AI-patterned prose. After writing, run a final pass against `references/human-voice.md` to catch significance inflation, filler transitions, vague attributions, formulaic endings, rule-of-three patterns, meta-commentary, and uniform rhythm. The notebook voice should read like a person who actually understood the material, not a language model summarizing it.
