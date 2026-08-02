# Hachiware Face Correction Design

## Goal

Repair the existing Hachiware v2 pet so its face reads much closer to the official character reference, with special attention to the eyes and pointed tooth. Preserve the validated animation structure and repository provenance.

## Source of truth

- Official reference: `https://www.chiikawaofficial.com/characters`
- The official Hachiware artwork on that page is the sole face-and-proportion reference.
- The previous generated canonical base and the three hand-drawn eye mockups are rejected as identity references.

## Locked visual traits

- Large round black eyes preserving both official white highlight shapes: the central white oval and lower white crescent; never tiny bean eyes.
- Short curved eyebrows, compact eye-to-mouth spacing, and pink cheek marks with short diagonal hatching.
- Low blue hachiware forehead marking with a clear central white wedge.
- Soft, slightly elongated bean body with tiny limbs, small tail, and cat-like ears.
- Cheerful open mouth with two small pointed white fangs and a pink tongue. Do not delete either tooth or close the mouth in the canonical happy expression.
- Simple hand-drawn black outline and flat colors; no glossy 3D rendering, plush texture, or invented eye style.

## Repair workflow

1. Save an official-reference-derived visual brief and generate one new canonical base image.
2. Present that single base image for visual approval before changing animation rows.
3. After approval, regenerate all identity-bearing standard rows from the approved base; mirror `running-left` only if the approved right-facing row remains safe to mirror.
4. Regenerate the cardinal anchors and both coherent look-direction rows using the approved base.
5. Reassemble the v2 atlas, run direction, continuity, chroma, visual, publication, and install QA, then repackage and reinstall.

## Acceptance criteria

- At normal pet size, the eyes are immediately larger and read as the official ring-eye construction.
- The face retains the official compact arrangement, cheeks, blue forehead split, and pointed-tooth smile.
- No row falls back to tiny black oval eyes or develops a different mascot identity.
- The package remains an 8x11 v2 atlas and passes all existing repository validation and temporary installation tests.
