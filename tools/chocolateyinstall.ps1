$ErrorActionPreference = 'Stop'

if (-not [Environment]::Is64BitOperatingSystem) {
  throw 'Windows App requires a 64-bit version of Windows.'
}

$packageName = $env:ChocolateyPackageName
$filePath = Join-Path $env:TEMP 'WindowsApp_x64_Release_2.0.1315.0.msix'
$url = 'https://res.cdn.office.net/remote-desktop-windows-client/a7014fb0-0bd0-470c-958b-dd5dbcee2d61/WindowsApp_x64_Release_2.0.1315.0.msix'
$checksum = '78112B46C21054B3FE1C63695EC9BE0ECA738193E8B0E6D2CADDD1F41D36935E'

Get-ChocolateyWebFile `
  -PackageName $packageName `
  -FileFullPath $filePath `
  -Url $url `
  -Checksum $checksum `
  -ChecksumType 'sha256'

try {
  Add-AppxPackage -Path $filePath -ForceApplicationShutdown
}
finally {
  Remove-Item -Path $filePath -Force -ErrorAction SilentlyContinue
}