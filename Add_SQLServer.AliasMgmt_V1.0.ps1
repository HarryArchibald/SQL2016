#Subject: Add SQL Native Client Configuration Alias
#Author: Harry Archibald
#Date: 18/05/2016
#V1.0 - Initial Release
param(
    [Parameter(Mandatory=$True)]
    [string]$ServerName,
    [Parameter(Mandatory=$True)]
    [string]$InstanceName,
    [Parameter(Mandatory=$True)]
    [string]$Port
    )
 
## Create the TCPAlias
$TCPAliasName=$ServerName+"\"+$InstanceName
$alias = ([wmiclass] '\\.\root\Microsoft\SqlServer\ComputerManagement12:SqlServerAlias').CreateInstance()
$alias.AliasName = $TCPAliasName
$alias.ConnectionString = $Port #connection specific parameters depending on the protocol
$alias.ProtocolName = 'tcp'
$alias.ServerName = $TCPAliasName
$alias.Put() | Out-Null;