Write-Host "installing Telegram"

$link = "https://telegram.org/dl/desktop/win64"

# Get the current directory
$currentDirectory = Get-Location

# Specify the subdirectory within the current directory
$installDirectory = Join-Path -Path $currentDirectory -ChildPath "apps"

# Check if Telegram is already installed by looking for its executable in the installation directory
$telegramExecutable = Join-Path -Path $installDirectory -ChildPath "Telegram.exe"
if (Test-Path $telegramExecutable) {
    Write-Host "Telegram is already installed."
} else {
    # Create the installation directory if it doesn't exist
    if (-not (Test-Path $installDirectory)) {
        New-Item -Path $installDirectory -ItemType Directory -Force
    }

    $setupPath = Join-Path -Path $installDirectory -ChildPath "telegram.exe"

    # Download the Telegram setup file
    try {
        $client = New-Object System.Net.WebClient
        $client.DownloadFile($link, $setupPath)
        Write-Host "Downloaded $link to $setupPath"
    } catch {
        Write-Host "An error occurred while downloading Telegram."
    }

    # Install Telegram silently
    if (Test-Path $setupPath) {
        try {
            Start-Process -FilePath $setupPath -ArgumentList "/VERYSILENT" -Wait
            Write-Host "Installed Telegram"
        } catch {
            Write-Host "An error occurred while installing Telegram."
        }
    }
}

