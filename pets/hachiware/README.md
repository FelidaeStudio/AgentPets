# Hachiware

This version is visually grounded in the official character page. It preserves
Hachiware's rounded blue-and-white body, large black eyes with two highlights
in each eye, pink cheeks, pink tongue, and two cute pointed fangs.

![Hachiware animation contact sheet](run/qa/contact-sheet.png)

Hachiware is a Codex Pet using an 8 × 11 v2 spritesheet. It includes idle,
left- and right-facing movement, waving, jumping, failed, waiting, running, and
review animations, plus 16 look directions. The repository installation
scripts support Windows, Linux, and macOS.

Files:

- [package/](package/) — installable pet package
- [run/qa/contact-sheet.png](run/qa/contact-sheet.png) — complete animation QA sheet
- [BUILD.md](BUILD.md) — build provenance and validation record

Install from the repository root:

```powershell
pwsh -NoProfile -File scripts/install-pet.ps1 -PetId hachiware
```

Windows PowerShell 5.1:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId hachiware
```
