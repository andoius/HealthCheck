#Source all the functions relate to CheckSQL
#trap [System.Exception]
#{
#    write-host "    Loading FAILED" -background "RED" -foreground "BLACK"
#    continue;
#}

Write-Host "***********************"
Write-Host "** Loading Functions **"
Write-Host "***********************"

Write-Host " Loading PingHost.ps1"
. ./_PingHost.ps1


Write-Host " Loading checkservices.ps1"
. ./_checkservices.ps1

Write-Host " Loading CheckInstalledSoftware.ps1"
. ./_CheckInstalledSoftware.ps1

Write-Host " Loading checkhardware.ps1"
. ./_checkhardware.ps1

Write-Host " Loading checkprocessor.ps1"
. ./_checkProcessor.ps1

Write-Host " Loading checkOS.ps1"
. ./_checkOS.ps1


Write-Host " Loading checkHD.ps1"
. ./_checkHD.ps1


Write-Host " Loading checknet.ps1"
. ./_checknet.ps1

Write-Host " Loading checkSQLVersion.ps1"
. ./_CheckSQLVersion.ps1



Write-Host " Loading checkconfiguration.ps1"
. ./_checkconfiguration.ps1


Write-Host " Loading checkinstance.ps1"
. ./_checkinstance.ps1

Write-Host " Loading CheckSQLFunctions.ps1"
. ./_CheckSQLFunctions.ps1

Write-Host " Loading checkdatabases.ps1"
. ./_checkdatabases.ps1


Write-Host " Loading check Database Defaults.ps1"
. ./_checkdatabaseDefaults.ps1

Write-Host " Loading checksecurity.ps1"
. ./_checksecurity.ps1

#Write-Host " Loading fnDumpObjecttoXML.ps1"
# . ./fnDumpObjecttoXML.ps1

Write-Host "**********************"
Write-Host "** Functions Loaded **"
Write-Host "**********************"
