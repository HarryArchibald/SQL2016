BACKUP LOG tanium
TO DISK = N'$(FILESERVER)\tanium.trn' 
    WITH FORMAT
GO
BACKUP LOG tanium_archive
TO DISK = N'$(FILESERVER)\tanium_archive.trn' 
    WITH FORMAT
GO