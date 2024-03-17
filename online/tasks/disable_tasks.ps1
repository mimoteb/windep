# this file has mistakes
# get-scheduledtask | where-object {$_.taskname -like "ScheduledDefrag"} | disable-scheduledtask
# TaskPath should look like "\dir1\subdir\"
# Description
write-host 'Disabling Tasks'
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\config\tasks.lst')
$items = Get-Content -Path $tempPath
# Read the file line by line
Get-Content $items | ForEach-Object {
    # Split each line into path and task name using "\" as the delimiter
    $parts = $_.Trim() -split "\\"

    # Check if there are at least two parts (path and task name)
    if ($parts.Length -ge 2) {
        # Extract the path and task name
        $taskPath = $parts[0..($parts.Length - 2)] -join "\"
        $taskName = $parts[-1]
        Write-Host '[Task] Disabling' $taskName -ForegroundColor Cyan
        # Disable the task using the task path
        Disable-ScheduledTask -TaskPath $taskPath -TaskName $taskName
    }
    else {
        Write-Host "[ERROR] Invalid line: $_" -ForegroundColor Red
    }

}


$tasks = @(
	"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
	"Microsoft\Windows\Application Experience\ProgramDataUpdater"
	"Microsoft\Windows\Autochk\Proxy"
	"Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
	"Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
	"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
	"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
)
foreach ($task in $tasks) {
	schtasks /Change /TN $task /Disable | Out-Null
}


# Disable Unneeded Scheduled Tasks
Write-Host "Disabling Unneeded Scheduled Tasks..."
schtasks /Change /TN Microsoft\Windows\CloudExperienceHost\CreateObjectTask /Disable | Out-Null
schtasks /Change /TN Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector /Disable | Out-Null
schtasks /Change /TN Microsoft\Windows\DiskFootprint\Diagnostics /Disable | Out-Null
schtasks /Change /TN Microsoft\Windows\Feedback\Siuf\DmClient /Disable | Out-Null
schtasks /Change /TN Microsoft\Windows\NetTrace\GatherNetworkInfo /Disable | Out-Null
schtasks /Change /TN Microsoft\Windows\Windows Error Reporting\QueueReporting /Disable | Out-Null

Write-Host "Disabling Scheduled Tasks..."
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Application Experience\StartupAppTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maps\MapsToastTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Maps\MapsUpdateTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Shell\FamilySafetyMonitor"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\WDI\ResolutionHost"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Autochk\Proxy"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Feedback\Siuf\DmClient"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"
Disable-ScheduledTask -TaskName "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
Disable-ScheduledTask -TaskName "\Microsoft\XblGameSave\XblGameSaveTask"
Unregister-ScheduledTask -TaskName 'Optimize Drives' -Confirm:$false
schtasks /Change /TN "Microsoft\Windows\Defrag\ScheduledDefrag" /Disable
