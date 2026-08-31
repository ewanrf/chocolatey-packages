$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$msixPath = Join-Path $toolsDir 'ChatGPT-x64.msix'

$url = 'https://persistent.oaistatic.com/codex-app-prod/ChatGPT-x64.msix'
$checksum = '1A3088E72FCCA3F9CABB1EB288CFC9CA78BD6392DBDD42CB20D1317040AF0056'
$expectedPublisher = 'CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B'
$expectedThumbprint = 'EF37AE84D33026A24D437EDBC40A5D81A5AD0CC7'
$targetVersion = [version]'26.825.6671.0'
$minimumBuild = 19041

if ([Environment]::OSVersion.Version.Build -lt $minimumBuild) {
    throw "ChatGPT Desktop requires Windows 10 version 2004 (build $minimumBuild) or later."
}

$installedPackage = Get-AppxPackage -Name 'OpenAI.Codex' -ErrorAction SilentlyContinue |
    Sort-Object Version -Descending |
    Select-Object -First 1
if ($installedPackage -and [version]$installedPackage.Version -ge $targetVersion) {
    Write-Host "ChatGPT Desktop $($installedPackage.Version) is already installed."
    return
}

Get-ChocolateyWebFile `
    -PackageName $packageName `
    -FileFullPath $msixPath `
    -Url $url `
    -Checksum $checksum `
    -ChecksumType 'sha256'

$signature = Get-AuthenticodeSignature -FilePath $msixPath
if ($signature.Status -ne 'Valid' -or
    $signature.SignerCertificate.Subject -ne $expectedPublisher -or
    $signature.SignerCertificate.Thumbprint -ne $expectedThumbprint) {
    throw 'The downloaded ChatGPT MSIX did not have the expected valid OpenAI signature.'
}

Write-Host 'Installing the official ChatGPT Desktop MSIX.'
Add-AppxPackage -Path $msixPath -ErrorAction Stop
