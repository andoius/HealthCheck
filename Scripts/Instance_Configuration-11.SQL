select name,description , value, minimum,maximum, value_in_use  from sys.configurations
order by name

--exec master.dbo.sp_configure