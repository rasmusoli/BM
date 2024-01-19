@echo off
powershell.exe -File "C:\Windows\Temp\BM-main\DanskSprogpakke.ps1"
if %errorlevel% neq 0 (
    echo PowerShell script exited with error. Terminating batch process.
    taskkill /F /IM cmd.exe
)
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -file .\o365removal\install.ps1
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -file .\GetHash.ps1
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -file .\UpdateOS.ps1
PowerShell.exe Write-Host "Genstarter maskinen om 60 sekunder" -Foregroundcolor Red
PowerShell.exe Restart-Computer  -wait -Timeout 300 -Verbose