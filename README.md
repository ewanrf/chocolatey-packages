# Windows App Chocolatey package

Community package source for Microsoft Windows App.

## Build

```powershell
choco pack
```

## Test locally

```powershell
choco install windows-app --source . --accept-license -y
choco uninstall windows-app -y
```

The package downloads Microsoft's signed 64-bit MSIX and validates its SHA-256 checksum before installation.
