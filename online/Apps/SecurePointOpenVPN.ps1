
$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Specify the destination path for the downloaded MSI file
$SetupFile = Join-Path -Path $PSDir -ChildPath "OpenVPNClient.msi"

# Check if the MSI file already exists
if (-not (Test-Path $SetupFile)) {
    # Installation file doesn't exist, will start downloading from github
    # Specify the URL of the GitHub releases page
    $url = "https://api.github.com/repos/Securepoint/openvpn-client/releases/latest"

    # Send a GET request to the GitHub API to fetch information about the latest release
    $response = Invoke-RestMethod -Uri $url

    # Extract the download URL of the MSI file from the response
    $latestMsiLink = $response.assets | Where-Object { $_.name -like "*.msi" } | Select-Object -ExpandProperty browser_download_url

    # Create a WebClient object
    $webClient = New-Object System.Net.WebClient
    
    # Download the MSI file from the link
    $webClient.DownloadFile($latestMsiLink, $SetupFile)
    
    # Dispose of the WebClient object
    $webClient.Dispose()
    
    Write-Host "Download complete. MSI file saved to: $SetupFile"
} else {
    Write-Host "MSI file already exists. Skipping download."
}
# Check if the SSLVpnClient.exe file exists
$sslVpnClientPath = "C:\Program Files (x86)\Securepoint SSL VPN\SSLVpnClient.exe"
if (Test-Path $sslVpnClientPath) {
    Write-Host "SSL VPN client already installed. Skipping installation."
} else {
    # Execute msiexec with the specified parameters
    Start-Process -FilePath "msiexec" -ArgumentList "/qn /i `"$destinationPath`" CWINVERSION=10" -Wait
}