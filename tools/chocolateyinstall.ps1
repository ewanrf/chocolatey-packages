$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'brother-ptp750w-driver'
}

$architecture = $env:PROCESSOR_ARCHITEW6432
if (-not $architecture) {
    $architecture = $env:PROCESSOR_ARCHITECTURE
}

if ($architecture -eq 'ARM64') {
    throw 'Brother does not provide a PT-P750W printer driver for Windows on ARM.'
}

$tempRoot = Join-Path $env:TEMP "$packageName-$env:ChocolateyPackageVersion"
$installerPath = Join-Path $tempRoot 'pdp75w730cuk.exe'
$extractPath = Join-Path $tempRoot 'extracted'
$expectedPublisherThumbprint = '9767A81893C5B7E94EF55396345A039FF1E1143D'
$publisherCertificateAdded = $false

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    Get-ChocolateyWebFile `
        -PackageName $packageName `
        -FileFullPath $installerPath `
        -Url 'https://download.brother.com/welcome/dlfp101264/pdp75w730cuk.exe' `
        -Checksum 'EFA6200EFE7DE50C09E9ADAF027F5F9DA3AF75026B3EC0D2739403CD08247C11' `
        -ChecksumType 'sha256'

    $signature = Get-AuthenticodeSignature -LiteralPath $installerPath
    if ($signature.Status -ne [System.Management.Automation.SignatureStatus]::Valid) {
        throw "Brother driver signature validation failed: $($signature.StatusMessage)"
    }

    $publisherCertificate = $signature.SignerCertificate
    if (-not $publisherCertificate -or $publisherCertificate.Thumbprint -ne $expectedPublisherThumbprint) {
        throw "Brother driver publisher certificate did not match expected thumbprint $expectedPublisherThumbprint."
    }

    $publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new(
        'TrustedPublisher',
        [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
    )
    $publisherStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
    try {
        $trustedCertificates = $publisherStore.Certificates.Find(
            [System.Security.Cryptography.X509Certificates.X509FindType]::FindByThumbprint,
            $expectedPublisherThumbprint,
            $false
        )

        if ($trustedCertificates.Count -eq 0) {
            $publisherStore.Add($publisherCertificate)
            $publisherCertificateAdded = $true
        }
    }
    finally {
        $publisherStore.Close()
    }

    Get-ChocolateyUnzip `
        -FileFullPath $installerPath `
        -Destination $extractPath

    $msiPath = Join-Path $extractPath 'Driver\Driver\bspp75.msi'
    if (-not (Test-Path -LiteralPath $msiPath)) {
        throw "Brother driver MSI was not found at $msiPath"
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
    try {
        if ($publisherCertificateAdded) {
            $publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new(
                'TrustedPublisher',
                [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
            )
            $publisherStore.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
            try {
                $trustedCertificates = $publisherStore.Certificates.Find(
                    [System.Security.Cryptography.X509Certificates.X509FindType]::FindByThumbprint,
                    $expectedPublisherThumbprint,
                    $false
                )

                foreach ($certificate in $trustedCertificates) {
                    $publisherStore.Remove($certificate)
                }
            }
            finally {
                $publisherStore.Close()
            }
        }
    }
    finally {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
