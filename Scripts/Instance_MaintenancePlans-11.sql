select  name [Name], description [Description], suser_sname(ownersid) [Owner], createdate [CreateDate]from msdb.dbo.sysssispackages where packagetype =6

