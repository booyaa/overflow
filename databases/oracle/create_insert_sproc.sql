-- description: pl/sql script to generate insert sproc for a given table
-- usage: sqlplus conn/to/your/oracle @create_insert_sproc TABLE_NAME (SPROC_PREFIX optional)
-- reqs: you have data dictionary access or gtfo
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE  
  v_table_name VARCHAR2(30) := '&1';
  v_sproc_prefix VARCHAR2(5) := '&2';
  
  CURSOR c_cursor IS
    SELECT *
    FROM user_tab_columns
    WHERE table_name = v_table_name
    ORDER BY COLUMN_ID;
    
  v_columns user_tab_columns%ROWTYPE;
  
  v_last_column_id NUMBER;
  
  v_parameter_line VARCHAR2(50);
  v_insert_cols VARCHAR2(1000);
  v_insert_vals VARCHAR2(1000);
  
  PROCEDURE p (p_text VARCHAR2) AS BEGIN DBMS_OUTPUT.put_line(p_text); END;
BEGIN
  SELECT MAX(column_id) INTO v_last_column_id FROM user_tab_columns WHERE table_name = v_table_name;
  
  
  p('CREATE PROCEDURE ' || v_sproc_prefix  || v_table_name || '_INSERT (');
  OPEN c_cursor;
  
  LOOP
    FETCH c_cursor INTO v_columns;      
    EXIT WHEN c_cursor%NOTFOUND;
    
    v_parameter_line := '    P_' || v_columns.column_name || ' IN ' || v_columns.data_type;
    
    IF v_columns.column_id <> v_last_column_id THEN
      v_parameter_line := v_parameter_line || ', ';
    ELSE
      v_parameter_line := v_parameter_line || ')';
    END IF;
    
    p(v_parameter_line);
  END LOOP;
  
  CLOSE c_cursor;
  
  p('BEGIN');
  
  
  v_insert_cols := 'INSERT INTO ' || v_table_name || '(';
  v_insert_vals := 'VALUES(';
  
  OPEN c_cursor;    
  LOOP
    FETCH c_cursor INTO v_columns;
    EXIT WHEN c_cursor%NOTFOUND;
    
    v_insert_cols := v_insert_cols || v_columns.column_name;
    v_insert_vals := v_insert_vals || 'P_' || v_columns.column_name;

    IF v_columns.column_id <> v_last_column_id THEN
     v_insert_cols := v_insert_cols || ', ';
     v_insert_vals := v_insert_vals || ', ';
    ELSE
      v_insert_cols := v_insert_cols|| ')';
      v_insert_vals := v_insert_vals|| ')';
    END IF;

      
  END LOOP;  
  CLOSE c_cursor;
  p('   ' || v_insert_cols);
  p('   ' || v_insert_vals || ';');
  p('   COMMIT;');
  
  p('END;');
  p('/');
END;
/
SET SERVEROUTPUT OFF
SET VERIFY ON
