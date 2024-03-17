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