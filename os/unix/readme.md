#Unix

<a name="F"/>
##_F_ind
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