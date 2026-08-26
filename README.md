# MySQL Shell Chocolatey package

Community package source for MySQL Shell on Windows.

## Build

Run from the package directory:

```powershell
choco pack .\mysql-shell.nuspec
```

## Test

Use a clean Windows test machine or VM:

```powershell
choco install mysql-shell --source "$env:USERPROFILE\Desktop;https://community.chocolatey.org/api/v2/" --accept-license -y
choco uninstall mysql-shell -y
```

The package installs the official signed x64 MSI embedded in the package. It declares `vcredist140` version 14.40.0 or newer as its only Chocolatey dependency.

## Vendor payload

- Package version: 26.7.1.2
- Installer version: 26.7.1
- x64 MSI: `mysql-shell-26.7.1-windows-x86-64bit.msi`
- SHA-256: `2AE7405A0A76FEA7FFC6D95E400C1BA7194EACA8F9556F53DA386579B826F754`
- Authenticode status when packaged: Valid
- Signer: Oracle America, Inc.
- License: MySQL Shell 26.7.1 Community license extracted from the MSI
- Icon: MySQL Shell executable icon extracted from the MSI
