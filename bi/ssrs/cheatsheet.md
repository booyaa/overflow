# TOC

* [ABCDE](#AtoE)
* [FGHIJ](#FtoJ)
* [KLMNO](#KtoO)
* [PQRST](#PtoV)
* [UVWXYZ](#UtoZ)

----

<a name="AtoE"/>
# A B C D E
## Db Connectivity

Where possible always use the OLEDB over ODBC. If you can create the DSN in ODBC, you have a good chance of creating it as OLEDB connection. If you have to, create a connection using SSIS. Steal the connection string.

### Connection Strings

#### iSeries
`Data Source=ISERIES_SERVER_NAME;User ID=USER_ID;Initial Catalog=INITIAL_CATALOGUE;Provider=IBMDA400.DataSource.1;Force Translate=1;`

#### Oracle

#### ACE (aka JET or MS Office drivers)

## Error messages

### Data retrieval failed for subreport ... located at .... Please check the log files for more information

####Cause #1 - not using a shared data source

Check that your subreport has access to a shared data source. Otherwise you may need to provide credentials.

More information can be found here: http://venusingireddy.blogspot.co.uk/2014/05/the-user-data-source-credentials-do-not.html

####Cause #2 - you copied the report

SSRS keeps some kind of GUID reference, delete and readd the sub-report.

<a name="FtoJ">
#F G H I J
</a>

## Hiding rows

- In tablix right click on a "Row Visibility"
- Show or hide based on an expression
- `=Fields!Surname.Value = ""` (Item: <All>, Values: True (highlighted)
- CanShrink: True property might be useful.

If this doesn't work, click on the row and check that you haven't set a cell level visibility property by mistake. This will override the row visibility property.

<a name="KtoO">
#K L M N O
</a>


<a name="PtoV">
#P Q R S T
</a>

##Passing parameters from main report to sub reports

In the main report you have parameter called ```XML```.

Open up the subreport properties, create a new property called ```subrepXML```, set the value as ```=Parameters!XML.value```.

Save and close.

In the sub report create a new parameter called ```subrepXML``` with ```Specify values``` selected. You can now reference this within your datasets. Check out [Parsing XML as a dataset](#ParsingXmlDataSet) for as useful application.


<a name="ParsingXmlDataSet"##Parsing XML as a dataset</a>

###Design stage

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

###TODO: list useful sites that provide good ElementPath queries.

###Deployment stage

replace the previous query with this expression

```
="<Query><XmlData>" & Parameters!XML.Value & "</XmlData><ElementPath>root{}/branch</ElementPath></Query>"
```

You'll no longer be able to map or refresh fields until you revert back to the Design stage. I've tried specifying a valid value in the XML parameter, but SSRS 2008 gleefully ignores it.

## Quick tips

### Columns spanning two pages wide? 

Check Report properties paper size is A4 not Letter. Also trim the margins to 0.25in. In some cases it may be better to change orientation to Landscape.

### Date format (abbreviate)

```=Format(Fields!DATE_FIELD_NAME.Value, "yyyy-MM-dd")```

Resource:
[https://msdn.microsoft.com/en-us/library/az4se3k1%28v=vs.110%29.aspx](https://msdn.microsoft.com/en-us/library/az4se3k1%28v=vs.110%29.aspx)

### Layout

Resource:
[http://www.mssqltips.com/sqlservertip/3023/sql-server-reporting-services-tips-and-tricks-to-improve-the-end-user-experience/](http://www.mssqltips.com/sqlservertip/3023/sql-server-reporting-services-tips-and-tricks-to-improve-the-end-user-experience/)
### Version control

Set report property Description as your version string (would be nice if this could be linked to major.minor.build number like SSIS).

<a name="UtoZ"/>
#U V W X Y Z

##URLs

- http://server/Reports - UI
- http://servers/ReportServer - API view
