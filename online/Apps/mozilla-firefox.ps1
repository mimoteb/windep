# Get the path to the temporary directories
$TempDir = [System.IO.Path]::GetTempPath()
$BaseDir = Join-Path $TempDir 'windep-main'

# Firefox
$checkPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
$setupPath = Join-Path $scriptDirectory "apps\firefox.exe"

if (-not (Test-Path $checkPath)) {
    if (-not (Test-Path $setupPath)) {
        try {
            $client = New-Object System.Net.WebClient
            $client.DownloadFile("https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=de", $setupPath)
            Write-Host "Firefox setup file downloaded."
        } catch {
            Write-Host "An error occurred while downloading the Firefox setup file."
        }
    }

    try {
        Start-Process .\Apps\firefox.exe -Wait -ArgumentList '-ms -ma'
        Write-Host "Installed Firefox"
    } catch {
        Write-Host "An error occurred while installing Firefox."
    }
} else {
    Write-Host "Firefox is already installed."
}