SELECT
  tablespace_name,
  TO_CHAR(used_percent, '00.00') AS "%"
FROM
  dba_tablespace_usage_metrics;
