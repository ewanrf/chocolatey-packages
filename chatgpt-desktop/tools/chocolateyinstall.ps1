$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$msixPath = Join-Path $toolsDir 'ChatGPT-x64.msix'

$url = 'https://persistent.oaistatic.com/codex-app-prod/ChatGPT-x64.msix'
$checksum = '56B4F1667A69F0661F135EFF345F7369E3557A44514E93DC141662F6B50516AF'
$expectedPublisher = 'CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B'
$expectedThumbprint = '3E7198AD1E2A836E84A0FE16E0E45379083DA80B'
$targetVersion = [version]'26.818.8289.0'

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
