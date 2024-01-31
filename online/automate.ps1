$repo = 'https://github.com/mimoteb/windep/archive/refs/heads/main.zip'
$repo_OutFile = '$env:TEMP\windep.zip'
Invoke-WebRequest -Uri $repo -OutFile $repo_OutFile
# Extract the zip file
Expand-Archive -Path "$env:TEMP\windep.zip" -DestinationPath "$env:TEMP"
