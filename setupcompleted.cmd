@echo off
echo written by Solomon Samuel
echo this script requires an internet connection.
rem remove all files in directory
del /f /s /q %temp%\windep-main\*
rem remove directory
rd /s /q %temp%\windep-main
powershell -ExecutionPolicy Bypass -Command "& { Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mimoteb/windep/main/automate.ps1' -UseBasicParsing).Content }"


@echo off
echo written by Solomon Samuel
echo this script requires an internet connection.

powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mimoteb/win/main/online/automate.ps1?' -OutFile '%temp%\automate.ps1'; & '%temp%\automate.ps1'"
