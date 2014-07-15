/*
List All SQL Server Agent Jobs formatted for Work Package
---------------------------------------------------------
V0.1	30 June 2011	Andrew Mitchell		First Release

*/

DECLARE @ProdVersion CHAR(12)
DECLARE @Version CHAR(2)
SET @ProdVersion = cast(serverproperty('ProductVersion')as char(12))
SET @Version= cast(left(@ProdVersion,charindex('.',@ProdVersion)-1)as char(2))

		SELECT @@Servername [Host Name],SJ.name as [SQL job name] , 
		(select name from msdb.dbo.syscategories where msdb.dbo.syscategories.category_id = sj.category_id) 'Category', 		
		(select name from master.dbo.sysLogins where Sid = sj.Owner_sid)  'Owner',SJ.Description [Description]
		, CASE freq_type
		WHEN 1 THEN 'Occurs on ' + STUFF(RIGHT(active_start_date, 4), 3,0, '/') + '/' + LEFT(active_start_date, 4) + ' at '
		+ REPLACE( RIGHT(CONVERT(varchar(30),
		CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime) /* hh:mm:ss 24H */
		, 9), 14), ':000', ' ') /* HH:mm:ss:000AM/PM then replace the :000 with space.*/
		WHEN 4 THEN 'Occurs every ' + CAST(freq_interval as varchar(10))
		+ ' day(s) '
		+ CASE freq_subday_type
		WHEN 1 THEN 'at '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		WHEN 2 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' second(s)'
		WHEN 4 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' minute(s)'
		WHEN 8 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' hour(s)'
		ELSE '' END
		+ CASE WHEN freq_subday_type in (2,4,8) /* repeat seconds/mins/hours */
		THEN ' between '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		+ ' and '
		+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_end_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		ELSE ''
		END
		WHEN 8 THEN
		'Occurs every ' + CAST(freq_recurrence_factor as varchar(10))
		+ ' week(s) on '
		+
		REPLACE( CASE WHEN freq_interval&1 = 1 THEN 'Sunday, ' ELSE '' END
		+ CASE WHEN freq_interval&2 = 2 THEN 'Monday, ' ELSE '' END
		+ CASE WHEN freq_interval&4 = 4 THEN 'Tuesday, ' ELSE '' END
		+ CASE WHEN freq_interval&8 = 8 THEN 'Wednesday, ' ELSE '' END
		+ CASE WHEN freq_interval&16 = 16 THEN 'Thursday, ' ELSE '' END
		+ CASE WHEN freq_interval&32 = 32 THEN 'Friday, ' ELSE '' END
		+ CASE WHEN freq_interval&64 = 64 THEN 'Saturday, ' ELSE '' END
		+ '|', ', |', ' ') /* get rid of trailing comma */

		+ CASE freq_subday_type
		WHEN 1 THEN 'at '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		WHEN 2 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' second(s)'
		WHEN 4 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' minute(s)'
		WHEN 8 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' hour(s)'
		ELSE '' END
		+ CASE WHEN freq_subday_type in (2,4,8) /* repeat seconds/mins/hours */
		THEN ' between '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		+ ' and '
		+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_end_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		ELSE ''
		END
		WHEN 16 THEN
		'Occurs every ' + CAST(freq_recurrence_factor as varchar(10))
		+ ' month(s) on '
		+ 'day ' + CAST(freq_interval as varchar(10)) + ' of that month ' 
		+ CASE freq_subday_type
		WHEN 1 THEN 'at '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		WHEN 2 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' second(s)'
		WHEN 4 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' minute(s)'
		WHEN 8 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' hour(s)'
		ELSE '' END
		+ CASE WHEN freq_subday_type in (2,4,8) /* repeat seconds/mins/hours */
		THEN ' between '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		+ ' and '
		+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_end_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		ELSE ''
		END
		WHEN 32 THEN
		'Occurs ' +
		CASE freq_relative_interval
		WHEN 1 THEN 'every first '
		WHEN 2 THEN 'every second '
		WHEN 4 THEN 'every third '
		WHEN 8 THEN 'every fourth '
		WHEN 16 THEN 'on the last '
		END
		+ CASE freq_interval WHEN 1 THEN 'Sunday'
		WHEN 2 THEN 'Monday'
		WHEN 3 THEN 'Tuesday'
		WHEN 4 THEN 'Wednesday'
		WHEN 5 THEN 'Thursday'
		WHEN 6 THEN 'Friday'
		WHEN 7 THEN 'Saturday'
		WHEN 8 THEN 'day'
		WHEN 9 THEN 'weekday'
		WHEN 10 THEN 'weekend'
		END

		+ ' of every ' + CAST(freq_recurrence_factor as varchar(10)) + ' month(s) '
		+ CASE freq_subday_type
		WHEN 1 THEN 'at '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		WHEN 2 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' second(s)'
		WHEN 4 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' minute(s)'
		WHEN 8 THEN 'every ' + CAST(freq_subday_interval as varchar(10)) + ' hour(s)'
		ELSE '' END
		+ CASE WHEN freq_subday_type in (2,4,8) /* repeat seconds/mins/hours */
		THEN ' between '+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_start_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		+ ' and '
		+ LTRIM(REPLACE( RIGHT(CONVERT(varchar(30), CAST(convert(varchar(8), STUFF(STUFF(RIGHT('000000' + CAST(active_end_time as varchar(10)), 6), 3, 0, ':' ), 6, 0, ':' ), 8) as datetime), 9), 14), ':000', ' '))
		ELSE ''
		END
		WHEN 64 THEN 'Runs when the SQL Server Agent service starts'
		WHEN 128 THEN 'Runs when the computer is idle'

		END as [Schedules]
		, 
		(select 

				cast(case notify_level_eventlog 
					when 0 then ''
					when 1 then 'Event Log - When a job succeeds'
					when 2 then 'Event Log - Whenever the job completes'
				end as char(100)) + char(10)  +
				cast(case notify_level_email 
					when 0 then ''
					when 1 then 'Email ' + (select name from msdb.dbo.sysoperators where id = sj.notify_email_operator_id) +  ' - When a job succeeds'
					when 2 then 'Email ' + (select name from msdb.dbo.sysoperators where id = sj.notify_email_operator_id) +  ' - Whenever the job completes'
				end as char(100)) + char(10) +
				cast(case notify_level_netsend 
					when 0 then ''
					when 1 then 'netsend ' + (select name from msdb.dbo.sysoperators where id = sj.notify_netsend_operator_id) +  ' - When a job succeeds'
					when 2 then 'netsend ' + (select name from msdb.dbo.sysoperators where id = sj.notify_netsend_operator_id) +  ' - Whenever the job completes'
				end as char(100)) + char(10) +
				cast(case notify_level_Page 
					when 0 then ''
					when 1 then 'Page ' + (select name from msdb.dbo.sysoperators where id = sj.notify_page_operator_id) +  ' - When a job succeeds'
					when 2 then 'Page ' + (select name from msdb.dbo.sysoperators where id = sj.notify_page_operator_id) +  ' - Whenever the job completes'
				end as char(100)) + char(10) 

				from msdb.dbo.sysjobs j where j.job_id = sj.job_id)
				 'Notifications'

		FROM msdb.dbo.sysjobs SJ
		INNER JOIN msdb.dbo.sysjobschedules SJS
		ON SJ.job_id = SJS.job_id
		--INNER JOIN msdb.dbo.sysschedules SS
		--ON SJS.schedule_id = SS.schedule_id

