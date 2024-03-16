# _workaround_for_old_deployment_scripts

# Description

# STEP 1 is the app already installed
# STEP 2 is there a downloaded copy
# Step 3 download
# step 4 silent install
# step 5 create shortcuts
# change all downloaded items to temp directory instead
# Get the path to the temporary directory
$TempDir = [System.IO.Path]::GetTempPath()

# Combine the temporary directory path with the desired subdirectory
$BaseDir = Join-Path $TempDir 'windep-main'

# This Script is a work around for the old deployment scripts
if (-not (Test-Path $appsDirectory)) {
    New-Item -Path $appsDirectory -ItemType Directory
    Write-Host "Directory 'apps' created."} else {}
# remove offline directory
try {
    Remove-Item -Path (Join-Path $BaseDir "\offline") -force -Recurse -ErrorAction SilentlyContinue
}
catch {
    <#Do this if a terminating exception happens#>
}
# Temp remove the scripts from the old deployment version
$targetDirectory = "C:\Windows\Setup\Scripts"

try {
    # Attempt to remove the directory forcibly
    Remove-Item -Path $targetDirectory -Recurse -Force -ErrorAction Stop
    Write-Host "Directory $targetDirectory has been forcibly removed."
} catch {
    Write-Host "An error occurred: $_"
    Write-Host "Continuing with the script..."
}
# Generate a random integer between 0 and 10000
$generatedNumber = Get-Random -Minimum 0 -Maximum 10001

# Display the result using Write-Host
Rename-Computer -NewName "Deployment-PC-$generatedNumber" -Force

