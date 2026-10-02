# Security

**English** | [فارسی](SECURITY.fa.md)

This project is a wrapper around the MIT-licensed Claude RTL Companion and
intentionally avoids modifying Claude's installed package.

- No `app.asar` modification
- No `WindowsApps` ownership changes
- No MSIX re-signing
- No certificate installation
- No Administrator requirement

Claude Developer Mode is enabled through the same user configuration key used
by the upstream companion. Each Claude session still requires the user to
enable **Main Process Debugger** from Claude's Developer menu.

The debugger is local to the machine. While it is active, another process
running as the same Windows user may be able to connect to the local inspector
endpoint. Do not expose the debugger port through firewall/port-forward rules.

## Network activity

`Setup-Claude-RTL.ps1` uses Git to clone a pinned upstream commit.
The Vazirmatn helper may download the pinned v33.003 WOFF2 file from jsDelivr.

No conversation content is uploaded by this wrapper.
