# Brother b-PAC3 Client Component Chocolatey package

Installs the Brother b-PAC3 Client Component only. It provides the runtime components required by applications that automate Brother label printing. It does not install the SDK, samples, printer drivers, or P-touch Editor.

## Architecture

b-PAC3 must match the architecture of the application that uses it. The package automatically installs both components on 64-bit Windows, allowing x86 and x64 applications to use b-PAC3. It installs only x86 on 32-bit Windows.

## Build

Run from the package directory:

```powershell
choco pack .\brother-bpac3-client-component.nuspec
```

## Vendor payloads

| Architecture | File | SHA-256 | MSI product code |
| --- | --- | --- | --- |
| x86 | `bcciw34015.msi` | `5D2493B91E8666EE08BB7B628DED38FFBE09CE0A1B3911CECAE6F800E9E4D796` | `{E3D06202-9680-491C-8EA9-732E04811C83}` |
| x64 | `bcciw34015_64.msi` | `C8E11B20E5EF5361853367236794A96AC120A8A632A6D19AEDFB42786BB1150D` | `{B3E26CFC-84B1-4C1A-BAA0-B8A6EF1F5EE3}` |

Both files are Brother-signed and were verified before packaging. Installing requires acceptance of the [Brother software EULA](https://support.brother.com/g/s/agreement/English/agree.html).
