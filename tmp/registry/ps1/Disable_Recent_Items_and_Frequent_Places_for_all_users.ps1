Write-Host 'disabling recent items and frequent places for all users'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoRecentDocsHistory' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;