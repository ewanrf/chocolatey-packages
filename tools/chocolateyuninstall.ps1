$ErrorActionPreference = 'Stop'

Get-AppxPackage -Name 'MicrosoftCorporationII.Windows365' |
  Remove-AppxPackage