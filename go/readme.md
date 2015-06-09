#go learnings

##git and hg (until google code dies off)

1. download and install [git](http://git-scm.com/download/win)

##proxy (if required)

1. download and install [cntml](http://cntlm.sourceforge.net/)
1. cd to cntlm install dir
1. cntlm -H to generate password hashes
1. edit the following lines in ```cntlm.ini```

  ```
  Username
  Domain
  Password <-- leave this blank
  
  PassLM <-- paste in your hash
  PassNT <-- paste in your hash
  PassNTLMv2 <-- paste in your hash
  
  Proxy <-- get this from your proxy pac file
  
  ```

5. net start cntlm
6. set HTTP_PROXY=http://127.0.0.1:3128

quick test

```
cd %GOPATH%
go get github.com/robfig/cron
cd pkg\windows_amd64\github.com\robfig
```



###configure

* [https://github.com/golang/go/wiki/GoGetTools](https://github.com/golang/go/wiki/GoGetTools)
* [https://github.com/golang/go/wiki/GoGetProxyConfig](https://github.com/golang/go/wiki/GoGetProxyConfig)
 

## formatting strings

```go
  fmt.Printf("Hello, %8s\n", "pad")
	fmt.Printf("Hello, %-8s\n", "pad")
	fmt.Printf("Hello, %0.8d\n", 123)
	
	//output:
	//Hello,      pad
  //Hello, pad     
  //Hello, 00000123
```

## deltas

```go
format := "2006-01-02 15:04 MST"
start, _ := time.Parse(format, "2014-05-03 20:57 UTC")
finish, _ := time.Parse(format, "2014-05-04 20:57 UTC")
delta := finish.sub(start)

fmt.Printf("%s", delta)

//output: 24h0m0s
```
