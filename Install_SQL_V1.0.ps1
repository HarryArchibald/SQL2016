#Subject: Install SQL Server 2016 Enterprise Edition (SQL Engine + Tools) and configure network components
#Author: Harry Archibald
#Date: 03/jun/2016
#V1.0 - Initial Release
param(
    [Parameter(Mandatory=$True)]
    [string]$InstallDrive,
    [Parameter(Mandatory=$True)]
    [string]$HostName,
    [Parameter(Mandatory=$True)]
    [string]$InstanceName, 
    [Parameter(Mandatory=$True)]
    [string]$UserDBDrive, 
    [Parameter(Mandatory=$True)]
    [string]$LogDrive, 
    [Parameter(Mandatory=$True)]
    [string]$TempDBDrive,
    [Parameter(Mandatory=$True)]
    [string]$BackupDrive, 
    [Parameter(Mandatory=$True)]
    [string]$InstanceDir,
    [Parameter(Mandatory=$True)]
    [string]$SQLBinDrive, 
    [Parameter(Mandatory=$True)]
    [string]$AgentAccount, 
    [Parameter(Mandatory=$True)]
    [string]$AgentPassword, 
    [Parameter(Mandatory=$True)]
    [string]$SQLAccount, 
    [Parameter(Mandatory=$True)]
    [string]$SQLPassword, 
    [Parameter(Mandatory=$True)]
    [string]$SAPassword, 
    [Parameter(Mandatory=$True)]
    [string]$SysAdminADGroup, 
    [Parameter(Mandatory=$True)]
    [string]$SQLSvcADGroup, 
    [Parameter(Mandatory=$True)]
    [string]$Domain, 
    [Parameter(Mandatory=$True)]
    [string]$Collation, 
    [Parameter(Mandatory=$True)]
    [string]$Port,
    [Parameter(Mandatory=$True)]
    [string]$Filesize=1,
    [Parameter(Mandatory=$True)]
    [string]$Logsize=1,
    [Parameter(Mandatory=$True)]
    [string]$Filecount=1,
    [Parameter(Mandatory=$True)]
    [string]$MAXDOP=1,
    [Parameter(Mandatory=$True)]
    [string]$CostThreshold=5,
    [Parameter(Mandatory=$True)]
    [decimal]$SQLMaxMem
    )
$powershellArguments=".\Install_SQL_DBEngine_V1.0.ps1 $InstallDrive $InstanceName $UserDBDrive $LogDrive $TempDBDrive $BackupDrive $InstanceDir $SQLBinDrive $AgentAccount $AgentPassword $SQLAccount $SQLPassword $SAPassword $SysAdminADGroup  $SQLSvcADGroup  $Domain  $Collation $Filesize $Filecount $Logsize"
Start-Process powershell.exe -ArgumentList $powershellArguments -Wait -RedirectStandardOutput Install_SQL_DBEngine_V1.txt
.\Post_Install_Scripts\SQLConfiguration_V1.2.ps1 $HostName $InstanceName  $MAXDOP $MAXDOP $SQLMaxMem *> SQLConfiguration_V1.txt
.\Network_Configuration_v1.0.ps1 $HostName $InstanceName $Port *> Network_Configuration_v1.txt