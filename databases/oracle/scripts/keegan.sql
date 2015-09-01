--View perms (geddit)
--tags (for github search): perms , privs , keegan , crap_jokes
CLEAR SCREEN
SET WRAP OFF
SET LINESIZE 200

VARIABLE OBJECT_OWNER VARCHAR2 
VARIABLE OBJECT_NAME VARCHAR2 
BEGIN
:OBJECT_OWNER := 'SYS';
:OBJECT_NAME := 'USER_TABLES';
END;
/

COL PRIVILEGE FORMAT A10
COL GRANTEE FORMAT A20
COL GRANTOR FORMAT A20
COL OBJECT_NAME FORMAT A30
COL GRANTABLE FORMAT A10

SELECT
  PRIVILEGE,
  GRANTEE,
  GRANTABLE,
  GRANTOR,
  COLUMN_NAME object_name
FROM
  all_col_privs
WHERE
  table_schema = :OBJECT_OWNER
AND TABLE_NAME = :OBJECT_NAME
UNION ALL
SELECT
  PRIVILEGE,
  GRANTEE,
  GRANTABLE,
  GRANTOR,
  table_NAME object_name
FROM
  all_tab_privs
WHERE
  table_schema = :OBJECT_OWNER
AND TABLE_NAME = :OBJECT_NAME;

