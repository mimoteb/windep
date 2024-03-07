# Description

$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# finally execute all the reg files in the same directory
$RegFiles = Get-ChildItem -Path $PSDir -Filter "*.reg" -Recurse -ErrorAction SilentlyContinue
foreach ($File in $RegFiles) {
    Write-Host '[REG] The following file found in, and will be executed: '$File -ForegroundColor Cyan
    Start-Process regedit -ArgumentList '/s', $File -NoNewWindow -Wait
}

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue
