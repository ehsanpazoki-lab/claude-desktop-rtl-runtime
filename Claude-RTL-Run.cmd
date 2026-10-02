@echo off
setlocal EnableExtensions
title Claude RTL + Vazirmatn
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Claude-RTL-Run.ps1"
set "RC=%ERRORLEVEL%"
echo.
if "%RC%"=="0" (
  echo Claude RTL finished successfully.
  timeout /t 3 /nobreak >nul
) else (
  echo Launcher exited with code %RC%.
  pause
)
exit /b %RC%
