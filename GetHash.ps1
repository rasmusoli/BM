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

function Handle-Error {
    param(
        [string]$errorMessage = "An error occurred - Please check the log file for more information located at c:\windows\logs\software\"
    )

    [console]::beep()
    [console]::beep()
    [console]::beep()

    # Make the script speak
    Add-Type -TypeDefinition '
    using System.Speech.Synthesis;
    public class Speaker {
        public static void Speak(string text) {
            using (SpeechSynthesizer synth = new SpeechSynthesizer()) {
                synth.Speak(text);
            }
        }
    }' -ReferencedAssemblies 'System.Speech'
    [Speaker]::Speak($errorMessage)
}

## Start Logging
Start-Transcript -Path "$env:Windir\Logs\Software\GetHash.log" -NoClobber -Append

try {
    ## Install NuGet Package Provider
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to install NuGet Package Provider" -ForegroundColor Red
    Stop-Transcript
    Handle-Error -errorMessage "Failed to install NuGet Package Provider"
    exit 1
}

## Add Scripts directory to PATH
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

try {
    ## Set Execution Policy
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to set execution policy" -ForegroundColor Red
    Stop-Transcript
    Handle-Error -errorMessage "Failed to set execution policy"
    exit 1
}

try {
    ## Install Get-WindowsAutopilotInfo script
    Install-Script -Name Get-WindowsAutopilotInfo -Force -ErrorAction Stop
} catch {
    Write-Host "Failed to install Get-WindowsAutopilotInfo script" -ForegroundColor Red
    Stop-Transcript
    Handle-Error -errorMessage "Failed to install Get-WindowsAutopilotInfo script"
    exit 1
}

try {
    ## Get BIOS Serial Number
    $serial = (Get-WmiObject win32_bios | Select-Object Serialnumber).SerialNumber
} catch {
    Write-Host "Failed to get BIOS serial number" -ForegroundColor Red
    Stop-Transcript
    Handle-Error -errorMessage "Failed to get BIOS serial number"
    exit 1
}

try {
    ## Run Get-WindowsAutopilotInfo script
    Get-WindowsAutopilotInfo -OutputFile "$PSScriptRoot\$serial.csv" -ErrorAction Stop
} catch {
    Write-Host "Failed to run Get-WindowsAutopilotInfo script" -ForegroundColor Red
    Stop-Transcript
    Handle-Error -errorMessage "Failed to run Get-WindowsAutopilotInfo script"
    exit 1
}

## Stop Logging
Stop-Transcript