sp_msforeachDB ' Use ?; 

select ''?'' DB ,
 b.name as USERName, c.name as RoleName, coalesce (case b.isntgroup when 1 then ''WINDOWS_GROUP'' end,
case b.isntuser when 1 then ''WINDOWS_USER'' end,
case b.issqluser when 1 then ''SQL_USER'' end )as ACCOUNT_TYPE
from sysmembers a 
 join sysusers b 
on a.memberuid = b.uid join sysusers c
on a.groupuid = c.uid
where b.Name not in (''dbo'') '