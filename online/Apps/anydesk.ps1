# Description

# AnyDesk Installation from Local Source

# Check if the software is already installed
$CheckPath = [System.IO.Path]::Combine($env:ProgramData, 'Microsoft\Windows\Start Menu\Programs')
$Filter = '*Anydesk*.lnk'

# Check if a file with the specified criteria exists
$IsSoftwareInstalled = Get-ChildItem -Path $CheckPath -Filter $Filter -File | Select-Object -First 1 -ErrorAction SilentlyContinue



if ($IsSoftwareInstalled) {
    Write-Host "[AnyDesk] Found in $IsSoftwareInstalled" -ForegroundColor Green
    } else {
        # AnyDesk is not installed now installing it
        # Find the first drive with "windep" in its root path
        $IsWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1
        # Check if local windep directory exists
        if ($null -ne $IsWinDep) {
            $DriveLetter = $IsWinDep.Name 
            $WinDep = (Join-Path $DriveLetter '\windep\')
            Write-Host "[$WinDep] Found 'windep'" -ForegroundColor Green
            $setupPath = (Join-Path $WinDep "Apps\AnyDesk.exe")
            if (Test-Path $setupPath) {
                try {
                    Write-Host "[AnyDesk] is being installed"
                    Start-Process msiexec.exe -Wait -ArgumentList "/I `"$setupPath`" /quiet"
                    Write-Host '[AnyDesk] Installed' -ForegroundColor Green
                    # After a sucessful installation Copy the shortcut to default user so all users can have a link on their desktop
                    try{
                        $Source = #IsSoftwareInstalled
                        Copy-Item -Path $check_path -Destination (Join-Path $env:USERPROFILE "Desktop\AnyDesk Hanebutt IT-Consult GmbH AnyDesk Client.lnk") -ErrorAction Ignore
                    } catch{ Write-Host "Error in "$setupPath}
                } catch {}
            }
            else {Write-Host '[AnyDesk] Installation was not found in Drive\Windep\Apps\AnyDesk.exe'}
        } else {Write-Host "[Drive\WinDep] Directory was not found." -ForegroundColor Red}
}




$setupPath = Join-Path $BaseDir "apps\anydesk.msi"
if (-not (Test-Path $check_path)) {
    # The shortcut does not exist
    if (-not (Test-Path $setupPath)) {
        # The msi file does not exist, download the file...
        try {
            $client = New-Object System.Net.WebClient
            $client.DownloadFile("", $setupPath)

            Write-Host "Installed AnyDesk"
            
        } catch {
            # Handle if a terminating exception happens
            Write-Host 'Error installing AnyDesk'
        }
        Start-Process msiexec.exe -Wait -ArgumentList "/I `"$setupPath`" /quiet"

        # Create a shortcut for AnyDesk on Desktop for all users
        
    }
}

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue