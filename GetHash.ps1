Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
Install-Script -Name Get-WindowsAutopilotInfo -Force
$serial = (Get-WmiObject win32_bios | select Serialnumber).SerialNumber
Get-WindowsAutopilotInfo -OutputFile $psscriptroot\$serial.csv