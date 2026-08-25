$ErrorActionPreference = 'Stop'

$processes = @(Get-Process -Name 'ChatGPT' -ErrorAction SilentlyContinue)
if ($processes.Count -gt 0) {
    Write-Host 'Closing ChatGPT before uninstalling the MSIX.'
    $processes | Stop-Process -Force -ErrorAction Stop
}

$packages = @(Get-AppxPackage -Name 'OpenAI.Codex' -ErrorAction SilentlyContinue)
if ($packages.Count -eq 0) {
    Write-Warning 'ChatGPT Desktop is not installed for the current user. Nothing to uninstall.'
    return
}

foreach ($package in $packages) {
    Write-Host "Uninstalling $($package.PackageFullName)."
    Remove-AppxPackage -Package $package.PackageFullName -ErrorAction Stop
}
