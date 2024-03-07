# Description
# Install Adobe Acrobat Reader 2020


# Adobe Acrobat reader Installation
$drives = Get-PSDrive -PSProvider FileSystem

# Find the first drive with "windep" in its root path
$localWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1
localWinDepLetter
# Display the result
if ($null -ne $localWinDep) {
    $localWinDepLetter = $localWinDep.Name 
    $WinDep = (Join-Path $localWinDepLetter '\windep\')
    Write-Host "[$localWinDepLetter] Found 'windep'" -ForegroundColor Green
    $setupPath = (Join-Path $WinDep "Apps\acrordr2020\Setup.exe")
    if (Test-Path $setupPath) {
        try {Start-Process $setupPath -Wait -ArgumentList '/sPB /rs /rps /sl "1031"'
            Write-Host 'Installed Adobe Acrobat Reader'
        } catch {}
    } else {Write-Host '[Adobe Reader] Installation was not found in Drive\Windep\Apps\AcroRDR2020\Setup.exe'}
} else {Write-Host "[Drive\WinDep] Directory was not found." -ForegroundColor Red}


# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue
