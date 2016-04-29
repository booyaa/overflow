# Command line tools

## Cheatsheet

```
SET MQSERVER=CHANNEL.NAME/TCP/HOST OR IP ADDRESS(PORT)
AMQSPUTC QUEUENAME QUEUEMANAGER < SOME\FILE\CALLED\HELLO.TXT
AMQSGETC QUEUENAME QUEUEMANAGER
```

## Display library version

Win (or c:\windows\assembly)

```
C:\IBM\WebSphere MQ\dspmqver -i
```

Unix (should be in path

```
dspmqver -i
```

source: http://www-01.ibm.com/support/docview.wss?uid=swg21621707
tag: mq , .net , dll

## RFHUtilc

Queue Manager Name: CHANNEL NAME/TCP/HOSTNAME(PORT)
