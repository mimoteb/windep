Write-Host 'Turning off Aero snap'
if((Test-Path -LiteralPath "HKCU:\Control Panel\Desktop") -ne $true) {  New-Item "HKCU:\Control Panel\Desktop" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop' -Name 'WindowArrangementActive' -Value '0' -PropertyType String -Force -ErrorAction Continue;