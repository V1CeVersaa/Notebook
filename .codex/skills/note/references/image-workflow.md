# Image Workflow Reference

This reference covers the full pipeline for acquiring, processing, converting, and inserting images into notebook notes. It is the operational companion to the brief image guidance in `SKILL.md` and `notebook-style.md`.

## Pipeline Overview

Every image passes through four stages before appearing in a note:

1. **Acquire** — obtain a raw image from a PDF or locate an already-extracted file
2. **Process** — crop and rotate to eliminate waste; nothing more
3. **Convert** — produce a `.webp` file at the right quality
4. **Insert** — choose a width, name the file correctly, and embed the HTML tag

---

## Stage 1: Acquire

### Extract pages from a PDF

Use `ffmpeg` to render PDF pages to high-resolution PNG. Extract only the pages that will be used, not the whole document.

```bash
# Single page (page 5, one-indexed in ffmpeg's -ss)
ffmpeg -i source.pdf -vf "scale=3000:-1" -vframes 1 -ss 4 raw-page.png

# A range of pages — then pick what you need
ffmpeg -i source.pdf -vf "scale=3000:-1" frames/page%03d.png
```

Resolution `scale=3000:-1` keeps width at 3000 px and preserves aspect ratio — enough to crop without visible interpolation artefacts in the final webp.

If `ffmpeg` does not handle the specific PDF cleanly, fall back to a Python script inside the `MISC` conda environment using `fitz` (PyMuPDF):

```bash
conda run -n MISC python - <<'EOF'
import fitz, sys
doc = fitz.open("source.pdf")
page = doc[4]          # zero-indexed
mat = fitz.Matrix(3, 3)   # 3× zoom ≈ 216 dpi
pix = page.get_pixmap(matrix=mat)
pix.save("raw-page.png")
EOF
```

### Locate an already-extracted image

If the source material already has image files (JPEG, PNG, TIFF), use them directly. Skip to Stage 2.

---

## Stage 2: Process

The only allowed operations are **crop** and **rotate**. The goal is a tight, unambiguous frame: no slide decorations, no irrelevant whitespace, no partial adjacent diagrams, and no missing parts of the relevant content.

Prefer `ffmpeg` for both operations to stay in one tool.

```bash
# Crop: w × h pixels starting at x,y from top-left
ffmpeg -i raw-page.png -vf "crop=1800:900:120:340" cropped.png

# Rotate 90° clockwise (transpose=1), 90° CCW (transpose=2), 180° (transpose=2,transpose=2)
ffmpeg -i raw-page.png -vf "transpose=1" rotated.png

# Crop then rotate in one pass
ffmpeg -i raw-page.png -vf "crop=1800:900:120:340,transpose=1" processed.png
```

**Crop discipline**: include the full diagram title/label if it identifies the figure; exclude unrelated slide text, logos, slide numbers, and excessive blank margins. When two closely related sub-figures appear on the same slide and the note refers to both together, keep them in one image. When they are referenced separately, crop to two files.

---

## Stage 3: Convert

Convert every processed image to `.webp` using `cwebp`. Use quality 85 as the default; drop to 75 for screenshots with flat areas, raise to 92 for diagrams with fine detail.

```bash
cwebp -q 85 processed.png -o output.webp
```

If converting a batch:

```bash
for f in processed/*.png; do
    cwebp -q 85 "$f" -o "${f%.png}.webp"
done
```

Do not keep intermediate PNG files in the `assets/` directory. Only `.webp` files (and source PDFs when the PDF itself is a note attachment) belong there.

---

## Stage 4: Name and Place

### Naming convention

Files go in the `assets/` directory next to the note (or a subdirectory of `assets/` when the series has a large image collection). File names use the pattern:

```
{index}-{number}[-{topic}].webp
```

| Part | Meaning | Required |
|------|---------|----------|
| `index` | The note's index prefix — lecture number (e.g. `15`), chapter number, or topic slug (e.g. `AVL`) | yes |
| `number` | Sequential count of images within that note, starting at 1 | yes |
| `topic` | Short English slug describing the diagram's subject (e.g. `attention-mask`, `pipeline`, `layer-norm`) | when it adds clarity |

Separators are hyphens. Do not use underscores or spaces. Examples:

```
15-1.webp           # lecture 15, first image
15-2-attention.webp # lecture 15, second image, topic: attention
AVL-1.webp          # topic-indexed series, first image
6-3-cfg.webp        # lecture 6, third image, topic: CFG
```

When a note's `index` is a multi-part string like `106L-15`, preserve that prefix verbatim: `106L-15-1.webp`.

### Asset subdirectories

- **Default**: single `assets/` per note directory
- **Large series** (many images per directory, e.g. CV): use numbered subdirectories `assets_1/`, `assets_2/`, `assets_3/` — one per cluster of notes
- **Compilers / structured courses**: may use named subdirectories such as `assets/6 IR/` to mirror lecture groupings; follow the existing convention in that series

---

## Stage 5: Insert

### HTML template

```markdown
<img class="center-picture" src="./assets/filename.webp" width=550 />
```

- Always use the `center-picture` class
- Path is always relative to the note (`./assets/`)
- Format is always `.webp`
- Width is set in pixels with no `px` suffix

### Width selection

| Context | Width |
|---------|-------|
| Default (diagrams, architecture figures, algorithm flowcharts) | `550` |
| Dense screenshots or wide figures (ML architecture, full pipeline) | `600` |
| Narrow diagrams that only need a portion of the line width | `400`–`500` |

Adjust to the largest value that makes the figure readable without over-scaling. When a series has an established width convention, match it rather than using the default.

Add `alt` text only when nearby files in the same series do so consistently. When used, `alt` should name the concept the figure illustrates, not describe layout.

---

## Environment

`ffmpeg` and `cwebp` are available in the system environment. Use them directly from the shell.

For Python-based steps (e.g. PyMuPDF page extraction), always run inside the `MISC` conda environment to avoid polluting the outer environment:

```bash
conda run -n MISC python script.py
# or interactively:
conda activate MISC
python ...
```

Do not `pip install` anything outside of `MISC`.

---

## Image Density by Domain

Images are not decoration — they replace prose that cannot convey spatial, structural, or sequential information as efficiently. The right count depends on the domain:

| Domain | Typical density | Rationale |
|--------|----------------|-----------|
| CV, perceptual ML, RL environments | high (4–8 per ~1000 words) | architecture diagrams, training curves, qualitative results are irreplaceable |
| Systems, compilers, algorithms | moderate (2–4 per ~1000 words) | data-structure diagrams, pipeline stages, assembly/IR comparisons add genuine value |
| Math, optimization, probability | low–sparse (0–2 per ~1000 words) | derivations and definitions are primary; reserve images for geometric intuitions |
| TCS, formal languages, logic | sparse (0–1 per ~1000 words) | reduction diagrams and automaton diagrams can help; symbolic content dominates |
| PL, programming language notes | sparse (0–1 per ~1000 words) | code and AST snippets serve the same function |

The heuristic "two to three images per thousand words" is a rough baseline for a balanced note; weight it by domain. A CV lecture note with no images is almost certainly missing something; a probability theorem note with five images may be over-illustrated.
