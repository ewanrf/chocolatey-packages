$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'claude-desktop'
}

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'exe'
    url            = 'https://downloads.claude.ai/releases/win32/x64/1.34493.1/Claude-255293a41a25d54c5177aa9614fb4cd620e70b78.exe'
    checksum       = '44BC7D2BF386D4CAD48F75434F6297343DCFC27294A0667D619E08F8C732EE91'
    checksumType   = 'sha256'
    silentArgs     = '/S'
    softwareName   = 'Claude*'
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyPackage @packageArgs
