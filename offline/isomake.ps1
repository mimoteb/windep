. .\config.ps1

# Set your variables here
Write-Host "Creating ISO file" -ForegroundColor Cyan
$oscdimgPath = Join-Path $PSScriptRoot "oscdimg.exe"
$iso_dir = $base + "iso"
$output_iso_file = $base + "windows_install.iso"

# Construct the command
$oscdimgCommand = @"
& "$oscdimgPath" -m -o -u2 -udfver102 -bootdata:2#p0,e,b$iso_dir\boot\etfsboot.com#pEF,e,b$iso_dir\efi\microsoft\boot\efisys.bin $iso_dir $output_iso_file
"@

# Execute the command
Invoke-Expression -Command $oscdimgCommand
