# GANGLIA Monitor
- [What is Ganglia?](http://ganglia.info/)
Ganglia is a scalable distributed monitoring system for high-performance computing systems such as clusters and Grids. It is based on a hierarchical design targeted at federations of clusters. It leverages widely used technologies such as XML for data representation, XDR for compact, portable data transport, and RRDtool for data storage and visualization. It uses carefully engineered data structures and algorithms to achieve very low per-node overheads and high concurrency. The implementation is robust, has been ported to an extensive set of operating systems and processor architectures, and is currently in use on thousands of clusters around the world. It has been used to link clusters across university campuses and around the world and can scale to handle clusters with 2000 nodes.

Ganglia��һ������չ�ķֲ�ʽ���ϵͳ�����ڼ�Ⱥ������ȸ����ܼ���ϵͳ����������Լ�Ⱥ���˵ķֲ���ơ��������˹㷺ʹ�õļ��������������ݱ�ʾ��XML�����ڽ��ա���Яʽ���ݴ����XDR�Լ��������ݴ洢�Ϳ��ӻ���RRDtool����ʹ�þ�����Ƶ����ݽṹ���㷨��ʵ�ַǳ��͵�ÿ�ڵ㿪���͸߲����ԡ���ʵ�ַǳ���׳������ֲ��һ��㷺�Ĳ���ϵͳ�ʹ�������ϵ�ṹ�У�Ŀǰ��ȫ����ǧ����Ⱥ��ʹ�á����Ѿ����������Ӵ�ѧУ԰��������صļ�Ⱥ�����ҿ�����չ����2000���ڵ�ļ�Ⱥ��

Ganglia is a BSD-licensed open-source project that grew out of the University of California, Berkeley Millennium Project which was initially funded in large part by the National Partnership for Advanced Computational Infrastructure (NPACI) and National Science Foundation RI Award EIA-9802069. NPACI is funded by the National Science Foundation and strives to advance science by creating a ubiquitous, continuous, and pervasive national computational infrastructure: the Grid. Current support comes from Planet Lab: an open platform for developing, deploying, and accessing planetary-scale services.

Ganglia��һ��BSD��Ȩ�Ŀ�Դ��Ŀ�������Լ��������Ǵ�ѧ��������ǧ��ƻ�����ɹ��Ҹ߼����������ʩ���Һ���������NPACI���͹��ҿ�ѧ�����RI��EIA9802069A������NACPI�ɹ��ҿ�ѧ�����������������ͨ������һ���޴����ڡ������Ŀ�ѧ���ƽ���ѧ���Լ��޴����ڵĹ��Ҽ��������ʩ������Ŀǰ��֧������Planet Lab��һ�����ڿ���������ͷ������Ǽ�����Ŀ���ƽ̨��

## 0. prepare
- chmod +x ./build
- chmod +x ./start

## 1. start build
- 1.1 build container image
  - ./build
- 1.2 run container
  - ./start

## 2. setup
- 2.1 come in container
  - docker exec -it container-id bash
- 2.2 start installing
  - cd /tmp && ./install.sh

## 3. test
- 3.1 test ganglia's service
    curl localhost:80/ganglia/
- 3.2 exit container and check container status
    exit
    docker ps
- 3.3 check host machine's service
    curl localhost:80/ganglia/
- 3.4 Mapping port: localhost port --> public network port
  - ssh -o StrictHostKeyChecking=no -o ExitOnForwardFailure=yes -o TCPKeepAlive=yes -Nf -R 22888:localhost:80 sshr@172.168.131.2 -p 5051

## 4. use
- 4.1 use web-browser browsing
  - http://ip:port/ganglia/
