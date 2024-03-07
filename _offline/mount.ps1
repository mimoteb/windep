. .\config.ps1

New-Item -ItemType Directory -Path $mount -Force -ErrorAction SilentlyContinue
if((Test-Path $wim) -eq $true){
    Write-Host 'Wim File is:'$Wim
    dism /get-imageInfo /imagefile:$wim
    Mount-WindowsImage -ImagePath $wim -Index 1 -Path $mount
    Get-WindowsEdition -Path $mount
    dism /get-mountedimageinfo
}else{
    Write-Host 'Wim File not found in:'$Wim
}
