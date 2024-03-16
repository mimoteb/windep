# Reset NTFS Permissions
# Description

$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = (Join-Path $PSDir "\directories.lst")
$Items = Get-Content -Path $JunkPath
foreach($Item in $Items){
    if (Test-Path $Item){
        Write-Host '[Directory] Removing Junk at:' $Item -ForegroundColor Cyan
        Remove-Item -Path $Item -Recurse -Force -ErrorAction SilentlyContinue -Confirm:$false}
    }
    
