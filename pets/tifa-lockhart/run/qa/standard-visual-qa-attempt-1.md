# Standard visual QA — attempt 1

- Verdict: fail
- Reviewer: independent hatch-pet visual worker
- Rows reviewed: idle, running-right, running-left, waving, jumping, failed, waiting, running, review
- Finding: `running-left` visually reads as a direct horizontal mirror of `running-right`, moving the anatomical-left forearm guard and single left earring to the wrong anatomical side.
- Other rows: identity, state semantics, scale, baseline, hair continuity, cropping, overlap, guide pixels, shadows, and detached effects passed.
- Required repair: regenerate the complete `running-left` row as a grounded row. Do not mirror it.
