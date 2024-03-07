# Load configuration from a separate file
. .\config.ps1
#Disable Realtime Antivirus
Write-Host '[INFO] Disable Anti-Virus to speed up' -ForegroundColor Yellow
write-host '[INFO] Copying files from windir to the image started' -ForegroundColor Cyan
# Ensure that $mount and $windir exist before copying
if (Test-Path -Path @($mount, $windir) -PathType Container) {
    # Copy files from $windir to $mount
    Copy-Item -Path $windir\* -Destination $mount -Recurse -Force
    Write-Host "Files copied from $windir to $mount." -ForegroundColor Green
} else {
    Write-Host "Either $windir or $mount does not exist." -ForegroundColor Red
}

Write-Host '[WIM] Component cleanup and resetting the base' -ForegroundColor Black
Dism /Image:$mount /cleanup-image /StartComponentCleanup /ResetBase
Write-Host '[WIM] Dismounting...' -ForegroundColor Cyan
Dismount-WindowsImage -Path $mount -Save -CheckIntegrity