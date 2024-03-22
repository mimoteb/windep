$drives = Get-PSDrive -PSProvider FileSystem

# Find the first drive with "windep" in its root path
$IsWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1

# Display the result
if ($null -ne $IsWinDep) {
    $DriveLetter = $IsWinDep.Name 
    $WinDep = (Join-Path $DriveLetter '\windep\')
    Write-Host "[$WinDep] Found 'windep'" -ForegroundColor Green
    
    }