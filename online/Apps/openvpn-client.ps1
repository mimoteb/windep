$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# For Home office, a laptop is required - check if the PC has a battery
$Laptop = Get-WmiObject -Class Win32_Battery -ErrorAction SilentlyContinue

if ($Laptop) {
    # Laptop detected

    # Specify the destination path for the downloaded MSI file
    $SetupFile = Join-Path -Path $PSDir -ChildPath "OpenVPNClient.msi"

    # Check if the MSI file already exists
    if (-not (Test-Path $SetupFile)) {
        # Installation file doesn't exist, will start downloading from GitHub
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
        
        Write-Host "[OpenVPN] Download complete. MSI file saved to: $SetupFile" -ForegroundColor Green
    } else {
        Write-Host "[OpenVPN] MSI file already exists. Skipping download." -ForegroundColor Yellow
    }

    # Check if the SSLVpnClient.exe file exists
    $sslVpnClientPath = "C:\Program Files (x86)\Securepoint SSL VPN\SSLVpnClient.exe"
    if (Test-Path $sslVpnClientPath) {
        Write-Host "[OpenVPN] SSL VPN client already installed. Skipping installation." -ForegroundColor Yellow
    } else {
        # Execute msiexec with the specified parameters
        Start-Process -FilePath "msiexec" -ArgumentList "/qn /i `"$destinationPath`" CWINVERSION=10" -Wait
    }

}

# If execution reaches here, it means no battery is detected
Write-Host "[Laptop] No laptop detected"
