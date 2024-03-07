Write-Host '[INFO] Stopping Windows Defender' -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $true -Force
$repo = 'https://github.com/mimoteb/windep/archive/refs/heads/main.zip'
$repo_OutFile = "$env:TEMP\windep-main.zip"
$extractedPath = "$env:TEMP"

# Remove WinDep-Main directory in Temp if Existed 
$tempDirectory = [System.IO.Path]::GetTempPath()
$targetDirectory = Join-Path $tempDirectory 'windep-main'

try {
    # Check if the directory exists
    if (Test-Path -Path $targetDirectory -PathType Container) {
        # Directory exists, so remove it forcibly
        Remove-Item -Path $targetDirectory -Recurse -Force
        Write-Host "Directory $targetDirectory has been forcibly removed."
    } else {
        Write-Host "Directory $targetDirectory does not exist."
    }
} catch {
    Write-Host "An error occurred: $_"
}


try {
    Write-Host "[Downloading] from $repo" -ForegroundColor Cyan
    Write-Host "[Info] to $repo_OutFile" -ForegroundColor Yellow
    Invoke-WebRequest -Uri $repo -OutFile $repo_OutFile -ErrorAction Stop

    Write-Host "[Extracting] the repo" -foregroundcolor cyan
    Expand-Archive -Path $repo_OutFile -DestinationPath $extractedPath -ErrorAction Stop

    Write-Host "[Changing] the current directory to $extractedPath" -ForegroundColor Yellow
    
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    # Handle the error as needed (log, cleanup, etc.)
}
finally {
    # Cleanup: Remove the downloaded zip file
    Remove-Item -Path $repo_OutFile -ErrorAction SilentlyContinue
}
set-location -Path "$env:TEMP\windep-main"
Write-Host "Current Directory: $($PWD.Path)" -foregroundcolor yellow

# this will be the main script
$scripts = Get-ChildItem -path "$env:TEMP\windep-main\online\*.ps1"  | Sort-Object
foreach ($script in $scripts) {
    write-host '[Executing] :' $script -ForegroundColor cyan
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $script" -Wait
}

Write-Host 'Restart the computer'