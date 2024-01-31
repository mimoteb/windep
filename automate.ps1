$repo = 'https://github.com/mimoteb/windep/archive/refs/heads/main.zip'
$repo_OutFile = "$env:TEMP\windep-main.zip"
$extractedPath = "$env:TEMP"

try {
    Write-Host "Downloading from $repo"
    Write-Host "Downloading to $repo_OutFile"
    Invoke-WebRequest -Uri $repo -OutFile $repo_OutFile -ErrorAction Stop

    Write-Host "Extracting the repo"
    Expand-Archive -Path $repo_OutFile -DestinationPath $extractedPath -ErrorAction Stop

    Write-Host "Changing the current directory to $extractedPath"
    Set-Location -Path $extractedPath
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    # Handle the error as needed (log, cleanup, etc.)
}
finally {
    # Cleanup: Remove the downloaded zip file
    Remove-Item -Path $repo_OutFile -ErrorAction SilentlyContinue
}

# this will be the main script
$scriptPath = 'from a list of files'
Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $scriptPath" -Wait
