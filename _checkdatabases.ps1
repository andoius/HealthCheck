function checkdatabases(
[string] $servername
)
{
Write-Host "Checking Databases"
$Path = $Location
${LocationCSV} = $Path  +"\CheckDatabases-DataSpace.csv"
${LocationXML} = $Path  +"\CheckDatabases-DataSpace.XML"

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$DataSet2 = New-Object System.Data.DataSet
$DataSet3 = New-Object System.Data.DataSet
$DataSet4 = New-Object System.Data.DataSet
$DataSet5 = New-Object System.Data.DataSet
$DataSet6 = New-Object System.Data.DataSet
$DataSet7 = New-Object System.Data.DataSet
$DataSet8 = New-Object System.Data.DataSet
$DataSet9 = New-Object System.Data.DataSet
$DataSet10 = New-Object System.Data.DataSet
$DataSet11 = New-Object System.Data.DataSet

$SqlConnection.ConnectionString = "Server=$servername;Database=master;Integrated Security=True"

$SqlCmd.CommandText = "select [name] from master.dbo.sysdatabases"
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet)#|out-null
$dbs =$DataSet.Tables[0]

#$dbs 

foreach ($db in $dbs)
{

#$db.name

$SqlCmd.CommandText = "["+$db.name+"]..sp_spaceused "
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet2) |out-null

}
#$DataSet2.Tables[0]| format-table -autosize
#$DataSet2.Tables[0]| export-csv "{$Location}\checkdatabases-Space.csv" 
$DataSet2.Tables[0]|export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet2.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")
#foreach ($db in $dbs)
#{

#$db.name

#$SqlCmd.CommandText = "
#select rtrim('["+$db.name+"]') as Dbname,
#DATABASEPROPERTY('"+$db.name+"','IsInRecovery') as Inrecovery,
#DATABASEPROPERTY('"+$db.name+"','IsInLoad')  as InLoad,
#DATABASEPROPERTY('"+$db.name+"','IsEmergencyMode')  as InEmergency,
#DATABASEPROPERTY('"+$db.name+"','IsOffline') as Isoffline,
#DATABASEPROPERTY('"+$db.name+"','IsReadOnly')  as IsReadonly,
#DATABASEPROPERTY('"+$db.name+"','IsSingleUser')  as IsSingleuser,
#DATABASEPROPERTY('"+$db.name+"','IsSuspect') as IsSuspect,
#DATABASEPROPERTY('"+$db.name+"','IsInStandBy') as IsStandby,
#DATABASEPROPERTY('"+$db.name+"','Version') as version,
#DATABASEPROPERTY('"+$db.name+"','IsTruncLog') as IsTrunclog
#"
#$SqlCmd.CommandText 

$SQL = ${ScriptLocation} + "Database_Properties-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet4) | out-null

#}

${LocationCSV} = $Path  +"\CheckDatabases-Properties.CSV"
${LocationXML} = $Path  +"\CheckDatabases-Properties.XML"



#$DataSet4.Tables[0]| format-table -autosize 
$DataSet4.Tables[0]| export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet4.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")



${LocationCSV} = $Path  +"\CheckDatabases-LogSpace.CSV"
${LocationXML} = $Path  +"\CheckDatabases-LogSpace.XML"
$SQL = ${ScriptLocation} + "Database_LogSpace-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet3)|out-null
#$DataSet3.Tables[0] | format-table -autosize
$DataSet3.Tables[0] | export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet3.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")


#Agent Job Details

${LocationCSV} = $Path  +"\CheckDatabases-AgentJobs.CSV"
${LocationXML} = $Path  +"\CheckDatabases-AgentJobs.XML"
$SQL = ${ScriptLocation} + "Database-AgentJobs-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet5)|out-null
#$DataSet5.Tables[0] | format-table -autosize
$DataSet5.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet5.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")



#Model Database Settings

${LocationCSV} = $Path  +"\CheckDatabases-Model.CSV"
${LocationXML} = $Path  +"\CheckDatabases-Model.XML"
$SQL = ${ScriptLocation} + "Database-Model-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet6)|out-null
#$DataSet6.Tables[0] | format-table -autosize
$DataSet6.Tables[0] | export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet6.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")


#Database Settings

${LocationCSV} = $Path  +"\CheckDatabases-Settings.CSV"
${LocationXML} = $Path  +"\CheckDatabases-Settings.XML"
$SQL = ${ScriptLocation} + "Database-Settings-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet7)|out-null
#$DataSet7.Tables[0] | format-table -autosize
$DataSet7.Tables[0] | export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet7.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")



#Database Files

${LocationCSV} = $Path  +"\CheckDatabases-Files.CSV"
${LocationXML} = $Path  +"\CheckDatabases-Files.XML"
$SQL = ${ScriptLocation} + "Database-Files-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet8)|out-null
#$DataSet8.Tables[0] | format-table -autosize
$DataSet8.Tables[0] | export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet8.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

#Database backup state

${LocationCSV} = $Path  +"\CheckDatabases-BackupStatus.CSV"
${LocationXML} = $Path  +"\CheckDatabases-BackupStatus.XML"
$SQL = ${ScriptLocation} + "Database-BackupStatus-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet9)|out-null
#$DataSet9.Tables[0] | format-table -autosize
$DataSet9.Tables[0] | export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet9.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")


#Temp DB Files

${LocationCSV} = $Path  +"\CheckDatabases-TempDBFiles.CSV"
${LocationXML} = $Path  +"\CheckDatabases-TempDBFiles.XML"
$SQL = ${ScriptLocation} + "Database-TempDBFiles-${SQLVersion}.SQL"
$SQL
#"DBCC SQLPERF(LOGSPACE) WITH NO_INFOMSGS "
$SqlCmd.CommandText =get-content ${SQL} 
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet10)|out-null
#$DataSet10.Tables[0] | format-table -autosize
$DataSet10.Tables[0] | export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet10.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")





$SqlConnection.Close()


}

