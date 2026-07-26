# Tifa Lockhart look mechanics

Tifa is a humanoid pixel-chibi with large expressive eyes, long very dark hair ending in a dolphin-tail split, a white-and-black combat top, dark skirt and shorts, red-and-black boots, fingerless gloves, an anatomical-left forearm guard, and one anatomical-left teardrop earring. Looking around should read as alert, warm character acting rather than rotation of the complete sprite.

## Anchors and motion hierarchy

- Keep both feet, lower torso, body scale, and baseline fixed across the complete loop.
- The eyes lead every gaze change. Eyelids and eyebrows follow subtly so the direction remains readable at normal pet size.
- The head and neck follow with a restrained yaw or pitch. Preserve skull shape, facial spacing, hairline, clothing, gloves, and boots without broad raster warping.
- The shoulders and upper torso follow only slightly. Never rotate, skew, or tilt the complete sprite.
- Her long hair remains attached and volume-stable. The lower lengths and dolphin-tail tips lag the head by a small, continuous amount; they never jump, flip sides, detach, or become a different hairstyle.
- The forearm guard and teardrop earring remain on Tifa's anatomical left. They may be partly occluded by a turn, but must never migrate to the opposite side.
- Tifa holds no prop. Her hands remain relaxed and attached, with no combat strike, weapon, new gesture, or object.

## Cardinal pose families

- `000 up`: pupils and irises rise; upper eyelids open slightly; chin lifts; the face pitches upward while torso and feet stay anchored. Slightly more underside of the bangs and chin becomes visible.
- `090 screen-right`: pupils and nose move toward the image's right; the head yaws toward screen-right; the visible cheek, ear, hair volume, left earring, and left guard change only according to anatomical occlusion.
- `180 down`: pupils lower; upper eyelids soften; chin tucks; the face pitches down while shoulders follow minimally. Bangs overlap slightly more of the forehead and upper face.
- `270 screen-left`: pupils and nose move toward the image's left; the head yaws toward screen-left; the opposite cheek and ear visibility changes naturally while the anatomical-left cues remain correctly attached.

## Interpolation and motion budget

Each 22.5-degree step moves the pupils, eyelids, head angle, visible cheek and ear balance, and hair-tip follow-through by roughly one equal increment. Diagonals combine the adjacent vertical and horizontal cardinal families. The lower body does not slide. Head size, face proportions, hair volume, outfit silhouette, asymmetric cues, and baseline remain constant.

Row 9 progresses coherently through `000 -> 090 -> 180`. Row 10 begins one even step after `157.5`, progresses through `180 -> 270 -> 000`, and ends at `337.5` exactly one even step before the approved `000` pose. No adjacent pair may reverse, snap, flip the earring or forearm guard, change scale, or return to a neutral/front-facing pose.
