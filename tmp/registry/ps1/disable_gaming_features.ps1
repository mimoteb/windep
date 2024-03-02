Write-Host 'Turning off game mode notification'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\GameBar") -ne $true) {  New-Item "HKCU:\Software\Microsoft\GameBar" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\GameBar' -Name 'ShowGameModeNotifications' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;

Write-Host 'Turning off game bar tips'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\GameBar") -ne $true) {  New-Item "HKCU:\Software\Microsoft\GameBar" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\GameBar' -Name 'ShowStartupPanel' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;

Write-Host 'Disabling open xbox game bar using xbox button on game controller'
if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\GameBar") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\GameBar" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\GameBar' -Name 'UseNexusForGameBarEnabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;

Write-Host 'Turning off Gamebar'
if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR") -ne $true) {  New-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKCU:\System\GameConfigStore") -ne $true) {  New-Item "HKCU:\System\GameConfigStore" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;

Write-Host 'Turning off Game mode'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\GameBar") -ne $true) {  New-Item "HKCU:\Software\Microsoft\GameBar" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\GameBar' -Name 'AllowAutoGameMode' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;

# it is a good idea here to remove XBOX packages from the system