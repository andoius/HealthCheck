print''
print 'Adding additional files for tempDB'
Print '###################################'
print ''
set nocount on
declare @core int
create table #core
(
        id int,
        name varchar(128),
        IV int,
        CV varchar(128)
)
insert #core
        exec master..xp_msver
select @core = IV from #core
        where name like '%ProcessorCount%'
drop table #core
 

declare @int int
declare @cmd varchar(1000)
declare @datadir varchar(150)
select @datadir = left(filename, len(filename) - 4) from tempdb.sys.sysfiles where name = 'tempdev'
set @int = 1

if @Core > 8 
begin
set @Core=8
end

while @int < @core
begin
                set @cmd = '
                ALTER DATABASE tempdb
                ADD FILE (
                NAME = tempdev' + cast(@int as varchar(1)) + '  
    , FILENAME = ''' + @datadir + cast(@int as varchar(1)) + '.mdf''
    , SIZE = 1024MB
    , FILEGROWTH = 1024MB 
    , MAXSIZE = UNLIMITED)'
             

               -- exec (@cmd)     
                set @int = @int + 1          
end


print 'Tempdb''s configuration is complete'
go