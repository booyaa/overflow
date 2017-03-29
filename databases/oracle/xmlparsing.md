# when xml attacks!

At some point in your xml wrangling career you will hit an node whose data is too big for Oracle's `EXTRACTVALUE` (I think the upper limit is 4000 characters) and get this lovely message.

```
ORA-01706: user function result value was too large
01706. 00000 -  "user function result value was too large"
```

To mitigate this problem, you need to switch to **XMLTABLE** and it's useful *PASSING* attribute:

```sql
SELECT
    fix.biggie AS notorious
FROM
    source_table_with_xmltype_column o,
    XMLTABLE ( '/*'
        PASSING o.xml_field COLUMNS
            biggie VARCHAR2(4000) PATH 'substring(/path/to/offending/item/text(),1,3999)'
    ) fix;
```

The gist of the fix is to use xpath to truncate the text value before it's handed off to Oracle. Trying to cast the `xmltype` column as a `varchar2(4000)` will not fix it because the problem happens as **extractvalue** is parsing the node.

## items of note

`XML ( '/*'` - how to specify the root of an xml document

`biggie VARCHAR2(4000) PATH 'substring(/path/to/offending/item/text(),1,3999)'` - how to get the text from an xpath and truncate it to 4000 chars.

sources:
- https://oracle-base.com/articles/misc/xmltable-convert-xml-data-into-rows-and-columns-using-sql
- http://stackoverflow.com/a/12691983/105282
- for a 10g fix http://stackoverflow.com/a/13790623/105282

# normalize countries with states

```sql
	/* results table
		Name  State
		US    Washington
		US	  Oregon
	*/
	
	with foo as (select xmltype('<?xml version="1.0"?>
	<countries>
	  <country>
		<name>Canada</name>
	  </country>
	  <country>
		<name>US</name>
		<states>
		  <state>
			<name>Washington</name>
			<name>Oregon</name>        
		  </state>
		</states>
	  </country>
	</countries>') as XMLDATA FROM DUAL)


	select t1.countryname as name, t2.state as state
	from foo,

	  xmltable('countries/country[2]' passing XMLDATA  
		columns 
		  countryname varchar2(10) path 'name',
		  statename xmltype path 'states/state' -- good example of how to 
	  ) t1,                                         -- parse different nodes
	                                                -- to get more columns
	  xmltable('state/name' passing t1.statename    
		columns
		  state varchar2(10) path '.'
	  ) t2;
```

#normalize countries
```sql
	/* results table
	  Name
	  Canada
	  US
	*/
	
	with foo as (select xmltype('<?xml version="1.0"?>
	<countries>
	  <country>
		<name>Canada</name>
	  </country>
	  <country>
		<name>US</name>
		<states>
		  <state>
			<name>Washington</name>
			<name>Oregon</name>        
		  </state>
		</states>
	  </country>
	</countries>') as XMLDATA FROM DUAL)

	select t1.countryname as name
	from foo,
	  xmltable('countries/country' passing XMLDATA
		columns 
		  countryname varchar2(10) path 'name'
	  ) t1;
```

#xmlquery way

```sql
	/* results table
		CountryName
		Canada
		US
	*/

	with foo as (select xmltype('<?xml version="1.0"?>
	<countries>
	  <country>
		<name>Canada</name>
	  </country>
	  <country>
		<name>US</name>
		<states>
		  <state>
			<name>Washington</name>
			<name>Oregon</name>        
		  </state>
		</states>
	  </country>
	</countries>') as XMLDATA FROM DUAL)

	SELECT x.countryname
	  FROM foo,
		XMLTable('for $i in /countries/country
				  return $i'
				  PASSING XMLDATA
				  COLUMNS countryname varchar(10) PATH 'name') x;
```


# Meta xml extraction

```xml
<main>                    
	<document_id>1234567</document_id>                    
	<format>E66</format>                    
	<data>
		<Fname>ABCD</Fname>
		<Lname>EFGD</Lname>
	</data>                
</main>
```

You want the xml child of /main/data

TL;DR node() is the key, text() returns nothing because it's xml. extracting /main/data will also give you the parent i.e. `<data><Fname...><etc></data>`

```plsql
DECLARE
  xmlData XMLType;
  sDocumentId VARCHAR2(100);
  sFormat     VARCHAR2(100);
  cData CLOB;
BEGIN
  xmlData := XMLType(
  '<main>                    
<document_id>1234567</document_id>                    
<format>E66</format>                    
<data><Fname>ABCD</Fname><Lname>EFGD</Lname></data>                
</main>'
  );
  SELECT
    ExtractValue(xmlData, '/main/document_id/text()'),
    ExtractValue(xmlData, '/main/format/text()'),
    Extract(xmlData, '/main/data/node()').getStringVal()
  INTO
    sDocumentId,
    sFormat,
    cData
  FROM
    (
      SELECT
        xmlData
      FROM
        DUAL
    );
  dbms_output.put_line(sDocumentId);
  dbms_output.put_line(sFormat);
  dbms_output.put_line(cData);
  /* output
  1234567
  E66
  <Fname>ABCD</Fname><Lname>EFGD</Lname>
  */
END;
```

