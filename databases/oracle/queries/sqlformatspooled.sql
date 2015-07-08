-- requires sqldeveloper or sqlcl
set echo on
spool c:\foo.sql
select /*insert*/ from  user_tables;
