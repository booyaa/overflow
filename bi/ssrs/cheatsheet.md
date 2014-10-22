#Error messages

##Data retrieval failed for subreport ... located at .... Please check the log files for more information

##Cause #1 - not using a shared data source

Check that your subreport has access to a shared data source. Otherwise you may need to provide credentials.

More information can be found here: http://venusingireddy.blogspot.co.uk/2014/05/the-user-data-source-credentials-do-not.html

##Cause #2 - you copied the report

SSRS keeps some kind of GUID reference, delete and readd the sub-report.

#Parsing XML as a dataset

##Design stage

Specify the following as your DataSet query:

```
<Query><XmlData>
<?xml version="1.0" encoding="utf-8"?>
<root>
  <branch>
    <twig>aroomba</twig>
  </branch>
</root>
</XmlData><ElementPath>root{}/branch</ElementPath></Query>
```

##Deployment stage

replace the previous query with this expression

```
="<Query><XmlData>" & Parameters!XML.Value & "</XmlData><ElementPath>root{}/branch</ElementPath></Query>"
```

You'll no longer be able to map or refresh fields until you revert back to the Design stage. I've tried specifying a valid value in the XML parameter, but SSRS 2008 gleefully ignores it.
