# AgentPets

A multi-pet repository for preserving, reviewing, installing, and sharing
custom Codex Pets.

The repository keeps both:

- `run/`: reproducible hatch-pet build evidence, including prompts,
  references, extracted frames, final atlases, QA, and validation results.
- `package/`: the directly installable `pet.json + spritesheet.webp` pair.

> This repository does not include a license or grant reuse rights for its
> code or artwork. Character-related content is unofficial fan work. Read
> [FAN-CONTENT-NOTICE.md](FAN-CONTENT-NOTICE.md) before publishing or using it.

## Pets

| Pet | ID | Contract | Build record | Package |
| --- | --- | --- | --- | --- |
| [Lunablade](pets/lunablade/README.md) | `lunablade` | v1 | [BUILD.md](pets/lunablade/BUILD.md) | [`package/`](pets/lunablade/package/) |
| [Lucyblade](pets/lucyblade/README.md) | `lucyblade` | v2 | [BUILD.md](pets/lucyblade/BUILD.md) | [`package/`](pets/lucyblade/package/) |
| [Lucyna Kushinada](pets/lucyna_kushinada/README.md) | `lucyna_kushinada` | v1 | [BUILD.md](pets/lucyna_kushinada/BUILD.md) | [`package/`](pets/lucyna_kushinada/package/) |
| [Marin Kitagawa](pets/marin-kitagawa/README.md) | `marin-kitagawa` | v2 | [BUILD.md](pets/marin-kitagawa/BUILD.md) | [`package/`](pets/marin-kitagawa/package/) |
| [Tifa Lockhart](pets/tifa-lockhart/README.md) | `tifa-lockhart` | v2 | [BUILD.md](pets/tifa-lockhart/BUILD.md) | [`package/`](pets/tifa-lockhart/package/) |
| [Hachiware](pets/hachiware/README.md) | `hachiware` | v2 | [BUILD.md](pets/hachiware/BUILD.md) | [`package/`](pets/hachiware/package/) |

## Preview

Each card shows one representative idle frame rather than a complete
spritesheet or contact sheet.

<table>
  <tr>
    <td align="center"><a href="pets/lunablade/README.md"><strong>Lunablade</strong></a><br><img src="pets/lunablade/run/frames/idle/00.png" width="180" alt="Lunablade representative idle frame"></td>
    <td align="center"><a href="pets/lucyblade/README.md"><strong>Lucyblade</strong></a><br><img src="pets/lucyblade/run/qa/frames/idle/00.png" width="180" alt="Lucyblade representative idle frame"></td>
    <td align="center"><a href="pets/lucyna_kushinada/README.md"><strong>Lucyna Kushinada</strong></a><br><img src="pets/lucyna_kushinada/run/qa/representative-frame.png" width="180" alt="Lucyna Kushinada representative idle frame"></td>
  </tr>
  <tr>
    <td align="center"><a href="pets/marin-kitagawa/README.md"><strong>Marin Kitagawa</strong></a><br><img src="pets/marin-kitagawa/run/frames/idle/00.png" width="180" alt="Marin Kitagawa representative idle frame"></td>
    <td align="center"><a href="pets/tifa-lockhart/README.md"><strong>Tifa Lockhart</strong></a><br><img src="pets/tifa-lockhart/run/frames/idle/00.png" width="180" alt="Tifa Lockhart representative idle frame"></td>
    <td align="center"><a href="pets/hachiware/README.md"><strong>Hachiware</strong></a><br><img src="pets/hachiware/run/frames/idle/00.png" width="180" alt="Hachiware representative idle frame"></td>
  </tr>
</table>

## Installation

Replace `<pet-id>` with an ID from the table above.

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId <pet-id>
```

PowerShell 7 on Windows, Linux, or macOS:

```powershell
pwsh -NoProfile -File scripts/install-pet.ps1 -PetId <pet-id>
```

If a pet with the same ID already exists, explicitly allow replacement:

```powershell
pwsh -NoProfile -File scripts/install-pet.ps1 -PetId <pet-id> -Force
```

The installer resolves the Codex home directory in this order:

1. The `-CodexHome` argument.
2. The `CODEX_HOME` environment variable.
3. `.codex` under the current platform's user directory.

Default installation locations:

- Windows: `%USERPROFILE%\.codex\pets\<pet-id>\`
- Linux: `$HOME/.codex/pets/<pet-id>/`
- macOS: `$HOME/.codex/pets/<pet-id>/`

The destination directory contains only:

```text
pet.json
spritesheet.webp
```

After installation, open **Settings > Pets > Refresh** in Codex, select the
pet, and enter `/pet`.

## Repository layout

```text
AgentPets/
├── .github/workflows/validate.yml
├── AGENTS.md
├── FAN-CONTENT-NOTICE.md
├── catalog.json
├── docs/
│   ├── ADDING_A_PET.md
│   └── PUBLISHING.md
├── scripts/
│   ├── install-pet.ps1
│   ├── package-pet.ps1
│   ├── validate-pets.ps1
│   └── validate-publication.ps1
├── tests/
│   ├── cross-platform.ps1
│   ├── install-all.ps1
│   └── validate-publication.ps1
└── pets/<pet-id>/
    ├── README.md
    ├── BUILD.md
    ├── build.json
    ├── package/
    │   ├── pet.json
    │   └── spritesheet.webp
    └── run/
```

## Rebuild an installation package

```powershell
pwsh -NoProfile -File scripts/package-pet.ps1 -PetId <pet-id>
```

The script deterministically builds `package/` from the final WebP referenced
by `build.json`. A v2 pet manifest must include `spriteVersionNumber: 2`.

## Validation

```powershell
pwsh -NoProfile -File tests/validate-publication.ps1
pwsh -NoProfile -File tests/cross-platform.ps1
pwsh -NoProfile -File scripts/validate-pets.ps1
pwsh -NoProfile -File tests/install-all.ps1
```

Validation covers:

- consistency between the catalog, build metadata, and package manifests;
- v1/v2 atlas dimensions, PNG alpha mode, WebP hashes, and the 20 MiB package
  limit;
- hatch-pet validation and QA results;
- private Windows, Linux, macOS, WSL, and local file URI paths;
- non-example email addresses, common local Codex storage locations;
- underscore and hyphen pet IDs, `CODEX_HOME`, and temporary installation.

GitHub Actions runs the same checks on Windows, Ubuntu, and macOS.

## Adding and publishing pets

- Add a pet: [docs/ADDING_A_PET.md](docs/ADDING_A_PET.md)
- Publish to GitHub: [docs/PUBLISHING.md](docs/PUBLISHING.md)

Before publishing, validate the complete commit history being pushed. It must
not contain local absolute paths, private email addresses, temporary
directories, or retired pet IDs. Commit authors should use a GitHub-associated
noreply email address.

## Historical integrity

Never fabricate missing historical manifests for an older pet. Record missing
files in the pet's `BUILD.md` and `build.json`, and clearly identify any later
validation as a subsequent deterministic check rather than part of the
original run.
