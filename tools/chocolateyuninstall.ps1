$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = 'brother-ptp700-driver'
    fileType       = 'msi'
    silentArgs     = '{8FB77D96-81CA-43F5-879A-8D7714454DFE} /qn /norestart'
    validExitCodes = @(0, 1605, 1614, 1641, 3010)
}

Uninstall-ChocolateyPackage @packageArgs

$pnputilPath = Join-Path $env:SystemRoot 'System32\pnputil.exe'
$driverPackages = Get-WindowsDriver -Online -All | Where-Object {
    $_.ProviderName -like 'Brother*' -and
    [System.IO.Path]::GetFileName($_.OriginalFileName) -eq 'bspp70v.inf'
}

foreach ($driverPackage in $driverPackages) {
    $process = Start-Process `
        -FilePath $pnputilPath `
        -ArgumentList @('/delete-driver', $driverPackage.Driver, '/uninstall') `
        -Wait `
        -PassThru `
        -NoNewWindow

    if ($process.ExitCode -ne 0) {
        throw "Failed to remove Brother driver package $($driverPackage.Driver). pnputil exited with code $($process.ExitCode)."
    }
}

