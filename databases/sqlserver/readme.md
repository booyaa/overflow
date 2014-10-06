
## conversion

###from int date 20141009 to datetime


```select cast(cast(DateAsInt as varchar(10)) as date```

## date arithemetic

### diff

```select datediff(d, '2014-10-01', getdate())```

where d is days, for more dateparts see: http://msdn.microsoft.com/en-us/library/ms189794.aspx


### inserts

#### create a back up table

```select * into foo_backup from foo```


#### intos
```insert into foo(fizz,buzz)
  select [fizz], '3123' [buzz]
  from bar
```



## openquery oracle through a linked server

```select * FROM OPENQUERY(ORCL_LINKSVR, 'SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OBJECT_NAME=''FOO''')```
