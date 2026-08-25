# ChatGPT Desktop Chocolatey package

Installs OpenAI's official ChatGPT Desktop MSIX for Windows x64.

The install script downloads the MSIX from `persistent.oaistatic.com`, checks its SHA-256 hash and Authenticode signature, and uses `Add-AppxPackage`. It does not require Microsoft Store or winget.

## Test

```powershell
choco pack .\chatgpt-desktop\chatgpt-desktop.nuspec --outputdirectory .\pack-check
choco install chatgpt-desktop --source "$env:USERPROFILE\Desktop" --accept-license -y
choco uninstall chatgpt-desktop -y
```
