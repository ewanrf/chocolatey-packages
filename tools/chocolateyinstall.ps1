$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'rovo-desktop'
}

$osArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture

switch ($osArchitecture) {
    ([System.Runtime.InteropServices.Architecture]::X64) {
        $url = 'https://update-nucleus.atlassian.com/Rovo/80c27f7ff6ac3c5d4c1763c75aa54d6b/win32/x64/Rovo-1.55.163-x64.msi'
        $checksum = '8AC9D8DC4F2E6A0C536EDD27695165312D09C0BE75A7DDB0556103ADC1455792'
    }
    ([System.Runtime.InteropServices.Architecture]::Arm64) {
        $url = 'https://update-nucleus.atlassian.com/Rovo/80c27f7ff6ac3c5d4c1763c75aa54d6b/win32/arm64/Rovo-1.55.163-arm64.msi'
        $checksum = '75F6DD3EBFF03E8AD75E6F8077FB635EBB363C90764B2363F9EEC68E4D519BFE'
    }
    default {
        throw "Rovo Desktop does not provide an installer for Windows $osArchitecture."
    }
}

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'msi'
    url            = $url
    checksum       = $checksum
    checksumType   = 'sha256'
    silentArgs     = '/qn /norestart'
    softwareName   = 'Rovo'
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyPackage @packageArgs
