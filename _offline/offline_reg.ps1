Write-Host 'modifying registry values'

REG LOAD HKLM\NTUSER $mount\users\Default\NTUSER.DAT
 
# Removes Task View from the Taskbar
New-itemproperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0" -PropertyType Dword
 
# Removes Widgets from the Taskbar
New-itemproperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value "0" -PropertyType Dword
 
# Removes Chat from the Taskbar
New-itemproperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value "0" -PropertyType Dword
 
# Default StartMenu alignment 0=Left
New-itemproperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value "0" -PropertyType Dword
 
# Removes search from the Taskbar
reg.exe add "HKLM:\NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 0 /f

Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "FeatureManagementEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -Type DWord
Set-ItemProperty "HKLM:\NTUSER\" -Name "" -Value 0 -Type DWord

#Remove OneDriveSetup
Remove-Item "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Run"
REG UNLOAD HKLM\NTUSER