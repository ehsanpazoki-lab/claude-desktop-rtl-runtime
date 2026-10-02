#define MyAppName "Claude Desktop RTL Runtime"
#ifndef MyAppVersion
#define MyAppVersion "0.2.1-beta"
#endif
#ifndef MyAppFileVersion
#define MyAppFileVersion "0.2.1.0"
#endif
#define MyAppPublisher "Ehsan Pazoki (ehsanpazoki-lab)"
#define MyAppPublisherURL "https://github.com/ehsanpazoki-lab"
#define MyAppURL "https://github.com/ehsanpazoki-lab/claude-desktop-rtl-runtime"
#define MyAppSupportURL "https://github.com/ehsanpazoki-lab/claude-desktop-rtl-runtime/issues"
#define MyAppUpdatesURL "https://github.com/ehsanpazoki-lab/claude-desktop-rtl-runtime/releases"
#define StartMenuFolder "{userprograms}\Claude Desktop RTL Runtime"

[Setup]
AppId={{9D5A70AC-4036-44A3-AF7C-812789F4DF61}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppPublisherURL}
AppSupportURL={#MyAppSupportURL}
AppUpdatesURL={#MyAppUpdatesURL}
DefaultDirName={localappdata}\Programs\Claude Desktop RTL Runtime
DefaultGroupName=Claude Desktop RTL Runtime
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=output
OutputBaseFilename=Claude-Desktop-RTL-Runtime-Setup-v{#MyAppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
LicenseFile=..\LICENSE
SetupIconFile=..\assets\icons\Claude-RTL.ico
UninstallDisplayIcon={app}\assets\icons\Claude-RTL.ico
UninstallDisplayName={#MyAppName}
CloseApplications=no
SetupLogging=yes
VersionInfoCompany=Ehsan Pazoki / ehsanpazoki-lab
VersionInfoDescription={#MyAppName} - community RTL runtime
VersionInfoProductName={#MyAppName}
VersionInfoVersion={#MyAppFileVersion}
VersionInfoTextVersion={#MyAppVersion}
VersionInfoProductVersion={#MyAppFileVersion}
VersionInfoProductTextVersion={#MyAppVersion}

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "tray"; Description: "Show RTL controller in the system tray after installation"; GroupDescription: "System tray:"; Flags: checkedonce
Name: "tray\autostart"; Description: "Start RTL tray controller with Windows"; Flags: unchecked

[Files]
Source: "..\assets\icons\Claude-RTL.ico"; DestDir: "{app}\assets\icons"; Flags: ignoreversion
Source: "..\assets\icons\Claude-RTL-Inactive.ico"; DestDir: "{app}\assets\icons"; Flags: ignoreversion
Source: "..\assets\icons\Claude-RTL.png"; DestDir: "{app}\assets\icons"; Flags: ignoreversion
Source: "..\assets\icons\Claude-RTL-Inactive.png"; DestDir: "{app}\assets\icons"; Flags: ignoreversion
Source: "..\assets\icons\README.md"; DestDir: "{app}\assets\icons"; Flags: ignoreversion
Source: "..\Claude-RTL-Run.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Claude-RTL-Run.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Disable-Claude-RTL.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Disable-Claude-RTL.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Status-Claude-RTL.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Status-Claude-RTL.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Claude-RTL-Tray.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Claude-RTL-Tray.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Stop-Claude-RTL-Tray.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Test-Vazirmatn-Download.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\scripts\Ensure-Vazirmatn.ps1"; DestDir: "{app}\scripts"; Flags: ignoreversion
Source: "staging\assets\Vazirmatn.woff2"; DestDir: "{app}\assets"; Flags: ignoreversion
Source: "staging\vendor\claude-rtl-companion\*"; DestDir: "{app}\vendor\claude-rtl-companion"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "staging\BUILDINFO.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\README.fa.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\INSTALL.fa.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SECURITY.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\SECURITY.fa.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\TROUBLESHOOTING.fa.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\THIRD_PARTY_NOTICES.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\THIRD_PARTY_NOTICES.fa.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{userdesktop}\Claude RTL"; Filename: "{app}\Claude-RTL-Run.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\assets\icons\Claude-RTL.ico"; Tasks: desktopicon

Name: "{#StartMenuFolder}\Claude RTL"; Filename: "{app}\Claude-RTL-Run.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\assets\icons\Claude-RTL.ico"
Name: "{#StartMenuFolder}\Disable Claude RTL"; Filename: "{app}\Disable-Claude-RTL.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\assets\icons\Claude-RTL-Inactive.ico"
Name: "{#StartMenuFolder}\Claude RTL Status"; Filename: "{app}\Status-Claude-RTL.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\assets\icons\Claude-RTL.ico"
Name: "{#StartMenuFolder}\RTL Tray Controller"; Filename: "{app}\Claude-RTL-Tray.cmd"; WorkingDir: "{app}"; IconFilename: "{app}\assets\icons\Claude-RTL.ico"
Name: "{#StartMenuFolder}\Documentation (English)"; Filename: "{app}\README.md"
Name: "{#StartMenuFolder}\مستندات فارسی"; Filename: "{app}\README.fa.md"
Name: "{#StartMenuFolder}\Uninstall Claude Desktop RTL Runtime"; Filename: "{uninstallexe}"

Name: "{userstartup}\Claude RTL Tray Controller"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\Claude-RTL-Tray.ps1"""; WorkingDir: "{app}"; IconFilename: "{app}\assets\icons\Claude-RTL.ico"; Tasks: tray\autostart

[InstallDelete]
Type: files; Name: "{userstartup}\Claude RTL Tray Controller.lnk"

[Run]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\Claude-RTL-Tray.ps1"""; Description: "Start Claude RTL tray controller"; Flags: postinstall nowait skipifsilent; Tasks: tray

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\Stop-Claude-RTL-Tray.ps1"""; Flags: runhidden waituntilterminated
