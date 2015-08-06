# docker / wordpress / nginx

## setup first site

## db

    docker create --name mysql-data -v /var/lib/mysql mariadb
    docker run --name mysql --volumes-from mysql-data -e MYSQL_ROOT_PASSWORD=wordpress -d mariadb

## nginx.conf

```nginx
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen 80;
        root /var/www/html;
        index index.html index.php;
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
            fastcgi_pass   wordpress:9000;
            try_files $uri =404;
        }
    }
}
```

# setup first site

    docker run --name wpfoo --link mysql:mysql -p 9000:9000 -d wordpress:fpm

# nginx

    docker run --rm -p 80:80 --volumes-from=wpfoo -v $PWD/nginx-multi.conf:/etc/nginx/nginx.conf nginx

# tear down

    docker run --rm -it --link mysql:mysql mariadb /bin/bash # sh -c "mysql -h mysql -p"

```sql
drop database wordpress;
```
# multiple wordpress

    mkdir {conf,wpfoo,wpbar}
    docker run --name wpfoo --link mysql:mysql -p 9001:9000 -d -v $PWD/wpfoo:/var/www/html wordpress:fpm
    docker run --name wpfoo --link mysql:mysql -p 9001:9000 -d -v $PWD/wpfoo:/var/www/html wordpress:fpm
    docker run --rm -p 80:80 -v $PWD/wpfoo:/var/www/foo -v $PWD/wpbar:/var/www/bar -v $PWD/conf/nginx.conf:/etc/nginx/nginx.conf nginx

docker run --name wpbooyaa --link mysql:mysql -p 9001:9000 -d -e WORDPRESS_DB_NAME=wpbooyaa wordpress:fpm

# go 

## compiling

`docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang go build -v`

# nginx

## serverblocks (aka virtual hosts)

fire up a separate nginx site (bar) to test proxy pass

    docker run --name bar \
      -p 8080:80 nginx

    docker run --name foo \
      -v $PWD/conf.d:/etc/nginx/conf.d \
      -v $PWD/sites:/usr/share/nginx \
      --link bar:bar \
      -p 80:80 nginx

* 1st -v points to our new serverblock confs (FIXME: data container)
* 2nd -v points to our new www root dirs (FIXME: data containers)
* --link adds bar to the hosts file
* Expose port 80 to docker host

assuming you have the file dir:

    /sites
    /sites/foo.org
    /sites/foo.org/index.html
    /sites/bar.com
    /sites/bar.com/index.html
    /Dockerfile
    /conf.d
    /conf.d/foo.org.conf
    /conf.d/bar.com.conf
    /conf.d/default.conf

foo.org.conf:

```nginx
server {
    listen       80;
    server_name foo.org;

    location / {
        root   /usr/share/nginx/foo.org;
        index  index.html index.htm;
    }

    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```


bar.com.conf:

```nginx
server {
    listen       80;
    server_name bar.com;

    location / {
        root   /usr/share/nginx/bar.com;
        index  index.html index.htm;
    }

    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

## nginx and php:fpm

index.php:
```
<?php phpinfo(); ?>
```

nginx.conf:
```
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen 80;
        root /var/www/html;
        index index.html index.php;
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
            fastcgi_pass   php-fpm:9000;
            try_files $uri =404;
        }
    }
}
```

```
docker run -d -v $PWD/index.php:/var/www/html/index.php --name php-fpm php:5.6-fpm
docker run -p 8080:80 --volumes-from php-fpm --link php-fpm:php-fpm -v $PWD/nginx.conf:/etc/nginx/nginx.conf nginx
```
got working with wordpress by changing fastcgi_pass from php-fpm to wordpress.

# nginx and wordpress 

## pre-reqs

```
docker pull the following images
wordpress           fpm                 b986af329094        2 weeks ago         423.8 MB
nginx               latest              224873bdcaa1        2 weeks ago         93.44 MB
mariadb             latest              7f70676c217c        2 weeks ago         257.4 MB
```

## setup

mysql

```
docker create --name mysql-data -v /var/lib/mysql mariadb
docker run --name mysql --volumes-from mysql-data -e MYSQL_ROOT_PASSWORD=wordpress -d mariadb

docker run --name mysqltest --rm -it --rm --link mysql:mysql sh -C "mysql -h mysql -p $MYSQL_ENV_MYSQL_ROOT_PASSWORD""
```

wordpress

```
docker run --name wordpress --link mysql:mysql -p 9000:9000 -d wordpress:fpm

docker run --name wordpresstest -it --rm --volumes-from wordpress --link wordpress_wordpress /bin/bash

ls /var/www/html
netstat -tlp
```

nginx

```
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile        on;
    keepalive_timeout  65;
    server {
        listen 80;
        root /var/www/html;
        index index.html index.php;
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
            fastcgi_pass   wordpress:9000;
            try_files $uri =404;
        }
    }
}
```
# multiple wordpress sites
```
docker run --rm -p 8080:80 \
--volumes-from barcom_wordpress_1 \
--volumes-from fooorg_wordpress_1 \
--link barcom_wordpress_1:bar \
--link fooorg_wordpress_1:foo \
-v $PWD/nginx-wp.conf:/etc/nginx/nginx.conf \
-v $PWD/conf.d:/etc/nginx/conf.d \
nginx
```

should place you in the name site and first user wizard.

#docker

##b2d linking your host osx filesystem with a container

if you use docker -v /some/path/on/host:/some/path/on/container you won't find the directory on your mac. as with all tunnelling and sharing the link is between the container and your boot2docker vm that host the docker daemon.

a slightly hackish way to fix is to install sshfs on your boot2docker and map it. the other alternative is to use rsync to periodically keep the two directories up to date.

```
osx $ boot2docker ssh # your pass will tcuser, also pro-tip turn on remote login in sysprefs if you don't normally enable ssh on you rmac
b2d $ tce-load -wi sshfs-fuse # installs ssh fs
b2d $ mkdir ~/osx
b2d $ sshfs $username@$ipaddress:/Users/$username/ /home/docker/osx/ # where $username $ipaddress are the details of your mac.
b2d $ sudo -s # if you need to peek around, for some reason the docker account has insufficent rights
osx $ docker run -it -rm -v /home/docker/osx:/opt/booyaa ubuntu bash
container $ ls /opt/booyaa # et violá you haz macbook file os avails

```


##mysql

```
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=mysecretpassword -d mysql # startup

docker run -it --link some-mysql:mysql --rm mysql sh -c 'exec mysql -h"$MYSQL_PORT_3306_TCP_ADDR" -P"$MYSQL_PORT_3306_TCP_PORT" -uroot -p"$MYSQL_ENV_MYSQL_ROOT_PASSWORD"' # launch mysql

docker run --name some-app --link some-mysql:mysql -d application-that-uses-mysql # link an app
```

##wordpress (still not working)

setup: https://github.com/eugeneware/docker-wordpress-nginx


##setup nat-ing (boot2docker)

###terminology

* host computer used to start up boot2docker (b2d) vm
* b2d (boot2docker vmimage/hypervisor that runs all docker containers)
* image is a docker vm like a template
* container is an instance of an image

###commands

```
docker run -p <b2d port>:<container port> --name <container name> -d <image name> # -p(ublis a container's port) -d(etach)
docker start <container name>
boot2docker ssh -L <b2p port>:localhost:<host port> # localhost is host computer
```

###test

http://localhost:<host port>

##magick
enable vol sharing

    docker run -it --link some-mysql:mysql -name fooofoo -v /home/docker/osx:/opt/booyaa mysql bash # my usual workflow
    boot2docker sudo sshfs booyaa@192.168.59.3:/Users/booyaa/ /home/docker/osx/


    docker run -it --link some-mysql:mysql --rm -v /Users/booyaa/Desktop/hello:/opt/booyaa mysql bash # how to map the boot2docker vm to the container, now just need to work out how to get files off it...
    docker run -it ubuntu bash
    docker ps -a
    export FOO=$(docker ps | grep -Ev ^CONTAINER | cut -d' ' -f40- | awk '{print $1}' | head -1) # get first container
    for i in $(docker ps -aq); do docker rm $i; done # blat ALL containers (even ones running)
    docker run --memory=2048k --rm -it nodesource/node:trusty node -e "console.log(process.memoryUsage())" # smallest amount of memory you can get away with for node

##reference
* node containers by nodesource - https://nodesource.com/blog/nodesource-docker-images
* wordpress - https://registry.hub.docker.com/_/wordpress/
* wordpress (official repo)- https://github.com/docker-library/wordpress
* wordpress on digitalocean - https://www.digitalocean.com/community/tutorials/how-to-dockerise-and-deploy-multiple-wordpress-applications-on-ubuntu
* cheatsheet - https://github.com/wsargent/docker-cheat-sheet#containers

# wordpress

#ntpdate europe.pool.ntp.org

to update time when we put the mac sleep

#wordpress my story

##preqs

pull the following docker images

```
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
mysql               5.6                 461d07d927e6        8 days ago          282.8 MB
debian              jessie              50ec2d202fe8        9 days ago          122.8 MB
antfie/wordpress    latest              1bf169c6f66b        6 weeks ago         299.2 MB
```

##parameters

SITE_NAME=foo
MYSQL_PASSWORD=wordpress
HTTP_PORT=80

##theory


##copy and paste time

```
 #create mysql data container
docker create --name foo-mysql-data -v /var/lib/mysql mysql:5.6

 #create mysql server container
docker run --name foo-mysql --volumes-from foo-mysql-data -e MYSQL_ROOT_PASSWORD=wordpress -d mysql:5.6

 #shell into mysql (temporary)
docker run -it --rm --link foo-mysql:mysql mysql:5.6 /bin/bash

 #create db
docker run -it --rm --link foo-mysql:mysql mysql:5.6 /bin/bash -c 'mysqladmin --host=mysql --password=wordpress create wordpress'

##possible tweaks for creating default admin user in wordpress

source: http://www.wpbeginner.com/wp-tutorials/how-to-add-an-admin-user-to-the-wordpress-database-via-mysql/

```
USER_LOGIN=booyaa
USER_PASS=password1
USER_EMAIL=foo@domain.com

insert into wp_users(user_login,
                        user_pass, 
                        user_nicename,
                        user_email,
                        user_registered,
                        user_status,
                        display_name)

values($USER_LOGIN,
        MD5($USER_PASS),
        $USER_LOGIN,
        $USER_EMAIL,
        SYSDATE(),
        0,
        $USER_LOGIN);
        

--some how get the ID

USER_ID=@LAST_ID

insert into wp_usermeta(user_id,
                        meta_key,
                        meta_value)
values($USER_ID,
		'wp_capabilities',
		'a:1:{s:13:"administrator";b:1;}');

insert into wp_usermeta(user_id,
                        meta_key,
                        meta_value)
values($USER_ID,
		'wp_user_level',
		'10');

commit;		
        
```

```

insert into wp_users(user_login,
                        user_pass, 
                        user_nicename,
                        user_email,
                        user_registered,
                        user_status,
                        display_name)

values('booyaa',
        MD5('password1'),
        'booyaa',
        'booyaabooyaabooyaa@gmail.com',
        SYSDATE(),
        0,
        'booyaa');


```


 #test
docker run -it --rm --link foo-mysql:mysql mysql:5.6 /bin/bash

 #create www data container
docker create --name foo-wordpress-data -v /var/www/html debian:jessie

 #setup wordpress - instead of firing up another temporary container we can just go to docker's vfs mount and drop files in place

docker inspect foo-wordpress-data | grep -A1 -E '^    "Volumes": {' | grep '/var/lib/docker' | cut -f2 -d':' | sed 's/ "//g'
cd to/vfs/mount point
tar xvfz ~/stage/latest.tar.gz
mv wordpress/* .
rm -rf wordpress
cd ..
chown -R www-data:www-data html


docker run -it --rm --volumes-from=foo-wordpress-data -v $(pwd):/backup debian:jessie /bin/bash -c 'sleep 5 && cd /var/www/html/ && tar xvfz /backup/latest.tar.gz && mv wordpress/* . && rm -rf wordpress && cd .. && chown -R www-data:www-data html'

docker run -it --rm --volumes-from=foo-wordpress-data debian:jessie /bin/bash

 #fire up apache

docker run --name foo-wordpress --volumes-from foo-wordpress-data --link foo-mysql:mysql -p 80:80 -d antfie/wordpress
```

##test
if virual box portforward has been setup correctly dockerhost port 80 will be mapped to 3380

###manual setup (using wizard)

database name: wordpress
user name: root
password: wordpress
database host: mysql
table prefix: wp_

#tear down

```
docker rm -f $(docker ps -aq)
```

#misc

##toolkit

* apt-cache-ng container: http://docs.docker.com/examples/apt-cacher-ng/

##memory usage

source: http://programster.blogspot.co.uk/2014/09/docker-implementing-container-memory.html

```
SEARCH='GRUB_CMDLINE_LINUX=""'
REPLACE='GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"'
FILEPATH="/etc/default/grub"
sudo sed -i "s;$SEARCH;$REPLACE;" $FILEPATH
sudo update-grub
echo "You now need to reboot for the changes to take effect"
```

##wordpress salt

source: http://stackoverflow.com/a/6233537
```
 #!/bin/sh

SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='put your unique phrase here'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php
```

##nginx wordpress

http://www.servercobra.com/automated-wordpress-install-with-nginx-script/

##benchmarking

basic usage

```ab -n 100 -c 10 http://localhost:80/```

advanced

```ab -n 400 -c 10 -g apache-1.tsv http://localhost:80/```

http://www.bradlanders.com/2013/04/15/apache-bench-and-gnuplot-youre-probably-doing-it-wrong/


##docker-compose

```
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

##docker-machine

```
docker-machine create 	staging \
	--driver digitalocean \
	--digitalocean-access-token bda47270426b0d372983add192094c0281d996471867fec4b410ed6089d2d250

docker $(docker-machine config dev) ps
 docker $(docker-machine config dev) run busybox echo hello world 
```



docker-machine create ohai2gb --driver digitalocean --digitalocean-access-token bda47270426b0d372983add192094c0281d996471867fec4b410ed6089d2d250 --digitalocean-region lon1 --digitalocean-size 2gb

scp -i ~/.docker/machine/machines/ohai2gb/id_rsa do root@$(docker-machine ip):/root/do
##test


```
docker create --name foo-mysql-data -v /var/lib/mysql mysql:5.6
docker run --name foo-mysql --volumes-from foo-mysql-data -e MYSQL_ROOT_PASSWORD=wordpress -d mysql:5.6
docker run -it --rm --link foo-mysql:mysql mysql:5.6 /bin/bash -c 'mysqladmin --host=mysql --password=$MYSQL_ENV_MYSQL_ROOT_PASSWORD create wordpress'

echo Create wordpress data container
docker create --name $SITE_NAME-wordpress-data -v /var/www/html debian:jessie

echo Copy wordpress install to it\'s data container
docker run -it --rm --volumes-from=foo-wordpress-data -v $(pwd):/backup debian:jessie /bin/bash -c 'sleep 5 && cd /var/www/html/ && tar xfz /backup/latest.tar.gz && mv wordpress/* . && rm -rf wordpress && cd .. && chown -R www-data:www-data html'

echo Fire up apache
docker run --memory=256m --name $SITE_NAME-wordpress --volumes-from $SITE_NAME-wordpress-data --link $SITE_NAME-mysql:mysql -p 80:80 -d antfie/wordpress

echo Summary of containers created
docker ps -a
```


##wordpress package

assumes you ran mysql-infra compose

###brand new site w/o database

```
docker run --name wpfoo --link mysqlinfra_mysqlserver_1:mysql -p 8000:80 -e WORDPRESS_DB_USER=root -d wordpress:4.1-apache # creates a wordpress site based on existing db


docker run --name wpbar --link mysqlinfra_mysqlserver_1:mysql -p 80:80 -e WORDPRESS_DB_NAME=wpbar -d wordpress:4.1-apache # create a new site based on new db
```

###migration

####from docker image (assumes wordpress image)


peek at existing volume

```
docker run --volumes-from wordpress_wordpress_1 -it --rm debian:jessie /bin/bash
```

backup /var/www//html to tar file

```
docker run --volumes-from wordpress_wordpress_1 -v $(pwd):/backup debian:jessie tar cvf /backup/foo-www.tar /var/www/html
```

note the path...

    booyaa@dockerhost:~/coding/backup$ tar tvf foo-www.tar | head -n 10
    drwxr-xr-x www-data/www-data 0 2015-03-23 23:58 var/www/html/
    -rw-r--r-- www-data/www-data 2380 2013-10-24 23:58 var/www/html/wp-links-opml.php
    -rw-r--r-- www-data/www-data 3032 2014-02-09 20:39 var/www/html/xmlrpc.php
    -rw-r--r-- www-data/www-data 11115 2014-07-18 10:13 var/www/html/wp-settings.php
    -rw-r--r-- www-data/www-data   271 2012-01-08 17:01 var/www/html/wp-blog-header.php
    drwxr-xr-x www-data/www-data     0 2015-02-18 22:10 var/www/html/wp-includes/
    drwxr-xr-x www-data/www-data     0 2015-02-18 22:10 var/www/html/wp-includes/js/
    -rw-r--r-- www-data/www-data  1643 2014-07-10 00:58 var/www/html/wp-includes/js/customize-preview-widgets.min.js
    -rw-r--r-- www-data/www-data   324 2014-01-29 04:43 var/www/html/wp-includes/js/zxcvbn-async.min.js
    -rw-r--r-- www-data/www-data  4060 2014-12-16 20:30 var/www/html/wp-includes/js/customize-preview.js

backup mysql

    docker run -it --rm --link mysqlinfra_mysqlserver_1:mysql -v /home/booyaa/stage/sql:/temp mysql:5.6 sh -c 'mysqldump --host=mysql --password="$MYSQL_ENV_MYSQL_ROOT_PASSWORD" wpfoo > /temp/wpfoo.sql'

create new tainer

    docker create --name foo_wp_data -v /var/www/html debian:jessie

restore website

    docker run --volumes-from foo_wp_data -v $(pwd):/backup debian:jessie tar xvf /backup/foo-www.tar 

check

    docker run --volumes-from foo_wp_data -v /var/www/html debian:jessie /bin/bash

restore database

    docker run -it --rm --link mysqlinfra_mysqlserver_1:mysql -v $(pwd):/temp mysql:5.6 sh -c 'mysql --host=mysql --password="$MYSQL_ENV_MYSQL_ROOT_PASSWORD" wpfoo < /temp/wpfoo.sql'


new docker-compose.yml

    wordpress:
      image: wordpress:4.1-apache
      external_links:
        - mysqlinfra_mysqlserver_1:mysql
      environment:
        - WORDPRESS_DB_NAME=wpfoo
      ports:
        - 8888:80
      volumes_from:
        - foo_wp_data

####research
hello.sql

      SHOW DATABASES;
      EXIT

this could easily be a mysql data dump

      docker run -it --rm --link mysqlinfra_mysqlserver_1:mysql -v /home/booyaa/stage/sql:/temp mysql:5.6 sh -c 'mysql --host=mysql --password="$MYSQL_ENV_MYSQL_ROOT_PASSWORD" < /temp/hello.sql'

how to reference wordpress locally on host (would prefer a data tainer)

    docker run --name myblog -v /home/booyaa/stage/wordpress:/var/www/html --link mysqlinfra_mysqlserver_1:mysql -p 8000:80 -e WORDPRESS_DB_NAME=wpfizz wordpress:4.1-apache
