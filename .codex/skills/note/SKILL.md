---
name: note
description: >-
  Convert PPTs, slide decks, PDFs, Word documents, lecture transcripts,
  articles, papers, screenshots, rough bullets, or existing excerpts into
  V1CeVersa's Notebook notes. Use this skill whenever the user asks to read
  material and write, expand, rewrite, or place a note in this MkDocs notebook,
  even if they only say "整理成笔记", "做成 notebook 风格", "读一下这个 PPT",
  "根据这篇文章生成笔记", or provide a target docs/ path.
argument-hint: "[source file/path/url/text] [optional target docs path]"
---

# V1CeVersa Notebook Note Skill

This skill turns source material into notes that feel native to V1CeVersa's MkDocs Material notebook. It is meant for substantial note production, not a chat summary. The output should usually be a Markdown note under `docs/`, or a targeted patch to an existing note.

Before writing, read `references/notebook-style.md`. When working inside the notebook repo, also inspect nearby notes in the same series because local convention beats global convention. Before delivering, run a final anti-AI pass against `references/human-voice.md` to check for significance inflation, filler transitions, formulaic endings, meta-commentary, and uniform rhythm. When creating a new directory, a multi-file topic, or any `index.md`, inspect the relevant `mkdocs.yml` `nav` block before deciding names, paths, and whether the new pages should be wired into navigation.

## Operating Workflow

The workflow has four explicit stages. Do not begin a later stage while the current one is incomplete. **Note quality is the primary bottleneck; images come last, after the text is stable.**

### Stage 1: Orient

Identify the **source type**, **target location**, and **note role**. If the user gives a target file, use it. If the target is not explicit but the topic clearly belongs to an existing section such as `docs/ai/lm/`, `docs/cs/compilers/`, `docs/math/opt/`, or `docs/system/caqa/`, choose the closest series after checking adjacent files and the matching `mkdocs.yml` nav subtree. Ask a short question only when placement is genuinely ambiguous.

Read enough of the source before drafting. For PPTs and slide PDFs, recover the lecture arc from titles, slide order, figures, equations, captions, and speaker notes when present. Do not produce a slide-by-slide transcript unless explicitly asked. For documents and articles, extract the central problem, definitions, mechanism, derivations, evidence, limitations, and reusable examples. For papers, separate source-backed claims from your own explanatory unpacking.

Inspect one to three nearby notebook files. Match the series' heading language, numbering convention, outline admonition style, code density, and math notation. For domain-specific explanation structure and vocabulary register, consult `## Explanation Patterns by Domain` and `## Vocabulary and Register` in `references/notebook-style.md`.

### Stage 2: Draft

Write the note as a **learning artifact** — Chinese, technically precise, student-to-future-self. Restructure material into a concept hierarchy; explain why each concept is introduced; unpack formal definitions immediately after giving them; walk through derivations step by step. Use bullets for definitions, checklists, algorithm steps, and compact comparisons; keep main explanations in connected prose. Avoid self-descriptive organization prose.

Do **not** insert actual images during drafting. Where a figure from the source material is likely needed, leave a placeholder comment instead:

```markdown
<!-- FIGURE: brief description of what the figure should show, and where it appears in the source -->
```

This keeps the text structure visible during review without committing to specific assets yet.

### Stage 3: Review

After drafting, do a dedicated review pass on two tracks before touching any image file.

**Text quality track** — check each of the following:

- Every formal definition is unpacked immediately after the formula or statement, not several paragraphs later.
- Derivations have Chinese commentary between steps explaining what changed and why; there are no bare symbol-chain blocks.
- ML/LM notes classify each architectural or training choice as `"目前是铁律"` / `"大多数现代 [X] 使用"` / `"仍有争议"` — not paraphrased.
- Systems and compilers notes state design-space tradeoffs explicitly before naming the winner.
- Theory notes give intuition immediately after the formal definition, not only after the proof.
- No self-referential org prose, no empty overview paragraphs, no generic filler transitions.
- Anti-AI pass against `references/human-voice.md`: check for significance inflation, rule-of-three patterns, formulaic endings, vague attributions, and uniform rhythm.
- Heading hierarchy matches adjacent files; outline checklist reflects what is actually written; bilingual pairs appear on first formal introduction.

**Image placement track** — produce an explicit list of image slots. For each slot, record:

1. Location: which section heading and what concept the prose is explaining at that point
2. What the figure must show: the specific diagram, chart, or algorithm illustration needed — precise enough that someone can locate it in the source PDF
3. Justification: what spatial, structural, or sequential information the prose alone cannot convey as efficiently
4. Source hint: approximate page or slide number if known

A slot without a clear justification should be dropped. The total slot count should match the domain density target (see `references/image-workflow.md` → "Image Density by Domain").

**Output of Stage 3**: a list of text corrections and the finalized image slot list.

### Stage 4: Revise

Apply all text corrections. Remove placeholder comments that the review found unjustified. If the review found that a section needs expansion, write it before proceeding. After revision, the note text is frozen — do not make further structural changes during the image pipeline.

Run a final consistency pass: title and H2/H3 hierarchy coherent; outline checklist matches written files; first formal technical terms have bilingual pairs; math and code formatting follow notebook conventions; `mkdocs.yml` paths match actual file names if navigation was touched.

### Stage 5: Image Pipeline

Only begin after Stages 1–4 are complete and the note text is stable. Use the image slot list from the review as the work order. For each slot: acquire the raw image from the source, process (crop/rotate), convert to webp, name correctly, and insert the HTML tag at the anchored location.

Full operational details — ffmpeg extraction commands, cwebp options, naming convention, width table, conda MISC environment — are in `references/image-workflow.md`.

## Output Contract

When creating or revising a topic `index.md`, use this exact structure:

```markdown
# [Topic Title]

!!! info

    一两句话说明这个主题的技术核心、关键 primitives 或内容地图。不要给 admonition 加标题，不要解释目录组织逻辑。

## Table of Contents

- [ ] [Child Note Title](./child-note.md)
- [x] [Completed Child Note](./completed-note.md)

## Introduction

用最少篇幅说明这个主题最关键的问题、技术分层和切中要害的判断。
```

The checkboxes under `## Table of Contents` are the completeness/status markers, but do not say that in the visible note body. Arrange the table of contents by the topic's conceptual structure, not by a narrated "reading order". Keep `index.md` lean: no full derivations, installation walkthroughs, long examples, source provenance, or verbose reading notes. Move those into child notes and link them from the task list. The `## Introduction` section is optional, but when present it should be concise and analytical rather than a second outline.

When creating an ordinary content note, use one H1 title and usually place an outline admonition immediately after it:

```markdown
# [Title]

!!! Abstract "Outline"

    一句话概括本讲的核心问题、推进顺序和最后得到的理解。

    - [x] [1. First Major Section](#1-first-major-section)
    - [x] [2. Second Major Section](#2-second-major-section)
```

Use numbered H2 sections by default. Match adjacent files when they use Chinese ordinals such as `## 十一、Python 风格对象`, lecture titles such as `## Lecture 7: ...`, or unnumbered legacy headings. Use H3 only when a section needs real internal structure.

When a note uses an outline, internal cross-links, or headings that are likely to be referenced later, prefer explicit MkDocs heading anchors with `attr_list` instead of relying on generated anchors. This is especially important for Chinese headings, punctuation-heavy headings, and headings containing inline code. Use readable stable IDs such as:

```markdown
## 七、函数是一等对象 { #chapter-7 }

### 7.1 函数对象与高阶函数 { #chapter-7-first-class }
```

Point outline links to those explicit IDs. In book/course series, keep the anchor scheme local and predictable, for example `#chapter-7` for chapter-level sections and `#chapter-7-first-class` or `#chapter-7-1` for subsection-level sections. Do not churn anchors that are already explicit and working unless the user asks for a series-wide normalization.

For technical explanations, prefer this rhythm: introduce the problem, state the formal object, immediately explain what it means, then show how it is used. A definition like `优势函数/Advantage Function` should not be left as a symbol-only formula; add the intuitive reading right after the formula.

For math-heavy material, use inline `$...$` and display `$$...$$`. Use `\mathrm{}` for text inside math, `\boldsymbol{}` for vectors, `\lVert \rVert` for norms, `\operatorname*{}` for named operators, and `aligned` or `gather` for multi-line derivations. Insert Chinese commentary between math blocks when a derivation has nontrivial steps.

For code-heavy material, use fenced blocks with language tags. Use Pymdownx inline highlighting such as `` `#!py torch.no_grad()` `` when matching existing Python/C++ notes. Collapse long code, proofs, or source excerpts under `???- Info "Code"` / `???- Info "证明"` so the main narrative stays readable.

For figures, images are inserted only after the text is reviewed and revised (Stage 5 of the Operating Workflow). The insertion form is:

```markdown
<img class="center-picture" src="./assets/name.webp" width=550 />
```

Store assets in `assets/` next to the note. Name files with `{index}-{number}[-{topic}].webp` — for example `15-2-attention.webp`. Never fabricate a figure; leave a `<!-- FIGURE: ... -->` placeholder if the asset is not yet available. Full pipeline details (ffmpeg, cwebp, naming, width table, density table) are in `references/image-workflow.md`.

For references, keep external source URLs, paper links, slide origins, and extraction notes in HTML comments, not visible prose:

```markdown
<!-- Source: ... -->
```

## Source-Specific Guidance

For PPT or slide PDFs, rebuild the logical lecture rather than mirroring slide boundaries. Slides often omit the connective tissue; add the missing motivation, define symbols before using them, and explain why a transition happens. Preserve important equations, tables, algorithms, and diagrams. If a slide is only a visual reminder, turn it into the concept it supports.

For long documents or articles, compress aggressively but do not flatten the argument. Keep the causal chain: background pressure, key concept, mechanism, consequence, limitation. If the article is argumentative, make the structure of the argument visible; if it is technical, prioritize definitions, invariants, algorithms, and failure modes.

For research papers, do not write a generic paper summary. Write a notebook note that teaches the mechanism. Include the problem setting, the core insight, the method, the main empirical/theoretical claim, limitations, and how it connects to nearby notes when that context exists. If the user asks for faithfulness, be strict about what the paper actually supports.

For existing notes, avoid large style churn. Patch the missing conceptual bridge, derivation, example, or section, then update the outline checklist if appropriate. Do not update `mkdocs.yml` nav, create `index.md`, or reorganize directories unless explicitly asked or unless the current task is explicitly a new navigable multi-file topic.

## Quality Bar

A good output should read like it was written by the notebook owner after actually understanding the material. It should be **dense but not stiff**, **formal where necessary but immediately unpacked**, and **organized by concepts rather than source pages**. It should avoid generic transitions, empty overview paragraphs, emoji, decorative prose, visible meta-comments about how the note was generated, and self-referential explanations of directory structure or reading order.

Domain-specific signals: math/optimization notes must include Chinese commentary between derivation steps, not just symbol blocks; ML/LM notes must classify each design choice as settled/mainstream/contested using the standard vocabulary from `references/notebook-style.md`; systems notes must state design-space tradeoffs explicitly before naming the winner; theory notes must give intuition immediately after the formal definition, not after the proof.
