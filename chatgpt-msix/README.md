# ChatGPT MSIX Chocolatey package

Installs OpenAI's official ChatGPT Desktop MSIX for Windows x64.

The install script downloads the MSIX from `persistent.oaistatic.com`, checks its SHA-256 hash and Authenticode signature, and uses `Add-AppxPackage`. It does not require Microsoft Store or winget. Windows 10 version 2004 (build 19041) or later is required.

## Test

```powershell
choco pack .\chatgpt-msix\chatgpt-msix.nuspec --outputdirectory .\pack-check
choco install chatgpt-msix --source "$env:USERPROFILE\Desktop" --accept-license -y
choco uninstall chatgpt-msix -y
```
