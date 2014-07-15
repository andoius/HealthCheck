CREATE TABLE #tempInstanceNames
(
      InstanceName      NVARCHAR(100),
      RegPath           NVARCHAR(100),
      DefaultDataPath   NVARCHAR(MAX),
	  DefaultLogPath    NVARCHAR(MAX),
	  DefaultBackupPath NVARCHAR(MAX),
	  DefaultFTPath NVARCHAR(MAX)
)
 
INSERT INTO #tempInstanceNames (InstanceName, RegPath)
EXEC   master..xp_instance_regenumvalues
       @rootkey = N'HKEY_LOCAL_MACHINE',
       @key     = N'SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL'

DECLARE     @SQL VARCHAR(MAX)
SET         @SQL = 'DECLARE @returnValue NVARCHAR(100) ; set @returnValue ='''''
SELECT @SQL = @SQL + CHAR(13) +
'EXEC   master.dbo.xp_regread
@rootkey      = N''HKEY_LOCAL_MACHINE'',
@key          = N''SOFTWARE\Microsoft\Microsoft SQL Server\' + RegPath + '\Setup'',
@value_name   = N''SQLDataRoot'',
@value        = @returnValue OUTPUT;
 
UPDATE #tempInstanceNames SET DefaultDataPath = @returnValue
WHERE RegPath = ''' + RegPath + '''' + CHAR(13) FROM #tempInstanceNames
 
EXEC (@SQL)


 SET         @SQL = 'DECLARE @returnValue NVARCHAR(100) ; set @returnValue ='''''
 SELECT @SQL = @SQL + CHAR(13) +
'EXEC   master.dbo.xp_regread
@rootkey      = N''HKEY_LOCAL_MACHINE'',
@key          = N''SOFTWARE\Microsoft\Microsoft SQL Server\' + RegPath + '\MSSQLServer'',
@value_name   = N''DefaultLog'',
@value        = @returnValue OUTPUT;
 
UPDATE #tempInstanceNames SET DefaultLogPath = @returnValue
WHERE RegPath = ''' + RegPath + '''' + CHAR(13) FROM #tempInstanceNames
EXEC (@SQL) 

SET         @SQL = 'DECLARE @returnValue NVARCHAR(100) ; set @returnValue ='''''
SELECT @SQL = @SQL + CHAR(13) +
'EXEC   master.dbo.xp_regread
@rootkey      = N''HKEY_LOCAL_MACHINE'',
@key          = N''SOFTWARE\Microsoft\Microsoft SQL Server\' + RegPath + '\MSSQLServer'',
@value_name   = N''BackupDirectory'',
@value        = @returnValue OUTPUT;
 
UPDATE #tempInstanceNames SET DefaultBackupPath = @returnValue
WHERE RegPath = ''' + RegPath + '''' + CHAR(13) FROM #tempInstanceNames
EXEC (@SQL) 



SET         @SQL = 'DECLARE @returnValue NVARCHAR(100) ; set @returnValue ='''''
SELECT @SQL = @SQL + CHAR(13) +
'EXEC   master.dbo.xp_regread
@rootkey      = N''HKEY_LOCAL_MACHINE'',
@key          = N''SOFTWARE\Microsoft\Microsoft SQL Server\' + RegPath + '\MSSQLServer'',
@value_name   = N''FullTextDefaultPath'',
@value        = @returnValue OUTPUT;
 
UPDATE #tempInstanceNames SET DefaultFTPath = @returnValue
WHERE RegPath = ''' + RegPath + '''' + CHAR(13) FROM #tempInstanceNames
EXEC (@SQL) 


SELECT      InstanceName, RegPath, DefaultDataPath, DefaultLogPath , DefaultBackupPath , DefaultFTPath
FROM        #tempInstanceNames

