# AgentPets repository guidance

This repository preserves both reproducible build evidence and installable
packages for multiple Codex/ChatGPT pets.

When adding or changing a pet:

1. Use a lowercase, URL-safe id for `pets/<id>/`. IDs may contain single `-`
   or `_` separators and must match `^[a-z0-9]+(?:[-_][a-z0-9]+)*$`.
2. Preserve the hatch-pet working output under `pets/<id>/run/`. Keep prompts,
   references, decoded strips, frames, final atlases, QA, and manifests.
3. Put only `pet.json` and `spritesheet.webp` under `pets/<id>/package/`.
4. Add `BUILD.md` for human-readable provenance and `build.json` for repository
   automation.
5. Never fabricate missing historical manifests. Record missing history and
   distinguish later deterministic validation from the original run.
6. Generate the package with
   `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package-pet.ps1 -PetId <id>`.
7. Add or update the entry in `catalog.json` and the root README table.
8. Validate with
   `powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-pets.ps1`.
9. Test installation with `scripts/install-pet.ps1` using a temporary
   `-CodexHome` before declaring the work done.
10. Keep repository artifacts publication-safe. Use repository-relative paths
    in manifests and QA output; replace private generation or import locations
    with privacy-safe provenance such as `generated-images/...` or
    `local-imports/...`. Never commit a concrete user-home or local workspace
    path.
11. Keep Windows PowerShell 5.1 and PowerShell 7 compatibility. Do not depend
    on `USERPROFILE`, a hard-coded `powershell` executable, `System.Drawing`,
    or Windows-only path separators.
12. Run `tests/validate-publication.ps1`, `tests/cross-platform.ps1`,
    `scripts/validate-pets.ps1`, and `tests/install-all.ps1` before publication.

`catalog.json` and `build.json` are repository metadata, not official Codex
manifests. `package/pet.json` is the hatch-pet installation manifest. This
repository intentionally has no `LICENSE`; follow `FAN-CONTENT-NOTICE.md` and
do not imply that public visibility grants reuse rights.
