# Check if SecurePoint OpenVPN is installed at the beginning 
# Execute script only when laptop is detected i.e. when there is a battery
# Download using webclient
# Secure Point language selection prompt suspends the automation
# Description
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
# this code must be runned as an administrator
$URL = "https://sourceforge.net/projects/securepoint/files/latest/download"
$FileName = $env:TEMP + "\securepointvpn.exe"
try { 
    Write-Host "[OpenVPN] Downloading to : " + $FileName -ForegroundColor Cyan
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($URL, $FileName)
        Write-Host "[OpenVPN] downloaded successfully." -ForegroundColor Green
        & $FileName /qn
    }
        catch {
            Write-Host "Error in Securepoint VPN installation" -ForegroundColor Red
    }

