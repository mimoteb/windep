# Description

$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue