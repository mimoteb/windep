Write-Host 'disabling recently added apps list on startup menu'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'HideRecentlyAddedApps' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;
