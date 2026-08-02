# Rejected generation attempts

## failed — attempt 1

Rejected during independent visual QA. The strip contained eight complete,
Hachiware-consistent poses, but frame 7 added a detached white puff effect.
The source is preserved at
`run/decoded/rejected/failed-attempt-1.png`; it is not packaging-eligible.

## failed — attempt 2

Passed per-row structural checks but was rejected in the combined visual
review. Frames 3, 6, and especially 7 changed pose and apparent scale too
abruptly for a coherent loop. Preserved at
`run/decoded/rejected/failed-attempt-2.png`.

## running — attempt 1

Rejected during independent visual QA. The strip contained six complete poses,
but introduced task-work props that are not part of Hachiware's base identity.
The `running` state means an active task-processing loop here, not literal
locomotion. The source is preserved at
`run/decoded/rejected/running-attempt-1.png`; it is not packaging-eligible.

## running — attempt 2

Passed per-row structural checks but was rejected in the combined visual
review because the six poses read too close to idle and did not clearly convey
active task processing. Preserved at
`run/decoded/rejected/running-attempt-2.png`.

## jumping — attempt 1

Passed per-row structural checks but was rejected in the combined visual
review because the five poses did not show enough vertical displacement for a
readable jump arc. Preserved at
`run/decoded/rejected/jumping-attempt-1.png`.

## look-cardinals — attempt 1

Rejected during independent visual QA. The up/down cues were readable, but the
screen-right and screen-left anchors changed to near-profile head silhouettes
instead of restrained three-quarter facial cues. Preserved at
`run/decoded/rejected/look-cardinals-attempt-1.png`.

## Additional unselected generation outputs

- `running-right-attempt-1.png`: rejected because the gait remained mostly
  front-facing instead of unmistakably traveling screen-right.
- `idle-unselected-alternate.png`: valid-looking alternate output not selected
  as the canonical idle strip.
- `failed-unselected-tears.png`: unselected alternate with detached tear marks,
  prohibited by the clean-extraction contract.

## Cute rework: running duplicate

Rejected before deterministic extraction because the worker returned the exact
same generated source path as the accepted `review` row. A single strip cannot
serve both app states, and the visible action description also failed to prove
that `running` was distinct from review. No duplicate was copied into the
packaging-eligible `decoded/running.png` path.
