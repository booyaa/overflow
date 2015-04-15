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

tag: mq , .net , dll
