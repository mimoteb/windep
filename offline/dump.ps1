. .\config.ps1
# Mount
Get-AppxProvisionedPackage -path $mount | Select-Object -ExpandProperty PackageName | ForEach-Object {$_.Trim()} | Where-Object {$_ -ne ''} > .\provisioned.lst
Get-WindowsCapability -Path $mount | Select-Object -ExpandProperty Name | ForEach-Object {$_.Trim()} | Where-Object{$_ -ne ''} > .\capabilities.lst
Get-WindowsOptionalFeature -Path $mount | Select-Object -ExpandProperty FeatureName | ForEach-Object {$_.Trim()} | Where-Object {$_ -ne '' } > .\features.lst
