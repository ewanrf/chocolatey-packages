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

The package downloads Anthropic's official signed x64 installer, validates its SHA-256 checksum, and installs it silently for the current user.

## Vendor payloads

- Package version: 1.34493.1.2
- Installer version: 1.34493.1
- x64 download: `https://downloads.claude.ai/releases/win32/x64/1.34493.1/Claude-255293a41a25d54c5177aa9614fb4cd620e70b78.exe`
- x64 SHA-256: `44BC7D2BF386D4CAD48F75434F6297343DCFC27294A0667D619E08F8C732EE91`
- Authenticode status when packaged: Valid
- Signer: Anthropic, PBC

The vendor URL is version-pinned. New releases require a new Chocolatey package version and checksum update.

Anthropic requires acceptance of its [Consumer Terms](https://www.anthropic.com/legal/consumer-terms).
