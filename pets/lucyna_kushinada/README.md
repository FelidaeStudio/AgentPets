# Lucyna Kushinada

A Lucyna Kushinada-inspired cyberpunk Codex Pet imported from the
user-provided `lucy-codex-pet.zip` archive.

![Lucyna Kushinada animation contact sheet](run/qa/contact-sheet.png)

## Installation

Run from the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId lucyna_kushinada
```

Then select **Settings > Pets > Refresh > Lucyna Kushinada** in Codex and
enter `/pet`.

## Artifacts and history

- `package/`: the directly installable `pet.json + spritesheet.webp` pair.
- `run/source/`: the original ZIP and its original `pet.json` and PNG atlas.
- `run/final/`: deterministically normalized PNG/WebP files and later validation results.
- `run/qa/contact-sheet.png`: the subsequently generated visual QA sheet.

This import contains only final artifacts. Original prompts, references, row
strips, frames, and generation manifests were unavailable and have not been
fabricated. See [BUILD.md](BUILD.md) for details.

Before public use, read the repository's
[FAN-CONTENT-NOTICE.md](../../FAN-CONTENT-NOTICE.md).
