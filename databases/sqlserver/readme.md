## _C_onversion

###convert integers

https://technet.microsoft.com/en-us/library/ms187928%28v=sql.105%29.aspx?f=255&MSPPError=-2147217396

popular 

```select convert(varchar(255), getdate(), int)```

where int is 

* 110 is US format (so will cause much lulz elsewhere)
* 112 is ISO sortable yyyymmdd
* 126 is ISO8601
* 127 is ISO8601 timezone


###from int date 20141009 to datetime

```select cast(cast(DateAsInt as varchar(10)) as date```

## _D_ata import/export

Caveat: Maybe a SS2008 R2 feature in Management Studio

### Export 
1. Right click on database you wish export
2. ```Tasks``` > ```Generate Scripts...```
3. Select objects you wish to export
4. In ```Set Scripting Options```, click the ```Advanced``` button
5. In ```General``` options, change ```Types of data to script``` from ```Schema Only``` to ```Data Only```


## Date arithemetic

### diff

```select datediff(d, '2014-10-01', getdate())```

where d is days, for more dateparts see: http://msdn.microsoft.com/en-us/library/ms189794.aspx

## _I_f else

```
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

### inserts

#### create a back up table

```select * into foo_backup from foo```

#### intos

```sql
insert into foo(fizz,buzz)
  select [fizz], '3123' [buzz]
  from bar
```

#### identities

```sql
set identity_insert database.schema.table on -- allows us to insert ids

insert into database.schema.table(col1,col2) -- important that you specify the columns, otherwise you'll get a cryptic identity error
select col1,col2 from database_backup.schema.table;

set identity_insert database.schema.table off -- return to normal
```

## _M_erge

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

todo: how can we use the OUTPUT clause to pump data into an audit trail w/o using triggers.


## _O_penquery oracle through a linked server

```select * FROM OPENQUERY(ORCL_LINKSVR, 'SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OBJECT_NAME=''FOO''')```

## _T_ransactions

```
BEGIN TRAN foo

UPDATE foo SET bar='OH NOES!'
GO

/* output 
(5000 rows(s) affected) <--- ZOMG ZOMG! NOOOO! *cries*faints*
*/

ROLLBACK TRAN foo -- and breath again
```
