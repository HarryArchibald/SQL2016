#Subject: Restart SQL Server instance
#Author: Harry Archibald
#Date: 27/04/2016
#v1.0 Initial release

param(
    [Parameter(Mandatory=$True)]
    [string]$InstanceName
    )
$ms = "MSSQL$"
$service = get-service "$ms$InstanceName"
restart-service $service.name -force #Restart SQL Services 
$ms = "SQLAgent$"
$service = get-service "$ms$InstanceName"
restart-service $service.name -force #Restart SQL Agent 