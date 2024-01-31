write-host 'Disabling services/ stopping them temporarily'
$Services = Get-Content -Path .\lists\services.lst

foreach ($Service in $Services)
{
    write-host $Service
    # try 
    # {
    #     Stop-Service -Name $Service -ErrorAction SilentlyContinue
	#     net stop $Service
	# }
    
    # catch{   }
    # try
    # {
    #     Set-Service -Name $Service -StartupType 'Disabled' -ErrorAction SilentlyContinue
    #     sc config $Service start=disabled
    # }
    # catch    {  }
}