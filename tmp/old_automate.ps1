# fetch the files from github repo and then execute them


write-host 'this script is being called from github.com/mimoteb'
write-host 'written by Solomon Samuel'

write-host 'creating base directory in $env:TEMP\dep'
New-Item -ItemType Directory -Path "$env:TEMP\dep"
#Paths
$TaskListPath = ".\lists\tasks.lst"

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


Write-Host 'Disabling Task Scheduler Tasks'


# Read the file line by line
Get-Content $TaskListPath | ForEach-Object {
    # Split each line into path and task name using "\" as the delimiter
    $parts = $_.Trim() -split "\\"

    # Check if there are at least two parts (path and task name)
    if ($parts.Length -ge 2) {
        # Extract the path and task name
        $taskPath = $parts[0..($parts.Length - 2)] -join "\"
        $taskName = $parts[-1]

        # Disable the task using the task path
        Disable-ScheduledTask -TaskPath $taskPath -TaskName $taskName
    }
    else {
        Write-Host "Invalid line: $_"
    }

}


Write-Host 'restart the computer'






# example execute in a new window and wait for the process to end.
#start /wait powershell.exe -File "c:\windows\setup\scripts\remove_bloatware.ps1"