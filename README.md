# Brother QL-800 Chocolatey package

This package installs the Brother QL-800 Windows printer driver silently. It does not install P-touch Editor or the Printer Setting Tool.

## Build

Run from the package directory:

```powershell
choco pack .\brother-ql800-driver.nuspec
```

## Test

Use a Windows 10 or Windows 11 test machine or VM. Disconnect the printer's USB cable before installation, as Brother instructs.

```powershell
choco install brother-ql800-driver --source . --yes
Get-PrinterDriver -Name 'Brother QL-800' -ErrorAction SilentlyContinue
pnputil.exe /enum-drivers | Select-String -Pattern 'Brother|bsq16av.inf' -Context 2,4
```

Connect the printer after the package finishes, then print a test label. Static package checks cannot confirm USB detection or printing.

To test removal:

```powershell
choco uninstall brother-ql800-driver --yes
```

## Vendor payload

- Driver release: 1.10.1c, 21 March 2025
- Supported OS: Windows 10 and Windows 11, x86 and x64
- ARM64: not supported by Brother
- Download: `https://download.brother.com/welcome/dlfp101277/bsq16aw1101cus.exe`
- SHA-256: `836C155150696535947F598041BB1E97020D6F27BD21607BF2E2AC99B24A1713`
- MSI product code: `{FCFD8743-24E3-4C8E-B494-02F41BDD1906}`

Installing the package requires acceptance of the [Brother software EULA](https://support.brother.com/g/s/agreement/English/agree.html).
