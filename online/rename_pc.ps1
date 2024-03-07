# Generate a random integer between 0 and 10000
$generatedNumber = Get-Random -Minimum 0 -Maximum 10001

# Display the result using Write-Host
Rename-Computer -NewName "Deployment-PC-$generatedNumber" -Force