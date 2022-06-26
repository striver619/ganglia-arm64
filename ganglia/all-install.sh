#!/bin/bash

# MAINTAINER

set -e

deps()
{
        yum -y install rsync wget tar make net-tools netstat initscripts httpd php apr-devel \
                check-devel cairo-devel pango-devel libxml2-devel glib2-devel dbus-devel freetype-devel \
		fontconfig-devel gcc-c++ expat-devel python-devel libXrender-devel zlib libtool libart_lgpl \
		libpng dejavu-lgc-sans-mono-fonts dejavu-sans-mono-fonts perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker
}

confuse()
{
        cd ~
        [ -d /usr/local/confuse/bin ] && return
        [ -f confuse-2.7.tar.gz ] || wget http://download.savannah.gnu.org/releases/confuse/confuse-2.7.tar.gz
        tar -zxvf  confuse-2.7.tar.gz
        cd confuse-2.7
        ./configure --prefix=/usr/local/confuse CFLAGS=-fPIC --disable-nls --build=arm-linux
        make -j 64 && make install -j 64
}

rrd()
{
        cd ~
        [ -d /usr/local/rrdtool/bin ] && return
        [ -f rrdtool-1.5.0.tar.gz ] || wget https://oss.oetiker.ch/rrdtool/pub/rrdtool-1.5.0.tar.gz
	tar -zxvf rrdtool-1.5.0.tar.gz
	cd rrdtool-1.5.0
        ./configure --prefix=/usr/local/rrdtool --disable-tcl --build=arm-linux
        make -j 64 && make install -j 64
}

ganglia()
{
        cd ~
        [ -d /usr/local/ganglia/bin ] && return
        [ -f ganglia-3.7.2.tar.gz ] || wget http://distfiles.macports.org/ganglia/ganglia-3.7.2.tar.gz
        tar -zxvf ganglia-3.7.2.tar.gz
        cd ganglia-3.7.2

        ## modify libmetrics/linux/metrics.c
	## 先627行,追加3行内容
	sed -i '627 i\#ifdef __aarch64__ \n   snprintf(val.str, MAX_G_STRING_SIZE, "aarch64"); \n#endif' libmetrics/linux/metrics.c

	## 后520行,追加6行内容
	sed -i '520 i\#if defined (__aarch64__) \n    if (! val.uint32 ) \n    { \n        val.uint32 = 2600; \n    } \n#endif' libmetrics/linux/metrics.c
        
        ./configure --prefix=/usr/local/ganglia --with-librrd=/usr/local/rrdtool --with-libconfuse=/usr/local/confuse \
                --with-gmetad --with-libpcre=no --enable-gexec --enable-status --sysconfdir=/etc/ganglia --build=arm-linux

        ## isntall gmetad
        make -j 64 && make install -j 64
        cp gmetad/gmetad.init /etc/init.d/gmetad

        ## gmetad.conf
        sed -i "44s/^/#/" /etc/ganglia/gmetad.conf
        sed -i '45 i\data_source "arm_cluster" 172.168.178.160' /etc/ganglia/gmetad.conf
        ## setuid_username "nobody"
        ## rrd_rootdir "/var/lib/ganglia/rrds"

        cp /usr/local/ganglia/sbin/gmetad /usr/sbin/
        chkconfig --add gmetad

        ## install gmond
        mkdir -p /var/lib/ganglia/rrds/
        chmod 777 /var/lib/ganglia/
        chown -R nobody:nobody /var/lib/ganglia/rrds/
        mkdir -p /usr/local/ganglia/var/run/

        cp gmond/gmond.init /etc/init.d/gmond
        cp /usr/local/ganglia/sbin/gmond /usr/sbin/
        gmond --default_config > /etc/ganglia/gmond.conf
        ## globals      user = nobody
        ## cluster      name = "arm_cluster"

        chkconfig --add gmond

        ## install ganglia-web
        [ -d /usr/local/ganglia-web/bin ] && return
        [ -f ganglia-web-3.7.2.tar.gz ] || wget http://distfiles.macports.org/ganglia-web/ganglia-web-3.7.2.tar.gz
        tar -zxvf ganglia-web-3.7.2.tar.gz
        cd ganglia-web-3.7.2
        
        ## Makefile
        
        # Location where gweb should be installed to (excluding conf, dwoo dirs).
        #GDESTDIR = /usr/share/ganglia-webfrontend

        # Location where default apache configuration should be installed to.
        #GCONFDIR = /etc/ganglia-web

        # Gweb statedir (where conf dir and Dwoo templates dir are stored)
        #GWEB_STATEDIR = /var/lib/ganglia-web

        # Gmetad rootdir (parent location of rrd folder)
        #GMETAD_ROOTDIR = /var/lib/ganglia

        #APACHE_USER = nobody
        
        mkdir /usr/share/ganglia-webfrontend /etc/ganglia-web /var/lib/ganglia-web
        sed -i 's/APACHE_USER = .*/APACHE_USER = nobody/' Makefile
        make -j 64 && make install -j 64

        ## configuration httpd.conf
        sed -i 's/#ServerName.*/ServerName localhost:80/' /etc/httpd/conf/httpd.conf
        systemctl enable httpd
}

del()
{
        cd ~
        rm -rf confuse-2.7* rrdtool-1.5.0* ganglia-3.7.2* ganglia-web-3.7.2*
}

start()
{

}

main()
{
        deps
        confuse
        rrd
        ganglia
        del
        start
}

main
