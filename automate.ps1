Write-Host '[INFO] Stopping Windows Defender' -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $true -Force
$repo = 'https://github.com/mimoteb/windep/archive/refs/heads/main.zip'
$repo_OutFile = "$env:TEMP\windep-main.zip"
$extractedPath = "$env:TEMP"

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
$scripts = Get-ChildItem -Path "$env:TEMP\windep-main\online\*.ps1" | Sort-Object
$logFilePath = "$env:TEMP\windep.log"

foreach ($script in $scripts) {
    Write-Host "[Executing] : $($script.FullName)" -ForegroundColor Cyan

    try {
        $output = Invoke-Expression -Command "powershell -ExecutionPolicy Bypass -File $($script.FullName) 2>&1"
        $output | Out-File -Append -LiteralPath $logFilePath
        Write-Host "[Success] : $($script.FullName)" -ForegroundColor Green
    } catch {
        $errorMessage = "Error executing script $($script.FullName). Error message: $_"
        $errorMessage | Out-File -Append -LiteralPath $logFilePath
        Write-Host "[Error] : $($script.FullName)" -ForegroundColor Red
        Write-Host $errorMessage -ForegroundColor Red
    }
}

Write-Host 'Restart the computer'
