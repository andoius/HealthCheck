#write-host "    Loading" -background "BLACK" -foreground "YELLOW"

Function Pinghost  ([string] $Hostname )
{
$status=get-wmiobject win32_pingstatus -Filter "Address='$Hostname'" | Select-Object statuscode

if($status.statuscode -eq 0)
{
write-host $Hostname is REACHABLE -background "GREEN" -foreground "BLACk"
}
else
{
$global:errorvar="host not reachable" 
write-host $Hostname is NOT reachable -background "RED" -foreground "BLACk"
}
}
#write-host "    Completed" -background "BLACK" -foreground "GREEN"
