# fetch the files from github repo and then execute them

#Paths


write-host 'Turning on hibernation'
powercfg /hibernate on

write-host 'Disable password expiration'
net accounts /maxpwage:unlimited

write-host 'setting power settings'
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-dc 5
powercfg /change standby-timeout-dc 5

write-host 'stopping windows update service'
net stop WUAUSERV

write-host 'stopping oneDrive'
taskkill /f /im onedrive.exe


