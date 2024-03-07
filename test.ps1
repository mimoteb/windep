$tempDirectory = [System.IO.Path]::GetTempPath()

# Combine the temporary directory path with the desired subdirectory
$BaseDir = Join-Path $tempDirectory 'windep-main'
Write-Host $setupPath

foreach ($d in Get-PSDrive) {
    Write-Host $d
}