param(
    [int]$Port = 9229
)

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Upstream = Join-Path $Root 'vendor\claude-rtl-companion'
$Main = Join-Path $Upstream 'claude-rtl.ps1'
$Cdp = Join-Path $Upstream 'scripts\cdp-inject.ps1'
$RtlSnippet = Join-Path $Upstream 'scripts\inject-snippet.js'
$FontHelper = Join-Path $Root 'scripts\Ensure-Vazirmatn.ps1'

function Info($m) { Write-Host "[Claude RTL] $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "[Claude RTL] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "[Claude RTL] $m" -ForegroundColor Yellow }

foreach ($f in @($Main,$Cdp,$RtlSnippet,$FontHelper)) {
    if (-not (Test-Path -LiteralPath $f)) {
        throw "Required file not found: $f`nRun Setup-Claude-RTL.cmd first."
    }
}

Info "Enabling Claude Developer Mode..."
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Main -Mode EnableDevMode
if ($LASTEXITCODE -ne 0) { throw "EnableDevMode failed." }

# Start Claude package if the main app is not running.
$running = Get-CimInstance Win32_Process -Filter "Name='Claude.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.ExecutablePath -like '*WindowsApps*' -and $_.CommandLine -notmatch '--type=' }

if (-not $running) {
    Info "Starting Claude Desktop..."
    $pkg = Get-AppxPackage -Name Claude -ErrorAction Stop
    $app = (Get-AppxPackageManifest $pkg).Package.Applications.Application | Select-Object -First 1
    $aumid = 'shell:AppsFolder\' + $pkg.PackageFamilyName + '!' + $app.Id
    Start-Process explorer.exe $aumid

    $deadline = (Get-Date).AddSeconds(45)
    do {
        Start-Sleep -Milliseconds 500
        $running = Get-CimInstance Win32_Process -Filter "Name='Claude.exe'" -ErrorAction SilentlyContinue |
            Where-Object { $_.ExecutablePath -like '*WindowsApps*' -and $_.CommandLine -notmatch '--type=' }
    } until ($running -or (Get-Date) -ge $deadline)

    if (-not $running) { throw "Claude Desktop did not start within 45 seconds." }
}

function Test-Cdp {
    try {
        $null = Invoke-RestMethod -Uri "http://127.0.0.1:$Port/json/list" -TimeoutSec 2
        return $true
    } catch {
        return $false
    }
}

if (-not (Test-Cdp)) {
    Write-Host ""
    Warn "One manual step is required for each new Claude session:"
    Write-Host "  Claude menu -> Developer -> Enable Main Process Debugger"
    Write-Host ""
    Write-Host "Waiting up to 3 minutes..."

    $deadline = (Get-Date).AddMinutes(3)
    while ((Get-Date) -lt $deadline -and -not (Test-Cdp)) {
        Start-Sleep -Seconds 1
    }
    if (-not (Test-Cdp)) {
        throw "Main Process Debugger was not enabled within 3 minutes."
    }
}

Info "Applying upstream RTL engine..."
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Cdp -SnippetPath $RtlSnippet -Port $Port
if ($LASTEXITCODE -ne 0) { throw "RTL injection failed." }

Info "Preparing Vazirmatn..."
$FontPath = (& $FontHelper | Select-Object -Last 1)
if (-not $FontPath -or -not (Test-Path -LiteralPath $FontPath)) {
    throw "Could not resolve Vazirmatn font."
}

$fontB64 = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($FontPath))
$tempJs = Join-Path $env:TEMP "claude-rtl-vazirmatn-$PID.js"

$js = @'
(async () => {
  const STYLE_ID = 'claude-vazirmatn-rtl-runtime';
  const FONT_KEY = '__claudeVazirmatnRuntime';
  const FAMILY = 'Claude Vazirmatn RTL';

  document.getElementById(STYLE_ID)?.remove();
  if (window[FONT_KEY]) {
    try { document.fonts.delete(window[FONT_KEY]); } catch (_) {}
    try { delete window[FONT_KEY]; } catch (_) {}
  }

  const raw = atob('__FONT_BASE64__');
  const bytes = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) bytes[i] = raw.charCodeAt(i);

  const face = new FontFace(FAMILY, bytes.buffer, {
    style: 'normal',
    weight: '100 900',
    unicodeRange:
      'U+0600-06FF,U+0750-077F,U+0870-089F,U+08A0-08FF,U+FB50-FDFF,U+FE70-FEFF'
  });

  document.fonts.add(face);
  await face.load();
  window[FONT_KEY] = face;

  const root = document.body || document.documentElement;
  const fallback = getComputedStyle(root).fontFamily || 'system-ui,sans-serif';

  const style = document.createElement('style');
  style.id = STYLE_ID;
  style.textContent = `
:dir(rtl):not(pre):not(code):not(.epitaxy-codeblock):not(.epitaxy-diff) {
  font-family: "${FAMILY}", ${fallback} !important;
}
`;
  (document.head || document.documentElement).appendChild(style);

  return 'Vazirmatn runtime font applied';
})()
'@

$js = $js.Replace('__FONT_BASE64__', $fontB64)
$utf8 = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($tempJs, $js, $utf8)

try {
    Info "Applying Vazirmatn..."
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $Cdp -SnippetPath $tempJs -Port $Port
    if ($LASTEXITCODE -ne 0) { throw "Vazirmatn injection failed." }
}
finally {
    Remove-Item -LiteralPath $tempJs -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Ok "Claude RTL + Vazirmatn is active for this session."
