# Adobe Acrobat reader Installation
$drives = Get-PSDrive -PSProvider FileSystem

# Find the first drive with "windep" in its root path
$IsWinDep = $drives | Where-Object { Test-Path (Join-Path $_.Root "\" -ChildPath "windep") } | Select-Object -First 1
if ($null -ne $IsWinDep) {
    
    # this will be the main script
    $Scripts = Get-ChildItem -path "$env:TEMP\windep\*.ps1" -Recurse | Sort-Object
    foreach ($script in $Scripts) {
        write-host '[Executing] :' $script -ForegroundColor Cyan
        Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File $Script" -Wait
    }
}