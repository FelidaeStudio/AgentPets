# Hachiware Face Correction Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current tiny-eye Hachiware identity with a new official-reference-grounded face, then rebuild and reinstall the complete validated v2 pet.

**Architecture:** Treat the new canonical base image as an approval gate and the sole generated identity source. After approval, regenerate every identity-bearing animation row and both coherent look rows, then use the existing deterministic hatch-pet scripts for extraction, assembly, chroma cleanup, QA, packaging, and installation.

**Tech Stack:** Codex `imagegen`, hatch-pet Python/Pillow scripts, PowerShell repository packaging and validation scripts, WebP/PNG v2 atlas assets.

## Global Constraints

- Official reference: `https://www.chiikawaofficial.com/characters`.
- The official Hachiware artwork on that page is the sole face-and-proportion reference.
- The previous generated canonical base and the three hand-drawn eye mockups are rejected as identity references.
- Large round black eyes preserving the official central white oval and lower white crescent highlights; never tiny bean eyes.
- Short curved eyebrows, compact eye-to-mouth spacing, and pink cheek marks with short diagonal hatching.
- Low blue hachiware forehead marking with a clear central white wedge.
- Soft, slightly elongated bean body with tiny limbs, small tail, and cat-like ears.
- Cheerful open mouth with two small pointed white fangs and a pink tongue.
- Keep `pets/hachiware/run/` reproducible and privacy-safe; `pets/hachiware/package/` contains only `pet.json` and `spritesheet.webp`.
- Final atlas is exactly `1536x2288`, uses `192x208` cells, and declares `spriteVersionNumber: 2`.

---

### Task 1: Generate and approve the corrected canonical base

**Files:**
- Preserve: `pets/hachiware/run/references/canonical-base.png` as `pets/hachiware/run/decoded/rejected/base-tiny-eye-v2.png`
- Modify: `pets/hachiware/run/prompts/base-pet.md`
- Modify after approval: `pets/hachiware/run/references/base-source.png`
- Modify after approval: `pets/hachiware/run/references/canonical-base.png`
- Modify: `pets/hachiware/run/imagegen-jobs.json`

**Interfaces:**
- Consumes: official Hachiware artwork and the locked visual traits in the design spec.
- Produces: one approved transparent/chroma-ready canonical base image used by every row job.

- [ ] **Step 1: Archive the rejected tiny-eye base without deleting run history**

Copy the current canonical base to `decoded/rejected/base-tiny-eye-v2.png`; retain all earlier rejected attempts.

- [ ] **Step 2: Rewrite the base prompt around the official face construction**

Require large round black eyes with both official white highlight shapes, short curved brows, tight eye-mouth spacing, four-line pink cheeks, the official blue forehead split, round pear-shaped body, two readable pointed fangs, and a pink tongue. Explicitly forbid tiny bean eyes, deleted highlights, deleted teeth, glossy 3D rendering, and generic cat proportions.

- [ ] **Step 3: Generate exactly one new base candidate with `imagegen`**

Use the official page artwork visible in the current conversation as the visual reference. Generate a single full-body, centered, flat hand-drawn character on the run's existing chroma background.

- [ ] **Step 4: Run visual QA before touching animation rows**

At normal pet size confirm that both eyes read as large official-style rings, the white eye interiors remain visible, the tooth is readable, and the blue marking/body proportions match the official reference.

- [ ] **Step 5: Present the base candidate to the user**

Stop at this approval gate. Only after explicit approval copy the candidate to both canonical reference paths and mark the base job complete in `imagegen-jobs.json` using repository-relative provenance.

### Task 2: Regenerate and validate standard animation rows

**Files:**
- Modify: `pets/hachiware/run/prompts/rows/*.md`
- Modify: `pets/hachiware/run/decoded/{idle,running-right,running-left,waving,jumping,failed,waiting,running,review}.png`
- Modify: `pets/hachiware/run/frames/*/*.png`
- Modify: `pets/hachiware/run/qa/rows/*/review.json`
- Modify: `pets/hachiware/run/qa/standard-visual-qa.md`

**Interfaces:**
- Consumes: the user-approved `references/canonical-base.png` and each state layout guide.
- Produces: nine validated standard row strips and extracted frame directories.

- [ ] **Step 1: Regenerate the eight non-mirrored state rows**

Generate `idle`, `running-right`, `waving`, `jumping`, `failed`, `waiting`, `running`, and `review` independently with `imagegen`, attaching the approved canonical base and matching layout guide to every job.

- [ ] **Step 2: Decide and produce `running-left`**

If `running-right` is visually safe to flip, run `${CODEX_HOME}/skills/hatch-pet/scripts/derive_running_left_from_running_right.py`; otherwise generate `running-left` independently with the approved base and layout guide.

- [ ] **Step 3: Extract and inspect every standard row**

For each strip, run `${CODEX_HOME}/skills/hatch-pet/scripts/extract_strip_frames.py` followed by `${CODEX_HOME}/skills/hatch-pet/scripts/inspect_frames.py`. Reject rows with cropped parts, forbidden effects, transparent body holes, missing large ring eyes, or lost pointed-tooth identity.

- [ ] **Step 4: Create and inspect standard motion QA**

Run `make_contact_sheet.py` and `render_animation_previews.py`; record an independent visual verdict in `qa/standard-visual-qa.md`.

### Task 3: Rebuild the 16 look directions

**Files:**
- Modify: `pets/hachiware/run/qa/look-mechanics.md`
- Modify: `pets/hachiware/run/decoded/look-cardinals.png`
- Modify: `pets/hachiware/run/decoded/look-anchors-approved.png`
- Modify: `pets/hachiware/run/decoded/look-row-9.png`
- Modify: `pets/hachiware/run/decoded/look-row-10.png`
- Modify: `pets/hachiware/run/qa/direction-semantics.json`
- Modify: `pets/hachiware/run/qa/direction-blind-validation.json`
- Modify: `pets/hachiware/run/qa/look-continuity.json`

**Interfaces:**
- Consumes: approved canonical base and all validated standard rows.
- Produces: approved cardinals plus two coherent eight-pose direction rows in fixed clockwise order.

- [ ] **Step 1: Define official-face-safe look mechanics**

Use eyebrows, ring-eye placement, mouth orientation, cheek alignment, and small head/body turns. Do not shrink the eyes or rotate the whole sprite to fake gaze.

- [ ] **Step 2: Generate and approve four cardinals**

Generate one strip ordered `000 up`, `090 screen-right`, `180 down`, `270 screen-left`; extract anchors with `extract_cardinal_anchors.py` and approve all four semantics before continuing.

- [ ] **Step 3: Generate and register look row 9**

Generate the coherent sequence `000, 022.5, 045, 067.5, 090, 112.5, 135, 157.5`, then run frame extraction, edge inspection, semantics review, and continuity measurement.

- [ ] **Step 4: Generate and register look row 10**

Generate the coherent sequence `180, 202.5, 225, 247.5, 270, 292.5, 315, 337.5` using the approved cardinals and completed row 9, then run the same checks.

- [ ] **Step 5: Run independent direction QA**

Create the focused direction sheet and randomized blind A/B sheet, combine three isolated reviewer verdicts, and require both cardinal pairs to pass with no labeled wrong-quadrant direction.

### Task 4: Assemble, package, validate, and install

**Files:**
- Modify: `pets/hachiware/run/final/spritesheet-extended.png`
- Modify: `pets/hachiware/run/final/spritesheet-extended.webp`
- Modify: `pets/hachiware/run/qa/*`
- Modify: `pets/hachiware/package/pet.json`
- Modify: `pets/hachiware/package/spritesheet.webp`
- Modify if provenance changes: `pets/hachiware/BUILD.md`, `pets/hachiware/build.json`, `catalog.json`, `README.md`

**Interfaces:**
- Consumes: nine validated standard rows and sixteen validated look directions.
- Produces: the final installable Hachiware v2 package and a matching installed pet.

- [ ] **Step 1: Assemble the extended atlas**

Run `assemble_extended_atlas.py` to produce the exact `1536x2288` pre-despill atlas and assembly manifest.

- [ ] **Step 2: Apply the single final chroma cleanup**

Run `despill_chroma_edges.py` exactly once on the current final atlas and require `qa/chroma-despill-extended.json` to report `ok: true` with alpha preserved.

- [ ] **Step 3: Validate visual and atlas invariants**

Run `validate_atlas.py --require-v2`, regenerate contact/direction sheets, and record final independent visual QA confirming official-style ring eyes across all used cells.

- [ ] **Step 4: Package and run repository verification**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package-pet.ps1 -PetId hachiware
powershell -NoProfile -ExecutionPolicy Bypass -File tests/validate-publication.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/cross-platform.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-pets.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/install-all.ps1
```

Require all commands to exit `0` and confirm the package directory contains only `pet.json` and `spritesheet.webp`.

- [ ] **Step 5: Install and hash-verify the approved package**

Set `$codexHome = Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex'`, run `scripts/install-pet.ps1 -PetId hachiware -CodexHome $codexHome`, then compare SHA-256 hashes for installed `pet.json` and `spritesheet.webp` against the package files.
