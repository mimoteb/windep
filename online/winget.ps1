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

# Add-AppxPackage -Path "D:\data\winget-cli.msixbundle" 
$progressPreference = 'silentlyContinue'

function Download-File {
    param (
        [string]$url,
        [string]$outputPath
    )

    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $outputPath)
}

Write-Information "Downloading WinGet and its dependencies..."

Download-File -url "https://aka.ms/getwinget" -outputPath "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
Download-File -url "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -outputPath "Microsoft.VCLibs.x64.14.00.Desktop.appx"
Download-File -url "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx" -outputPath "Microsoft.UI.Xaml.2.8.x64.appx"

Add-AppxPackage -Path "Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage -Path "Microsoft.UI.Xaml.2.8.x64.appx"
Add-AppxPackage -Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

$setupPath = "C:\Program Files\7-Zip\7z.exe"

if (-not (Test-Path $setupPath)) {
    try {
        # Install 7-Zip using winget if not already installed
        winget install 7zip.7zip --force --silent

        Write-Host "7-Zip installation completed."
    } catch {
        Write-Host "An error occurred while installing 7-Zip: $_"
    }
} else {
    Write-Host "7-Zip is already installed."
}



winget install Zoom.ZoomOutlookPlugin --force --silent

# winget install Mozilla.Firefox --force --silent