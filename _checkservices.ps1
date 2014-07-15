# Function to check windows services related to SQL Server
Function checkservices  ([string] $Hostname)
{

# $dir = split-path -parent $MyInvocation.MyCommand.Definition
# ${Location} = $dir + "\Output\[" +  $Hostname + "]"
${LocationCSV} = ${Location} +"\CheckALLServices.CSV"
${LocationXML} = ${Location} +"\CheckALLServices.XML"
${LocationHTML} = ${Location} +"\CheckALLServices.HTML"
#HTML BITS

$Header = "<style>"
$Header = $Header + "BODY{background-color:white;}"
$Header = $Header + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Header = $Header + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#E6CC80}"
$Header = $Header + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#F5EBCC}"
$Header = $Header + "</style>"

$Title ="Installed Services Report"
$Body = "<h1> $Title </h1>"




$Services = get-wmiobject -class win32_service -computername $hostname| where {$_.name -like '*'}|  select-object Name,state,status,Started,Startmode,Startname,Description

write-output $Services |export-csv -noTypeInformation -path ("${LocationCSV}")

# Write to CSV

Import-CSV ("${LocationCSV}")  | select @{Name="Server";Expression={$Hostname}}, "instance", "version",name,Startname,startmode,status| convertto-html -head $Header -Body $Body -Title $Title |out-file ${LocationHTML} 

Invoke-Expression ${LocationHTML}



# Remove hashed start line

$path = "${LocationCSV}" 
$lines = Get-Content -Path $path 
0 | ForEach-Object { $lines[$_] = $null } 
Set-Content -Path $path -Value $lines



$Title ="Installed SQL Server Services Report"
$Body = "<h1> $Title </h1>"

($Services | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

${LocationCSV} = ${Location} +"\CheckSQLServices.CSV"
${LocationXML} = ${Location} +"\CheckSQLServices.XML"
${LocationHTML} = ${Location} +"\CheckSQLServices.HTML"

$Services=get-wmiobject -class win32_service -computername $hostname| where {$_.name -like '*SQL*'}| select-object Name,state,status,Started,Startmode,Startname,Description

write-output $Services |export-csv -noTypeInformation -path ("${LocationCSV}")



#import-csv ("${LocationCSV}") | convertto-html |out-file ${LocationHTML} 

Import-CSV ("${LocationCSV}")  | select @{Name="Server";Expression={$Hostname}}, "instance", "version",name,Startname,startmode,status| convertto-html -head $Header -Body $Body -Title $Title |out-file ${LocationHTML} 

Invoke-Expression ${LocationHTML}




$path = "${LocationCSV}" 
$lines = Get-Content -Path $path 
0 | ForEach-Object { $lines[$_] = $null } 
Set-Content -Path $path -Value $lines

($Services | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")


<#
foreach ( $service in $Services)
{


if($service.state -ne "Running" -or  $service.status -ne "OK" -or $service.started -ne "True" )
{
$message="Host="+$Hostname+" " +$Service.Name +" " +$Service.state +" " +$Service.status +" " +$Service.Started +" " +$Service.Startname 
write-host $message -background "RED" -foreground "BLACk"

}
else
{
$message="Host="+$Hostname+" " +$Service.Name +" " +$Service.state +" " +$Service.status +" " +$Service.Started +" " +$Service.Startname 
write-host $message -background "GREEN" -foreground "BLACk"
}

}

#>
}
