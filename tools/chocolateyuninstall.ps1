$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'pdf-architect'
}

$moduleEntries = @(
    Get-UninstallRegistryKey -SoftwareName 'PDF Architect 10*' |
        Where-Object {
            $_.DisplayName -match '^PDF Architect 10 (View|OCR|OCR TESS) Module$'
        } |
        Sort-Object `
            @{ Expression = { if ($_.DisplayName -eq 'PDF Architect 10 View Module') { 1 } else { 0 } } }, `
            DisplayName
)

foreach ($moduleEntry in $moduleEntries) {
    if ($moduleEntry.UninstallString -notmatch '(?i)\bmsiexec(?:\.exe)?\b\s+/[ix]\s*(?<productCode>\{[0-9A-F-]{36}\})') {
        throw "Could not find an MSI product code in the uninstall command for $($moduleEntry.DisplayName)."
    }

    $packageArgs = @{
        packageName    = $packageName
        fileType       = 'msi'
        silentArgs     = "$($matches.productCode) /qn /norestart"
        validExitCodes = @(0, 1605, 1614, 1641, 3010)
    }

    Uninstall-ChocolateyPackage @packageArgs
}

$remainingModules = @(
    Get-UninstallRegistryKey -SoftwareName 'PDF Architect 10*' |
        Where-Object {
            $_.DisplayName -match '^PDF Architect 10 (View|OCR|OCR TESS) Module$'
        }
)

if ($remainingModules.Count -gt 0) {
    throw 'PDF Architect MSI modules are still registered after uninstall. The wrapper entry was not removed.'
}

$wrapperEntries = @(
    Get-UninstallRegistryKey -SoftwareName 'PDF Architect 10' |
        Where-Object {
            $_.DisplayName -eq 'PDF Architect 10'
        }
)

foreach ($wrapperEntry in $wrapperEntries) {
    if (Test-Path -LiteralPath $wrapperEntry.PSPath) {
        Remove-Item -LiteralPath $wrapperEntry.PSPath -Force
    }
}
