# This script is supposed to run after all other scripts under \online were executed
Write-Host '[Image] cleanup components' -ForegroundColor Cyan
# start /wait dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
# start /wait dism.exe /Online /Cleanup-Image /SPSuperseded
# relative paths should be used here

Start-Process -FilePath dism.exe -ArgumentList '/Online /Cleanup-Image /StartComponentCleanup /ResetBase' -Wait
Start-Process -FilePath dism.exe -ArgumentList '/Online /Cleanup-Image /SPSuperseded' -Wait
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1 /VeryLowDisk /AUTOCLEAN' -Wait

Start-Process -FilePath compact.exe -ArgumentList '/CompactOs:always'