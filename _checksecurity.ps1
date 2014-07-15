function checksecurity(
[string] $servername
)
{


Write-Host "Connecting to ${servername}"


$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$DataSet = New-Object System.Data.DataSet
$DataSet1 = New-Object System.Data.DataSet
$SqlConnection.ConnectionString = "Server=$servername;Database=master;Integrated Security=True"


${LocationCSV} = ${Location} +"\CheckDatabaseSecurity.csv"
${LocationXML} = ${Location} +"\CheckDatabaseSecurity.XML"
$SQL = ${ScriptLocation} + "Database_Security-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet) #| out-null
#$DataSet.Tables[0]
$DataSet.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

$SqlConnection.Close()



}
