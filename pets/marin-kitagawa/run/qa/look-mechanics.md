# Marin Kitagawa look mechanics

Marin is a humanoid pixel-chibi with large expressive eyes, a distinct face, side-swept bangs, asymmetric ear piercings, long blonde hair with pink tips, and a stable school outfit. Looking around should read as attentive character acting, not as rotation of the whole sprite.

## Anchors and motion hierarchy

- Keep both feet, lower torso, body scale, and baseline fixed across the complete loop.
- The eyes lead each gaze change. Eyelids and eyebrows reshape subtly so the direction remains readable at normal pet size.
- The head and neck follow with a restrained yaw or pitch. Preserve skull shape, facial spacing, bangs, piercings, choker, hands, and outfit without broad raster warping.
- The shoulders and upper torso follow only slightly. Do not rotate, skew, or tilt the complete sprite.
- Hair remains attached and volume-stable. Front locks and pink tips lag the head by a small, continuous amount; they never jump, flip sides, or expose a new hairstyle.
- Ear piercings stay attached to their correct ears and preserve their asymmetric pattern as visibility changes.
- Marin holds no prop. Her hands remain relaxed and attached, with no new gesture or object.

## Cardinal pose families

- `000 up`: pupils and irises rise; upper eyelids open slightly; chin lifts; the face pitches upward while the torso and feet remain anchored. Slightly more underside of the bangs and chin is visible.
- `090 screen-right`: pupils and nose move to the image's right of the head center; the head yaws toward screen-right; more of Marin's screen-left cheek and hair volume is visible while the far ear and its piercings become partly occluded.
- `180 down`: pupils lower; upper eyelids soften; chin tucks; the face pitches down while the shoulders follow minimally. More bangs overlap the forehead and upper face.
- `270 screen-left`: pupils and nose move to the image's left of the head center; the head yaws toward screen-left; more of Marin's screen-right cheek and hair volume is visible while the opposite ear and piercings become partly occluded.

## Interpolation and motion budget

Each 22.5-degree step moves the pupils, eyelids, head angle, visible cheek/ear balance, and hair-tip follow-through by roughly one equal increment. Diagonals combine the adjacent vertical and horizontal cardinal families. The lower body does not slide. Head size, face proportions, hair volume, outfit silhouette, and baseline stay constant.

Row 9 progresses coherently through `000 -> 090 -> 180`. Row 10 begins one even step after `157.5`, progresses through `180 -> 270 -> 000`, and ends at `337.5` exactly one even step before the approved `000` pose. No adjacent pair may reverse, snap, flip the bangs or earrings, change scale, or return to a neutral/front-facing pose.

