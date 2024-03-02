write-host 'removing junk files and directories'
$junk_files = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\files.lst')
$junk_files = Get-Content -Path $tempPath

$junkdir_list = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\directories.lst')
$junkdir_list = Get-Content -Path $tempPath

Clear-RecycleBin -Force -Confirm:$false -ErrorAction Continue

# Remove files

foreach($item in $junk_files){
    try {Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue} catch {<#Do this if a terminating exception happens#>}
}

# Remove directories

foreach($item in $junkdir_list){Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false}


Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction Continue -Confirm:$false

Remove-Item -Path ${env:localappdata}\Microsoft\Edge\'User Data'\Default\Cache -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\CrashDumps -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:appdata}\'Foxit Software'\Addon\'Foxit PhantomPDF'\Install -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path ${env:localappdata}\SOUND_FORGE_Audio_Studio_15.0.0.46_x86.exe -Recurse -Force -ErrorAction SilentlyContinue

# cmd sytle
echo removing junk files
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*