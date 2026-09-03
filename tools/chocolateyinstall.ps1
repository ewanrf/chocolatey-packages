$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'claude-desktop'
}

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$expectedPublisher = 'CN="Anthropic, PBC", O="Anthropic, PBC", L=San Francisco, S=California, C=US, SERIALNUMBER=4860621, OID.2.5.4.15=Private Organization, OID.1.3.6.1.4.1.311.60.2.1.2=Delaware, OID.1.3.6.1.4.1.311.60.2.1.3=US'
$minimumBuild = 19041

if ([Environment]::OSVersion.Version.Build -lt $minimumBuild) {
    throw "Claude Desktop requires Windows 10 version 2004 (build $minimumBuild) or later."
}

switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()) {
    'X64' { $architecture = 'x64' }
    'Arm64' { $architecture = 'arm64' }
    default { throw 'Claude Desktop requires Windows x64 or ARM64.' }
}

$url = "https://claude.ai/api/desktop/win32/$architecture/msix/latest/redirect"
$msixPath = Get-ChocolateyWebFile -PackageName $packageName `
    -FileFullPath (Join-Path $toolsDir "Claude-$architecture.msix") `
    -Url $url -ForceDownload

$signature = Get-AuthenticodeSignature -FilePath $msixPath
if ($signature.Status -ne 'Valid' -or
    $signature.SignerCertificate.Subject -ne $expectedPublisher) {
    throw 'The downloaded Claude MSIX did not have the expected valid Anthropic signature.'
}

Add-Type -AssemblyName System.IO.Compression.FileSystem
$archive = [System.IO.Compression.ZipFile]::OpenRead($msixPath)
try {
    $manifestEntry = $archive.GetEntry('AppxManifest.xml')
    if (-not $manifestEntry) { throw 'The Claude MSIX does not contain AppxManifest.xml.' }
    $reader = [System.IO.StreamReader]::new($manifestEntry.Open())
    try { $manifest = [xml]$reader.ReadToEnd() }
    finally { $reader.Dispose() }
}
finally { $archive.Dispose() }

$identity = $manifest.Package.Identity
if ($identity.Name -ne 'Claude' -or $identity.Publisher -ne $expectedPublisher -or
    $identity.ProcessorArchitecture -ne $architecture) {
    throw 'The downloaded MSIX does not match the expected Claude app identity and architecture.'
}

$deviceFamily = $manifest.Package.Dependencies.TargetDeviceFamily |
    Where-Object { $_.Name -eq 'Windows.Desktop' } | Select-Object -First 1
if (-not $deviceFamily) { throw 'The Claude MSIX does not declare Windows.Desktop support.' }
if ([Environment]::OSVersion.Version -lt [version]$deviceFamily.MinVersion) {
    throw "This Claude release requires Windows $($deviceFamily.MinVersion) or later."
}

$msixVersion = [version]$identity.Version
$installedPackage = Get-AppxPackage -Name 'Claude' -ErrorAction Stop |
    Where-Object { $_.Publisher -eq $expectedPublisher } |
    Sort-Object { [version]$_.Version } -Descending |
    Select-Object -First 1
if ($installedPackage -and [version]$installedPackage.Version -ge $msixVersion) {
    Write-Host "Claude Desktop $($installedPackage.Version) is already installed."
    return
}

Write-Host "Installing the official Claude Desktop MSIX $msixVersion."
Add-AppxPackage -Path $msixPath -ForceApplicationShutdown -ErrorAction Stop
