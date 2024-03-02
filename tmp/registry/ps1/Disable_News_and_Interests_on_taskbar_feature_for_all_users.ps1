Write-Host 'Disabling News and interests on taskbar feature for all users'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests" -force -ErrorAction Continue};
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -force -ErrorAction Continue};
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests' -Name 'value' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds' -Name 'EnableFeeds' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
