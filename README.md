# Microsoft 365 Copilot

This package downloads the Microsoft-signed M365 Copilot Desktop Installer, verifies its SHA-256 checksum and Authenticode signature, and runs it silently. The Microsoft bootstrapper retrieves and installs the `Microsoft.MicrosoftOfficeHub` MSIX for the current user.

The Chocolatey package version tracks the inspected bootstrapper. The installed Microsoft 365 Copilot app may update independently through Microsoft.

Chocolatey installs `vcredist140` as a package dependency. This is the Visual C++ redistributable, not the VCLibs AppX frameworks or Windows App Runtime required by the MSIX.

## Local test commands

```powershell
choco install m365-copilot --source "$env:USERPROFILE\Desktop;https://community.chocolatey.org/api/v2/" --accept-license -y
choco uninstall m365-copilot -y
```
