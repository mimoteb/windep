$checkPath = "C:\Program Files\7-Zip\7z.exe"
$setupPath = Join-Path $BaseDir "apps\7z.msi"

if (-not (Test-Path $checkPath)) {
    if (-not (Test-Path $setupPath)) {
        try {
            $client = New-Object System.Net.WebClient
            "https://7-zip.org/a/.msi"
            $client.DownloadFile("https://7-zip.org/a/7z2301-x64.msi", $setupPath)
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