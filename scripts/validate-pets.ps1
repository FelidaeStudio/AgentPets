[CmdletBinding()]
param(
    [string]$RepositoryRoot,

    [ValidatePattern('^[a-z0-9]+(?:[-_][a-z0-9]+)*$')]
    [string]$PetId
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
}

$catalogPath = Join-Path $RepositoryRoot "catalog.json"
if (-not (Test-Path -LiteralPath $catalogPath -PathType Leaf)) {
    throw "Missing catalog: $catalogPath"
}

$catalog = Get-Content -LiteralPath $catalogPath -Raw | ConvertFrom-Json
$pets = @($catalog.pets)
if (-not [string]::IsNullOrWhiteSpace($PetId)) {
    $pets = @($pets | Where-Object { $_.id -eq $PetId })
    if ($pets.Count -eq 0) {
        throw "Pet '$PetId' is not registered in catalog.json"
    }
}

function Get-PngHeaderInfo {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $stream = [IO.File]::OpenRead($Path)
    try {
        if ($stream.Length -lt 33) {
            throw "File is too short to be a PNG"
        }
        $header = [byte[]]::new(26)
        $read = $stream.Read($header, 0, $header.Length)
        if ($read -ne $header.Length) {
            throw "Could not read the PNG header"
        }
    }
    finally {
        $stream.Dispose()
    }

    $signature = [byte[]](137, 80, 78, 71, 13, 10, 26, 10)
    for ($index = 0; $index -lt $signature.Length; $index++) {
        if ($header[$index] -ne $signature[$index]) {
            throw "Invalid PNG signature"
        }
    }
    if ([Text.Encoding]::ASCII.GetString($header, 12, 4) -ne "IHDR") {
        throw "PNG does not start with an IHDR chunk"
    }

    $width = [Net.IPAddress]::NetworkToHostOrder(
        [BitConverter]::ToInt32($header, 16)
    )
    $height = [Net.IPAddress]::NetworkToHostOrder(
        [BitConverter]::ToInt32($header, 20)
    )
    [pscustomobject]@{
        Width = $width
        Height = $height
        BitDepth = [int]$header[24]
        ColorType = [int]$header[25]
        HasAlpha = [int]$header[25] -in @(4, 6)
    }
}

$failures = [System.Collections.Generic.List[string]]::new()
$seenIds = @{}
$maxBytes = 20MB

foreach ($pet in $pets) {
    if ([string]::IsNullOrWhiteSpace($pet.id) -or
        $pet.id -notmatch '^[a-z0-9]+(?:[-_][a-z0-9]+)*$') {
        $failures.Add("Invalid pet id: '$($pet.id)'")
        continue
    }
    if ($seenIds.ContainsKey($pet.id)) {
        $failures.Add("Duplicate pet id: '$($pet.id)'")
        continue
    }
    $seenIds[$pet.id] = $true

    $buildPath = Join-Path $RepositoryRoot $pet.build
    if (-not (Test-Path -LiteralPath $buildPath -PathType Leaf)) {
        $failures.Add("[$($pet.id)] Missing build.json: $($pet.build)")
        continue
    }
    $build = Get-Content -LiteralPath $buildPath -Raw | ConvertFrom-Json
    $petRoot = Split-Path -Parent $buildPath
    if ($build.id -ne $pet.id) {
        $failures.Add("[$($pet.id)] build.json id does not match catalog")
    }

    $sourcePng = Join-Path $petRoot $build.paths.sourceAtlasPng
    $sourceWebp = Join-Path $petRoot $build.paths.sourceAtlasWebp
    $packageDir = Join-Path $petRoot $build.paths.package
    $packageManifest = Join-Path $packageDir "pet.json"
    $packageWebp = Join-Path $packageDir "spritesheet.webp"

    foreach ($requiredPath in @($sourcePng, $sourceWebp, $packageManifest, $packageWebp)) {
        if (-not (Test-Path -LiteralPath $requiredPath -PathType Leaf)) {
            $failures.Add("[$($pet.id)] Missing required file: $requiredPath")
        }
    }
    if (-not (Test-Path -LiteralPath $sourcePng -PathType Leaf)) {
        continue
    }

    try {
        $png = Get-PngHeaderInfo -Path $sourcePng
        if ($png.Width -ne $build.atlas.width -or $png.Height -ne $build.atlas.height) {
            $failures.Add("[$($pet.id)] Atlas dimensions do not match build.json: $($png.Width)x$($png.Height)")
        }
        if (-not $png.HasAlpha) {
            $failures.Add("[$($pet.id)] PNG does not report an alpha channel: color type $($png.ColorType)")
        }
    }
    catch {
        $failures.Add("[$($pet.id)] Could not inspect PNG: $($_.Exception.Message)")
    }

    if ((Test-Path -LiteralPath $packageWebp) -and (Get-Item -LiteralPath $packageWebp).Length -gt $maxBytes) {
        $failures.Add("[$($pet.id)] Package spritesheet is larger than 20 MiB")
    }

    if ((Test-Path -LiteralPath $sourceWebp) -and (Test-Path -LiteralPath $packageWebp)) {
        $sourceHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $sourceWebp).Hash
        $packageHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $packageWebp).Hash
        if ($sourceHash -ne $packageHash) {
            $failures.Add("[$($pet.id)] Package WebP does not match run/final WebP")
        }
    }

    if (Test-Path -LiteralPath $packageManifest) {
        $manifest = Get-Content -LiteralPath $packageManifest -Raw | ConvertFrom-Json
        if ($manifest.id -ne $pet.id -or $manifest.spritesheetPath -ne "spritesheet.webp") {
            $failures.Add("[$($pet.id)] Invalid package/pet.json")
        }
        if ($null -ne $build.atlas.spriteVersionNumber -and
            [int]$build.atlas.spriteVersionNumber -ge 2 -and
            [int]$manifest.spriteVersionNumber -ne [int]$build.atlas.spriteVersionNumber) {
            $failures.Add("[$($pet.id)] package/pet.json spriteVersionNumber does not match build.json")
        }
    }

    $validationRelative = if ($build.paths.validation) { $build.paths.validation } else { "run/final/validation.json" }
    $resultRelatives = @($validationRelative)
    if ($build.paths.frameReview) {
        $resultRelatives += $build.paths.frameReview
    }
    elseif (-not $build.provenance.resultsOnly) {
        $resultRelatives += "run/qa/review.json"
    }
    foreach ($resultRelative in $resultRelatives) {
        $resultPath = Join-Path $petRoot $resultRelative
        if (-not (Test-Path -LiteralPath $resultPath -PathType Leaf)) {
            $failures.Add("[$($pet.id)] Missing validation result: $resultRelative")
            continue
        }
        $result = Get-Content -LiteralPath $resultPath -Raw | ConvertFrom-Json
        if (-not $result.ok) {
            $failures.Add("[$($pet.id)] Validation failed: $resultRelative")
        }
    }

    Write-Host "Checked $($pet.id)"
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

$publicationValidator = Join-Path $RepositoryRoot "scripts/validate-publication.ps1"
if (-not (Test-Path -LiteralPath $publicationValidator -PathType Leaf)) {
    Write-Error "Missing publication privacy validator: $publicationValidator"
    exit 1
}
& $publicationValidator -RepositoryRoot $RepositoryRoot

Write-Host "All $($pets.Count) pet(s) passed repository validation."
