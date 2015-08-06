# piping commands to and from docker

## test script

```shell
tester.sh
#!/bin/bash
echo '**************************'
echo '** Begin standard input **'
echo '**************************'
cat < /dev/stdin
echo '***************************'
echo '** Finish standard input **'
echo '***************************'
```

if you pipe data into the script you should get the input echoed back to you

```
$ echo foo | ./tester.sh
**************************
** Begin standard input **
**************************
foo
***************************
** Finish standard input **
***************************
```

if you redirect a file (in our case a here string), you get a similar result

```
./tester.sh << EOF
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> EOF
**************************
** Begin standard input **
**************************
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
***************************
** Finish standard input **
***************************
```

# docker image

here's our Dockerfile

```
FROM debian:jessie
MAINTAINER Mark Santa Ana <booyaa@booyaa.org>
WORKDIR /usr/src
ADD tester.sh /usr/src/
ENV PATH=$PATH:/usr/src
CMD tester.sh
```

let's build it using `docker build -t pipeline .`

# testing pipes in docker

piping still works as expected

```
$ echo foo | docker run -i --rm pipeline
**************************
** Begin standard input **
**************************
foo
***************************
** Finish standard input **
***************************
```

so does redirection

```
docker run -i --rm pipeline << EOF
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> all work and no play makes jack a dull boy
> EOF
**************************
** Begin standard input **
**************************
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
all work and no play makes jack a dull boy
***************************
** Finish standard input **
***************************
```

but there's more! typing out the docker command can get a bit tedious, so let's alias it!

```
alias bar="docker run -i --rm pipeline"
echo foo | bar
**************************
** Begin standard input **
**************************
foo
***************************
** Finish standard input **
***************************
```

FIN.
