##Bitmasks

```
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

##Tracing

###Registry
```
HKLM\SOFTWARE\Wow6432Node\ORACLE\ODP.NET\4.112.3.0:
TracelLevel=1
TraceOption=0
TraceFileName=C:\odpnet4.trc
```

Trace files updated after you close the connection / application.
