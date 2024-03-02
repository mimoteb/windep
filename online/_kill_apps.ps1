write-host 'stopping windows update service'
net stop WUAUSERV

write-host 'stopping oneDrive'
taskkill /f /im onedrive.exe