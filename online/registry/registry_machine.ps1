# Description

# Get the path to the temporary directories
$TempDir = [System.IO.Path]::GetTempPath()
$BaseDir = Join-Path $TempDir 'windep-main'

Start-Process regedit -ArgumentList '/s', join-path $BaseDir '\online\machine.reg'
regedit /s (join-path $BaseDir '\online\machine.reg')
#Start-Process reg -ArgumentList "import ./user.reg" -Wait

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue