# Get the latest download URL
# $URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
# $URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
#         Select-Object -ExpandProperty "assets" |
#         Where-Object { $_.browser_download_url -like '*.msixbundle' } |
#         Select-Object -ExpandProperty "browser_download_url"

# # Set the download path to %temp%
# $downloadPath = [System.IO.Path]::Combine($env:TEMP, "winget-cli.msix")

# # Download the MSIX bundle using .NET WebClient
# $webClient = New-Object System.Net.WebClient
# $webClient.DownloadFile($URL, $downloadPath)

# # Install the MSIX bundle
# Add-AppxPackage -Path $downloadPath

# # Delete the downloaded file
# Remove-Item $downloadPath

Add-AppxPackage -Path "D:\data\winget-cli.msixbundle"

$checkPath = "C:\Program Files\7-Zip\7z.exe"
$setupPath = Join-Path $scriptDirectory "apps\7z.msi"

if (-not (Test-Path $checkPath)) {
    if (-not (Test-Path $setupPath)) {
        try {
            winget install 7zip.7zip --force --silent
            # $client = New-Object System.Net.WebClient
            # "https://7-zip.org/a/.msi"
            # $client.DownloadFile("https://7-zip.org/a/7z2301-x64.msi", $setupPath)
            Write-Host "7-Zip setup file downloaded."
        } catch {
            Write-Host "An error occurred while downloading the 7-Zip setup file."
        }
    }

    try {
        Start-Process msiexec.exe -Wait -ArgumentList "/i `"$setupPath`" /quiet"
        Write-Host "Installed 7-Zip"
    } catch {
        Write-Host "An error occurred while installing 7-Zip."
    }
} else {
    Write-Host "7-Zip is already installed."
}



winget install Zoom.ZoomOutlookPlugin --force --silent

# winget install Mozilla.Firefox --force --silent