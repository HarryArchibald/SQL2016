#Subject: Create AAG.
#Author: Harry Archibald
#Date: 27/04/2016
#v1.0 Initial release
param ([Parameter(Mandatory=$True)][string]$PrimaryInstance,
[Parameter(Mandatory=$True)][string]$SecondaryInstance,
[Parameter(Mandatory=$True)][string]$FileServer,
[Parameter(Mandatory=$True)][string]$UserDBDrive, 
[Parameter(Mandatory=$True)][string]$LogDrive,
[Parameter(Mandatory=$True)][string]$PrimaryFQDN,
[Parameter(Mandatory=$True)][string]$SecondaryFQDN,
[Parameter(Mandatory=$True)][string]$ListenerIP,
[Parameter(Mandatory=$True)][string]$ListenerSubnet,
[Parameter(Mandatory=$True)][string]$ListenerPort)
# Enable HA at instance level on Primary
Enable-SqlAlwaysOn -serverinstance $PrimaryInstance -force
# Enable HA at instance level on Secondary
Enable-SqlAlwaysOn -serverinstance $SecondaryInstance -force
#Create endpoint on Primary
Invoke-Sqlcmd -ServerInstance $PrimaryInstance -InputFile .\CreateEndpoint.sql
#Create endpoint on Secondary
Invoke-Sqlcmd -ServerInstance $SecondaryInstance -InputFile .\CreateEndpoint.sql
# Restore dbs om primary, set recovery to full
$MyArray = "FileServer=$FileServer", "UserDBDrive=$UserDBDrive", "LogDrive=$LogDrive"
Invoke-Sqlcmd -ServerInstance $PrimaryInstance -InputFile .\RestoreDBsOnPrimary.sql -Variable $MyArray
# Create AG on primary
$MyArray = "PrimaryInstance=$PrimaryInstance", "SecondaryInstance=$SecondaryInstance", "PrimaryFQDN=$PrimaryFQDN", "SecondaryFQDN=$SecondaryFQDN", "ListenerIP=$ListenerIP", "ListenerSubnet=$ListenerSubnet", "ListenerPort=$ListenerPort"
Invoke-Sqlcmd -ServerInstance $PrimaryInstance -InputFile .\CreateAG.sql -Variable $MyArray
# Join secondary to AG
Invoke-Sqlcmd -ServerInstance $SecondaryInstance -InputFile .\JoinAG.sql
# Restore dbs on secondary with norecovery
$MyArray = "FileServer=$FileServer", "UserDBDrive=$UserDBDrive", "LogDrive=$LogDrive"
Invoke-Sqlcmd -ServerInstance $SecondaryInstance -InputFile .\RestoreDBsOnSecondary.sql -Variable $MyArray
# Backup logs on primary
Invoke-Sqlcmd -ServerInstance $PrimaryInstance -InputFile .\BackupLogsOnPrimary.sql -Variable FileServer=$FileServer
# Restore log to secondary with norecovery
Invoke-Sqlcmd -ServerInstance $SecondaryInstance -InputFile .\RestoreLogsOnSecondary.sql -Variable FileServer=$FileServer
# Join dbs to AG on secondary
Invoke-Sqlcmd -ServerInstance $SecondaryInstance -InputFile .\JoinAGOnSecondary.sql
