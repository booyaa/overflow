##Bitmasks

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
##Functions

###substring
```sql
select substring('foobar', -3) from dual; -- returns "bar"
select substring('foobar', 0, 3) from dual; -- returns "foo"
```

##Queries

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


##sqlplus

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
* 
##Tracing

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
