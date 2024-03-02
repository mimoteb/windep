#Remove AppxPackage
Write-Host 'removing AppxPackage'

foreach ($AppxPackage in $JunkAppxPackages) {
    Write-Host 'Removing:'$AppxPackage
    Remove-AppxPackage -Package $AppxPackage.Trim() -AllUsers -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'restart the computer'




#Remove Windows Capabilities
Write-Host 'removing windows capabilities'

foreach ($WindowsCapability in $JunkWindowsCapabilities) {
    Write-Host 'Removing:'$WindowsCapability
    Remove-WindowsCapability -Online -Name $WindowsCapability.Trim() -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'restart the computer'



foreach($AppxProvisionedPackage in $JunkAppxProvisionedPackages){
    write-host 'Removing:'$AppxProvisionedPackage
    Remove-AppxProvisionedPackage -PackageName $AppxProvisionedPackage.Trim() -Online -Verbose -ErrorAction SilentlyContinue
}
Write-Host 'restart the computer'




Write-Host 'Processing Optional Features list...'

if ((Test-Path $bloatware) -eq $true){
    # Read the list from the file
    $bloatware = Get-Content -Path $bloatware
    foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue} catch {}
    }
}

# example execute in a new window and wait for the process to end.
#start /wait powershell.exe -File "c:\windows\setup\scripts\remove_bloatware.ps1"