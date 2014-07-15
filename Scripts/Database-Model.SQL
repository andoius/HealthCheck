select
   db_name(mf.database_id)  as database_name,
   --mf.file_id,
   --mf.file_guid,
   --mf.type,
   mf.type_desc,
   --mf.data_space_id,
   mf.name as logical_name,
   --mf.physical_name,
   --mf.state,
   --mf.state_desc,
   --(mf.size / 128) as mf_size_mb,
   --(vfs.size_on_disk_bytes / 1024 / 1024) as vfs_size_mb,
   case
      when mf.max_size = -1 then 'unlimited'
      else cast((mf.max_size / 128) as varchar(32)) + 'mb'
   end as max_size,
   case
      when mf.is_percent_growth = 0 then cast((growth / 128) as varchar(32)) + 'mb'
      when mf.is_percent_growth = 1 then cast(growth as varchar(32)) + '%'
   end as growth,
   --mf.is_media_read_only,
   --mf.is_read_only,
   --mf.is_sparse
   --mf.is_percent_growth,
   --mf.is_name_reserved,
   --mf.create_lsn,
   --mf.drop_lsn,
   --mf.read_only_lsn,
   --mf.read_write_lsn,
   --mf.differential_base_lsn,
   --mf.differential_base_guid,
   --mf.differential_base_time,
   --mf.redo_start_lsn,
   --mf.redo_start_fork_guid,
   --mf.redo_target_lsn,
   --mf.redo_target_fork_guid,
   --mf.backup_lsn
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
