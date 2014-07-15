#Function to check the HDD information on the host machine
Function checkHD([string] $Hostname )
{
${LocationCSV} = ${Location} +"\CheckDrives.CSV"
${LocationXML} = ${Location} +"\CheckDrives.XML"
#$drives=get-wmiobject -class Win32_LogicalDisk -computername $hostname -errorvariable errorvar
$drives=get-wmiobject -query "Select * from Win32_logicaldisk where DriveType =3"  -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$drives|export-csv -noTypeInformation -path ("${LocationCSV}")
($computer | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")
}

${LocationCSV} = ${Location} +"\CheckDriveInfo.CSV"
${LocationXML} = ${Location} +"\CheckDriveInfo.XML"
#$drives=get-wmiobject -class Win32_LogicalDisk -computername $hostname -errorvariable errorvar
$drives=get-wmiobject -class Win32_diskdrive -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$drives|export-csv -noTypeInformation -path ("${LocationCSV}")
($computer | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")
}

${LocationCSV} = ${Location} +"\CheckDiskPartition.CSV"
${LocationXML} = ${Location} +"\CheckDiskPartition.XML"
${LocationHTML} = ${Location} +"\CheckDiskPartition.HTML"

#HTML BITS

$Header = "<style>"
$Header = $Header + "BODY{background-color:white;}"
$Header = $Header + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Header = $Header + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#E6CC80}"
$Header = $Header + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#F5EBCC}"
$Header = $Header + "</style>"
$Title ="Disk Partition Report"
$Body = "<h1> $Title </h1>"




#$drives=get-wmiobject -class Win32_LogicalDisk -computername $hostname -errorvariable errorvar
$drives=get-wmiobject -class Win32_diskpartition -computername $hostname -errorvariable errorvar

if (-not $errorvar)
{
$drives|export-csv -noTypeInformation -path ("${LocationCSV}")
($computer | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")




#import-csv ("${LocationCSV}") | convertto-html |out-file ${LocationHTML} 

Import-CSV ("${LocationCSV}")  | select diskIndex,Caption, startingoffset ,"StripeSize", "PARTITION_OFFSET / STRIPE_UNIT_SIZE"| convertto-html -head $Header -Body $Body -Title $Title |out-file ${LocationHTML} 

Invoke-Expression ${LocationHTML}

}



${LocationCSV} = ${Location} +"\CheckDiskPartitionAlignment.CSV"
${LocationXML} = ${Location} +"\CheckDiskPartitionAlignment.XML"
${LocationHTML} = ${Location} +"\CheckDiskPartitionAlignment.HTML"
#$drives=get-wmiobject -class Win32_LogicalDisk -computername $hostname -errorvariable errorvar
$drives= Get-WmiObject  -Class Win32_DiskPartition -computername $hostname -errorvariable errorvar| Select-Object -Property DeviceId, Name, Description, BootPartition, PrimaryPartition, Index, Size, BlockSize, StartingOffset
if (-not $errorvar)
{
$drives|export-csv -noTypeInformation -path ("${LocationCSV}")
($computer | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")


$Title ="Disk Alignment Report"
$Body = "<h1> $Title </h1>"


#import-csv ("${LocationCSV}") | convertto-html |out-file ${LocationHTML} 
Import-CSV ("${LocationCSV}")  | select deviceid,name, startingoffset ,"StripeSize", "PARTITION_OFFSET / STRIPE_UNIT_SIZE"| convertto-html -head $Header -Body $Body -Title $Title |out-file ${LocationHTML} 

Invoke-Expression ${LocationHTML}


#$partitions = Get-WmiObject -ComputerName $sqlserver -Class Win32_DiskPartition;
#$partitions | Select-Object -Property DeviceId, Name, Description, BootPartition, PrimaryPartition, Index, Size, BlockSize, StartingOffset
<#
foreach ($drive in $drives) 
{

if ($drive.drivetype -eq "3" )
{ 
$message= "DeviceID="+$drive.Deviceid+" Size="+ $drive.size/1048576+"MB Free Space="+ $drive.freespace/1048576 +"MB Percentage Used=" + (($drive.Size/1048576)-($drive.freespace/1048576))/($drive.Size/1048576) *100+"% "
write-host $message -background "GREEN" -foreground "BLACk"
}

}
#>
}

}
