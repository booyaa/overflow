# _c_ygwin-lite

install git and include git bash. you get most of the core unix tools: grep, cut, find, sort, unix2dos and of course a bash shell.

## unix2dos

```
find . -type f -exec unix2dos {} \;
```

# _E_RRORLEVEL

```IF %ERRORLEVEL% NEQ 0 ECHO ARROOOGA ARROOOOGA!```

tags: ERROR , ERRORLEVEL , NEQ

# Extracting files from an MSI 

with a detailed log file 

```msiexec /a "X:\PATH\TO\FILE.MSI" /qb /L*v "Q:\PATH\TO\FILE.LOG" TARGETDIR="Y:\PATH\TO\EXTRACT\FILES\INTO"```

Caveat: you won't know what the script does post file extraction.

tags: msi , msiexec

# _S_hell to file explorer and back again

## dos to file explorer (retains path)

```c:\foo\bar\>explorer .```

## file explorer

in address bar overwrite value with

```cmd .```

# _F_OR loopisms

## failing silently (caution)
When you have to ensure dir doesn't fail i.e. oracle external table preprocessor script.  force all output (standard out and error) to standard out and then filter out ```File Not Found```. If no files are found the loop will fall through silently.

```batch
for /f "tokens=*" %%A in ('dir *.zip /b 2^>^&1 ^| FINDSTR /V "File Not Found"') do (
  UNZIP -o %DBDUMP_PATH%\%%A -d D:\APPS\UTIL\FOO
)
```

- bonus tip: you have to redirect standard error to standard out to be able to filter/pipe to another command.
- bonus tip: note the escaped `>, &, |` symbols in the loop expression.
- bonus tip: silence is golden, if you need to kill all output from standard out and error: ```>NUL 2>&1```

see also: http://shaunedonohue.blogspot.co.uk/2007/09/every-time-i-need-to-redirect-dos.html

tags: for , dos , loop , stderr , stdout , redirect

## testes, testes, 1, 2, 3?

```batch
for %i in (1,2,3) do @echo %i
```

output

```
1
2
3
```

# _L_og all things (including errors)

`1>>%LOGFILE% 2>&1`

# _T_FS

To use TF.EXE (note TF.EXE not TFS) run Visual Studio COmmand Prompt

## Find status of code

```
REM based on current path that is a local mapping to code in TFS
CD /D C:\TFS\MainProject\SubProject
tf status . /user:* /recursive

REM based on TFS path
tf status $/MainProject/SubProject /user:* /recursive

REM tip, use /format:detailed to see workspace
```

## Undo checkout status (if someone has left)

```
tf undo $/MainProject/SubProject/nibble.bas /workspace:WORKSPACE_NAME;USER_ID /s:http://TFSSERVER:PORTNO/TFS_PATH/COLLECTION_NAME
```

## reference

- [msdn](https://msdn.microsoft.com/en-us/library/z51z7zy0%28v=vs.100%29.aspx)
tags : tf , tfs , source control

# _V_ariables

Switching drives (fucking hate windows...)

drive letter sniffing is obsoleted by `CD /D %INSTALLPATH%`. take aways `IF /I` compare strings without case matching

```batch
SET INSTALLPATH=C:\FOO
SET CWD=%CD%
IF /I "%INSTALLPATH:~-0,2%" == "C:" GOTO CDRIVE
IF "%INSTALLPATH:~-0,2%" == "D:" GOTO DDRIVE
GOTO ERRLOLWATDRIVE

:CDRIVE
C:
:DDRIVE
D:
CALL install.cmd
GOTO END

:ERRLOLWATDRIVE
ECHO Error expected C: or D: got %INSTALLPATH:~-0,2%

:END
CD %CWD%
::FIXME only switches back to old dir path, you still need to do the fucking drive switch...
```


