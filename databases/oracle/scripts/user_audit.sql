set linesize 100
SET pages 1000 
col os_username FOR a20 
col term FOR a20
col returncode FOR a25
SELECT
  os_username,
  NVL(terminal,userhost) term,
  case returncode
  when 0 then 'Successful login'
  when 1017 then 'Invalid username/password'
  when 28000 then 'Locked out account'
  else 'Unknown return code: ' || to_char(returncode)
  end returncode,
  TO_CHAR(TIMESTAMP, 'DD-MON-YYYY HH24:MI:SS') ts
FROM
  dba_audit_session
WHERE
  username    ='&DB_USERNAME'
AND TIMESTAMP > sysdate - 7
ORDER BY
  TIMESTAMP;
  
