$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
if (-not $packageName) {
    $packageName = 'brother-bpac3-client-component'
}

$installers = @{
    x86 = @{
        FileName = 'bcciw34015.msi'
        Url = 'https://download.brother.com/welcome/dlfp101009/bcciw34015.msi'
        Checksum = '5D2493B91E8666EE08BB7B628DED38FFBE09CE0A1B3911CECAE6F800E9E4D796'
        ProductCode = '{E3D06202-9680-491C-8EA9-732E04811C83}'
    }
    x64 = @{
        FileName = 'bcciw34015_64.msi'
        Url = 'https://download.brother.com/welcome/dlfp101010/bcciw34015_64.msi'
        Checksum = 'C8E11B20E5EF5361853367236794A96AC120A8A632A6D19AEDFB42786BB1150D'
        ProductCode = '{B3E26CFC-84B1-4C1A-BAA0-B8A6EF1F5EE3}'
    }
}

$tempRoot = Join-Path $env:TEMP "$packageName-$env:ChocolateyPackageVersion"

if (Test-Path -LiteralPath $tempRoot) {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    $architectures = @('x86')
    if ([Environment]::Is64BitOperatingSystem) {
        $architectures += 'x64'
    }

    foreach ($architecture in $architectures) {
        $installer = $installers[$architecture]
        $installerPath = Join-Path $tempRoot $installer.FileName

        Get-ChocolateyWebFile `
            -PackageName $packageName `
            -FileFullPath $installerPath `
            -Url $installer.Url `
            -Checksum $installer.Checksum `
            -ChecksumType 'sha256'

        $signature = Get-AuthenticodeSignature -LiteralPath $installerPath
        if ($signature.Status -ne [System.Management.Automation.SignatureStatus]::Valid) {
            throw "Brother MSI signature validation failed for ${architecture}: $($signature.StatusMessage)"
        }

        $packageArgs = @{
            packageName    = $packageName
            fileType       = 'msi'
            file           = $installerPath
            silentArgs     = '/qn /norestart'
            validExitCodes = @(0, 1641, 3010)
        }

        Install-ChocolateyInstallPackage @packageArgs
    }
}
finally {
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
