# AGENTS.md

Guidelines for agents working in this notebook repository.

This repository is a MkDocs Material notebook. The goal is to maintain durable notes that match the owner's existing structure, tone, and navigation.

## Use the Note Skill

For any task that creates, rewrites, expands, moves, splits, or files notes, or turns PPTs, PDFs, articles, papers, webpages, screenshots, or rough excerpts into Markdown notes, read and follow:

- `.codex/skills/note/SKILL.md`
- `.codex/skills/note/references/notebook-style.md`

Those files are the source of truth for note writing, directory placement, topic `index.md` structure, language style, vocabulary register, domain-specific explanation patterns, and validation. Keep this root file small; if instructions conflict, follow the more specific skill guidance.

## Think Before Editing

Before writing or reorganizing notes, inspect nearby files in the same directory and the relevant `mkdocs.yml` nav block. Match the existing path names, heading depth, admonition style, code density, image syntax, math conventions, casing, spaces, underscores, hyphens, numbering, and navigation depth. Do not invent a cleaner path convention just because it looks nicer.

If several placements are plausible, surface the ambiguity instead of silently choosing one that changes the long-term notebook structure.

## Keep Changes Small

Touch only the files needed for the requested note or navigation change. Do not refactor unrelated notes, rename unrelated directories, reformat old prose, clean up existing warnings, or delete content that your current change did not make obsolete. If a problem is outside the requested scope, mention it separately.

## Write Notebook Notes, Not Chat Summaries

Notes should be Chinese, technical, and useful to a future reader. Keep APIs, code identifiers, algorithm names, and standard English acronyms in English. Explain concepts directly, unpack formulas and code, and organize by the real conceptual structure rather than by slide/page order.

Avoid visible self-referential prose such as explaining how the directory is organized, what the agent did, why files were split, what checkboxes mean, or what order the reader should follow. If orientation is needed, describe the technical content itself: what each section teaches, which primitives matter, and where the conceptual boundaries are.

## Topic Index Pages

Every topic `index.md` should stay lean:

```markdown
# [Topic Title]

!!! info

    [Brief technical map: core idea, key primitives, or scope.]

## Table of Contents

- [ ] [Child Note Title](./child-note.md)
- [x] [Complete Child Note](./complete-note.md)

## Introduction

[Optional concise technical introduction.]
```

Arrange the table of contents by conceptual structure, not by narrated reading instructions. Do not put long examples, installation details, derivations, source provenance, or broad summaries in `index.md`; put them in child notes.

## Verification

For normal note edits, first check the changed Markdown directly. If the site is already served on `localhost:8000`, verify rendered pages there instead of running a full `mkdocs build` by default. Run `mkdocs build` only when navigation, links, Markdown extensions, or generated site behavior need a repository-level check.

When running `mkdocs build`, do not leave the generated `site/` directory in the working tree. Prefer writing the build output somewhere outside the repository, for example `mkdocs build --strict -d /tmp/note-mkdocs-site`, and remove the generated `site/` directory after verification if the default output path was used.

If `mkdocs build --strict` fails because of pre-existing warnings, separate those from issues introduced by the current change.
