# Bind variables vs User variables

```PLSQL
PROMPT bind variables are...
VAR foo VARCHAR2

SET SERVEROUTPUT ON
BEGIN
  :FOO := 'in PL/SQL blocks';
  DBMS_OUTPUT.PUT_LINE('mostly used...');
END;
/
SET SERVEROUTPUT OFF

PRINT foo
```

output
```
bind variables are...

PL/SQL procedure successfully completed.

mostly used...


FOO
---
in PL/SQL blocks
```

```PLSQL
PROMPT Where as user variable are...
DEFINE FOO = 'useful in SQL scripts'
SET VERIFY OFF
SELECT '&FOO' AS BAR FROM DUAL;
SET VERIFY ON
```

output
```
Where as user variable are...

BAR                 
---------------------
useful in SQL scripts
```

To be explict, use bind vars to interact with PL/SQL blocks and user variables are substituion variables that could be used anywhere. The only downside to user variables is that you can't DEFINE a variable with another user variable.

Further reading:

- [Toadworld using bind variables](http://www.toadworld.com/platforms/oracle/w/wiki/1358.using-bind-variables)
- [bind variables performant when using with dynamic (useful instrumention query)](http://www.dba-oracle.com/plsql/t_plsql_efficient.htm)
