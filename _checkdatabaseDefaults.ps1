function checkDefaults(
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


${LocationCSV} = ${Location} +"\Database-DefaultLocation.csv"
${LocationXML} = ${Location} +"\Database-DefaultLocation.XML"
${LocationHTML} = ${Location} +"\Database-DefaultLocation.HTML"



$Header = "<style>"
$Header = $Header + "BODY{background-color:white;}"
$Header = $Header + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$Header = $Header + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#E6CC80}"
$Header = $Header + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: white;background-color:#F5EBCC}"
$Header = $Header + "</style>"

$Title ="Database Defaults Report"
$Body = "<h1> $Title </h1>"






$SQL = ${ScriptLocation} + "Database-DefaultLocations-${SQLVersion}.SQL"
$SQL
$SqlCmd.CommandText = get-content ${SQL}
$SqlCmd.Connection = $SqlConnection
$SqlAdapter.SelectCommand = $SqlCmd
$SqlAdapter.Fill($DataSet) #| out-null
#$DataSet.Tables[0]
$DataSet.Tables[0] |export-csv -noTypeInformation -path ("${LocationCSV}")
($DataSet.Tables[0] | ConvertTo-XML -NoTypeInformation).Save("${LocationXML}")

$SqlConnection.Close()

Import-CSV ("${LocationCSV}")  | select * | convertto-html -head $Header -Body $Body -Title $Title |out-file ${LocationHTML} 
 

Invoke-Expression ${LocationHTML}

}
