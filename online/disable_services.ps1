write-host 'Disabling services/ stopping them temporarily'
$items = Get-Content -Path ..\lists\services.lst

foreach ($item in $items)
{
    try 
    {
        write-host 'Stopping' $item -ForegroundColor Yellow
        Stop-Service -Name $item -ErrorAction SilentlyContinue
	    net stop $item
	}
    
    catch{   }
    try
    {
        write-host 'Disabling' $item -ForegroundColor Yellow
        Set-Service -Name $item -StartupType 'Disabled' -ErrorAction SilentlyContinue
        sc config $item start=disabled
    }
    catch{  }
}
