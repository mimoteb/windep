# the file name should be changed
# New Challenge: let the pre.ps1 run at the very first beginning and post.ps1 the last one!
# Description
Write-Host '[INFO] Stopping Windows Defender' -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $true -Force
$URL = 'https://github.com/mimoteb/windep/archive/refs/heads/main.zip'
$repo_OutFile = (Join-Path $env:TEMP "\windep-main.zip")
$TempDir = [System.IO.Path]::GetTempPath()
$BaseDir = Join-Path $TempDir 'windep-main'
# Remove WinDep-Main directory in Temp if Existed 


try {
    # Check if the directory exists
    if (Test-Path -Path $BaseDir -PathType Container) {
        # Directory exists, so remove it forcibly
        Remove-Item -Path $BaseDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Directory $BaseDir has been forcibly removed." -ForegroundColor Yellow
    } else {
        Write-Host "Directory $BaseDir does not exist." -foregroundcolor yellow
    }
} catch {
    Write-Host "An error occurred: $_"
}


try {
    Write-Host "[Downloading] from $URL" -ForegroundColor Cyan
    Write-Host "[Info] to $repo_OutFile" -ForegroundColor Yellow
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($URL, $repo_OutFile)
    #Invoke-WebRequest -Uri $repo -OutFile $repo_OutFile -ErrorAction Stop

    Write-Host "[Extracting] the repo" -foregroundcolor cyan
    Expand-Archive -Path $repo_OutFile -DestinationPath $TempDir -ErrorAction Stop

    Write-Host "[Changing] the current directory to $TempDir" -ForegroundColor Yellow
    
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
    # Handle the error as needed (log, cleanup, etc.)
}
finally {
    # Cleanup: Remove the downloaded zip file
    Remove-Item -Path $repo_OutFile -Force -ErrorAction SilentlyContinue
}
Set-Location -Path $BaseDir
Write-Host "Current Directory: $($PWD.Path)" -foregroundcolor yellow

# this will be the main script
$scripts = Get-ChildItem -path "$env:TEMP\windep-main\online\*.ps1" -Recurse | Sort-Object
foreach ($script in $scripts) {
    write-host '[Executing] :' $script -ForegroundColor Cyan
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $script" -Wait
    Remove-Item -Path $script -Force -ErrorAction SilentlyContinue
}

Write-Host 'Restart the computer'

# Finally delete this script
# Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue