$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'mysql-shell'
}

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$file = Join-Path $toolsDir 'mysql-shell-26.7.1-windows-x86-64bit.msi'

$packageArgs = @{
    packageName    = $packageName
    fileType       = 'msi'
    file           = $file
    silentArgs     = '/qn /norestart WIXUI_EXITDIALOGOPTIONALCHECKBOX=0 MSIFASTINSTALL=7'
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyInstallPackage @packageArgs
