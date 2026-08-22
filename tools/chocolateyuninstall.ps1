$ErrorActionPreference = 'Stop'

$packageArgs = @{
    packageName    = 'brother-ql800-driver'
    fileType       = 'msi'
    silentArgs     = '{FCFD8743-24E3-4C8E-B494-02F41BDD1906} /qn /norestart'
    validExitCodes = @(0, 1605, 1614, 1641, 3010)
}

Uninstall-ChocolateyPackage @packageArgs

$pnputilPath = Join-Path $env:SystemRoot 'System32\pnputil.exe'
$driverPackages = Get-WindowsDriver -Online -All | Where-Object {
    $_.ProviderName -like 'Brother*' -and
    [System.IO.Path]::GetFileName($_.OriginalFileName) -eq 'bsq16av.inf'
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
