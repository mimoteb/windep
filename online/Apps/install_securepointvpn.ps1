# Execute script only when laptop is detected i.e. when there is a battery
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
# this code must be runned as an administrator
$Link = "https://sourceforge.net/projects/securepoint/files/latest/download"
$FileName = $env:TEMP + "\securepointvpn.exe"
try { 
    Write-Host "Downloading: " + $FileName
        Invoke-WebRequest -UserAgent "Wget" -Uri $Link -OutFile $env:TEMP'\securepointvpn.exe'
        Write-Host "SecurePoint VPN Client downloaded successfully."
        & $FileName /qn
    }
        catch {
            Write-Host "Error in Securepoint VPN installation"
    }
#del $MyInvocation.MyCommand.Source