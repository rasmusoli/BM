<#
.SYNOPSIS
This script installs necessary packages and scripts, retrieves the BIOS serial number, and runs the Get-WindowsAutopilotInfo script.

.DESCRIPTION
The script performs the following steps:
1. Starts a transcript for logging.
2. Installs the NuGet package provider.
3. Adds the Scripts directory to the PATH environment variable.
4. Sets the execution policy to RemoteSigned for the current process.
5. Installs the Get-WindowsAutopilotInfo script.
6. Retrieves the BIOS serial number.
7. Runs the Get-WindowsAutopilotInfo script and outputs the information to a CSV file.
8. If any of the steps fail, the script writes an error message, stops the transcript, and exits with a non-zero status code.

.NOTES
Make sure to run this script with administrative privileges to avoid permission issues.
#>

## Start Logging
Start-Transcript -Path "$env:Windir\Logs\Software\GetHash.log" -NoClobber -Append

try {
    ## Install NuGet Package Provider
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to install NuGet Package Provider: $_" -ForegroundColor Red
    Stop-Transcript
    exit 1
}

## Add Scripts directory to PATH
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

try {
    ## Set Execution Policy
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to set execution policy: $_" -ForegroundColor Red
    Stop-Transcript
    exit 1
}

try {
    ## Install Get-WindowsAutopilotInfo script
    Install-Script -Name Get-WindowsAutopilotInfo -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to install Get-WindowsAutopilotInfo script: $_" -ForegroundColor Red
    Stop-Transcript
    exit 1
}

try {
    ## Get BIOS Serial Number
    $serial = (Get-WmiObject win32_bios | select Serialnumber).SerialNumber
} catch {
    Write-Host "Failed to get BIOS serial number: $_" -ForegroundColor Red
    Stop-Transcript
    exit 1
}

try {
    ## Run Get-WindowsAutopilotInfo script
    Get-WindowsAutopilotInfo -OutputFile "$PSScriptRoot\$serial.csv" -ErrorAction Stop
} catch {
    Write-Host "Failed to run Get-WindowsAutopilotInfo script: $_" -ForegroundColor Red
    Stop-Transcript
    exit 1
}

## Stop Logging
Stop-Transcript