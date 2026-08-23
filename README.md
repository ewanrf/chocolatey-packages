# PDF Architect Chocolatey package

Community package source for PDF Architect 10 by Avanquest pdfforge.

The public download is a small wrapper. It contains the direct URL for the signed PDF Architect 10 installer used by this package:

`https://cdnbz.pdfarchitect.org/unify/v10/installer/latest/PDF_Architect_10_Installer.exe`

## Build

Run from the package directory:

```powershell
choco pack .\pdf-architect.nuspec
```

## Test

Use a clean Windows test machine or VM:

```powershell
choco install pdf-architect --source . --accept-license -y
choco uninstall pdf-architect -y
```

The install is configured to avoid launching PDF Architect, changing the default PDF application, creating a desktop shortcut, enabling automatic updates, enabling notifications, or installing Messenger.

The uninstall script silently removes PDF Architect 10's registered OCR, OCR TESS, and View MSI modules. The View module is removed last. Once no modules remain, it removes PDForge's stale PDF Architect 10 Add/Remove Programs registry entry. This was validated on a clean Windows VM.

## Vendor payload

- Installer version: 10.0.24.1
- Download: `https://cdnbz.pdfarchitect.org/unify/v10/installer/latest/PDF_Architect_10_Installer.exe`
- SHA-256: `B1B99D2891BA0D9B3A288CB197E8EF3CFC1ED1EC0C3BF1E5F27BA195ED2BB1F6`
- Authenticode status when packaged: Valid
- Signer: Avanquest Software SAS
- Signer certificate thumbprint: `A3E9BB632402D81896A85C1E0699D201D116C137`

The vendor URL contains `latest`. Its checksum must be updated when PDForge replaces the installer.

Installing the package requires acceptance of the [PDF Architect EULA](https://www.pdfforge.org/pdfarchitect/eula).
