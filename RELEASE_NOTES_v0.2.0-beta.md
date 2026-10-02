# v0.2.0-beta

Unified UX release for Claude Desktop RTL Runtime + Vazirmatn.

Highlights:

- Adds a lightweight Windows system-tray controller.
- Tray menu provides **Enable RTL**, **Disable RTL**, **Status**, and **Exit Tray Controller**.
- Double-clicking the tray icon starts the Claude RTL enable flow.
- Adds a dedicated `Claude RTL Status` command.
- Installer creates an explicit Start Menu folder containing:
  - Claude RTL
  - Disable Claude RTL
  - Claude RTL Status
  - RTL Tray Controller
  - English/Persian documentation
  - Uninstall shortcut
- Optional Desktop shortcut remains unchecked by default.
- Adds an optional **Start RTL tray controller with Windows** task, unchecked by default.
- Installer offers to start the tray controller after installation.
- Uninstall stops the tray controller before files are removed.
- The existing manual Claude step remains: in a fresh session enable
  **Developer → Enable Main Process Debugger** before runtime injection completes.

The tray controller is user-mode only and does not require Administrator privileges.
No app.asar patching or MSIX re-signing is introduced.
