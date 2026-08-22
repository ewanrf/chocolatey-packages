$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'brother-ptp700-driver'
}

$architecture = $env:PROCESSOR_ARCHITEW6432
if (-not $architecture) {
    $architecture = $env:PROCESSOR_ARCHITECTURE
}

if ($architecture -eq 'ARM64') {
    throw 'Brother does not provide a PT-P700 printer driver for Windows on ARM.'
}

$tempRoot = Join-Path $env:TEMP "$packageName-$env:ChocolateyPackageVersion"
$installerPath = Join-Path $tempRoot 'pdp70w730dus.exe'
$extractPath = Join-Path $tempRoot 'extracted'

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    Get-ChocolateyWebFile `
        -PackageName $packageName `
        -FileFullPath $installerPath `
        -Url 'https://download.brother.com/welcome/dlfp101261/pdp70w730dus.exe' `
        -Checksum '45DC86CB32AA7D82C9ABA72ACDBF749AE8EE8F58DC972ED2EFCEA2F3571B3E09' `
        -ChecksumType 'sha256'

    Get-ChocolateyUnzip `
        -FileFullPath $installerPath `
        -Destination $extractPath

    $msiPath = Join-Path $extractPath 'Driver\Driver\bspp70.msi'
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
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}

