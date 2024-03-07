write-host '[Info] Installing Apps' -ForegroundColor Yellow

# STEP 1 is the app already installed
# STEP 2 is there a downloaded copy
# Step 3 download
# step 4 silent install
# step 5 create shortcuts
# change all downloaded items to temp directory instead

# Get the path to the temporary directory
$TempDir = [System.IO.Path]::GetTempPath()
# Combine the temporary directory path with the desired subdirectory
$BaseDir = Join-Path $TempDir 'windep-main'

# Adobe Acrobat reader
$setupPath = Join-Path $BaseDir "Apps\acrordr2020\Setup.exe"
$setupPath = "d:\data\acrordr2020\Setup.exe"
if (Test-Path $setupPath) {
    try {
        Start-Process $setupPath -Wait -ArgumentList '/sPB /rs /rps /sl "1031"'
        Write-Host 'Installed Adobe Acrobat Reader'
    } catch {
        # Handle if a terminating exception happens
    }
} else {
    Write-Host 'Adobe Acrobat Reader setup file not found.'
}

#AnyDesk
$check_path = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\AnyDesk Hanebutt IT-Consult GmbH AnyDesk Client\AnyDesk Hanebutt IT-Consult GmbH AnyDesk Client.lnk"
$setupPath = Join-Path $BaseDir "apps\anydesk.msi"
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

# Firefox
$checkPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
$setupPath = Join-Path $BaseDir "apps\firefox.exe"

if (-not (Test-Path $checkPath)) {
    if (-not (Test-Path $setupPath)) {
        try {
            $client = New-Object System.Net.WebClient
            $client.DownloadFile("https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de", $setupPath)
            Write-Host "Firefox setup file downloaded."
        } catch {
            Write-Host "An error occurred while downloading the Firefox setup file."
        }
    }

    try {
        Start-Process .\Apps\firefox.exe -Wait -ArgumentList '-ms -ma'
        Write-Host "Installed Firefox"
    } catch {
        Write-Host "An error occurred while installing Firefox."
    }
} else {
    Write-Host "Firefox is already installed."
}

