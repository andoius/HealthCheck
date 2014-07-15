SELECT     db.name AS DatabaseName,
            SUM(8192.0E * af.size / 1048576.0E) AS Size,
SUSER_SNAME(db.sid) as Owner,
			  DATABASEPROPERTYEX(db.name , 'Recovery') 'RecoveryModel',
     DATABASEPROPERTYEX(db.name , 'Collation')  'Collation',
    DATABASEPROPERTYEX(db.name, 'Status')  'State'
FROM        master..sysdatabases AS db
INNER JOIN master..sysaltfiles AS af ON af.[dbid] = db.[dbid]

GROUP BY    db.name, db.sid 

order by DatabaseName
