Write-Host 'Turning off enchance pointer precision'
if((Test-Path -LiteralPath "HKCU:\Control Panel\Mouse") -ne $true) {  New-Item "HKCU:\Control Panel\Mouse" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -Value '0' -PropertyType String -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -Value '0' -PropertyType String -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -Value '0' -PropertyType String -Force -ErrorAction Continue;