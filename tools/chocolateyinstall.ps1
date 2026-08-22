$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'brother-ql700-driver'
}

$architecture = $env:PROCESSOR_ARCHITEW6432
if (-not $architecture) {
    $architecture = $env:PROCESSOR_ARCHITECTURE
}

if ($architecture -eq 'ARM64') {
    throw 'Brother does not provide a QL-700 printer driver for Windows on ARM.'
}

$tempRoot = Join-Path $env:TEMP "$packageName-$env:ChocolateyPackageVersion"
$installerPath = Join-Path $tempRoot 'qd700w650cus.exe'
$extractPath = Join-Path $tempRoot 'extracted'

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    Get-ChocolateyWebFile `
        -PackageName $packageName `
        -FileFullPath $installerPath `
        -Url 'https://download.brother.com/welcome/dlfp101262/qd700w650cus.exe' `
        -Checksum 'F1FA1761D7B785EDF27551CAC2ACD4387895CB6F0C48325C1F4B74FBD0373BF7' `
        -ChecksumType 'sha256'

    Get-ChocolateyUnzip `
        -FileFullPath $installerPath `
        -Destination $extractPath

    $msiPath = Join-Path $extractPath 'Driver\Driver\bsq70.msi'
    if (-not (Test-Path -LiteralPath $msiPath)) {
        throw "Brother driver MSI was not found at $msiPath"
    }

    # Unlike the QL-800 driver, the QL-700 catalog is signed directly by
    # Brother instead of Microsoft Windows Hardware Compatibility Publisher.
    # Trust only the exact certificate shipped with this driver so Windows
    # does not display an interactive publisher prompt during installation.
    $toolsDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
    $certificatePath = Join-Path $toolsDirectory 'brother-industries-9767a818.cer'
    $expectedThumbprint = '9767A81893C5B7E94EF55396345A039FF1E1143D'

    if (-not (Test-Path -LiteralPath $certificatePath)) {
        throw "Brother publisher certificate was not found at $certificatePath"
    }

    $publisherCertificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certificatePath)
    if ($publisherCertificate.Thumbprint -ne $expectedThumbprint) {
        throw "Brother publisher certificate thumbprint did not match $expectedThumbprint"
    }

    $publisherStore = New-Object System.Security.Cryptography.X509Certificates.X509Store(
        'TrustedPublisher',
        [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
    )

    try {
        $publisherStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $trustedCertificate = $publisherStore.Certificates | Where-Object {
            $_.Thumbprint -eq $expectedThumbprint
        }

        if (-not $trustedCertificate) {
            $publisherStore.Add($publisherCertificate)
            Write-Host 'Trusted the Brother certificate used to sign the QL-700 driver.'
        }
    }
    finally {
        $publisherStore.Close()
    }

    $packageArgs = @{
        packageName    = $packageName
        fileType       = 'msi'
        file           = $msiPath
        silentArgs     = '/qn /norestart'
        validExitCodes = @(0, 1641, 3010)
    }

    Install-ChocolateyInstallPackage @packageArgs
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
