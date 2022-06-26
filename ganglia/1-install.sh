#!/bin/bash

# MAINTAINER zhangqichen <17852657226@163.com>

set -e

deps()
{
        yum -y install rsync wget tar make net-tools netstat initscripts httpd php apr-devel apr-util \
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
        ./configure --prefix=/usr/local/ganglia --with-librrd=/usr/local/rrdtool --with-libconfuse=/usr/local/confuse \
                --with-gmetad --with-libpcre=no --enable-gexec --enable-status --sysconfdir=/etc/ganglia --build=arm-linux

        ## isntall gmetad
        make -j 64 && make install -j 64
        cp gmetad/gmetad.init /etc/init.d/gmetad
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
        chkconfig --add gmond

}

del()
{
        cd ~
        rm -rf confuse-2.7* rrdtool-1.5.0* ganglia-3.7.2* ganglia-web-3.7.2*
}

start()
{
        gmetad start
        gmond start
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
