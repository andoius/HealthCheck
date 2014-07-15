select name [NAME],  [FILENAME] , [SIZE]
from sysaltfiles 
where dbid =db_id('TempDB')
and groupid=1
order by fileid
