$repo = 'https://github.com/mimoteb/windep/archive/refs/heads/main.zip'
$repo_OutFile = '$env:TEMP\windep-main.zip'
Invoke-WebRequest -Uri $repo -OutFile $repo_OutFile
# Extract the zip file
Expand-Archive -Path $repo_OutFile -DestinationPath "$env:TEMP"
set-location -Path "$env:TEMP\windep-main\"