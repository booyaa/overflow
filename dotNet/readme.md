##initialise an array
```string[] urmum = new string[] { "is teh cool", "bakes a mean cookie", "fibble" };```

##initialise a class

```
public class Poop {
  public string name { get; set; } // pro-tip prop<tab><tab> to generate via code snippet
  public int linkage { get; set; }
}

// in your main app

Poop mrHanky = new Poop() { name = "mrHanky", linkage = 5 };
```

##xml to linq


###How to pass XElement XML as a string

Source: http://msdn.microsoft.com/en-us/library/bb298331(v=vs.110).aspx
```
TextReader sr = new StringReader(@"<Root>
    <Child1>1</Child1>
    <Child2>2</Child2>
    <Child3>3</Child3>
</Root>");
XElement doc = XElement.Load(sr);
sr.Close();
IEnumerable<XElement> childList =
  from e in doc.Elements()
  select e;

foreach (XElement e in childList)
  Console.WriteLine(e);
```

###How to pass XElement XML as a file

Source: http://msdn.microsoft.com/en-us/library/bb675196(v=vs.100).aspx
```
XDocument doc = XDocument.Load("Test.xml");
IEnumerable<XElement> childList =
    from el in doc.Elements()
    select el;
foreach (XElement e in childList)
    Console.WriteLine(e);

```


##emumerating over linq object
