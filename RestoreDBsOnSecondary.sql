--Author: Harry Archibald
--Date: 26/05/2016
-- Restore db to secondary
RESTORE DATABASE tanium
    FROM DISK = N'$(FILESERVER)\tanium.bak'
  WITH NORECOVERY, REPLACE,
    MOVE 'tanium' TO '$(UserDBDrive)\tanium.mdf', 
   MOVE 'tanium_Log' TO '$(UserLogDrive)\tanium.ldf'

GO
RESTORE DATABASE tanium_archive
    FROM DISK = N'$(FILESERVER)\tanium_archive.bak'
WITH NORECOVERY, REPLACE,
    MOVE 'tanium_archive' TO '$(UserDBDrive)\tanium_archive.mdf', 
   MOVE 'tanium_archive_Log' TO '$(UserLogDrive)\tanium_archive.ldf'
GO