# Description

$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Machine = (Join-Path $PSDir "\Machine.reg")
$User = (Join-Path $PSDir "\User.reg")
$TempDir = [System.IO.Path]::GetTempPath()
$BaseDir = Join-Path $TempDir 'windep-main'


Start-Process regedit -ArgumentList '/s', $Machine
# Check if the user is not an administrator
Start-Process regedit -ArgumentList '/s', $User

# finally execute all the reg files in the same directory
$
# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue