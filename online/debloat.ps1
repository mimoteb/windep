write-host '[Info] removing bloatwares' -ForegroundColor Yellow

Write-Host 'removing AppxPackage'
$JunkAppxProvisionedPackages = get-content -path .\lists\AppxPackage.lst
foreach ($AppxPackage in $JunkAppxPackages) {
    Write-Host 'Removing:'$AppxPackage
    Remove-AppxPackage -Package $AppxPackage.Trim() -AllUsers -Verbose -ErrorAction SilentlyContinue
}

Write-Host 'removing windows capabilities'
$JunkWindowsCapabilities = Get-Content -Path .\lists\capabilities.lst
foreach ($WindowsCapability in $JunkWindowsCapabilities) {
    Write-Host 'Removing:'$WindowsCapability
    Remove-WindowsCapability -Online -Name $WindowsCapability.Trim() -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'removing windows AppxProvisionedPackage'
foreach($AppxProvisionedPackage in $JunkAppxProvisionedPackages){
    write-host 'Removing:'$AppxProvisionedPackage
    Remove-AppxProvisionedPackage -PackageName $AppxProvisionedPackage.Trim() -Online -Verbose -ErrorAction SilentlyContinue
}

Write-Host 'Processing Optional Features list...'
'\features.lst'
if ((Test-Path $bloatware) -eq $true){
    # Read the list from the file
    $bloatware = Get-Content -Path $bloatware
    foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue} catch {}
    }
}