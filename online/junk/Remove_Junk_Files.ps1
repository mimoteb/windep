# is it correct to use recurse with the files????
# if the file is existed take the ownership and reset ntfs permissions when it can't be deleted
# remove junk files can also be added from the offline deployment like "Send To" items
# Description

# Remove files
$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Junk_files = (Join-Path $PSDir '\Files.lst')
$junk_files = Get-Content -Path $Junk_files
foreach($item in $junk_files){
    Write-Host '[File] Removing Junk at:' $item -ForegroundColor Cyan
    if (Test-Path $item){
        
        try {Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue} catch {}
    }
    
}
