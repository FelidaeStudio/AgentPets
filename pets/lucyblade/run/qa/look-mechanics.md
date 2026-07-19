# Lucyblade look mechanics

Lucyblade is a humanoid pixel-chibi character. Across all 16 clockwise look directions, keep her feet and lower body nearly fixed on the same baseline. Directional intent begins in the purple eyes and eyelids, then follows through the face, head, neck, and only a restrained upper-torso turn. Preserve the same head size, facial proportions, short silver-white bob, pale lilac tips, long asymmetric right-side bang, costume palette, and compact silhouette; do not broadly warp, rotate, mirror, or replace the whole character.

The blue lightsaber remains a single rigid physical prop held by the same hand in every direction. Its hilt stays visibly connected to that hand, with correct hand/body occlusion and only subtle natural lag from the upper-body turn. Do not add glow, blur, trails, duplicate blades, detached effects, shadows, labels, or guide marks.

Screen-space cardinal meanings are fixed:

- `000`: look straight up.
- `090`: look to screen-right.
- `180`: look straight down.
- `270`: look to screen-left.

Intermediate directions must progress evenly clockwise between these anchors. The transition from `337.5` back to `000` must be as small and continuous as every other adjacent step.
