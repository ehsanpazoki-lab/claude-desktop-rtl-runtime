#define MyAppName "Claude Desktop RTL Runtime"
#ifndef MyAppVersion
#define MyAppVersion "0.2.0-beta"
#endif
#define MyAppPublisher "Community project"
#define MyAppURL "https://github.com/ehsanpazoki-lab/claude-desktop-rtl-runtime"
#define StartMenuFolder "{userprograms}\Claude Desktop RTL Runtime"

[Setup]
AppId={{9D5A70AC-4036-44A3-AF7C-812789F4DF61}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
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
UninstallDisplayName={#MyAppName}
CloseApplications=no
SetupLogging=yes

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "traystartup"; Description: "Start RTL tray controller with Windows"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
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
Name: "{userdesktop}\Claude RTL"; Filename: "{app}\Claude-RTL-Run.cmd"; WorkingDir: "{app}"; Tasks: desktopicon

Name: "{#StartMenuFolder}\Claude RTL"; Filename: "{app}\Claude-RTL-Run.cmd"; WorkingDir: "{app}"
Name: "{#StartMenuFolder}\Disable Claude RTL"; Filename: "{app}\Disable-Claude-RTL.cmd"; WorkingDir: "{app}"
Name: "{#StartMenuFolder}\Claude RTL Status"; Filename: "{app}\Status-Claude-RTL.cmd"; WorkingDir: "{app}"
Name: "{#StartMenuFolder}\RTL Tray Controller"; Filename: "{app}\Claude-RTL-Tray.cmd"; WorkingDir: "{app}"
Name: "{#StartMenuFolder}\Documentation (English)"; Filename: "{app}\README.md"
Name: "{#StartMenuFolder}\مستندات فارسی"; Filename: "{app}\README.fa.md"
Name: "{#StartMenuFolder}\Uninstall Claude Desktop RTL Runtime"; Filename: "{uninstallexe}"

Name: "{userstartup}\Claude RTL Tray Controller"; Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\Claude-RTL-Tray.ps1"""; WorkingDir: "{app}"; Tasks: traystartup

[Run]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\Claude-RTL-Tray.ps1"""; Description: "Start Claude RTL tray controller"; Flags: postinstall nowait skipifsilent

[UninstallRun]
Filename: "{sys}\WindowsPowerShell\v1.0\powershell.exe"; Parameters: "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File ""{app}\Stop-Claude-RTL-Tray.ps1"""; Flags: runhidden waituntilterminated
