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

The package downloads Anthropic's current official x64 or ARM64 MSIX, validates its Authenticode signature and exact publisher identity, and installs it for the current user. Windows 10 version 2004 (build 19041) or later is required. The signed manifest's Windows requirement is also checked.

## Vendor payloads

- Package version: 1.44121.4
- MSIX version inspected on 3 September 2026: 1.44121.4.0
- x64 download: `https://claude.ai/api/desktop/win32/x64/msix/latest/redirect`
- ARM64 download: `https://claude.ai/api/desktop/win32/arm64/msix/latest/redirect`
- Authenticode status when packaged: Valid
- Signer: Anthropic, PBC

These URLs track Anthropic's current release, so no fixed checksum is stored. Each download must have a valid Anthropic signature and match the expected Claude app identity and architecture. The downloaded app version is read from its signed manifest, not inferred from the Chocolatey package version. Installation is skipped when the same or a newer app is already installed. Run a Chocolatey upgrade with `--force` to recheck the vendor download if the Chocolatey package version has not changed.

The package uses Chocolatey's HTTPS download helper and respects its configured download policy. It does not change global checksum settings. If an administrator disables `allowEmptyChecksumsSecure`, that policy must permit this package's signature-based verification before it can download successfully.

Anthropic requires acceptance of its [Consumer Terms](https://www.anthropic.com/legal/consumer-terms).
