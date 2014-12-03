
## _C_onversion

###from int date 20141009 to datetime


```select cast(cast(DateAsInt as varchar(10)) as date```

## _D_ate arithemetic

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
