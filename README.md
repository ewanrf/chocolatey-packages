# Brother PT-P700 Chocolatey package

This package installs the Brother PT-P700 Windows printer driver silently. It does not install P-touch Editor, P-touch Update Software, or the Printer Setting Tool.

## Build

Run from the package directory:

```powershell
choco pack .\brother-ptp700-driver.nuspec
```

## Test

Use a Windows 10 or Windows 11 test machine or VM. Disconnect the printer's USB cable before installation, as Brother instructs.

```powershell
choco install brother-ptp700-driver --source . --yes
Get-PrinterDriver -Name 'Brother PT-P700' -ErrorAction SilentlyContinue
pnputil.exe /enum-drivers | Select-String -Pattern 'Brother|bspp70v.inf' -Context 2,4
```

Connect the printer after the package finishes, then print a test label. Static package checks cannot confirm USB detection or printing.

To test removal:

```powershell
choco uninstall brother-ptp700-driver --yes
```

## Vendor payload

- Driver release: 7.3.0d, 17 February 2025
- Supported OS: Windows 10 and Windows 11, x86 and x64
- ARM64: not supported by Brother
- Download: `https://download.brother.com/welcome/dlfp101261/pdp70w730dus.exe`
- SHA-256: `45DC86CB32AA7D82C9ABA72ACDBF749AE8EE8F58DC972ED2EFCEA2F3571B3E09`
- MSI product code: `{8FB77D96-81CA-43F5-879A-8D7714454DFE}`
- Driver INF: `bspp70v.inf`

Installing the package requires acceptance of the [Brother software EULA](https://support.brother.com/g/s/agreement/English/agree.html).
