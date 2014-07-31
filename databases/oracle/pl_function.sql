REM Reference: http://docs.oracle.com/cd/B28359_01/appdev.111/b28370/subprograms.htm#CIHEAIBE
SET SERVEROUTPUT ON
SET DEFINE OFF

DECLARE
  -- local vars
  v_number NUMBER := 5;
  
  FUNCTION squared (p_number IN NUMBER) 
    RETURN NUMBER
  IS    
  BEGIN    
    RETURN p_number * p_number;
  END;
BEGIN
  FOR i in 1..5
  LOOP
    DBMS_OUTPUT.put_line(i || ' ^ 2 = ' || squared(i));
  END LOOP;

END;
/
SET SERVEROUTPUT OFF
SET DEFINE ON
