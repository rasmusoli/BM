## create log file

# Define the path of the log file
$logFile = "$env:SystemRoot\Logs\Software\DanskSprogPakke.log"

# Check if the directory exists, if not, create it
if(!(Test-Path -Path "$env:SystemRoot\Logs\Software\")) {
    # Create the directory for the log file
    New-Item -ItemType Directory -Force -Path "$env:SystemRoot\Logs\Software\"
}

# Create the log file
New-Item -ItemType File -Path $logFile -Force

# Print a message to the console and write it to the log file
Write-Host "Installerer Dansk sprogflade" -ForegroundColor Red
Add-Content -Path $logFile -Value "Installerer Dansk sprogflade"

# Try to install the Danish language pack
try {
    Install-Language -Language da-DK -CopyToSettings -Verbose
    # If the language pack is installed successfully, write a message to the log file
    Add-Content -Path $logFile -Value "Installed Danish language pack"
} catch {
    # If there's an error, print the error message to the console and write it to the log file
    $errorMessage = "Error installing language: $_"
    Write-Host $errorMessage -ForegroundColor Red
    Add-Content -Path $logFile -Value $errorMessage
    # Exit the script with a non-zero status code to indicate that an error occurred
    exit 1
}

# Pause the script for 5 seconds
Start-Sleep -Seconds 5

# Print a message to the console and write it to the log file
Write-Host "Sætter sproget til Dansk" -ForegroundColor Red
Add-Content -Path $logFile -Value "Sætter sproget til Dansk"

# Try to set the UI language override to Danish
try {
    Set-WinUILanguageOverride -Language da-DK -Verbose
    # If the UI language override is set successfully, write a message to the log file
    Add-Content -Path $logFile -Value "Set UI language override to Danish"
} catch {
    # If there's an error, print the error message to the console and write it to the log file
    $errorMessage = "Error setting UI language override: $_"
    Write-Host $errorMessage -ForegroundColor Red
    Add-Content -Path $logFile -Value $errorMessage
    # Exit the script with a non-zero status code to indicate that an error occurred
    exit 1
}

# Pause the script for 5 seconds
Start-Sleep -Seconds 5

# Try to set the user language list to Danish
try {
    Set-WinUserLanguageList -LanguageList da-DK -Force -Verbose
    # If the user language list is set successfully, write a message to the log file
    Add-Content -Path $logFile -Value "Set user language list to Danish"
} catch {
    # If there's an error, print the error message to the console and write it to the log file
    $errorMessage = "Error setting user language list: $_"
    Write-Host $errorMessage -ForegroundColor Red
    Add-Content -Path $logFile -Value $errorMessage
    # Exit the script with a non-zero status code to indicate that an error occurred
    exit 1
}