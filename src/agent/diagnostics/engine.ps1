Set-StrictMode -Version Latest

function Invoke-EHMTADiagnostics {
    param(
        [Parameter(Mandatory)]
        [object]$Inventory
    )

    $findings = @()

    foreach ($disk in @($Inventory.Storage)) {

        if ($null -ne $disk.UsedPercent -and $disk.UsedPercent -ge 90) {
            $findings += [pscustomobject]@{
                Severity = 'WARNING'
                Code     = 'STORAGE_PRESSURE'
                Target   = [string]$disk.Drive
                Message  = 'Storage usage is above 90 percent.'
                Evidence = "$($disk.UsedPercent)% used"
            }
        }
    }

    if ($null -ne $Inventory.Resources.MemoryPercent -and
        $Inventory.Resources.MemoryPercent -ge 90) {

        $findings += [pscustomobject]@{
            Severity = 'WARNING'
            Code     = 'MEMORY_PRESSURE'
            Target   = 'system'
            Message  = 'Memory utilization is above 90 percent.'
            Evidence = "$($Inventory.Resources.MemoryPercent)% memory utilization"
        }
    }

    if ($null -ne $Inventory.Resources.CPUPercent -and
        $Inventory.Resources.CPUPercent -ge 90) {

        $findings += [pscustomobject]@{
            Severity = 'WARNING'
            Code     = 'CPU_PRESSURE'
            Target   = 'system'
            Message  = 'CPU utilization is above 90 percent.'
            Evidence = "$($Inventory.Resources.CPUPercent)% CPU utilization"
        }
    }

    $publicFirewall = $null

    if ($null -ne $Inventory.Security -and
        $null -ne $Inventory.Security.Firewall) {

        $publicFirewall = $Inventory.Security.Firewall.Public
    }

    if ($publicFirewall -eq $false) {
        $findings += [pscustomobject]@{
            Severity = 'WARNING'
            Code     = 'FIREWALL_PUBLIC_DISABLED'
            Target   = 'Windows Firewall'
            Message  = 'Public firewall profile is disabled.'
            Evidence = 'Public profile Enabled=False'
        }
    }

    $critical = @(
        $findings | Where-Object { $_.Severity -eq 'CRITICAL' }
    ).Count

    $warning = @(
        $findings | Where-Object { $_.Severity -eq 'WARNING' }
    ).Count

    [pscustomobject]@{
        Status = if ($critical -gt 0) {
            'CRITICAL'
        }
        elseif ($warning -gt 0) {
            'WARNING'
        }
        else {
            'HEALTHY'
        }

        Findings = @($findings)

        Counts = [pscustomobject]@{
            Critical = $critical
            Warning  = $warning
            Total    = $findings.Count
        }
    }
}
