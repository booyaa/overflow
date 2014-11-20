#hello world
warning:extract value expects a single value to be returned
```sql
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
            <city>foo</city>
            
            <name>Oregon</name>        
          </state>
        </states>
      </country>
    </countries>') as XMLDATA FROM DUAL)
    
select extractvalue(foo.xmldata, '/countries/country/states/state/city') "name" from foo;    
```

#how to get attribute values
```sql
with foo as (select xmltype('<?xml version="1.0"?>
    <library>
      <book title="crap book">
        <page>1</page>
        <page>2</page>
      </book>
    </library>') as XMLDATA from DUAL)
select extractvalue(foo.xmldata, '/library/book/@title') "title" from foo;
```

