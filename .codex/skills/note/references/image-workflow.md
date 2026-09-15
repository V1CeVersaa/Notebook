# Image Workflow Reference

Read this reference when the task needs image acquisition or changes. It covers source extraction, processing, conversion, insertion, and final inspection. Overall task completion is defined in [SKILL.md](../SKILL.md), and formatting in [notebook-style.md](notebook-style.md).

## Pipeline Overview

For source figures, use the operations that are needed; reuse already suitable assets:

1. **Acquire** — obtain a raw image from a PDF or locate an already-extracted file
2. **Process** — frame the relevant content while preserving labels and evidence
3. **Convert** — produce a `.webp` file at the right quality
4. **Insert** — choose a width, name the file correctly, and embed the HTML tag

---

## Stage 1: Acquire

### Extract pages from a PDF

`ffmpeg` cannot decode PDFs — do not try `ffmpeg -i source.pdf`. Render pages with `fitz` (PyMuPDF) in a suitable environment, or use Poppler as shown below. The Python example uses the existing `MISC` environment. Extract only the pages that will be used, not the whole document.

```bash
conda run --no-capture-output -n MISC python - <<'EOF'
import fitz
doc = fitz.open("source.pdf")
mat = fitz.Matrix(3, 3)   # 3× zoom ≈ 216 dpi — enough to crop without artefacts
for pno in [4, 11, 12]:   # zero-indexed pages to extract
    pix = doc[pno].get_pixmap(matrix=mat)
    pix.save(f"raw-page-{pno + 1}.png")
EOF
```

If poppler is available, `pdftoppm` is a shell-only alternative for page ranges (`-f`/`-l` are one-indexed):

```bash
pdftoppm -png -r 200 -f 5 -l 5 source.pdf raw-page
```

### Locate an already-extracted image

If the source material already has image files (JPEG, PNG, TIFF), use them directly. Skip to Stage 2.

---

## Stage 2: Process

For source figures, use **crop** and **rotate** to obtain a readable frame. Preserve axes, labels, legends, and subfigures needed to interpret the content; do not alter plotted data or remove qualifications. Resizing and format conversion must preserve legibility.

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

Check whether `ffmpeg`, `cwebp`, and the needed PDF renderer are available before choosing commands. Use installed tools directly; do not assume another machine has the same environment.

For Python-based steps (e.g. PyMuPDF page extraction), prefer the existing `MISC` conda environment. If unavailable, use an already suitable isolated environment or the Poppler alternative; do not block solely on the environment name:

```bash
conda run -n MISC python script.py
# or interactively:
conda activate MISC
python ...
```

Do not `pip install` anything outside of `MISC`.

---

## Image Selection

Select images by explanatory value and source evidence, with no density quota. Architecture diagrams, training curves, and qualitative results may be central to a CV or RL note; symbolic derivations and code may already explain a math or PL topic. These are cues to check for omissions, not requirements to add or remove a certain number of images.

For each image, identify what the reader learns from it and where the prose uses it. Preserve figures needed to substantiate a reported result. Zero images is acceptable when the requested material is fully explained without them.

## Final Inspection

After insertion, open the final assets and verify that labels, axes, legends, and fine detail remain readable, the relevant content is complete, and the image supports the surrounding explanation. Check relative paths from the note; inspect the rendered page when displayed width or placement matters, using the verification guidance in `AGENTS.md` at the repository root.

If a figure reveals a factual or structural error, revise the affected prose and recheck that portion. Resolve temporary figure comments before declaring the note complete. Report a missing necessary asset as incomplete work, not as a successful image stage.
