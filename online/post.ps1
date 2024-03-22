# This script is supposed to run after all other scripts under \online were executed
# Description
Write-Host '[Image] cleanup components' -ForegroundColor Cyan
# start /wait dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
# start /wait dism.exe /Online /Cleanup-Image /SPSuperseded
# relative paths should be used here
Write-Host '[Reset Base] resetting the base'
Start-Process -FilePath dism.exe -ArgumentList '/Online /Cleanup-Image /StartComponentCleanup /ResetBase' -Wait
Start-Process -FilePath dism.exe -ArgumentList '/Online /Cleanup-Image /SPSuperseded' -Wait
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1 /VeryLowDisk /AUTOCLEAN' -Wait
Write-Host '[Compacting OS] This process will take some time, disable the Antivirus to speed up the process' -ForegroundColor Cyan
Start-Process -FilePath compact.exe -ArgumentList '/CompactOs:always'