REM keywords : audit , connections , v$session
SET LINESIZE 200
COL USERNAME FORMAT A20 
COL OSUSER FORMAT A20 
COL MACHINE FORMAT A10
SELECT
  username,
  osuser,
  machine,
  program
FROM
  v$session
WHERE
  username IS NOT NULL;
  
