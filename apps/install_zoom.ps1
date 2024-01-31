$FileName = $env:TEMP + "\zoom.exe"
$Link = "https://cdn.zoom.us/prod/5.11.11.8425/ZoomInstaller.exe"
Write-Host "File will be downloaded to : " + $FileName
write-host "Zoom wurde in Roaming installiert! ein benutzer anmeldung ist erforderlich!"
$client = new-object System.Net.WebClient
$client.DownloadFile($Link, $FileName)
& $FileName