## create log file

$logFile = "$env:SystemRoot\Logs\Software\DanskSprogPakke.log"

# Check if the directory exists, if not, create it
if(!(Test-Path -Path "$env:SystemRoot\Logs\Software\")) {
    New-Item -ItemType Directory -Force -Path "$env:SystemRoot\Logs\Software\"
}

# Create the log file
New-Item -ItemType File -Path $logFile -Force


Write-Host "Installerer Dansk sprogflade" -ForegroundColor Red
Add-Content -Path $logFile -Value "Installerer Dansk sprogflade"

try {
    Install-Language -Language da-DK -CopyToSettings -Verbose
    Add-Content -Path $logFile -Value "Installed Danish language pack"
} catch {
    $errorMessage = "Error installing language: $_"
    Write-Host $errorMessage -ForegroundColor Red
    Add-Content -Path $logFile -Value $errorMessage
    exit 1
}

Start-Sleep -Seconds 5

Write-Host "Sætter sproget til Dansk" -ForegroundColor Red
Add-Content -Path $logFile -Value "Sætter sproget til Dansk"

try {
    Set-WinUILanguageOverride -Language da-DK -Verbose
    Add-Content -Path $logFile -Value "Set UI language override to Danish"
} catch {
    $errorMessage = "Error setting UI language override: $_"
    Write-Host $errorMessage -ForegroundColor Red
    Add-Content -Path $logFile -Value $errorMessage
    exit 1
}

Start-Sleep -Seconds 5

try {
    Set-WinUserLanguageList -LanguageList da-DK -Force -Verbose
    Add-Content -Path $logFile -Value "Set user language list to Danish"
} catch {
    $errorMessage = "Error setting user language list: $_"
    Write-Host $errorMessage -ForegroundColor Red
    Add-Content -Path $logFile -Value $errorMessage
    exit 1
}

$successMessage = "Sprog sat til Dansk - Genstart før, at det træder i kræft"
Write-Host $successMessage -ForegroundColor Green
Add-Content -Path $logFile -Value $successMessage