#!/bin/bash

# docker run -dit --name doc-md-1 -p 80:8000 centos:7

deps()
{
    yum -y install epel-release wget tar python3 python3-pip net-tools make gcc
}

conf()
{
    mkdir ~/.pip
    touch ~/.pip/pip.conf
    sed -i "1 i [global]" ~/.pip/pip.conf
    sed -i "2 i index-url = https://pypi.tuna.tsinghua.edu.cn/simple" ~/.pip/pip.conf
    sed -i "3 i [install]" ~/.pip/pip.conf
    sed -i "4 i trusted-host = pypi.tuna.tsinghua.edu.cn" ~/.pip/pip.conf
    python3 -m pip install --upgrade pip
}

pinst()
{
    pip3 install wheel beautifulsoup4==4.8.2 django==2.1.8 pillow
}

sqlite()
{
    cd ~
    wget https://www.sqlite.org/2019/sqlite-autoconf-3270200.tar.gz
    tar -zxf sqlite-autoconf-3270200.tar.gz
    cd sqlite-autoconf-3270200
    ./configure --prefix=/usr/local
    make -j 64 && make install -j 64
    cd .. && rm -rf sqlite-autoconf-3270200*
    rm -rf /usr/bin/sqlite3
    ln -s /usr/local/bin/sqlite3 /usr/bin/sqlite3
    sqlite3 --version
}

doc()
{
    mkdir /doc-manage
    cd /doc-manage
    wget http://210.22.22.150:3731/mirrors/tmp/MrDoc.tar.gz
    tar -zxf MrDoc.tar.gz
    cd /doc-manage/MrDoc
    python3 manage.py makemigrations
    python3 manage.py migrate
    echo 'please input your doc sys superuser account info'
    PYTHONIOENCODING=utf-8 python3 manage.py createsuperuser
}

start()
{
    echo 'starting doc sys...'
    nohup python3 manage.py runserver 0.0.0.0:8000 > doc-2021.log 2>&1 &
    echo 'now doc sys started'
}

main()
{
    deps
    conf
    pinst
    slqplite
    doc
    start
}

main