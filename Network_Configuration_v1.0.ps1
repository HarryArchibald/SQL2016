#Subject: Configure Network and restart SQL Server instance
#Author: Harry Archibald
#Date: 27/04/2016
#v1.0 Initial release
param(
    [Parameter(Mandatory=$True)]
    [string]$HostName,
    [Parameter(Mandatory=$True)]
    [string]$InstanceName,
    [Parameter(Mandatory=$True)]
    [string]$Port
    )
.\ChangeNetworkProtocols.ps1 $InstanceName
.\ChangePort.ps1 $InstanceName $Port
.\Add_SQLServer.AliasMgmt_V1.0.ps1 $HostName $InstanceName $Port
.\RestartSQL.ps1 $InstanceName