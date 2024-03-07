# STEP 1 is the app already installed
# STEP 2 is there a downloaded copy
# Step 3 download
# step 4 silent install
# step 5 create shortcuts
# change all downloaded items to temp directory instead
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$appsDirectory = Join-Path $scriptDirectory "apps"

if (-not (Test-Path $appsDirectory)) {
    New-Item -Path $appsDirectory -ItemType Directory
    Write-Host "Directory 'apps' created."} else {}

#AnyDesk
$check_path = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyDesk Hanebutt IT-Consult GmbH AnyDesk Client\AnyDesk Hanebutt IT-Consult GmbH AnyDesk Client.lnk"
$setupPath = Join-Path $scriptDirectory "apps\anydesk.msi"
if (-not (Test-Path $check_path)) {
    # The shortcut does not exist
    if (-not (Test-Path $setupPath)) {
        # The msi file does not exist, download the file...
        try {
            $client = New-Object System.Net.WebClient
            $client.DownloadFile("https://get.anydesk.com/hpbChuIG/Fernwartung.exe", $setupPath)

            Write-Host "Installed AnyDesk"
            
        } catch {
            # Handle if a terminating exception happens
            Write-Host 'Error installing AnyDesk'
        }
        Start-Process msiexec.exe -Wait -ArgumentList "/I `"$setupPath`" /quiet"

        # Create a shortcut for AnyDesk on Desktop for all users
        try{
            Copy-Item -Path $check_path -Destination (Join-Path $env:USERPROFILE "Desktop\AnyDesk Hanebutt IT-Consult GmbH AnyDesk Client.lnk") -ErrorAction Ignore
        } catch{ Write-Host "Error in "$setupPath}
    }
}
