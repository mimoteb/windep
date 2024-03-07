Write-Host '[Windows Capabilities] Removal started' -ForegroundColor Yellow
$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'AppxPackages.lst'

$JunkItems = Get-Content -Path $tempPath

$JunkItems = Get-Content -Path $JunkPath
foreach ($item in $JunkItems) {
    Write-Host '[Capability] Removing:'$item -ForegroundColor Cyan
    Remove-WindowsCapability -Online -Name $item.Trim() -Verbose -ErrorAction SilentlyContinue
}