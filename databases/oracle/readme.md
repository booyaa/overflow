# All or some

Return all or some values

Assume data_group table looks like this

```text
|group_id|table_name|
|1       |foo       |
|2       |bar       |
```

```sql
CREATE OR REPLACE PROCEDURE foo (p_group_id IN NUMBER)
AS
  CURSOR cur_data_group(p_group_id NUMBER)
      IS
  SELECT table_name
    FROM data_group
   WHERE group_id = NVL(p_group, group_id);
BEGIN
  FRO rec IN cur_data_group(p_group)
  LOOP
    dbms_output.put_line(table_name);
  END LOOP;
END;
/
```

Example output

```sql
SET SERVEROUTPUT ON

EXEC foo(p_group_id=>1);

foo

EXEC foo;

foo
bar
```

# Bitmasks 

```sql
with data as
(
select 'appears_in_both', 4 as wanted from dual
union all
select 'alpha', 1 as wanted from dual
union all
select 'beta', 2 as wanted from dual
)
select * from data
where bitand(wanted, 5) <> 0; -- gets you appears_in_both and alpha (4+1)

--where bitand(wanted, 6) <> 0; -- gets you appears_in_both and beta (4+2)
```

# CSV

Quick and dirty CSV export SELECT csv hint.

```sql
SPOOL C:\TEMP\foobar.csv

SELECT /*csv*/ *
  FROM foo
  LEFT
  JOIN bar
    ON foo.id = bar.id
 WHERE foo.name LIKE '%HURR%';
 
 SPOOL OFF
```

Complete list of formats

```sql
SELECT /*csv*/ * FROM scott.emp;
SELECT /*xml*/ * FROM scott.emp;
SELECT /*html*/ * FROM scott.emp;
SELECT /*delimited*/ * FROM scott.emp;
SELECT /*insert*/ * FROM scott.emp;
SELECT /*loader*/ * FROM scott.emp;
SELECT /*fixed*/ * FROM scott.emp;
SELECT /*text*/ * FROM scott.emp;
```

Full details and source can be  [here](http://www.thatjeffsmith.com/archive/2012/05/formatting-query-results-to-csv-in-oracle-sql-developer/).

# Data Dictionary

who has create database link (shows roles and users) privs

`select grantee from dba_sys_privs  where PRIVILEGE ='CREATE DATABASE LINK';`

# Database name

`select ora_database_name from dual`

# Datapump

## IMPORT

```sql
GRANT CREATE TABLE TO user; -- not role unless you want lulz
GRANT ROLE IMP_FULL_DATABASE to user;
```

`GRANT CREATE TABLE` is an important gotcha, otherwise you'll spend ages scratching your head wondering why `impdp` works, but api doesn't

## Troubleshooting

Use the command line tool to generate table schemas in a dump file if dbms_datapump api fails to import

`impdp directory=expdir dumpfile=myexp.dmp sqlfile=ddl.sql`


# Dates

```sql
select length('2015-JAN-12') from dual;	-- 11 - lolwat?
select length('2015-01-12') from dual;	-- 10 - ISO8601 lite?
select length('20150112') from dual;	-- 8 - meh
select length('12-JAN-15') from dual;	-- 9 - Oraclistas
```

# Escaping

```sql
-- escape _
SELECT * FROM FOO WHERE BAR LIKE 'A\_B' ESCAPE '\';

-- quotes
SELECT q'|who's house?|' FROM DUAL;
```

# Flashback

```sql
select * from user_recyclebin where original_name = 'foo'; -- check recyclebin for file
flashback table foo to before drop; -- restore foo
flashback table foo to before drop rename to bar; -- restore foo as bar (if foo is in use and you just need it flashback for reference purposes)
```

## Auditing changes using flash back

```sql
CLEAR SCREEN

COL name FORMAT a30

COL rname FORMAT a30

SELECT
    name,
    rname
FROM
    all_refresh_children AS OF TIMESTAMP ( trunc(SYSDATE - 1 / 24) )
WHERE
    rname = 'RFG_GROUP2';
```

where:
 - `1 / 24` is an hour ago
 - `36 / 24` is yesterday an hour and half ago

# Functions

## substring

```sql
select substring('foobar', -3) from dual; -- returns "bar"
select substring('foobar', 0, 3) from dual; -- returns "foo"
```

## Inserts multi-table

This assumes you have already created mailing_list and stats table.

```sql
INSERT ALL
   INTO mailing_list
      VALUES(name, email)
   
   INTO stats
      VALUES(id, loc)
   
   SELECT * 
      FROM big_user_data;
```

# Invalid objects

as sys or sysdba role

```sql
@?/rdbms/admin/utlrp.sql
```
source: http://oracle-base.com/articles/misc/recompiling-invalid-schema-objects.php#utlrp_and_utlprp

useful queries:

`select obj#, compile_err from utl_recomp_errors;`

tags: recompile , UTL_RECOMP , invalid , dba_objects , user_objects , errors , deploy , build

# Killing sessions

```sql
-- find
select sid, serial#, inst_id, username, osuser, program 
from gv$session 
where username is not null;

-- r11 onwards
alter system kill session 'SID,SERIAL#,@INST_ID';

-- for the copy and pastafarians
select 'alter system kill session ''' || sid || ', ' || serial# || ', @' || inst_id || ''';' || ' -- ' || username || ' - ' || osuser || ' - ' || program 

from gv$session
where osuser like '%saving_copy_pastafarians_from_killing_everything%' -- this needs to be a valid where clause
/
```

# Limiting rows

An alternative to rownum (which runs before an ORDER BY) is to use FETCH.

```sql
SELECT *
   FROM FOO
   ORDER BY widget_price
   FETCH FIRST 50 PERCENT ROWS ONLY;
```

# Markdown nav generator

Add `<A href="A"/>` to your titles and then use this code to generate a alphabeta nav bar like this `[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)...`

```sql
SET SERVEROUTPUT ON
DECLARE
  ch CHAR;
BEGIN
FOR i IN ASCII('A')..ASCII('Z')
LOOP
  ch := CHR(i);
  DBMS_OUTPUT.put('[' || ch || '](#' || ch || ')');
END LOOP;
  DBMS_OUTPUT.put_line('');
END;
/
```

## Materialize Views

Creates a snapshot of a view. Useful where you don't need historic data (use bulk load pattern if you need this).

Create the materialize view.

```sql
CREATE MATERIALIZE VIEW foo_mv
TABLESPACE "foo_data"
BUILD DEFERRED
REFRESH COMPLETE
ON DEMAND
AS
SELECT * FROM foo_v
```

Create the refresh group.

```sql
BEGIN
  DBMS_REFRESH.destroy (name => 'RGRP_FOO_MV');
  DBMS_REFRESH.make (name => 'RGRP_FOO_MV', next_date => null, interval => null);
  -- we've set next_date and interval to null because we don't want the Oracle scheduler to manage refresh
END;
/
```

To refresh the materialize view (you could stick this in a stored proc and execute in your alternative task scheduling system).

`EXEC DBMS_REFRESH.refresh('RGRP_FOO_MV');`

Useful queries:

```sql
SELECT * FROM user_refresh_children; -- to see existing refresh groups
SELECT * FROM user_mviews; -- to view freshness of materialized views
```

# Pivot

pivot => rows to columns
unpivot => columns to rows
```sql
WITH
      T
AS
(
   SELECT
      TO_CHAR(EMPNO) EMPNO,
      ENAME,
      JOB,
      TO_CHAR(MGR) MGR,
      TO_CHAR(HIREDATE) HIREDATE,
      TO_CHAR(SAL) SAL,
      TO_CHAR(COMM) COMM,
      TO_CHAR(DEPTNO) DEPTNO
   FROM
      EMP
   WHERE
      EMPNO=7788
)
SELECT
   *
FROM
   T
UNPIVOT
INCLUDE NULLS
(
   VALUE
   FOR
      COL
   IN
   (
      EMPNO,
      ENAME,
      JOB,
      MGR,
      HIREDATE,
      SAL,
      COMM,
      DEPTNO
   )
);

```

source: http://www.dba-oracle.com/t_advanced_sql_pivot_unpivot.htm

# Privs

```sql
GRANT ON object_name TO user_or_role
REVOKE ON object_name FROM user_or_role
```

## Role or user

Grant on role whenever possible, but for dynamic sql sprocs you need to grant explictly on user. Otherwise you'll get an ORA-00942 Table or view not found.

# Queries

## selecting by time range

assume that some_date_stamp is date type.

```
select * 
from foo 
where some_date_stamp between TO_DATE('14-FEB-14 14:14:14', 'DD-MON_YY HH24:MI:SS) and TO_DATE('14-FEB-14 15:15:15', 'DD-MON_YY HH24:MI:SS)
```

## explain plan usage

```sql
explain plan for select * from foo where bar='true';
select * from table(dbms_xplan.display);
```

alarm bells:
* keep an eye out for cost, partition ranges and table access.
* table access full = full table scan
* indexes not being touched
* partition range is not single or iterator not invoked

useful reads: http://www.orafaq.com/tuningguide/partition%20prune.html

# Random data

```sql
with foo as (
select  rownum, 
        dbms_random.value() rnd_no,
       CAST(dbms_random.normal() as number(10,8)) rnd_norm
from dual
connect by rownum <= 50000
)
select 
  avg(rnd_no) as mean_number,
  stddev(rnd_no) as sd_number,
  avg(rnd_norm) as mean_norm,
  stddev(rnd_norm) as sd_norm
from foo;
```

alternate method for pl/sql blocks is to use `DBMS_STATS.convert_raw_value`, but it's more of a pita since you have to pass an variable reference.

```sql
SET SERVEROUTPUT ON
DECLARE
foo VARCHAR2(25);
BEGIN
  DBMS_STATS.convert_raw_value('483939373431393030313930', foo);
  DBMS_OUTPUT.put_line('foo: ' || foo);
END;
/

```

# Raw values

As used by RAW datatype and various data dictionary columns

```sql
SELECT  table_name,
        column_name, 
        data_type,        
        data_length,
        CASE data_type
          WHEN 'VARCHAR2' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(low_value))
          WHEN 'NUMBER' THEN TO_CHAR(UTL_RAW.cast_to_number(low_value))
        END AS low_val,
        LENGTH(CASE data_type
          WHEN 'VARCHAR2' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(low_value))
          WHEN 'NUMBER' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(low_value))
        END) AS low_val_len,
        CASE data_type
          WHEN 'VARCHAR2' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(high_value))
          WHEN 'NUMBER' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(high_value))
        END AS high_val,
        LENGTH(case data_type
          WHEN 'VARCHAR2' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(high_value))
          WHEN 'NUMBER' THEN TO_CHAR(UTL_RAW.cast_to_varchar2(high_value))
        END) as high_val_len
 FROM user_tab_columns 
ORDER 
   BY table_name, column_name;
```


# Sampling

```sql
SELECT   foo,
         DBMS_RANOMD.value() as rnd_no
   FROM bar
   ORDER BY rnd_no --gives you randomly sorted
   FETCH FIRST 5 ROWS ONLY; -- returns only 5 rows, but will process all rows before return the 1st five.
```

# Storage use of a table

```sql
SELECT segment_name,
        TO_CHAR(ROUND(SUM(bytes)/1024/1024/1024,3),'FM0.000') AS GB 
  FROM user_segments 
 GROUP 
    BY segment_name
 ORDER 
    BY 2 DESC;
```

# Stack traces

```sql
BEGIN
  NULL;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-2000, 'Stack trace: ' || dbms_utility.format_error_backtrace);
END
```

tags: stack , backtrace , errors, stack trace

# SQL*plus

## defaults
### for scripting

```
SET LINESIZE 90
SET PAGESIZE 100
SET WRAP OFF
```

### interactive

```
col <field name> format a15 
set pagesize 25
```

### spooling

```
SPOOL some_shit.sql
select 'insert into foo(id) values(' || id || ');' from bar
/
SPOOL OFF
@some_shit.sql
```
### sysing up

this assumes you're in the oracle admin group for what ever your os is. also ```/nolog``` works in linux which is bloody insane.

```
sqlplus /nolog
connect / as sysdba
```

## editing command history


```
SET EDITFILE "foo.buf"
DEFINE _EDITOR=vi
```

## resources

* All the scripts! - http://www.oracle-wiki.net/startsql


# Temporal queries

## AS OF

keywords: flashback, scn

```
select * 
from foo
as of timestamp(systimestamp - INTERVAL '30' minute(1)); -- alt notation 30 mins ago
```

```
select * 
from foo
as of timestamp(sysdate-1/24); -- an hour ago
```

See also: auditing refresh groups.

## SCN to timestamp (another alternative way to view the data, use rowid for deduping)

```
select SCN_TO_TIMESTAMP(ORA_ROWSCN)
from foo

/* example output
ORA_ROWSCN SCN_TO_TIMESTAMP(ORA_ROWSCN)
---------- ----------------------------
   9.5E+12 02-DEC-14 09.43.42.000000000 
   9.5E+12 02-DEC-14 09.43.42.000000000 
   9.5E+12 02-DEC-14 10.25.33.000000000 
   9.5E+12 02-DEC-14 13.08.14.000000000
*/
```
# Trace

If oracle support want a trace log:

```sqlplus
SET ECHO ON
CONNECT / AS SYSDBA
GRANT ALTER SESSION TO testuser;

CONNECT testuser/testuser

alter session set tracefile_identifier='29400'; 
alter session set timed_statistics = true;
alter session set statistics_level=all;
alter session set max_dump_file_size = unlimited;

-- anything not listed in diagnostics event list (see resources below) is probably an oracle error number
alter session set events '29400 trace name context forever, level 3'; 
alter session set events '29913 trace name errorstack level 3';  -- 

SELECT * FROM that_thing_that_causes_the_problem;

--baseline
SELECT * FROM dual;

EXIT;
```

To find the trace and alert log files:

```sqlplus
show parameter core_dump_dest
```

Drop down a level to find trace and alert directories.

resources:
* [http://blog.tanelpoder.com/2013/10/07/why-doesnt-alter-system-set-events-set-the-events-or-tracing-immediately/](http://blog.tanelpoder.com/2013/10/07/why-doesnt-alter-system-set-events-set-the-events-or-tracing-immediately/)
* [http://www.dba-oracle.com/int_alter_session_set_event.htm](http://www.dba-oracle.com/int_alter_session_set_event.htm)
* [http://www.adp-gmbh.ch/ora/tuning/diagnostic_events/index.html](http://www.adp-gmbh.ch/ora/tuning/diagnostic_events/index.html)
* [http://www.adp-gmbh.ch/ora/tuning/diagnostic_events/list.html](http://www.adp-gmbh.ch/ora/tuning/diagnostic_events/list.html)
* [https://jonathanlewis.wordpress.com/2011/02/15/ora-29913/](https://jonathanlewis.wordpress.com/2011/02/15/ora-29913/)
 

# synonyms

```sql
select 'CREATE OR REPLACE SYNONYM "' || OWNER || '"."' || TABLE_NAME || '" FOR "' || TABLE_OWNER || '"."' || TABLE_NAME || '";' from DBA_SYNONYMS where OWNER like '%FOO%';
```

# TO_CHAR

useful formats

```
SELECT TO_CHAR(COUNT(*), '99G999G999') FROM foo; 

-- 13,999,999 if unioning a small figure you'd it would be right aligned i.e.
--      9,999
```

also ```RPAD``` is your friend in dynamic sql...

##Tracing

###Registry

```
HKLM\SOFTWARE\Wow6432Node\ORACLE\ODP.NET\4.112.3.0:
TracelLevel=1
TraceOption=0
TraceFileName=C:\odpnet4.trc
```

Trace files updated after you close the connection / application.

# Unlock an account

```sql
select username, account_status from dba_users where account_status <> 'OPEN' order by username; -- to check for locked accounts 
alter user USERNAME account unlock;
```

if the account has become locked because the password has expired then use

```
alter user USERNAME identified by NEW_PASSWORD account unlock;
```

# Variables

How to get the name of a script

```
SET SERVEROUTPUT ON
REM $$plsql_unit will return a NULL if run in an anon block
EXEC DBMS_OUTPUT.put_line(NVL($$plsql_unit, 'plsql anon block'));
```

# Vectors or tuples in WHERE IN

```sql
with gps_map as (
  select -0.7945 as gps_lon, -0.4248 as gps_lat from dual 
  union all
  select  -0.2683,	-0.2555 from dual
  union all
  select 1.1266, -1.2959 from dual
)
select 
  gps_lon, gps_lat
  from gps_map
  where (gps_lon, gps_lat) in 
  (
    (-0.7945, -0.4248),    
    (1.1266, -1.2959)
  );
```                     
