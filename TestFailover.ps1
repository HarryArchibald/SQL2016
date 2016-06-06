#Subject: Failover AG
#Author: Harry Archibald
#Date: 02/06/2016
#v1.0 Initial release
param(
    [Parameter(Mandatory=$True)]
    [string]$AGName,
    [Parameter(Mandatory=$True)]
    [string]$InstanceName
    )
Import-Module SQLPS –DisableNameChecking

$path = "SQLServer:\SQL\$($instanceName)\DEFAULT\AvailabilityGroups\$($AGName)"

#failover
Switch-SqlAvailabilityGroup –Path $path