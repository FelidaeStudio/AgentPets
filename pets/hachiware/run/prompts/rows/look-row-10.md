Create one horizontal look-direction strip for Codex pet `hachiware`, atlas row 10.

Use the attached canonical base, completed standard contact sheet, layout guide, and approved four-cardinal strip for identity, scale, registration, spacing, direction semantics, and cross-row continuity. Read `qa/look-mechanics.md` and follow its pet-specific movement and eye/prop mechanics. The approved cardinal strip and completed coherent row 9 are authoritative. Use the cardinals for direction meaning and row 9 for cross-row identity, scale, registration, and continuity.

COHERENT SYNTHESIS LOCK: produce one unified eight-pose row. Do not paste, tile, or independently restyle individual cells. Every final cell must be drawn together with the same face construction, body proportions, line/render quality, lighting, materials, scale, baseline, and registration.

Output exactly 8 complete full-body frames in this exact left-to-right order: 180, 202.5, 225, 247.5, 270, 292.5, 315, 337.5. Degrees are clockwise: 000 is up, 090 right, 180 down, and 270 left. Neutral/front is not part of this row.

DIRECTION TARGETS — use these to shape the coherent row, not as pixel-level landmark gates:

1. `180`: vertical DOWN; no horizontal requirement.
2. `202.5`: horizontal SCREEN-LEFT and vertical DOWN.
3. `225`: horizontal SCREEN-LEFT and vertical DOWN.
4. `247.5`: horizontal SCREEN-LEFT and vertical DOWN.
5. `270`: horizontal SCREEN-LEFT; no vertical requirement.
6. `292.5`: horizontal SCREEN-LEFT and vertical UP.
7. `315`: horizontal SCREEN-LEFT and vertical UP.
8. `337.5`: horizontal SCREEN-LEFT and vertical UP.

Cardinals must be unmistakable. Intermediate poses should broadly occupy the intended quadrant and advance naturally through the ordered loop. Minor pupil, nose, eyelid, or aiming-feature deviations are acceptable when the overall direction, continuity, identity, and motion remain coherent. Do not deform the character merely to make every intermediate axis independently obvious.

SCREEN-COORDINATE LOCK: screen-left means the viewer's left image edge, never the character's own left. The row should travel naturally through the left half of the loop. Near-vertical 202.5 and 337.5 may have subtle horizontal cues; prioritize a coherent arc over exact pupil or nose placement.

HARD LAYOUT AND CONTINUITY CONTRACT — DETERMINISTIC REGISTRATION: draw exactly eight separated pose groups in left-to-right direction order. Keep enough chroma-only space between neighboring poses that each complete pose can be detected without cutting through foreground. Approximate the guide's equal spacing, but do not distort a pose merely to hit an exact source-canvas coordinate; deterministic assembly will crop the eight ordered groups, then apply one shared scale and baseline.

Use the same body height, head size, baseline, and planted-body position across the generated family. Never overlap neighboring poses, merge two poses into one connected group, crop foreground at the outer canvas edge, or resize one pose independently.

Keep the feet, base, or lower torso planted at the same coordinates across all eight frames. Express direction through the eyes, face, head, upper body, and physically appropriate prop movement, not by moving, rotating, or rescaling the entire sprite.

Place one centered pose in each invisible equal-width slot on flat pure user-selected #00FF00. Change only the natural parts needed to express gaze: eyes, eyelids, head, face, neck, upper body, appendages, and constrained prop follow-through. Keep identity, silhouette, materials, palette, markings, and props consistent.

ROW-BOUNDARY LOCK: 180 must continue directly from row 9's 157.5, matching its body size, baseline, planted anchor, expression, and construction. 337.5 must be one even 22.5-degree step before 000: nearly up-facing while remaining on the overall left-hand arc. Do not distort pupils, nose, or body geometry merely to exaggerate the subtle horizontal component.

PRE-RETURN CHECK: reject this result if it does not contain eight separated pose groups in the required order; neighboring poses overlap; foreground is cropped at the outer canvas edge; any frame changes sprite scale, body or head size, baseline, or planted-body position; the row visibly reverses into the wrong half of the loop; or 180 does not continue from 157.5 or 337.5 does not flow evenly into 000. Minor intermediate pupil or nose deviations are not rejection reasons. Exact cell cropping, resizing, and recentering happen deterministically after generation.

Do not rotate, skew, or tilt the whole sprite to fake gaze. Do not add replacement/googly eyes, labels, degree text, arrows, clocks, grids, shadows, glows, scenery, detached effects, or chroma-key colors inside the pet.

REPAIR EMPHASIS AFTER WORKER SELF-REJECTION: The previous row put the `270`
face on the viewer's RIGHT and was rejected before copying. For every cell from
`202.5` through `337.5`, place Hachiware's eye ovals, eyebrows, cheeks, mouth,
and paired fangs toward the VIEWER'S LEFT IMAGE EDGE. At `270`, all facial
landmarks must sit visibly LEFT of the round head center and match the FOURTH
pose in `look-anchors-approved.png`; never match the second pose. The blue
forehead part, cheek visibility, and body turn must reinforce the same
screen-left direction. Reject the row yourself if the face moves rightward.

BOUNDARY CONTINUITY REPAIR AFTER INDEPENDENT QA: Screen-left semantics now pass,
but the prior row visibly snapped from narrow `157.5` to broad `180`, and from
narrow `337.5` to broad `000`. Keep `180` unmistakably DOWN while preserving
nearly the same three-quarter silhouette width, body area, center, and visible
side as the completed `157.5`; only advance one 22.5-degree step. Across the
second half, widen the silhouette gradually. Make `337.5` a near-up, nearly
frontal pose with body width, area, center, blue marking visibility, and face
placement close to the repaired broad `000`, while retaining a subtle
screen-left cue. No single adjacent pair may make a large width or area jump.

STRATEGY CHANGE AFTER THE SAME BOUNDARY FAILURE RECURRED: Simplify the body
mechanics. Treat the lower body and bean-shaped outer silhouette as nearly
locked; let the large highlighted eyes, eyebrows, face surface, blue forehead
part, cheeks, mouth, and paired fangs carry most of the look direction. For `180`, copy the
completed `157.5` BODY SILHOUETTE, width, center, foot positions, and scale as
closely as possible, then advance only the facial aim to unmistakably DOWN.
Keep `202.5`, `225`, `247.5`, and `270` at nearly that same body width and area.
For `292.5`, keep the `270` body silhouette and move mainly the face upward;
do not suddenly widen the body. Widen only a small equal amount at `315` and
again at `337.5`, so the last pose approaches the broad `000` smoothly. The
generator must preserve this pose family as one continuous bean body rather
than switching between side-profile and frontal character models.

FINAL ARCHITECTURE LOCK: The newly approved cardinal strip uses one broad,
stable bean-body silhouette for every direction. Preserve that same body width,
area, center, feet, baseline, ears, and cap footprint in all eight cells. Do
not use narrow side-profile bodies at `180`, `270`, or any intermediate. Carry
the clockwise left-half arc through facial landmarks and tiny face-surface/cap
cues, with the outer body effectively locked from `157.5` through `000`.

FINAL SEAM REPAIR: The stable-body architecture fixed the earlier `157.5 ->
180` and `270 -> 292.5` pops, but independent QA still found `337.5` about 17%
narrower in area than `000`. Keep all accepted semantics. Make `315` begin a
small widening step, and make the `337.5` OUTER BODY SILHOUETTE, width, area,
center, foot spacing, baseline, ears, and blue-cap footprint practically the
same as the approved broad `000`. Only the face retains a subtle screen-left
cue. At normal pet size, toggling between `337.5` and `000` must look like one
tiny final gaze step, not a body-size change.
