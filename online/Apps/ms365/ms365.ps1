# the paths are incorrect
# OneNote is usually is a preinstalled software and should be removed from $officeExecutables check list to actually allow the installation of microsoft 365
# Description
# Check if Office is installed
$officeInstalled = $false
$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$office_exe = Join-Path $PSDir '\setup.exe'
$office_config = Join-Path $PSDir '\config.xml'
# List of common Office executable names
$officeExecutables = @(
    "excel.exe",
    "winword.exe",
    "powerpnt.exe",
    "outlook.exe"
)

# Check if any Office executable exists in Program Files directory
$programFilesPath = [System.IO.Path]::Combine($env:ProgramFiles, "Microsoft Office")

foreach ($executable in $officeExecutables) {
    $executablePath = Get-ChildItem -Path $programFilesPath -Recurse -Filter $executable -File | Select-Object -ExpandProperty FullName
    if ($executablePath) {
        Write-Host '[Microsoft 365] The Software is already installed on the system' -foregroundcolor Yellow
        $officeInstalled = $true
        break
    }else{
        if ($officeInstalled) {
            Write-Host "Microsoft Office is installed."
        } else {
            Write-Host "Microsoft Office is not installed."
        }
        Write-Host '[MS365] Downloading' -ForegroundColor Cyan
        Start-Process -Wait -FilePath $office_exe -ArgumentList "/download", $office_config
        Write-Host '[MS365] Installing'
        Start-Process -Wait -FilePath $office_exe -ArgumentList "/configure", $office_config
    }
}

