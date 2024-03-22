
$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
# Specify the URL of the GitHub releases page
$url = "https://api.github.com/repos/Securepoint/openvpn-client/releases/latest"

# Send a GET request to the GitHub API to fetch information about the latest release
$response = Invoke-RestMethod -Uri $url

# Extract the download URL of the MSI file from the response
$latestMsiLink = $response.assets | Where-Object { $_.name -like "*.msi" } | Select-Object -ExpandProperty browser_download_url

# Specify the destination path for the downloaded MSI file
$destinationPath = Join-Path -Path $PSDir -ChildPath "OpenVPNClient.msi"

# Check if the MSI file already exists
if (-not (Test-Path $destinationPath)) {
    # Create a WebClient object
    $webClient = New-Object System.Net.WebClient
    
    # Download the MSI file from the link
    $webClient.DownloadFile($latestMsiLink, $destinationPath)
    
    # Dispose of the WebClient object
    $webClient.Dispose()
    
    Write-Host "Download complete. MSI file saved to: $destinationPath"
} else {
    Write-Host "MSI file already exists. Skipping download."
}

# Execute msiexec with the specified parameters
Start-Process -FilePath "msiexec" -ArgumentList "/qn /i `"$destinationPath`" CWINVERSION=10" -Wait
