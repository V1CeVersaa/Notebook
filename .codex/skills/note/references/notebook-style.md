# Notebook Style Guide

This reference defines file organization and Markdown formatting for notebook artifacts. Read the sections needed for the current change. Existing series conventions take precedence over default templates, within the user's requested scope. Explanatory prose is covered in [human-voice.md](human-voice.md); coverage questions are in [domain-patterns.md](domain-patterns.md). These artifact conventions do not prescribe the assistant's chat style.

## Repository Shape

The notebook is a MkDocs Material site. Notes live under `docs/` and are grouped by subject: `docs/ai/`, `docs/cs/`, `docs/math/`, `docs/system/`, `docs/rl/`, and `docs/varia/`. A single Markdown file is usually one lecture, chapter, or focused technical topic. Assets normally live in a sibling `assets/` directory near the note.

When creating a new directory, a multi-file topic, or an `index.md`, inspect `mkdocs.yml` before choosing paths. The `nav` tree is the notebook's public map: it usually points a topic label to `path/index.md`, then lists child notes as sibling Markdown files under the same directory. Preserve the repo's actual path casing, spaces, underscores, hyphens, and numbering style instead of inventing a cleaner convention. Course/book series often use files such as `1 Intro.md`, `Chapter 1.md`, or `topic1.md`; framework/tool topics often use lowercase slugs such as `einx/vectorization.md`. Never create a path that differs from an existing one only by letter case.

A request for a new navigable topic includes its necessary index and minimal nav wiring. Patch only the smallest matching subtree and make every nav path match an actual file. Otherwise, keep existing navigation and directories unless the requested change needs them.

## Language And Voice

Body text is Chinese. Code identifiers, APIs, algorithm names, and standard English acronyms stay English. On first formal introduction of a technical concept, use a bilingual pair, such as `策略梯度/Policy Gradient` or `静态单赋值/Static Single Assignment/SSA`. A mention in the outline admonition does not count as the first formal introduction — give the pair again where the concept is actually defined in the body; after that, either language alone is fine depending on what reads more naturally. Everyday CS terms such as 缓存、寄存器、变量、函数 do not need forced English pairing.

Write as a student explaining the material to a future self: connected explanations, complete coverage of the requested knowledge, and enough detail to follow the reasoning. Use [human-voice.md](human-voice.md) for writing decisions and examples.

Do not let the note explain its own bookkeeping. Visible prose should not say things like “this directory only keeps the reading route”, “the following checkbox means completion”, “these details are placed in child notes”, or “read these in this order”. Orientation is useful only when it names the technical content itself: which primitive is introduced, what mechanism a section explains, and what boundary or failure mode the reader should remember.

## Micro-Typography

Use these defaults for new text unless the target series or user specifies otherwise:

- Put a half-width space between Chinese text and Latin letters, numbers, inline code, or inline math: `LLM 上的 RL`, `使用 3 个参数`, `记好这个 $\phi_2$`.
- Chinese prose uses full-width punctuation（，。：（）？）; text inside code, math, and pure-English fragments uses half-width punctuation. Parentheses wrapping Chinese content are full-width even when the content includes English: `（梯度衰减/Gradient Attenuation）`.
- Bold definition markers take a full-width colon: `**定义**：`, `**定理**：`, `**R1-Zero**：`.
- Use punctuation to make sentence structure clear. A comma, parenthesis, colon, or Chinese em dash `——` can introduce an explanation; choose according to the relationship rather than a fixed punctuation quota.
- Bold `**...**` highlights key concepts and conclusions. Italic `*...*` may mark brief emphasis when it matches the local register; avoid highlighting whole paragraphs.

## Structure

Use exactly one H1. For an index in an existing series, follow that series's structure. For a new topic without an established index convention, use this default:

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

The task-list checkbox in the table of contents marks whether the linked note is complete enough to use, but do not explain that convention in visible note prose. Arrange child links by conceptual structure, not by a narrated reading sequence. Keep `index.md` lean and do not put installation walkthroughs, long examples, full derivations, or detailed summaries there. Move those into child files and link them from the table of contents. The `## Introduction` section is optional; when present it should be concise and analytical rather than a second outline.

Existing indexes may omit the introductory callout, use another admonition, or credit sources visibly. Preserve those local choices; do not normalize unrelated indexes to this template.

Ordinary substantial notes should include an outline admonition after the H1 or after a short opening paragraph:

```markdown
!!! Abstract "Outline"

    一句话概括本讲核心内容和脉络。

    - [x] [1. Finished Section](#1-finished-section)
    - [ ] 2. Planned Section
```

The outline sentence should explain the note's conceptual arc, not merely list topics. Mark `[x]` only for sections that are actually written. A planned-but-unwritten section appears in the outline as an unchecked plain-text item (no link, since there is no heading yet); do not leave empty headings in the body as placeholders. Link the item once the section exists.

H2 conventions vary by series. Common patterns are `## 1. Section Name`, `## 十一、Python 风格对象`, and `## Lecture 7: ...`. Match adjacent files first. H3 sections are normally numbered within the parent, such as `### 1.1 ...`, unless the local series uses short unnumbered helper headings. Use H3 only when a section needs real internal structure.

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

Use `$...$` inline and `$$...$$` display, with no spaces just inside inline math delimiters. Prefer `\mathrm{}` for text inside math, `\boldsymbol{}` for vectors, `\lVert \rVert` for norms, and `\operatorname*{}` for operators such as `argmin`. Use `aligned` or `gather` for multi-line derivations.

Keep notation consistent with the target series. For explanatory commentary between formulas and the scope of derivations, see [human-voice.md](human-voice.md) and the relevant section of [domain-patterns.md](domain-patterns.md).

## Code

Use fenced code blocks with language tags: `py`, `cpp`, `rust`, `C`, `txt`, `bash`, etc. Inline language-specific highlighting appears in the repo, for example `` `#!cpp std::optional` `` and `` `#!py torch.no_grad()` ``. Use it when it improves readability and matches the local file.

Long code can go under `???- Info "Code"` when it would interrupt the main explanation. Keep code visible when it is the current object of study, and explain the lines needed to understand the mechanism.

## Images

Use this image form:

```markdown
<img class="center-picture" src="./assets/filename.webp" width=550 />
```

Keep image paths relative to the note. Use width around `550` by default; ML notes with wide architecture diagrams or dense screenshots use `600`; narrow diagrams that need less horizontal space use `400`–`500`. Add `alt` text only if nearby files do so consistently; when used, name the concept the figure illustrates rather than describing layout.

**Naming**: files go in `assets/` next to the note and follow `{index}-{number}[-{topic}].webp`, with hyphens as separators. The `index` is the lecture or chapter number (e.g. `15`) or a topic slug (e.g. `AVL`); `number` is the sequential count within that note starting at 1; `topic` is an optional short English slug added when it clarifies the subject (e.g. `15-2-attention.webp`). Large series may use numbered asset subdirectories (`assets_1/`, `assets_2/`) or named subdirectories (`assets/6 IR/`); match the local series convention.

**Selection**: Include images that help explain the requested material or preserve necessary source evidence. No image count or density is required; zero images can be appropriate. Selection and final inspection are covered in [image-workflow.md](image-workflow.md).

Do not fabricate source figures or empirical data. A `<!-- FIGURE: ... -->` comment can mark an asset still needed during drafting, but does not satisfy the final deliverable. Source extraction, processing, and insertion are covered in [image-workflow.md](image-workflow.md).

## Source Notes And References

Keep production metadata such as source file paths, slide origins, and extraction notes in HTML comments. Keep attribution needed to interpret or check a technical claim visible near that claim, following local citation style. Hidden production metadata can use:

```markdown
<!-- Source: ... -->
```

Do not put visible “generated from PPT” or placement commentary into the note body unless the user asks for that provenance to be visible.

## Definition Markers and Local Conventions

In math and theory notes, use bold prose markers such as `**定义**：`, `**定理**：`, `**性质**：`, and `**Proof：**` for ordinary statements. Reserve `!!! Danger "Theorem Title"` for central named theorems when that matches the series.

Series-specific choices remain local: `??? Info "高僧预测"` appears in CAQA notes, boxed pseudocode in optimization notes, and a simple `!!! Abstract "Table of Contents"` in CV notes. Do not transfer one series's devices to every subject.

Do not add emoji to notebook artifacts by default. Conversation can follow the user's chat preferences. Use direct technical explanation, with the vocabulary and depth the material needs; the writing reference governs narrative choices without prescribing fixed opinions or phrases.
