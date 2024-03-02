Write-Host 'Turning off Search web results'
if((Test-Path -LiteralPath "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer") -ne $true) {  New-Item "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -force -ErrorAction Continue };
New-ItemProperty -LiteralPath 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name 'DisableSearchBoxSuggestions' -Value 1 -PropertyType DWord -Force -ErrorAction Continue;
