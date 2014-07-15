#Objective: To check various status of SQL Server 
#Host, instances and databases.
#Author: MAK
#Date Written: June 5, 2008

param([string[]] $Server , [string[]] $Instance)


 if  (!$Server -or !$Instance ){ 
 Write-host ""
 Write-host ""
 Write-host "Usage:"
 Write-host ""
 Write-host  " CheckSQLServer <Computer[,Computer]> <Instance>"  
 Write-host  "   <Computer[,Computer]>   Single computer for standalone server"
 Write-host  "                           List of nodes for Clustered Server" 
 Write-host  "   <Instance>              Instance name of SQL Server Instance to be checked"
   return
}




$global:errorvar=0

#clear-host
. .\_CheckSQL_Lib.ps1 

$dir = split-path -parent $MyInvocation.MyCommand.Definition
$Location = $dir + "\Output\" 
# remove the output directory
Remove-Item -Path ${Location} -force -recurse


#Create the output Directory

new-item ${Location} -type directory -force

; if($Server){ 
"  "
" Servers "
" ------- "
$i = 0
foreach ($arg in $Server) { echo "Server $i : $arg"; $i++ 

$Hostname  = $arg

# Server specifc Items go here



$Location = $dir + "\Output\" +  $Hostname 
$ScriptLocation = $dir + "\Scripts\" 

new-item ${Location} -type directory -force
Write-host "Output to: $Location"
Write-host "........................"
Write-host " "
Write-host "Checking SQL Server....."
Write-host "........................"
Write-host " "
Write-host "Arguments accepted : $Hostname"
Write-host "........................"
Write-host "Pinging the host machine"
Write-host "........................"

pinghost $Hostname

if ($global:errorvar -ne "${Hostname} is NOT reachable")
{


Write-host "Checking windows services on the host related to SQL Server" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "..........................................................." -foregroundcolor  "White" -backgroundcolor "Gray"
if (Get-Command checkservices -errorAction SilentlyContinue)
{
checkservices $Hostname 
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}

Write-host "Checking Installed Software on the Server" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "..........................................................." -foregroundcolor  "White" -backgroundcolor "Gray"
if (Get-Command checkservices -errorAction SilentlyContinue)
{
CheckInstalledSoftware $Hostname 
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}


Write-host "Checking hardware Information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
if (Get-Command checkhardware -errorAction SilentlyContinue)
{
checkhardware $Hostname 
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}


Write-host "Checking processor Information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
if (Get-Command checkprocessor -errorAction SilentlyContinue)
{
checkprocessor $Hostname 
}
else
{
Write-host "Not Loaded" -foregroundcolor "BLACK" -backgroundcolor "RED"

}



Write-host "Checking OS Information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
if (Get-Command checkOS -errorAction SilentlyContinue)
{
checkOS $Hostname
}
else
{
Write-host "Not Loaded" -backgroundcolor "RED" -foregroundcolor "BLACK"

}




Write-host "Checking HDD Information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
if (Get-Command checkHD -errorAction SilentlyContinue)
{
checkHD $Hostname
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}




Write-host "Checking Network Adapter Information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
if (Get-Command checknet -errorAction SilentlyContinue)
{
checknet $Hostname
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}

}
} 
" "
" "

if($Instance){ 

" "
" Instances"
" ---------"
" "
$i = 0
foreach ($arg in $Instance) { echo "Instance $i : $arg"; $i++ 

$instancename  = $arg
$Location = $dir + "\Output\" +  $instancename 
new-item ${Location} -type directory -force
#Instance Specific Items go Here

Write-host "Checking SQL Server Version....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
Write-host " Checking ${instancename}"
if (Get-Command CheckSQLVersion -errorAction SilentlyContinue)
{
$SQLVersion = CheckSQLVersion $instancename
Write-host "SQL Server ${instancename} is version ${SQLVersion}" -foregroundcolor  "White" -backgroundcolor "Gray"
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}



Write-host "Checking Configuration information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
Write-host " Checking ${instancename}"
if (Get-Command checkconfiguration -errorAction SilentlyContinue)
{
checkconfiguration $instancename
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}




Write-host "Checking Instance property Information....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
Write-host " Checking ${instancename}"
if (Get-Command checkinstance -errorAction SilentlyContinue)
{
checkinstance $instancename  
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}




Write-host "Checking SQL Server databases........." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "Checking Database status and size....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
Write-host " Checking ${instancename}"
if (Get-Command checkdatabases -errorAction SilentlyContinue)
{
checkdatabases $instancename  
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}
#


Write-host "Checking Database Security....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
Write-host " Checking ${instancename}"
if (Get-Command checksecurity -errorAction SilentlyContinue)
{
checksecurity $instancename  
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}

Write-host "Checking Database Defaults....." -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "......................................" -foregroundcolor  "White" -backgroundcolor "Gray"
Write-host "" 
Write-host " Checking ${instancename}"
if (Get-Command checkDefaults -errorAction SilentlyContinue)
{
checkDefaults $instancename  
}
else
{
Write-host "Not Loaded" -background "RED" -foreground "BLACK"

}


}

 }
Write-host "Finished : Please review the text above for Errors" -background "Green" -foreground "Yellow"

}
