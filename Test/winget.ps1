check if the app is already installed
$appName = "Zoom.ZoomOutlookPlugin"

# Check if the application is already installed
$isInstalled = $null -ne (winget list | Select-String -SimpleMatch $appName)

if (-not $isInstalled) {
    # Install the application using winget
    winget install -n $appName
    Write-Host "$appName installed successfully."
} else {
    Write-Host "$appName is already installed."
}