@echo off
echo written by Solomon Samuel
echo this script requires an internet connection.
echo This script should be inside a windows image in the location:
echo Mount_Dir\Windows\Setup\Scripts\
echo cleaning update %temp%\windep-main\
del /f /s /q %temp%\windep-main\*
rd /s /q %temp%\windep-main
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mimoteb/windep/main/automate.ps1?' -OutFile '%temp%\automate.ps1'; & '%temp%\automate.ps1'"
reg add HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /v MyRunOnceEntry /d "powershell -ExecutionPolicy Bypass -File %tmp%\windep\automate.ps1" /f