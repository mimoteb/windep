# Load configuration from a separate file
. .\config.ps1

# Check if the backup WIM file exists
$backupWimPath = Join-Path -Path $backupdir -ChildPath "install.wim"
if (Test-Path -Path $backupWimPath) {
    # Delete the existing WIM file
    if (Test-Path $wim){
        Write-Host '[DELETE]' $wim -ForegroundColor Red
        Remove-Item -Path $wim -Force
    }

    # Restore the backup WIM file
    Write-Host '[INFO] Copy from:' $backupWimPath '>>To>>' $wim -ForegroundColor Yellow
    Copy-Item -Path $backupWimPath -Destination $wim -Force -ErrorAction SilentlyContinue
    Write-Host "[Sucess] Backup image restored to: $wim" -ForegroundColor Green
} else {
    Write-Host "[FAIL] No backup was restored. Backup file does not exist." -ForegroundColor Red
}
