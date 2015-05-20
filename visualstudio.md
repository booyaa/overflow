# Visual Studio and friends

## TFS

### unlock file

launch visual studio command prompt

```
tf undo $/tfs/path/to/file.exit /workspace:"only if name has spaces";domain\user /s:http://server:port/tfs/collection
```

source: https://techkn0w.wordpress.com/2007/06/21/unlocking-items-locked-by-someone-else-in-tfs-source-control/

tag : tfs , unlock


### metadata queries

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

source: http://stackoverflow.com/a/10194041/105282
refs: 
* http://vsts-fu.blogspot.co.uk/ 
* http://www.woodwardweb.com/vsts/getting_started.html
* https://visualstudiomagazine.com/articles/2009/03/09/inside-the-tfs-databases-an-occasional-series.aspx
* http://stackoverflow.com/questions/5977244/how-to-get-git-like-statistics-from-tfs

tags: year , datepart , dateonly
