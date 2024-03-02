Write-Host 'disabling save taskbar thumbnail previews'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\DWM") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\DWM" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\DWM' -Name 'AlwaysHibernateThumbnails' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
