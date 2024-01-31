$repo = 'https://raw.githubusercontent.com/mimoteb/win/main/online/automate.ps1?'
$repo_OutFile = '%temp%\windep.zip'
Invoke-WebRequest -Uri $repo -OutFile $repo_OutFile
# Extract the zip file
Expand-Archive -Path "$env:TEMP\windep.zip" -DestinationPath "$env:TEMP"
