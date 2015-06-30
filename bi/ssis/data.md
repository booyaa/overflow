
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

