# Description

# AnyDesk Installation from Local Source

# Check if the software is already installed
$CheckPath = [System.IO.Path]::Combine($env:ProgramData, 'Microsoft\Windows\Start Menu\Programs')
$Filter = '*Anydesk*.lnk'

# Check if a file with the specified criteria exists
$IsSoftwareInstalled = Get-ChildItem -Path $CheckPath -Filter $Filter -File | Select-Object -First 1 -ErrorAction SilentlyContinue



if ($IsSoftwareInstalled) {
    Write-Host "[AnyDesk] Found in $CheckPath" -ForegroundColor Green
    } else {

        # Find the first drive with "windep" in its root path
        $IsWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1
        # Check if local windep directory exists
        if ($null -ne $IsWinDep) {
            $DriveLetter = $IsWinDep.Name 
            $WinDep = (Join-Path $DriveLetter '\windep\')
            Write-Host "[$WinDep] Found 'windep'" -ForegroundColor Green
            $setupPath = (Join-Path $WinDep "Apps\acrordr2020\Setup.exe")
            if (Test-Path $setupPath) {
                try {Start-Process $setupPath -Wait -ArgumentList '/sPB /rs /rps /sl "1031"'
                    Write-Host 'Installed Adobe Acrobat Reader'
                } catch {}
            } else {Write-Host '[Adobe Reader] Installation was not found in Drive\Windep\Apps\AcroRDR2020\Setup.exe'}
        } else {Write-Host "[Drive\WinDep] Directory was not found." -ForegroundColor Red}
        Write-Host "[AnyDesk] is being installed"
        Write-Host "No file matching the criteria found in $CheckPath."
}




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

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue