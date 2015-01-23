# inserting (hurr) output from dynamic sql

normally you'd expect to get away with using something like select blah into v_ariable_name, but with dynamic sql you need 
place the INTO in the EXECUTE IMMEDIATE statement.

```sql
SET SERVEROUTPUT ON
DECLARE
  v_sql VARCHAR2(8000);
  v_count NUMBER;
  CURSOR c_tables
      IS
  SELECT table_name
    FROM user_tables;
BEGIN
  FOR rec in c_tables
  LOOP
    v_sql := 'SELECT count(*) FROM ' || rec.table_name;
    EXECUTE IMMEDIATE v_sql INTO v_count;
    
    DBMS_OUTPUT.put_line(rec.table_name || ' has ' || v_count);
  END LOOP;
END;
/
```

# TODO: EXECUTE IMMEDIATE USING..
