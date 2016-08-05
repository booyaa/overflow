DECLARE
  v_num_rows NUMBER;
  v_table_name VARCHAR2(35);
  v_sql VARCHAR2(8000);

  CURSOR c_tabs IS
    SELECT table_name FROM user_tables;
BEGIN
 FOR v_rec IN c_tabs
 LOOP
    v_table_name := v_rec.table_name;
    v_sql := 'SELECT count(*) FROM ' || v_table_name;
    EXECUTE IMMEDIATE v_sql INTO v_num_rows;

    DBMS_OUTPUT.put_line(v_table_name || ': ' || v_num_rows || ' rows.' );
 END LOOP;
END;
/
