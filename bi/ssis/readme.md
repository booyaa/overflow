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
