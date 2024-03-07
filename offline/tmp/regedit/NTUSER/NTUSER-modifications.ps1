#change HKLM:\NtUserOffline\ to HKLM:\NtUserOffline\OFFLINENTUSER\
#reg load HKLM\NtUserOffline W:\mount\Users\Default\NTUSER.DAT
# Disable Cortana
write-host "Disabling Cortana..."
New-Item -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\' -Name 'Windows Search' -Force
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -PropertyType DWORD -Value '0' -Force

# Configure Search Options:
write-host "Configuring Search Options..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -PropertyType DWORD -Value '0' -Force
# Disallow search and Cortana to use location
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'ConnectedSearchUseWeb' -PropertyType DWORD -Value '0' -Force
# Do not allow web search
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'DisableWebSearch' -PropertyType DWORD -Value '0' -Force

write-host "Disallowing the user to change sign-in options.."
New-Item -Path "HKLM:\NtUserOffline\SOFTWARE\Microsoft\PolicyManager\current\device" -Name "Settings" -Force
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\PolicyManager\current\device\Settings' -Name 'AllowSignInOptions' -PropertyType DWORD -Value '0' -Force

# Disable the Azure AD Sign In button in the settings app
write-host "Disabling Azure AD sign-in options.."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\PolicyManager\current\device\Settings' -Name 'AllowWorkplace' -PropertyType DWORD -Value '0' -Force

write-host "Disabling the Microsoft Account Sign-In Assistant."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'NoConnectedUser' -PropertyType DWORD -Value '3' -Force

# Disable the MSA Sign In button in the settings app
write-host "Disabling MSA sign-in options.."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\PolicyManager\current\device\Settings' -Name 'AllowYourAccount' -PropertyType DWORD -Value '0' -Force

write-host "Disabling camera usage on user's lock screen..."
New-Item -Path "HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows" -Name "Personalization" -Force
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenCamera' -PropertyType DWORD -Value '1' -Force

write-host "Disabling lock screen slideshow..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Personalization' -Name 'NoLockScreenSlideshow' -PropertyType DWORD -Value '1' -Force

# Offline maps
write-host "Turning off unsolicited network traffic on the Offline Maps settings page..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Maps' -Name 'AllowUntriggeredNetworkTrafficOnSettingsPage' -PropertyType DWORD -Value '0' -Force
write-host "Turning off Automatic Download and Update of Map Data..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\Maps' -Name 'AutoDownloadAndUpdateMapData' -PropertyType DWORD -Value '0' -Force

# Microsoft Edge
write-host "Enabling Do Not Track in Microsoft Edge..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main' -Name 'DoNotTrack' -PropertyType DWORD -Value '1' -Force

write-host "Disallow web content on New Tab page in Microsoft Edge..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\MicrosoftEdge\SearchScopes' -Name 'AllowWebContentOnNewTabPage' -PropertyType DWORD -Value '0' -Force

# General stuff
write-host "Turning off the advertising ID..."
New-Item -Path "HKLM:\NtUserOffline\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "AdvertisingInfo" -Force
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -PropertyType DWORD -Value '0' -Force

write-host "Turning off location..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessLocation' -PropertyType DWORD -Value '0' -Force
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors' -Name 'DisableLocation' -PropertyType DWORD -Value '0' -Force

# Stop getting to know me
write-host "Turning off automatic learning..."
New-ItemProperty -Path 'HKLM:\NtUserOffline\Software\Policies\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -PropertyType DWORD -Value '1' -Force
# Turn off updates to the speech recognition and speech synthesis models
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\Speech_OneCore\Preferences' -Name 'ModelDownloadAllowed' -PropertyType DWORD -Value '0' -Force

write-host "Disallowing Windows apps to access account information..."
New-Item -Path "HKLM:\NtUserOffline\SOFTWARE\Microsoft\Windows\AppPrivacy" -Name "AppPrivacy" -Force
New-ItemProperty -Path 'HKLM:\NtUserOffline\SOFTWARE\Microsoft\Windows\AppPrivacy' -Name 'LetAppsAccessAccountInfo' -PropertyType DWORD -Value '2' -Force
