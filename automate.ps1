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
$scripts = Get-ChildItem -path "$env:TEMP\windep-main\online\*.ps1"  | Sort-Object
$logFilePath = "C:\Path\To\Your\LogFile.txt"

foreach ($script in $scripts) {
    Write-Host "[Executing] : $script" -ForegroundColor Cyan

    $process = Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $script" -PassThru -Wait

    if ($process.ExitCode -eq 0) {
        "Script $($script.FullName) executed successfully" | Out-File -Append -LiteralPath $logFilePath
    } else {
        "Error executing script $($script.FullName). Exit code: $($process.ExitCode)" | Out-File -Append -LiteralPath $logFilePath
    }
}
Write-Host 'Restart the computer'