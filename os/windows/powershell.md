# Count how many process

```ps1
Get-Process | Where-Object {$_.Path -like "*EXCEL*"} |
```

# reading dot config files

```ps1
PS> $webConfig = "D:\path\to\foo.exe.config"

PS>$doc = new-object System.Xml.XmlDocument

PS>$doc.Load($webConfig)

PS>$doc.configuration.Logging.Udp.Enabled
true

PS>$doc.configuration.Logging.Udp.Enabled = "false"

PS>$doc.Save($webConfig)

PS>$doc.configuration.ConfigSection.add

key                                                         value
---                                                         -----
ServiceName                                                 ACME_FOO
ServiceDisplayName                                          ACME Foo
ServiceDescription                                          Handles Misc
ApplicationName                                             ACME
TimerIntervalSeconds                                        20
TimerEnabled                                                true
TimerActiveDays                                             12345
TimerActiveFrom                                             07:00:00
TimerActiveTo                                               19:00:00

PS>$doc.SelectSingleNode('//ConfigSection/add[@key="ServiceName"]/@value')

#text
-----
Mizuho_ESPP_File_Mover

```

# Find process by nanme and show owner

Inspired by http://powershell.org/wp/forums/topic/retrieving-process-list-and-owner-name/

```ps1
Get-WmiObject win32_process | Select-Object Name,@{n='Owner';e={$_.GetOwner().User}} | Where-Obj
ect {$_.Name -like "*EXCEL*"}
```

# Kill process (forcefully) by name

```ps1
Get-Process | Where-Object {$_.Path -like "*EXCEL*"} | Stop-Process -Force
```

# Further reading
- http://gnawgnu.blogspot.co.uk/2009/09/powershell-script-to-kill-process-b.yhtml
- http://stackoverflow.com/questions/10265869/kill-process-by-filename
