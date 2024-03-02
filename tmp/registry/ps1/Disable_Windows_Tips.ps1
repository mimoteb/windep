Write-Host 'Disabling Windows tips'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableSoftLanding' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;
