Write-Host 'Turning off improve inking and typing recognition'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Input\TIPC") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Input\TIPC" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Input\TIPC' -Name 'Enabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
