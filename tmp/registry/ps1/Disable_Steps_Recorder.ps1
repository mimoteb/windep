Write-Host 'disabling steps recorder'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat' -Name 'DisableUAR' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;