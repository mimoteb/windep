Write-Host 'disabling scaling'
if((Test-Path -LiteralPath "HKCU:\Control Panel\Desktop") -ne $true) {  New-Item "HKCU:\Control Panel\Desktop" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop") -ne $true) {  New-Item "HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Policies\Microsoft\Windows\Display") -ne $true) {  New-Item "HKCU:\Software\Policies\Microsoft\Windows\Display" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Display") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Display" -force -ErrorAction Continue };
Remove-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'EnablePerProcessSystemDPI' -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\Control Panel\Desktop' -Name 'EnablePerProcessSystemDPI' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\Display' -Name 'EnablePerProcessSystemDPIForProcesses' -Value '' -PropertyType String -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Policies\Microsoft\Windows\Display' -Name 'DisablePerProcessSystemDPIForProcesses' -Value '' -PropertyType String -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop' -Name 'EnablePerProcessSystemDPI' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Display' -Name 'EnablePerProcessSystemDPIForProcesses' -Force -ErrorAction Continue;
Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Display' -Name 'DisablePerProcessSystemDPIForProcesses' -Force -ErrorAction Continue;
