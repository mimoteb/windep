write-host 'this file is only for beta testing'
New-Item -ItemType Directory -Path "$env:TEMP\dep" -Force -ErrorAction SilentlyContinue | Out-Null

#Paths
# $Services = Get-Content -Path .\lists\services.lst
# $TaskListPath = ".\lists\tasks.lst"
# $JunkAppxPackages = Get-Content -Path .\lists\AppxPackage.lst
# $JunkWindowsCapabilities = Get-Content -Path .\lists\capabilities.lst
# $JunkAppxProvisionedPackages = get-content -path .\lists\AppxPackage.lst
$bloatware = Join-Path $PSScriptRoot '\features.lst'
write-host $bloatware



# Remove files
$junk_files = Get-Content -Path .\lists\files.lst
foreach($junk_file in $junk_files){
    try {Remove-Item -Path $junk_file -Recurse -Force -ErrorAction SilentlyContinue} catch {<#Do this if a terminating exception happens#>}
}

# Remove directories
$junkdir_list = Get-Content -Path .\lists\directories.lst
foreach($junkdir in $junkdir_list){Remove-Item -Path $junkdir -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false}


Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction Continue -Confirm:$false

Remove-Item -Path ${env:localappdata}\Microsoft\Edge\'User Data'\Default\Cache -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\CrashDumps -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:appdata}\'Foxit Software'\Addon\'Foxit PhantomPDF'\Install -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\SOUND_FORGE_Audio_Studio_15.0.0.46_x86.exe -Recurse -Force -ErrorAction SilentlyContinue

Clear-RecycleBin -Force -Confirm:$false -ErrorAction Continue