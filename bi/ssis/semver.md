i've created a User variable called ```VersionString``` with this expression code. 

```@[System::MachineName] + " v" + (DT_STR,4,1252) @[System::VersionMajor]  + "." + (DT_STR,4,1252) @[System::VersionMinor] + "." +  (DT_STR,4,1252) @[System::VersionBuild]```

n.b. I ended up ditching creating an extraneous variable called ```VersionPatch`` because you can't query it via msdb.dbo.sysssispackages so it's fucking useless.

references
----------
where it all began - http://semver.org/ tl;dr - major - breaking changes, minor - feature, with backward compatibility, build - patches and unfortunately saves.
heavily inspired by http://sqlblog.com/blogs/andy_leonard/archive/2010/01/06/ssis-snack-package-version.aspx

changelog
---------

- 20151012 - lol still doing ssis...
- 20130704 - added machinename so you can tell if you ran the package locally or on the server.
- 20121116 - created

tags : semantic versioning , semver , sem , ssis
