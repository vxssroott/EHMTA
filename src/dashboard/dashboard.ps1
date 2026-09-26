$ErrorActionPreference = 'Stop'

$Agent = Join-Path $PSScriptRoot '..\agent\ui\console.ps1'
& $Agent
