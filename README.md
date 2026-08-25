# Claude Desktop Chocolatey package

Community package source for Claude Desktop on Windows.

## Build

Run from the package directory:

```powershell
choco pack .\claude-desktop.nuspec
```

## Test

Use a clean Windows test machine or VM:

```powershell
choco install claude-desktop --source "$env:USERPROFILE\Desktop" --accept-license -y
choco uninstall claude-desktop -y
```

The package selects Anthropic's official signed x64 or ARM64 MSIX, validates its SHA-256 checksum, and installs it for the current user.

## Vendor payloads

- Package version: 1.34493.1.1
- Installer version: 1.34493.1
- x64 download: `https://claude.ai/api/desktop/win32/x64/msix/latest/redirect`
- x64 SHA-256: `AD5EAD595FEC1977C0CCB1D7FAB3BE040773B716451431DBD6BAB457BA31A55C`
- ARM64 download: `https://claude.ai/api/desktop/win32/arm64/msix/latest/redirect`
- ARM64 SHA-256: `3F5ECCED9682CF1BCA9226DCF4275C9747494B0DE7971812A9B1CCF57D7F9395`
- Authenticode status when packaged: Valid
- Signer: Anthropic, PBC

The vendor endpoints always redirect to the current release. New releases require a new Chocolatey package version and checksum update; until then, this package rejects a changed download.

Claude Desktop requires Windows 10 version 1903 or later. Anthropic requires acceptance of its [Consumer Terms](https://www.anthropic.com/legal/consumer-terms).
