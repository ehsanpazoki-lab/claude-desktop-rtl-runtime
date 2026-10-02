param(
    [int]$Port = 9229
)

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Upstream = Join-Path $Root 'vendor\claude-rtl-companion'
$Main = Join-Path $Upstream 'claude-rtl.ps1'
$Cdp = Join-Path $Upstream 'scripts\cdp-inject.ps1'

function Info($m) { Write-Host "[Claude RTL Disable] $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "[Claude RTL Disable] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "[Claude RTL Disable] $m" -ForegroundColor Yellow }

if (-not (Test-Path -LiteralPath $Main)) {
    throw "Upstream companion is not installed. Run Setup-Claude-RTL.cmd first."
}

$runtimeRestored = $false

function Test-Cdp {
    try {
        $targets = @(Invoke-RestMethod -Uri "http://127.0.0.1:$Port/json/list" -TimeoutSec 2)
        return ($targets.Count -gt 0)
    } catch {
        return $false
    }
}

if ((Test-Path -LiteralPath $Cdp) -and (Test-Cdp)) {
    Info "Removing RTL and Vazirmatn from the current Claude session..."

    $tempJs = Join-Path $env:TEMP "claude-rtl-cleanup-$PID.js"

    $cleanupJs = @'
(() => {
  const result = {
    rtlRemoveCalled: false,
    rtlStyleRemoved: false,
    fontStyleRemoved: false,
    fontFaceRemoved: false
  };

  try {
    if (typeof window.claudeRtlRemove === 'function') {
      window.claudeRtlRemove();
      result.rtlRemoveCalled = true;
    }
  } catch (_) {}

  try {
    const rtlStyle = document.getElementById('claude-rtl-companion');
    if (rtlStyle) {
      rtlStyle.remove();
      result.rtlStyleRemoved = true;
    }
  } catch (_) {}

  try {
    const fontStyle = document.getElementById('claude-vazirmatn-rtl-runtime');
    if (fontStyle) {
      fontStyle.remove();
      result.fontStyleRemoved = true;
    }
  } catch (_) {}

  try {
    const fontKey = '__claudeVazirmatnRuntime';
    const face = window[fontKey];
    if (face) {
      try { document.fonts.delete(face); } catch (_) {}
      try { delete window[fontKey]; } catch (_) {}
      result.fontFaceRemoved = true;
    }
  } catch (_) {}

  return JSON.stringify(result);
})()
'@

    $utf8 = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($tempJs, $cleanupJs, $utf8)

    try {
        & powershell.exe -NoProfile -ExecutionPolicy Bypass `
            -File $Cdp `
            -SnippetPath $tempJs `
            -Port $Port

        if ($LASTEXITCODE -eq 0) {
            $runtimeRestored = $true
            Ok "Runtime RTL/Vazirmatn cleanup was sent to all Claude views."
        }
        else {
            Warn "Runtime cleanup returned exit code $LASTEXITCODE."
        }
    }
    catch {
        Warn "Runtime cleanup could not be completed: $($_.Exception.Message)"
    }
    finally {
        Remove-Item -LiteralPath $tempJs -Force -ErrorAction SilentlyContinue
    }
}
else {
    Warn "Main Process Debugger is not available on port $Port."
    Warn "The current session cannot be restored live; fully quit Claude to clear runtime changes."
}

Info "Disabling Claude Developer Mode..."
& powershell.exe -NoProfile -ExecutionPolicy Bypass `
    -File $Main `
    -Mode DisableDevMode

if ($LASTEXITCODE -ne 0) {
    throw "DisableDevMode failed."
}

Write-Host ""

if ($runtimeRestored) {
    Ok "RTL and Vazirmatn were removed from the current session."
    Ok "Developer Mode is disabled for future Claude launches."
}
else {
    Ok "Developer Mode is disabled for future Claude launches."
    Warn "Fully quit Claude once to remove any remaining runtime RTL/Vazirmatn from this session."
}
