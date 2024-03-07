
# Description
# Check if Office is installed
$officeInstalled = $false

# List of common Office executable names
$officeExecutables = @(
    "excel.exe",
    "winword.exe",
    "powerpnt.exe",
    "outlook.exe",
    "mspub.exe",
    "onenote.exe",
    "lync.exe"
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
        
        Write-Host "Downloading MS365"
        $office_exe = Join-Path $BaseDir '\tmp\apps\officesetup.exe'
        $office_config = Join-Path $BaseDir '\config\office-de-config.xml'
        Start-Process -Wait -FilePath $office_exe -ArgumentList "/download", $office_config
        Start-Process -Wait -FilePath $office_exe -ArgumentList "/configure", $office_config
    }
}

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue