$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceFile = Join-Path $projectRoot "index.html"
$outputDir = Join-Path $projectRoot "public"
$outputFile = Join-Path $outputDir "index.html"

if (-not (Test-Path -LiteralPath $sourceFile)) {
    throw "Source file not found: $sourceFile"
}

if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Copy-Item -LiteralPath $sourceFile -Destination $outputFile -Force
Write-Host "Synced index.html -> public/index.html"

npx wrangler pages deploy public --project-name golf-reservation-lesson
