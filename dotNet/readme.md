##Detect 64 bit architecture

```CSharp
// for .NET 4.0 onwards
if (Environment.Is64BitProcess)
    Console.WriteLine("64-bit process");
else
    Console.WriteLine("32-bit process");
```
source (and alternatives for .NET lower than 4.0): http://www.blackwasp.co.uk/Is64BitProcess.aspx

##TODO: Emumerating over linq object

##Initialise an array
```string[] urmum = new string[] { "is teh cool", "bakes a mean cookie", "fibble" };```

##Initialise a class

```
public class Poop {
  public string name { get; set; } // pro-tip prop<tab><tab> to generate via code snippet
  public int linkage { get; set; }
}

// in your main app

Poop mrHanky = new Poop() { name = "mrHanky", linkage = 5 };
```

##WCF self hosted errors

You want to run your service using a dedicated service account that isn't local admin, but you get the following error in the event log:

```
Service cannot be started. System.ServiceModel.AddressAccessDeniedException: HTTP could not register URL
http://+:31337/foo/bar/. Your process does not have access rights to this namespace (see
http://go.microsoft.com/fwlink/?LinkId=70353 for details). ---> System.Net.HttpListenerException: Access is denied
```
The fix is to run the following as admin on the server:

```netsh http add urlacl url=http://+:31337/foo/bar user=DOMAIN\SERVICE_ACCOUNT_NAME```

###background

You'll get this error if your uri hasn't already been registered in ```netsh http show```. You don't get if using IIS instead of self hosted, because IIS hides it away from you.

It didn't help that the microsoft link is now dead, thank goodness for the [internet archive](http://web.archive.org/web/20120218225559/http://msdn.microsoft.com/en-us/library/ms733768.aspx)



##XML to Linq

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

###Pass XElement XML as a file

Source: http://msdn.microsoft.com/en-us/library/bb675196(v=vs.100).aspx
```
XDocument doc = XDocument.Load("Test.xml");
IEnumerable<XElement> childList =
    from el in doc.Elements()
    select el;
foreach (XElement e in childList)
    Console.WriteLine(e);

```
