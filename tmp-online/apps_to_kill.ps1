# these apps can be killed before the processing so it will not make the computer slow.
Write-Host '[INFO] Stopping Windows Defender' -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $true -Force

write-host '[INFO] Stopping Windows Update...' -ForegroundColor Cyan
net stop WUAUSERV

write-host '[INFO] Stopping oneDrive' -foregroundcolor cyan
taskkill /f /im onedrive.exe