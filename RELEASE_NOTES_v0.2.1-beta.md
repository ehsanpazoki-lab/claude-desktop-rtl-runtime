# v0.2.1-beta

UX and stability refinement release.

- Adds original community icons for Setup, Start Menu, Desktop, and system tray.
- The icon artwork uses a generic RTL speech-bubble motif and does not reproduce official vendor logos.
- Installer metadata now identifies the maintainer as **Ehsan Pazoki (`ehsanpazoki-lab`)** and links to the GitHub profile, repository, issues, and releases.
- Adds an explicit installer choice for whether the RTL controller should appear in the system tray after installation.
- Tray auto-start with Windows remains a separate optional choice and is unchecked by default.
- Upgrade installs delete the legacy Startup shortcut first, so the user's new tray/startup choice is respected.
- Claude tray polling is made substantially lighter: the interval is increased and each refresh queries at most two likely renderer targets.
- The standalone Claude Status command also prefers likely renderer targets and stops early once RTL + Vazirmatn are confirmed.

The existing manual `Developer → Enable Main Process Debugger` step remains unchanged.
