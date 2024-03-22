# Description
# Install Adobe Acrobat Reader 2020


# Adobe Acrobat reader Installation
$drives = Get-PSDrive -PSProvider FileSystem

# Find the first drive with "windep" in its root path
$IsWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1

# Display the result
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
