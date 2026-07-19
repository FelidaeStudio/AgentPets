[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9]+(?:[-_][a-z0-9]+)*$')]
    [string]$PetId,

    [string]$CodexHome,

    [string]$RepositoryRoot,

    [switch]$Force
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
}
if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $CodexHome = $env:CODEX_HOME
    }
    else {
        $userProfile = [Environment]::GetFolderPath(
            [Environment+SpecialFolder]::UserProfile
        )
        if ([string]::IsNullOrWhiteSpace($userProfile)) {
            throw "Could not resolve the user profile. Pass -CodexHome or set CODEX_HOME."
        }
        $CodexHome = Join-Path $userProfile ".codex"
    }
}

$packageDir = Join-Path (Join-Path (Join-Path $RepositoryRoot "pets") $PetId) "package"
$manifestPath = Join-Path $packageDir "pet.json"
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Missing package manifest: $manifestPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($manifest.id -ne $PetId) {
    throw "Package id '$($manifest.id)' does not match '$PetId'"
}
if ($manifest.spritesheetPath -ne "spritesheet.webp") {
    throw "Unsupported spritesheetPath: '$($manifest.spritesheetPath)'"
}

$sourceWebp = Join-Path $packageDir $manifest.spritesheetPath
if (-not (Test-Path -LiteralPath $sourceWebp -PathType Leaf)) {
    throw "Missing package spritesheet: $sourceWebp"
}

$targetDir = Join-Path (Join-Path $CodexHome "pets") $PetId
if ((Test-Path -LiteralPath $targetDir) -and -not $Force) {
    throw "Pet already exists at $targetDir. Re-run with -Force to overwrite its package files."
}

New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
Copy-Item -LiteralPath $manifestPath -Destination (Join-Path $targetDir "pet.json") -Force
Copy-Item -LiteralPath $sourceWebp -Destination (Join-Path $targetDir "spritesheet.webp") -Force

Write-Host "Installed $PetId to $targetDir"
Write-Host "In Codex, open Settings > Pets, choose Refresh, then select $($manifest.displayName)."
