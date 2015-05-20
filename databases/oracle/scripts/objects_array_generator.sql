CLEAR SCREEN
SET SERVEROUTPUT ON
DECLARE
  CURSOR cur_objects IS
  SELECT -- customise this query to suit your needs
    synonym_name as object_name -- don't change this unless you update the cursor loop
  FROM
    user_synonyms
  ORDER BY
    synonym_name;
  
  v_array_t_tmpl VARCHAR2(2000) := 'TYPE array_t IS VARRAY(%ITEMS%) OF VARCHAR2(30);';
  v_table_array_tmpl VARCHAR2(32000) := 'table_array array_t := array_t(' || CHR(10) || '%COLS%' || CHR(10) || ');';
  v_cols VARCHAR2(16000) := '';
  v_sql VARCHAR2(32000) := '';      
  v_arraysize NUMBER := 0;
BEGIN  
  FOR r IN cur_objects
  LOOP    
    v_cols := v_cols || ',''' || r.object_name || '''' || CHR(10);    
    v_arraysize := v_arraysize + 1;
  END LOOP;
  
  v_sql := REPLACE(v_array_t_tmpl, '%ITEMS%', v_arraysize);
  DBMS_OUTPUT.put_line(v_sql);
  
  v_cols := SUBSTR(v_cols, 2);
  v_sql := REPLACE(v_table_array_tmpl, '%COLS%', v_cols);
  DBMS_OUTPUT.put_line(v_sql);
END;
/

SET SERVEROUTPUT OFF
