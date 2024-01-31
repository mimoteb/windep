# fetch the files from github repo and then execute them




write-host 'stopping windows update service'
net stop WUAUSERV

write-host 'stopping oneDrive'
taskkill /f /im onedrive.exe


