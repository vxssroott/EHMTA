Set-StrictMode -Version Latest

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$runtime = Join-Path $PSScriptRoot '..\core\runtime.ps1'
. $runtime

$report = Invoke-EHMTAAgent

function Add-Row {
    param(
        [System.Windows.Controls.StackPanel]$Panel,
        [string]$Label,
        [string]$Value
    )

    $grid = New-Object System.Windows.Controls.Grid
    $grid.Margin = '0,2,0,2'

    $grid.ColumnDefinitions.Add(
        (New-Object System.Windows.Controls.ColumnDefinition)
    )
    $grid.ColumnDefinitions.Add(
        (New-Object System.Windows.Controls.ColumnDefinition)
    )

    $left = New-Object System.Windows.Controls.TextBlock
    $left.Text = $Label
    $left.FontWeight = 'SemiBold'

    $right = New-Object System.Windows.Controls.TextBlock
    $right.Text = $Value
    $right.HorizontalAlignment = 'Right'

    [System.Windows.Controls.Grid]::SetColumn($right, 1)

    $grid.Children.Add($left) | Out-Null
    $grid.Children.Add($right) | Out-Null
    $Panel.Children.Add($grid) | Out-Null
}

$window = New-Object System.Windows.Window
$window.Title = 'EHMTA — Endpoint Management Console'
$window.Width = 1180
$window.Height = 760
$window.MinWidth = 950
$window.MinHeight = 620
$window.WindowStartupLocation = 'CenterScreen'
$window.Background = '#101216'
$window.Foreground = '#E7EAF0'

$root = New-Object System.Windows.Controls.Grid
$root.Margin = '14'

$root.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='220'}))
$root.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition -Property @{Width='*'}))

$sidebar = New-Object System.Windows.Controls.StackPanel
$sidebar.Margin = '0,0,14,0'

$brand = New-Object System.Windows.Controls.TextBlock
$brand.Text = 'EHMTA'
$brand.FontSize = 26
$brand.FontWeight = 'Bold'
$brand.Margin = '4,4,4,2'
$sidebar.Children.Add($brand) | Out-Null

$subtitle = New-Object System.Windows.Controls.TextBlock
$subtitle.Text = 'Endpoint Management'
$subtitle.Opacity = .65
$subtitle.Margin = '5,0,5,25'
$sidebar.Children.Add($subtitle) | Out-Null

$navItems = @(
    'Overview',
    'Inventory',
    'Diagnostics',
    'Telemetry',
    'Artifacts',
    'Management',
    'Events'
)

foreach ($item in $navItems) {
    $button = New-Object System.Windows.Controls.Button
    $button.Content = $item
    $button.HorizontalContentAlignment = 'Left'
    $button.Margin = '0,2,0,2'
    $button.Padding = '12,9'
    $button.Background = '#181B21'
    $button.Foreground = '#DDE1E8'
    $button.BorderBrush = '#292D35'
    $sidebar.Children.Add($button) | Out-Null
}

$right = New-Object System.Windows.Controls.Grid

$rowHeader = New-Object System.Windows.Controls.RowDefinition
$rowHeader.Height = 'Auto'
[void]$right.RowDefinitions.Add($rowHeader)

$rowContent = New-Object System.Windows.Controls.RowDefinition
$rowContent.Height = '*'
[void]$right.RowDefinitions.Add($rowContent)

$header = New-Object System.Windows.Controls.Grid
$header.Margin = '0,0,0,12'

$title = New-Object System.Windows.Controls.TextBlock
$title.Text = "Endpoint Overview  /  $($report.host.Hostname)"
$title.FontSize = 22
$title.FontWeight = 'SemiBold'

$status = New-Object System.Windows.Controls.TextBlock
$status.Text = "● $($report.diagnostics.Status)"
$status.FontSize = 15
$status.HorizontalAlignment = 'Right'
$status.VerticalAlignment = 'Center'

$header.Children.Add($title) | Out-Null
$header.Children.Add($status) | Out-Null
[System.Windows.Controls.Grid]::SetColumn($status, 1)

$right.Children.Add($header) | Out-Null

$content = New-Object System.Windows.Controls.ScrollViewer
$content.VerticalScrollBarVisibility = 'Auto'

$stack = New-Object System.Windows.Controls.StackPanel

function Add-Section {
    param(
        [string]$Name
    )

    $border = New-Object System.Windows.Controls.Border
    $border.Background = '#15181E'
    $border.BorderBrush = '#292D35'
    $border.BorderThickness = '1'
    $border.Padding = '14'
    $border.Margin = '0,0,0,10'

    $panel = New-Object System.Windows.Controls.StackPanel

    $heading = New-Object System.Windows.Controls.TextBlock
    $heading.Text = $Name.ToUpper()
    $heading.FontSize = 12
    $heading.FontWeight = 'Bold'
    $heading.Opacity = .65
    $heading.Margin = '0,0,0,10'

    $panel.Children.Add($heading) | Out-Null
    $border.Child = $panel
    $stack.Children.Add($border) | Out-Null

    return $panel
}

$p = Add-Section 'Host'
Add-Row $p 'Hostname' $report.host.Hostname
Add-Row $p 'Operating System' $report.host.OS
Add-Row $p 'Build' $report.host.Build
Add-Row $p 'Architecture' $report.host.Architecture
Add-Row $p 'Uptime' "$([math]::Round($report.host.UptimeSeconds / 3600, 1)) hours"

$p = Add-Section 'Resources'
Add-Row $p 'CPU' "$($report.resources.CPUPercent)%"
Add-Row $p 'Memory' "$($report.resources.MemoryPercent)%"
Add-Row $p 'Processes' "$($report.resources.ProcessCount)"

$p = Add-Section 'Security'
$fw = $report.security.Firewall
Add-Row $p 'Firewall / Domain' "$($fw.Domain)"
Add-Row $p 'Firewall / Private' "$($fw.Private)"
Add-Row $p 'Firewall / Public' "$($fw.Public)"
Add-Row $p 'Secure Boot' "$($report.security.SecureBoot)"

$p = Add-Section 'Services'
Add-Row $p 'Total' "$($report.services.Total)"
Add-Row $p 'Running' "$($report.services.Running)"
Add-Row $p 'Stopped' "$($report.services.Stopped)"

$p = Add-Section 'Diagnostics'
Add-Row $p 'Status' "$($report.diagnostics.Status)"
Add-Row $p 'Findings' "$($report.diagnostics.Counts.Total)"
Add-Row $p 'Warnings' "$($report.diagnostics.Counts.Warning)"
Add-Row $p 'Critical' "$($report.diagnostics.Counts.Critical)"

$p = Add-Section 'Telemetry'
Add-Row $p 'Schema' "$($report.schema)"
Add-Row $p 'Agent' "$($report.agent.name) $($report.agent.version)"
Add-Row $p 'Cycle' "$($report.agent.cycle)"
Add-Row $p 'Lifecycle' "$($report.lifecycle.state)"
Add-Row $p 'Duration' "$($report.lifecycle.duration_ms) ms"

$content.Content = $stack
$right.Children.Add($content) | Out-Null
[System.Windows.Controls.Grid]::SetRow($content, 1)

$root.Children.Add($sidebar) | Out-Null
$root.Children.Add($right) | Out-Null
[System.Windows.Controls.Grid]::SetColumn($right, 1)

$window.Content = $root
$window.ShowDialog() | Out-Null


