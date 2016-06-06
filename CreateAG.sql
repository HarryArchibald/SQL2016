--Author: Harry Archibald
--Date: 26/05/2016
-- Create AG with endpoints.
CREATE AVAILABILITY GROUP AG 
FOR DATABASE tanium, tanium_archive
REPLICA ON 
      '$(PrimaryInstance)' WITH 
         (
         ENDPOINT_URL = 'TCP://$(PrimaryFQDN):7022',
         AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
         FAILOVER_MODE = AUTOMATIC
         ),
      '$(SecondaryInstance)' WITH 
         (
         ENDPOINT_URL = 'TCP://$(SecondaryFQDN):7022',
         AVAILABILITY_MODE = SYNCHRONOUS_COMMIT,
         FAILOVER_MODE = AUTOMATIC
         )
LISTENER ‘AgListener’ ( WITH IP ( ('$(Listenerip)'),('$(Listenersubnet)') ) , PORT = $(ListenerPort)); 
GO