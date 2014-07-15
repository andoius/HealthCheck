SELECT DB_name(DBID) [DATABASE],NAME,FILENAME, SIZE 
,(((CAST([size] as DECIMAL(18,4)) * 8192) /1024) /1024) as 'File Size (MB)'
,((((CAST([size] as DECIMAL(18,4)) * 8192) /1024) /1024) /1024) as 'File Size (GB)'FROM SYSaltfiles 

ORDER BY DBID ASC, GROUPID , FILEID

