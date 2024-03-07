write-host '[Info] removing bloatwares' -ForegroundColor Yellow


$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\AppxPackage.lst')

Write-Host 'removing windows AppxProvisionedPackage'

Write-Host '[Info] Processing Optional Features list...' -ForegroundColor Yellow
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\features.lst')
foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue
        Write-Host "[Feature] Disabling "$item.Trim()} catch {}
    }