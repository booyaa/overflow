## conversion

###from int date 20141009 to datetime


```select cast(cast(DateAsInt as varchar(10)) as date```


## query oracle through a linked server

```select * FROM OPENQUERY(ORCL_LINKSVR, 'SELECT OWNER, OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OBJECT_NAME=''FOO''')```
