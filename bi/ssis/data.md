
todo: doco this

## oledb connections as data adapter
```csharp
try
{
  ConnectionManager cm = Dts.Connections[“Minerva”];       
  Microsoft.SqlServer.Dts.Runtime.Wrapper.IDTSConnectionManagerDatabaseParameters100 cmParams = cm.InnerObject as Microsoft.SqlServer.Dts.Runtime.Wrapper.IDTSConnectionManagerDatabaseParameters100;
  using (OleDbConnection conn = cmParams.GetConnectionForSchema() as OleDbConnection)
  {
    OleDbCommand command =new OleDbCommand(sqlScript, conn);
    command.ExecuteNonQuery();
  }
}
catch (Exception e)
{
}
```

Don't forget to add a reference Microsoft.SqlServer.Dts.Runtime.Wrapper (haven't worked out why it doesn't work server side).

source: https://saldeloera.wordpress.com/2012/04/09/ssis-how-to-reuse-existing-connection-manager-to-execute-sql-in-script-task/

## fill a dt with an sqlcommand sproc call
```csharp
DataTable table = new DataTable();
using(var con = new SqlConnection(ConfigurationManager.ConnectionStrings["DB"].ConnectionString))
using(var cmd = new SqlCommand("usp_GetABCD", con))
using(var da = new SqlDataAdapter(cmd))
{
   cmd.CommandType = CommandType.StoredProcedure;
   da.Fill(table);
}
```

source: http://stackoverflow.com/a/13402124/105282

## using foreach variable enumerator

example give iterates through a string variable (User::StdOut) used to store standard out from an execute process task:


```
sample data
hello\r\n
world\r\n
```

explode lines in a script task and store in an object variable (User::StdOutLines)

```
System.Collections.ArrayList arr = new System.Collections.ArrayList();
string[] lines = vars["User::StdOut"].Value.ToString().Split({'\r','\n'}, StringSplitOptions.RemoveEmptyEntries);
foreach (line in lines)
{
  arr.Add(line);
}
vars["User::StdOutLines"] = arr;
```

then in the foreach enumerator set your variable as User::StdOutLines and your variable mapping as an object variable (not sure if this is required vs string will test later on). 

tags : variable , foreach , enumerator
