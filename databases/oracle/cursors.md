##Parameters

```
SET SERVEROUTPUT ON
DECLARE
  CURSOR c_objects(p_owner VARCHAR2, p_type VARCHAR2) 
  IS
  SELECT object_name
    FROM all_objects
   WHERE owner=p_owner AND object_type=p_type;
    
BEGIN   
  FOR v_rec IN c_objects('foo', 'TABLE')
  LOOP
    DBMS_OUTPUT.put_line(v_rec.object_name);
  END LOOP;
END;
/
```

##Returning a record set

n.b. if you need something more complicate like a composite record/type you'll need to create code in package.

```sql
-- requirements: you've got access to the data dictionary or gtfo

CREATE OR REPLACE PROCEDURE table_get(p_name IN VARCHAR2, p_tables OUT SYS_REFCURSOR)
AS
BEGIN
  OPEN p_tables FOR
    SELECT * FROM user_tables WHERE TABLE_NAME LIKE p_name;
END;
/

-- test harness
SET SERVEROUTPUT ON
DECLARE
  v_cursor SYS_REFCURSOR;
  v_tables user_tables%ROWTYPE;
  v_filter VARCHAR2(30) := 'FOO%';
BEGIN
  table_get(p_name => v_filter, p_tables => v_cursor);
  
  DBMS_OUTPUT.put_line('Tables that match: ' || v_filter);
  
  LOOP
    FETCH v_cursor INTO v_tables;

    EXIT WHEN v_cursor%NOTFOUND;
    
    DBMS_OUTPUT.put_line(v_tables.table_name);
  END LOOP;
END;
/

DROP PROCEDURE table_get;
/

```

##Quick and dirty PL/SQL to query a refcursor (probably a pipelined func too)

```sql
SET SERVEROUTPUT ON
CLEAR SCREEN

VAR P_NAME CHAR
VAR P_TABLES REFCURSOR

DECLARE
  -- this sproc is purely for example purposes, you could be referring to one in the database and/or a package
  PROCEDURE table_get(p_name IN VARCHAR2, p_tables OUT SYS_REFCURSOR)
  AS
  BEGIN
    OPEN p_tables 
     FOR
        SELECT * 
          FROM user_tables 
         WHERE TABLE_NAME LIKE P_NAME;
  END;


BEGIN  
  :P_NAME := '%REQ%';
  table_get(:P_NAME, :P_TABLES);
END;
/


PRINT P_TABLES
```
