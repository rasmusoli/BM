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
Start-Transcript -Path "$env:windir\logs\software\O365-Log.txt"

## Declare Arguments
$ArgsO365Install = "/Configure .\Install.xml"

## create folder for O365
$Folder = "$env:windir\temp\o365"
New-Item -ItemType Directory -Path $folder -verbose

## Copy .xml contents to folder
Copy-Item -Path "$psscriptroot\Install.xml" -Destination $folder -Verbose

## Download ODT Setup
$ProgressPreference = 'SilentlyContinue'
function Get-ODTUri {
 
    [CmdletBinding()]
    [OutputType([string])]
    param ()
 
    $url = "https://www.microsoft.com/en-us/download/confirmation.aspx?id=49117"
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $url -ErrorAction SilentlyContinue -verbose
    }
    catch {
        Handle-Error -errorMessage "Failed to connect to ODT: $url with error $_."
        Throw "Failed to connect to ODT: $url with error $_."
        Break
    }
    finally {
        $ODTUri = $response.links | Where-Object {$_.outerHTML -like "*click here to download manually*"}
        Write-Output $ODTUri.href
    }
}

## Attempt to download the ODT files
try {
    $URL = $(Get-ODTUri)
    Invoke-WebRequest -UseBasicParsing -Uri $url -OutFile $folder\ODT.EXE -Verbose
} catch {
    Write-Host "Failed to download ODT file: $_" -ForegroundColor Red
    Handle-Error -errorMessage "Failed to download ODT file"
    exit 1
}

Set-Location $Folder -Verbose

## Extract Installer
try {
    Start-Process .\ODT.exe -ArgumentList "/QUIET /EXTRACT:.\" -Wait -Verbose
} catch {
    Handle-Error -errorMessage "Failed to extract installer"
    Write-Host "Failed to extract installer: $_" -ForegroundColor Red
    exit 1
}

## Start Installation
try {
    Start-process .\setup.exe -Argumentlist $ArgsO365Install -wait -Verbose
} catch {
    Handle-Error -errorMessage "Failed to start installation"
    Write-Host "Failed to start installation: $_" -ForegroundColor Red
    exit 1
}

## Cleanup
Set-Location $env:windir -Verbose
try {
    Remove-Item $Folder -Recurse -Force -Verbose -ErrorAction Stop
} catch {
    Write-Host "Failed to remove O365 Folder" -ForegroundColor Red
    Handle-Error -errorMessage "Failed to remove O365 Folder"
    exit 1
}

# stop logging
Stop-Transcript