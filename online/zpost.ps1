Write-Host '[Image] cleanup components' -ForegroundColor Cyan
# start /wait dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
# start /wait dism.exe /Online /Cleanup-Image /SPSuperseded

Start-Process -FilePath dism.exe -ArgumentList '/Online /Cleanup-Image /StartComponentCleanup /ResetBase' -Wait
Start-Process -FilePath dism.exe -ArgumentList '/Online /Cleanup-Image /SPSuperseded' -Wait
Start-Process -FilePath CleanMgr.exe -ArgumentList '/sagerun:1 /VeryLowDisk /AUTOCLEAN' -Wait

regedit /s machine.reg
regedit /s user.reg