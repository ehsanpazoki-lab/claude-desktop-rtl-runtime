param(
    [int]$Port = 9229
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Root = $PSScriptRoot
$RunScript = Join-Path $Root 'Claude-RTL-Run.ps1'
$DisableScript = Join-Path $Root 'Disable-Claude-RTL.ps1'
$VendorMain = Join-Path $Root 'vendor\claude-rtl-companion\claude-rtl.ps1'
$PidFile = Join-Path $Root 'claude-rtl-tray.pid'

$createdNew = $false
$mutex = New-Object System.Threading.Mutex(
    $true,
    'Local\ClaudeDesktopRTLRuntimeTray_v020',
    [ref]$createdNew
)

if (-not $createdNew) {
    exit 0
}

try {
    [System.IO.File]::WriteAllText(
        $PidFile,
        [string]$PID,
        (New-Object System.Text.UTF8Encoding($false))
    )
}
catch {}

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

function Get-RtlStatus {
    try {
        $rawTargets = Invoke-RestMethod `
            -Uri "http://127.0.0.1:$Port/json/list" `
            -TimeoutSec 2

        $targets = @($rawTargets | ForEach-Object { $_ })
    }
    catch {
        return [pscustomobject]@{
            Debugger = $false
            Active = $false
            FontLoaded = $false
            Targets = 0
            Detail = 'Main Process Debugger is not active.'
        }
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

    foreach ($target in $targets) {
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
        }
        catch {}
    }

    return [pscustomobject]@{
        Debugger = $true
        Active = $rtlActive
        FontLoaded = $fontLoaded
        Targets = $targets.Count
        Detail = "Queried $queried Claude view(s)."
    }
}

function Start-HiddenPowerShell {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ScriptPath,

        [string]$ExtraArguments = ''
    )

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        throw "Required script not found: $ScriptPath"
    }

    $quoted = '"' + $ScriptPath.Replace('"', '\"') + '"'
    $argLine = "-NoProfile -ExecutionPolicy Bypass -File $quoted"

    if ($ExtraArguments) {
        $argLine += " $ExtraArguments"
    }

    Start-Process `
        -FilePath 'powershell.exe' `
        -ArgumentList $argLine `
        -WindowStyle Hidden | Out-Null
}

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Application
$notify.Text = 'Claude RTL: checking...'
$notify.Visible = $true

$menu = New-Object System.Windows.Forms.ContextMenuStrip

$headerItem = New-Object System.Windows.Forms.ToolStripMenuItem
$headerItem.Text = 'Claude RTL Runtime'
$headerItem.Enabled = $false

$enableItem = New-Object System.Windows.Forms.ToolStripMenuItem
$enableItem.Text = 'Enable RTL'

$disableItem = New-Object System.Windows.Forms.ToolStripMenuItem
$disableItem.Text = 'Disable RTL'

$statusItem = New-Object System.Windows.Forms.ToolStripMenuItem
$statusItem.Text = 'Status'

$separator = New-Object System.Windows.Forms.ToolStripSeparator

$exitItem = New-Object System.Windows.Forms.ToolStripMenuItem
$exitItem.Text = 'Exit Tray Controller'

[void]$menu.Items.Add($headerItem)
[void]$menu.Items.Add($enableItem)
[void]$menu.Items.Add($disableItem)
[void]$menu.Items.Add($statusItem)
[void]$menu.Items.Add($separator)
[void]$menu.Items.Add($exitItem)

$notify.ContextMenuStrip = $menu

$script:LastActive = $null

function Refresh-TrayStatus {
    try {
        $s = Get-RtlStatus

        if ($s.Active) {
            $notify.Icon = [System.Drawing.SystemIcons]::Information
            $notify.Text = 'Claude RTL: Active'
            $enableItem.Enabled = $false
            $disableItem.Enabled = $true
        }
        else {
            $notify.Icon = [System.Drawing.SystemIcons]::Application
            $notify.Text = 'Claude RTL: Inactive'
            $enableItem.Enabled = $true
            $disableItem.Enabled = $s.Debugger
        }

        if ($null -ne $script:LastActive -and $script:LastActive -ne $s.Active) {
            if ($s.Active) {
                $notify.BalloonTipTitle = 'Claude RTL'
                $notify.BalloonTipText = 'RTL + Vazirmatn is active.'
            }
            else {
                $notify.BalloonTipTitle = 'Claude RTL'
                $notify.BalloonTipText = 'RTL is inactive.'
            }

            $notify.ShowBalloonTip(1800)
        }

        $script:LastActive = $s.Active
    }
    catch {
        $notify.Text = 'Claude RTL: status error'
        $enableItem.Enabled = $true
        $disableItem.Enabled = $true
    }
}

$enableAction = {
    try {
        if (-not (Test-Path -LiteralPath $VendorMain)) {
            [System.Windows.Forms.MessageBox]::Show(
                'Claude RTL Companion is not installed. Run Setup-Claude-RTL.cmd first.',
                'Claude RTL Runtime',
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            ) | Out-Null
            return
        }

        $result = [System.Windows.Forms.MessageBox]::Show(
            "Enable Claude RTL?`r`n`r`nClaude will be opened if needed. In a fresh Claude session, choose:`r`nDeveloper -> Enable Main Process Debugger`r`n`r`nThe tray controller will detect RTL after injection completes.",
            'Claude RTL Runtime',
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($result -ne [System.Windows.Forms.DialogResult]::Yes) {
            return
        }

        Start-HiddenPowerShell `
            -ScriptPath $RunScript `
            -ExtraArguments "-Port $Port"

        $notify.BalloonTipTitle = 'Claude RTL'
        $notify.BalloonTipText = 'Waiting for Claude Main Process Debugger / RTL injection...'
        $notify.ShowBalloonTip(2500)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            'Claude RTL Error',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    }
}

$enableItem.Add_Click($enableAction)
$notify.Add_DoubleClick($enableAction)

$disableItem.Add_Click({
    try {
        Start-HiddenPowerShell `
            -ScriptPath $DisableScript `
            -ExtraArguments "-Port $Port"

        $notify.BalloonTipTitle = 'Claude RTL'
        $notify.BalloonTipText = 'Disabling RTL...'
        $notify.ShowBalloonTip(1500)
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            'Claude RTL Error',
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    }
})

$statusItem.Add_Click({
    $s = Get-RtlStatus

    $message = @"
Main debugger:     $($s.Debugger)
RTL active:        $($s.Active)
Vazirmatn loaded:  $($s.FontLoaded)
Targets discovered:$($s.Targets)

$($s.Detail)
"@

    [System.Windows.Forms.MessageBox]::Show(
        $message,
        'Claude RTL Status',
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null
})

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 3000
$timer.Add_Tick({ Refresh-TrayStatus })
$timer.Start()

$exitItem.Add_Click({
    $timer.Stop()
    $notify.Visible = $false
    [System.Windows.Forms.Application]::Exit()
})

try {
    Refresh-TrayStatus
    [System.Windows.Forms.Application]::Run()
}
finally {
    try { $timer.Stop() } catch {}
    try { $notify.Visible = $false } catch {}
    try { $notify.Dispose() } catch {}
    try { $menu.Dispose() } catch {}
    try { Remove-Item -LiteralPath $PidFile -Force -ErrorAction SilentlyContinue } catch {}
    try { $mutex.ReleaseMutex() } catch {}
    try { $mutex.Dispose() } catch {}
}
