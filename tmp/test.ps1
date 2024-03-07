$tempDirectory = [System.IO.Path]::GetTempPath()

# Combine the temporary directory path with the desired subdirectory
$scriptDirectory = Join-Path $tempDirectory 'windep'
$setupPath = Join-Path $scriptDirectory "apps\7z.msi"
Write-Host $setupPath