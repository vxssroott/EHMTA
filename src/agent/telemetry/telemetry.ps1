Set-StrictMode -Version Latest

function New-EHMTATelemetryEnvelope {
    param(
        [Parameter(Mandatory)]
        [object]$Inventory,

        [Parameter(Mandatory)]
        [object]$Diagnostics
    )

    $cycle = [guid]::NewGuid().ToString()

    [pscustomobject]@{
        schema = 'ehmta.telemetry.v1'

        agent = [pscustomobject]@{
            name    = 'EHMTA'
            version = '0.1.0'
            cycle   = $cycle
        }

        timestamp = (Get-Date).ToUniversalTime().ToString('o')

        host        = $Inventory.Host
        hardware    = $Inventory.Hardware
        resources   = $Inventory.Resources
        storage     = @($Inventory.Storage)
        network     = @($Inventory.Network)
        security    = $Inventory.Security
        services    = $Inventory.Services
        diagnostics = $Diagnostics

        lifecycle = [pscustomobject]@{
            mode         = 'one-shot'
            state        = 'completed'
            duration_ms  = 0
            exit         = 'pending'
        }
    }
}

function ConvertTo-EHMTATelemetryJson {
    param(
        [Parameter(Mandatory)]
        [object]$Envelope
    )

    $Envelope | ConvertTo-Json -Depth 20
}
