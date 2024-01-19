## Start Logging
Start-Transcript -Path "$env:windir\logs\software\O365-Log.txt"

## Declare Arguments
$ArgsO365Install = "/Configure .\Install.xml"
#$ArgsO365Uninstall = "/Configure .\Uninstall.xml"

## Create Temp Directory
$Folder = "$env:windir\temp\o365"
New-Item -ItemType Directory -Path $folder
Copy-Item -Path "$psscriptroot\Install.xml" -Destination $folder
#Copy-Item -Path ".\UnInstall.xml" -Destination $folder

## Download ODT Setup
$ProgressPreference = 'SilentlyContinue'
function Get-ODTUri {
 
    [CmdletBinding()]
    [OutputType([string])]
    param ()
 
    $url = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=49117"
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $url -ErrorAction SilentlyContinue
    }
    catch {
        Throw "Failed to connect to ODT: $url with error $_."
        Break
    }
    finally {
        $ODTUri = $response.links | Where-Object {$_.outerHTML -like "*click here to download manually*"}
        Write-Output $ODTUri.href
    }
}

$URL = $(Get-ODTUri)
Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $folder\ODT.EXE
Set-Location $Folder

## Extract Installer
Start-Process .\ODT.exe -ArgumentList "/QUIET /EXTRACT:.\" -Wait

## Start Installation
#Start-process .\setup.exe -Argumentlist $ArgsO365Uninstall -wait
Start-process .\setup.exe -Argumentlist $ArgsO365Install -wait

## Cleanup
Set-Location C:\
Remove-Item $Folder -Recurse -Force

## Stop Logning
Stop-Transcript
