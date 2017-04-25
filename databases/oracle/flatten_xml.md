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
    let $node_path := local:path-to-node($i)
    let $node_value := $i/text()    
    where string-length($node_value) > 0 
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
