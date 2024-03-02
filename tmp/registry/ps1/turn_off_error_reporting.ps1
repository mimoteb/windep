Write-Host 'Turning off Windows error reporting for current user'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\Windows Error Reporting") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;

Write-Host 'Turning off Windows reporting for all users'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting' -Name 'Disabled' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;