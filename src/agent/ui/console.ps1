param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$AgentRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$RepoRoot  = (Resolve-Path (Join-Path $AgentRoot '..\..')).Path

$RuntimePath = Join-Path $AgentRoot 'core\runtime.ps1'
$ReportRoot  = Join-Path $RepoRoot 'build\reports'

if (-not (Test-Path $ReportRoot)) {
    New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
}

# ============================================================
# WINDOW
# ============================================================

$xaml = @"
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="EHMTA Operator Console"
    Width="1400"
    Height="880"
    MinWidth="1000"
    MinHeight="650"
    WindowStartupLocation="CenterScreen"
    Background="#101419"
    Foreground="#E7ECF2"
    WindowStyle="SingleBorderWindow"
    ResizeMode="CanResize"
    ShowInTaskbar="True">

    <Window.Resources>

        <Style TargetType="Button">
            <Setter Property="Margin" Value="3"/>
            <Setter Property="Padding" Value="12,7"/>
            <Setter Property="Background" Value="#20262D"/>
            <Setter Property="Foreground" Value="#E7ECF2"/>
            <Setter Property="BorderBrush" Value="#3A444F"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>

        <Style TargetType="TabItem">
            <Setter Property="Foreground" Value="#DCE4EC"/>
        </Style>

    </Window.Resources>

    <Grid>

        <Grid.RowDefinitions>
            <RowDefinition Height="52"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="30"/>
        </Grid.RowDefinitions>

        <!-- HEADER -->

        <Border Grid.Row="0"
                Background="#171C22"
                BorderBrush="#303842"
                BorderThickness="0,0,0,1">

            <Grid Margin="12,0">

                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>

                <StackPanel Orientation="Horizontal"
                            VerticalAlignment="Center">

                    <TextBlock
                        Text="EHMTA"
                        FontSize="20"
                        FontWeight="SemiBold"/>

                    <TextBlock
                        Text="  /  OPERATOR CONSOLE"
                        FontSize="11"
                        Foreground="#75818D"
                        VerticalAlignment="Center"/>

                </StackPanel>

                <TextBlock
                    Grid.Column="1"
                    x:Name="HeaderState"
                    Text="INITIALIZING"
                    Margin="18,0"
                    VerticalAlignment="Center"
                    Foreground="#8FA1B3"/>

                <Button
                    Grid.Column="2"
                    x:Name="RefreshButton"
                    Content="REFRESH"
                    Width="95"/>

                <Button
                    Grid.Column="3"
                    x:Name="ExportButton"
                    Content="EXPORT"
                    Width="95"/>

                <Button
                    Grid.Column="4"
                    x:Name="ExitButton"
                    Content="EXIT"
                    Width="75"/>

            </Grid>

        </Border>

        <!-- BODY -->

        <Grid Grid.Row="1">

            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="215"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!-- NAVIGATION -->

            <Border
                Grid.Column="0"
                Background="#151A20"
                BorderBrush="#303842"
                BorderThickness="0,0,1,0">

                <DockPanel>

                    <StackPanel DockPanel.Dock="Bottom"
                                Margin="10">

                        <Button
                            x:Name="OpenReportsButton"
                            Content="OPEN REPORTS"/>

                        <Button
                            x:Name="ExitButtonNav"
                            Content="CLOSE CONSOLE"/>

                        <TextBlock
                            Text="EHMTA v0.1.0"
                            Margin="8,12,8,2"
                            FontSize="11"
                            Foreground="#687583"/>

                    </StackPanel>

                    <ListBox
                        x:Name="Navigation"
                        Background="Transparent"
                        BorderThickness="0"
                        SelectedIndex="0">

                        <ListBoxItem Content="LANDING"/>
                        <ListBoxItem Content="OVERVIEW"/>
                        <ListBoxItem Content="INVENTORY"/>
                        <ListBoxItem Content="DIAGNOSTICS"/>
                        <ListBoxItem Content="TELEMETRY"/>
                        <ListBoxItem Content="SECURITY"/>
                        <ListBoxItem Content="SERVICES"/>
                        <ListBoxItem Content="USER MANUAL"/>
                        <ListBoxItem Content="ARCHITECTURE"/>
                        <ListBoxItem Content="LICENSE"/>
                        <ListBoxItem Content="RUNTIME"/>

                    </ListBox>

                </DockPanel>

            </Border>

            <!-- WORKSPACE -->

            <Grid Grid.Column="1"
                  Margin="14">

                <TabControl
                    x:Name="Workspace"
                    Background="#101419"
                    BorderBrush="#303842">

                    <!-- LANDING -->

                    <TabItem Header="LANDING">

                        <ScrollViewer>

                            <StackPanel Margin="28">

                                <TextBlock
                                    Text="EHMTA"
                                    FontSize="42"
                                    FontWeight="SemiBold"/>

                                <TextBlock
                                    Text="Ephemeral Host Management &amp; Telemetry Agent"
                                    FontSize="18"
                                    Foreground="#8A98A6"
                                    Margin="0,4,0,0"/>

                                <TextBlock
                                    Text="Endpoint observability • diagnostic intelligence • structured telemetry • controlled management"
                                    FontSize="13"
                                    Foreground="#65727F"
                                    Margin="0,8,0,26"/>

                                <Border
                                    Background="#171C22"
                                    BorderBrush="#303842"
                                    BorderThickness="1"
                                    Padding="22">

                                    <StackPanel>

                                        <TextBlock
                                            Text="CONTROL-PLANE INITIALIZATION"
                                            FontSize="11"
                                            Foreground="#71808E"/>

                                        <TextBlock
                                            Text="A lightweight endpoint runtime engineered around explicit lifecycle boundaries, evidence-preserving telemetry and operator-visible state."
                                            FontSize="17"
                                            TextWrapping="Wrap"
                                            Margin="0,8,0,18"/>

                                        <Button
                                            x:Name="LaunchButton"
                                            Content="INITIALIZE LIVE HOST SCAN"
                                            Width="230"
                                            HorizontalAlignment="Left"/>

                                    </StackPanel>

                                </Border>

                                <TextBlock
                                    Text="CAPABILITY MATRIX"
                                    FontSize="11"
                                    Foreground="#71808E"
                                    Margin="0,28,0,10"/>

                                <TextBlock
                                    Text="HOST IDENTITY    HARDWARE DISCOVERY    STORAGE DISCOVERY    NETWORK DISCOVERY&#x0a;RESOURCE TELEMETRY    SECURITY POSTURE    SERVICE HEALTH    DIAGNOSTIC ENGINE&#x0a;STRUCTURED TELEMETRY    EVIDENCE EXPORT    OPERATOR CONTROL PLANE"
                                    FontFamily="Consolas"
                                    FontSize="12"
                                    Foreground="#AAB5C0"/>

                            </StackPanel>

                        </ScrollViewer>

                    </TabItem>

                    <!-- OVERVIEW -->

                    <TabItem Header="OVERVIEW">

                        <Grid Margin="10">

                            <Grid.RowDefinitions>
                                <RowDefinition Height="90"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>

                            <Grid>

                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>

                                <Border Grid.Column="0"
                                        Background="#171C22"
                                        BorderBrush="#303842"
                                        BorderThickness="1"
                                        Padding="14"
                                        Margin="0,0,5,0">
                                    <StackPanel>
                                        <TextBlock Text="HOST"
                                                   FontSize="10"
                                                   Foreground="#778493"/>
                                        <TextBlock x:Name="HostValue"
                                                   Text="—"
                                                   FontSize="17"/>
                                    </StackPanel>
                                </Border>

                                <Border Grid.Column="1"
                                        Background="#171C22"
                                        BorderBrush="#303842"
                                        BorderThickness="1"
                                        Padding="14"
                                        Margin="5,0">
                                    <StackPanel>
                                        <TextBlock Text="CPU"
                                                   FontSize="10"
                                                   Foreground="#778493"/>
                                        <TextBlock x:Name="CpuValue"
                                                   Text="—"
                                                   FontSize="17"/>
                                    </StackPanel>
                                </Border>

                                <Border Grid.Column="2"
                                        Background="#171C22"
                                        BorderBrush="#303842"
                                        BorderThickness="1"
                                        Padding="14"
                                        Margin="5,0">
                                    <StackPanel>
                                        <TextBlock Text="MEMORY"
                                                   FontSize="10"
                                                   Foreground="#778493"/>
                                        <TextBlock x:Name="MemoryValue"
                                                   Text="—"
                                                   FontSize="17"/>
                                    </StackPanel>
                                </Border>

                                <Border Grid.Column="3"
                                        Background="#171C22"
                                        BorderBrush="#303842"
                                        BorderThickness="1"
                                        Padding="14"
                                        Margin="5,0,0,0">
                                    <StackPanel>
                                        <TextBlock Text="DIAGNOSTICS"
                                                   FontSize="10"
                                                   Foreground="#778493"/>
                                        <TextBlock x:Name="DiagnosticValue"
                                                   Text="—"
                                                   FontSize="17"/>
                                    </StackPanel>
                                </Border>

                            </Grid>

                            <Grid Grid.Row="1"
                                  Margin="0,12,0,0">

                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>

                                <GroupBox Header="HOST IDENTITY"
                                          Margin="0,0,6,0">

                                    <TextBox
                                        x:Name="HostDetails"
                                        IsReadOnly="True"
                                        TextWrapping="Wrap"
                                        VerticalScrollBarVisibility="Auto"
                                        Background="#0D1115"
                                        Foreground="#DDE4EC"
                                        BorderThickness="0"
                                        Padding="12"/>

                                </GroupBox>

                                <GroupBox Header="EXECUTION CONTEXT"
                                          Grid.Column="1"
                                          Margin="6,0,0,0">

                                    <TextBox
                                        x:Name="RuntimeDetails"
                                        IsReadOnly="True"
                                        TextWrapping="Wrap"
                                        VerticalScrollBarVisibility="Auto"
                                        Background="#0D1115"
                                        Foreground="#DDE4EC"
                                        BorderThickness="0"
                                        Padding="12"/>

                                </GroupBox>

                            </Grid>

                        </Grid>

                    </TabItem>

                    <!-- INVENTORY -->

                    <TabItem Header="INVENTORY">

                        <Grid Margin="10">

                            <Grid.ColumnDefinitions>
                                <ColumnDefinition Width="*"/>
                                <ColumnDefinition Width="*"/>
                            </Grid.ColumnDefinitions>

                            <GroupBox Header="HARDWARE"
                                      Margin="0,0,6,0">

                                <TextBox
                                    x:Name="HardwareDetails"
                                    IsReadOnly="True"
                                    TextWrapping="Wrap"
                                    VerticalScrollBarVisibility="Auto"
                                    Background="#0D1115"
                                    Foreground="#DDE4EC"
                                    BorderThickness="0"
                                    Padding="12"/>

                            </GroupBox>

                            <GroupBox Header="STORAGE / NETWORK"
                                      Grid.Column="1"
                                      Margin="6,0,0,0">

                                <TextBox
                                    x:Name="StorageDetails"
                                    IsReadOnly="True"
                                    TextWrapping="Wrap"
                                    VerticalScrollBarVisibility="Auto"
                                    Background="#0D1115"
                                    Foreground="#DDE4EC"
                                    BorderThickness="0"
                                    Padding="12"/>

                            </GroupBox>

                        </Grid>

                    </TabItem>

                    <!-- DIAGNOSTICS -->

                    <TabItem Header="DIAGNOSTICS">

                        <Grid Margin="10">

                            <Grid.RowDefinitions>
                                <RowDefinition Height="Auto"/>
                                <RowDefinition Height="*"/>
                            </Grid.RowDefinitions>

                            <StackPanel Orientation="Horizontal">

                                <TextBlock
                                    Text="DIAGNOSTIC ENGINE"
                                    FontWeight="SemiBold"
                                    VerticalAlignment="Center"/>

                                <Button
                                    x:Name="DiagnosticsButton"
                                    Content="RUN LIVE DIAGNOSTICS"
                                    Margin="18,0,0,0"/>

                            </StackPanel>

                            <DataGrid
                                Grid.Row="1"
                                x:Name="DiagnosticsGrid"
                                Margin="0,12,0,0"
                                AutoGenerateColumns="True"
                                IsReadOnly="True"
                                Background="#0D1115"
                                Foreground="#DDE4EC"/>

                        </Grid>

                    </TabItem>

                    <!-- TELEMETRY -->

                    <TabItem Header="TELEMETRY">

                        <Grid Margin="10">

                            <TextBox
                                x:Name="TelemetryDetails"
                                IsReadOnly="True"
                                TextWrapping="NoWrap"
                                HorizontalScrollBarVisibility="Auto"
                                VerticalScrollBarVisibility="Auto"
                                Background="#0D1115"
                                Foreground="#DDE4EC"
                                BorderThickness="0"
                                FontFamily="Consolas"
                                FontSize="12"
                                Padding="12"/>

                        </Grid>

                    </TabItem>

                    <!-- SECURITY -->

                    <TabItem Header="SECURITY">

                        <Grid Margin="10">

                            <TextBox
                                x:Name="SecurityDetails"
                                IsReadOnly="True"
                                TextWrapping="Wrap"
                                VerticalScrollBarVisibility="Auto"
                                Background="#0D1115"
                                Foreground="#DDE4EC"
                                BorderThickness="0"
                                Padding="12"/>

                        </Grid>

                    </TabItem>

                    <!-- SERVICES -->

                    <TabItem Header="SERVICES">

                        <Grid Margin="10">

                            <TextBox
                                x:Name="ServicesDetails"
                                IsReadOnly="True"
                                TextWrapping="Wrap"
                                VerticalScrollBarVisibility="Auto"
                                Background="#0D1115"
                                Foreground="#DDE4EC"
                                BorderThickness="0"
                                Padding="12"/>

                        </Grid>

                    </TabItem>

                    <!-- MANUAL -->

                    <TabItem Header="USER MANUAL">

                        <TextBox
                            x:Name="ManualText"
                            Margin="10"
                            IsReadOnly="True"
                            TextWrapping="Wrap"
                            VerticalScrollBarVisibility="Auto"
                            Background="#0D1115"
                            Foreground="#DDE4EC"
                            BorderThickness="0"
                            FontFamily="Consolas"
                            FontSize="12"
                            Padding="15"/>

                    </TabItem>

                    <!-- ARCHITECTURE -->

                    <TabItem Header="ARCHITECTURE">

                        <TextBox
                            x:Name="ArchitectureText"
                            Margin="10"
                            IsReadOnly="True"
                            TextWrapping="NoWrap"
                            HorizontalScrollBarVisibility="Auto"
                            VerticalScrollBarVisibility="Auto"
                            Background="#0D1115"
                            Foreground="#DDE4EC"
                            BorderThickness="0"
                            FontFamily="Consolas"
                            FontSize="12"
                            Padding="15"/>

                    </TabItem>

                    <!-- LICENSE -->

                    <TabItem Header="LICENSE">

                        <TextBox
                            x:Name="LicenseText"
                            Margin="10"
                            IsReadOnly="True"
                            TextWrapping="Wrap"
                            VerticalScrollBarVisibility="Auto"
                            Background="#0D1115"
                            Foreground="#DDE4EC"
                            BorderThickness="0"
                            Padding="15"/>

                    </TabItem>

                    <!-- RUNTIME -->

                    <TabItem Header="RUNTIME">

                        <TextBox
                            x:Name="RuntimeLog"
                            Margin="10"
                            IsReadOnly="True"
                            TextWrapping="Wrap"
                            VerticalScrollBarVisibility="Auto"
                            Background="#0D1115"
                            Foreground="#DDE4EC"
                            BorderThickness="0"
                            FontFamily="Consolas"
                            FontSize="12"
                            Padding="15"/>

                    </TabItem>

                </TabControl>

            </Grid>

        </Grid>

        <!-- STATUS -->

        <Border Grid.Row="2"
                Background="#0D1115"
                BorderBrush="#303842"
                BorderThickness="0,1,0,0">

            <Grid Margin="10,0">

                <TextBlock
                    x:Name="StatusText"
                    Text="INITIALIZING"
                    VerticalAlignment="Center"
                    FontSize="10"
                    Foreground="#7F8A96"/>

                <TextBlock
                    x:Name="TimestampText"
                    HorizontalAlignment="Right"
                    VerticalAlignment="Center"
                    FontSize="10"
                    Foreground="#5D6874"/>

            </Grid>

        </Border>

    </Grid>

</Window>
"@

try {

    $reader = New-Object System.Xml.XmlNodeReader ([xml]$xaml)
    $Window = [Windows.Markup.XamlReader]::Load($reader)

}
catch {

    throw "EHMTA UI construction failed: $($_.Exception.Message)"

}

# ============================================================
# CONTROLS
# ============================================================

$HeaderState       = $Window.FindName('HeaderState')
$RefreshButton     = $Window.FindName('RefreshButton')
$ExportButton      = $Window.FindName('ExportButton')
$ExitButton        = $Window.FindName('ExitButton')
$ExitButtonNav     = $Window.FindName('ExitButtonNav')
$OpenReportsButton = $Window.FindName('OpenReportsButton')
$LaunchButton      = $Window.FindName('LaunchButton')
$DiagnosticsButton = $Window.FindName('DiagnosticsButton')
$Navigation        = $Window.FindName('Navigation')
$Workspace         = $Window.FindName('Workspace')

$HostValue       = $Window.FindName('HostValue')
$CpuValue        = $Window.FindName('CpuValue')
$MemoryValue     = $Window.FindName('MemoryValue')
$DiagnosticValue = $Window.FindName('DiagnosticValue')

$HostDetails      = $Window.FindName('HostDetails')
$RuntimeDetails   = $Window.FindName('RuntimeDetails')
$HardwareDetails  = $Window.FindName('HardwareDetails')
$StorageDetails   = $Window.FindName('StorageDetails')
$DiagnosticsGrid  = $Window.FindName('DiagnosticsGrid')
$TelemetryDetails = $Window.FindName('TelemetryDetails')
$SecurityDetails  = $Window.FindName('SecurityDetails')
$ServicesDetails  = $Window.FindName('ServicesDetails')
$ManualText       = $Window.FindName('ManualText')
$ArchitectureText = $Window.FindName('ArchitectureText')
$LicenseText      = $Window.FindName('LicenseText')
$RuntimeLog       = $Window.FindName('RuntimeLog')
$StatusText       = $Window.FindName('StatusText')
$TimestampText    = $Window.FindName('TimestampText')

$script:CurrentReport = $null
$script:RuntimeLoaded = $false
$script:Busy = $false

# ============================================================
# HELPERS
# ============================================================

function Set-Status {
    param(
        [string]$Text,
        [string]$State = 'READY'
    )

    $StatusText.Text = $Text
    $HeaderState.Text = $State
    $TimestampText.Text = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
}

function Log {
    param([string]$Text)

    $RuntimeLog.AppendText(
        "[{0}] {1}`r`n" -f
        (Get-Date -Format 'HH:mm:ss'),
        $Text
    )

    $RuntimeLog.ScrollToEnd()
}

function Prop {
    param(
        [object]$Object,
        [string]$Name,
        [object]$Default = $null
    )

    if ($null -eq $Object) {
        return $Default
    }

    $p = $Object.PSObject.Properties[$Name]

    if ($null -eq $p) {
        return $Default
    }

    return $p.Value
}

function Show-Object {
    param([object]$Object)

    if ($null -eq $Object) {
        return 'NO DATA'
    }

    if ($Object -is [string]) {
        return $Object
    }

    try {
        return $Object | ConvertTo-Json -Depth 30
    }
    catch {
        return $Object | Out-String
    }
}

# ============================================================
# RUNTIME LOADER
# ============================================================

function Initialize-Runtime {

    Log "EHMTA runtime initialization started."
    Log "Agent root: $AgentRoot"
    Log "Runtime: $RuntimePath"

    if (-not (Test-Path $RuntimePath)) {
        Log "FATAL: runtime.ps1 does not exist."
        return $false
    }

    try {

        . $RuntimePath

        if (-not (Get-Command Invoke-EHMTAAgent -ErrorAction SilentlyContinue)) {
            throw "Invoke-EHMTAAgent was not registered."
        }

        $script:RuntimeLoaded = $true

        Log "Runtime initialization: PASS."
        Log "Execution engine: Invoke-EHMTAAgent"

        return $true

    }
    catch {

        Log "RUNTIME INITIALIZATION FAILED."
        Log "MESSAGE: $($_.Exception.Message)"
        Log "TYPE: $($_.Exception.GetType().FullName)"

        if ($_.ScriptStackTrace) {
            Log "STACK: $($_.ScriptStackTrace)"
        }

        return $false

    }
}

# ============================================================
# LIVE EXECUTION
# ============================================================

function Invoke-LiveCycle {

    if ($script:Busy) {
        return
    }

    $script:Busy = $true

    try {

        Set-Status 'EXECUTING LIVE HOST CYCLE...' 'SCANNING'

        $Window.Cursor =
            [System.Windows.Input.Cursors]::Wait

        Log '=================================================='
        Log 'LIVE EHMTA EXECUTION CYCLE'
        Log '=================================================='

        if (-not $script:RuntimeLoaded) {

            if (-not (Initialize-Runtime)) {
                throw 'Runtime initialization failed. See RUNTIME tab.'
            }

        }

        Log 'Calling backend execution engine...'

        $result = @(Invoke-EHMTAAgent)

        if ($result.Count -eq 0) {
            throw 'Backend returned no result.'
        }

        $report = $result |
            Where-Object {
                $_.PSObject.Properties['Agent'] -or
                $_.PSObject.Properties['TelemetrySchema']
            } |
            Select-Object -Last 1

        if ($null -eq $report) {
            throw 'Backend returned objects, but none matched the EHMTA telemetry envelope.'
        }

        $script:CurrentReport = $report

        Log 'Telemetry envelope received.'
        Log 'Synchronizing operator surfaces...'

        $hostInfo = Prop $report 'Host'
        $resources = Prop $report 'Resources'
        $diagnostics = Prop $report 'Diagnostics'
        $hardware = Prop $report 'Hardware'
        $storage = Prop $report 'Storage'
        $network = Prop $report 'Network'
        $security = Prop $report 'Security'
        $services = Prop $report 'Services'
        $lifecycle = Prop $report 'Lifecycle'

        $hostname = Prop $host 'Hostname' $env:COMPUTERNAME
        $cpu = Prop $resources 'CpuPercent' 0
        $memory = Prop $resources 'MemoryPercent' 0
        $diag = Prop $diagnostics 'Status' 'UNKNOWN'

        $HostValue.Text = [string]$hostname
        $CpuValue.Text = '{0:N1} %' -f [double]$cpu
        $MemoryValue.Text = '{0:N1} %' -f [double]$memory
        $DiagnosticValue.Text = [string]$diag

        $HostDetails.Text = Show-Object $host
        $HardwareDetails.Text = Show-Object $hardware

        $StorageDetails.Text =
            "STORAGE`r`n`r`n" +
            (Show-Object $storage) +
            "`r`n`r`nNETWORK`r`n`r`n" +
            (Show-Object $network)

        $SecurityDetails.Text = Show-Object $security
        $ServicesDetails.Text = Show-Object $services

        $RuntimeDetails.Text =
            Show-Object ([pscustomobject]@{
                Agent = Prop $report 'Agent'
                Cycle = Prop $report 'Cycle'
                Timestamp = Prop $report 'Timestamp'
                DurationMs = Prop $lifecycle 'DurationMs'
                ExitReady = Prop $lifecycle 'ExitReady'
            })

        $findings = Prop $diagnostics 'Findings'

        if ($null -ne $findings) {
            $DiagnosticsGrid.ItemsSource = @($findings)
        }
        else {
            $DiagnosticsGrid.ItemsSource = @()
        }

        $TelemetryDetails.Text =
            $report | ConvertTo-Json -Depth 30

        Log 'Operator surfaces synchronized.'
        Log 'LIVE CYCLE COMPLETE.'

        Set-Status 'LIVE TELEMETRY SYNCHRONIZED' 'ONLINE'

        $Workspace.SelectedIndex = 1

    }
    catch {

        Log "BACKEND FAILURE: $($_.Exception.Message)"
        Log "EXCEPTION TYPE: $($_.Exception.GetType().FullName)"

        if ($_.ScriptStackTrace) {
            Log "STACK TRACE:"
            Log $_.ScriptStackTrace
        }

        Set-Status 'BACKEND RUNTIME ERROR' 'ERROR'

        $Workspace.SelectedIndex = 10

        [System.Windows.MessageBox]::Show(
            $Window,
            "EHMTA backend execution failed.`r`n`r`n$($_.Exception.Message)`r`n`r`nSee the RUNTIME tab for the complete execution trace.",
            'EHMTA Runtime Error',
            'OK',
            'Error'
        ) | Out-Null

    }
    finally {

        $Window.Cursor =
            [System.Windows.Input.Cursors]::Arrow

        $script:Busy = $false

    }
}

# ============================================================
# DOCUMENTATION
# ============================================================

$ManualPath = Join-Path $RepoRoot 'docs\USER-MANUAL.md'
$ArchitecturePath = Join-Path $RepoRoot 'docs\ARCHITECTURE.md'
$LicensePath = Join-Path $RepoRoot 'LICENSE.txt'

if (Test-Path $ManualPath) {
    $ManualText.Text = Get-Content $ManualPath -Raw
}

if (Test-Path $ArchitecturePath) {
    $ArchitectureText.Text = Get-Content $ArchitecturePath -Raw
}

if (Test-Path $LicensePath) {
    $LicenseText.Text = Get-Content $LicensePath -Raw
}

# ============================================================
# BUTTONS
# ============================================================

$ExitHandler = {

    Set-Status 'CLOSING EHMTA OPERATOR CONSOLE...' 'EXITING'

    $Window.Close()

}

$ExitButton.Add_Click($ExitHandler)
$ExitButtonNav.Add_Click($ExitHandler)

$LaunchButton.Add_Click({

    $Workspace.SelectedIndex = 1
    Invoke-LiveCycle

})

$RefreshButton.Add_Click({

    Invoke-LiveCycle

})

$DiagnosticsButton.Add_Click({

    Invoke-LiveCycle

})

$ExportButton.Add_Click({

    try {

        if ($null -eq $script:CurrentReport) {
            Invoke-LiveCycle
        }

        if ($null -eq $script:CurrentReport) {
            return
        }

        $hostname =
            ($env:COMPUTERNAME -replace '[^a-zA-Z0-9._-]', '_')

        $timestamp =
            Get-Date -Format 'yyyyMMdd-HHmmss'

        $path =
            Join-Path $ReportRoot "EHMTA-$hostname-$timestamp.json"

        $script:CurrentReport |
            ConvertTo-Json -Depth 30 |
            Set-Content -LiteralPath $path -Encoding UTF8

        Log "REPORT EXPORTED: $path"

        Set-Status 'REPORT EXPORTED' 'EXPORT'

    }
    catch {

        Log "EXPORT FAILURE: $($_.Exception.Message)"

    }

})

$OpenReportsButton.Add_Click({

    if (-not (Test-Path $ReportRoot)) {
        New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
    }

    Start-Process explorer.exe $ReportRoot

})

$Navigation.Add_SelectionChanged({

    if ($Navigation.SelectedIndex -ge 0) {
        $Workspace.SelectedIndex = $Navigation.SelectedIndex
    }

})

# ============================================================
# WINDOW LIFECYCLE
# ============================================================

$Window.Add_Closing({

    param($sender,$eventArgs)

    Log 'Operator requested application shutdown.'

})

$Window.Add_ContentRendered({

    Log 'EHMTA OPERATOR CONSOLE ONLINE.'
    Log "Host: $env:COMPUTERNAME"
    Log "Repository: $RepoRoot"
    Log 'UI/backend boundary established.'

    if (Initialize-Runtime) {

        Set-Status 'READY — INITIALIZE LIVE HOST SCAN' 'READY'

        Log 'Runtime readiness: PASS.'
        Log 'No backend cycle has been executed yet.'

    }
    else {

        Set-Status 'RUNTIME INITIALIZATION FAILED' 'ERROR'

        $Workspace.SelectedIndex = 10

    }

})

# ============================================================
# RUN
# ============================================================

[void]$Window.ShowDialog()

