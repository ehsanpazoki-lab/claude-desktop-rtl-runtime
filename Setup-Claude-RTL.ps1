param()

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$VendorDir = Join-Path $Root 'vendor\claude-rtl-companion'
$FontHelper = Join-Path $Root 'scripts\Ensure-Vazirmatn.ps1'
$UpstreamRepo = 'https://github.com/Sabarhealth/claude-rtl-companion.git'
$PinnedCommit = 'ab938536096145fb797f2f6cdbc7bb8c1a008b3e'

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required for the one-time setup. Install Git for Windows, then rerun Setup-Claude-RTL.cmd."
}

if (-not (Test-Path -LiteralPath (Join-Path $VendorDir 'claude-rtl.ps1'))) {
    New-Item -ItemType Directory -Path (Split-Path $VendorDir -Parent) -Force | Out-Null
    Write-Host "[setup] Cloning upstream Claude RTL Companion..."
    git clone $UpstreamRepo $VendorDir
    if ($LASTEXITCODE -ne 0) { throw "git clone failed." }
}

Write-Host "[setup] Pinning upstream to tested commit $PinnedCommit..."
git -C $VendorDir fetch --all --tags
if ($LASTEXITCODE -ne 0) { throw "git fetch failed." }
git -C $VendorDir checkout --detach $PinnedCommit
if ($LASTEXITCODE -ne 0) { throw "git checkout failed." }

Write-Host "[setup] Preparing Vazirmatn..."
$font = (& $FontHelper | Select-Object -Last 1)
if (-not $font) { throw "Could not prepare Vazirmatn." }

Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host "Next: run Claude-RTL-Run.cmd"
