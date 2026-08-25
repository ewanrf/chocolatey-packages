$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'claude-desktop'
}

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

if ([Environment]::OSVersion.Version.Build -lt 18362) {
    throw 'Claude Desktop requires Windows 10 version 1903 or later.'
}

switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture) {
    ([System.Runtime.InteropServices.Architecture]::X64) {
        $url = 'https://claude.ai/api/desktop/win32/x64/msix/latest/redirect'
        $checksum = 'AD5EAD595FEC1977C0CCB1D7FAB3BE040773B716451431DBD6BAB457BA31A55C'
    }
    ([System.Runtime.InteropServices.Architecture]::Arm64) {
        $url = 'https://claude.ai/api/desktop/win32/arm64/msix/latest/redirect'
        $checksum = '3F5ECCED9682CF1BCA9226DCF4275C9747494B0DE7971812A9B1CCF57D7F9395'
    }
    default {
        throw "Claude Desktop does not provide an MSIX installer for Windows $([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)."
    }
}

$installerPath = Join-Path $toolsDir 'Claude.msix'

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $installerPath -Url $url -Checksum $checksum -ChecksumType 'sha256'
Add-AppxPackage -Path $installerPath -ForceApplicationShutdown -ErrorAction Stop
