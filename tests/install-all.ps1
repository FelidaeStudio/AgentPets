[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$fixtureRoot = Join-Path $PSScriptRoot ".install-all-fixture"
$resolvedFixture = [IO.Path]::GetFullPath($fixtureRoot)
$resolvedTests = [IO.Path]::GetFullPath($PSScriptRoot) +
    [IO.Path]::DirectorySeparatorChar

if (-not $resolvedFixture.StartsWith(
        $resolvedTests,
        [StringComparison]::OrdinalIgnoreCase
    )) {
    throw "Unsafe fixture path: $resolvedFixture"
}

try {
    New-Item -ItemType Directory -Force -Path $resolvedFixture | Out-Null
    $catalog = Get-Content `
        -Raw `
        -Encoding UTF8 `
        -LiteralPath (Join-Path $repositoryRoot "catalog.json") |
        ConvertFrom-Json

    foreach ($pet in $catalog.pets) {
        & (Join-Path $repositoryRoot "scripts/install-pet.ps1") `
            -PetId $pet.id `
            -CodexHome $resolvedFixture `
            -RepositoryRoot $repositoryRoot

        $installedDir = Join-Path (Join-Path $resolvedFixture "pets") $pet.id
        $installedNames = @(
            (Get-ChildItem -LiteralPath $installedDir -File).Name | Sort-Object
        )
        if (($installedNames -join ",") -ne "pet.json,spritesheet.webp") {
            throw "Unexpected installed files for $($pet.id): $($installedNames -join ', ')"
        }

        $source = Join-Path `
            (Join-Path `
                (Join-Path (Join-Path $repositoryRoot "pets") $pet.id) `
                "package") `
            "spritesheet.webp"
        $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $source).Hash
        $installedHash = (
            Get-FileHash `
                -Algorithm SHA256 `
                -LiteralPath (Join-Path $installedDir "spritesheet.webp")
        ).Hash
        if ($sourceHash -ne $installedHash) {
            throw "Installed spritesheet hash mismatch for $($pet.id)"
        }
    }

    Write-Host "Temporary installation passed for $($catalog.pets.Count) pet(s)."
}
finally {
    if (Test-Path -LiteralPath $resolvedFixture) {
        $check = [IO.Path]::GetFullPath($resolvedFixture)
        if (-not $check.StartsWith(
                $resolvedTests,
                [StringComparison]::OrdinalIgnoreCase
            ) -or [IO.Path]::GetFileName($check) -ne ".install-all-fixture") {
            throw "Refusing to clean unsafe fixture path: $check"
        }
        Remove-Item -LiteralPath $check -Recurse -Force
    }
}
