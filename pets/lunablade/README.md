# Lunablade

An animated Codex Pet with white hair, black armor, and a blue energy blade.

![Lunablade animation contact sheet](run/qa/contact-sheet.png)

## Installation

The installable files are in [`package/`](package/):

```text
package/
├── pet.json
└── spritesheet.webp
```

Run from the repository root:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId lunablade
```

Then select **Settings > Pets > Refresh > Lunablade** in Codex and enter
`/pet`.

## Build record

The complete available build artifacts are preserved in [`run/`](run/):

- `prompts/`: base-character, animation-row, direction-repair, and retry prompts.
- `references/`: the canonical base and atlas layout references.
- `decoded/`: generated and decoded base art and animation rows.
- `frames/`: animation frames separated by state.
- `final/`: standard and extended atlases with validation results.
- `qa/`: contact sheets, motion GIFs, direction checks, and frame inspection results.

See [BUILD.md](BUILD.md) for detailed build notes, known missing history, and
later validation. Machine-readable metadata is in [build.json](build.json).
The rebuilt v2 edition is preserved separately as [`../lucyblade/`](../lucyblade/).

Before public use, read the repository's
[FAN-CONTENT-NOTICE.md](../../FAN-CONTENT-NOTICE.md).
