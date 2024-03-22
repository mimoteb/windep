# Specify the GitHub repository owner and name
$owner = "Securepoint"
$repo = "openvpn-client"

# Construct the URL for the releases endpoint of the repository
$url = "https://api.github.com/repos/$owner/$repo/releases/latest"

# Send a GET request to the GitHub API to fetch information about the latest release
$response = Invoke-RestMethod -Uri $url

# Extract the download URL of the MSI file from the response
$latestMsiLink = $response.assets | Where-Object { $_.name -like "*.msi" } | Select-Object -ExpandProperty browser_download_url

# Display the link of the latest MSI version
Write-Host $latestMsiLink
