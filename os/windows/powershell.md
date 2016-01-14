###Find process by nanme and show owner

Inspired by http://powershell.org/wp/forums/topic/retrieving-process-list-and-owner-name/

```ps1
Get-WmiObject win32_process | Select-Object Name,@{n='Owner';e={$_.GetOwner().User}} | Where-Obj
ect {$_.Name -like "*EXCEL*"}
```

###Count how many process

```ps1
Get-Process | Where-Object {$_.Path -like "*EXCEL*"} |
```
###Kill process (forcefully) by name

```ps1
Get-Process | Where-Object {$_.Path -like "*EXCEL*"} | Stop-Process -Force
```

###further reading
- http://gnawgnu.blogspot.co.uk/2009/09/powershell-script-to-kill-process-b.yhtml
- http://stackoverflow.com/questions/10265869/kill-process-by-filename
