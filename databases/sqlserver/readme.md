# Conversion

## convert integers

[https://technet.microsoft.com/en-us/library/ms187928](https://technet.microsoft.com/en-us/library/ms187928)

popular 

`select convert(varchar(255), getdate(), int)`

where int is 

* 110 is US format (so will cause much lulz elsewhere)
* 112 is ISO sortable yyyymmdd
* 113 is Europe default + milliseconds (dd mon yyyy hh:mi:ss:mmm(24h)) - useful if using dg4 as something truncs datetime millisecond values.
* 126 is ISO8601
* 127 is ISO8601 timezone


## from int date 20141009 to datetime

`select cast(cast(DateAsInt as varchar(10)) as date`

## from string to datetime

`select convert(char(10), '20160229', 120)`


# Cursors

```sql
declare @field varchar(100);
declare @data_cur cursor;

set @data_cur = cursor FOR
	with data as (	
	select '1' as thing
	union
	select '2'
	union
	select '3'
	)
	select thing from data

open @data_cur;

fetch next from @data_cur into @field;

while @@FETCH_STATUS = 0
begin
	print 'row: ' + @field
	fetch next from @data_cur into @field;
end

close @data_cur
deallocate @data_cur
```

## Reference material

- http://sqlblog.com/blogs/adam_machanic/archive/2007/10/13/cursors-run-just-fine.aspx
- http://stackoverflow.com/questions/8728858/oracle-cursor-vs-sql-server-cursor#8729418
- http://stackoverflow.com/a/747376/105282

Remember

# Data import/export

Caveat: Maybe a SS2008 R2 feature in Management Studio

## Export 

1. Right click on database you wish export
2. `Tasks` > `Generate Scripts...`
3. Select objects you wish to export
4. In `Set Scripting Options`, click the `Advanced` button
5. In `General` options, change `Types of data to script` from `Schema Only` to `Data Only`

Tags : datageneration, data generation, datagen, data, export, data export

# Date arithemetic

## add/substract

`select dateadd(second, 10, '2015-01-01 00:00:00') -- adds 10 seconds to new years`

## leapyears

```sql
select dateadd(year, 3, '2016-02-29') -- gives you 2019-02-29 wrong!
select dateadd(day, 1095, '2016-02-29') -- gives you 2019-02-28 correct!
```

quick and date way is to extract `right('20160229', 4)` and check for '0229'

### reference

- [http://dwaincsql.com/2014/04/04/manipulating-dates-and-times-in-t-sql/](http://dwaincsql.com/2014/04/04/manipulating-dates-and-times-in-t-sql/)

## diff

`select datediff(d, '2014-10-01', getdate())`

where d is days, for more dateparts see: http://msdn.microsoft.com/en-us/library/ms189794.aspx

## date only part of getdate

equivalent of ```TRUNC(SYSDATE)```

### SQL Server 2008

`cast(getdate as Date)`

Gives you `2016-10-24`

### Backward compatibility

`dateadd(dd, datediff(dd,0, getDate()), 0)`

Gives you `2016-10-24 00:00:00.000`

# Execute	

```sql
create procedure foo
as
begin
	declare @temp as table(nextday datetime)
	declare @var datetime
	
	set @var = '2016-03-31'
	
	insert into @temp execute('SELECT TRUNC(?) FROM DUAL', @var) AT ORACLE_LINKED_SERVER_NAME
	select * from @temp
end
```

N.B. you need _rpc_ and _rpc_out_ enabled in your linked server settings

# If else

```sql
DECLARE @jobid INT

WITH crraaaazzzzy AS (
	SELECT 1 jobid
	UNION ALL
	SELECT 2 jobid
	UNION ALL
	SELECT 3 jobid
)

SELECT @jobid = MAX(@jobid)  
FROM crraaaazzzzy
IF @jobid IS NOT NULL 
BEGIN
	PRINT 'do something with max jobid: ' + CONVERT(VARCHAR(3),@jobid )
	PRINT 'idk like delete shit...'
END
ELSE
	PRINT 'no records to delete'
```

## inserts

### create a back up table

`select * into foo_backup from foo`

### intos

```sql
insert into foo(fizz,buzz)
  select [fizz], '3123' [buzz]
  from bar
```

### identities

```sql
set identity_insert database.schema.table on -- allows us to insert ids

insert into database.schema.table(col1,col2) -- important that you specify the columns, otherwise you'll get a cryptic identity error
select col1,col2 from database_backup.schema.table;

set identity_insert database.schema.table off -- return to normal
```
# Functions

indexof/instring is called charindex and usage is different from most indexing functions:

`select charindex('needle','needle in haystack')`

tags: strings , search , indexof , instr

# Merge

```sql
MERGE [dbo].[TargetTable] AS t
USING (SELECT column_list FROM [dbo].[SourceTable]) AS s -- this could have been table instead of a subselect
	ON  t.thisId = s.thatId
WHEN MATCHED THEN
	UPDATE -- existing records
		SET t.foo = s.bar
			,t.fizz = s.buzz -- don't stick t.thisId here unless you want people to point and laugh at you
WHEN NOT MATCHED THEN
	INSERT (t.column_list)
	VALUES(s.column_list) -- you can also transform source data here
;
```

source: http://msdn.microsoft.com/en-us/library/bb510625%28d=printer,v=sql.110%29.aspx

## how to use in an sproc

```sql
create table foo (
	needle nvarchar(5),
	token uniqueidentifier
)

go

insert into foo values ('bar', @NEWID)
go


create procedure usp_FooIns
	@needle nvarchar(5),
	@token uniqueidentifier
as
begin
	merge foo as target
		using (select @needle, @token) as source (needle, token)
		on target.needle = source.needle
		when matched then
			update -- note the absence of table name, it's implied
			set token=source.token
		when not matched then
			insert (needle, token) values (source.needle, source.token) -- same as update statement
end;			
go


select * from foo
exec usp_FooIns(@needle = 'bar', @token = NEWID()) -- will update the existing bar entry, with the new token
select * from foo
exec usp_FooIns(@needle = 'foo', @token = NEWID()) -- will create a new row
select * from foo
```

todo: how can we use the OUTPUT clause to pump data into an audit trail w/o using triggers

# Openquery oracle through a linked server

`select * FROM OPENQUERY(ORCL_LINKSVR, 'SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OBJECT_NAME=''FOO''')`

# Transactions

```sql
BEGIN TRAN foo

UPDATE foo SET bar='OH NOES!'
GO

/* output 
(5000 rows(s) affected) <--- ZOMG ZOMG! NOOOO! *cries*faints*
*/

ROLLBACK TRAN foo -- and breath again
```

using try and catch

```sql
BEGIN TRY
	BEGIN TRANSACTION
	--do something potentially harmful to db...
	COMMIT
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK
END CATCH
```
tag: transaction , rollback , tran

# Extract Username from system_user

```sql
select substring(SYSTEM_USER, charindex('\', system_user)+1, len(system_user))

/* 
system_user is DOMAIN\USER_NAME

expected output

USER_NAME
*/
```

# Sorting

## Date

```sql
--2008 (has DATE datatype)
SELECT MyDateColumn, count(*) 
FROM MyTable 
GROUP BY CAST(myDateTime AS DATE)

--older
SELECT MyDateColumn, count(*) 
FROM MyTable 
GROUP BY DATEADD(day, DATEDIFF(day, 0, MyDateTimeColumn), 0);
```	
	
# Version

|                   | RTM           | SP1          | SP2        | SP3        | SP4        | Latest                   |
| ----------------- | ------------- | ------------ | ---------- | ---------- | ---------- | ------------------------ |
| SQL Server 2016   | 13.00.1601.5  |              |            |            |            | 13.0.2149.0 CU1          |
| SQL Server 2014   | 12.00.2000.8  | 12.00.4100.1 | 12.00.5000 |            |            | 12.00.5511.0 (SP2 CU1)   |
| SQL Server 2012   | 11.00.2100.60 | 11.00.3000   | 11.00.5058 | 11.00.6020 |            | 11.00.6540.0 (SP3 CU4)   |
| SQL Server 2008R2 | 10.50.1600.1  | 10.50.2500   | 10.50.4000 | 10.50.6000 |            | 10.50.6542 (TLS 1.2 upd) |
| SQL Server 2008   | 10.00.1600.22 | 10.00.2531   | 10.00.4000 | 10.00.5500 | 10.00.6000 | 10.00.6547 (TLS 1.2 upd) |
| SQL Server 2005   | 9.00.1399.06  | 9.00.2047    | 9.00.3042  | 9.00.4035  | 9.00.5000  | 9.00.5324 (MS12-070)     |

https://buildnumbers.wordpress.com/sqlserver/

tags: version , build , number
