# TOC

* [ABCDE](#AtoE)
* [FGHIJ](#FtoJ)
* [KLMNO](#KtoO)
* [PQRST](#PtoV)
* [UVWXYZ](#UtoZ)

----

<a name="AtoE">
# A B C D E
</a>

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

## Quick stage

### Columns spanning two pages wide? 

Check Report properties paper size is A4 not Letter. Also trim the margins to 0.25in. In some cases it may be better to change orientation to Landscape.

### Date format (abbreviate)

```=Format(Fields!DATE_FIELD_NAME.Value, "yyyy-MM-dd")```

### Version control

Set report property Description as your version string (would be nice if this could be linked to major.minor.build number like SSIS).

<a name="UtoZ">
#U V W X Y Z
</a>
