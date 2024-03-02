Write-Host 'Turning off relevant Ads'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
