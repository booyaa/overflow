-------------------------------------------------------------                                       
-- Author        : YOUR NAME HERE
-- Creation Date : TODAY
-- Description   : This should be meaningful
-------------------------------------------------------------
SET SERVEROUTPUT ON
SET LINESIZE 100
SET VERIFY OFF
SET FEEDBACK OFF
PROMPT

----------------------------------------------------------------
-- CODE BEGINS HERE
----------------------------------------------------------------
DECLARE
   count INT := 0;
BEGIN
	count := 1;
	
	IF count > 0 THEN RAISE_APPLICATION_ERROR(-20000, 'WRONG VALUE FOR COUNT!'); END IF;

	-- this line wil never run
	DBMS_OUTPUT.PUT_LINE('TEST PASSED!');
	
	EXCEPTION 
		WHEN OTHERS THEN
		  -- sometimes it's useful to know where your script is failing...
		  DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
		  DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
		  DBMS_OUTPUT.PUT_LINE('TEST FAILED!');      
END;
/
----------------------------------------------------------------
-- CODE ENDS HERE
----------------------------------------------------------------
SET VERIFY OFF
SET FEEDBACK OFF
/
