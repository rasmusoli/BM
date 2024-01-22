# BM

## Description

Contains the scripts BM Managed Services use to pre-deploy af laptop with the intend of using it for Microsoft Auto Pilot

## Installation

Copy the repository and launch using "BM-Install.cmd"
Alternatively launch the deployment script which will pull the repo to c:\windows\temp\, expand it and run

```powershell
function Handle-Error {
    param(
        [string]$errorMessage = "An error occurred - Please check the log file for more information located at c:\windows\logs\software\BM-Deploy.log"
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

$repoUrl = "https://github.com/rasmusoli/BM/archive/main.zip"
$repoPath = "C:\Windows\Temp"
$zipPath = Join-Path -Path $repoPath -ChildPath "BM-Deploy.zip"
$installScript = Join-Path -Path $repoPath -ChildPath "BM-Main\BM-Install.cmd"
$csvPath = Join-Path -Path $repoPath -ChildPath "BM-Main"

# Start logging
Start-Transcript -Path "c:\windows\logs\software\BM-Deploy.log" -NoClobber -Append

try {
    # Check internet connectivity
    if (!(Test-Connection -ComputerName "Github.com" -Count 1 -Quiet)) {
        Handle-Error -errorMessage "No internet connection"
        throw "No internet connection"
    }

    # Download the repository
    if (!(Test-Path -Path $zipPath)) {
        Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath
        Handle-error -errorMessage "Failed to download the repository"
        throw "Failed to download the repository"
    }

    # Unzip the repository
    if (!(Test-Path -Path $installScript)) {
        Expand-Archive -Path $zipPath -DestinationPath $repoPath -Force -ErrorAction Stop
        Handle-Error -errorMessage "Failed to unzip the repository"
        Stop-Transcript
        exit 1
    }

    # Run the installation script
    if (Test-Path -Path $installScript) {
        $process = Start-Process -FilePath $installScript -Wait -PassThru
        if ($process.ExitCode -ne 0) {
            throw "Installation script exited with code $($process.ExitCode)"
        }
    } else {
        Handle-Error -errorMessage "Installation script not found at $installScript"
        throw "Installation script not found at $installScript"
        Stop-Transcript
        exit 1
    }

    # Get the serial number
    $serial = (Get-WmiObject win32_bios | Select-Object Serialnumber).SerialNumber

    # Copy .csv files from repo to execution directory
    $csvFile = Join-Path -Path $csvPath -ChildPath "$serial.csv"
    if (Test-Path -Path $csvFile) {
        Copy-Item -Path $csvFile -Destination $PSScriptRoot -Force -ErrorAction Stop
    } else {
        throw "CSV file not found at $csvFile"
    }
} catch {
    Write-Error "An error occurred: $_"
    Stop-Transcript
    exit 1
}

# Remove the repository
Remove-Item -Path $zipPath -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -path (Join-Path -Path $repoPath -ChildPath "BM-Main") -Recurse -Force -ErrorAction SilentlyContinue

# Stop logging
Stop-Transcript


```cmd
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0BM-Deploy.ps1"
Shutdown -r -t 60