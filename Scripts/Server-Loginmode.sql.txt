declare @val char (10)
EXECUTE master..xp_instance_regread 'HKEY_LOCAL_MACHINE','Software\Microsoft\MSSQLServer\MSSQLServer\','LoginMode','REG_DWORD', @val output
select @val 

CREATE TABLE #tempInstanceNames
(
      InstanceName      NVARCHAR(100),
      RegPath           NVARCHAR(100),
	  LoginMode			NVARCHAR(200)
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
@key          = N''SOFTWARE\Microsoft\Microsoft SQL Server\' + RegPath + '\MSSQLSERVER'',
@value_name   = N''LoginMode'',
@value        = @returnValue OUTPUT;
 
UPDATE #tempInstanceNames SET LoginMode = @returnValue
WHERE RegPath = ''' + RegPath + '''' + CHAR(13) FROM #tempInstanceNames
 
EXEC (@SQL)


SELECT      *
FROM        #tempInstanceNames


drop table #tempInstanceNames

