# Brother QL-700 Chocolatey package

This package installs the Brother QL-700 Windows printer driver silently. It does not install P-touch Editor or other Brother utilities.

The QL-700 driver catalog is signed directly by Brother rather than Microsoft Windows Hardware Compatibility Publisher. To prevent an interactive Windows Security prompt, the package verifies Brother certificate thumbprint `9767A81893C5B7E94EF55396345A039FF1E1143D` and adds that certificate to the local machine's Trusted Publishers store before installing the MSI.

## Build

Run from the package directory:

```powershell
choco pack .\brother-ql700-driver.nuspec
```

## Test

Use a Windows 10 or Windows 11 test machine or VM. Disconnect the printer's USB cable before installation, as Brother instructs.

```powershell
choco install brother-ql700-driver --source . --yes
Get-PrinterDriver -Name 'Brother QL-700' -ErrorAction SilentlyContinue
pnputil.exe /enum-drivers | Select-String -Pattern 'Brother|bsq70v.inf' -Context 2,4
```

Connect the printer after the package finishes, then print a test label. Static package checks cannot confirm USB detection or printing.

To test removal:

```powershell
choco uninstall brother-ql700-driver --yes
```

## Vendor payload

- Driver release: 6.5.0c, 18 February 2025
- Supported OS: Windows 10 and Windows 11, x86 and x64
- ARM64: not supported by Brother
- Download: `https://download.brother.com/welcome/dlfp101262/qd700w650cus.exe`
- SHA-256: `F1FA1761D7B785EDF27551CAC2ACD4387895CB6F0C48325C1F4B74FBD0373BF7`
- MSI product code: `{1CACF9EF-3BF1-4E55-A3C5-3990C49907A2}`
- Driver INF: `bsq70v.inf`
- Publisher certificate: `9767A81893C5B7E94EF55396345A039FF1E1143D`

Installing the package requires acceptance of the [Brother software EULA](https://support.brother.com/g/s/agreement/English/agree.html).
