# Altering column length

You'll still get an error when running the generated sql if you try to shrink a column.

```sql
SELECT 'ALTER TABLE ' || table_name || ' MODIFY ' || column_name || ' VARCHAR2(' || CASE column_name  WHEN 'FOO' THEN '10'  ELSE '20' END || ');' AS sql
  FROM user_tab_columns 
 WHERE column_name IN ( 'FOO','BAR')
   AND table_name IN (SELECT table_name FROM user_tables)   
   AND NOT regexp_like(table_name, '_(NEW|BAK)$') -- exclude backups
```

# Inserting (hurr) output from dynamic sql

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
tags: rowcount , row , count

# TODO: EXECUTE IMMEDIATE USING..
