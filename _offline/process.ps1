. .\config.ps1

function own {
    param ($Path)
    if ((Test-Path $Path) -eq $true){
        $cmd = 'takeown /F '+$Path+'\* /A /R'
        $cmd = 'takeown /F '+$Path+'* /A /R'
        cmd.exe /c $cmd
        $cmd = 'ICACLS '+$Path+'\* /T /Q /C /RESET'
        $cmd = 'ICACLS '+$Path+'* /T /Q /C /RESET'
        cmd.exe /c $cmd
    }
}

Write-Host 'Processing Optional Features list...' -ForegroundColor Cyan
$bloatware = '.\lists\features.lst' # Path to the list of features to remove
if ((Test-Path $bloatware) -eq $true){
    # Read the list from the file
    $bloatware = Get-Content -Path $bloatware
    foreach ($item in $bloatware) {
        try {Disable-WindowsOptionalFeature -path $mount -FeatureName $item.Trim() -ErrorAction SilentlyContinue} catch {}
    }
}

Write-Host 'Processing Provisioned Packages list...' -ForegroundColor Cyan
$bloatware = '.\lists\provisioned_packages.lst'
if ((Test-Path $bloatware) -eq $true){
    # Read the list from the file
    $bloatware = Get-Content -Path $bloatware
    foreach ($item in $bloatware) {
        try {Remove-AppxProvisionedPackage -PackageName $item.Trim() -Path $mount -ErrorAction SilentlyContinue} catch {}
    }
}

Write-Host 'Processing Windows Capabilities list...' -ForegroundColor Cyan
$bloatware = '.\lists\capabilities.lst'
if ((Test-Path $bloatware) -eq $true){
    # Read the list from the file
    $bloatware = Get-Content -Path $bloatware
    foreach ($item in $bloatware) {
        try {Remove-WindowsCapability -Path $mount -Name $WindowsCapability.Trim() -ErrorAction SilentlyContinue} catch {}
    }
}


# Read the list of files to remove from file.lst
$filesToRemove = Get-Content .\lists\files.lst

# Loop through and remove files
foreach ($file in $filesToRemove) {
    $fullPath = Join-Path -Path $mount -ChildPath $file
    if ((Test-Path $file)){
        try {
            Remove-Item -Path $fullPath -Force -ErrorAction SilentlyContinue
            Write-Host '[FILE] Removed: $file'
        }catch {Write-Host '[ERROR] $_'}
    }
}

# Read the list of directories to remove from dir.lst
$dirsToRemove = Get-Content .\lists\dir.lst
# Loop through and remove directories
foreach ($dir in $dirsToRemove) {
    $fullPath = Join-Path -Path $mount -ChildPath $dir
    if ((Test-Path $fullPath)){
        own($fullPath)
        try {
            Remove-Item -Path $fullPath -Force -Recurse -ErrorAction SilentlyContinue
            Write-Host "[DIR] Removed: $fullPath"
        }catch {Write-Host "[ERROR] $_"}
    }
}

# Ensure that $mount and $windir exist before copying
if (Test-Path -Path @($mount, $windir) -PathType Container) {
    # Copy files from $windir to $mount
    Copy-Item -Path $windir\* -Destination $mount -Recurse -Force
    Write-Host "Files copied from $windir to $mount." -ForegroundColor Green
} else {
    Write-Host "Either $windir or $mount does not exist." -ForegroundColor Red
}