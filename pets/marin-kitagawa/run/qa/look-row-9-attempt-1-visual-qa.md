# Look row 9 attempt 1 visual QA

- Verdict: fail
- Severity: major
- Cardinal result: `000` up passed; `090` screen-right passed semantically.
- Continuity result: failed.
- Evidence: `067.5 -> 090` abruptly rotates the full silhouette into profile, changing the lower-body orientation, bangs, and piercing visibility. `090 -> 112.5` then snaps back near-front; `112.5` lacks a clear downward pitch. `157.5` has a clear downward cue but only a subtle rightward component.
- Required repair: resynthesize the complete coherent row. Use a three-quarter `090` pose family, keep feet and lower body front-anchored, interpolate head and eye yaw evenly through `112.5`, preserve continuous bangs and piercing occlusion, and strengthen the downward cue after `090`.

