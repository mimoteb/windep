# these apps can be killed before the processing so it will not make the computer slow.
Write-Host '[Windows Defender] Stopping Windows Defender' -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $true -Force

write-host '[Windows Update] Stopping Windows Update...' -ForegroundColor Cyan
net stop WUAUSERV

write-host '[OneDrive] Stopping oneDrive' -ForegroundColor Cyan
taskkill /f /im onedrive.exe