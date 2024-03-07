write-host '[Info] removing bloatwares' -ForegroundColor Yellow


$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\AppxPackage.lst')

Write-Host 'removing windows AppxProvisionedPackage'

