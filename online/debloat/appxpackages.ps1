Write-Host '[AppxPackages] Removal started' -ForegroundColor Yellow
$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'AppxPackage.lst'
$JunkItems = Get-Content -Path $JunkPath -ErrorAction SilentlyContinue
foreach ($item in $JunkItems) {
    $item = $item.Trim()

    try {
        Get-AppxPackage -all *$item* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
        Get-AppxPackage -all *$item* | Remove-AppPackage -ErrorAction Continue
        # WRONG: Remove-AppxPackage -Package $item -AllUsers -ErrorAction SilentlyContinue
        Write-Host "[Success] AppxPackag removed: $item" -ForegroundColor Green
    } catch {
        Write-Host "[Error]: Failed to remove $item - $_" -ForegroundColor Red
    }

    try {
        Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -match [regex]::Escape($item) } | Remove-AppxProvisionedPackage -AllUsers -ErrorAction SilentlyContinue
        Write-Host "[Success] removed provisioned package: $item" -ForegroundColor Green
    } catch {
        Write-Host "[Error]: Failed to remove $item - $_" -ForegroundColor Red
    }
}