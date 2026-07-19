# Full direction-loop visual QA

Verdict: **PASS after row-10 retries**

Several complete row-10 candidates were rejected and retained under `generated/rejected/`: two confused screen-left with screen-right, one preserved leftward semantics but failed to return toward the frontal `000` pose, and one had correct directions but insufficient cell-edge clearance. The approved row was regenerated as a complete coherent strip from a non-packaging direction guide.

- All 16 directions progress clockwise in screen coordinates.
- `202.5, 225, 247.5` move monotonically down-left; `270` is screen-left; `292.5, 315, 337.5` progressively return through up-left to near-frontal up.
- The visually reviewed `337.5 → 000` loop closure is now a small, acceptable change despite the conservative pixel-difference warning.
- Lucy identity, foot baseline, scale, and exactly one same-hand-attached blue lightsaber remain stable.
