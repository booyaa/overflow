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
##awk
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

```
awk ' BEGIN { print "header" } { print } END { print "lines:"NR } ' /etc/passwd # example of begin and end blocks
awk ' {print NR, $0_} ' /etc/passwd # add line numbers to each line
ifconfig eth0 | awk -F":" '/HWaddr/{print toupper($3 $4 $5 $6 $7 $8)}' # prints partial mac address fragment
```

##declare
[A](#A)[B](#B)[C](#C)[D](#D)[E](#E)[F](#F)[G](#G)[H](#H)[I](#I)[J](#J)[K](#K)[L](#L)[M](#M)[N](#N)[O](#O)[P](#P)[Q](#Q)[R](#R)[S](#S)[T](#T)[U](#U)[V](#V)[W](#W)[X](#X)[Y](#Y)[Z](#Z)

shows bash function definitons

```declare -f | grep '^[a-z_]' # just the names```


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