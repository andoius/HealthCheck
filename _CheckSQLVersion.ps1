Function CheckSQLVersion
(
[string] $servername
)
{
# Connect and run a command using SQL Native Client, Returns a recordset

# Create and open a database connection
Write-host " Connecting to  ${servername}"
$sqlConnection = new-object System.Data.SqlClient.SqlConnection "Server=$servername;Database=master;Integrated Security=True"
$sqlConnection.Open()
#Create a command object
$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "select cast(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(20)), CHARINDEX('.', CAST(SERVERPROPERTY('ProductVersion') AS VARCHAR(20)), 1) - 1) as integer) as Version"
#Execute the Command
$sqlReader = $sqlCommand.ExecuteReader()
#Parse the records
#return $sqlReader["Version"]
while ($sqlReader.Read()) { return $sqlReader["Version"]}
# Close the database connection
$sqlConnection.Close()
}
