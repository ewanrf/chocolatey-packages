$ErrorActionPreference = 'Stop'

$packages = Get-AppxPackage -Name 'Claude' -ErrorAction SilentlyContinue |
    Where-Object { $_.Publisher -like '*Anthropic, PBC*' }

if (-not $packages) {
    Write-Warning 'Claude Desktop is not registered for the current user. Nothing to uninstall.'
    return
}

foreach ($package in $packages) {
    Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
}
