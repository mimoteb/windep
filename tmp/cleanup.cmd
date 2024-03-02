echo removing junk files
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
del /F /Q %APPDATA%\Microsoft\Windows\Recent\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*
del /F /Q %APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*

echo post cleanup
start /wait dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase
start /wait dism.exe /Online /Cleanup-Image /SPSuperseded
start /wait CleanMgr.exe /sagerun:1 /VeryLowDisk /AUTOCLEAN