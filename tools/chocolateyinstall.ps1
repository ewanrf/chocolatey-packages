$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'pdf-architect'
}

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'exe'
    url            = 'https://cdnbz.pdfarchitect.org/unify/v10/installer/latest/PDF_Architect_10_Installer.exe'
    checksum       = 'B1B99D2891BA0D9B3A288CB197E8EF3CFC1ED1EC0C3BF1E5F27BA195ED2BB1F6'
    checksumType   = 'sha256'
    silentArgs     = '/quiet /default_application=0 /run_application=0 /desktop_shortcut=0 /enable_automatic_updates=0 /disable_notification_system=1 /install_messenger=0'
    softwareName   = 'PDF Architect*'
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyPackage @packageArgs
