Write-Host 'disabling open news and interests on hover'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarOpenOnHover' -Value 0 -PropertyType DWord -Force -ErrorAction Continue;
