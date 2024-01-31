@echo off
echo written by Solomon Samuel
echo this script requires an internet connection.

powershell -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mimoteb/win/main/online/automate.ps1?$RANDOM' -OutFile '%temp%\automate.ps1'; & '%temp%\automate.ps1'"