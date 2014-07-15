# Name: cluster_ps.ps1
# Can only be run on Windows 2008 clusters or higher
#
# Get the date and set the variable
$Now = Get-Date
# Import the cmdlets
Import-Module failoverclusters

# Get the cluster vip and set to variable
$clustervip = Get-Cluster | foreach-object {$_.name}

# delete previous days check
del c:\logs\clustercheck.txt

Out-File "c:\logs\clustercheck.txt" -Encoding ASCII
Add-Content c:\logs\clustercheck.txt "Cluster Healthcheck for $clustervip" -Encoding ASCII
Add-Content c:\logs\clustercheck.txt "`n$Now" -Encoding ASCII
Add-Content c:\logs\clustercheck.txt "`n" -Encoding ASCII

# get the vip
$clustervip = Get-Cluster | foreach-object {$_.name}
Add-Content c:\logs\clustercheck.txt "`nCluster VIP" -Encoding ASCII
Add-Content c:\logs\clustercheck.txt "`n$clustervip" -Encoding ASCII
Add-Content c:\logs\clustercheck.txt "`n" -Encoding ASCII

# Get Quorum Owner
Add-Content c:\logs\clustercheck.txt "`nCluster Quorum" -Encoding ASCII
Get-ClusterQuorum | Format-Table -AutoSize -Wrap Cluster, QuorumResource, QuorumType | Out-File -append  -Encoding ASCII c:\logs\clustercheck.txt

# Get Cluster Node status
Add-Content c:\logs\clustercheck.txt "`nListing Cluster Nodes Status" -Encoding ASCII
Get-ClusterNode | Format-Table -AutoSize | Out-File -append  -Encoding ASCII c:\logs\clustercheck.txt

# Get Cluster Groups
Add-Content c:\logs\clustercheck.txt "`nListing Cluster Groups" -Encoding ASCII
Get-ClusterGroup | Format-Table -AutoSize | Out-File -append  -Encoding ASCII c:\logs\clustercheck.txt

# See which resources are in my group
Add-Content c:\logs\clustercheck.txt "`nListing Cluster Resources" -Encoding ASCII
Get-ClusterGroup | Get-ClusterResource | Format-Table -AutoSize -Wrap | Out-File -append  -Encoding ASCII c:\logs\clustercheck.txt

# Get resource dependency
Add-Content c:\logs\clustercheck.txt "`nListing Cluster Resource Dependencies" -Encoding ASCII
Get-ClusterGroup | Get-ClusterResource | Get-ClusterResourceDependency | Format-Table -AutoSize -Wrap | Out-File -append  -Encoding ASCII c:\logs\clustercheck.txt

# Change the -To, -From and -SmtpServer values to match your servers.
#Send-MailMessage -To me@myserver.com -From maint@myserver.com -subject "Cluster Health Report" -SmtpServer my.smtp.server -Attachments c:\clustercheck.txt