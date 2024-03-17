# Description

write-host 'Disabling services/ stopping them temporarily'
$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$FilePath = Join-Path $PSDir -ChildPath "services.lst"
$items = Get-Content -Path $FilePath

foreach ($item in $items)
{
    write-host ("[Service] Disabling '{0}'" -f $item) -ForegroundColor Cyan
    try 
    {Stop-Service -Name $item -ErrorAction SilentlyContinue -Force} catch{}
    try
    { Set-Service -Name $item -StartupType 'Disabled' -ErrorAction SilentlyContinue} catch{}
}