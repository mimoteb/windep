write-host '[Info] removing bloatwares' -ForegroundColor Yellow

Write-Host '[Info] Removing AppxPackages' -ForegroundColor Yellow
$tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\AppxPackage.lst')
$items = Get-Content -Path $tempPath

foreach ($item in $items) {
    $item = $item.Trim()

    # try {
    #     Get-AppxPackage -all *$item* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    #     Get-AppxPackage -all *$item* | Remove-AppPackage -ErrorAction Continue
    #     # WRONG: Remove-AppxPackage -Package $item -AllUsers -ErrorAction SilentlyContinue
    #     Write-Host "[Success] AppxPackag removed: $item" -ForegroundColor Green
    # } catch {
    #     Write-Host "[Error]: Failed to remove $item - $_" -ForegroundColor Red
    # }

    try {
        Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -match [regex]::Escape($item) } | Remove-AppxProvisionedPackage -AllUsers -ErrorAction SilentlyContinue

        #Remove-AppxProvisionedPackage -package $item -Online -ErrorAction SilentlyContinue
        Write-Host "[Success] removed provisioned package: $item" -ForegroundColor Green
    } catch {
        Write-Host "[Error]: Failed to remove $item - $_" -ForegroundColor Red
    }
}

# Write-Host '[Info] removing windows capabilities' -ForegroundColor Yellow
# $tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\capabilities.lst')
# $items = Get-Content -Path $tempPath
# foreach ($item in $items) {
#     Write-Host 'Removing:'$item
#     Remove-WindowsCapability -Online -Name $item.Trim() -Verbose -ErrorAction SilentlyContinue
# }
# Write-Host 'removing windows AppxProvisionedPackage'
# $tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\capabilities.lst')
# $items = Get-Content -Path $tempPath
# foreach($item in $items){
#     write-host 'Removing:'$item
#     Remove-AppxProvisionedPackage -PackageName $item.Trim() -Online -Verbose -ErrorAction SilentlyContinue
# }

# Write-Host '[Info] Processing Optional Features list...' -ForegroundColor Yellow
# $tempPath = [System.IO.Path]::Combine($env:TEMP, 'windep-main\lists\features.lst')
# foreach ($item in $bloatware) {
#         try {Disable-WindowsOptionalFeature -Online -FeatureName $item.Trim() -ErrorAction SilentlyContinue} catch {}
#     }