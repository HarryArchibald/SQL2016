--Author: Harry Archibald
--Date: 26/05/2016
-- Restore db to primary
RESTORE DATABASE tanium
    FROM DISK = N'$(fileserver)\tanium.bak'
WITH RECOVERY,
    MOVE 'tanium' TO '$(UserDBDrive)\tanium.mdf', 
   MOVE 'tanium_Log' TO '$(LogDrive)\tanium.ldf'
GO
RESTORE DATABASE tanium_archive
    FROM DISK = N'$(fileserver)\tanium_archive.bak'
WITH RECOVERY,
    MOVE 'tanium_archive' TO '$(UserDBDrive)\tanium_archive.mdf', 
   MOVE 'tanium_archive_Log' TO '$(LogDrive)\tanium_archive.ldf'
GO

