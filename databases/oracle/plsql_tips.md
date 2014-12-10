#Split a line with in a single dbms_output.put_line

```sql
dbms_output.put_line('foo' || chr(10) || chr(13) || 'bar') -- if you want \n\r otherwise just use chr(10)
```

