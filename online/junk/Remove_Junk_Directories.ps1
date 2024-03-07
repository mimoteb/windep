# Check if the directory exists
# Reset NTFS Permissions
# Description

$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = (Join-Path $PSDir "\directories.lst")
$Items = Get-Content -Path $tempPath
foreach($Item in $Items){
    Write-Host '[Directory] Removing Junk at:' $Item -ForegroundColor Cyan
    Remove-Item -Path $Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false}
# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue