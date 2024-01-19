@echo off
powershell.exe -File "%~dp0DanskSprogpakke.ps1"
if %errorlevel% neq 0 (
    echo PowerShell script exited with error. Terminating batch process.
    exit /b %errorlevel%
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0O365.ps1"
if %errorlevel% neq 0 (
    echo PowerShell script exited with error. Terminating batch process.
    exit /b %errorlevel%
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0GetHash.ps1"
if %errorlevel% neq 0 (
    echo PowerShell script exited with error. Terminating batch process.
    exit /b %errorlevel%
)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0UpdateOS.ps1"
if %errorlevel% neq 0 (
    echo PowerShell script exited with error. Terminating batch process.
    exit /b %errorlevel%
)
powershell.exe -Command "Write-Host 'Genstarter maskinen om 60 sekunder' -Foregroundcolor Red"
shutdown /r /t 60
