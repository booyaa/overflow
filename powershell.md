# simple query sql

```ps
sqlps # to invoke sql powershell cmdlet
PS SQLSERVER:\> Invoke-Sqlcmd -Query "select GETDATE() as TimeOfQuery;" - ServerInstance "SQLD04"

```
