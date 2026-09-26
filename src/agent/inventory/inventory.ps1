Set-StrictMode -Version Latest

function Get-EHMTAHostIdentity {
    $cs = Get-CimInstance Win32_ComputerSystem
    $os = Get-CimInstance Win32_OperatingSystem

    [ordered]@{
        Hostname       = $env:COMPUTERNAME
        Username       = $env:USERNAME
        Manufacturer   = $cs.Manufacturer
        Model          = $cs.Model
        Domain         = $cs.Domain
        OS             = $os.Caption
        Version        = $os.Version
        Build          = $os.BuildNumber
        Architecture   = $os.OSArchitecture
        LastBoot       = $os.LastBootUpTime
        UptimeSeconds  = [math]::Round(((Get-Date) - $os.LastBootUpTime).TotalSeconds)
        Timezone       = (Get-TimeZone).Id
    }
}

function Get-EHMTAHardware {
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $memory = Get-CimInstance Win32_ComputerSystem
    $gpu = @(Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM, DriverVersion)

    [ordered]@{
        CPU = [ordered]@{
            Name          = $cpu.Name
            Cores         = $cpu.NumberOfCores
            LogicalCPU    = $cpu.NumberOfLogicalProcessors
            MaxClockMHz   = $cpu.MaxClockSpeed
        }
        Memory = [ordered]@{
            TotalGB = [math]::Round($memory.TotalPhysicalMemory / 1GB, 2)
        }
        GPU = $gpu
    }
}

function Get-EHMTADisks {
    @(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
        [ordered]@{
            Drive       = $_.DeviceID
            FileSystem  = $_.FileSystem
            SizeGB      = [math]::Round($_.Size / 1GB, 2)
            FreeGB      = [math]::Round($_.FreeSpace / 1GB, 2)
            UsedPercent = if ($_.Size) {
                [math]::Round((1 - ($_.FreeSpace / $_.Size)) * 100, 1)
            } else { 0 }
        }
    })
}

function Get-EHMTANetwork {
    @(Get-NetAdapter -ErrorAction SilentlyContinue |
        Where-Object Status -ne 'Disabled' |
        ForEach-Object {
            $ip = Get-NetIPAddress -InterfaceIndex $_.ifIndex -ErrorAction SilentlyContinue |
                Where-Object AddressFamily -in 'IPv4','IPv6' |
                Select-Object -ExpandProperty IPAddress

            [ordered]@{
                Name        = $_.Name
                Interface   = $_.InterfaceDescription
                Status      = $_.Status
                LinkSpeed   = $_.LinkSpeed
                MAC         = $_.MacAddress
                Addresses   = @($ip)
            }
        })
}

function Get-EHMTASecurity {
    $firewall = Get-NetFirewallProfile -ErrorAction SilentlyContinue

    [ordered]@{
        Firewall = if ($firewall) {
            [ordered]@{
                Domain  = @($firewall | Where-Object Name -eq 'Domain').Enabled
                Private = @($firewall | Where-Object Name -eq 'Private').Enabled
                Public  = @($firewall | Where-Object Name -eq 'Public').Enabled
            }
        } else { $null }

        SecureBoot = try {
            Confirm-SecureBootUEFI -ErrorAction Stop
        } catch {
            $null
        }
    }
}

function Get-EHMTAResources {
    $os = Get-CimInstance Win32_OperatingSystem
    $cpu = Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average

    $totalMemory = $os.TotalVisibleMemorySize
    $freeMemory = $os.FreePhysicalMemory

    [ordered]@{
        CPUPercent       = [math]::Round($cpu.Average, 1)
        MemoryPercent    = if ($totalMemory) {
            [math]::Round((1 - ($freeMemory / $totalMemory)) * 100, 1)
        } else { 0 }
        ProcessCount     = @(Get-Process).Count
        Timestamp        = (Get-Date).ToUniversalTime().ToString('o')
    }
}

function Get-EHMTAServices {
    $services = @(Get-Service)

    [ordered]@{
        Total   = $services.Count
        Running = @($services | Where-Object Status -eq 'Running').Count
        Stopped = @($services | Where-Object Status -eq 'Stopped').Count
        Failed  = 0
    }
}

function Get-EHMTAInventory {
    [ordered]@{
        Host        = Get-EHMTAHostIdentity
        Hardware    = Get-EHMTAHardware
        Storage     = Get-EHMTADisks
        Network     = Get-EHMTANetwork
        Security    = Get-EHMTASecurity
        Resources   = Get-EHMTAResources
        Services    = Get-EHMTAServices
    }
}
