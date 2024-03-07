# Description

# Remove files
$junk_files = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\files.lst')
$junk_files = Get-Content -Path $tempPath
foreach($item in $junk_files){
    Write-Host '[File] Removing Junk at:' $item -ForegroundColor Cyan
    try {Remove-Item -Path $item -Recurse -Force -ErrorAction SilentlyContinue} catch {<#Do this if a terminating exception happens#>}
}
# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue