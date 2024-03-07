# Description
Write-Host '[Windows Capabilities] Removal started' -ForegroundColor Yellow

$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'Capabilities.lst'
$JunkItems = Get-Content -Path $JunkPath

foreach ($item in $JunkItems) {
    Write-Host '[Capability] Removing:'$item -ForegroundColor Cyan
    Remove-WindowsCapability -Online -Name $item.Trim() -Verbose -ErrorAction SilentlyContinue
}

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue