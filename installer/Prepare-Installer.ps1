param()

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$Stage = Join-Path $PSScriptRoot 'staging'
$Assets = Join-Path $Stage 'assets'
$VendorParent = Join-Path $Stage 'vendor'
$Vendor = Join-Path $VendorParent 'claude-rtl-companion'
$FontHelper = Join-Path $Root 'scripts\Ensure-Vazirmatn.ps1'

$UpstreamRepo = 'https://github.com/Sabarhealth/claude-rtl-companion.git'
$PinnedCommit = 'ab938536096145fb797f2f6cdbc7bb8c1a008b3e'

if (Test-Path -LiteralPath $Stage) {
    Remove-Item -LiteralPath $Stage -Recurse -Force
}
New-Item -ItemType Directory -Path $Assets -Force | Out-Null
New-Item -ItemType Directory -Path $VendorParent -Force | Out-Null

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required to BUILD the installer. End users of the compiled installer do not need Git."
}

Write-Host "[installer] Cloning pinned Claude RTL Companion..."
git clone --quiet $UpstreamRepo $Vendor
if ($LASTEXITCODE -ne 0) { throw "git clone failed." }

git -C $Vendor checkout --quiet --detach $PinnedCommit
if ($LASTEXITCODE -ne 0) { throw "git checkout failed." }

$actual = (git -C $Vendor rev-parse HEAD).Trim()
if ($actual -ne $PinnedCommit) {
    throw "Unexpected upstream commit: $actual"
}

Remove-Item -LiteralPath (Join-Path $Vendor '.git') -Recurse -Force

foreach ($rel in @('claude-rtl.ps1','scripts\cdp-inject.ps1','scripts\inject-snippet.js','LICENSE')) {
    if (-not (Test-Path -LiteralPath (Join-Path $Vendor $rel))) {
        throw "Required upstream file missing: $rel"
    }
}

Write-Host "[installer] Preparing pinned Vazirmatn..."
$font = (& $FontHelper -AssetDir $Assets | Select-Object -Last 1)
if (-not $font -or -not (Test-Path -LiteralPath $font)) {
    throw "Could not prepare Vazirmatn for installer."
}

@"
Claude RTL Companion
Pinned commit: $PinnedCommit
Prepared: $(Get-Date -Format o)
"@ | Set-Content -LiteralPath (Join-Path $Stage 'BUILDINFO.txt') -Encoding UTF8

Write-Host "[installer] Staging ready: $Stage" -ForegroundColor Green
