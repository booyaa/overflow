# _c_ygwin-lite

install git and include git bash. you get most of the core unix tools: grep, cut, find, sort, unix2dos and of course a bash shell.

## unix2dos

```
find . -type f -exec unix2dos {} \;
```

# Extracting files from an MSI 

with a detailed log file 

```msiexec /a "X:\PATH\TO\FILE.MSI" /qb /L*v "Q:\PATH\TO\FILE.LOG" TARGETDIR="Y:\PATH\TO\EXTRACT\FILES\INTO"```



Caveat: you won't know what the script does post file extraction.

tags: msi , msiexec
# _s_hell to file explorer and back again

## dos to file explorer (retains path)

```c:\foo\bar\>explorer .```

## file explorer

in address bar overwrite value with

```cmd .```

## for loopisms

When you have to ensure dir doesn't fail i.e. oracle external table preprocessor script.  force all output (standard out and error) to standard out and then filter out ```File Not Found```. If no files are found the loop will fall through silently.

```dos
for /f "tokens=*" %%A in ('dir *.zip /b 2^>^&1 ^| FINDSTR /V "File Not Found"') do (
  UNZIP -o %DBDUMP_PATH%\%%A -d D:\APPS\UTIL\ACBSIMP 
)
```

- bonus tip: you have to redirect standard error to standard out to be able to filter/pipe to another command.
- bonus tip: note the escaped `>, &, |` symbols in the loop expression.
- bonus tip: silence is golden, if you need to kill all output from standard out and error: ```>NUL 2>&1```
