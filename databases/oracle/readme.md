##bitmasks

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
where bitand(wanted, 2) = 0; -- gets you appears_in_both and alpha

--where bitand(wanted, 1) = 0; -- gets you appears_in_both and beta
```
