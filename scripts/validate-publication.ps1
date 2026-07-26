[CmdletBinding()]
param(
    [string]$RepositoryRoot
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
}

$root = [IO.Path]::GetFullPath($RepositoryRoot)
if (-not (Test-Path -LiteralPath $root -PathType Container)) {
    throw "Repository root does not exist: $root"
}
$rootPrefix = $root.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) +
    [IO.Path]::DirectorySeparatorChar

$textExtensions = @(
    ".json", ".jsonl", ".md", ".txt", ".ps1", ".psm1", ".psd1",
    ".yaml", ".yml", ".toml", ".xml", ".csv", ".tsv", ".html",
    ".css", ".js", ".mjs", ".cjs", ".ts", ".tsx", ".jsx", ".py",
    ".sh", ".bat", ".cmd"
)
$structuredExtensions = @(".json", ".jsonl", ".yaml", ".yml", ".toml", ".xml")
$failures = [System.Collections.Generic.List[string]]::new()
$validatorPath = [IO.Path]::GetFullPath($MyInvocation.MyCommand.Path)
$temporaryDirectoryNames = @(
    ".install-test",
    ".install-all-fixture",
    ".cross-platform-fixture",
    ".publication-privacy-fixture"
)

Get-ChildItem -LiteralPath $root -Recurse -Directory -Force |
    Where-Object { $temporaryDirectoryNames -contains $_.Name } |
    ForEach-Object {
        $relative = if ($_.FullName.StartsWith(
                $rootPrefix,
                [StringComparison]::OrdinalIgnoreCase
            )) {
            $_.FullName.Substring($rootPrefix.Length)
        }
        else {
            $_.Name
        }
        $failures.Add("$relative is a leftover temporary directory")
    }

function Test-PublicationContent {
    param(
        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$RelativePath,

        [Parameter(Mandatory = $true)]
        [string]$Extension,

        [Parameter(Mandatory = $true)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[string]]$Findings
    )

    if ($Content -match '(?i)[A-Z]:[\\/]+Users[\\/]+[^\\/"\s]+') {
        $Findings.Add("$RelativePath contains a concrete Windows user-profile path")
    }
    if ($Content -match '(?i)(?:^|[^A-Za-z0-9:/]|file://)/(?:Users|home|root|mnt/[a-z]/Users)/[^/"\s]+') {
        $Findings.Add("$RelativePath contains a concrete Unix or WSL user-home path")
    }
    if ($Content -match '(?i)(?:^|[^A-Za-z0-9:/]|file://)/(?:private/)?var/folders/[^/"\s]+') {
        $Findings.Add("$RelativePath contains a concrete macOS per-user temporary path")
    }
    if ($Content -match '(?i)(?:^|[^A-Za-z0-9:/]|file://)/Volumes/[^/"\s]+/') {
        $Findings.Add("$RelativePath contains a concrete macOS mounted-volume path")
    }
    if ($Content -match '(?i)(?:^|[^A-Za-z0-9:/]|file://)/(?:workspace|workspaces|projects?|repos?)/[^/"\s]+') {
        $Findings.Add("$RelativePath contains a concrete Unix workspace path")
    }
    if ($Content -match '(?i)\.codex[\\/]+(?:generated_images|visualizations)[\\/]') {
        $Findings.Add("$RelativePath contains a local Codex storage path")
    }
    if ($Content -match '(?i)[A-Z]:[\\/]+(?:Workspace|Repos?|Projects?|Documents|Downloads)[\\/]') {
        $Findings.Add("$RelativePath contains a concrete local workspace or documents path")
    }
    if ($structuredExtensions -contains $Extension -and
        $Content -match '(?i)(?<![A-Za-z])[A-Z]:[\\/]+') {
        $Findings.Add("$RelativePath contains an absolute Windows path in structured metadata")
    }

    foreach ($match in [regex]::Matches($Content, '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b')) {
        if ($match.Value -notmatch '(?i)@(example\.com|example\.org|example\.net)$') {
            $Findings.Add("$RelativePath contains a non-example email address")
            break
        }
    }
}

$files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object {
    $_.FullName -notmatch '(?i)[\\/]\.git[\\/]' -and
    [IO.Path]::GetFullPath($_.FullName) -ne $validatorPath -and
    $textExtensions -contains $_.Extension.ToLowerInvariant()
}

foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $relative = if ($file.FullName.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        $file.FullName.Substring($rootPrefix.Length)
    }
    else {
        $file.Name
    }

    Test-PublicationContent `
        -Content $content `
        -RelativePath $relative `
        -Extension $file.Extension.ToLowerInvariant() `
        -Findings $failures
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$archives = Get-ChildItem -LiteralPath $root -Recurse -File -Filter *.zip |
    Where-Object { $_.FullName -notmatch '(?i)[\\/]\.git[\\/]' }

foreach ($archiveFile in $archives) {
    $archiveRelative = if ($archiveFile.FullName.StartsWith(
            $rootPrefix,
            [StringComparison]::OrdinalIgnoreCase
        )) {
        $archiveFile.FullName.Substring($rootPrefix.Length)
    }
    else {
        $archiveFile.Name
    }

    $archive = $null
    try {
        $archive = [IO.Compression.ZipFile]::OpenRead($archiveFile.FullName)
        foreach ($entry in $archive.Entries) {
            $extension = [IO.Path]::GetExtension($entry.FullName).ToLowerInvariant()
            if ($textExtensions -notcontains $extension) {
                continue
            }
            if ($entry.Length -gt 5MB) {
                $failures.Add("$archiveRelative!/$($entry.FullName) is too large for privacy inspection")
                continue
            }

            $reader = [IO.StreamReader]::new(
                $entry.Open(),
                [Text.UTF8Encoding]::new($false),
                $true
            )
            try {
                $content = $reader.ReadToEnd()
            }
            finally {
                $reader.Dispose()
            }
            Test-PublicationContent `
                -Content $content `
                -RelativePath "$archiveRelative!/$($entry.FullName)" `
                -Extension $extension `
                -Findings $failures
        }
    }
    catch {
        $failures.Add("$archiveRelative could not be inspected: $($_.Exception.Message)")
    }
    finally {
        if ($null -ne $archive) {
            $archive.Dispose()
        }
    }
}

if ($failures.Count -gt 0) {
    $failures | Sort-Object -Unique | ForEach-Object { Write-Error $_ -ErrorAction Continue }
    throw "Publication privacy validation failed with $($failures.Count) finding(s)."
}

Write-Host "Publication privacy validation passed for $($files.Count) text file(s) and $($archives.Count) ZIP archive(s)."
