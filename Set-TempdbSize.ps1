####################### 
<# 
.SYNOPSIS 
Genrates a script that will create multiple temdb data files 
.DESCRIPTION 
Genrates a script that will create multiple temdb data files.  The script can then be run manaully against a server using Management Studio or can be passed to another function like Invoke-SqlCmd or Invoke-SqlCmd2 
.INPUTS 
None 
    You cannot pipe objects to Set-TempDbSize 
.OUTPUTS 
   System.String 
.EXAMPLE 
Set-TempDbSize 
This example returns a script that can be used to create additional tempdb data files. 
 
    declare @data_path varchar(300); 
 
    select  
        @data_path = replace([filename], '.mdf','') 
    from  
        sysaltfiles s 
    where 
        name = 'tempdev'; 
 
    ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = 1024MB , MAXSIZE = 2048MB, FILEGROWTH = 512MB ); 
     
    declare @stmnt2 nvarchar(500) 
    select @stmnt2 = N'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''tempdev2'', FILENAME = ''' + @data_path + '2.mdf'' , SIZE = 1024MB , MAXSIZE = 2048MB, FILEGROWTH = 512MB )'; 
    exec sp_executesql @stmnt2; 
         
    declare @stmnt3 nvarchar(500) 
    select @stmnt3 = N'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''tempdev3'', FILENAME = ''' + @data_path + '3.mdf'' , SIZE = 1024MB , MAXSIZE = 2048MB, FILEGROWTH = 512MB )'; 
    exec sp_executesql @stmnt3; 
         
    declare @stmnt4 nvarchar(500) 
    select @stmnt4 = N'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''tempdev4'', FILENAME = ''' + @data_path + '4.mdf'' , SIZE = 1024MB , MAXSIZE = 2048MB, FILEGROWTH = 512MB )'; 
    exec sp_executesql @stmnt4; 
.NOTES 
Version History 
v1.0   - Michael Wells - Initial release 
#> 
function Set-TempDbSize 
{ 
    [CmdletBinding()] 
    param( 
    [Parameter(Position=0, Mandatory=$false)] [Int16]$maxFileCount = 16, 
    [Parameter(Position=1, Mandatory=$false)] [Int32]$maxFileInitialSizeMB = 1024, 
    [Parameter(Position=2, Mandatory=$false)] [Int32]$maxFileGrowthSizeMB = 2048, 
    [Parameter(Position=3, Mandatory=$false)] [Int32]$fileGrowthMB = 512, 
    [Parameter(Position=4, Mandatory=$false)] [float]$coreMultiplier = 1.0, 
    [Parameter(Position=5, Mandatory=$false)] [switch]$outClipboard 
    ) 
     
    #get a collection of physical processors 
    [array] $procs = Get-WmiObject Win32_Processor 
    $totalProcs = $procs.Count 
    $totalCores = 0 
 
    #count the total number of cores across all processors 
    foreach ($proc in $procs) 
    { 
        $totalCores = $totalCores + $proc.NumberOfCores 
    } 
 
    #get the amount of total memory (MB)  
    $wmi = Get-WmiObject Win32_OperatingSystem 
    $totalMemory = ($wmi.TotalVisibleMemorySize / 1024) 
 
    #calculate the number of files needed (= number of procs) 
    $fileCount = $totalCores * $coreMultiplier 
 
    if ($fileCount -gt $maxFileCount) 
    { 
        $fileCount = $maxFileCount 
    } 
 
    #calculate file size (total memory / number of files) 
    $fileSize = $totalMemory / $fileCount 
 
    if ($fileSize -gt $maxFileInitialSizeMB) 
    { 
        $fileSize = $maxFileInitialSizeMB 
    } 
 
    #build the sql command 
    $command = @" 
    declare @data_path varchar(300); 
 
    select  
        @data_path = replace([filename], '.mdf','') 
    from  
        sysaltfiles s 
    where 
        name = 'tempdev'; 
 
    ALTER DATABASE [tempdb] MODIFY FILE ( NAME = N'tempdev', SIZE = {0}MB , MAXSIZE = {1}MB, FILEGROWTH = {2}MB ); 
"@ -f $fileSize, $maxFileGrowthSizeMB, $fileGrowthMB 
 
    for ($i = 2; $i -le $fileCount; $i++) 
    { 
        $command =  $command + @" 
    declare @stmnt{3} nvarchar(500) 
    select @stmnt{3} = N'ALTER DATABASE [tempdb] ADD FILE ( NAME = N''tempdev{3}'', FILENAME = ''' + @data_path + '{3}.mdf'' , SIZE = {0}MB , MAXSIZE = {1}MB, FILEGROWTH = {2}MB )'; 
    exec sp_executesql @stmnt{3}; 
"@ -f $fileSize, $maxFileGrowthSizeMB, $fileGrowthMB, $i         
    } 
 
    if ($outClipboard) 
    { 
        $command | clip 
        return "The SQL query has been loaded into the clipboard." 
    } 
    else 
    { 
        return $command 
    } 
}

Set-TempDbSize -outClipboard