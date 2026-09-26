$ErrorActionPreference='Stop'
$Root=Join-Path $env:LOCALAPPDATA 'EHMTA'
$Tmp=Join-Path $env:TEMP 'EHMTA-install'
$Zip=Join-Path $env:TEMP 'EHMTA.zip'
$Url='https://github.com/vxssroott/EHMTA/archive/refs/heads/main.zip'
if(Test-Path $Tmp){Remove-Item $Tmp -Recurse -Force}
Invoke-WebRequest $Url -OutFile $Zip -UseBasicParsing
Expand-Archive $Zip -DestinationPath $Tmp -Force
$Src=Get-ChildItem $Tmp -Directory | Select-Object -First 1
if(-not(Test-Path (Join-Path $Src.FullName 'src\agent\EHMTA-Agent.ps1'))){throw 'Invalid EHMTA package'}
if(Test-Path $Root){Remove-Item $Root -Recurse -Force}
New-Item $Root -ItemType Directory -Force | Out-Null
Copy-Item (Join-Path $Src.FullName '*') $Root -Recurse -Force
$Build=Join-Path $Root 'build'
New-Item $Build -ItemType Directory -Force | Out-Null
New-Item (Join-Path $Build 'logs') -ItemType Directory -Force | Out-Null
New-Item (Join-Path $Build 'reports') -ItemType Directory -Force | Out-Null
$Launcher=Join-Path $Build 'EHMTA-Desktop.ps1'
@"
`$ErrorActionPreference='Stop'
`$Root='$Root'
`$Entry=Join-Path `$Root 'src\agent\EHMTA-Agent.ps1'
& `$Entry -UI
"@ | Set-Content $Launcher -Encoding UTF8
$Desktop=[Environment]::GetFolderPath('Desktop')
$Shortcut=Join-Path $Desktop 'EHMTA Operator Console.lnk'
$Shell=New-Object -ComObject WScript.Shell
$Link=$Shell.CreateShortcut($Shortcut)
$Link.TargetPath=(Get-Command powershell.exe).Source
$Link.Arguments="-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$Launcher`""
$Link.WorkingDirectory=$Root
$Link.Description='EHMTA Operator Console'
$Link.Save()
Remove-Item $Zip -Force -ErrorAction SilentlyContinue
Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "EHMTA installed to $Root"
Write-Host "Desktop shortcut created: $Shortcut"
Start-Process powershell.exe -ArgumentList "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$Launcher`""
