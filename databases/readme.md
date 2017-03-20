# basics

```sql
WITH foo AS (
    SELECT
        1 AS id,
        111 AS data
    FROM
        dual
    UNION ALL
    SELECT
        2 AS id,
        222 AS data
    FROM
        dual
    UNION ALL
    SELECT
        3 AS id,
        333 AS data
    FROM
        dual
),bar AS (
    SELECT
        2 AS id,
        'AAA' AS data
    FROM
        dual
    UNION ALL
    SELECT
        3 AS id,
        'BBB' AS data
    FROM
        dual
    UNION ALL
    SELECT
        4 AS id,
        'CCC' AS data
    FROM
        dual
)  select f.data as foo, b.data as bar
from foo f
--cross join bar b /* lol foo x bar = 9 rows*/
--inner join bar b /* fetches data if present in both tables - 2 rows*/
--left join bar b /* fetches data if present in left - 3 rows */
--right join bar b /* fetches data if present in right - 3 rows */
full outer join bar b /* gets everything even nulls, not the same as cross join - 4 rows*/
on f.id = b.id
;
```

# boilerplate

## sorting by month abbreviation

```sql
  --i'll assume your case extract 3 letter month and upper cases it.
  when 'JAN' then 1
    when 'FEB' then 2
    when 'MAR' then 3
    when 'APR' then 4    
    when 'MAY' then 5
    when 'JUN' then 6
    when 'JUL' then 7
    when 'AUG' then 8    
    when 'SEP' then 9
    when 'OCT' then 10
    when 'NOV' then 11
    when 'DEC' then 12
```

# defensive coding

Always wrap ON clauses in parens to avoid predicates being deleted accidentally. The following code will scream if you delete  the AND clause.

```sql
SELECT *
  FROM foo
  LEFT JOIN bar
    ON ((foo.id = bar.id)
        AND (foo.fizz = bar.buzz))
```

Where as the following won't.

```sql
SELECT *
  FROM foo
  LEFT JOIN bar
    ON foo.id = bar.id
        AND foo.fizz = bar.buzz
```


# reading

- [running oracle packages or sprocs on sql server](https://fred115.wordpress.com/2013/04/13/call-oracle-store-procedure-from-ms-sql-server-via-openquery/)
