FROM centos:7

# MAINTAINER

COPY install.sh /tmp
COPY files.txt /tmp
COPY httpd.conf /tmp
COPY httpd.init /tmp
COPY metrics.c /tmp
COPY gmetad.conf /tmp
COPY gmetad.init /tmp
COPY gmond.conf /tmp
COPY gmond.init /tmp
COPY Makefile /tmp
COPY conf.php /tmp
COPY functions.php /tmp

RUN chmod 777 /tmp/install.sh
RUN chmod 777 /tmp/httpd.init
RUN chmod 777 /tmp/gmetad.init
RUN chmod 777 /tmp/gmond.init

RUN chown -R apps:apps /tmp/install.sh 
RUN chown -R apps:apps /tmp/files.txt
RUN chown -R apps:apps /tmp/httpd.conf 
RUN chown -R apps:apps /tmp/httpd.init 
RUN chown -R apps:apps /tmp/metrics.c
RUN chown -R apps:apps /tmp/gmetad.conf
RUN chown -R apps:apps /tmp/gmetad.init
RUN chown -R apps:apps /tmp/gmond.conf 
RUN chown -R apps:apps /tmp/gmond.init 
RUN chown -R apps:apps /tmp/Makefile
RUN chown -R apps:apps /tmp/conf.php
RUN chown -R apps:apps /tmp/functions.php
