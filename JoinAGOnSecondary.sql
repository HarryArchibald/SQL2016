--Author: Harry Archibald
--Date: 26/05/2016
-- Join dbs to AG.
ALTER DATABASE tanium SET HADR AVAILABILITY GROUP = AG;
GO
ALTER DATABASE tanium_archive SET HADR AVAILABILITY GROUP = AG;
GO