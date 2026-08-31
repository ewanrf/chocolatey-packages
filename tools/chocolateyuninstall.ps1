$ErrorActionPreference = 'Stop'

$packageIdentity = 'Microsoft.MicrosoftOfficeHub'
try {
    $processes = @(Get-Process -Name 'Microsoft.MicrosoftOfficeHub', 'OfficeHub' -ErrorAction SilentlyContinue)
    if ($processes.Count -gt 0) {
        $processes | Stop-Process -Force -ErrorAction Stop
    }

    $packages = @(Get-AppxPackage -Name $packageIdentity -ErrorAction SilentlyContinue)
    foreach ($package in $packages) {
        Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
    }

    Write-Host 'Uninstalled.'
}
catch {
    throw "Uninstall failed: $($_.Exception.Message)"
}
