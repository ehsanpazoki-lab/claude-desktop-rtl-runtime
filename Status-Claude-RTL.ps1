param(
    [int]$Port = 9229
)

$ErrorActionPreference = 'Stop'

function Invoke-CdpExpression {
    param(
        [Parameter(Mandatory=$true)]
        [string]$WebSocketUrl,

        [Parameter(Mandatory=$true)]
        [string]$Expression
    )

    $ws = New-Object System.Net.WebSockets.ClientWebSocket
    $cts = New-Object System.Threading.CancellationTokenSource
    $cts.CancelAfter(4000)

    try {
        $wsUri = New-Object System.Uri ([string]$WebSocketUrl)
        $null = $ws.ConnectAsync($wsUri, $cts.Token).GetAwaiter().GetResult()

        $msg = @{
            id = 1
            method = 'Runtime.evaluate'
            params = @{
                expression = $Expression
                returnByValue = $true
            }
        } | ConvertTo-Json -Depth 10 -Compress

        $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg)
        $seg = New-Object System.ArraySegment[byte] -ArgumentList @(,$bytes)

        $null = $ws.SendAsync(
            $seg,
            [System.Net.WebSockets.WebSocketMessageType]::Text,
            $true,
            $cts.Token
        ).GetAwaiter().GetResult()

        while ($true) {
            $sb = New-Object System.Text.StringBuilder

            do {
                $buf = New-Object byte[] 65536
                $rseg = New-Object System.ArraySegment[byte] -ArgumentList @(,$buf)
                $res = $ws.ReceiveAsync($rseg, $cts.Token).GetAwaiter().GetResult()
                [void]$sb.Append(
                    [System.Text.Encoding]::UTF8.GetString($buf, 0, $res.Count)
                )
            } while (-not $res.EndOfMessage)

            $obj = $sb.ToString() | ConvertFrom-Json
            if ($obj.id -eq 1) {
                return $obj.result.result.value
            }
        }
    }
    finally {
        try {
            if ($ws.State -eq [System.Net.WebSockets.WebSocketState]::Open) {
                $closeCts = New-Object System.Threading.CancellationTokenSource
                $closeCts.CancelAfter(1000)
                try {
                    $null = $ws.CloseAsync(
                        [System.Net.WebSockets.WebSocketCloseStatus]::NormalClosure,
                        'done',
                        $closeCts.Token
                    ).GetAwaiter().GetResult()
                }
                finally {
                    $closeCts.Dispose()
                }
            }
        }
        catch {}

        $ws.Dispose()
        $cts.Dispose()
    }
}

try {
    $rawTargets = Invoke-RestMethod `
        -Uri "http://127.0.0.1:$Port/json/list" `
        -TimeoutSec 3

    $targets = @($rawTargets | ForEach-Object { $_ })
}
catch {
    Write-Host "Debugger active   : False"
    Write-Host "RTL active        : False"
    Write-Host "Vazirmatn loaded  : False"
    Write-Host "Reason            : Claude Main Process Debugger is not active on port $Port"
    exit 0
}

$expr = @"
(() => JSON.stringify({
  rtl:
    typeof window.claudeRtlRemove === 'function' ||
    !!document.getElementById('claude-rtl-companion'),
  font:
    !!document.getElementById('claude-vazirmatn-rtl-runtime') ||
    Array.from(document.fonts || []).some(
      f => f.family === 'Claude Vazirmatn RTL'
    )
}))()
"@

$rtlActive = $false
$fontLoaded = $false
$queried = 0

$candidates = @(
    $targets |
        Where-Object {
            $_.webSocketDebuggerUrl -and
            ($_.type -eq 'page' -or -not $_.type)
        } |
        Sort-Object @{
            Expression = {
                if ($_.url -match 'claude|app://') { 0 } else { 1 }
            }
        }
)

foreach ($target in $candidates) {
    if ($queried -ge 4) {
        break
    }
    $wsUrl = @($target.webSocketDebuggerUrl) |
        Where-Object { $_ } |
        Select-Object -First 1

    if (-not $wsUrl) {
        continue
    }

    try {
        $value = Invoke-CdpExpression `
            -WebSocketUrl ([string]$wsUrl) `
            -Expression $expr

        $state = $value | ConvertFrom-Json
        $queried++

        if ($state.rtl) { $rtlActive = $true }
        if ($state.font) { $fontLoaded = $true }

        if ($rtlActive -and $fontLoaded) {
            break
        }
    }
    catch {
        # A utility/devtools view may disappear while Claude is updating.
        # Continue checking the remaining targets.
    }
}

Write-Host "Debugger active   : True"
Write-Host "Targets discovered: $($targets.Count)"
Write-Host "Targets queried   : $queried"
Write-Host "RTL active        : $rtlActive"
Write-Host "Vazirmatn loaded  : $fontLoaded"
