write-host '[Info] removing bloatwares' -ForegroundColor Yellow

Write-Host '[Info] Removing AppxPackages' -ForegroundColor Yellow
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\AppxPackage.lst')
$items = Get-Content -Path $tempPath

foreach ($item in $items) {
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

Write-Host '[Info] removing windows capabilities' -ForegroundColor Yellow
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\capabilities.lst')
$items = Get-Content -Path $tempPath
foreach ($item in $items) {
    Write-Host '[Capability] Removing:'$item -ForegroundColor Cyan
    Remove-WindowsCapability -Online -Name $item.Trim() -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'removing windows AppxProvisionedPackage'

Write-Host '[Info] Processing Optional Features list...' -ForegroundColor Yellow
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\features.lst')
foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue
        Write-Host "[Feature] Disabling "$item.Trim()} catch {}
    }