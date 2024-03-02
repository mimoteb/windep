Write-Host 'Turning off multilingual text prediction'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Input\Settings") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Input\Settings" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Input\Settings' -Name 'MultilingualEnabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
