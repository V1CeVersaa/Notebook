---
name: note
description: >-
  Create, expand, revise, or organize Markdown study notes in this MkDocs
  notebook. Use for requests to turn material into notebook notes or edit
  existing notes; not for chat-only reading, explanation, or review.
---

# V1CeVersa Notebook Note Skill

Produce notes that explain the material coherently, cover the requested knowledge completely, and use no more space than the explanation needs. Accept source files, URLs, excerpts, and an optional target path. Follow the user's requested scope and deliverable; a source or `docs/` path alone does not authorize writing a note.

## Choose the Work Needed

**Mechanical edits** — typos, links, and local formatting: read the affected passage and enough context to avoid changing its meaning. Check the changed text or link directly; do not load writing guides or inspect unrelated notes.

**Content patches** — a definition, derivation, example, or section: read the affected section and follow its dependencies (symbols, assumptions, references, and subsequent uses). Read the whole note only when those dependencies require it. Match the target's existing conventions; inspect a nearby note only if the target leaves a convention unclear. Apply the writing guidance to new or modified prose, not to untouched paragraphs. Update an outline when section coverage changes. Do not add navigation or reorganize files unless needed for the requested deliverable.

**New notes or substantial rewrites** — read the source within the requested coverage, identify its conceptual dependencies, and inspect representative nearby notes. Use the references below to plan and draft. Expanding a short outline entry is a patch; completing an entire stub follows this route. An existing file can take either route according to the user's request.

**Placement and navigation changes** — inspect the relevant `mkdocs.yml` subtree and local path conventions. A request for a new navigable topic includes the necessary index and minimal nav wiring; a single-note patch does not. Use the user's target when given. Ask only if unresolved placement would materially change the notebook's long-term structure; continue independent reading meanwhile.

## Read References as Needed

- [notebook-style.md](references/notebook-style.md): formatting and file organization. Read the relevant sections when creating a note or changing its structure; use the target's conventions for a small patch.
- [human-voice.md](references/human-voice.md): explanatory, connected Chinese prose. Read when drafting or substantially revising prose; consult examples when useful for calibration.
- [domain-patterns.md](references/domain-patterns.md): coverage questions for a new note or substantive section. Read only the relevant domain. These are prompts for deciding what the material needs, not mandatory headings or a fixed order.
- [image-workflow.md](references/image-workflow.md): read when acquiring or modifying images. Skip when the task needs no image work.

Local series conventions guide formatting, not factual correctness. The references refine the task within the scope set by the user and `AGENTS.md`.

## Source and Coverage

For a full chapter, lecture, or paper note, read the whole requested source unit, including relevant figures, captions, tables, assumptions, and limitations. For a targeted addition, read the relevant passages and their dependencies. Do not infer unread coverage from a title or abstract. If extraction is incomplete, identify the gap and recover the affected material before claiming complete coverage.

Organize a learning note by conceptual dependencies while preserving all substantive content needed for the requested scope. Follow source order when the user requests faithful translation or sequential commentary. For slides, recover the connections between definitions, diagrams, and derivations; for articles, retain the argument and qualifications. Cut repeated exposition rather than necessary reasoning.

Source fidelity is always required. Distinguish reported claims, explanatory derivations, and your own evaluations. Derive added explanations from stated premises or support them with sources. Do not invent missing empirical results, citations, causal explanations, or consensus. Keep assumptions and uncertainty close to the claims they qualify.

## Draft, Review, and Illustrate

Draft the conceptual explanation, checking coverage and dependencies as it develops. Review content and structure before polishing wording. Correct only the requested scope; flag unrelated problems separately. The workflow can revisit a previous decision when reading or verification reveals an error.

Inspect source figures when needed to understand the material. Usually finish text structure before bulk image processing. During drafting, a temporary `<!-- FIGURE: concept; source page -->` comment can mark an image still needed. Choose images for the information they contribute, with no required count or density. For several images, keep a compact working record of placement, purpose, and source to avoid repeated searches.

Acquire, process, and insert the needed assets using the image reference. If inspecting a figure reveals a factual or structural error, correct the affected text and check it again. Text is not frozen against corrections.

## Completion and Verification

Finish the requested local edits and their applicable checks without asking for review between routine steps. Follow `AGENTS.md` for preview and build selection; do not run a repository build for prose-only edits.

A complete delivery covers the requested material, preserves qualifications, and includes the necessary figures and explanations. Check changed outline entries, links, anchors, nav paths, and image paths against their actual targets. After inserting images, inspect the resulting assets for legibility, complete labels, and agreement with the prose; inspect the rendered page when sizing or placement needs validation.

Temporary figure comments and unchecked outline entries are not substitutes for required content. Remove obsolete placeholders; if a necessary source or asset remains unavailable, state exactly what is incomplete, finish independent work, and do not describe the note as complete. An explicitly requested draft may retain clearly identified gaps.

Stop verification after relevant checks pass unless a new change, failure, or unresolved concern warrants another check. Report the deliverable, checks performed, and material limitations concisely.
