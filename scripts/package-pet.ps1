[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9]+(?:[-_][a-z0-9]+)*$')]
    [string]$PetId,

    [string]$RepositoryRoot
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($RepositoryRoot)) {
    $RepositoryRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
}

$petRoot = Join-Path (Join-Path $RepositoryRoot "pets") $PetId
$buildPath = Join-Path $petRoot "build.json"
if (-not (Test-Path -LiteralPath $buildPath -PathType Leaf)) {
    throw "Missing build metadata: $buildPath"
}

$build = Get-Content -LiteralPath $buildPath -Raw | ConvertFrom-Json
if ($build.id -ne $PetId) {
    throw "build.json id '$($build.id)' does not match '$PetId'"
}

$sourceWebp = Join-Path $petRoot $build.paths.sourceAtlasWebp
$packageDir = Join-Path $petRoot $build.paths.package
if (-not (Test-Path -LiteralPath $sourceWebp -PathType Leaf)) {
    throw "Missing source atlas: $sourceWebp"
}

New-Item -ItemType Directory -Force -Path $packageDir | Out-Null
Copy-Item -LiteralPath $sourceWebp -Destination (Join-Path $packageDir "spritesheet.webp") -Force

$manifest = [ordered]@{
    id = $build.id
    displayName = $build.displayName
    description = $build.description
    spritesheetPath = "spritesheet.webp"
}
if ($null -ne $build.atlas.spriteVersionNumber -and [int]$build.atlas.spriteVersionNumber -ge 2) {
    $manifest.spriteVersionNumber = [int]$build.atlas.spriteVersionNumber
}
$json = $manifest | ConvertTo-Json
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText((Join-Path $packageDir "pet.json"), $json, $utf8)

Write-Host "Packaged $PetId at $packageDir"
