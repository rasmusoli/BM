Write-host "Installerer Dansk sprogflade" -ForegroundColor Red
Install-Language -Language da-DK -CopyToSettings -Verbose
Sleep 5
Write-host "Sætter sproget til Dansk" -ForegroundColor Red
Set-WinUILanguageOverride -Language da-DK -Verbose
sleep 5
Set-WinUserLanguageList -LanguageList da-DK -Force -Verbose
Write-Host "Sprog sat til Dansk - Genstart før, at det træder i kræft" -ForegroundColor Green