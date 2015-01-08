##_B_itmasks

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
##_F_unctions

###substring
```sql
select substring('foobar', -3) from dual; -- returns "bar"
select substring('foobar', 0, 3) from dual; -- returns "foo"
```

##_L_imiting rows

An alternative to rownum (which runs before an ORDER BY) is to use FETCH.

```sql
SELECT *
   FROM FOO
   ORDER BY widget_price
   FETCH FIRST 50 PERCENT ROWS ONLY;
```

##_P_rivs

```GRANT ON object_name TO user_or_role```
```REVOKE ON object_name FROM user_or_role```

###Role or user

Grant on role whenever possible, but for dynamic sql sprocs you need to grant explictly on user. Otherwise you'll get an ORA-00942 Table or view not found.


##_Q_ueries

###selecting by time range

assume that some_date_stamp is date type.

```
select * 
from foo 
where some_date_stamp between TO_DATE('14-FEB-14 14:14:14', 'DD-MON_YY HH24:MI:SS) and TO_DATE('14-FEB-14 15:15:15', 'DD-MON_YY HH24:MI:SS)
```

###explain plan usage

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

##_R_andom data

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

##_S_ampling

```sql
SELECT   foo,
         DBMS_RANOMD.value() as rnd_no
   FROM bar
   ORDER BY rnd_no --gives you randomly sorted
   FETCH FIRST 5 ROWS ONLY; -- returns only 5 rows, but will process all rows before return the 1st five.
```
##_S_QL*plus

###defaults
####for scripting

```
SET LINESIZE 90
SET PAGESIZE 100
SET WRAP OFF
```

####interactive

```
col <field name> format a15 
set pagesize 25
```

###spooling

```
SPOOL some_shit.sql
select 'insert into foo(id) values(' || id || ');' from bar
/
SPOOL OFF
@some_shit.sql
```
###sysing up

this assumes you're in the oracle admin group for what ever your os is. also ```/nolog``` works in linux which is bloody insane.

```
sqlplus /nolog
connect / as sysdba
```

###editing command history


```
SET EDITFILE "foo.buf"
DEFINE _EDITOR=vi
```

##resources
* http://www.orafaq.com/wiki/SQL*Plus_FAQ

##_T_emporal queries

###AS OF

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

###SCN to timestamp (another alternative way to view the data, use rowid for deduping)

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

##_T_racing

###Registry

```
HKLM\SOFTWARE\Wow6432Node\ORACLE\ODP.NET\4.112.3.0:
TracelLevel=1
TraceOption=0
TraceFileName=C:\odpnet4.trc
```

Trace files updated after you close the connection / application.

##Unlock

```
select username, account_status from dba_users; -- to check for locked accounts 
alter user USERNAME account unlock;
```
