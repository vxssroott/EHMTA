Set-StrictMode -Version Latest

$inventoryModule   = Join-Path $PSScriptRoot '..\inventory\inventory.ps1'
$diagnosticModule  = Join-Path $PSScriptRoot '..\diagnostics\engine.ps1'
$telemetryModule   = Join-Path $PSScriptRoot '..\telemetry\telemetry.ps1'

. $inventoryModule
. $diagnosticModule
. $telemetryModule

function Invoke-EHMTAAgent {
    $start = Get-Date

    $inventory = Get-EHMTAInventory

    if ($null -eq $inventory) {
        throw 'Inventory collection returned no data.'
    }

    $diagnostics = Invoke-EHMTADiagnostics -Inventory $inventory

    if ($null -eq $diagnostics) {
        throw 'Diagnostic engine returned no result.'
    }

    $envelope = New-EHMTATelemetryEnvelope `
        -Inventory $inventory `
        -Diagnostics $diagnostics

    $envelope.lifecycle.duration_ms =
        [math]::Round(((Get-Date) - $start).TotalMilliseconds, 0)

    $envelope.lifecycle.exit = 'ready'

    return $envelope
}

Invoke-EHMTAAgent
