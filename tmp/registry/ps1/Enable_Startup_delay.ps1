Write-Host 'enabling startup delay'
if((Test-Path -LiteralPath "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize") -ne $true) {  New-Item "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" -force -ErrorAction Continue };
Remove-ItemProperty -LiteralPath 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize' -Name 'Startupdelayinmsec' -Force -ErrorAction Continue;
