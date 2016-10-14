# Queries to make using SSIS a chore

## SSIS2012 View packages version for a given project 

```sql
declare @name varchar(20)
declare @project_id int
declare @object_version_lsn int

set @name = 'PROJECT_FOLDER_NAME'

select *
from ssisdb.internal.projects
where name = @name
order by project_id

select @project_id = max(project_id)
from ssisdb.internal.projects
where name = @name

select @object_version_lsn = object_version_lsn
from ssisdb.internal.projects
where name = @name
and project_id = @project_id

print 'using project_id ' + convert(varchar, @project_id)
print 'using object_version_lsn ' + convert(varchar, @object_version_lsn)

select @project_id project_id, @name project_name, name, version_major, version_minor, version_build
from ssisdb.internal.packages 
where project_id = @project_id
and project_version_lsn = @object_version_lsn
order by name
```
