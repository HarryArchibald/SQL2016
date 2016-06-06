#Subject: Restart SQL Server instance
#Author: Harry Archibald, amended from https://gallery.technet.microsoft.com/scriptcenter/How-to-set-SQL-Server-690bfa04#content 
#Date: 27/04/2016
#v1.0 Initial release
param(
    [Parameter(Mandatory=$True)]
    [string]$InstanceName
    )

[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo") | Out-Null
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement") | Out-Null


 
##################################################################  
# Function to Enable or Disable a SQL Server Network Protocol 
################################################################## 
function ChangeSQLProtocolStatus($server,$instance,$protocol,$enable){ 
 
    $smo = 'Microsoft.SqlServer.Management.Smo.' 
     
    $wmi = new-object ($smo + 'Wmi.ManagedComputer') 
 
    $singleWmi = $wmi | where {$_.Name -eq $server}   

    $uri = "ManagedComputer[@Name='$server']/ServerInstance[@Name='$instance']/ServerProtocol[@Name='$protocol']" 

    $protocol = $singleWmi.GetSmoObject($uri) 
     
    $protocol.IsEnabled = $enable 
     
    $protocol.Alter() 
     
    $protocol 
} 
 
##################################################################  
# Enable TCP/IP SQL Server Network Protocol 
################################################################## 
ChangeSQLProtocolStatus -server $env:computername -instance $InstanceName -protocol "TCP" -enable $true | Out-Null
 
##################################################################  
# Enable Named Pipes SQL Server Network Protocol 
################################################################## 
ChangeSQLProtocolStatus -server $env:computername -instance $InstanceName -protocol "NP" -enable $false | Out-Null

##################################################################  
# Disable Shared Memory SQL Server Network Protocol 
################################################################## 
ChangeSQLProtocolStatus -server $env:computername -instance $InstanceName -protocol "SM" -enable $false | Out-Null
 
