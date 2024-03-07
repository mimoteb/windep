. .\config.ps1

# check if $wim file exists!

# List all the indexes in the WIM File
dism.exe /Get-WimInfo /WimFile:$wim

# Prompt the user to choose an index to export
$chosenIndex = Read-Host "Enter the index you want to export"


# Use Dism to export the chosen index
Invoke-Expression -Command "Dism /Export-Image /SourceImageFile:$wim /SourceIndex:$chosenIndex /DestinationImageFile:$wim"

# Check the exit code to verify if the operation was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Image export completed successfully."
} else {
    Write-Host "Image export failed. Error code: $LASTEXITCODE"
}