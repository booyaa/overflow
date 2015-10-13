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
