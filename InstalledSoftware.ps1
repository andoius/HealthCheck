﻿
$dir = split-path -parent $MyInvocation.MyCommand.Definition
$Location = $dir + "\Output\" 
# remove the output directory
Remove-Item -Path ${Location} -force -recurse


#Create the output Directory

new-item ${Location} -type directory -force
$Location
$Path = $Location
${LocationCSV} = $Path  +"\CheckInstalledSoftware.csv"
${LocationXML} = $Path  +"\CheckInstalledSoftware.XML"

if (!([Diagnostics.Process]::GetCurrentProcess().Path -match '\\syswow64\\'))
{
  $unistallPath = "\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\"
  $unistallWow6432Path = "\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\"
  @(
  if (Test-Path "HKLM:$unistallWow6432Path" ) { Get-ChildItem "HKLM:$unistallWow6432Path"}
  if (Test-Path "HKLM:$unistallPath" ) { Get-ChildItem "HKLM:$unistallPath" }
  if (Test-Path "HKCU:$unistallWow6432Path") { Get-ChildItem "HKCU:$unistallWow6432Path"}
  if (Test-Path "HKCU:$unistallPath" ) { Get-ChildItem "HKCU:$unistallPath" }
  ) |
  ForEach-Object { Get-ItemProperty $_.PSPath } |
  Where-Object {
    $_.DisplayName -and !$_.SystemComponent -and !$_.ReleaseType -and !$_.ParentKeyName -and ($_.UninstallString -or $_.NoRemove)
  } |
  Sort-Object DisplayName |
  Select-Object ${env:COMPUTERNAME}, DisplayName, DisplayVersion| export-csv -noTypeInformation -path ("${LocationCSV}")
}
else
{
  "You are running 32-bit Powershell on 64-bit system. Please run 64-bit Powershell instead." | Write-Host -ForegroundColor Red
}

