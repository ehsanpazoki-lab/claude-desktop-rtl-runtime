# Changelog

## 0.2.0-beta

- Add a lightweight Windows system-tray controller with Enable/Disable/Status.
- Add dedicated Claude RTL status scripts.
- Create explicit Start Menu folder shortcuts for Run, Disable, Status, Tray, docs, and Uninstall.
- Add optional tray auto-start with Windows and automatic tray shutdown during uninstall.


## 0.1.1-beta

- Adds optional Desktop shortcut task to the Windows installer (unchecked by default).
- Makes installer version/output naming derive from the release tag.
- Keeps RTL runtime behavior unchanged from 0.1.0-beta.


## 0.1.0-beta

- First public beta wrapper.
- Pins a tested Claude RTL Companion commit.
- Adds one-click Windows launcher.
- Adds runtime Vazirmatn injection for RTL text.
- Adds live runtime restore/disable when the Main Process Debugger is available.
- Avoids app.asar/MSIX modification.
