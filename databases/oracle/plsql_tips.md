# Dynamic SQL

## _F_ormatting columns

```sqlplus
COLUMN foobar_something_blah FORMAT A25 HEADING 'foobar'
COLUMN foobar_price_usd FORMAT $99.99
```


## getting row count from dynamic sql

```plsql
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
# Split a line with in a single dbms_output.put_line

```plsql
dbms_output.put_line('foo' || chr(10) || chr(13) || 'bar') -- if you want \n\r otherwise just use chr(10)
```

# Types

## Arrays

```plsql
create or replace package foo 
as
  type schema_types is table of varchar2(30); -- pro securitai tip: these can be row or custom types, lock it down!
  type tablespace_types is table of varchar2(30); 
  procedure bar(p_schema_from in schema_types, p_schema_to in schema_types, p_tablespaces in tablespace_types); 
end foo;
/

create or replace package body foo 
as
  procedure bar(p_schema_from in schema_types, p_schema_to in schema_types, p_tablespaces in tablespace_types)
  as
  begin
    if (p_schema_from.count <> p_schema_to.count) AND (p_schema_to.count <> p_tablespaces.count) then
      raise_application_error(-20000, 'array item count mismatch!');
    end if;
    
    for i in p_schema_from.first .. p_schema_from.last
    loop
      dbms_output.put_line('index: ' || i || ' from: ' || rpad(p_schema_from(i), 8, ' ') || ' to: ' || rpad(p_schema_to(i), 8, ' ') || ' tablespaces: ' || p_tablespaces(i));
    end loop;
  end;
end foo;
/


set serveroutput on
declare  
  --initializifying
  blah FOO.schema_types := FOO.schema_types('ohai','somuch','wow', 'doge');  
  argh FOO.schema_types := FOO.schema_types('meh','veh','teh', 'rah');  
  meh FOO.tablespace_types := FOO.tablespace_types('ohai_data', 'somuch_data', 'wow_data', 'doge_data');
begin
  foo.bar(p_schema_from => blah, p_schema_to => blah, p_tablespaces => meh);
end;
/
```
