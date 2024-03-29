# Description
Write-Host '[Windows Optional Features] Disabling Features' -ForegroundColor Yellow

$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'Features.lst'
$JunkItems = Get-Content -Path $JunkPath

foreach ($item in $JunkItems) {
        try {
            Write-Host ('[Feature] Removing: {0}' -f $item.Trim()) -ForegroundColor Cyan
            Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue -NoRestart
        } catch {}
    }