#Dynamic SQL

##getting row count from dynamic sql

```sql
DECLARE
  v_row_count number := 0;
  
  CURSOR c_tables
  IS
  SELECT table_name
    FROM user_tables;
    
BEGIN
  FOR tab_rec IN c_tables
  LOOP
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || tab_rec.table_name
    INTO v_row_count;
    
    DBMS_OUTPUT.put_line(tab_rec.table_name || ' has ' || v_row_count || ' rows.');
  END LOOP;
END;
/
  
```
#Split a line with in a single dbms_output.put_line

```sql
dbms_output.put_line('foo' || chr(10) || chr(13) || 'bar') -- if you want \n\r otherwise just use chr(10)
```

