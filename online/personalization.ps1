write-host 'Turning on hibernation'
powercfg /hibernate on

write-host 'Disable password expiration'
net accounts /maxpwage:unlimited

write-host 'setting power settings'
powercfg /change monitor-timeout-ac 0
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-dc 5
powercfg /change standby-timeout-dc 5

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue