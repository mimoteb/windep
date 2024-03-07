$mPoint = 'HKLM\OFFLINENTUSER'
$NTUSER_FILE = "W:\mount\Users\Default\NTUSER.DAT"
$NTUSER_Path = $mPoint + " "+   $NTUSER_FILE
Write-Host $NTUSER_Path
reg load $NTUSER_Path
New-Item -Path $mPoint '\SOFTWARE\Policies\Microsoft' -Name 'Internet Explorer' -Force
New-Item -Path $mPoint '\SOFTWARE\Policies\Microsoft\Internet Explorer' -Name 'Main' -Force
New-ItemProperty -Path $mPoint + '\SOFTWARE\Policies\Microsoft\Internet Explorer\Main' -Name DisableFirstRunCustomize -PropertyType DWORD -Value '1' -Force
reg unload $NTUSER_Path