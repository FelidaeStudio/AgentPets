# Hachiware build record

## Overview

- Build tool: Codex `hatch-pet` skill with the built-in `imagegen` path
- Pet id: `hachiware`
- Style: minimal hand-drawn kawaii sticker
- Sprite contract: v2, 8 columns × 11 rows
- Atlas: 1536 × 2288 RGBA WebP/PNG
- Cell: 192 × 208
- Canonical reference: `run/references/canonical-base.png`
- Package: `package/pet.json + package/spritesheet.webp`

## Character grounding

The design was visually grounded from:

- https://chiikawa.fandom.com/wiki/Hachiware
- https://www.chiikawaofficial.com/characters

The official character page was retained as a build reference. The revised
generated identity uses a short round white bean silhouette, a soft blue
hachiware forehead marking and tail, large round black eyes with a central oval
and lower crescent highlight, pink cheeks with four hatch marks, stubby limbs,
and exactly two small triangular pointed fangs around a pink tongue whenever
the mouth is open. Personality cues emphasize optimism, helpfulness, and
friendly curiosity.

## Standard animation rows

The run contains generated and validated strips for `idle`, `running-right`,
`waving`, `jumping`, `failed`, `waiting`, `running`, and `review`.
`running-left` was deterministically mirrored from the approved rightward gait
after independent review confirmed no fixed left/right identity marking.

Combined visual QA initially rejected three otherwise structurally valid rows:
`jumping` lacked a readable vertical arc, `failed` changed pose and scale too
abruptly, and `running` looked too close to idle. All three were regenerated.
The accepted jump uses stable-slot extraction to preserve its vertical motion.
Rejected attempts and reasons remain under `run/decoded/rejected/` and
`run/qa/rejections.md`.

## V2 look directions

Four cardinal anchors established up, right, down, and left. The two coherent
eight-pose rows use facial placement, profile visibility, cheeks, forehead
marking, and tail placement to complete the 16-direction clockwise loop while
preserving the large highlighted eyes and paired fangs wherever the face is
visible.

Deterministic registration confirmed both hard cardinal gates. Labeled loop
review confirmed the intended quadrants and no reversal. Continuity warnings
at `180 -> 202.5`, `247.5 -> 270`, and `337.5 -> 000` were visually reviewed as
intentional changes between front, profile, and raised-face views rather than
clipping or loop reversal.

## Deterministic and visual QA

- `run/qa/review.json`: standard-row structural pass
- `run/qa/standard-visual-qa.md`: repaired standard rows pass
- `run/qa/despill.json`: single authorized edge-local despill;
  alpha preserved
- `run/final/validation.json`: v2 RGBA PNG pass, zero warnings
- `run/qa/direction-blind-validation.json`: hard cardinal gates pass
- `run/qa/direction-semantics.json`: reviewed clockwise semantics pass
- `run/qa/look-continuity.json`: metric warnings reviewed
- `run/qa/final-visual-qa.md`: final independent visual pass

## Provenance

The active run preserves prompts, layout guides, canonical art, decoded
strips, rejected attempts, extracted frames, atlases, previews, QA, manifests,
and validation results. Machine-generated paths were converted to
repository-relative paths before publication.
