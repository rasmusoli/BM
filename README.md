# BM

## Description

Contains the scripts BM Managed Services use to pre-deploy af laptop with the intend of using it for Microsoft Auto Pilot

## Installation

Copy the repository and launch using "BM-Install.cmd"
Alternatively launch the deployment script which will pull the repo to c:\windows\temp\, expand it and run

```powershell
# Download the zip file
Invoke-WebRequest -Uri 'https://codeload.github.com/rasmusoli/BM/zip/refs/heads/main' -OutFile "$env:SystemRoot\Temp\BM-main.zip"

# Extract the zip file
Expand-Archive -Path "$env:SystemDrive\Temp\BM-main.zip" -DestinationPath "$env:SystemRoot\Temp\" -verbose
Start-Process -file $env:SystemRoot\Temp\BM-main\BM-Install.cmd