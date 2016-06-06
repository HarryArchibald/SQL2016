--Author: Harry Archibald
--Date: 26/05/2016
-- Restore log to secondary
RESTORE LOG tanium FROM DISK = '$(fileserver)\tanium.trn' WITH NORECOVERY
GO
RESTORE LOG tanium_archive FROM DISK = '$(fileserver)\tanium_archive.trn' WITH NORECOVERY
GO