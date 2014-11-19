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


