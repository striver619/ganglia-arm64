# GANGLIA Monitor
- [What is Ganglia?](http://ganglia.info/)
Ganglia is a scalable distributed monitoring system for high-performance computing systems such as clusters and Grids. It is based on a hierarchical design targeted at federations of clusters. It leverages widely used technologies such as XML for data representation, XDR for compact, portable data transport, and RRDtool for data storage and visualization. It uses carefully engineered data structures and algorithms to achieve very low per-node overheads and high concurrency. The implementation is robust, has been ported to an extensive set of operating systems and processor architectures, and is currently in use on thousands of clusters around the world. It has been used to link clusters across university campuses and around the world and can scale to handle clusters with 2000 nodes.

Ganglia是一个可扩展的分布式监控系统，用于集群和网格等高性能计算系统。它基于针对集群联盟的分层设计。它利用了广泛使用的技术，如用于数据表示的XML、用于紧凑、便携式数据传输的XDR以及用于数据存储和可视化的RRDtool。它使用精心设计的数据结构和算法来实现非常低的每节点开销和高并发性。该实现非常健壮，已移植到一组广泛的操作系统和处理器体系结构中，目前在全球数千个集群上使用。它已经被用于连接大学校园和世界各地的集群，并且可以扩展处理2000个节点的集群。

Ganglia is a BSD-licensed open-source project that grew out of the University of California, Berkeley Millennium Project which was initially funded in large part by the National Partnership for Advanced Computational Infrastructure (NPACI) and National Science Foundation RI Award EIA-9802069. NPACI is funded by the National Science Foundation and strives to advance science by creating a ubiquitous, continuous, and pervasive national computational infrastructure: the Grid. Current support comes from Planet Lab: an open platform for developing, deploying, and accessing planetary-scale services.

Ganglia是一个BSD授权的开源项目，它来自加利福尼亚大学，伯克利千年计划最初由国家高级计算基础设施国家合作伙伴基金（NPACI）和国家科学基金会RI奖EIA9802069A资助，NACPI由国家科学基金会资助，致力于通过创造一个无处不在、连续的科学来推进科学。以及无处不在的国家计算基础设施：网格。目前的支持来自Planet Lab：一个用于开发、部署和访问行星级服务的开放平台。

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
