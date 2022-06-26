FROM centos:7

# MAINTAINER zhangqichen <17852657226@163.com>

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
