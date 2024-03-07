# Description
Write-Host '[AppxPackages] Removal started' -ForegroundColor Yellow
$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'AppxPackages.lst'
$JunkItems = Get-Content -Path $JunkPath -ErrorAction SilentlyContinue
foreach ($item in $JunkItems) {
    $item = $item.Trim()

    try {
        Get-AppxPackage -all *$item* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxPackage -all *$item* | Remove-AppPackage -ErrorAction SilentlyContinue
        # WRONG: Remove-AppxPackage -Package $item -AllUsers -ErrorAction SilentlyContinue
        Write-Host "[$item] AppxPackag removed: $item" -ForegroundColor Green
    } catch {Write-Host "[$item]: Failed to remove $item - $_" -ForegroundColor Red}

    try {
        Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -match [regex]::Escape($item) } | Remove-AppxProvisionedPackage -AllUsers -ErrorAction SilentlyContinue
        Write-Host "[$item] removed" -ForegroundColor Green
    } catch {Write-Host "[$item]: Failed to remove - $_" -ForegroundColor Red}
}

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue