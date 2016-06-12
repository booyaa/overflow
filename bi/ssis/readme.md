#BIDS helper tips

- Batch property updates, to fix SSIS2012 project where protection level is > 0 [http://www.cathrinewilhelmsen.net/2015/07/14/batch-update-properties-in-ssis-packages-t-sql-tuesday-68/](http://www.cathrinewilhelmsen.net/2015/07/14/batch-update-properties-in-ssis-packages-t-sql-tuesday-68/)
 
#DLL hell (why i hate .net)

Places to stick DLLs:

- GAC
- C:\Program Files\Microsoft SQL Server\110\DTS\Binn (could be D drive too)
- C:\Program Files\Microsoft SQL Server\110\DTS\Binn (could be D drive too)

Avoid none local drive mappings, you won't have them on a server or your AD service account won't have a login script to map it. Also you'll trigger a security warning if you don't use strongnames.

##GAC

1. copy gacutil from sdk 
2. `path\to\gacutil.exe /i "Namespace.Of.Your.Awful.dll"`

tags : gac , dll , crap , assembly

#variable dispenser template

```
public void Main()
        {
            Variables vars = null;
            
            try
            {
                Dts.VariableDispenser.LockForWrite("User::strWritable");
                Dts.VariableDispenser.LockForRead("User::strReadable");
                

                Dts.VariableDispenser.GetVariables(ref vars);
                vars["User::strWritable"].Value = vars["User::strReadable"].Value.ToString();

                Dts.TaskResult = (int)ScriptResults.Success;
            }
            catch (Exception)
            {
                Dts.TaskResult = (int)ScriptResults.Failure;
            }
            finally
            {
                vars.Unlock();
            }
        }
    }
```
# Mitigate XML Task (Transform operation) being broken in SSIS2012 (re: CU7 patch)

- Save the transformation result to a file
- Create a new script task to ingest the file

```
//reference variable to store contents of XML result
using (var sr = new StreamReader("c:\\file.xml") // so you dispose of the file lock automatically 
{
 var["User::XmlResult"].Value = sr.ReadToEnd();
}
```
