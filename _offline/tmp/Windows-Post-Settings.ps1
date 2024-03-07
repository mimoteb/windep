if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
#Mount Registry Hives
New-PSDrive -PSProvider Registry -Root HKEY-CLASSES_ROOT -Name HKCR
New-PSDrive -PSProvider Registry -Root HK_USERS -Name 'HKU'
New-PSDrive -PSProvider Registry -Root HKEY_CURRENT_CONFIG -Name HKCC

#Disable Ads-id
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

#Disable Wifi-hotspot sharing
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

#Disable Activity Tracking
@('EnableActivityFeed','PublishUserActivities','UploadUserActivities') |% { Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name $_ -Type DWord -Value 0 }

#Disable Being Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

#Disable Telemetry
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWord -Value 0

#Default Explorer viewing directory
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

#Disable Recent files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0

#Disable Recent Directories
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0

#Disable Delivery Optimizations
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config -Name DODownloadMode -Type DWord -Value 0

#disable sticky keys
Set-ItemProperty -Path 'HKCU:\Control Panel\Accessibility\StickyKeys' -Name 'Flags' -Value '506'

#disable location Computer\HKEY_CURRENT-USER\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 'Deny'

#disable Mouse Enhanced Pointer precision
Set-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseSpeed' -Value '0'
Set-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold1' -Value '0'
Set-ItemProperty 'HKCU:\Control Panel\Mouse' -Name 'MouseThreshold2' -Value '0'

#disable Bing Search from Windows 11 Start Menu
Set-ItemProperty 'HKCU:\Software\Policies\Microsoft\Windows' -Name 'DisableSearchBoxSuggestions' -Value '0'

#disable Microsoft OneDrive in Explorer
Set-ItemProperty 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name 'System.IsPinnedToNameSpaceTree' -Value '0'

#disable User Libraries Directory in Explorer
Set-ItemProperty 'HKCR:\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' -Name 'System.IsPinnedToNameSpaceTree' -Value '0'

#Disable Photos Directory in Explorer
Set-ItemProperty 'HKCR:\CLSID\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}' -Name 'System.IsPinnedToNameSpaceTree' -Value '0'

#Disable Music Directory in Explorer
Set-ItemProperty 'HKCR:\CLSID\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}' -Name 'System.IsPinnedToNameSpaceTree' -Value '0'
 
#Disable Videos Directory in Explorer
Set-ItemProperty 'HKCR:\CLSID\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}' -Name 'System.IsPinnedToNameSpaceTree' -Value '0'

#Remove Keys:
# Desktop Folder
# {B4BFCC3A-DB2C-424C-B029–7FE99A87C641}

# Videos Folder
# {A0953C92–50DC-43bf-BE83–3742FED03C9C}]
# {f86fa3ab-70d2–4fc7–9c99-fcbf05467f3a}]

# Pictures Folder
# {3ADD1653-EB32–4cb0-BBD7-DFA0ABB5ACCA}]
# {24ad3ad4-a569–4530–98e1-ab02f9417aa8}]

# Music Folder
# {1CF1260C-4DD0–4ebb-811F-33C572699FDE}]
# {3dfdf296-dbec-4fb4–81d1–6a3438bcf4de}]

# Downloads Folder
# {374DE290–123F-4565–9164–39C4925E467B}]
# {088e3905–0323–4b02–9826–5d99428e115f}]

# Desktop Folder
# {A8CDFF1C-4878–43be-B5FD-F8091C1C60D0}]
# {d3162b92–9365–467a-956b-92703aca08af}]

#disable feedback hub
#reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t "REG_DWORD" /d "0" /f
#reg delete "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /f


[cmdletbinding(DefaultParameterSetName="Decrapifier")]
param (
	[switch]$AllApps, 
    [switch]$LeaveTasks,
    [switch]$LeaveServices,
	[switch]$AppAccess,
	[switch]$OneDrive,
	[switch]$Xbox,
	[switch]$Tablet,
	[switch]$Cortana,
    [switch]$ClearStart,
	[switch]$NoLog,
    [Parameter(ParameterSetName="AppsOnly")]
    [switch]$AppsOnly,
    [Parameter(ParameterSetName="SettingsOnly")]
    [switch]$SettingsOnly
	)

#------USER EDITABLE VARIABLES - change these to your tastes!------

#Apps to keep. Wildcard is implied so try to be specific enough to not overlap with apps you do want removed. 
#Make sure not begin or end with a "|". ex: "app|app2" - good. "|app|app2|" - bad.

$GoodApps =	"calculator|camera|sticky|store|windows.photos|soundrecorder|mspaint|microsoft.paint|windowsnotepad|screensketch"

#Start Menu XML. If you run the script without -ClearStart, the XML below will be used for a custom start layout. By default it just leaves File Explorer, classic Control Panel, and Snipping Tool tiles.
#Place your XML like so:
#	$StartLayourStr = @"
#	<**YOUR START LAYOUT XML**>
#	"@

$StartLayoutStr = @" 
<LayoutModificationTemplate Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">
        <start:Group Name="" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout">
          <start:DesktopApplicationTile Size="2x2" Column="0" Row="0" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\File Explorer.lnk" />
          <start:DesktopApplicationTile Size="2x2" Column="2" Row="0" DesktopApplicationLinkPath="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Accessories\Snipping Tool.lnk" />
		  <start:DesktopApplicationTile Size="2x2" Column="0" Row="2" DesktopApplicationLinkPath="%APPDATA%\Microsoft\Windows\Start Menu\Programs\System Tools\Control Panel.lnk" />
        </start:Group>
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

#------End editable variables------


#---Functions---

#Appx removal
#Removes all apps or some apps depending on switches used.

Function RemoveApps {
	#SafeApps contains apps that shouldn't be removed, or just can't and cause errors
	$SafeApps = "AAD.brokerplugin|accountscontrol|apprep.chxapp|assignedaccess|asynctext|bioenrollment|capturepicker|cloudexperience|contentdelivery|desktopappinstaller|ecapp|edge|extension|getstarted|immersivecontrolpanel|lockapp|net.native|oobenet|parentalcontrols|PPIProjection|search|sechealth|secureas|shellexperience|startmenuexperience|terminal|vclibs|xaml|XGpuEject"
	If ($Xbox) {
		$SafeApps = "$SafeApps|Xbox" 
}
	
	If ($Allapps) {
		$RemoveApps = Get-AppxPackage -allusers | where-object {$_.name -notmatch $SafeApps}
		$RemovePrApps = Get-AppxProvisionedPackage -online | where-object {$_.displayname -notmatch $SafeApps}
			ForEach ($RemovedApp in $RemoveApps) {
				Write-Host Removing app package: $RemovedApp.name
				Remove-AppxPackage -package $RemovedApp -erroraction silentlycontinue
				
}			ForEach ($RemovedPrApp in $RemovePrApps) {
				Write-Host Removing provisioned app $RemovedPrApp.displayname
				Remove-AppxProvisionedPackage -online -packagename $RemovedPrApp.packagename -erroraction silentlycontinue
				
}
}	Else {
		$SafeApps = "$SafeApps|$GoodApps"
		$RemoveApps = Get-AppxPackage -allusers | where-object {$_.name -notmatch $SafeApps}
		$RemovePrApps = Get-AppxProvisionedPackage -online | where-object {$_.displayname -notmatch $SafeApps}
			ForEach ($RemovedApp in $RemoveApps) {
				Write-Host Removing app package: $RemovedApp.name
				Remove-AppxPackage -package $RemovedApp -erroraction silentlycontinue
				
}			ForEach ($RemovedPrApp in $RemovePrApps) {
				Write-Host Removing provisioned app $RemovedPrApp.displayname
				Remove-AppxProvisionedPackage -online -packagename $RemovedPrApp.packagename -erroraction silentlycontinue
				
}
}
} 
#End Function RemoveApps
		
	


        
#Registry change functions
#Load default user hive
Function loaddefaulthive {
	$matjazp72 = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList' Default).Default
    reg load "$reglocation" $matjazp72\ntuser.dat
}

#Unload default user hive
Function unloaddefaulthive {
    [gc]::collect()
    reg unload "$reglocation"
}


#Cycle registry locations - 1st pass HKCU, 2nd pass default NTUSER.dat
Function RegChange {
    Write-Host "***Applying registry items to HKCU...***"
    $reglocation = "HKCU"
    regsetuser
    $reglocation = "HKLM\AllProfile"
	Write-Host "***Applying registry items to default NTUSER.DAT...***"
    loaddefaulthive; regsetuser; unloaddefaulthive
    $reglocation = $null
	Write-Host "***Applying registry items to HKLM...***"
    regsetmachine
    Write-Host "***Registry set current user and default user, and policies set for local machine!***"
}


#Set current and default user registry settings
Function RegSetUser {
    #Start menu suggestions
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SystemPaneSuggestionsEnabled" /D 0 /F
	#Show suggested content in settings
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-338393Enabled" /D 0 /F
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-353694Enabled" /D 0 /F
	#Show suggestions occasionally
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-338388Enabled" /D 0 /F
	#Multitasking - Show suggestions in timeline
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-353698Enabled" /D 0 /F
    #Lockscreen suggestions, rotating pictures
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SoftLandingEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "RotatingLockScreenEnabled" /D 0 /F
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "RotatingLockScreenOverlayEnabled" /D 0 /F
    #Preinstalled apps, Minecraft Twitter etc all that - still need a clean default start menu to fully eliminate
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "PreInstalledAppsEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "PreInstalledAppsEverEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "OEMPreInstalledAppsEnabled" /D 0 /F
    #MS shoehorning apps quietly into your profile
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SilentInstalledAppsEnabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "ContentDeliveryAllowed" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContentEnabled" /D 0 /F
    #Ads in File Explorer
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /T REG_DWORD /V "ShowSyncProviderNotifications" /D 0 /F
	#Show me the Windows welcome experience after updates and occasionally
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-310093Enabled" /D 0 /F
	#Get tips, tricks, suggestions as you use Windows 
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-338389Enabled" /D 0 /F

	#Privacy Settings
	#Let websites provide local content by accessing language list - appears to reset during OOBE.
	#Reg Add "$reglocation\Control Panel\International\User Profile" /T REG_DWORD /V "HttpAcceptLanguageOptOut" /D 1 /F
    #Ask for feedback
    Reg Add "$reglocation\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "NumberOfSIUFInPeriod" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "PeriodInNanoSeconds" /D 0 /F
	#Let apps use advertising ID
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F
	#Let Windows track app launches to improve start and search results - includes run history
	#Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /T REG_DWORD /V "Start_TrackProgs" /D 0 /F
	#Tailored experiences - Diagnostics & Feedback settings
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /T REG_DWORD /V "TailoredExperiencesWithDiagnosticDataEnabled" /D 0 /F
	#Let apps on other devices open messages and apps on this device - Shared Experiences settings
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /T REG_DWORD /V "RomeSdkChannelUserAuthzPolicy" /D 0 /F
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /T REG_DWORD /V "CdpSessionUserAuthzPolicy" /D 0 /F
	
	#Speech Inking & Typing - comment out if you use the pen\stylus a lot
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /T REG_DWORD /V "Enabled" /D 0 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitTextCollection" /D 1 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitInkCollection" /D 1 /F
    Reg Add "$reglocation\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /T REG_DWORD /V "HarvestContacts" /D 0 /F
	Reg Add "$reglocation\SOFTWARE\Microsoft\Personalization\Settings" /T REG_DWORD /V "AcceptedPrivacyPolicy" /D 0 /F
	#Improve inking & typing recognition
	Reg Add "$reglocation\SOFTWARE\Microsoft\Input\TIPC" /T REG_DWORD /V "Enabled" /D 0 /F
	#Pen & Windows Ink - Show recommended app suggestions
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /T REG_DWORD /V "PenWorkspaceAppSuggestionsEnabled" /D 0 /F
	
	#People + Feeds
	#Show My People notifications
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People\ShoulderTap" /T REG_DWORD /V "ShoulderTap" /D 0 /F
	#Show My People app suggestions
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /T REG_DWORD /V "SubscribedContent-314563Enabled" /D 0 /F
	#People on Taskbar
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /T REG_DWORD /V "PeopleBand" /D 0 /F
	#News/Feeds taskbar item
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /T REG_DWORD /V "ShellFeedsTaskbarViewMode" /D 2 /F
		
	#Other Settings
	#Use Autoplay for all media and devices
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /T REG_DWORD /V "DisableAutoplay" /D 1 /F
	#Taskbar search, personal preference. 0 = no search, 1 = search icon, 2 = search bar
    Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "SearchboxTaskbarMode" /D 0 /F
	#Allow search to use location if it's enabled
	Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "AllowSearchToUseLocation" /D 0 /F
	#Do not track - Edge
	Reg Add "$reglocation\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /T REG_DWORD /V "DoNotTrack" /D 1 /F
	#Do not track - IE
	Reg Add "$reglocation\SOFTWARE\Microsoft\Internet Explorer\Main" /T REG_DWORD /V "DoNotTrack" /D 1 /F
	
	#--Optional User Settings--
	
    #App permissions user settings, these are all available from the settings menu
    If ($AppAccess) {
}	 Else{ 	
		#App permissions
		#Location - see tablet settings
		#Camera
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /T REG_SZ /V "Value" /D Deny /F
		#Microphone
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /T REG_SZ /V "Value" /D Deny /F
		#Notifications - doesn't appear to work in 1803, setting hasn't been moved as of 1803 like most of the others
		#Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /T REG_SZ /V "Value" /D Deny /F
		#Account Info
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /T REG_SZ /V "Value" /D Deny /F
		#Contacts
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\contacts" /T REG_SZ /V "Value" /D Deny /F	
		#Calendar
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appointments" /T REG_SZ /V "Value" /D Deny /F
		#Call history
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\phoneCallHistory" /T REG_SZ /V "Value" /D Deny /F
		#Email
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\email" /T REG_SZ /V "Value" /D Deny /F
		#Tasks
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userDataTasks" /T REG_SZ /V "Value" /D Deny /F
		#TXT/MMS
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\chat" /T REG_SZ /V "Value" /D Deny /F
		#Radios - doesn't appear to work in 1803, setting hasn't been moved as of 1803 like most of the others
		#Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /T REG_SZ /V "Value" /D Deny /F
		#Other Devices - reset during OOBE
		#Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /T REG_SZ /V "Value" /D Deny /F
		#Cellular Data
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\cellularData" /T REG_SZ /V "Value" /D Deny /F
		#Allow apps to run in background global setting - seems to reset during OOBE
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /T REG_DWORD /V "GlobalUserDisabled" /D 1 /F
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "BackgroundAppGlobalToggle" /D 0 /F	
		#App Diagnostics - doesn't appear to work in 1803, setting hasn't been moved as of 1803 like most of the others
		#Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" /T REG_SZ /V "Value" /D Deny /F
		#My Documents
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\documentsLibrary" /T REG_SZ /V "Value" /D Deny /F
		#My Pictures
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\picturesLibrary" /T REG_SZ /V "Value" /D Deny /F
		#My Videos
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\videosLibrary" /T REG_SZ /V "Value" /D Deny /F
		#File System
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\broadFileSystemAccess" /T REG_SZ /V "Value" /D Deny /F
		
		#Tablet Settings - use -Tablet switch to leave these on
		If ($Tablet) {
}
		 Else {
			#Deny access to location and sensors
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_DWORD /V "SensorPermissionState" /D 0 /F
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_SZ /V "Value" /D Deny /F
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E6AD100E-5F4E-44CD-BE0F-2265D88D14F5}" /T REG_SZ /V "Value" /D Deny /F
			Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /T REG_SZ /V "Value" /D Deny /F
}
		
}
	
	#Disable Cortana - use -Cortana to leave it on
	If ($Cortana){
}	 Else{
		#Disable Cortana and Bing search user settings
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaEnabled" /D 0 /F
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CanCortanaBeEnabled" /D 0 /F
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "DeviceHistoryEnabled" /D 0 /F
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaConsent" /D 0 /F
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "CortanaInAmbientMode" /D 0 /F
		#Disable Bing search from start menu/search bar
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "BingSearchEnabled" /D 0 /F
		#Disable Cortana on lock screen
		Reg Add "$reglocation\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /T REG_DWORD /V "VoiceActivationEnableAboveLockscreen" /D 0 /F
		#Disable Cortana search history
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /T REG_DWORD /V "HistoryViewEnabled" /D 0 /F
}
		
	#Game settings - use -Xbox to leave these on
	If ($Xbox) {
}	 Else {
		#Disable Game DVR
		Reg Add "$reglocation\System\GameConfigStore" /T REG_DWORD /V "GameDVR_Enabled" /D 0 /F
}
	
	#OneDrive settings - use -OneDrive switch to leave these on
	If ($OneDrive) {
}	 Else {
		#Disable OneDrive startup run user settings
		Reg Add "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /T REG_BINARY /V "OneDrive" /D 0300000021B9DEB396D7D001 /F
		#Disable automatic OneDrive desktop setup for new accounts
		If ($reglocation -ne "HKCU") {
			Reg Delete "$reglocation\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /V "OneDriveSetup" /F
}
}

#End user registry settings
}


#Set local machine settings and local group policies    
Function RegSetMachine {
    #--Local GP settings--   CONVERT THESE TO HKCU / DEFAULT / HKLM WHERE POSSIBLE
    #Can be adjusted in GPedit.msc in Pro+ editions.
    #Local Policy\Computer Config\Admin Templates\Windows Components			
    #/Application Compatibility
    #Turn off Application Telemetry			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "AITEnable" /D 0 /F			
    #Turn off inventory collector			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /T REG_DWORD /V "DisableInventory" /D 1 /F

    #/Cloud Content			
    #Turn off Consumer Experiences	- Enterprise only (for Pro, HKCU settings and start menu cleanup achieve same result)		
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableWindowsConsumerFeatures" /D 1 /F
	#Turn off all spotlight features	
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /T REG_DWORD /V "DisableWindowsSpotlightFeatures" /D 1 /F  

    #/Data Collection and Preview Builds			
    #Set Telemetry to off (switches to 1:basic for W10Pro and lower)			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "AllowTelemetry" /D 0 /F
    #Disable pre-release features and settings			
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /T REG_DWORD /V "EnableConfigFlighting" /D 0 /F
    #Do not show feedback notifications			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "DoNotShowFeedbackNotifications" /D 1 /F

    #/Store
    #Disable all apps from store, commented out by default as it will break the store			
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "DisableStoreApps" /D 1 /F		
    #Turn off Store, left disabled by default			
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "RemoveWindowsStore" /D 1 /F

    #/Sync your settings - commented out by default to keep functionality of sync service		
    #Do not sync (anything)			
    #Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /T REG_DWORD /V "DisableSettingSync" /D 2 /F
    #Disallow users to override this
    #Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /T REG_DWORD /V "DisableSettingSyncUserOverride" /D 1 /F
	
	#Add "Run as different user" to context menu
	Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /T REG_DWORD /V "ShowRunasDifferentuserinStart" /D 1 /F
	
	#Disable "Meet Now" taskbar button
	Reg Add	"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /T REG_DWORD /V "HideSCAMeetNow" /D 1 /F
	
	#!!!None of these effective anymore in 1803!!! Now handled by HKCU settings
    #Disallow web search from desktop search			
    #Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "DisableWebSearch" /D 1 /F
    #Don't search the web or display web results in search			
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "ConnectedSearchUseWeb" /D 0 /F
	#Don't allow search to use location
	#Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "AllowSearchToUseLocation" /D 0 /F

    #/Windows Update			
    #Turn off featured SOFTWARE notifications through Windows Update
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /T REG_DWORD /V "EnableFeaturedSoftware" /D 0 /F

    #--Non Local GP Settings--		
    #Delivery Optimization settings - sets to 1 for LAN only, change to 0 for off
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /T REG_DWORD /V "DownloadMode" /D 1 /F
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /T REG_DWORD /V "DODownloadMode" /D 1 /F
	Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /T REG_DWORD /V "DownloadMode" /D 1 /F
	
    #Disabling advertising info and device metadata collection for this machine
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /V "PreventDeviceMetadataFromNetwork" /T REG_DWORD /D 1 /F

	#Disable CEIP. GP setting at: Computer Config\Admin Templates\System\Internet Communication Managemen\Internet Communication settings
    Reg Add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /T REG_DWORD /V "CEIPEnable" /D 0 /F
	
	#Turn off automatic download/install of store app updates	
    #Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /T REG_DWORD /V "AutoDownload" /D 2 /F	
	
	#Prevent using sign-in info to automatically finish setting up after an update
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /T REG_DWORD /V "ARSOUserConsent" /D 0 /F
	
    #Prevent apps on other devices from opening apps on this one - disables phone pairing
    #Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" /T REG_DWORD /V "UserAuthPolicy" /D 0 /F
    
    #Enable diagnostic data viewer
    Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" /T REG_DWORD /V "EnableEventTranscript" /D 1 /F
	
	#Disable Edge desktop shortcut
	Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /T REG_DWORD /V "DisableEdgeDesktopShortcutCreation" /D 1 /F
	
	#Filter web content through smartscreen. Left enabled by default.
    #Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /T REG_DWORD /V "EnableWebContentEvaluation" /D 0 /F

	#--Optional Machine Settings--
	
	#Disable Cortana - use -Cortana to leave it on
	If ($Cortana){
}	 Else{
    #Cortana local GP - Computer Config\Admin Templates\Windows Components\Search			
    #Disallow Cortana			
    Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "AllowCortana" /D 0 /F
    #Disallow Cortana on lock screen - seems pointless with above setting, may be deprecated, covered by HKCU anyways		
    #Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /T REG_DWORD /V "AllowCortanaAboveLock" /D 0 /F
}

	#Tablet Settings - use -Tablet switch to leave these on
	If ($Tablet) {
}	 Else {
		#Turn off location - global
		Reg Add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /T REG_SZ /V "Value" /D Deny /F
}
	
	#Game settings - use -Xbox to leave these on
	If ($Xbox) {
}	 Else {
		#Disable Game Monitoring Service
		Reg Add "HKLM\SYSTEM\CurrentControlSet\Services\xbgm" /T REG_DWORD /V "Start" /D 4 /F
		#GameDVR local GP - Computer Config\Admin Templates\Windows Components\Windows Game Recording and Broadcasting
		Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /T REG_DWORD /V "AllowGameDVR" /D 0 /F
}

	#OneDrive settings - use -OneDrive switch to leave these on
	If ($OneDrive) {
}	 Else {
		#Prevent usage of OneDrive local GP - Computer Config\Admin Templates\Windows Components\OneDrive	
		Reg Add	"HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSyncNGSC" /D 1 /F
		Reg Add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSync" /D 1 /F
		#Remove OneDrive from File Explorer
		Reg Add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /T REG_DWORD /V "System.IsPinnedToNameSpaceTree" /D 0 /F
		Reg Add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /T REG_DWORD /V "System.IsPinnedToNameSpaceTree" /D 0 /F
}
	
#End machine registry settings
}           


#Clean up the default start menu    
Function ClearStartMenu {
    If ($ClearStart) {
		Write-Host "***Setting empty start menu for new profiles...***"
#Don't edit this. Creates empty start menu if -ClearStart is used.
        $StartLayoutStr = @"
<LayoutModificationTemplate Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
  </LayoutModificationTemplate>
"@
	    add-content $Env:TEMP\startlayout.xml $StartLayoutStr
        import-startlayout -layoutpath $Env:TEMP\startlayout.xml -mountpath $Env:SYSTEMDRIVE\
        remove-item $Env:TEMP\startlayout.xml
}    Else {        
		Write-Host "***Setting clean start menu for new profiles...***"
#Custom start layout XML near the top of the script.

        add-content $Env:TEMP\startlayout.xml $StartLayoutStr
        import-startlayout -layoutpath $Env:TEMP\startlayout.xml -mountpath $Env:SYSTEMDRIVE\
        remove-item $Env:TEMP\startlayout.xml
}
}


#Goodbye Message Function
Function Goodbye {
    Write-Host "*******Decrapification complete.*******"
	Write-Host "*******Remember to set your execution policy back!  Set-Executionpolicy restricted is the Windows 10 default.*******"
    Write-Host "*******Reboot your computer now!*******"     
}

#---End of functions---


#Decrapify
If ($NoLog) {
}Else  {
	Start-Transcript $ENV:SYSTEMDRIVE\WindowsDCtranscript.txt
}
Write-Host "******Decrapifying Windows 10...******"
If ($AppsOnly) {
    RemoveApps
    ClearStartMenu
    Goodbye
}Elseif ($SettingsOnly) {
    DisableTasks
    DisableServices
    RegChange
    ClearStartMenu
    Goodbye
}Else {
	RemoveApps
    DisableTasks
    DisableServices
    RegChange
    ClearStartMenu
    Goodbye
}

If ($NoLog) {
}Else  {
	Stop-Transcript
}








<#
$EnableEdgePDFTakeover.Text = "Enable Edge PDF Takeover"
$EnableEdgePDFTakeover.Width = 185
$EnableEdgePDFTakeover.Height = 35
$EnableEdgePDFTakeover.Location = New-Object System.Drawing.Point(155, 260)

#>

#This will self elevate the script so with a UAC prompt since this script needs to be run as an Administrator in order to function properly.

$ErrorActionPreference = 'SilentlyContinue'

$Button = [System.Windows.MessageBoxButton]::YesNoCancel
$ErrorIco = [System.Windows.MessageBoxImage]::Error
$Ask = 'Do you want to run this as an Administrator?

        Select "Yes" to Run as an Administrator

        Select "No" to not run this as an Administrator
        
        Select "Cancel" to stop the script.'

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    $Prompt = [System.Windows.MessageBox]::Show($Ask, "Run as an Administrator or not?", $Button, $ErrorIco) 
    Switch ($Prompt) {
        #This will debloat Windows 10
        Yes {
            Write-Host "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue."
            Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
            Exit
        }
        No {
            Break
        }
    }
}


#Unnecessary Windows 10 AppX apps that will be removed by the blacklist.
$global:Bloatware = @(
    "Microsoft.PPIProjection"
    "Microsoft.BingNews"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.Messaging"
    "Microsoft.Microsoft3DViewer"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.NetworkSpeedTest"
    "Microsoft.News"                                    # Issue 77
    "Microsoft.Office.Lens"                             # Issue 77
    "Microsoft.Office.OneNote"
    "Microsoft.Office.Sway"
    "Microsoft.OneConnect"
    "Microsoft.People"
    "Microsoft.Print3D"
    "Microsoft.RemoteDesktop"                           # Issue 120
    "Microsoft.SkypeApp"
    "Microsoft.StorePurchaseApp"
    "Microsoft.Office.Todo.List"                        # Issue 77
    "Microsoft.Whiteboard"                              # Issue 77
    "Microsoft.WindowsAlarms"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.WindowsMaps"
    "Microsoft.WindowsSoundRecorder"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.ZuneMusic"
    "Microsoft.ZuneVideo"

    #Sponsored Windows 10 AppX Apps
    #Add sponsored/featured apps to remove in the "*AppName*" format
    "EclipseManager"
    "ActiproSoftwareLLC"
    "AdobeSystemsIncorporated.AdobePhotoshopExpress"
    "Duolingo-LearnLanguagesforFree"
    "PandoraMediaInc"
    "CandyCrush"
    "BubbleWitch3Saga"
    "Wunderlist"
    "Flipboard"
    "Twitter"
    "Facebook"
    "Spotify"                                           # Issue 123
    "Minecraft"
    "Royal Revolt"
    "Sway"                                              # Issue 77
    "Dolby"                                             # Issue 78

    #Optional: Typically not removed but you can if you need to for some reason
    #"Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe"
    #"Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe"
    #"Microsoft.BingWeather"
)

#Valuable Windows 10 AppX apps that most people want to keep. Protected from DeBloat All.
#Credit to /u/GavinEke for a modified version of my whitelist code
$global:WhiteListedApps = @(
    "Microsoft.WindowsCalculator"               # Microsoft removed legacy calculator
    "Microsoft.WindowsStore"                    # Issue 1
    "Microsoft.Windows.Photos"                  # Microsoft disabled/hid legacy photo viewer
    "CanonicalGroupLimited.UbuntuonWindows"     # Issue 10
    "Microsoft.Xbox.TCUI"                       # Issue 25, 91  Many home users want to play games
    "Microsoft.XboxApp"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"               # Issue 25, 91  Many home users want to play games
    "Microsoft.XboxIdentityProvider"            # Issue 25, 91  Many home users want to play games
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.MicrosoftStickyNotes"            # Issue 33  New functionality.
    "Microsoft.MSPaint"                         # Issue 32  This is Paint3D, legacy paint still exists in Windows 10
    "Microsoft.WindowsCamera"                   # Issue 65  New functionality.
    "\.NET"
    "Microsoft.HEIFImageExtension"              # Issue 68
    "Microsoft.ScreenSketch"                    # Issue 55: Looks like Microsoft will be axing snipping tool and using Snip & Sketch going forward
    "Microsoft.StorePurchaseApp"                # Issue 68
    "Microsoft.VP9VideoExtensions"              # Issue 68
    "Microsoft.WebMediaExtensions"              # Issue 68
    "Microsoft.WebpImageExtension"              # Issue 68
    "Microsoft.DesktopAppInstaller"             # Issue 68
    "WindSynthBerry"                            # Issue 68
    "MIDIBerry"                                 # Issue 68
    "Slack"                                     # Issue 83
    "*Nvidia*"                                  # Issue 198
    "Microsoft.MixedReality.Portal"             # Issue 195
)

#NonRemovable Apps that where getting attempted and the system would reject the uninstall, speeds up debloat and prevents 'initalizing' overlay when removing apps
$NonRemovables = Get-AppxPackage -AllUsers | Where-Object { $_.NonRemovable -eq $true } | ForEach { $_.Name }
$NonRemovables += Get-AppxPackage | Where-Object { $_.NonRemovable -eq $true } | ForEach { $_.Name }
$NonRemovables += Get-AppxProvisionedPackage -Online | Where-Object { $_.NonRemovable -eq $true } | ForEach { $_.DisplayName }
$NonRemovables = $NonRemovables | Sort-Object -Unique

if ($NonRemovables -eq $null ) {
    # the .NonRemovable property doesn't exist until version 18xx. Use a hard-coded list instead.
    #WARNING: only use exact names here - no short names or wildcards
    $NonRemovables = @(
        "1527c705-839a-4832-9118-54d4Bd6a0c89"
        "c5e2524a-ea46-4f67-841f-6a9465d9d515"
        "E2A4F912-2574-4A75-9BB0-0D023378592B"
        "F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE"
        "InputApp"
        "Microsoft.AAD.BrokerPlugin"
        "Microsoft.AccountsControl"
        "Microsoft.BioEnrollment"
        "Microsoft.CredDialogHost"
        "Microsoft.ECApp"
        "Microsoft.LockApp"
        "Microsoft.MicrosoftEdgeDevToolsClient"
        "Microsoft.MicrosoftEdge"
        "Microsoft.PPIProjection"
        "Microsoft.Win32WebViewHost"
        "Microsoft.Windows.Apprep.ChxApp"
        "Microsoft.Windows.AssignedAccessLockApp"
        "Microsoft.Windows.CapturePicker"
        "Microsoft.Windows.CloudExperienceHost"
        "Microsoft.Windows.ContentDeliveryManager"
        "Microsoft.Windows.Cortana"
        "Microsoft.Windows.HolographicFirstRun"         # Added 1709
        "Microsoft.Windows.NarratorQuickStart"
        "Microsoft.Windows.OOBENetworkCaptivePortal"    # Added 1709
        "Microsoft.Windows.OOBENetworkConnectionFlow"   # Added 1709
        "Microsoft.Windows.ParentalControls"
        "Microsoft.Windows.PeopleExperienceHost"
        "Microsoft.Windows.PinningConfirmationDialog"
        "Microsoft.Windows.SecHealthUI"                 # Issue 117 Windows Defender
        "Microsoft.Windows.SecondaryTileExperience"     # Added 1709
        "Microsoft.Windows.SecureAssessmentBrowser"
        "Microsoft.Windows.ShellExperienceHost"
        "Microsoft.Windows.XGpuEjectDialog"
        "Microsoft.XboxGameCallableUI"                  # Issue 91
        "Windows.CBSPreview"
        "windows.immersivecontrolpanel"
        "Windows.PrintDialog"
        "Microsoft.VCLibs.140.00"
        "Microsoft.Services.Store.Engagement"
        "Microsoft.UI.Xaml.2.0"
    )
}

# import library code - located relative to this script
Function dotInclude() {
    Param(
        [Parameter(Mandatory)]
        [string]$includeFile
    )
    # Look for the file in the same directory as this script
    $scriptPath = $PSScriptRoot
    if ( $PSScriptRoot -eq $null -and $psISE) {
        $scriptPath = (Split-Path -Path $psISE.CurrentFile.FullPath)
    }
    if ( test-path $scriptPath\$includeFile ) {
        # import and immediately execute the requested file
        .$scriptPath\$includeFile
    }
}

# Override built-in blacklist/whitelist with user defined lists
dotInclude 'custom-lists.ps1'

#convert to regular expression to allow for the super-useful -match operator
$global:BloatwareRegex = $global:Bloatware -join '|'
$global:WhiteListedAppsRegex = $global:WhiteListedApps -join '|'


# This form was created using POSHGUI.com  a free online gui designer for PowerShell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(500,570)
$Form.StartPosition              = 'CenterScreen'
$Form.FormBorderStyle            = 'FixedSingle'
$Form.MinimizeBox                = $false
$Form.MaximizeBox                = $false
$Form.ShowIcon                   = $false
$Form.text                       = "Windows10Debloater"
$Form.TopMost                    = $false
$Form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#252525")

$DebloatPanel                    = New-Object system.Windows.Forms.Panel
$DebloatPanel.height             = 160
$DebloatPanel.width              = 480
$DebloatPanel.Anchor             = 'top,right,left'
$DebloatPanel.location           = New-Object System.Drawing.Point(10,10)

$RegistryPanel                   = New-Object system.Windows.Forms.Panel
$RegistryPanel.height            = 80
$RegistryPanel.width             = 480
$RegistryPanel.Anchor            = 'top,right,left'
$RegistryPanel.location          = New-Object System.Drawing.Point(10,180)

$CortanaPanel                    = New-Object system.Windows.Forms.Panel
$CortanaPanel.height             = 120
$CortanaPanel.width              = 153
$CortanaPanel.Anchor             = 'top,right,left'
$CortanaPanel.location           = New-Object System.Drawing.Point(10,270)

$EdgePanel                       = New-Object system.Windows.Forms.Panel
$EdgePanel.height                = 120
$EdgePanel.width                 = 154
$EdgePanel.Anchor                = 'top,right,left'
$EdgePanel.location              = New-Object System.Drawing.Point(173,270)

$DarkThemePanel                  = New-Object system.Windows.Forms.Panel
$DarkThemePanel.height           = 120
$DarkThemePanel.width            = 153
$DarkThemePanel.Anchor           = 'top,right,left'
$DarkThemePanel.location         = New-Object System.Drawing.Point(337,270)

$OtherPanel                      = New-Object system.Windows.Forms.Panel
$OtherPanel.height               = 160
$OtherPanel.width                = 480
$OtherPanel.Anchor               = 'top,right,left'
$OtherPanel.location             = New-Object System.Drawing.Point(10,400)

$Debloat                         = New-Object system.Windows.Forms.Label
$Debloat.text                    = "DEBLOAT OPTIONS"
$Debloat.AutoSize                = $true
$Debloat.width                   = 457
$Debloat.height                  = 142
$Debloat.Anchor                  = 'top,right,left'
$Debloat.location                = New-Object System.Drawing.Point(10,9)
$Debloat.Font                    = New-Object System.Drawing.Font('Consolas',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Debloat.ForeColor               = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$CustomizeBlacklist             = New-Object system.Windows.Forms.Button
$CustomizeBlacklist.FlatStyle   = 'Flat'
$CustomizeBlacklist.text        = "CUSTOMISE BLOCKLIST"
$CustomizeBlacklist.width       = 460
$CustomizeBlacklist.height      = 30
$CustomizeBlacklist.Anchor      = 'top,right,left'
$CustomizeBlacklist.location    = New-Object System.Drawing.Point(10,40)
$CustomizeBlacklist.Font        = New-Object System.Drawing.Font('Consolas',9)
$CustomizeBlacklist.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RemoveAllBloatware              = New-Object system.Windows.Forms.Button
$RemoveAllBloatware.FlatStyle    = 'Flat'
$RemoveAllBloatware.text         = "REMOVE ALL BLOATWARE"
$RemoveAllBloatware.width        = 460
$RemoveAllBloatware.height       = 30
$RemoveAllBloatware.Anchor       = 'top,right,left'
$RemoveAllBloatware.location     = New-Object System.Drawing.Point(10,80)
$RemoveAllBloatware.Font         = New-Object System.Drawing.Font('Consolas',9)
$RemoveAllBloatware.ForeColor    = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RemoveBlacklistedBloatware                 = New-Object system.Windows.Forms.Button
$RemoveBlacklistedBloatware.FlatStyle       = 'Flat'
$RemoveBlacklistedBloatware.text            = "REMOVE BLOATWARE WITH CUSTOM BLOCKLIST"
$RemoveBlacklistedBloatware.width           = 460
$RemoveBlacklistedBloatware.height          = 30
$RemoveBlacklistedBloatware.Anchor          = 'top,right,left'
$RemoveBlacklistedBloatware.location        = New-Object System.Drawing.Point(10,120)
$RemoveBlacklistedBloatware.Font            = New-Object System.Drawing.Font('Consolas',9)
$RemoveBlacklistedBloatware.ForeColor       = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Registry                        = New-Object system.Windows.Forms.Label
$Registry.text                   = "REGISTRY CHANGES"
$Registry.AutoSize               = $true
$Registry.width                  = 457
$Registry.height                 = 142
$Registry.Anchor                 = 'top,right,left'
$Registry.location               = New-Object System.Drawing.Point(10,10)
$Registry.Font                   = New-Object System.Drawing.Font('Consolas',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Registry.ForeColor              = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RevertChanges                    = New-Object system.Windows.Forms.Button
$RevertChanges.FlatStyle          = 'Flat'
$RevertChanges.text               = "REVERT REGISTRY CHANGES"
$RevertChanges.width              = 460
$RevertChanges.height             = 30
$RevertChanges.Anchor             = 'top,right,left'
$RevertChanges.location           = New-Object System.Drawing.Point(10,40)
$RevertChanges.Font               = New-Object System.Drawing.Font('Consolas',9)
$RevertChanges.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Cortana                         = New-Object system.Windows.Forms.Label
$Cortana.text                    = "CORTANA"
$Cortana.AutoSize                = $true
$Cortana.width                   = 457
$Cortana.height                  = 142
$Cortana.Anchor                  = 'top,right,left'
$Cortana.location                = New-Object System.Drawing.Point(10,10)
$Cortana.Font                    = New-Object System.Drawing.Font('Consolas',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Cortana.ForeColor               = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$EnableCortana                   = New-Object system.Windows.Forms.Button
$EnableCortana.FlatStyle         = 'Flat'
$EnableCortana.text              = "ENABLE"
$EnableCortana.width             = 133
$EnableCortana.height            = 30
$EnableCortana.Anchor            = 'top,right,left'
$EnableCortana.location          = New-Object System.Drawing.Point(10,40)
$EnableCortana.Font              = New-Object System.Drawing.Font('Consolas',9)
$EnableCortana.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableCortana                  = New-Object system.Windows.Forms.Button
$DisableCortana.FlatStyle        = 'Flat'
$DisableCortana.text             = "DISABLE"
$DisableCortana.width            = 133
$DisableCortana.height           = 30
$DisableCortana.Anchor           = 'top,right,left'
$DisableCortana.location         = New-Object System.Drawing.Point(10,80)
$DisableCortana.Font             = New-Object System.Drawing.Font('Consolas',9)
$DisableCortana.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Edge                            = New-Object system.Windows.Forms.Label
$Edge.text                       = "EDGE PDF"
$Edge.AutoSize                   = $true
$Edge.width                      = 457
$Edge.height                     = 142
$Edge.Anchor                     = 'top,right,left'
$Edge.location                   = New-Object System.Drawing.Point(10,10)
$Edge.Font                       = New-Object System.Drawing.Font('Consolas',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Edge.ForeColor                  = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$EnableEdgePDFTakeover           = New-Object system.Windows.Forms.Button
$EnableEdgePDFTakeover.FlatStyle = 'Flat'
$EnableEdgePDFTakeover.text      = "ENABLE"
$EnableEdgePDFTakeover.width     = 134
$EnableEdgePDFTakeover.height    = 30
$EnableEdgePDFTakeover.Anchor    = 'top,right,left'
$EnableEdgePDFTakeover.location  = New-Object System.Drawing.Point(10,40)
$EnableEdgePDFTakeover.Font      = New-Object System.Drawing.Font('Consolas',9)
$EnableEdgePDFTakeover.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableEdgePDFTakeover             = New-Object system.Windows.Forms.Button
$DisableEdgePDFTakeover.FlatStyle   = 'Flat'
$DisableEdgePDFTakeover.text        = "DISABLE"
$DisableEdgePDFTakeover.width       = 134
$DisableEdgePDFTakeover.height      = 30
$DisableEdgePDFTakeover.Anchor      = 'top,right,left'
$DisableEdgePDFTakeover.location    = New-Object System.Drawing.Point(10,80)
$DisableEdgePDFTakeover.Font        = New-Object System.Drawing.Font('Consolas',9)
$DisableEdgePDFTakeover.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Theme                           = New-Object system.Windows.Forms.Label
$Theme.text                      = "DARK THEME"
$Theme.AutoSize                  = $true
$Theme.width                     = 457
$Theme.height                    = 142
$Theme.Anchor                    = 'top,right,left'
$Theme.location                  = New-Object System.Drawing.Point(10,10)
$Theme.Font                      = New-Object System.Drawing.Font('Consolas',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Theme.ForeColor                 = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$EnableDarkMode                  = New-Object system.Windows.Forms.Button
$EnableDarkMode.FlatStyle        = 'Flat'
$EnableDarkMode.text             = "ENABLE"
$EnableDarkMode.width            = 133
$EnableDarkMode.height           = 30
$EnableDarkMode.Anchor           = 'top,right,left'
$EnableDarkMode.location         = New-Object System.Drawing.Point(10,40)
$EnableDarkMode.Font             = New-Object System.Drawing.Font('Consolas',9)
$EnableDarkMode.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableDarkMode                 = New-Object system.Windows.Forms.Button
$DisableDarkMode.FlatStyle       = 'Flat'
$DisableDarkMode.text            = "DISABLE"
$DisableDarkMode.width           = 133
$DisableDarkMode.height          = 30
$DisableDarkMode.Anchor          = 'top,right,left'
$DisableDarkMode.location        = New-Object System.Drawing.Point(10,80)
$DisableDarkMode.Font            = New-Object System.Drawing.Font('Consolas',9)
$DisableDarkMode.ForeColor       = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Other                           = New-Object system.Windows.Forms.Label
$Other.text                      = "OTHER CHANGES & FIXES"
$Other.AutoSize                  = $true
$Other.width                     = 457
$Other.height                    = 142
$Other.Anchor                    = 'top,right,left'
$Other.location                  = New-Object System.Drawing.Point(10,10)
$Other.Font                      = New-Object System.Drawing.Font('Consolas',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Other.ForeColor                 = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RemoveOnedrive                  = New-Object system.Windows.Forms.Button
$RemoveOnedrive.FlatStyle        = 'Flat'
$RemoveOnedrive.text             = "UNINSTALL ONEDRIVE"
$RemoveOnedrive.width            = 225
$RemoveOnedrive.height           = 30
$RemoveOnedrive.Anchor           = 'top,right,left'
$RemoveOnedrive.location         = New-Object System.Drawing.Point(10,40)
$RemoveOnedrive.Font             = New-Object System.Drawing.Font('Consolas',9)
$RemoveOnedrive.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$UnpinStartMenuTiles             = New-Object system.Windows.Forms.Button
$UnpinStartMenuTiles.FlatStyle   = 'Flat'
$UnpinStartMenuTiles.text        = "UNPIN TILES FROM START MENU"
$UnpinStartMenuTiles.width       = 225
$UnpinStartMenuTiles.height      = 30
$UnpinStartMenuTiles.Anchor      = 'top,right,left'
$UnpinStartMenuTiles.location    = New-Object System.Drawing.Point(245,40)
$UnpinStartMenuTiles.Font        = New-Object System.Drawing.Font('Consolas',9)
$UnpinStartMenuTiles.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$DisableTelemetry                = New-Object system.Windows.Forms.Button
$DisableTelemetry.FlatStyle      = 'Flat'
$DisableTelemetry.text           = "DISABLE TELEMETRY / TASKS"
$DisableTelemetry.width          = 225
$DisableTelemetry.height         = 30
$DisableTelemetry.Anchor         = 'top,right,left'
$DisableTelemetry.location       = New-Object System.Drawing.Point(10,80)
$DisableTelemetry.Font           = New-Object System.Drawing.Font('Consolas',9)
$DisableTelemetry.ForeColor      = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$RemoveRegkeys                   = New-Object system.Windows.Forms.Button
$RemoveRegkeys.FlatStyle         = 'Flat'
$RemoveRegkeys.text              = "REMOVE BLOATWARE REGKEYS"
$RemoveRegkeys.width             = 225
$RemoveRegkeys.height            = 30
$RemoveRegkeys.Anchor            = 'top,right,left'
$RemoveRegkeys.location          = New-Object System.Drawing.Point(245,80)
$RemoveRegkeys.Font              = New-Object System.Drawing.Font('Consolas',9)
$RemoveRegkeys.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$InstallNet35                    = New-Object system.Windows.Forms.Button
$InstallNet35.FlatStyle          = 'Flat'
$InstallNet35.text               = "INSTALL .NET V3.5"
$InstallNet35.width              = 460
$InstallNet35.height             = 30
$InstallNet35.Anchor             = 'top,right,left'
$InstallNet35.location           = New-Object System.Drawing.Point(10,120)
$InstallNet35.Font               = New-Object System.Drawing.Font('Consolas',9)
$InstallNet35.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

$Form.controls.AddRange(@($RegistryPanel,$DebloatPanel,$CortanaPanel,$EdgePanel,$DarkThemePanel,$OtherPanel))
$DebloatPanel.controls.AddRange(@($Debloat,$CustomizeBlacklist,$RemoveAllBloatware,$RemoveBlacklistedBloatware))
$RegistryPanel.controls.AddRange(@($Registry,$RevertChanges))
$CortanaPanel.controls.AddRange(@($Cortana,$EnableCortana,$DisableCortana))
$EdgePanel.controls.AddRange(@($EnableEdgePDFTakeover,$DisableEdgePDFTakeover,$Edge))
$DarkThemePanel.controls.AddRange(@($Theme,$DisableDarkMode,$EnableDarkMode))
$OtherPanel.controls.AddRange(@($Other,$RemoveOnedrive,$InstallNet35,$UnpinStartMenuTiles,$DisableTelemetry,$RemoveRegkeys))

$DebloatFolder = "C:\Temp\Windows10Debloater"
If (Test-Path $DebloatFolder) {
    Write-Host "${DebloatFolder} exists. Skipping."
}
Else {
    Write-Host "The folder ${DebloatFolder} doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
    Start-Sleep 1
    New-Item -Path "${DebloatFolder}" -ItemType Directory
    Write-Host "The folder ${DebloatFolder} was successfully created."
}

Start-Transcript -OutputDirectory "${DebloatFolder}"

Write-Output "Creating System Restore Point if one does not already exist. If one does, then you will receive a warning. Please wait..."
Checkpoint-Computer -Description "Before using W10DebloaterGUI.ps1" 


#region gui events {
$CustomizeBlacklist.Add_Click( {
        $CustomizeForm                  = New-Object System.Windows.Forms.Form
        $CustomizeForm.ClientSize       = New-Object System.Drawing.Point(580,570)
        $CustomizeForm.StartPosition    = 'CenterScreen'
        $CustomizeForm.FormBorderStyle  = 'FixedSingle'
        $CustomizeForm.MinimizeBox      = $false
        $CustomizeForm.MaximizeBox      = $false
        $CustomizeForm.ShowIcon         = $false
        $CustomizeForm.Text             = "Customize Allowlist and Blocklist"
        $CustomizeForm.TopMost          = $false
        $CustomizeForm.AutoScroll       = $false
        $CustomizeForm.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#252525")

        $ListPanel                     = New-Object system.Windows.Forms.Panel
        $ListPanel.height              = 510
        $ListPanel.width               = 572
        $ListPanel.Anchor              = 'top,right,left'
        $ListPanel.location            = New-Object System.Drawing.Point(10,10)
        $ListPanel.AutoScroll          = $true
        $ListPanel.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#252525")


        $SaveList                       = New-Object System.Windows.Forms.Button
        $SaveList.FlatStyle             = 'Flat'
        $SaveList.Text                  = "Save custom Allowlist and Blocklist to custom-lists.ps1"
        $SaveList.width                 = 560
        $SaveList.height                = 30
        $SaveList.Location              = New-Object System.Drawing.Point(10, 530)
        $SaveList.Font                  = New-Object System.Drawing.Font('Consolas',9)
        $SaveList.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")

        $CustomizeForm.controls.AddRange(@($SaveList,$ListPanel))

        $SaveList.Add_Click( {
               # $ErrorActionPreference = 'SilentlyContinue'

                '$global:WhiteListedApps = @(' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Encoding utf8
                @($ListPanel.controls) | ForEach {
                    if ($_ -is [System.Windows.Forms.CheckBox] -and $_.Enabled -and !$_.Checked) {
                        "    ""$( $_.Text )""" | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8
                    }
                }
                ')' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8

                '$global:Bloatware = @(' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8
                @($ListPanel.controls) | ForEach {
                    if ($_ -is [System.Windows.Forms.CheckBox] -and $_.Enabled -and $_.Checked) {
                        "    ""$($_.Text)""" | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8
                    }
                }
                ')' | Out-File -FilePath $PSScriptRoot\custom-lists.ps1 -Append -Encoding utf8

                #Over-ride the white/blacklist with the newly saved custom list
                dotInclude custom-lists.ps1

                #convert to regular expression to allow for the super-useful -match operator
                $global:BloatwareRegex = $global:Bloatware -join '|'
                $global:WhiteListedAppsRegex = $global:WhiteListedApps -join '|'
            })

        Function AddAppToCustomizeForm() {
            Param(
                [Parameter(Mandatory)]
                [int] $position,
                [Parameter(Mandatory)]
                [string] $appName,
                [Parameter(Mandatory)]
                [bool] $enabled,
                [Parameter(Mandatory)]
                [bool] $checked,
                [Parameter(Mandatory)]
                [bool] $autocheck,

                [string] $notes
            )

            $label = New-Object System.Windows.Forms.Label
            $label.Location = New-Object System.Drawing.Point(-10, (2 + $position * 25))
            $label.Text = $notes
            $label.Font = New-Object System.Drawing.Font('Consolas',8)
            $label.Width = 260
            $label.Height = 27
            $Label.TextAlign = [System.Drawing.ContentAlignment]::TopRight
            $label.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#888888")
            $ListPanel.controls.AddRange(@($label))

            $Checkbox = New-Object System.Windows.Forms.CheckBox
            $Checkbox.Text = $appName
            $CheckBox.Font = New-Object System.Drawing.Font('Consolas',8)
            $CheckBox.FlatStyle = 'Flat'
            $CheckBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#eeeeee")
            $Checkbox.Location = New-Object System.Drawing.Point(268, (0 + $position * 25))
            $Checkbox.Autosize = 1;
            $Checkbox.Checked = $checked
            $Checkbox.Enabled = $enabled
            $CheckBox.AutoCheck = $autocheck
            $ListPanel.controls.AddRange(@($CheckBox))
        }


        $Installed = @( (Get-AppxPackage).Name )
        $Online = @( (Get-AppxProvisionedPackage -Online).DisplayName )
        $AllUsers = @( (Get-AppxPackage -AllUsers).Name )
        [int]$checkboxCounter = 0

        ForEach ($item in $NonRemovables) {
            $string = ""
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { $string += " ConflictBlacklist " }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { $string += " ConflictWhitelist" }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            $string += "  Non-Removable"
            AddAppToCustomizeForm $checkboxCounter $item $true $false $false $string
            ++$checkboxCounter
        }
        ForEach ( $item in $global:WhiteListedApps ) {
            $string = ""
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { $string += " Conflict NonRemovables " }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { $string += " ConflictBlacklist " }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $false $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $global:Bloatware ) {
            $string = ""
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { $string += " Conflict NonRemovables " }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { $string += " Conflict Whitelist " }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += "Installed" }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { $string += " AllUsers" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $AllUsers ) {
            $string = "NEW   AllUsers"
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { continue }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { continue }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { $string += " Installed" }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $Installed ) {
            $string = "NEW   Installed"
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { continue }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { continue }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { continue }
            if ( $null -notmatch $Online -and $Online -cmatch $item) { $string += " Online" }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        ForEach ( $item in $Online ) {
            $string = "NEW   Online "
            if ( $null -notmatch $NonRemovables -and $NonRemovables -cmatch $item ) { continue }
            if ( $null -notmatch $global:WhiteListedAppsRegex -and $item -cmatch $global:WhiteListedAppsRegex ) { continue }
            if ( $null -notmatch $global:BloatwareRegex -and $item -cmatch $global:BloatwareRegex ) { continue }
            if ( $null -notmatch $Installed -and $Installed -cmatch $item) { continue }
            if ( $null -notmatch $AllUsers -and $AllUsers -cmatch $item) { continue }
            AddAppToCustomizeForm $checkboxCounter $item $true $true $true $string
            ++$checkboxCounter
        }
        [void]$CustomizeForm.ShowDialog()
    })


$RemoveBlacklistedBloatware.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Function DebloatBlacklist {
            Write-Host "Requesting removal of $global:BloatwareRegex"
            Write-Host "--- This may take a while - please be patient ---"
            Get-AppxPackage | Where-Object Name -cmatch $global:BloatwareRegex | Remove-AppxPackage
            Write-Host "...now starting the silent ProvisionedPackage bloatware removal..."
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -cmatch $global:BloatwareRegex | Remove-AppxProvisionedPackage -Online
            Write-Host "...and the final cleanup..."
            Get-AppxPackage -AllUsers | Where-Object Name -cmatch $global:BloatwareRegex | Remove-AppxPackage
        }
        Write-Host "`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`n`nRemoving blocklisted Bloatware.`n"
        DebloatBlacklist
        Write-Host "Bloatware removed!"
    })
$RemoveAllBloatware.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #This function finds any AppX/AppXProvisioned package and uninstalls it, except for Freshpaint, Windows Calculator, Windows Store, and Windows Photos.
        #Also, to note - This does NOT remove essential system services/software/etc such as .NET framework installations, Cortana, Edge, etc.

        #This is the switch parameter for running this script as a 'silent' script, for use in MDT images or any type of mass deployment without user interaction.

        Function Begin-SysPrep {

            Write-Host "Starting Sysprep Fixes"
   
            # Disable Windows Store Automatic Updates
            Write-Host "Adding Registry key to Disable Windows Store Automatic Updates"
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
            If (!(Test-Path $registryPath)) {
                Mkdir $registryPath
                New-ItemProperty $registryPath AutoDownload -Value 2 
            }
            Set-ItemProperty $registryPath AutoDownload -Value 2

            #Stop WindowsStore Installer Service and set to Disabled
            Write-Host "Stopping InstallService"
            Stop-Service InstallService
            Write-Host "Setting InstallService Startup to Disabled"
            Set-Service InstallService -StartupType Disabled
        }
        
        Function CheckDMWService {

            Param([switch]$Debloat)
  
            If (Get-Service dmwappushservice | Where-Object { $_.StartType -eq "Disabled" }) {
                Set-Service dmwappushservice -StartupType Automatic
            }

            If (Get-Service dmwappushservice | Where-Object { $_.Status -eq "Stopped" }) {
                Start-Service dmwappushservice
            } 
        }

        Function DebloatAll {
            #Removes AppxPackages
            Get-AppxPackage | Where { !($_.Name -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.Name) } | Remove-AppxPackage
            Get-AppxProvisionedPackage -Online | Where { !($_.DisplayName -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.DisplayName) } | Remove-AppxProvisionedPackage -Online
            Get-AppxPackage -AllUsers | Where { !($_.Name -cmatch $global:WhiteListedAppsRegex) -and !($NonRemovables -cmatch $_.Name) } | Remove-AppxPackage
        }
  
        #Creates a PSDrive to be able to access the 'HKCR' tree
        New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
  
        Function Remove-Keys {         
            #These are the registry keys that it will delete.
          
            $Keys = @(
          
                #Remove Background Tasks
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
          
                #Windows File
                "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
          
                #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
          
                #Scheduled Tasks to delete
                "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
          
                #Windows Protocol Keys
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
                "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
             
                #Windows Share Target
                "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            )
      
            #This writes the output of each key it is removing and also removes the keys listed above.
            ForEach ($Key in $Keys) {
                Write-Host "Removing $Key from registry"
                Remove-Item $Key -Recurse
            }
        }
          
        Function Protect-Privacy { 
  
            #Creates a PSDrive to be able to access the 'HKCR' tree
            New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
          
            #Disables Windows Feedback Experience
            Write-Host "Disabling Windows Feedback Experience program"
            $Advertising = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo'
            If (Test-Path $Advertising) {
                Set-ItemProperty $Advertising Enabled -Value 0
            }
          
            #Stops Cortana from being used as part of your Windows Search Function
            Write-Host "Stopping Cortana from being used as part of your Windows Search Function"
            $Search = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
            If (Test-Path $Search) {
                Set-ItemProperty $Search AllowCortana -Value 0
            }
          
            #Stops the Windows Feedback Experience from sending anonymous data
            Write-Host "Stopping the Windows Feedback Experience program"
            $Period1 = 'HKCU:\Software\Microsoft\Siuf'
            $Period2 = 'HKCU:\Software\Microsoft\Siuf\Rules'
            $Period3 = 'HKCU:\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds'
            If (!(Test-Path $Period3)) { 
                mkdir $Period1
                mkdir $Period2
                mkdir $Period3
                New-ItemProperty $Period3 PeriodInNanoSeconds -Value 0
            }
                 
            Write-Host "Adding Registry key to prevent bloatware apps from returning"
            #Prevents bloatware applications from returning
            $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
            If (!(Test-Path $registryPath)) {
                Mkdir $registryPath
                New-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 
            }          
      
            Write-Host "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
            $Holo = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic'    
            If (Test-Path $Holo) {
                Set-ItemProperty $Holo FirstRunSucceeded -Value 0
            }
      
            #Disables live tiles
            Write-Host "Disabling live tiles"
            $Live = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications'    
            If (!(Test-Path $Live)) {
                mkdir $Live  
                New-ItemProperty $Live NoTileApplicationNotification -Value 1
            }
      
            #Turns off Data Collection via the AllowTelemtry key by changing it to 0
            Write-Host "Turning off Data Collection"
            $DataCollection = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection'    
            If (Test-Path $DataCollection) {
                Set-ItemProperty $DataCollection AllowTelemetry -Value 0
            }
      
            #Disables People icon on Taskbar
            Write-Host "Disabling People icon on Taskbar"
            $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
            If (Test-Path $People) {
                Set-ItemProperty $People PeopleBand -Value 0
            }
  
            #Disables suggestions on start menu
            Write-Host "Disabling suggestions on the Start Menu"
            $Suggestions = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'    
            If (Test-Path $Suggestions) {
                Set-ItemProperty $Suggestions SystemPaneSuggestionsEnabled -Value 0
            }
            
            Write-Host "Disabling Bing Search when using Search via the Start Menu"
            $BingSearch = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
            If (Test-Path $BingSearch) {
                Set-ItemProperty $BingSearch DisableSearchBoxSuggestions -Value 1
            }
            
            Write-Host "Removing CloudStore from registry if it exists"
            $CloudStore = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore'
            If (Test-Path $CloudStore) {
                Stop-Process Explorer.exe -Force
                Remove-Item $CloudStore -Recurse -Force
                Start-Process Explorer.exe -Wait
            }

  
            #Loads the registry keys/values below into the NTUSER.DAT file which prevents the apps from redownloading. Credit to a60wattfish
            reg load HKU\Default_User C:\Users\Default\NTUSER.DAT
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SystemPaneSuggestionsEnabled -Value 0
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name PreInstalledAppsEnabled -Value 0
            Set-ItemProperty -Path Registry::HKU\Default_User\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name OemPreInstalledAppsEnabled -Value 0
            reg unload HKU\Default_User
      
            #Disables scheduled tasks that are considered unnecessary 
            Write-Host "Disabling scheduled tasks"
            #Get-ScheduledTask -TaskName XblGameSaveTaskLogon | Disable-ScheduledTask
            Get-ScheduledTask -TaskName XblGameSaveTask | Disable-ScheduledTask
            Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask
            Get-ScheduledTask -TaskName UsbCeip | Disable-ScheduledTask
            Get-ScheduledTask -TaskName DmClient | Disable-ScheduledTask
            Get-ScheduledTask -TaskName DmClientOnScenarioDownload | Disable-ScheduledTask
        }

        Function UnpinStart {
            # https://superuser.com/a/1442733
            # Requires -RunAsAdministrator

$START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

            $layoutFile="C:\Windows\StartMenuLayout.xml"

            #Delete layout file if it already exists
            If(Test-Path $layoutFile)
            {
                Remove-Item $layoutFile
            }

            #Creates the blank layout file
            $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

            $regAliases = @("HKLM", "HKCU")

            #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
            foreach ($regAlias in $regAliases){
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer" 
                IF(!(Test-Path -Path $keyPath)) { 
                    New-Item -Path $basePath -Name "Explorer"
                }
                Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
                Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
            }

            #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
            Stop-Process -name explorer
            Start-Sleep -s 5
            $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
            Start-Sleep -s 5

            #Enable the ability to pin items again by disabling "LockedStartLayout"
            foreach ($regAlias in $regAliases){
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer" 
                Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
            }

            #Restart Explorer and delete the layout file
            Stop-Process -name explorer

            # Uncomment the next line to make clean start menu default for all new users
            #Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

            Remove-Item $layoutFile
        }
        
        Function CheckInstallService {
  
            If (Get-Service InstallService | Where-Object { $_.Status -eq "Stopped" }) {  
                Start-Service InstallService
                Set-Service InstallService -StartupType Automatic 
            }
        }
  
        Write-Host "Initiating Sysprep"
        Begin-SysPrep
        Write-Host "Removing bloatware apps."
        DebloatAll
        Write-Host "Removing leftover bloatware registry keys."
        Remove-Keys
        Write-Host "Checking to see if any Allowlisted Apps were removed, and if so re-adding them."
        FixWhitelistedApps
        Write-Host "Stopping telemetry, disabling unneccessary scheduled tasks, and preventing bloatware from returning."
        Protect-Privacy
        Write-Host "Unpinning tiles from the Start Menu."
        UnpinStart
        Write-Host "Setting the 'InstallService' Windows service back to 'Started' and the Startup Type 'Automatic'."
        CheckDMWService
        CheckInstallService
        Write-Host "Finished all tasks. `n"
  
    } )
$RevertChanges.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #This function will revert the changes you made when running the Start-Debloat function.
        
        #This line reinstalls all of the bloatware that was removed
        Get-AppxPackage -AllUsers | ForEach { Add-AppxPackage -Verbose -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" } 
    
        #Tells Windows to enable your advertising information.    
        Write-Host "Re-enabling key to show advertisement information"
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        If (Test-Path $Advertising) {
            Set-ItemProperty $Advertising  Enabled -Value 1
        }
            
        #Enables Cortana to be used as part of your Windows Search Function
        Write-Host "Re-enabling Cortana to be used in your Windows Search"
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        If (Test-Path $Search) {
            Set-ItemProperty $Search  AllowCortana -Value 1 
        }
            
        #Re-enables the Windows Feedback Experience for sending anonymous data
        Write-Host "Re-enabling Windows Feedback Experience"
        $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 1 
    
        #Enables bloatware applications               
        Write-Host "Adding Registry key to allow bloatware apps to return"
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        If (!(Test-Path $registryPath)) {
            New-Item $registryPath 
        }
        Set-ItemProperty $registryPath  DisableWindowsConsumerFeatures -Value 0 
        
        #Changes Mixed Reality Portal Key 'FirstRunSucceeded' to 1
        Write-Host "Setting Mixed Reality Portal value to 1"
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 1 
        }
        
        #Re-enables live tiles
        Write-Host "Enabling live tiles"
        $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
        If (!(Test-Path $Live)) {
            New-Item $Live 
        }
        Set-ItemProperty $Live  NoTileApplicationNotification -Value 0 
       
        #Re-enables data collection
        Write-Host "Re-enabling data collection"
        $DataCollection = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        If (!(Test-Path $DataCollection)) {
            New-Item $DataCollection
        }
        Set-ItemProperty $DataCollection  AllowTelemetry -Value 1
        
        #Re-enables People Icon on Taskbar
        Write-Host "Enabling People Icon on Taskbar"
        $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        If (Test-Path $People) {
            Set-ItemProperty $People -Name PeopleBand -Value 1 -Verbose
        }
    
        #Re-enables suggestions on start menu
        Write-Host "Enabling suggestions on the Start Menu"
        $Suggestions = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $Suggestions)) {
            New-Item $Suggestions
        }
        Set-ItemProperty $Suggestions  SystemPaneSuggestionsEnabled -Value 1 
        
        #Re-enables scheduled tasks that were disabled when running the Debloat switch
        Write-Host "Enabling scheduled tasks that were disabled"
        Get-ScheduledTask XblGameSaveTaskLogon | Enable-ScheduledTask 
        Get-ScheduledTask  XblGameSaveTask | Enable-ScheduledTask 
        Get-ScheduledTask  Consolidator | Enable-ScheduledTask 
        Get-ScheduledTask  UsbCeip | Enable-ScheduledTask 
        Get-ScheduledTask  DmClient | Enable-ScheduledTask 
        Get-ScheduledTask  DmClientOnScenarioDownload | Enable-ScheduledTask 

        Write-Host "Re-enabling and starting WAP Push Service"
        #Enable and start WAP Push Service
        Set-Service "dmwappushservice" -StartupType Automatic
        Start-Service "dmwappushservice"
    
        Write-Host "Re-enabling and starting the Diagnostics Tracking Service"
        #Enabling the Diagnostics Tracking Service
        Set-Service "DiagTrack" -StartupType Automatic
        Start-Service "DiagTrack"
        Write-Host "Done reverting changes!"

        #
        Write-Output "Restoring 3D Objects from Explorer 'My Computer' submenu"
        $Objects32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        $Objects64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
        If (!(Test-Path $Objects32)) {
            New-Item $Objects32
        }
        If (!(Test-Path $Objects64)) {
            New-Item $Objects64
        }
    })
$DisableCortana.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Host "Disabling Cortana"
        $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
        If (!(Test-Path $Cortana1)) {
            New-Item $Cortana1
        }
        Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
        If (!(Test-Path $Cortana2)) {
            New-Item $Cortana2
        }
        Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
        Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
        If (!(Test-Path $Cortana3)) {
            New-Item $Cortana3
        }
        Set-ItemProperty $Cortana3 HarvestContacts -Value 0
        Write-Host "Cortana has been disabled."
    })
$DisableEdgePDFTakeover.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #Stops edge from taking over as the default .PDF viewer    
        Write-Host "Stopping Edge from taking over as the default .PDF viewer"
        $NoPDF = "HKCR:\.pdf"
        $NoProgids = "HKCR:\.pdf\OpenWithProgids"
        $NoWithList = "HKCR:\.pdf\OpenWithList" 
        If (!(Get-ItemProperty $NoPDF  NoOpenWith)) {
            New-ItemProperty $NoPDF NoOpenWith 
        }        
        If (!(Get-ItemProperty $NoPDF  NoStaticDefaultVerb)) {
            New-ItemProperty $NoPDF  NoStaticDefaultVerb 
        }        
        If (!(Get-ItemProperty $NoProgids  NoOpenWith)) {
            New-ItemProperty $NoProgids  NoOpenWith 
        }        
        If (!(Get-ItemProperty $NoProgids  NoStaticDefaultVerb)) {
            New-ItemProperty $NoProgids  NoStaticDefaultVerb 
        }        
        If (!(Get-ItemProperty $NoWithList  NoOpenWith)) {
            New-ItemProperty $NoWithList  NoOpenWith
        }        
        If (!(Get-ItemProperty $NoWithList  NoStaticDefaultVerb)) {
            New-ItemProperty $NoWithList  NoStaticDefaultVerb 
        }
            
        #Appends an underscore '_' to the Registry key for Edge
        $Edge = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
        If (Test-Path $Edge) {
            Set-Item $Edge AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_ 
        }
        Write-Host "Edge should no longer take over as the default .PDF."
    })
$EnableCortana.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Host "Re-enabling Cortana"
        $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
        If (!(Test-Path $Cortana1)) {
            New-Item $Cortana1
        }
        Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 1 
        If (!(Test-Path $Cortana2)) {
            New-Item $Cortana2
        }
        Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 0 
        Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 0 
        If (!(Test-Path $Cortana3)) {
            New-Item $Cortana3
        }
        Set-ItemProperty $Cortana3 HarvestContacts -Value 1 
        Write-Host "Cortana has been enabled!"
    })
$EnableEdgePDFTakeover.Add_Click( { 
        New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        $ErrorActionPreference = 'SilentlyContinue'
        Write-Host "Setting Edge back to default"
        $NoPDF = "HKCR:\.pdf"
        $NoProgids = "HKCR:\.pdf\OpenWithProgids"
        $NoWithList = "HKCR:\.pdf\OpenWithList"
        #Sets edge back to default
        If (Get-ItemProperty $NoPDF  NoOpenWith) {
            Remove-ItemProperty $NoPDF  NoOpenWith
        } 
        If (Get-ItemProperty $NoPDF  NoStaticDefaultVerb) {
            Remove-ItemProperty $NoPDF  NoStaticDefaultVerb 
        }       
        If (Get-ItemProperty $NoProgids  NoOpenWith) {
            Remove-ItemProperty $NoProgids  NoOpenWith 
        }        
        If (Get-ItemProperty $NoProgids  NoStaticDefaultVerb) {
            Remove-ItemProperty $NoProgids  NoStaticDefaultVerb 
        }        
        If (Get-ItemProperty $NoWithList  NoOpenWith) {
            Remove-ItemProperty $NoWithList  NoOpenWith
        }    
        If (Get-ItemProperty $NoWithList  NoStaticDefaultVerb) {
            Remove-ItemProperty $NoWithList  NoStaticDefaultVerb
        }
        
        #Removes an underscore '_' from the Registry key for Edge
        $Edge2 = "HKCR:\AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723_"
        If (Test-Path $Edge2) {
            Set-Item $Edge2 AppXd4nrz8ff68srnhf9t5a8sbjyar1cr723
        }
        Write-Host "Edge will now be able to be used for .PDF."
    })
$DisableTelemetry.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        #Disables Windows Feedback Experience
        Write-Host "Disabling Windows Feedback Experience program"
        $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
        If (Test-Path $Advertising) {
            Set-ItemProperty $Advertising Enabled -Value 0 
        }
            
        #Stops Cortana from being used as part of your Windows Search Function
        Write-Host "Stopping Cortana from being used as part of your Windows Search Function"
        $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        If (Test-Path $Search) {
            Set-ItemProperty $Search AllowCortana -Value 0 
        }

        #Disables Web Search in Start Menu
        Write-Host "Disabling Bing Search in Start Menu"
        $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 
        If (!(Test-Path $WebSearch)) {
            New-Item $WebSearch
        }
        Set-ItemProperty $WebSearch DisableWebSearch -Value 1 
            
        #Stops the Windows Feedback Experience from sending anonymous data
        Write-Host "Stopping the Windows Feedback Experience program"
        $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

        #Prevents bloatware applications from returning and removes Start Menu suggestions               
        Write-Host "Adding Registry key to prevent bloatware apps from returning"
        $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $registryPath)) { 
            New-Item $registryPath
        }
        Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

        If (!(Test-Path $registryOEM)) {
            New-Item $registryOEM
        }
        Set-ItemProperty $registryOEM ContentDeliveryAllowed -Value 0 
        Set-ItemProperty $registryOEM OemPreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM PreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM PreInstalledAppsEverEnabled -Value 0 
        Set-ItemProperty $registryOEM SilentInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM SystemPaneSuggestionsEnabled -Value 0          
    
        #Preping mixed Reality Portal for removal    
        Write-Host "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
        $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"    
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
        }

        #Disables Wi-fi Sense
        Write-Host "Disabling Wi-Fi Sense"
        $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
        $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
        $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
        If (!(Test-Path $WifiSense1)) {
            New-Item $WifiSense1
        }
        Set-ItemProperty $WifiSense1  Value -Value 0 
        If (!(Test-Path $WifiSense2)) {
            New-Item $WifiSense2
        }
        Set-ItemProperty $WifiSense2  Value -Value 0 
        Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0 
        
        #Disables live tiles
        Write-Host "Disabling live tiles"
        $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"    
        If (!(Test-Path $Live)) {      
            New-Item $Live
        }
        Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 
        
        #Turns off Data Collection via the AllowTelemtry key by changing it to 0
        Write-Host "Turning off Data Collection"
        $DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
        $DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
        $DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"    
        If (Test-Path $DataCollection1) {
            Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection2) {
            Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0 
        }
        If (Test-Path $DataCollection3) {
            Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0 
        }
    
        #Disabling Location Tracking
        Write-Host "Disabling Location Tracking"
        $SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
        $LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
        If (!(Test-Path $SensorState)) {
            New-Item $SensorState
        }
        Set-ItemProperty $SensorState SensorPermissionState -Value 0 
        If (!(Test-Path $LocationConfig)) {
            New-Item $LocationConfig
        }
        Set-ItemProperty $LocationConfig Status -Value 0 
        
        #Disables People icon on Taskbar
        Write-Host "Disabling People icon on Taskbar"
        $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
        If (Test-Path $People) {
            Set-ItemProperty $People -Name PeopleBand -Value 0
        } 
        
        #Disables scheduled tasks that are considered unnecessary 
        Write-Host "Disabling scheduled tasks"
        #Get-ScheduledTask XblGameSaveTaskLogon | Disable-ScheduledTask
        Get-ScheduledTask XblGameSaveTask | Disable-ScheduledTask
        Get-ScheduledTask Consolidator | Disable-ScheduledTask
        Get-ScheduledTask UsbCeip | Disable-ScheduledTask
        Get-ScheduledTask DmClient | Disable-ScheduledTask
        Get-ScheduledTask DmClientOnScenarioDownload | Disable-ScheduledTask

        #Write-Host "Uninstalling Telemetry Windows Updates"
        #Uninstalls Some Windows Updates considered to be Telemetry. !WIP!
        #Wusa /Uninstall /KB:3022345 /norestart /quiet
        #Wusa /Uninstall /KB:3068708 /norestart /quiet
        #Wusa /Uninstall /KB:3075249 /norestart /quiet
        #Wusa /Uninstall /KB:3080149 /norestart /quiet        

        Write-Host "Stopping and disabling WAP Push Service"
        #Stop and disable WAP Push Service
        Stop-Service "dmwappushservice"
        Set-Service "dmwappushservice" -StartupType Disabled

        Write-Host "Stopping and disabling Diagnostics Tracking Service"
        #Disabling the Diagnostics Tracking Service
        Stop-Service "DiagTrack"
        Set-Service "DiagTrack" -StartupType Disabled
        Write-Host "Telemetry has been disabled!"
    })
$RemoveRegkeys.Add_Click( { 
        $ErrorActionPreference = 'SilentlyContinue'
        $Keys = @(
            
            New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
            #Remove Background Tasks
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
            #Windows File
            "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
            #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
            #Scheduled Tasks to delete
            "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
            #Windows Protocol Keys
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
            #Windows Share Target
            "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        )
        
        #This writes the output of each key it is removing and also removes the keys listed above.
        ForEach ($Key in $Keys) {
            Write-Host "Removing $Key from registry"
            Remove-Item $Key -Recurse
        }
        Write-Host "Additional bloatware keys have been removed!"
    })
$UnpinStartMenuTiles.Add_Click( {
        #https://superuser.com/questions/1068382/how-to-remove-all-the-tiles-in-the-windows-10-start-menu
        #Unpins all tiles from the Start Menu
        Write-Host "Unpinning all tiles from the start menu"
        (New-Object -Com Shell.Application).
        NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
        Items() |
        % { $_.Verbs() } |
        ? { $_.Name -match 'Un.*pin from Start' } |
        % { $_.DoIt() }
    })

$RemoveOnedrive.Add_Click( { 
        If (Test-Path "$env:USERPROFILE\OneDrive\*") {
            Write-Host "Files found within the OneDrive folder! Checking to see if a folder named OneDriveBackupFiles exists."
            Start-Sleep 1
              
            If (Test-Path "$env:USERPROFILE\Desktop\OneDriveBackupFiles") {
                Write-Host "A folder named OneDriveBackupFiles already exists on your desktop. All files from your OneDrive location will be moved to that folder." 
            }
            else {
                If (!(Test-Path "$env:USERPROFILE\Desktop\OneDriveBackupFiles")) {
                    Write-Host "A folder named OneDriveBackupFiles will be created and will be located on your desktop. All files from your OneDrive location will be located in that folder."
                    New-item -Path "$env:USERPROFILE\Desktop" -Name "OneDriveBackupFiles"-ItemType Directory -Force
                    Write-Host "Successfully created the folder 'OneDriveBackupFiles' on your desktop."
                }
            }
            Start-Sleep 1
            Move-Item -Path "$env:USERPROFILE\OneDrive\*" -Destination "$env:USERPROFILE\Desktop\OneDriveBackupFiles" -Force
            Write-Host "Successfully moved all files/folders from your OneDrive folder to the folder 'OneDriveBackupFiles' on your desktop."
            Start-Sleep 1
            Write-Host "Proceeding with the removal of OneDrive."
            Start-Sleep 1
        }
        Else {
            Write-Host "Either the OneDrive folder does not exist or there are no files to be found in the folder. Proceeding with removal of OneDrive."
            Start-Sleep 1
            Write-Host "Enabling the Group Policy 'Prevent the usage of OneDrive for File Storage'."
            $OneDriveKey = 'HKLM:Software\Policies\Microsoft\Windows\OneDrive'
            If (!(Test-Path $OneDriveKey)) {
                Mkdir $OneDriveKey
                Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
            }
            Set-ItemProperty $OneDriveKey -Name OneDrive -Value DisableFileSyncNGSC
        }

        Write-Host "Uninstalling OneDrive. Please wait..."
    
        New-PSDrive  HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
        $onedrive = "$env:SYSTEMROOT\SysWOW64\OneDriveSetup.exe"
        $ExplorerReg1 = "HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        $ExplorerReg2 = "HKCR:\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}"
        Stop-Process -Name "OneDrive*"
        Start-Sleep 2
        If (!(Test-Path $onedrive)) {
            $onedrive = "$env:SYSTEMROOT\System32\OneDriveSetup.exe"
        }
        Start-Process $onedrive "/uninstall" -NoNewWindow -Wait
        Start-Sleep 2
        Write-Host "Stopping explorer"
        Start-Sleep 1
        taskkill.exe /F /IM explorer.exe
        Start-Sleep 3
        Write-Host "Removing leftover files"
        If (Test-Path "$env:USERPROFILE\OneDrive") {
            Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:LOCALAPPDATA\Microsoft\OneDrive") {
            Remove-Item "$env:LOCALAPPDATA\Microsoft\OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:PROGRAMDATA\Microsoft OneDrive") {
            Remove-Item "$env:PROGRAMDATA\Microsoft OneDrive" -Force -Recurse
        }
        If (Test-Path "$env:SYSTEMDRIVE\OneDriveTemp") {
            Remove-Item "$env:SYSTEMDRIVE\OneDriveTemp" -Force -Recurse
        }
        Write-Host "Removing OneDrive from windows explorer"
        If (!(Test-Path $ExplorerReg1)) {
            New-Item $ExplorerReg1
        }
        Set-ItemProperty $ExplorerReg1 System.IsPinnedToNameSpaceTree -Value 0 
        If (!(Test-Path $ExplorerReg2)) {
            New-Item $ExplorerReg2
        }
        Set-ItemProperty $ExplorerReg2 System.IsPinnedToNameSpaceTree -Value 0
        Write-Host "Restarting Explorer that was shut down before."
        Start-Process explorer.exe -NoNewWindow
        Write-Host "OneDrive has been successfully uninstalled!"
        
        Remove-item env:OneDrive
    })

$InstallNet35.Add_Click( {

        Write-Host "Initializing the installation of .NET 3.5..."
        DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
        Write-Host ".NET 3.5 has been successfully installed!"
    } )

$EnableDarkMode.Add_Click( {
        Write-Host "Enabling Dark Mode"
        $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty $Theme AppsUseLightTheme -Value 0
        Start-Sleep 1
        Write-Host "Enabled"
    }
)

$DisableDarkMode.Add_Click( {
        Write-Host "Disabling Dark Mode"
        $Theme = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
        Set-ItemProperty $Theme AppsUseLightTheme -Value 1
        Start-Sleep 1
        Write-Host "Disabled"
    }
)

[void]$Form.ShowDialog()