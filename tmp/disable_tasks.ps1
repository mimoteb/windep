write-host 'Disabling Tasks'
$TaskListPath = ".\lists\tasks.lst"

# Read the file line by line
Get-Content $TaskListPath | ForEach-Object {
    # Split each line into path and task name using "\" as the delimiter
    $parts = $_.Trim() -split "\\"

    # Check if there are at least two parts (path and task name)
    if ($parts.Length -ge 2) {
        # Extract the path and task name
        $taskPath = $parts[0..($parts.Length - 2)] -join "\"
        $taskName = $parts[-1]

        # Disable the task using the task path
        Disable-ScheduledTask -TaskPath $taskPath -TaskName $taskName
    }
    else {
        Write-Host "Invalid line: $_"
    }

}