# Get the latest download URL
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object { $_.browser_download_url -like '*.msixbundle' } |
        Select-Object -ExpandProperty "browser_download_url"

# Set the download path to %temp%
$downloadPath = [System.IO.Path]::Combine($env:TEMP, "winget-cli.msix")

# Download the MSIX bundle using .NET WebClient
$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($URL, $downloadPath)

# Install the MSIX bundle
Add-AppxPackage -Path $downloadPath

# Delete the downloaded file
Remove-Item $downloadPath
