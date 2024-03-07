# check if firefox is installed before the installation
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

# Description
$progressPreference = 'silentlyContinue'

function Download-File {
    param (
        [string]$url,
        [string]$outputFileName
    )

    $tempDirectory = [System.IO.Path]::GetTempPath()
    $outputPath = Join-Path $tempDirectory $outputFileName

    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($url, $outputPath)

    return $outputPath
}

Write-Information "Downloading WinGet and its dependencies..."

$wingetPath = Download-File -url "https://aka.ms/getwinget" -outputFileName "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
$vclibsPath = Download-File -url "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -outputFileName "Microsoft.VCLibs.x64.14.00.Desktop.appx"
$uixamlPath = Download-File -url "https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx" -outputFileName "Microsoft.UI.Xaml.2.8.x64.appx"

Add-AppxPackage -Path $vclibsPath
Add-AppxPackage -Path $uixamlPath
Add-AppxPackage -Path $wingetPath


$setupPath = "C:\Program Files\7-Zip\7z.exe"

if (-not (Test-Path $setupPath)) {
    try {
        # Install 7-Zip using winget if not already installed
        winget install -e --silent --accept-source-agreements --accept-package-agreements 7zip.7zip --force --silent

        Write-Host "7-Zip installation completed."
    } catch {
        Write-Host "An error occurred while installing 7-Zip: $_"
    }
} else {
    Write-Host "7-Zip is already installed."
}



winget install Zoom.ZoomOutlookPlugin --force --silent

winget install Mozilla.Firefox --force --silent

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue