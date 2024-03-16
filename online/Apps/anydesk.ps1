# Description

# AnyDesk Installation from Local Source

# Check if the software is already installed
$CheckPath = [System.IO.Path]::Combine($env:ProgramData, 'Microsoft\Windows\Start Menu\Programs')
$Filter = '*Anydesk*.lnk'

# Check if a file with the specified criteria exists
$IsSoftwareInstalled = Get-ChildItem -Path $CheckPath -Filter $Filter -File | Select-Object -First 1 -ErrorAction SilentlyContinue
if ($IsSoftwareInstalled) {
    # use $IsSoftwareInstalled.Fullname (for full path) #################
    Write-Host "[AnyDesk] Is already installed" -ForegroundColor Yellow
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
                    Write-Host "[AnyDesk] is being installed" -ForegroundColor Cyan
                    Start-Process msiexec.exe -Wait -ArgumentList "/I `"$setupPath`" /quiet"
                    Write-Host '[AnyDesk] Installed' -ForegroundColor Green
                    # After a sucessful installation Copy the shortcut to default user so all users can have a link on their desktop
                    try{
                        # Get the current logged-in user's desktop path
                        $desktopPath = [System.IO.Path]::Combine($env:USERPROFILE, 'Desktop')
                        # Search for a file with "Anydesk" in its name and has the .lnk extension on the desktop
                        $file = Get-ChildItem -Path $desktopPath -Filter '*Anydesk*.lnk' -File | Select-Object -First 1 -ErrorAction SilentlyContinue
                        if ($file) {
                            $Source = $file.FullName
                            $Destination = (Join-Path "C:\Users\Default\Desktop\" $file.Name)
                            # Create Shortcut for default User
                            Copy-Item -Path $Source -Destination $Destination -Force -ErrorAction SilentlyContinue
                            # Create Shortcut for current logged in user
                            Copy-Item -Path $Source -Destination (Join-Path $desktopPath $file.Name)
                        }
                    } catch{ Write-Host "Error in "$setupPath}
                } catch {}
            }
            else {Write-Host '[AnyDesk] Installation was not found in Drive\Windep\Apps\AnyDesk.exe'}
        } else {Write-Host "[Drive\WinDep] Directory was not found." -ForegroundColor Red}
}
