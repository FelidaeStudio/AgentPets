[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$fixtureRoot = Join-Path $PSScriptRoot ".cross-platform-fixture"
$codexHome = Join-Path $fixtureRoot "codex-home"
$petId = "lucyna_kushinada"
$petRoot = Join-Path (Join-Path $fixtureRoot "pets") $petId
$runFinal = Join-Path (Join-Path $petRoot "run") "final"
$packageDir = Join-Path $petRoot "package"
$fixtureScripts = Join-Path $fixtureRoot "scripts"
$utf8 = [Text.UTF8Encoding]::new($false)

$resolvedFixture = [IO.Path]::GetFullPath($fixtureRoot)
$resolvedTests = [IO.Path]::GetFullPath($PSScriptRoot) +
    [IO.Path]::DirectorySeparatorChar
if (-not $resolvedFixture.StartsWith(
        $resolvedTests,
        [StringComparison]::OrdinalIgnoreCase
    )) {
    throw "Unsafe fixture path: $resolvedFixture"
}

$sourcePng = Join-Path $repositoryRoot "pets/lunablade/run/final/spritesheet.png"
$sourceWebp = Join-Path $repositoryRoot "pets/lunablade/run/final/spritesheet.webp"
foreach ($source in @($sourcePng, $sourceWebp)) {
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Required fixture source is missing: $source"
    }
}

try {
    New-Item -ItemType Directory -Force `
        -Path $runFinal, $packageDir, $fixtureScripts | Out-Null
    Copy-Item -LiteralPath $sourcePng -Destination (Join-Path $runFinal "spritesheet.png")
    Copy-Item -LiteralPath $sourceWebp -Destination (Join-Path $runFinal "spritesheet.webp")
    Copy-Item `
        -LiteralPath (Join-Path $repositoryRoot "scripts/validate-publication.ps1") `
        -Destination (Join-Path $fixtureScripts "validate-publication.ps1")
    [IO.File]::WriteAllText(
        (Join-Path $runFinal "validation.json"),
        '{"ok":true}',
        $utf8
    )

    $catalog = @{
        repositoryFormatVersion = 2
        pets = @(
            @{
                id = $petId
                name = "Lucyna Kushinada"
                description = "Fixture pet"
                build = "pets/$petId/build.json"
                run = "pets/$petId/run"
                package = "pets/$petId/package"
                preview = "pets/$petId/run/final/spritesheet.png"
            }
        )
    } | ConvertTo-Json -Depth 8
    [IO.File]::WriteAllText((Join-Path $fixtureRoot "catalog.json"), $catalog, $utf8)

    $build = @{
        schemaVersion = 1
        id = $petId
        displayName = "Lucyna Kushinada"
        description = "Fixture pet"
        provenance = @{ resultsOnly = $true }
        paths = @{
            sourceAtlasPng = "run/final/spritesheet.png"
            sourceAtlasWebp = "run/final/spritesheet.webp"
            validation = "run/final/validation.json"
            package = "package"
        }
        atlas = @{
            width = 1536
            height = 1872
            cellWidth = 192
            cellHeight = 208
            spriteVersionNumber = 1
        }
    } | ConvertTo-Json -Depth 8
    [IO.File]::WriteAllText((Join-Path $petRoot "build.json"), $build, $utf8)

    & (Join-Path $repositoryRoot "scripts/package-pet.ps1") `
        -PetId $petId `
        -RepositoryRoot $resolvedFixture

    $priorCodexHome = $env:CODEX_HOME
    $priorUserProfile = $env:USERPROFILE
    try {
        $env:CODEX_HOME = $codexHome
        $env:USERPROFILE = $null
        & (Join-Path $repositoryRoot "scripts/install-pet.ps1") `
            -PetId $petId `
            -RepositoryRoot $resolvedFixture
    }
    finally {
        $env:CODEX_HOME = $priorCodexHome
        $env:USERPROFILE = $priorUserProfile
    }

    $installedDir = Join-Path (Join-Path $codexHome "pets") $petId
    $installedNames = @(
        (Get-ChildItem -LiteralPath $installedDir -File).Name | Sort-Object
    )
    if (($installedNames -join ",") -ne "pet.json,spritesheet.webp") {
        throw "Unexpected installed files: $($installedNames -join ', ')"
    }

    function powershell {
        throw "Repository validation attempted to launch a hard-coded powershell executable."
    }
    try {
        & (Join-Path $repositoryRoot "scripts/validate-pets.ps1") `
            -RepositoryRoot $resolvedFixture
    }
    catch {
        throw "Repository validator rejected the cross-platform fixture: $($_.Exception.Message)"
    }
    finally {
        Remove-Item -LiteralPath "function:\powershell" -ErrorAction SilentlyContinue
    }

    Write-Host "Cross-platform packaging and installation tests passed."
}
finally {
    if (Test-Path -LiteralPath $resolvedFixture) {
        $check = [IO.Path]::GetFullPath($resolvedFixture)
        if (-not $check.StartsWith(
                $resolvedTests,
                [StringComparison]::OrdinalIgnoreCase
            ) -or [IO.Path]::GetFileName($check) -ne ".cross-platform-fixture") {
            throw "Refusing to clean unsafe fixture path: $check"
        }
        Remove-Item -LiteralPath $check -Recurse -Force
    }
}
