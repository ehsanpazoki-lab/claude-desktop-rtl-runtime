@echo off
setlocal EnableExtensions
title Disable Claude RTL + Vazirmatn
chcp 65001 >nul

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Disable-Claude-RTL.ps1"
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (
  echo Disable completed.
) else (
  echo Disable exited with code %RC%.
)

pause
exit /b %RC%
