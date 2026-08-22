# Brother PT-P750W Chocolatey package

This package installs the Brother PT-P750W Windows printer driver silently. It does not install P-touch Editor, the Printer Setting Tool, Status Monitor or wireless setup utilities.

Brother signs this driver directly rather than using Microsoft's Windows Hardware Compatibility Publisher signature. For unattended installation, the package validates the checksum-pinned installer's Authenticode signature and exact certificate thumbprint, temporarily adds that certificate to the local machine Trusted Publishers store, and removes it after installation. A certificate that was already trusted is left unchanged.

## Build

Run from the package directory:

```powershell
choco pack .\brother-ptp750w-driver.nuspec
```

## Test

Use a Windows 10 or Windows 11 test machine or VM. Disconnect the printer's USB cable before installation, as Brother instructs.

```powershell
choco install brother-ptp750w-driver --source . --yes
Get-PrinterDriver -Name 'Brother PT-P750W' -ErrorAction SilentlyContinue
pnputil.exe /enum-drivers | Select-String -Pattern 'Brother|bspp75v.inf' -Context 2,4
```

Connect the printer after the package finishes, then print a test label. Static package checks cannot confirm USB or Wi-Fi detection or printing.

To test removal:

```powershell
choco uninstall brother-ptp750w-driver --yes
```

## Vendor payload

- Driver release: 7.3.0c, 18 February 2025
- Supported OS: Windows 10 and Windows 11, x86 and x64
- ARM64: not supported by Brother
- Download: `https://download.brother.com/welcome/dlfp101264/pdp75w730cuk.exe`
- SHA-256: `EFA6200EFE7DE50C09E9ADAF027F5F9DA3AF75026B3EC0D2739403CD08247C11`
- MSI product code: `{0D17AEB7-4058-4342-8C30-A3DA2C8170C8}`
- Brother signing certificate: `9767A81893C5B7E94EF55396345A039FF1E1143D`
- Driver INF: `bspp75v.inf`

Installing the package requires acceptance of the [Brother software EULA](https://support.brother.com/g/s/agreement/English/agree.html).
