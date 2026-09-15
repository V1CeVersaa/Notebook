# AGENTS.md

Guidelines for agents working in this repository — a MkDocs Material notebook of durable study notes. The goal is notes that match the owner's existing structure, tone, and navigation.

## Use the Note Skill

For creating, revising, or organizing notebook notes, use [.codex/skills/note/SKILL.md](.codex/skills/note/SKILL.md). It routes mechanical edits, content patches, and new notes to the guidance each needs. Reading, explaining, or reviewing material in chat does not by itself authorize writing a note.

The user's explicit request sets the scope and deliverable. Skill guidance refines note production within that scope and these repository boundaries; it does not expand authorization. Local series conventions guide formatting, not factual correctness.

Chat replies follow the user's conversation preferences. Notebook artifacts follow the note style, unless the user specifies otherwise for the task. Prefer connected prose for explanations; lists and tables remain useful for steps, parallel information, and comparisons. No fixed transition phrases, emoji frequency, or paragraph pattern is required.

## Think Before Editing

Read the affected passage and its dependencies for a local edit. For new notes or substantial rewrites, inspect representative nearby notes for heading depth, admonitions, code density, images, and math conventions. Read the relevant `mkdocs.yml` subtree when adding, moving, or wiring notes; preserve the actual path casing, spaces, numbering, and navigation depth.

Use an explicit target supplied by the user. Resolve routine choices from local context; ask only when unresolved placement would materially change the long-term notebook structure. A requested new navigable topic includes its necessary index and minimal nav wiring.

## Keep Changes Small

Touch only the files needed for the requested note or navigation change. Do not refactor unrelated notes, rename unrelated directories, reformat old prose, clean up existing warnings, or delete content that your current change did not make obsolete. If a problem is outside the requested scope, mention it separately. Preserve existing uncommitted work. Complete authorized local edits and applicable checks without pausing for approval between routine steps.

## Repo Hygiene

The working copy lives on a case-insensitive filesystem (macOS), but git is case-sensitive. Never rename a file or directory only by letter case in a single step; go through a temporary name (`git mv Dir tmp && git mv tmp dir`). After any rename, check for case-duplicate paths with `git ls-files | sort -f | uniq -di` — the index has accumulated duplicates like `PyTorch/` vs `pytorch/` exactly this way. Do not create new paths that differ from an existing one only by case.

Commit only when asked. Match the existing history style: `update(scope): message` (e.g. `update(notes): add JS/TS note`) or the dated `update: YYMMDD` form.

## Verification

For normal note edits, check the changed Markdown directly. `localhost:8000` serves this notebook in one of two modes, and only one of them is safe to verify against. Writing mode (`mkdocs serve`, started by `note on`) is live: its HTML contains `livereload(`, and rendered pages reflect the current working tree — verify there instead of running a build. Reading mode is a static snapshot built by `note-build`; it carries no `livereload(` marker and may predate the current edits, so never use it to verify a change you just made. Check for live mode with `curl -fsS --max-time 5 http://127.0.0.1:8000/ | grep -q 'livereload('`; a failed request means the preview is unavailable, not that a static snapshot was verified. Run `mkdocs build` only when navigation, links, Markdown extensions, or generated site behavior need a repository-level check, and write the output outside the repo: `mkdocs build --strict -d /tmp/note-mkdocs-site`. If `--strict` fails because of pre-existing warnings, separate those from issues introduced by the current change.

Finish after the relevant checks pass; repeat or broaden them only for new changes, failures, or unresolved concerns. Check final image assets after insertion when images changed. Report unavailable checks or missing required content accurately rather than declaring an incomplete artifact finished.
