# Claude Desktop RTL Runtime + Vazirmatn

**English** | [فارسی](README.fa.md)

> **Unofficial community project. Not affiliated with or endorsed by Anthropic.**

A small Windows wrapper that combines the MIT-licensed
[Claude RTL Companion](https://github.com/Sabarhealth/claude-rtl-companion)
with runtime Vazirmatn font injection.

It does **not** patch `app.asar`, modify `WindowsApps`, or re-sign the MSIX app.

Upstream is pinned for this beta to:

```text
ab938536096145fb797f2f6cdbc7bb8c1a008b3e
```

## Windows installer

For most users, the recommended distribution is the per-user Windows installer:

```text
Claude-Desktop-RTL-Runtime-Setup-v0.1.1-beta.exe
```

The compiled installer bundles the pinned upstream Claude RTL Companion snapshot
and Vazirmatn, so end users do **not** need Git for the installer edition.

## Requirements

- Windows 10/11
- Claude Desktop installed as the Microsoft Store/MSIX package
- PowerShell 5.1+
- Git for Windows for the one-time setup
- No Administrator rights required

## One-time setup

Extract the release ZIP anywhere.

Optional preflight test for the font download:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\Test-Vazirmatn-Download.ps1
```

Then run:

```text
Setup-Claude-RTL.cmd
```

This:
1. clones the upstream companion into `vendor/`
2. checks out the tested commit
3. downloads Vazirmatn 33.0.3 into `assets/`

## Daily use

Double-click:

```text
Claude-RTL-Run.cmd
```

For each fresh Claude session, one manual step remains:

```text
Claude menu -> Developer -> Enable Main Process Debugger
```

The launcher waits for that step, then injects RTL into all supported Claude
views and applies Vazirmatn to RTL text.

## Disable / restore

Run:

```text
Disable-Claude-RTL.cmd
```

If Claude's **Main Process Debugger** is still active, this command:

1. calls the upstream `window.claudeRtlRemove()` cleanup on all Claude views
2. removes the runtime Vazirmatn stylesheet and FontFace
3. disables Claude Developer Mode for future launches

The current Claude window should return to its normal LTR/default-font state
without a restart.

If the debugger is no longer available, Developer Mode is still disabled, but
the command will tell you to fully quit Claude once to clear the remaining
per-session runtime changes.

## Security

See [SECURITY.md](SECURITY.md).

## Known limitations

- Depends on an upstream project and a pinned tested commit.
- Claude's internal UI may change after Store updates.
- Main Process Debugger must still be enabled once per Claude session.

## Persian / فارسی

این پروژه نسخه اصلی Claude را Patch نمی‌کند. ابتدا پروژه امن
`claude-rtl-companion` را در commit تست‌شده دریافت می‌کند و سپس RTL و
Vazirmatn را فقط در همان Session به‌صورت runtime اعمال می‌کند.

## License

Wrapper code: MIT.

Upstream Claude RTL Companion: MIT.

Vazirmatn: OFL-1.1.

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).


## Desktop shortcut

- The installer offers an optional **Create a desktop shortcut** task for `Claude RTL`; it is unchecked by default.

## System tray controller

`v0.2.0-beta` adds a lightweight tray controller:

```text
Enable RTL
Disable RTL
Status
Exit Tray Controller
```

Double-clicking the tray icon starts the Enable flow. In each fresh Claude session,
the existing manual step still applies:

```text
Developer → Enable Main Process Debugger
```

The installer can optionally start the tray controller with Windows. Auto-start is
unchecked by default. It also creates an explicit **Claude Desktop RTL Runtime**
Start Menu folder containing Run, Disable, Status, Tray Controller, documentation,
and Uninstall.

## Maintainer and source

Maintained by **Ehsan Pazoki** on GitHub: `ehsanpazoki-lab`.

Project repository:
`https://github.com/ehsanpazoki-lab/claude-desktop-rtl-runtime`

This is an independent community project and is not affiliated with or endorsed by
the vendor of Claude.
