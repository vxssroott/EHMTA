param(
    [switch]$UI,
    [string]$OutputReport
)

$ErrorActionPreference = 'Stop'

$runtime = Join-Path $PSScriptRoot 'core\runtime.ps1'

if ($UI) {
    & (Join-Path $PSScriptRoot 'ui\console.ps1')
    exit $LASTEXITCODE
}

$report = & $runtime

if ($null -ne $OutputReport) {
    $report |
        ConvertTo-Json -Depth 20 |
        Set-Content -LiteralPath $OutputReport -Encoding UTF8
}

$report |
    ConvertTo-Json -Depth 20
