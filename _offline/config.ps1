$base = "C:\data\windep\win10de\"

$backupdir = $base + "backup\"
$mount = $base + "mount\"
$iso = $base + 'iso\'
$wim = $iso+"sources\install.wim"

$PSdir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$PSdir = $PSdir +'\'
$lists = $PSdir+"lists\"
$windir =  $PSdir + "windir\"

Write-Host "[base]          $base"
Write-Host "[Mount]         $mount"
Write-Host "[backupdir]     $backupdir"
Write-Host "[wim]           $wim"
Write-Host "[lists]         $lists"
Write-Host "[PSdir]         $PSdir"
Write-Host "[windir]$windir"