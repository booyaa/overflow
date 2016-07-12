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

## nuget

### create a package

```
TODO: add nuget.exe download url

nuget pack name_of_project.csproj
```


### to add vendor dlls to your package (assumes they live in "lib" dir in your project)

```
<files>
  <file src="lib\foo.dll target="lib\net45" />
</files>
```

source: http://stackoverflow.com/questions/25569552/install-specific-dlls-from-nuget-package

### further reading 

- https://damieng.com/blog/2014/01/08/simple-steps-for-publishing-your-nuget-package
- https://npe.codeplex.com/
- https://docs.nuget.org/create/creating-and-publishing-a-package

## WCF self hosted errors

You want to run your service using a dedicated service account that isn't local admin, but you get the following error in the event log:


> Service cannot be started. System.ServiceModel.AddressAccessDeniedException: HTTP could not register URL http://+:31337/foo/bar/. Your process does not have access rights to this namespace (see http://go.microsoft.com/fwlink/?LinkId=70353 for details). ---> System.Net.HttpListenerException: Access is denied

The fix is to run the following as admin on the server:

```netsh http add urlacl url=http://+:31337/foo/bar user=DOMAIN\SERVICE_ACCOUNT_NAME```

### background

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

## Generate classes from a XML schema

- create your new project that will house classes
- give your xsd file a sensible name because this will be the class name
- right click and open in command window (might need power toy), this should open a dos prompt with visual studio gubbins set
- xsd.exe NameOfXmlSchema.xsd /classes /namespace:ACME.Modles
 
You should find a new class called NameOfXmlSchema.cs in your folder.

Further reading:
- this [page](http://dotnetdust.blogspot.co.uk/2010/05/correctly-creating-classes-using-xsdexe.html) could help with adding as part of a pre-build event
- the another useful so [answer](http://stackoverflow.com/questions/14897750/automate-xsd-exe-during-build)

## iisexpress

### Configuring sites

2013 or earlier: `%USERPROFILE%\Documents\IISExpress\config\applicationhost.config`
2015 : `PATH\TO\TFS\SOLUTION\.vs\config\applicationhost.config`

### Virtual directories

```xml
<sites>
    <site name="Some.Web" id="2">
        <application path="/" applicationPool="Clr4IntegratedAppPool">
            <virtualDirectory path="/" physicalPath="c:\tfs\path\to\website" />
			<virtualDirectory path="/static" physicalPath="c:\tfs\path\to\static\assets" /> 
        </application>
        <bindings>
            <binding protocol="http" bindingInformation="*:64699:localhost" />
        </bindings>
    </site>
</sites>
```

