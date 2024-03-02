Write-Host 'Setting Never feedback frequency'
if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Siuf\Rules") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'NumberOfSIUFInPeriod' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
Remove-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules' -Name 'PeriodInNanoSeconds' -Force -ErrorAction Continue;
