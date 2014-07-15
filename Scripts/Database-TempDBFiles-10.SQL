select name [NAME], Physical_name [FILENAME] ,size [SIZE]
from sys.master_files 
where database_id =db_id('TempDB')
and type_desc ='ROWS'
order by file_id