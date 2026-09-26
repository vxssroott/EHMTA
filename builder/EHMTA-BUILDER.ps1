param(
    [string]$Output = "$PSScriptRoot\..\dist\EHMTA-Agent.exe"
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path "$PSScriptRoot\..").Path
$dist = Split-Path $Output -Parent

New-Item -ItemType Directory -Path $dist -Force | Out-Null

$ps2exe = Get-Command Invoke-ps2exe -ErrorAction SilentlyContinue

if ($null -eq $ps2exe) {
    $ps2exe = Get-Command ps2exe -ErrorAction SilentlyContinue
}

if ($null -eq $ps2exe) {
    Write-Host ''
    Write-Host 'PS2EXE is not installed.' -ForegroundColor Yellow
    Write-Host ''
    Write-Host 'Install it once with:' -ForegroundColor Cyan
    Write-Host 'Install-Module ps2exe -Scope CurrentUser' -ForegroundColor White
    Write-Host ''
    exit 2
}

$entry = Join-Path $root 'src\agent\EHMTA-Agent.ps1'

Write-Host ''
Write-Host 'Building EHMTA-Agent.exe...' -ForegroundColor Cyan

& $ps2exe.Source `
    -InputFile $entry `
    -OutputFile $Output `
    -NoConsole `
    -Title 'EHMTA Endpoint Management Agent' `
    -Description 'Ephemeral Host Management & Telemetry Agent' `
    -Product 'EHMTA' `
    -Company 'EHMTA' `
    -Version '0.1.0.0'

if (-not (Test-Path $Output)) {
    throw 'Build failed: EHMTA-Agent.exe was not produced.'
}

Write-Host ''
Write-Host 'BUILD SUCCESSFUL' -ForegroundColor Green
Write-Host "Artifact: $Output" -ForegroundColor Green
Write-Host ''
