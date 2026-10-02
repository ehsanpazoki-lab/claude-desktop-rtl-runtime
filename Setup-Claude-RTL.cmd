@echo off
setlocal
title Setup Claude RTL Runtime
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Setup-Claude-RTL.ps1"
set "RC=%ERRORLEVEL%"
echo.
if not "%RC%"=="0" pause
exit /b %RC%
