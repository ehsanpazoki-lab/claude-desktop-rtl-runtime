#define MyAppName "Claude Desktop RTL Runtime"
#ifndef MyAppVersion
#define MyAppVersion "0.1.1-beta"
#endif
#define MyAppPublisher "Community project"
#define MyAppURL "https://github.com/"

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

[Files]
Source: "..\Claude-RTL-Run.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Claude-RTL-Run.ps1"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Disable-Claude-RTL.cmd"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\Disable-Claude-RTL.ps1"; DestDir: "{app}"; Flags: ignoreversion
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
Name: "{group}\Claude RTL"; Filename: "{app}\Claude-RTL-Run.cmd"; WorkingDir: "{app}"
Name: "{group}\Disable Claude RTL"; Filename: "{app}\Disable-Claude-RTL.cmd"; WorkingDir: "{app}"
Name: "{group}\Documentation (English)"; Filename: "{app}\README.md"
Name: "{group}\مستندات فارسی"; Filename: "{app}\README.fa.md"

[Run]
Filename: "{app}\Claude-RTL-Run.cmd"; Description: "Launch Claude with RTL + Vazirmatn"; Flags: postinstall skipifsilent nowait
