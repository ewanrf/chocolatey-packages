$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'rovo-desktop'
}

$uninstallEntry = Get-UninstallRegistryKey -SoftwareName 'Rovo' |
    Where-Object { $_.DisplayName -eq 'Rovo' } |
    Sort-Object DisplayVersion -Descending |
    Select-Object -First 1

if (-not $uninstallEntry) {
    Write-Warning 'Rovo is not registered as installed. Nothing to uninstall.'
    return
}

if ($uninstallEntry.UninstallString -notmatch '(?i)\bmsiexec(?:\.exe)?\b\s+/[ix]\s*(?<productCode>\{[0-9A-F-]{36}\})') {
    throw 'Could not find the Rovo MSI product code in its uninstall command.'
}

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'msi'
    silentArgs     = "$($matches.productCode) /qn /norestart"
    validExitCodes = @(0, 1605, 1614, 1641, 3010)
}

Uninstall-ChocolateyPackage @packageArgs
