@echo off
echo written by Solomon Samuel
echo this script requires an internet connection.
echo This script should be inside a windows image in the location:
echo Mount_Dir\Windows\Setup\Scripts\
rem remove all files in directory
del /f /s /q %temp%\windep-main\*
rem remove directory
rd /s /q %temp%\windep-main
powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mimoteb/windep/main/automate.ps1?' -OutFile '%temp%\automate.ps1'; & '%temp%\automate.ps1'"
