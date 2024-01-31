if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
$FileName = $env:TEMP + "\asana.exe"
$Link = "https://desktop-downloads.asana.com/win32_x64/prod/latest/AsanaSetup.exe"
Write-Host "File will be downloaded to : " + $FileName
write-host "Asana wurde in Roaming installiert! ein benutzer anmeldung ist erforderlich!"
$client = new-object System.Net.WebClient
$client.DownloadFile($Link, $FileName)
& $FileName
# or winget install asana.asana --force --silent
