SELECT name AS 'Database_Name' , 
       DATABASEPROPERTYEX(name, 'Collation') as 'COLLATION', 
       DATABASEPROPERTYEX(name, 'Recovery') as 'Recovery Model', 
       DATABASEPROPERTYEX(name, 'Status') as 'Status',
       DATABASEPROPERTYEX(name, 'is_ansi_null_default_on') AS 'ANSI NULL Default' ,
       DATABASEPROPERTYEX(name, 'IsAutoClose') AS 'Auto CLOSE' ,
       DATABASEPROPERTYEX(name, 'IsAutoCreateStatistics') AS 'Auto Create Statistics' ,
       DATABASEPROPERTYEX(name, 'IsAutoShrink') AS 'Auto Shrink' ,
       DATABASEPROPERTYEX(name, 'IsAutoUpdateStatistics') AS 'Auto Update Statistics' ,
       DATABASEPROPERTYEX(name, 'UserAccess')  AS 'Restrict Access' ,
       DATABASEPROPERTYEX(name, 'IsPublished')  AS 'Published',
       DATABASEPROPERTYEX(name, 'IsSubscribed')  AS 'Subscribed'
FROM   master.dbo.sysdatabases 
ORDER BY 1

