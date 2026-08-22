$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'brother-ql800-driver'
}

$architecture = $env:PROCESSOR_ARCHITEW6432
if (-not $architecture) {
    $architecture = $env:PROCESSOR_ARCHITECTURE
}

if ($architecture -eq 'ARM64') {
    throw 'Brother does not provide a QL-800 printer driver for Windows on ARM.'
}

$tempRoot = Join-Path $env:TEMP "$packageName-$env:ChocolateyPackageVersion"
$installerPath = Join-Path $tempRoot 'bsq16aw1101cus.exe'
$extractPath = Join-Path $tempRoot 'extracted'

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    Get-ChocolateyWebFile `
        -PackageName $packageName `
        -FileFullPath $installerPath `
        -Url 'https://download.brother.com/welcome/dlfp101277/bsq16aw1101cus.exe' `
        -Checksum '836C155150696535947F598041BB1E97020D6F27BD21607BF2E2AC99B24A1713' `
        -ChecksumType 'sha256'

    Get-ChocolateyUnzip `
        -FileFullPath $installerPath `
        -Destination $extractPath

    $msiPath = Join-Path $extractPath 'Driver\Driver\bsq16a.msi'
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
