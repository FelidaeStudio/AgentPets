# Marin Kitagawa build record

## Overview

- Build tool: Codex `hatch-pet` skill with the built-in `imagegen` path
- Pet id: `marin-kitagawa`
- Style: polished anime pixel-art chibi
- Sprite contract: v2, 8 columns × 11 rows
- Atlas: 1536 × 2288 RGBA WebP/PNG
- Cell: 192 × 208
- Canonical reference: `run/references/canonical-base.png`
- Package: `package/pet.json + package/spritesheet.webp`

## Character grounding

The base prompt was text-grounded from the user-supplied character pages:

- https://sono-bisque-doll-wa-koi-wo-suru.fandom.com/wiki/Marin_Kitagawa
- https://hero.fandom.com/wiki/Marin_Kitagawa

No site artwork was copied into the repository. The generated design uses a modest school-uniform silhouette, long light-blonde hair fading to soft pink, dark-pink eyes, a small black choker, and tiny silver ear piercings. The character was kept wholesome and nonsexualized.

## Standard animation rows

The run contains independently generated and validated strips for:

1. `idle`
2. `running-right`
3. `running-left`
4. `waving`
5. `jumping`
6. `failed`
7. `waiting`
8. `running`
9. `review`

`running-left` was generated normally instead of mirrored because Marin's side-swept bangs and asymmetric ear-piercing pattern would switch sides under a mirror transform. All nine rows passed incremental frame extraction and the combined standard visual review.

## V2 look directions

The four cardinal anchors were generated and approved in `000`, `090`, `180`, `270` order. The 16-direction loop uses eyes and eyelids first, restrained head/neck and shoulder follow-through, anchored feet and lower torso, and continuous hair-tip and piercing visibility. Whole-sprite rotation was prohibited.

The first `look-row-9` attempt was rejected because `090` turned the full silhouette into profile and `112.5` snapped back near-front. The rejected source, registered strip, registration metadata, and QA evidence are preserved under `run/decoded/rejected/` and `run/qa/`. The complete row was regenerated and passed independent semantic and continuity review.

The final blind review passed both hard cardinal pairs and all horizontal intermediate pairs. Four intermediate vertical cues remained ambiguous in isolation and were accepted as warnings after labeled loop review confirmed the intended quadrants without reversal.

## Deterministic and visual QA

- `run/qa/review.json`: pass, zero errors and zero warnings
- `run/qa/chroma-despill-extended.json`: pass; the single authorized edge-local despill preserved alpha
- `run/final/validation-extended.json`: pass; v2 RGBA WebP, 1536 × 2288, zero warnings
- `run/qa/direction-blind-validation.json`: pass; cardinal hard gates confirmed
- `run/qa/direction-semantics.json`: all 16 directions reviewed, no failures
- `run/qa/look-continuity.json`: pass with reviewed metric warnings at `157.5 -> 180` and `337.5 -> 000`; final visual review found no visible snap, scale pop, baseline jump, identity change, or reversal
- `run/qa/final-visual-qa.md`: pass

## Provenance and licensing

This repository preserves prompts, layout guides, canonical art, decoded strips, rejected repair evidence, extracted frames, atlases, previews, QA, manifests, and deterministic validation results from the active run.

No license grant applies to this build. Public visibility does not authorize
reuse of the character-derived artwork; see the repository
`FAN-CONTENT-NOTICE.md`.
