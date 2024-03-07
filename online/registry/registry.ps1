# Description

$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Machine = (Join-Path $PSDir "\Machine.reg")
$User = (Join-Path $PSDir "\User.reg")
$TempDir = [System.IO.Path]::GetTempPath()
$BaseDir = Join-Path $TempDir 'windep-main'

Start-Process regedit -ArgumentList '/s', $Machine
regedit /s (join-path $BaseDir '\online\machine.reg')
#Start-Process reg -ArgumentList "import ./user.reg" -Wait

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue