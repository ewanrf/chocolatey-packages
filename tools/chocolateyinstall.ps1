$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$installerPath = Join-Path $toolsDir 'M365CopilotDesktopInstaller.exe'
$logPath = Join-Path $env:TEMP 'M365CopilotDesktopInstaller.log'

$url = 'https://res.cdn.office.net/s01-officehomewindows/5mttl/prod/M365CopilotDesktopInstaller.exe'
$checksum = '7B2A6D88E87F068E8775D1DE267EE932914F430BFA054A2012DEC43FA279E61A'
$expectedPublisher = 'CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US'
$expectedThumbprint = 'F5877012FBD62FABCBDC8D8CEE9C9585BA30DF79'
$packageIdentity = 'Microsoft.MicrosoftOfficeHub'

try {
    Get-ChocolateyWebFile `
        -PackageName $packageName `
        -FileFullPath $installerPath `
        -Url $url `
        -Checksum $checksum `
        -ChecksumType 'sha256'

    $signature = Get-AuthenticodeSignature -FilePath $installerPath
    if ($signature.Status -ne 'Valid' -or
        $signature.SignerCertificate.Subject -ne $expectedPublisher -or
        $signature.SignerCertificate.Thumbprint -ne $expectedThumbprint) {
        throw 'The bootstrapper signature was not the expected valid Microsoft signature.'
    }

    $process = Start-Process `
        -FilePath $installerPath `
        -ArgumentList @('--quiet', '--logfile', $logPath) `
        -Wait `
        -PassThru

    if ($process.ExitCode -ne 0) {
        throw "The bootstrapper exited with code $($process.ExitCode). See $logPath."
    }

    $installedPackage = Get-AppxPackage -Name $packageIdentity -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending |
        Select-Object -First 1

    if (-not $installedPackage) {
        throw 'The MSIX package was not detected after the bootstrapper completed.'
    }

    Write-Host 'Installed.'
}
catch {
    throw "Install failed: $($_.Exception.Message)"
}
