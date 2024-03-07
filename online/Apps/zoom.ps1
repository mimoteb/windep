
# Install Zoom including ZoomOutlookPlugin
$setupPath = Join-Path $appsDirectory "ZoomOutlookPluginSetup.msi"

if (Test-Path $setupPath) {
    try {
        Start-Process msiexec.exe -Wait -ArgumentList "/i `"$setupPath`" /quiet"
        Write-Host 'Installed Zoom Outlook Plugin'
    } catch {
        Write-Host 'An error occurred while installing Zoom Outlook Plugin.'
        # Handle if a terminating exception happens
    }
} else {
    Write-Host 'Zoom Outlook Plugin setup file not found.'
}