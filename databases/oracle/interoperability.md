#SQL Server

##Scenario

You have a database called ```foo``` on SQL Server called ```SQLBAR``` that you wish to give access to a database called ```lol``` on an Oracle Server called ```ORAWAT```.

Assuming we don't have any expensive stuff that allows kerberos authentication and sql accounts aren't punishable by death.

## Setup
On SQLBAR:

1. Create a sql account on SQL server called ```OraFoo```.
1. Give OraFoo dbo on Foo (hardening is left as an exercise for the reader).

On ORALOL:

1. Create an DSN using ODBC Data Source Admin that matches the version of Oracle you're using i.e. 32bit (%WINDIR%\SysWOW64\odbcad32.exe) or 64 (%WINDIR%\System32\odbcad32.exe). Populate with ```OraFoo``` credentials and call the DSN ```FOO```.
1. Test connectivity.
1. Set up your SID to point to ```lol```
1. cd %ORACLE_HOME%\hs\admin
1. Create a new Copy initdg4odbc.ora called initFOOLOL.ora
1. populate the following config values:
```
HD_FDS_CONNECT_INFO = FOOLOL
HS_FDS_TRACE_LEVEL = off
HD_FSD_SUPPORT_STATISTICS=FALSE
```
1. cd %ORACLE_HOME%\network\admin
1. Edit listener.ora
1. Add to the SID_LIST_LOL
```
(SID_DESC = 
  (SID_NAME = FOOLOL)
  (ORACLE_HOME = path/to/your/oracle/home)
  (PROGRAM = dg4odbc)
)
```
1. Edit tnsnames.ora and add a new TNS entry
```
LOL_FOO.WORLD =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (ADDRESS = (PROTOCOL = tcp)(HOST = ORAWAT)(PORT = 1337))
    )
    (CONNECT_DATA =
      (SID = LOLFOO)
    )
    (HS = OK)
  )
```
1. lsnrctl reload LOL
1. tnsping LOL_FOO.WORLD
1. Create db link
```
CREATE DATABASE LINK "LOL_FOO.WORLD" CONNECT TO "OraFoo"
IDENTIFIED BY "sekritpassword"
USING LOL_FOO.WORLD;
```

## Stored procedures

```DBMS_HS_PASSTHROUGH``` is a magic package, it won't pop up in code assist and is not listed in _objects. Provided you've completed the previous steps.

```
set serveroutput on
clear screen
declare
  v_result NUMBER;
begin
  v_result := DBMS_HS_PASSTHROUGH.EXECUTE_IMMEDIATE@"LOL_FOO.WORLD"('usp_CoolCatCode ''rotfl''');
end;
/
```

## Further reading

- http://stackoverflow.com/questions/16925825/having-troubles-with-unixodbc-freetds-and-pyodbc
- http://www.fatihacar.com/blog/oracle-dblink-with-odbc-connection-from-oracle-to-mssql-server-with-freetds/
- http://www.olcot.co.uk/sql-blogs/revised-difference-between-collation-sql_latin1_general_cp1_ci_as-and-latin1_general_ci_as
- http://www.easysoft.com/support/kb/kb01022.html
- http://www.easysoft.com/applications/oracle/database-gateway-dg4odbc.html
- https://oracle-base.com/articles/misc/heterogeneous-services-generic-connectivity
