#partitions

## create

## view
```sql
SELECT
  TABLE_NAME,
  PARTITION_NAME,
  NUM_ROWS,
  TABLESPACE_NAME,
  HIGH_VALUE
FROM
  USER_TAB_PARTITIONS
```

note NOW_ROW column is very useful to see where stray rows live (those where a partition failed to create)

## view row data by partition

```sql
SELECT
  *
FROM 
  PARTITIONED_TABLE PARTITION(P20140324) -- where P20140324 is the your partition naming scheme
```

##split partition

scenario

big_table

|P2011|5| <-- has the overflow from years 2009 and 2010
|P2012|1|
|P2013|1|

```sql
-- first split
ALTER TABLE big_table
  SPLIT PARTITION P2011
  AT (TO_DATE('01-JAN-2010', 'DD-MON-YYYY')
  INTO (PARTITION P2009, PARTITION P2011)
  UPDATE GLOBAL INDEXES;

--second split
ALTER TABLE big_table
  SPLIT PARTITION P2011
  AT (TO_DATE('01-JAN-2011', 'DD-MON-YYYY')
  INTO (PARTITION P2010, PARTITION P2011)
  UPDATE GLOBAL INDEXES;
```

