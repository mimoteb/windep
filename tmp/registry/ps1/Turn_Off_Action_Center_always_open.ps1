Write-Host 'Turning off Action center always open'
if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher") -ne $true) {  New-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher" -force -ErrorAction Continue };
Remove-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell\Launcher' -Name 'DisableLightDismiss' -Force -ErrorAction Continue;
