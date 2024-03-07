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


if (-not (Test-Path $appsDirectory)) {
    New-Item -Path $appsDirectory -ItemType Directory
    Write-Host "Directory 'apps' created."} else {}


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
