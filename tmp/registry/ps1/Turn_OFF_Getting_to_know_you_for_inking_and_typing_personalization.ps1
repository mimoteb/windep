Write-Host 'Turning off getting to know you for inking and typing personalization'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\InputPersonalization") -ne $true) {  New-Item "HKCU:\Software\Microsoft\InputPersonalization" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore") -ne $true) {  New-Item "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -force -ErrorAction Continue };
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Personalization\Settings") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Personalization\Settings" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
