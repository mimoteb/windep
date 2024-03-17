# this file has mistakes
# get-scheduledtask | where-object {$_.taskname -like "ScheduledDefrag"} | disable-scheduledtask
# TaskPath should look like "\dir1\subdir\" when using get-scheduledtask
# when disabling or enabling the task taskname can be full path + task name
# Description
Write-Host "Disabling Tasks" -ForegroundColor Yellow
$PSDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$tempFilePath = Join-Path -Path $PSDir -ChildPath "tasks.lst"

if (Test-Path -Path $tempFilePath) {
    $tasksToDisable = Get-Content -Path $tempFilePath

    foreach ($task in $tasksToDisable) {
        $taskName = Split-Path -Path $task -Leaf

        Write-Host ("[Task] Disabling '{0}'..." -f $taskName) -ForegroundColor Cyan
        Disable-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    }
}
else {
    Write-Warning ('[WARNING] File not found: {0}' -f $tempFilePath)
}