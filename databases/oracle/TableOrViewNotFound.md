#How to catch table or view not found

no you can't trap this error using WHEN OTHERS THEN...

a better way that was suggested by http://stackoverflow.com/a/4208506/105282 was to wrap into a stored procedure so the code would have to be compiled. the error in this is being triggered at runtime, so the exception block isn't going to catch it.

```sql
DECLARE
	jeremy_cnt INT := 0;
	missing_tables EXCEPTION;Ta
	PRAGMA EXCEPTION_INIT(missing_tables, -942);  
BEGIN
	EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM missing_table' INTO jeremy_cnt;
	
	EXCEPTION  
		WHEN missing_tables THEN
		  DBMS_OUTPUT.PUT_LINE('missing objects!');
END;
/
```
