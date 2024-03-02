write-host 'removing junk files and directories'

Clear-RecycleBin -Force -Confirm:$false -ErrorAction Continue

# Remove files
$junk_files = Get-Content -Path ..\lists\files.lst
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

# cmd sytle
echo removing junk files
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*