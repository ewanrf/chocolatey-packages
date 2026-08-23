# Rovo Desktop Chocolatey package

Community package source for Atlassian Rovo Desktop.

## Build

Run from the package directory:

```powershell
choco pack .\rovo-desktop.nuspec
```

## Test

Use a clean Windows test machine or VM:

```powershell
choco install rovo-desktop --source . --accept-license -y
choco uninstall rovo-desktop -y
```

The package selects the official x64 or ARM64 MSI for the operating system, validates its SHA-256 checksum, and installs it silently for all users.

## Vendor payloads

- Installer version: 1.55.163.0
- x64 download: `https://update-nucleus.atlassian.com/Rovo/80c27f7ff6ac3c5d4c1763c75aa54d6b/win32/x64/Rovo-1.55.163-x64.msi`
- x64 SHA-256: `8AC9D8DC4F2E6A0C536EDD27695165312D09C0BE75A7DDB0556103ADC1455792`
- ARM64 download: `https://update-nucleus.atlassian.com/Rovo/80c27f7ff6ac3c5d4c1763c75aa54d6b/win32/arm64/Rovo-1.55.163-arm64.msi`
- ARM64 SHA-256: `75F6DD3EBFF03E8AD75E6F8077FB635EBB363C90764B2363F9EEC68E4D519BFE`
- Authenticode status when packaged: Valid
- Signer: Atlassian US, Inc.
- Signer certificate thumbprint: `9D0FDB25D523F94CA3EF4FEFDCDC10160970570B`

The vendor URLs are version-pinned. New Rovo releases require a new Chocolatey package version and new checksums.

Rovo Desktop is currently in beta. Using it requires an Atlassian account with access to Rovo. Installing the package requires acceptance of the [Atlassian Customer Agreement](https://www.atlassian.com/legal/atlassian-customer-agreement).
