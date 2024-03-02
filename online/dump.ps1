. .\config.ps1
# Online
Get-AppxProvisionedPackage -Online | Select-Object -ExpandProperty PackageName | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } > .\lists\Get_Online_ProvisionedPackages.lst
Get-WindowsCapability -Online | Select-Object -ExpandProperty Name | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } > get_online_capabilities.lst
Get-WindowsOptionalFeature -Online | Select-Object -ExpandProperty FeatureName | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' } > get_online_features.lst

Get-Service | Select-Object Name, DisplayName > online_services.lst