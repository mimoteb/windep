write-host 'removing junk files and directories'

Clear-RecycleBin -Force -Confirm:$false -ErrorAction Continue

# Remove files
$junk_files = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\files.lst')
$junk_files = Get-Content -Path $tempPath
foreach($item in $junk_files){
    Write-Host '[File] Removing Junk at:' $item -ForegroundColor Cyan
    try {Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue} catch {<#Do this if a terminating exception happens#>}
}

# Remove directories
$junkdir_list = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\directories.lst')
$junkdir_list = Get-Content -Path $tempPath
foreach($item in $junkdir_list){
    Write-Host '[Directory] Removing Junk at:' $item -ForegroundColor Cyan
    Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false}


Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction Continue -Confirm:$false

Remove-Item -Path ${env:localappdata}\Microsoft\Edge\'User Data'\Default\Cache -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\CrashDumps -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:appdata}\'Foxit Software'\Addon\'Foxit PhantomPDF'\Install -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\SOUND_FORGE_Audio_Studio_15.0.0.46_x86.exe -Recurse -Force -ErrorAction SilentlyContinue

# cmd sytle
del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*