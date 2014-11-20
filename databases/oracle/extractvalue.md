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
