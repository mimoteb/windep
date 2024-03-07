$tempDirectory = [System.IO.Path]::GetTempPath()

# Combine the temporary directory path with the desired subdirectory
$BaseDir = Join-Path $tempDirectory 'windep'

# List all drives
$drives = Get-PSDrive -PSProvider FileSystem

# Find the first drive with "windep" in its root path
$localWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1

# Display the result
if ($localWinDep -ne $null) {
    $localWinDepLetter = $localWinDep.Name
    Write-Host "[$localWinDepLetter] Found 'windep'" -ForegroundColor Green
} else {
    Write-Host "[$localWinDepLetter] No drive found with 'windep' in its root path." -ForegroundColor Red
}
