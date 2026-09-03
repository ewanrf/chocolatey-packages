$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$msixPath = Join-Path $toolsDir 'ChatGPT-x64.msix'

$url = 'https://persistent.oaistatic.com/codex-app-prod/ChatGPT-x64.msix'
$expectedPublisher = 'CN=50BDFD77-8903-4850-9FFE-6E8522F64D5B'
$minimumBuild = 19041

if ([Environment]::OSVersion.Version.Build -lt $minimumBuild) {
    throw "ChatGPT Desktop requires Windows 10 version 2004 (build $minimumBuild) or later."
}

Get-ChocolateyWebFile `
    -PackageName $packageName `
    -FileFullPath $msixPath `
    -Url $url

$signature = Get-AuthenticodeSignature -FilePath $msixPath
if ($signature.Status -ne 'Valid' -or
    $signature.SignerCertificate.Subject -ne $expectedPublisher) {
    throw 'The downloaded ChatGPT MSIX did not have the expected valid OpenAI signature.'
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($msixPath)
try {
    $manifestEntry = $archive.GetEntry('AppxManifest.xml')
    $manifestReader = [System.IO.StreamReader]::new($manifestEntry.Open())
    try {
        $manifest = [xml]$manifestReader.ReadToEnd()
    }
    finally {
        $manifestReader.Dispose()
    }
}
finally {
    $archive.Dispose()
}

$msixVersion = [version]$manifest.Package.Identity.Version
$installedPackage = Get-AppxPackage -Name 'OpenAI.Codex' -ErrorAction SilentlyContinue |
    Sort-Object Version -Descending |
    Select-Object -First 1
if ($installedPackage -and [version]$installedPackage.Version -ge $msixVersion) {
    Write-Host "ChatGPT Desktop $($installedPackage.Version) is already installed."
    return
}

Write-Host "Installing the official ChatGPT Desktop MSIX $msixVersion."
Add-AppxPackage -Path $msixPath -ErrorAction Stop
