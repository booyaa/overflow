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
