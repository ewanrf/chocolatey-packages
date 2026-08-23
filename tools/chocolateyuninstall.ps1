$ErrorActionPreference = 'Stop'

$productCodes = @(
    '{E3D06202-9680-491C-8EA9-732E04811C83}',
    '{B3E26CFC-84B1-4C1A-BAA0-B8A6EF1F5EE3}'
)

foreach ($productCode in $productCodes) {
    $registryPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$productCode",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$productCode"
    )

    if ($registryPaths | Where-Object { Test-Path -LiteralPath $_ }) {
        $packageArgs = @{
            packageName    = 'brother-bpac3-client-component'
            fileType       = 'msi'
            silentArgs     = "$productCode /qn /norestart"
            validExitCodes = @(0, 1605, 1614, 1641, 3010)
        }

        Uninstall-ChocolateyPackage @packageArgs
    }
}
