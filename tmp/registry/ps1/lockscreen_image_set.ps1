# Specify the registry path and values
$registryPath = "HKLM:\Software\Policies\Microsoft\Windows\Personalization"
$valueName = "LockScreenImage"
$valueType = "String"
$imagePath = "C:\windows\web\screen\lockscreen.jpg"

# Check if the registry path exists, and create it if necessary
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force
}

# Set the lock screen image path in the registry
Set-ItemProperty -Path $registryPath -Name $valueName -Value $imagePath -Type $valueType

Write-Host "Lock screen image path set to: $imagePath"
