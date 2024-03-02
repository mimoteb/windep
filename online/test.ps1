write-host 'this file is only for beta testing'
New-Item -ItemType Directory -Path "$env:TEMP\dep" -Force -ErrorAction SilentlyContinue | Out-Null

#Paths
# $Services = Get-Content -Path .\lists\services.lst
# $TaskListPath = ".\lists\tasks.lst"
# $JunkAppxPackages = Get-Content -Path .\lists\AppxPackage.lst
# $JunkWindowsCapabilities = Get-Content -Path .\lists\capabilities.lst
# $JunkAppxProvisionedPackages = get-content -path .\lists\AppxPackage.lst
$bloatware = Join-Path $PSScriptRoot '\features.lst'
write-host $bloatware
