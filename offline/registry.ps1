Write-Host "[INFO] importing registry entries"
# Default Profile
REG LOAD HKLM\NTUSER $mount\users\Default\NTUSER.DAT

# Removes Task View from the Taskbar
try {
    New-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value "0" -PropertyType DWord -ErrorAction SilentlyContinue
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

# Removes Widgets from the Taskbar
try {
    
    New-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue
} catch {
    Write-Host "An error occurred while removing Widgets: $_" -ForegroundColor Red
}

# Removes Chat from the Taskbar
try {
    
    New-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue
} catch {
    Write-Host "An error occurred while removing Chat: $_" -ForegroundColor Red
}

# Default StartMenu alignment 0=Left
try {
    New-ItemProperty "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 0 -PropertyType DWord -ErrorAction SilentlyContinue
} catch {
    Write-Host "An error occurred while setting Default StartMenu alignment: $_" -ForegroundColor Red
}

# Removes search from the Taskbar
try {
    
    Set-ItemProperty -Path "HKLM:\NTUSER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0 -ErrorAction SilentlyContinue
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

# Remove OneDriveSetup
try {
    
    Remove-Item "HKLM:\NTUSER\Software\Microsoft\Windows\CurrentVersion\Run" -ErrorAction SilentlyContinue
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}

REG UNLOAD HKLM\NTUSER