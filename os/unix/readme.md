#Unix

```#!/bin/bash

OLDIFS=$IFS; IFS=","

while read product price quantity
do
        echo -e "\e[1;33m$product \
        =========================\e[0m\n\
        Price : \t $price \n\
        Quantity : \t $quantity \n"
done < $1
```
<a name="A"/>
##awk
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

```
awk ' BEGIN { print "header" } { print } END { print "lines:"NR } ' /etc/passwd # example of begin and end blocks
awk ' {print NR, $0_} ' /etc/passwd # add line numbers to each line
ifconfig eth0 | awk -F":" '/HWaddr/{print toupper($3 $4 $5 $6 $7 $8)}' # prints partial mac address fragment
```

<a name="C"/>
##Command Substitution

aka ```$(ls *.sql)``` or backtick (deprecated?)

```bash
foo=$(ls *.sql)
```
<a name="D"/>
##declare
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

shows bash function definitons

```declare -f | grep '^[a-z_]' # just the names```
<a name="C"/>
##colours
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

```grep --colors=always -R -E '(some|lots|blah) shiz' *.spec | less -R```

```grep -R``` emits raw codes even if the term is dumb
```less -R``` is the reciprocal switch on the other side of the pipe

<a name="F"/>
##find
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

Adapted from [this](http://javarevisited.blogspot.co.uk/2011/03/10-find-command-in-unix-examples-basic.html) article.

###-exec

Search for a term in a file

```find . -name ".htaccess" -exec grep -i REMOTE '{}' \; -print```

alternative method is to use xargs

```find . -name ".htaccess" -print | xargs grep -i REMOTE```


###-iname

Case insensitive search

```find . -iname "buzz" # will find BUZZ and buzz```

###-maxdepth

Limit search to current dir

```find . -maxdepth 1 -name ".htaccess"```

###-mtime


```
find . -name ".cs" -mtime 1 # find c sharp files nowish
find . -name ".cs" -mtime -1 # find c sharp files modified less than 1 day ago
find . -name ".cs" -mtime +1 # find c sharp files older

```

Caveat: 1 day is 24 hours in terms of a|c|mtime

###-perm

find files with a specific file perm with u=rw,og=r 

```find . -perm 644```

###-type

view symbolic links and their targets

```find ~/ -maxdepth 2 -type l -print | xargs ls -ld | cut -d  -f13```

cut work better than ```awk {print $10}``` in osx

##grep
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

```
grep -c name /proc/cpuinfo # count the number of times name appears in cpuinfo i.e. count processors
```
<a name="L" />
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)
##line endings

different ways to identify if a file is dos or unixsy

file

```
$ file *.txt

dos_file.txt:  ASCII text, with CRLF line terminators
unix_file.txt: ASCII text, with CRLF, LF line terminators
```

good old cat - where dos ends ^M$ and unix should be $.

```
$ cat -ve *.txt
--------------------------------------------------------^M$
--  DDL for Synonymn YIELD_LOG_DF^M$
--------------------------------------------------------^M$
^M$
  CREATE OR REPLACE SYNONYM "OBSB"."YIELD_LOG_DF" FOR "YIELD_LOG_DF"@"LN_OBS_BATCH.WORLD";^M$
--------------------------------------------------------^M$
--  DDL for Synonymn YIELD_LOG_DF^M$
--------------------------------------------------------^M$
$
  CREATE OR REPLACE SYNONYM "OBSB"."YIELD_LOG_DF" FOR "YIELD_LOG_DF"@"LN_OBS_BATCH.WORLD";$
```

xxd - where dos' last characters are 0d 0a and unix is 0a. (pro-tip: man ascii)

```
$ for i in $(ls *.txt); do echo $i ; xxd $i; done
dos_file.txt
0000000: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000010: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000020: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000030: 2d2d 2d2d 2d2d 2d2d 0d0a 2d2d 2020 4444  --------..--  DD
0000040: 4c20 666f 7220 5379 6e6f 6e79 6d6e 2059  L for Synonymn Y
0000050: 4945 4c44 5f4c 4f47 5f44 460d 0a2d 2d2d  IELD_LOG_DF..---
0000060: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000070: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000080: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000090: 2d2d 2d2d 2d0d 0a0d 0a20 2043 5245 4154  -----....  CREAT
00000a0: 4520 4f52 2052 4550 4c41 4345 2053 594e  E OR REPLACE SYN
00000b0: 4f4e 594d 2022 4f42 5342 222e 2259 4945  ONYM "OBSB"."YIE
00000c0: 4c44 5f4c 4f47 5f44 4622 2046 4f52 2022  LD_LOG_DF" FOR "
00000d0: 5949 454c 445f 4c4f 475f 4446 2240 224c  YIELD_LOG_DF"@"L
00000e0: 4e5f 4f42 535f 4241 5443 482e 574f 524c  N_OBS_BATCH.WORL
00000f0: 4422 3b0d 0a                             D";..
unix_file.txt
0000000: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000010: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000020: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000030: 2d2d 2d2d 2d2d 2d2d 0d0a 2d2d 2020 4444  --------..--  DD
0000040: 4c20 666f 7220 5379 6e6f 6e79 6d6e 2059  L for Synonymn Y
0000050: 4945 4c44 5f4c 4f47 5f44 460d 0a2d 2d2d  IELD_LOG_DF..---
0000060: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000070: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000080: 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d 2d2d  ----------------
0000090: 2d2d 2d2d 2d0d 0a0a 2020 4352 4541 5445  -----...  CREATE
00000a0: 204f 5220 5245 504c 4143 4520 5359 4e4f   OR REPLACE SYNO
00000b0: 4e59 4d20 224f 4253 4222 2e22 5949 454c  NYM "OBSB"."YIEL
00000c0: 445f 4c4f 475f 4446 2220 464f 5220 2259  D_LOG_DF" FOR "Y
00000d0: 4945 4c44 5f4c 4f47 5f44 4622 4022 4c4e  IELD_LOG_DF"@"LN
00000e0: 5f4f 4253 5f42 4154 4348 2e57 4f52 4c44  _OBS_BATCH.WORLD
00000f0: 223b 0a                                  ";.
```




##nl
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

add line number to a file

```nl /etc/passwd```

##sed-isms
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

```
sed -n '1,5p' /etc/passwd' # suppress stdout (otherwise you'll get two copies of the line). print lines 1 to 5
sed ' /^#/ d ; /^$/ d ' /etc/adduser.conf # removes comments and blank lines
sed ' 1,5 s/^/     /g' foo.sh # indents lines 1 to 5 with 5 spaces
sed -n ' 1,5 s/^/     /p' foo.sh # just show me the lines that will be amended
```

<a name="V"/>
##vim
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

###how to add vim prefs to your source code

The terminology for this one line is [modeline](http://vim.wikia.com/wiki/Modeline_magic].

bash:  ```# vim: set tabstop=2 shiftwidth=2 expandtab:```

**legend**

* tabstop is for tab key
* shiftwidth is for indentation ```< or >```
* expandtab converts tabs to spaces

###useful .vimrc

```
"TODO setup github repo so i don't need to download and install most of my favourites 
"execute pathogen#infect()

syntax on
filetype plugin indent on

" Press F4 to toggle highlighting on/off, and show current value.
:noremap <F4> :set hlsearch! hlsearch?<CR>
```
