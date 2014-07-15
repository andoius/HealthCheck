select
   db_name(mf.database_id)  as database_name,
   mf.type_desc,
   mf.name as logical_name,
   case
      when mf.max_size = -1 then 'unlimited'
      else cast((mf.max_size / 128) as varchar(32)) + 'mb'
   end as max_size,
   case
      when mf.is_percent_growth = 0 then cast((growth / 128) as varchar(32)) + 'mb'
      when mf.is_percent_growth = 1 then cast(growth as varchar(32)) + '%'
   end as growth,
   DATABASEPROPERTYEX(db_name(mf.database_id) , 'Recovery') 'Recovery',
   DATABASEPROPERTYEX(db_name(mf.database_id) , 'Status')  'Status',
   DATABASEPROPERTYEX(db_name(mf.database_id) , 'Collation')  'Collation'
from
   sys.master_files mf
      left join sys.dm_io_virtual_file_stats(null,null) vfs on vfs.database_id = mf.database_id
                                                           and vfs.file_id = mf.file_id

														   where db_name(mf.database_id) ='Model'
order by
   mf.database_id,
   mf.file_id
