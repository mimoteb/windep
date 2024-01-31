@echo off
echo written by Solomon Samuel
echo this script requires an internet connection.

powershell -ExecutionPolicy Bypass -Command "& { Invoke-Expression (Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/mimoteb/windep/main/automate.ps1' -force -UseBasicParsing).Content }"
