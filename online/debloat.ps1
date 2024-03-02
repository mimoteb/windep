write-host '[Info] removing bloatwares' -ForegroundColor Yellow

Write-Host 'removing AppxPackage'
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\AppxPackage.lst')
$items = Get-Content -Path $tempPath
foreach ($item in $items) {
    Write-Host 'Removing:'$item
    Remove-AppxPackage -Package $item.Trim() -AllUsers -Verbose -ErrorAction SilentlyContinue
    Remove-AppxProvisionedPackage -PackageName $item.Trim() -Online -Verbose -ErrorAction SilentlyContinue
}

Write-Host 'removing windows capabilities'
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\capabilities.lst')
$items = Get-Content -Path $tempPath
foreach ($item in $items) {
    Write-Host 'Removing:'$item
    Remove-WindowsCapability -Online -Name $item.Trim() -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'removing windows AppxProvisionedPackage'
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\capabilities.lst')
$items = Get-Content -Path $tempPath
foreach($item in $items){
    write-host 'Removing:'$item
    Remove-AppxProvisionedPackage -PackageName $item.Trim() -Online -Verbose -ErrorAction SilentlyContinue
}

Write-Host 'Processing Optional Features list...'
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\features.lst')
foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue} catch {}
    }