# Description
Write-Host '[AppxPackages] Removal started' -ForegroundColor Yellow
$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'AppxPackages.lst'
$JunkItems = Get-Content -Path $JunkPath -ErrorAction SilentlyContinue
foreach ($item in $JunkItems) {
    $item = $item.Trim()

    try {
        Write-Host ('[AppxPackage] Removing {0}' -f $item) -ForegroundColor Cyan
        Get-AppxPackage -all *$item* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxPackage -all *$item* | Remove-AppPackage -ErrorAction SilentlyContinue
        # WRONG: Remove-AppxPackage -Package $item -AllUsers -ErrorAction SilentlyContinue
        
    } catch {Write-Host "[$item]: Failed to remove $item - $_" -ForegroundColor Red}

    try {
        Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -match [regex]::Escape($item) } | Remove-AppxProvisionedPackage -AllUsers -ErrorAction SilentlyContinue
    } catch {Write-Host "[$item]: Failed to remove - $_" -ForegroundColor Red}
}

