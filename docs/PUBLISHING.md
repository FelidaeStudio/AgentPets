# Publishing AgentPets to GitHub

Publish only reviewed commits whose complete reachable history is free of
local filesystem paths, private email addresses, temporary artifacts, and
retired pet identifiers.

## 1. Confirm rights and visibility

Read [FAN-CONTENT-NOTICE.md](../FAN-CONTENT-NOTICE.md). This repository grants
no additional open-source or reuse license beyond the limited rights required
by GitHub's Terms of Service for public repositories and applicable law.
Confirm that making the selected content public is appropriate before creating
a public GitHub repository.

## 2. Validate the current snapshot

Run from the repository root.

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tests/validate-publication.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/cross-platform.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/validate-pets.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File tests/install-all.ps1
```

PowerShell 7 on Windows, Linux, or macOS:

```powershell
pwsh -NoProfile -File tests/validate-publication.ps1
pwsh -NoProfile -File tests/cross-platform.ps1
pwsh -NoProfile -File scripts/validate-pets.ps1
pwsh -NoProfile -File tests/install-all.ps1
```

All four commands must succeed. Also verify that `git diff --check` reports no
errors and that `scripts/validate-publication.ps1` passes for the repository
root.

## 3. Use reviewed Git history

1. Configure the author name and exact GitHub noreply email associated with
   the publishing account.
2. Keep commits logically separated so the repository history explains when
   each pet and publication safeguard was added.
3. Stage the intended changes and review `git status --short`.
4. Run all validation commands against the exact committed tree.
5. Inspect the full reachable history for private identifiers before pushing.
6. Push normally. Rewrite published history only when removal of incorrect or
   sensitive historical content is explicitly required.

Example identity configuration:

```powershell
git config user.name "<github-user-name>"
git config user.email "<github-noreply-email>"
```

Never substitute a personal email unless publishing it is intentional.

## 4. Verify the committed archive

Before pushing, export or inspect the exact committed tree and confirm:

- no `.git/`, `.install-test/`, test fixture, or local temporary directory is
  included;
- no concrete Windows, Linux, macOS, WSL, Downloads, Codex storage, or local
  workspace path is present;
- no private key, access token, API key, or non-example email is present;
- every `package/` contains only `pet.json` and `spritesheet.webp`;
- no file is 50 MiB or larger;
- `catalog.json`, every `build.json`, and every package manifest agree on ids
  and paths.

## 5. Push and inspect GitHub Actions

After pushing the clean history, wait for the `Validate repository` workflow
to pass on Windows, Ubuntu, and macOS. A failed job means the snapshot is not
ready for release; fix the reported issue in the clean repository and rerun
all local validation before pushing again.
