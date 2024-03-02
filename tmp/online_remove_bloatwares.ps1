
Write-Host 'Disabling Task Scheduler Tasks'
#$TaskListPath = ".\lists\tasks.lst"
$Bloatwares = (Invoke-WebRequest "http://mimoteb.synology.me/windows/deployment/lists/tasks.lst").ToString()

# Read the file line by line
Get-Content $Bloatwares | ForEach-Object {
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

#Remove AppxPackage
Write-Host 'removing AppxPackage'
#$Bloatwares = Get-Content -Path .\lists\AppxPackage.lst
Bloatwares = (Invoke-WebRequest "http://mimoteb.synology.me/windows/deployment/lists/AppxPackage.lst").ToString()
foreach ($item in $Bloatwares) {
    Write-Host 'Removing:'$item
    Remove-AppxPackage -Package $item.Trim() -AllUsers -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'restart the computer'




#Remove Windows Capabilities
Write-Host 'removing windows capabilities'
#$JunkWindowsCapabilities = Get-Content -Path .\lists\capabilities.lst
$Bloatwares = (Invoke-WebRequest "http://mimoteb.synology.me/windows/deployment/lists/tasks.lst").ToString()
foreach ($item in $Bloatwares) {
    Write-Host 'Removing:'$item
    Remove-WindowsCapability -Online -Name $item.Trim() -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'restart the computer'



$Bloatwares = get-content -path .\lists\AppxPackage.lst
foreach($item in $Bloatwares){
    write-host 'Removing:'$item
    Remove-AppxProvisionedPackage -PackageName $item.Trim() -Online -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'restart the computer'




Write-Host 'Processing Optional Features list...'
$Bloatwares = '.\lists\features.lst' # Path to the list of features to remove
if ((Test-Path $Bloatwares) -eq $true){
    # Read the list from the file
    $Bloatwares = Get-Content -Path $bloatware
    foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue} catch {}
    }
}


# Remove files
$junk_files = Get-Content -Path .\lists\files.lst
foreach($item in $junk_files){
    try {Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue} catch {<#Do this if a terminating exception happens#>}
}

# Remove directories
$junkdir_list = Get-Content -Path .\lists\directories.lst
foreach($item in $junkdir_list){Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false}


Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction Continue -Confirm:$false

Remove-Item -Path ${env:localappdata}\Microsoft\Edge\'User Data'\Default\Cache -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\CrashDumps -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:appdata}\'Foxit Software'\Addon\'Foxit PhantomPDF'\Install -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\SOUND_FORGE_Audio_Studio_15.0.0.46_x86.exe -Recurse -Force -ErrorAction SilentlyContinue

Clear-RecycleBin -Force -Confirm:$false -ErrorAction Continue