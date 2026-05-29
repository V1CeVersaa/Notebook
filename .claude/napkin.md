# Napkin Runbook

## Curation Rules
- Re-prioritize on every read.
- Keep recurring, high-value notes only.
- Max 10 items per category.
- Each item includes date + "Do instead".

## Execution & Validation (Highest Priority)
1. **[2026-04-05] Notes should preserve local style**
   Do instead: inspect adjacent sections before editing and match heading depth, admonition style, and code density.

## User Directives
1. **[2026-04-05] Python notes should be concise but complete**
   Do instead: keep explanations compact, include only the examples needed to cover the chapters main mechanisms.

## Navigation & Index Pages
1. **[2026-05-17] New note directories should follow `mkdocs.yml`**
   Do instead: inspect the relevant `nav` block before creating a new topic directory, preserve the repo's actual path/case/file naming, and wire multi-file topics into the smallest matching nav subtree when requested.
2. **[2026-05-17] Topic `index.md` pages have a strict contract**
   Do instead: use one H1, then bare `!!! info`, then `## Table of Contents` with task-list links whose checkbox marks completeness, and only an optional concise `## Introduction` after that.
3. **[2026-05-17] Index prose should describe content, not bookkeeping**
   Do instead: say what each child note teaches and which primitives matter; avoid visible explanations of directory organization, checkbox semantics, or reading-order instructions.
