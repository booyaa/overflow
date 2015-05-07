# _c_ygwin-lite

install git and include git bash. you get most of the core unix tools: grep, cut, find, sort, unix2dos and of course a bash shell.

## unix2dos

```
find . -type f -exec unix2dos {} \;
```

# Extracting files from an MSI 

```msiexec /a "X:\PATH\TO\FILE.MSI" /qb TARGETDIR="Y:\PATH\TO\EXTRACT\FILES\INTO"```

Caveat: you won't know what the script does post file extraction.

tags: msi , msiexec
# _s_hell to file explorer and back again

## dos to file explorer (retains path)

```c:\foo\bar\>explorer .```

## file explorer

in address bar overwrite value with

```cmd .```

