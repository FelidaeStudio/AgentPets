[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$repositoryRoot = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $repositoryRoot "scripts/validate-publication.ps1"
$fixtureRoot = Join-Path $PSScriptRoot ".publication-privacy-fixture"
$fixturePath = Join-Path $fixtureRoot "artifact.json"

if (-not (Test-Path -LiteralPath $validator -PathType Leaf)) {
    throw "Publication validator is missing: $validator"
}

$resolvedFixture = [IO.Path]::GetFullPath($fixtureRoot)
$resolvedTests = [IO.Path]::GetFullPath($PSScriptRoot) + [IO.Path]::DirectorySeparatorChar
if (-not $resolvedFixture.StartsWith($resolvedTests, [StringComparison]::OrdinalIgnoreCase)) {
    throw "Unsafe fixture path: $resolvedFixture"
}

try {
    New-Item -ItemType Directory -Force -Path $resolvedFixture | Out-Null

    $priorPreference = $ErrorActionPreference
    $unsafeCases = @(
        @{
            Name = "Windows user-profile path"
            Json = '{"path":"C:' + '\\Users\\' + 'alice\\private\\sprite.png"}'
        },
        @{
            Name = "macOS user-home path"
            Json = '{"path":"' + '/Us' + 'ers/alice/Library/Application Support/Codex/sprite.png"}'
        },
        @{
            Name = "Linux user-home path"
            Json = '{"path":"' + '/ho' + 'me/alice/.local/share/codex/sprite.png"}'
        },
        @{
            Name = "Linux root-home path"
            Json = '{"path":"' + '/ro' + 'ot/private/sprite.png"}'
        },
        @{
            Name = "macOS per-user temporary path"
            Json = '{"path":"' + '/private/var/fol' + 'ders/ab/cd/T/sprite.png"}'
        },
        @{
            Name = "macOS mounted-volume path"
            Json = '{"path":"' + '/Vol' + 'umes/PrivateDisk/AgentPets/sprite.png"}'
        },
        @{
            Name = "Unix workspace path"
            Json = '{"path":"' + '/work' + 'space/AgentPets/pets/tifa/run/artifact.json"}'
        },
        @{
            Name = "WSL Windows user-profile path"
            Json = '{"path":"' + '/mnt/c/Us' + 'ers/alice/private/sprite.png"}'
        },
        @{
            Name = "local file URI"
            Json = '{"path":"file:' + '///Us' + 'ers/alice/private/sprite.png"}'
        }
    )

    foreach ($case in $unsafeCases) {
        [IO.File]::WriteAllText($fixturePath, $case.Json, [Text.UTF8Encoding]::new($false))
        $wasRejected = $false
        try {
            & $validator -RepositoryRoot $resolvedFixture 2>&1 | Out-Null
        }
        catch {
            $wasRejected = $true
        }
        if (-not $wasRejected) {
            throw "Validator accepted a concrete $($case.Name)."
        }
    }

    [IO.File]::WriteAllText(
        $fixturePath,
        '{"path":"run/final/spritesheet.webp"}',
        [Text.UTF8Encoding]::new($false)
    )
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archivePath = Join-Path $resolvedFixture "artifact.zip"
    $archive = [IO.Compression.ZipFile]::Open(
        $archivePath,
        [IO.Compression.ZipArchiveMode]::Create
    )
    try {
        $entry = $archive.CreateEntry("metadata/artifact.json")
        $writer = [IO.StreamWriter]::new(
            $entry.Open(),
            [Text.UTF8Encoding]::new($false)
        )
        try {
            $writer.Write('{"path":"' + '/ho' + 'me/alice/private/sprite.png"}')
        }
        finally {
            $writer.Dispose()
        }
    }
    finally {
        $archive.Dispose()
    }

    $archiveWasRejected = $false
    try {
        & $validator -RepositoryRoot $resolvedFixture 2>&1 | Out-Null
    }
    catch {
        $archiveWasRejected = $true
    }
    if (-not $archiveWasRejected) {
        throw "Validator accepted a private path inside a ZIP text entry."
    }
    Remove-Item -LiteralPath $archivePath

    $temporaryInstallPath = Join-Path $resolvedFixture ".install-test"
    New-Item -ItemType Directory -Path $temporaryInstallPath | Out-Null
    $temporaryInstallWasRejected = $false
    try {
        & $validator -RepositoryRoot $resolvedFixture 2>&1 | Out-Null
    }
    catch {
        $temporaryInstallWasRejected = $true
    }
    if (-not $temporaryInstallWasRejected) {
        throw "Validator accepted a leftover temporary installation directory."
    }
    Remove-Item -LiteralPath $temporaryInstallPath

    $safeCases = @(
        @{
            Name = "repository-relative artifact path"
            Json = '{"path":"run/final/spritesheet.webp"}'
        },
        @{
            Name = "GitHub API URL"
            Json = '{"source":"https://api.github.com/' + 'repos/example/agent-pets"}'
        },
        @{
            Name = "HTTPS projects URL"
            Json = '{"source":"https://example.com/' + 'projects/agent-pets"}'
        }
    )

    foreach ($case in $safeCases) {
        [IO.File]::WriteAllText($fixturePath, $case.Json, [Text.UTF8Encoding]::new($false))
        try {
            & $validator -RepositoryRoot $resolvedFixture 2>&1 | Out-Null
        }
        catch {
            throw "Validator rejected a safe $($case.Name): $($_.Exception.Message)"
        }
    }

    Write-Host "Publication privacy validator tests passed."
}
finally {
    if (Test-Path -LiteralPath $resolvedFixture) {
        Remove-Item -LiteralPath $resolvedFixture -Recurse -Force
    }
}
