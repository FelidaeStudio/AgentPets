# Tifa Lockhart build record

## Overview

- Build tool: Codex `hatch-pet` skill with the built-in `imagegen` path
- Pet id: `tifa-lockhart`
- Style: polished anime pixel-art chibi
- Sprite contract: v2, 8 columns × 11 rows
- Atlas: 1536 × 2288 RGBA WebP/PNG
- Cell: 192 × 208
- Canonical reference: `run/references/canonical-base.png`
- Package: `package/pet.json + package/spritesheet.webp`

## Character grounding

The generated character was text-grounded from:

- https://finalfantasy.fandom.com/wiki/Tifa_Lockhart
- https://www.square-enix-games.com/en_GB/news/final-fantasy-vii-rebirth-closer-look

No site artwork was copied into the repository. The generated design uses Tifa's very long dark hair with a split tail, warm red-brown eyes, white-and-black athletic top, black skirt and shorts, stockings, red-and-black boots, fingerless gloves, anatomical-left forearm guard, and sole left teardrop earring. The design is wholesome and nonsexualized.

## Standard animation rows

The run contains generated and validated strips for:

1. `idle`
2. `running-right`
3. `running-left`
4. `waving`
5. `jumping`
6. `failed`
7. `waiting`
8. `running`
9. `review`

`running-left` was generated normally because Tifa's left forearm guard and sole left earring make horizontal mirroring identity-unsafe. Its first accepted-by-structure attempt still read visually as a mirror, so the full row was regenerated. The rejected strip and QA finding remain under `run/decoded/rejected/` and `run/qa/`.

## V2 look directions

The initial four-cardinal strip had a wrong `090` anchor, and its initial `000` anchor was too ambiguous at normal pet size. Both individual anchors were regenerated through the hatch-pet cardinal-repair path, normalized deterministically, and recomposed into `run/decoded/look-anchors-approved.png`.

The first row-9 attempt rotated the character toward a rear view and failed the humanoid gaze mechanics. The complete coherent row was regenerated with a front-to-restrained-three-quarter presentation, then registered and approved before row 10 was generated. The final 16-direction loop uses eyes and eyelids first, restrained head/neck and shoulder follow-through, anchored feet and lower torso, continuous long-hair motion, and correct anatomical-left cues.

Blind review passed both hard cardinal pairs. Near-up intermediate directions produced reviewed ambiguity in isolated blind comparisons; labeled normal-size loop review confirmed the intended quadrants and continuous progression without reversal. Continuity metrics flagged `157.5 -> 180` and `337.5 -> 000` as local difference outliers, but independent visual review found no visible snap, scale pop, baseline jump, identity change, or broken attachment.

## Deterministic and visual QA

- `run/qa/review.json`: pass, zero errors and zero warnings
- `run/qa/standard-visual-qa.md`: pass
- `run/qa/cardinal-visual-qa.md`: pass after targeted cardinal repairs
- `run/qa/look-row-9-visual-qa.md`: pass after complete-row regeneration
- `run/qa/look-row-10-visual-qa.md`: pass
- `run/qa/chroma-despill-extended.json`: pass; the single authorized edge-local despill preserved alpha
- `run/final/validation-extended.json`: pass; v2 RGBA WebP, 1536 × 2288, zero warnings
- `run/qa/direction-blind-validation.json`: pass with reviewed intermediate warnings; all hard cardinal gates confirmed
- `run/qa/direction-semantics.json`: all 16 directions reviewed with no failures
- `run/qa/look-continuity.json`: pass with visually reviewed boundary warnings
- `run/qa/final-visual-qa.md`: pass with no blocking repairs

## Provenance and licensing

This repository preserves prompts, layout guides, canonical art, decoded strips, rejected attempts, extracted frames, atlases, previews, QA, manifests, and deterministic validation results from the active run.

No license grant applies to this build. Public visibility does not authorize
reuse of the character-derived artwork; see the repository
`FAN-CONTENT-NOTICE.md`.
