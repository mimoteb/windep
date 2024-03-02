$regList = Get-ChildItem -Path .\registry -Filter "*.reg"
foreach ($reg in $regList)
{
    regedit /s $reg
}

Get-ChildItem -Path .\ps1 -Filter "*.ps1" | ForEach-Object { & $_.FullName }

