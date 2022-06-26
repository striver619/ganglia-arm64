#!/bin/bash

# env
# setup
# start
# main

# MAINTAINER

env()
{
	localedef -i en_US -f UTF-8 en_US.UTF-8
	mv /etc/localtime /etc/localtime.bak && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	
    yum -y install wget tar net-tools netstat initscripts make apr-devel apr-util check-devel cairo-devel pango-devel libxml2-devel \
		rpm-build glib2-devel dbus-devel freetype-devel fontconfig-devel gcc-c++ expat-devel python-devel libXrender-devel libtool \
		pkg-config zlib libpng libxml2 pixman cairo glib2 rsync
	
    mkdir -p /opt/software \
		/apps/{conf,sh,logs,run,svr,data} \
		/apps/conf/ganglia \
		/apps/svr/{apr-1.6.2,apr-util-1.6.0,confuse-2.7,expat-2.1.0,ganglia-3.7.2,httpd-2.4.48,pcre-8.32,php-7.3.29,rrdtool-1.5.0} \
		/apps/svr/httpd-2.4.48/htdocs/ganglia/ \
		/apps/data/ganglia/rrds \
		/apps/lib/ganglia \
		/apps/lib/ganglia-web \
		/var/lock/subsys/ \
		/apps/run/httpd/
	
    wget -P /opt/software -i files.txt
	useradd apps
	chown -R apps:apps /opt/software/ganglia-web-3.7.2/*
	chown -R apps:apps /apps && chown -R apps:apps /apps/*
}

setup()
{
	tar -zxf /opt/software/expat-2.1.0.tar.gz -C /opt/software
	cd /opt/software/expat-2.1.0 && {
		./configure --prefix=/apps/svr/expat-2.1.0 --build=arm-linux
		make && make install
	}

	tar -zxf /opt/software/confuse-2.7.tar.gz -C /opt/software
	cd /opt/software/confuse-2.7 && {
		./configure --prefix=/apps/svr/confuse-2.7 CFLAGS=-fPIC --disable-nls --build=arm-linux
		make && make install
	}
	cp -a /apps/svr/confuse-2.7/lib /apps/svr/confuse-2.7/lib64

	tar -zxf /opt/software/apr-1.6.2.tar.gz -C /opt/software
	cd /opt/software/apr-1.6.2 && {
		./configure --prefix=/apps/svr/apr-1.6.2 --build=arm-linux
		make && make install
	}
	cp -a /apps/svr/apr-1.6.2/include/apr-1/* /apps/svr/apr-1.6.2/include/
	cp -a /apps/svr/apr-1.6.2/lib /apps/svr/apr-1.6.2/lib64

	tar -zxf /opt/software/apr-util-1.6.0.tar.gz -C /opt/software
	cd /opt/software/apr-util-1.6.0 && {
		./configure --prefix=/apps/svr/apr-util-1.6.0 --with-apr=/apps/svr/apr-1.6.2 --build=arm-linux
		make && make install
	}

	tar -zxf /opt/software/pcre-8.32.tar.gz -C /opt/software
	cd /opt/software/pcre-8.32 && {
		./configure --prefix=/apps/svr/pcre-8.32 --build=arm-linux
		make && make install
	}
    
    tar -zxf /opt/software/rrdtool-1.5.0.tar.gz -C /opt/software
	cd /opt/software/rrdtool-1.5.0 && {
		./configure --prefix=/apps/svr/rrdtool-1.5.0 --disable-tcl --build=arm-linux
		make && make install
	}

	tar -zxf /opt/software/httpd-2.4.48.tar.gz -C /opt/software
	cd /opt/software/httpd-2.4.48 && {
		./configure --prefix=/apps/svr/httpd-2.4.48 --enable-so --enable-mods-shared=most \
					--with-apr=/apps/svr/apr-1.6.2 --with-apr-util=/apps/svr/apr-util-1.6.0 --build=arm-linux 
		make && make install
	}
	cp /tmp/httpd.init /apps/sh
	mv /apps/svr/httpd-2.4.48/conf/httpd.conf /apps/svr/httpd-2.4.48/conf/httpd.conf.bak
	cp /tmp/httpd.conf /apps/svr/httpd-2.4.48/conf/
	mv /apps/svr/httpd-2.4.48/log /apps/logs/httpd
	ln -s /apps/logs/httpd /apps/svr/httpd-2.4.48/logs
	ln -s /apps/svr/httpd-2.4.48/conf /apps/conf/httpd

	tar -zxf /opt/software/php-7.3.29.tar.gz -C /opt/software
	cd /opt/software/php-7.3.29 && {
		./configure --prefix=/apps/svr/php-7.3.29 --with-apxs2=/apps/svr/httpd-2.4.48/bin/apxs --build=arm-linux
		make && make install
	}

	tar -zxf /opt/software/ganglia-3.7.2.tar.gz -C /opt/software
    mv /opt/software/ganglia-3.7.2/libmetrics/linux/metrics.c /opt/software/ganglia-3.7.2/libmetrics/linux/metrics.c.bak
    cp /tmp/metrics.c /opt/software/ganglia-3.7.2/libmetrics/linux/
	cd /opt/software/ganglia-3.7.2 && {
		./configure --prefix=/apps/svr/ganglia-3.7.2 --with-librrd=/apps/svr/rrdtool-1.5.0 \
			--with-apr=/apps/svr/apr-1.6.2 --with-apr-util=/apps/svr/apr-util-1.6.0 \
			--with-libexpat=/apps/svr/expat-2.1.0 --with-libconfuse=/apps/svr/confuse-2.7 \
			--with-libpcre=/apps/svr/pcre-8.23 --enable-gexec --enable-status \
			--with-gmetad --with-static-modles --sysconfdir=/apps/conf/ganglia --build=arm-linux
		make && make install
	}
	
    cp /tmp/gmetad.conf /apps/conf/ganglia/
	cp /tmp/gmetad.init /apps/sh/

    cp /tmp/gmond.conf /apps/conf/ganglia/
	cp /tmp/gmond.init /apps/sh/
	
	tar -zxf /opt/software/ganglia-web-3.7.2.tar.gz -C /opt/software
    mv /opt/software/ganglia-web-3.7.2/Makefile /opt/software/ganglia-web-3.7.2/Makefile.bak
    chown -R apps:apps /tmp/Makefile
	cp -a /tmp/Makefile /opt/software/ganglia-web-3.7.2/
	cd /opt/software/ganglia-web-3.7.2 && {
		make && make install
	}
	cp /tmp/conf.php /apps/svr/httpd-2.4.48/htdocs/ganglia/
    cp /tmp/functions.php /apps/svr/httpd-2.4.48/htdocs/ganglia/
}

start()
{
	/apps/sh/gmetad.init start && /apps/sh/gmetad.init status
	/apps/sh/gmond.init start && /apps/sh/gmond.init status
	/apps/sh/httpd.init start && /apps/sh/httpd.init status
}

main()
{
	env
	setup
	start
}

main


# º¯Êý¶à¸ãÒ»Ð©
