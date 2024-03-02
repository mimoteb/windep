Write-Host '[Image] cleanup components' -ForegroundColor Cyan
start /wait dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
start /wait dism.exe /Online /Cleanup-Image /SPSuperseded
start /wait CleanMgr.exe /sagerun:1 /VeryLowDisk /AUTOCLEAN
