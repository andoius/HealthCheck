Function AdvancedOptions
(
[string] $servername
)
{
# Connect and run a command using SQL Native Client, Returns a recordset

# Create and open a database connection
$sqlConnection = new-object System.Data.SqlClient.SqlConnection "Server=$servername;Database=master;Integrated Security=True"
$sqlConnection.Open()
#Create a command object
$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "master.dbo.sp_configure 'show advanced options'"
#Execute the Command
$sqlReader = $sqlCommand.ExecuteReader()
#Parse the records
#return $sqlReader["Version"]
while ($sqlReader.Read()) { return $sqlReader["run_value"]}
# Close the database connection
$sqlConnection.Close()
}

Function AdvancedOptionsON
(
[string] $servername
)
{
# Connect and run a command using SQL Native Client, Returns a recordset

# Create and open a database connection
$sqlConnection = new-object System.Data.SqlClient.SqlConnection "Server=$servername;Database=master;Integrated Security=True"
$sqlConnection.Open()
#Create a command object
$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "master.dbo.sp_configure 'show advanced options',1"
#Execute the Command
$sqlReader = $sqlCommand.ExecuteReader()
#Parse the records
#return $sqlReader["Version"]
while ($sqlReader.Read()) { return $sqlReader["run_value"]}
# Close the database connection
$sqlConnection.Close()
}


Function Reconfigure
(
[string] $servername
)
{
# Connect and run a command using SQL Native Client, Returns a recordset

# Create and open a database connection
$sqlConnection = new-object System.Data.SqlClient.SqlConnection "Server=$servername;Database=master;Integrated Security=True"
$sqlConnection.Open()
#Create a command object
$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "Reconfigure"
#Execute the Command
$sqlReader = $sqlCommand.ExecuteNonQuery()
###Parse the records
###return $sqlReader["Version"]
##while ($sqlReader.Read()) { return $sqlReader["Version"]}
# Close the database connection
$sqlConnection.Close()
}

Function AdvancedOptionsOFF
(
[string] $servername
)
{
# Connect and run a command using SQL Native Client, Returns a recordset

# Create and open a database connection
$sqlConnection = new-object System.Data.SqlClient.SqlConnection "Server=$servername;Database=master;Integrated Security=True"
$sqlConnection.Open()
#Create a command object
$sqlCommand = $sqlConnection.CreateCommand()
$sqlCommand.CommandText = "master.dbo.sp_configure 'show advanced options',0"
#Execute the Command
$sqlReader = $sqlCommand.ExecuteReader()
#Parse the records
#return $sqlReader["Version"]
while ($sqlReader.Read()) { return $sqlReader["run_value"]}
# Close the database connection
$sqlConnection.Close()
}
