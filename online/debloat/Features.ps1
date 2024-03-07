# Description
Write-Host '[Windows Optional Features] Disabling Features' -ForegroundColor Yellow

$curDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$JunkPath = Join-Path $curDir 'Features.lst'
$JunkItems = Get-Content -Path $JunkPath

foreach ($item in $JunkItems) {
        try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue -NoRestart
        Write-Host "[Feature] Disabling "$item.Trim()} catch {}
    }

# Finally delete this script
Remove-Item -Path $MyInvocation.MyCommand.Source -Force -ErrorAction SilentlyContinue