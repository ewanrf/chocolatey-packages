$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'mysql-shell'
}

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'msi'
    silentArgs     = '{377D7936-CCED-4650-AC69-445D3063ABE0} /qn /norestart'
    validExitCodes = @(0, 1605, 1614, 1641, 3010)
}

Uninstall-ChocolateyPackage @packageArgs
