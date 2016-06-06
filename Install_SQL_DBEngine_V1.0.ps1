#Subject: Install SQL Server 2014 Enterprise Edition with SP1 (SQL Engine + Tools)
#Author: Harry Archibald
#Date: 09/05/2016
#V1.0 - Initial Release
param(
    [Parameter(Mandatory=$True)]
    [string]$InstallDrive,
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
    [string]$Filesize=1,
    [Parameter(Mandatory=$True)]
    [string]$Filecount=1,
    [Parameter(Mandatory=$True)]
    [string]$Logsize=1
    )

function SetAcl ($dir,$username)
{
  $Acl = Get-Acl $dir
  $Ar = New-Object  system.security.accesscontrol.filesystemaccessrule($username,"FullControl","ContainerInherit,ObjectInherit","None","Allow")
  $Acl.SetAccessRule($Ar)
  Set-Acl $dir $Acl 
}

#Create SQL Server folder structure and grant full control permissions to the SQL service account AD security group.
$LOGDIR= "$LogDrive\$InstanceName\"
$SQLTEMPBDIR="$TempDBDrive\$InstanceName\" 
$USERDBDIR="$UserDBDrive\$InstanceName\"
$BACKUPDIR="$BackupDrive\$InstanceName\"
$INSTANCE_DIR="$InstanceDir\Program Files\Microsoft SQL Server"
$INSTALLSHAREDDIR="$SQLBinDrive\Program Files\Microsoft SQL Server"
$INSTALLSHAREDWOWDIR="$SQLBinDrive\Program Files (x86)\Microsoft SQL Server"
$INSTALLSQLDATADIR="$UserDBDrive\$InstanceName\"

$AdminADGroup="$Domain\$SysAdminADGroup"
$SvcADGroup="$Domain\$SQLSvcADGroup"

New-Item -ErrorAction Ignore -Type Directory -Path $INSTANCE_DIR
New-Item -ErrorAction Ignore -Type Directory -Path $LOGDIR
New-Item -ErrorAction Ignore -Type Directory -Path $USERDBDIR
New-Item -ErrorAction Ignore -Type Directory -Path $INSTALLSQLDATADIR
New-Item -ErrorAction Ignore -Type Directory -Path $SQLTEMPBDIR
New-Item -ErrorAction Ignore -Type Directory -Path $BACKUPDIR

SetAcl $LOGDIR $AdminADGroup
SetAcl $USERDBDIR $AdminADGroup
SetAcl $INSTANCE_DIR $AdminADGroup
SetAcl $BACKUPDIR $AdminADGroup
SetAcl $SQLTEMPBDIR $AdminADGroup

SetAcl $LOGDIR $SvcADGroup
SetAcl $USERDBDIR $SvcADGroup
SetAcl $INSTANCE_DIR $SvcADGroup
SetAcl $BACKUPDIR $SvcADGroup
SetAcl $SQLTEMPBDIR $SvcADGroup

#Run SQL Server setup with specified options.
Set-Location -Path $InstallDrive
.\Setup.exe /ACTION=Install /IAcceptSQLServerLicenseTerms /QS /IndicateProgress=True /UpdateEnabled=False /UpdateSource=MU /Features=SQLENGINE,CONN,TOOLS /InstallSharedDir=$INSTALLSHAREDDIR /InstallSharedWowDir=$INSTALLSHAREDWOWDIR /InstanceName=$InstanceName /InstanceID=$InstanceName /InstanceDir=$INSTANCE_DIR /AGTSVCACCOUNT="$Domain\$AgentAccount" /AGTSVCPASSWORD="$AgentPassword" /AGTSVCSTARTUPTYPE=Automatic /BROWSERSVCSTARTUPTYPE=Disabled /SAPWD="$SAPassword" /SQLBACKUPDIR=$BACKUPDIR /SQLUSERDBDIR=$USERDBDIR /SQLUSERDBLOGDIR=$LOGDIR /InstallSQLDataDIR=$INSTALLSQLDATADIR /SQLTEMPDBDIR=$SQLTEMPBDIR /SQLTEMPDBLOGDIR=$SQLTEMPDBLOGDIR /SQLTEMPDBFILESIZE=$Filesize /SQLTEMPDBLOGFILESIZE=$Logsize /SQLTEMPDBFILECOUNT=$Filecount /SQLTEMPDBFILEGROWTH=0 /SQLTEMPDBLOGFILEGROWTH=0 /SQLSVCACCOUNT="$Domain\$SQLAccount" /SQLSVCPASSWORD="$SQLPassword" /SQLSVCSTARTUPTYPE=Automatic /SQLSYSADMINACCOUNTS="$Domain\$SysAdminADGroup" /TCPENABLED=1 /NPENABLED=0 /SQLCOLLATION="$Collation" 