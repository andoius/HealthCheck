function checkinstance(
[string] $servername
)
{


Write-Host "Connecting to ${servername}"
Write-Host " "
Write-Host "Checking Instance"
Write-Host " "

$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$DataSet1 = New-Object System.Data.DataSet
$DataSet2 = New-Object System.Data.DataSet
$DataSet3 = New-Object System.Data.DataSet
$SqlConnection.ConnectionString = "Server=$servername;Database=master;Integrated Security=True"


${LocationCSV} = ${Location} +"\CheckInstance.csv"
${LocationXML} = ${Location} +"\CheckInstance.XML"
$SQL = ${ScriptLocation} + "Instance_Properties-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet) #| out-null
#$DataSet.Tables[0]
$DataSet.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

${LocationCSV} = ${Location} +"\CheckInstance-MaintenancePlans.csv"
${LocationXML} = ${Location} +"\CheckInstance-MaintenancePlans.XML"
$SQL = ${ScriptLocation} + "Instance_MaintenancePlans-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet1) #| out-null
#$DataSet.Tables[0]
$DataSet1.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet1.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

${LocationCSV} = ${Location} +"\Check-TEMPDB.csv"
${LocationXML} = ${Location} +"\Check-TEMPDB.XML"
$SQL = ${ScriptLocation} + "TempDB-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet2) #| out-null
$DataSet2.Tables[0]
$DataSet2.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet2.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")



${LocationCSV} = ${Location} +"\InstanceConfiguration.csv"
${LocationXML} = ${Location} +"\InstanceConfiguration.XML"
$SQL = ${ScriptLocation} + "Instance_Configuration-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet3) #| out-null
$DataSet3.Tables[0]
$DataSet3.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet3.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

$SqlConnection.Close()



}
