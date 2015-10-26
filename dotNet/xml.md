# Confirm namespace

foo.xml

```xml
<Root xmlns="http://www.adventure-works.com">
  <Child>child content</Child>
</Root>
```

namespace.cs
```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Text;

namespace ConsoleApplication1
{
    class Program
    {        
        static void Main(string[] args)
        {
            XDocument doc = XDocument.Load(@"C:\PATH\TO\FOO.XML");
            bool found = doc.Root.Attributes().Where(a => a.IsNamespaceDeclaration)
                .Any(a =>
                {
                  var inner = false;
                  if (a.Value.Contains("bar"))
                  {
                    Console.WriteLine("Found bar in namespace");
                    inner = true;
                  }
                  return inner;
                }
                return inner;
             );

            Console.WriteLine("Did we find it? {0}", found);
            Console.Read();
        }
    }
}

```


# TODO

```xml
<root>
  <fizz>buzz</fizz>
  <foo>bar</foo> <--- want this
</root>
```

```csharp
doc.Descendants().Where(a => a.Name.LocalName == "foo" && a.Value == "bar").ToList().ForEach(b => Console.WriteLine("Descendant: {0}", b));
```
