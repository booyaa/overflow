CONNECT user_id/&password
SET sqlprompt "_USER'@'_CONNECT_IDENTIFIER _PRIVILEGE> "
REM quick and dirty way to get system details

TIMING START "Release timing"

COL ts NEW_VAL x
SELECT TO_CHAR(sysdate, 'yyyymmdd-hh24miss') ts FROM DUAL;
REM to hide query output
CLEAR SCREEN

spool release
REM will create a spool called release.lst, SQL Dev you can specify c:\path\to\spool file
REM otherwise your spool files will appear in %USERPROFILE%\AppData\Roaming\SQL Developer
PROMPT Running release on &x

REM example of a long running process and capturing the timing
HOST SLEEP 5
TIMING SHOW

REM start logging of all output
SET ECHO ON
SET FEEDBACK ON

REM object creation will be echoed

SET DEFINE OFF
REM when you don't want bind variables interpolation
PROMPT let &foo be &foo
SET DEFINE ON

TIMING OFF
SET FEEDBACK OFF
SET ECHO OFF
PROMPT phew no more echoing of everything!

SPOOL OFF
EXIT
