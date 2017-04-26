# Flattening xmltype columns

## Getting a distinct list of node paths with values

*TODO: turn this into a useful example*

The table `elephant_castle` has a `XMLTYPE` column `details` that we want to get a list of distinct node paths.

```sql
WITH node_list AS (
    SELECT
        x.*
    FROM
        elephant_castle ec
        CROSS JOIN XMLTABLE ( 
'declare function local:path-to-node( $nodes as node()* ) as xs:string* { 
    $nodes/string-join(ancestor-or-self::*/name(.),''/'') 
}
;for $i in $doc//*
    let $node_path := local:path-to-node($i)    (: still don''t have a clue how this func works :)
    let $node_value := $i/text()
    where string-length($node_value) > 0        (: how to exclude nodes without values :)

    return <data>
                <path>{$node_path}</path>
                <value>{$node_value}</value>
            </data>'
                PASSING ec.details AS "doc" COLUMNS
                    node_path VARCHAR2(4000) PATH 'path',
                    node_value VARCHAR2(4000) PATH 'value' /* this is for debugging purposes*/
            ) x
) SELECT distinct nl.node_path
FROM
    node_list nl;    
```    

## Further Reading

- xpath function [string-length](https://msdn.microsoft.com/en-us/library/ms256171(v=vs.110).aspx)
- xpath [node tests](http://www.way2tutorial.com/xml/xpath_node_test_examples.php)

### flwor specific
- [stylusstudios](http://www.stylusstudio.com/xquery-primer.html)
- [w3schools](https://www.w3schools.com/xml/xquery_flwor.asp)
- [altova](https://www.altova.com/xpath-intro.html)
- [all things oracle](http://allthingsoracle.com/xquery-for-absolute-beginners-part-3-flwor/)
- [msdn](https://docs.microsoft.com/en-us/sql/xquery/flwor-statement-and-iteration-xquery) warning: may have sql server specific stuff.
- [wikibooks](https://en.wikibooks.org/wiki/XQuery/FLWOR_Expression) also has a ton of xquery items.
