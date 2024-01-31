if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
$FileName = $env:TEMP + "\servereye.exe"
$Link = "https://occ.server-eye.de/download/se/ServerEyeSetup.exe"
$client = new-object System.Net.WebClient
$client.DownloadFile($Link, $FileName)
& $FileName /install /passive /norestart