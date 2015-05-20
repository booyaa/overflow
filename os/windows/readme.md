# _c_ygwin-lite

install git and include git bash. you get most of the core unix tools: grep, cut, find, sort, unix2dos and of course a bash shell.

## unix2dos

```
find . -type f -exec unix2dos {} \;
```

# Extracting files from an MSI 

with a detailed log file 

```msiexec /a "X:\PATH\TO\FILE.MSI" /qb /L*v "Q:\PATH\TO\FILE.LOG" TARGETDIR="Y:\PATH\TO\EXTRACT\FILES\INTO"```



Caveat: you won't know what the script does post file extraction.

tags: msi , msiexec
# _s_hell to file explorer and back again

## dos to file explorer (retains path)

```c:\foo\bar\>explorer .```

## file explorer

in address bar overwrite value with

```cmd .```

# _t_fs

```
USE TFS_YOUR_COLLECTION_NAME
--detail SELECT c.DisplayPart,cs.CreationDate,cs.ChangeSetId,v.*
--coding streak
SELECT DISTINCT CONVERT(VARCHAR(8), CreationDate, 112)
FROM tbl_ChangeSet cs
LEFT OUTER JOIN tbl_identity i ON cs.OwnerId = i.IdentityId
LEFT OUTER JOIN [Constants] AS c ON i.[TeamFoundationId] = c.[TeamFoundationId]
LEFT OUTER JOIN dbo.tbl_Version AS v ON v.Versionfrom = cs.ChangeSetId
WHERE UPPER(c.NamePart) = 'AD_USER_NAME'
	AND v.ParentPath LIKE '$\PROJECT_PATH%'
	AND datepart(year, creationdate) = 2015
ORDER BY 1
```

tags: year , datepart , dateonly
