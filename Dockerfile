# ARM64 (aarch64) 单阶段 Dockerfile - 在 CentOS 7 容器内完整编译 LibreOffice 25.8.4.2
# 构建时间: 8核约6-8小时，4核约12-15小时
# 最终镜像包含: GCC 11编译器、完整源码、生成的RPM包

FROM centos:7

# 构建参数
ARG MAKE_JOBS=4
ARG LO_VERSION=25.8.4.2

# 0. 配置 ARM64 Vault源（CentOS 7已停更）- 修复版
RUN rm -f /etc/yum.repos.d/CentOS-*.repo && \
    cat > /etc/yum.repos.d/CentOS-AltArch.repo <<'EOF'
[base]
name=CentOS-7 - Base - vault.centos.org (AltArch)
baseurl=http://vault.centos.org/altarch/7.9.2009/os/aarch64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7-aarch64

[updates]
name=CentOS-7 - Updates - vault.centos.org (AltArch)
baseurl=http://vault.centos.org/altarch/7.9.2009/updates/aarch64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7-aarch64

[extras]
name=CentOS-7 - Extras - vault.centos.org (AltArch)
baseurl=http://vault.centos.org/altarch/7.9.2009/extras/aarch64/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7-aarch64
EOF

# 配置 EPEL ARM64归档源（使用cat替代tee避免冲突）
RUN yum install -y -q wget && \
    wget -O /tmp/epel-release.rpm https://archives.fedoraproject.org/pub/archive/epel/7/aarch64/Packages/e/epel-release-7-11.noarch.rpm && \
    rpm -ivh /tmp/epel-release.rpm && \
    sed -i 's/^mirrorlist/#mirrorlist/' /etc/yum.repos.d/epel*.repo && \
    sed -i 's|^#baseurl=|baseurl=|' /etc/yum.repos.d/epel*.repo && \
    sed -i 's|download.fedoraproject.org/pub/epel|archives.fedoraproject.org/pub/archive/epel|' /etc/yum.repos.d/epel*.repo && \
    yum clean all && yum makecache -q && \
    rm -f /tmp/epel-release.rpm

# 1. 安装编译 GCC 11 的依赖
RUN yum install -y -q \
    gmp-devel mpfr-devel libmpc-devel \
    gcc-c++ make ncurses-devel

# 2. 源码编译安装 GCC 11.5.0（ARM64 唯一选择）
WORKDIR /usr/local/src
RUN wget -q https://ftp.gnu.org/gnu/gcc/gcc-11.5.0/gcc-11.5.0.tar.gz && \
    tar -xf gcc-11.5.0.tar.gz && \
    cd gcc-11.5.0 && \
    ./contrib/download_prerequisites && \
    mkdir build && cd build && \
    ../configure --prefix=/opt/gcc-11 \
      --enable-languages=c,c++ --disable-multilib --disable-werror && \
    make -j${MAKE_JOBS} && \
    make install && \
    cd /usr/local/src && \
    rm -rf gcc-11.5.0 gcc-11.5.0.tar.gz

# 设置 GCC 11 环境
ENV PATH="/opt/gcc-11/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/gcc-11/lib64:${LD_LIBRARY_PATH}"

# 3. 安装 LibreOffice 编译依赖（ARM64 包）
RUN yum install -y -q \
    git python3 curl unzip tar autoconf automake libtool pkgconfig \
    flex bison gperf fontconfig-devel libX11-devel libXext-devel \
    libXrender-devel libXinerama-devel libXrandr-devel libXt-devel \
    libXcursor-devel libXcomposite-devel libXdamage-devel libxcb-devel \
    mesa-libGL-devel mesa-libEGL-devel libdrm-devel gtk3-devel \
    boost-devel openssl-devel nss-devel libxml2-devel cups-devel \
    rpm-build clang llvm-devel vim perl-Archive-Zip perl-Digest-MD5

# 4. 下载并准备 LibreOffice 源码
WORKDIR /root/lobuild
RUN wget -q https://download.documentfoundation.org/libreoffice/src/25.8.4/libreoffice-${LO_VERSION}.tar.xz && \
    tar -xf libreoffice-${LO_VERSION}.tar.xz && \
    cd libreoffice-${LO_VERSION} && \
    ./download.sh

# 5. 配置 LibreOffice 编译参数（ARM64专用）
WORKDIR /root/lobuild/libreoffice-${LO_VERSION}
RUN cat > autogen.input <<EOF
--enable-epm
--enable-split-app-modules
--enable-python=system
--disable-dependency-tracking
--with-vendor="CentOS7-ARM64"
--with-package-format=rpm
--with-parallelism=${MAKE_JOBS}
--disable-ooenv
--disable-postgresql-sdbc
--without-java
--host=aarch64-redhat-linux-gnu
--build=aarch64-redhat-linux-gnu
EOF

RUN ./autogen.sh

# 6. 编译并打包LibreOffice（最耗时步骤）
# 修复: 直接执行make，失败时抛出错误
RUN make -j${MAKE_JOBS} && make distro-pack-install

# 7. 验证RPM生成并创建提取脚本
RUN ls -lh /root/lobuild/libreoffice-${LO_VERSION}/workdir/installation/*.rpm && \
    echo '#!/bin/bash' > /extract-rpms.sh && \
    echo "cd /root/lobuild/libreoffice-${LO_VERSION}/workdir/installation/" >> /extract-rpms.sh && \
    echo 'echo "Generated RPMs:"' >> /extract-rpms.sh && \
    echo 'ls -lh *.rpm' >> /extract-rpms.sh && \
    echo 'echo -e "\nTo copy RPMs out of container:"' >> /extract-rpms.sh && \
    echo 'echo "docker cp <container_id>:/root/lobuild/libreoffice-'${LO_VERSION}'/workdir/installation/*.rpm ./"' >> /extract-rpms.sh && \
    chmod +x /extract-rpms.sh

# 设置工作目录
WORKDIR /root/lobuild/libreoffice-${LO_VERSION}

# 默认命令：显示编译结果和使用说明
CMD echo "=== LibreOffice ${LO_VERSION} ARM64 Build Complete ===" && \
    echo && \
    echo "RPM location: /root/lobuild/libreoffice-${LO_VERSION}/workdir/installation/" && \
    ls -lh /root/lobuild/libreoffice-${LO_VERSION}/workdir/installation/*.rpm && \
    echo && \
    echo "Usage: docker cp <container_id>:/root/lobuild/libreoffice-'${LO_VERSION}'/workdir/installation/*.rpm ./" && \
bash

    

#FROM jenkins/jenkins:lts-slim-jdk17
#RUN jenkins-plugin-cli --plugins ssh-slaves blueocean kubernetes ace-editor ant antisamy-markup-formatter apache-httpcomponents-client-4-api apache-httpcomponents-client-5-api artifactory authentication-tokens bootstrap5-api bouncycastle-api branch-api build-timeout caffeine-api checks-api cloudbees-folder command-launcher commons-lang3-api commons-text-api config-file-provider credentials credentials-binding data-tables-api dependency-check-jenkins-plugin display-url-api docker-build-step docker-commons docker-java-api docker-workflow durable-task echarts-api email-ext external-monitor-job font-awesome-api git git-client git-server golang gradle handlebars htmlpublisher instance-identity ionicons-api ivy jackson2-api jakarta-activation-api jakarta-mail-api javadoc javax-activation-api javax-mail-api jaxb jdk-tool jquery3-api jquery-detached jsch junit kpp-management-plugin kubernetes kubernetes-client-api kubernetes-credentials ldap localization-support localization-zh-cn lockable-resources mailer mapdb-api mask-passwords matrix-auth matrix-project maven-plugin metrics mina-sshd-api-common mina-sshd-api-core momentjs okhttp-api pam-auth pipeline-build-step pipeline-graph-analysis  pipeline-input-step pipeline-github-lib pipeline-milestone-step pipeline-model-api pipeline-model-declarative-agent pipeline-model-definition pipeline-model-extensions pipeline-rest-api pipeline-stage-step pipeline-stage-tags-metadata pipeline-stage-view plain-credentials plugin-util-api publish-over publish-over-ftp publish-over-ssh quality-gates resource-disposer scm-api script-security snakeyaml-api sonar sonar-quality-gates ssh-agent ssh-credentials sshd structs subversion svncompat14 token-macro trilead-api variant workflow-aggregator workflow-api workflow-basic-steps workflow-cps workflow-cps-global-lib workflow-durable-task-step workflow-job workflow-multibranch workflow-scm-step workflow-step-api workflow-support ws-cleanup xcode-plugin theme-manager dark-theme

#FROM  golang:1.22.8 AS base
#RUN  mkdir /data && cd /data && git clone https://github.com/drone/drone.git && cd drone && git checkout tags/v2.24.0 && sed -i 's/5000/0/g' service/license/load.go && go build -o drone-server  ./cmd/drone-server/  && go build -o drone-server-oss -tags "oss nolimit" ./cmd/drone-server/

#FROM alpine:latest
#COPY --from=base /data/drone/drone-server /root/drone-server
#COPY --from=base /data/drone/drone-server-oss /root/drone-server-oss

#FROM continuumio/anaconda:2023.03-1
#RUN  conda install  pytorch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 pytorch-cuda=12.2  ; conda install --download-only pytorch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 pytorch-cuda=12.1 -c pytorch -c nvidia
#FROM openjdk:8u312-slim
#ENV  WORK_HOME=/home/admin CATALINA_HOME=/home/admin/apache-tomcat-8.5.42 
#RUN /bin/bash -c "apt update &&apt install -y vim unzip binutils net-tools tcpdump curl wget telnet lsof dnsutils iputils-ping procps && ln -s -f /bin/bash /bin/sh && echo \"alias ll='ls -l --color=auto'\" >>/etc/profile && source /etc/profile && apt cleall all" 
#WORKDIR /home/admin
#CMD ["/bin/sh","-c","bin/start.sh"]

#FROM maven
#SHELL ["/bin/bash", "-c"]
#RUN apt update>/dev/null && apt install -qq -y rpm yarn nodejs npm curl python3 python3-dev python3-pip python3-full>/dev/null && ln -s /usr/bin/python3 /usr/bin/python && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg > /etc/apt/trusted.gpg.d/yarn.asc  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && apt update>/dev/null && apt install -qq -y yarn openjdk-8-jdk>/dev/null && rm -rf /opt/java/openjdk  && cp -a /usr/lib/jvm/java-8-openjdk-amd64 /opt/java/openjdk && wget -q https://www-eu.apache.org/dist/ambari/ambari-2.7.8/apache-ambari-2.7.8-src.tar.gz && tar xfz apache-ambari-2.7.8-src.tar.gz && cd apache-ambari-2.7.8-src && mvn -q versions:set -DnewVersion=2.7.8.0.0>/dev/null && pushd ambari-metrics && mvn -q versions:set -DnewVersion=2.7.8.0.0>/dev/null && popd && echo 1111111111111111111111111111111111111111 && mvn -X -B clean install rpm:rpm -DnewVersion=2.7.8.0.0 -DbuildNumber=da8f1b9b5a799bfa8e2d8aa9ab31d6d5a1cc31a0 -DskipTests -Dpython.ver="python >= 2.6"
#20241125
#FROM centos:7
#SHELL ["/bin/bash", "-c"]

#RUN cd /etc/yum.repos.d/ &&  rm -rf * &&echo '[base]'>>local.repo &&echo 'name=CentOS'>>local.repo && echo 'baseurl=https://mirrors.aliyun.com/centos/$releasever/os/$basearch/'>>local.repo && echo 'gpgcheck=0'>>local.repo  && yum -y install gcc sudo wget openssh-clients openssh-server vim mariadb mariadb-server java-1.8.0-openjdk* net-tools chrony krb5-server krb5-libs krb5-workstation git rpm-build
#RUN wget https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.47/mysql-connector-java-5.1.47.jar -O /usr/share/java/mysql-connector-java.jar
#RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz -O /tmp/apache-maven.tar.gz --no-check-certificate \
#  && mkdir -p /usr/share/maven && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
#  && rm -f /tmp/apache-maven.tar.gz \
#  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

#RUN /bin/sed -i 's,#   StrictHostKeyChecking ask,StrictHostKeyChecking no,g' /etc/ssh/ssh_config

#RUN ssh-keygen -f "/root/.ssh/id_rsa" -N ""
#RUN wget -q https://www-eu.apache.org/dist/ambari/ambari-2.7.8/apache-ambari-2.7.8-src.tar.gz && tar xfz apache-ambari-2.7.8-src.tar.gz && cd apache-ambari-2.7.8-src && mvn -q versions:set -DnewVersion=2.7.8.0.0>/dev/null && pushd ambari-metrics && mvn -q versions:set -DnewVersion=2.7.8.0.0>/dev/null && popd && echo 1111111111111111111111111111111111111111 && mvn -X -B clean install rpm:rpm -DnewVersion=2.7.8.0.0 -DbuildNumber=da8f1b9b5a799bfa8e2d8aa9ab31d6d5a1cc31a0 -DskipTests -Dpython.ver="python >= 2.6"
#FROM  golang:1.22.8 AS base
#RUN  mkdir /data && cd /data && git clone https://github.com/drone/drone.git && cd drone  && git checkout tags/v2.24.0 && sed -i 's/5000/0/g' service/license/load.go && go build -o drone-server  ./cmd/drone-server/  && go build -o drone-server-nolimit -tags "nolimit" ./cmd/drone-server/

#FROM alpine:latest
#COPY --from=base /data/drone/drone-server /root/drone-server
#COPY --from=base /data/drone/drone-server-oss /root/drone-server-oss
#FROM ubuntu:24.04
#RUN  rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo  &&yum clean all &&yum -y install epel-release && yum localinstall -y --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && yum -y install --downloadonly --downloaddir=/media/ binfmt-support  && ls -lh /media/
#RUN   apt update && apt install wget curl -y && wget -O get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh && helm repo add openebs-lvmlocalpv https://openebs.github.io/lvm-localpv  && helm repo update &&helm pull openebs-lvmlocalpv/lvm-localpv --version 1.6.0
#### 编译minio
#FROM golang:1.24.0
#RUN go install github.com/minio/minio@RELEASE.2025-10-15T17-29-55Z

#### redhat9 安装libreoffice
#FROM --platform=linux/arm64 redhat/ubi9:9.6
#RUN dnf install java-1.8.0-openjdk -y wget unzip net-tools -y && cd /mnt/ &&  wget https://downloadarchive.documentfoundation.org/libreoffice/old/25.8.0.4/rpm/aarch64/LibreOffice_25.8.0.4_Linux_aarch64_rpm.tar.gz && tar -zxf LibreOffice_25.8.0.4_Linux_aarch64_rpm.tar.gz && cd LibreOffice_25.8.0.4_Linux_aarch64_rpm/RPMS && dnf install -y *rpm && cd ../../ && rm -rf * && wget https://downloadarchive.documentfoundation.org/libreoffice/old/25.8.0.4/rpm/aarch64/LibreOffice_25.8.0.4_Linux_aarch64_rpm_helppack_zh-CN.tar.gz && wget https://downloadarchive.documentfoundation.org/libreoffice/old/25.8.0.4/rpm/aarch64/LibreOffice_25.8.0.4_Linux_aarch64_rpm_langpack_zh-CN.tar.gz && wget https://downloadarchive.documentfoundation.org/libreoffice/old/25.8.0.4/rpm/aarch64/LibreOffice_25.8.0.4_Linux_aarch64_rpm_sdk.tar.gz 


#### 构建drone-kubenetes，用于arm推送
#FROM alpine:latest
#COPY update.sh /bin/update.sh
#RUN apk --no-cache add curl ca-certificates bash && curl -Lo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.25.0/bin/linux/arm64/kubectl && \
#    chmod +x /usr/local/bin/kubectl /bin/update.sh
#ENTRYPOINT ["/bin/bash"]
#CMD ["/bin/update.sh"]

####构建miniforge-25.9.1.0版本，并安装python3.12
#FROM ubuntu:24.04
#ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 CONDA_DIR=/opt/conda TARGETPLATFORM=linux/amd64 MINIFORGE_VERSION=25.9.1-0 MINIFORGE_NAME=Miniforge3 PATH=/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
#RUN apt-get update > /dev/null && \
#    apt-get install --no-install-recommends --yes \
#    wget \
#    bzip2 \
#    ca-certificates \
#    git \
#    tini \
#    > /dev/null && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* &&  wget --no-hsts --quiet https://github.com/conda-forge/miniforge/releases/download/${MINIFORGE_VERSION}/${MINIFORGE_NAME}-${MINIFORGE_VERSION}-Linux-$(uname -m).sh -O /tmp/miniforge.sh && \
#    /bin/bash /tmp/miniforge.sh -b -p ${CONDA_DIR} && \
#    rm /tmp/miniforge.sh && \
#    conda clean --tarballs --index-cache --packages --yes && \
#    find ${CONDA_DIR} -follow -type f -name '*.a' -delete && \
#    find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete && \
#    conda clean --force-pkgs-dirs --all --yes && \
#    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> /etc/skel/.bashrc && \
#    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh && conda activate base" >> ~/.bashrc && conda update conda -y && conda create -n myenv python=3.12 -y &&  conda init bash && export PATH="/opt/conda/bin:$PATH" >> /root/.bashrc && echo 'conda activate myenv' >> /root/.bashrc 
#ENTRYPOINT ["tini", "--"]
#CMD ["/bin/bash"]

#FROM ghcr.io/oracle/oraclelinux8-instantclient:23
#RUN dnf install -y java-1.8.0-openjdk mysql postgresql  && dnf clean all


#FROM node:20.19.2
#RUN git clone --depth 1  --branch v7.17.29 https://github.com/elastic/kibana.git 
#RUN wget https://github.com/yarnpkg/yarn/releases/download/v1.22.22/yarn-v1.22.22.tar.gz && tar zxf yarn-v1.22.22.tar.gz && cp -a  yarn-v1.22.22/bin/yarn /usr/bin/
#RUN df -h  && cd kibana && git switch -c 7.17.29 && sed -i '41s/false/true/' src/core/server/elasticsearch/version_check/es_kibana_version_compatability.ts && cat src/core/server/elasticsearch/version_check/es_kibana_version_compatability.ts && yarn kbn bootstrap && yarn build --skip-os-packages && df -h  &&  cp -a /kibana/target/kibana-7.17.29-SNAPSHOT-linux-x86_64.tar.gz /var/lib/docker/ && cp -a /kibana/target/kibana-7.17.29-SNAPSHOT-linux-aarch64.tar.gz /var/lib/docker/ && cd /var/lib/docker/  && ls -lha && rm -rf /kibana

#FROM alpine
#RUN apk add wget && wget https://sqlite.org/2025/sqlite-tools-linux-x64-3510100.zip
#RUN sqlite3

####编译drone-server
#FROM golang:1.24rc2
#RUN apt update && apt install -y git && git clone --depth 1 --branch v2.26.0  https://github.com/harness/harness.git && cd harness && git switch -c  2.26.0 && sed -i 's/5000/300000/g' service/license/load.go && go build -tags "nolimit"  -o drone-server ./cmd/drone-server && ls -lh /go/harness

####onlyoffice-jdk11
#FROM onlyoffice/documentserver:8.0.1
#RUN apt update && apt install -y openjdk-11-jdk && touch /etc/nginx/conf.d/custom.conf

####onlyoffice-jdk11
#FROM redhat/ubi10:10.1
#RUN dnf install -y --disableplugin=subscription-manager glibc-langpack-en fontconfig dejavu-sans-fonts  curl wget unzip  lsof net-tools bind-utils && echo 'export LANG=en_US.UTF-8' >> /etc/profile && echo 'export LANGUAGE=en_US:en' >> /etc/profile && echo 'export LC_ALL=en_US.UTF-8' >> /etc/profile && source /etc/profile && locale && dnf clean all && rm -rf /var/cache/yum

####下载
#FROM redhat/ubi10:10.1
#RUN dnf install -y --disableplugin=subscription-manager glibc-langpack-en fontconfig dejavu-sans-fonts  curl wget unzip  lsof net-tools bind-utils && curl -O https://downloadarchive.documentfoundation.org/libreoffice/old/25.8.4.2/src/libreoffice-25.8.4.2.tar.xz
