
# Adobe Acrobat reader
$setupPath = Join-Path $BaseDir "Apps\acrordr2020\Setup.exe"
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