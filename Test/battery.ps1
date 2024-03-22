# Check if the computer has a battery
$Laptop = Get-WmiObject -Class Win32_Battery -ErrorAction SilentlyContinue
if ($Laptop){$Laptop = $true}
write-host 'Is Laptop: '$Laptop