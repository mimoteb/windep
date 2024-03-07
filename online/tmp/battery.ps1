# Check if the computer has a battery
$batteryInfo = Get-WmiObject -Class Win32_Battery -ErrorAction SilentlyContinue

if ($batteryInfo) {
    Write-Host "Battery information available:"
    Write-Host "Manufacturer: $($batteryInfo.Manufacturer)"
    Write-Host "Status: $($batteryInfo.Status)"
    Write-Host "Battery Level: $($batteryInfo.EstimatedChargeRemaining)%"
} else {
    Write-Host "No battery found on this computer."
}
