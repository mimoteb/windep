$FileName = $env:TEMP + "\Telegram.exe"
$Link = "https://telegram.org/dl/desktop/win64"
Write-Host "File will be downloaded to : " + $FileName
$client = new-object System.Net.WebClient
$client.DownloadFile($Link, $FileName)
& $FileName /SILENT /SURPRESSMSGBOXES /NORESTART /LANG=de