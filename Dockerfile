# *******************************************************************************
#  ARM64 (aarch64) 多阶段 Dockerfile
#  阶段 1：完整编译 LibreOffice 25.8.4.2
#  阶段 2：仅保留 RPM 与提取脚本，体积 ≈ 200 MB
#  构建：docker build --build-arg MAKE_JOBS=8 -t lo-centos7-arm64 .
#  提取：docker run --rm -v $PWD/output:/output lo-centos7-arm64
# *******************************************************************************

####################  阶段 1：builder  ####################
FROM centos:7
RUN cd /mnt/ && curl -O  https://dev-www.libreoffice.org/src/libabw-0.1.3.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/phc-winner-argon2-20190702.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/boost_1_88_0.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/box2d-2.4.1.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/breakpad-b324760c7f53667af128a6b77b790323da04fcb9.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/bsh-2.1.1-src.zip ; curl -O  https://dev-www.libreoffice.org/src/bzip2-1.0.8.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/cairo-1.17.$(CAIRO_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libcdr-0.1.8.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/48d647fbd8ef8889e5a7f422c1bfda94-clucene-core-2.3.3.4.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/dragonbox-1.1.3.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/dtoa-20180411.tgz ; curl -O  https://dev-www.libreoffice.org/src/libcmis-0.6.2.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/CoinMP-1.8.4.tgz ; curl -O  https://dev-www.libreoffice.org/src/cppunit-1.15.1.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/curl-8.14.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libe-book-0.1.3.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libepoxy-1.5.10.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/3ade8cfe7e59ca8e65052644fed9fca4-epm-3.7.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libepubgen-0.1.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libetonyek-0.1.$(ETONYEK_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/expat-2.7.3.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/Firebird-3.0.7.33374-0.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/fontconfig-2.17.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/368f114c078f94214a308a74c7e991bc-crosextrafonts-20130214.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/c74b7223abe75949b4af367942d96c7a-crosextrafonts-carlito-20130920.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/33e1e61fab06a547851ed308b4ffef42-dejavu-fonts-ttf-2.37.zip ; curl -O  https://dev-www.libreoffice.org/src/1725634df4bb3dcb1b2c91a6175f8789-GentiumBasic_1102.zip ; curl -O  https://dev-www.libreoffice.org/src/liberation-narrow-fonts-ttf-1.07.6.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/liberation-fonts-ttf-2.1.5.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/e7a384790b13c29113e22e596ade9687-LinLibertineG-20120116.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoKufiArabic-v2.109.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSans-v2.015.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSerif-v2.015.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSerifHebrew-v2.004.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSansArabic-v2.010.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoNaskhArabic-v2.019.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSansHebrew-v3.001.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSansArmenian-v2.008.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSerifArmenian-v2.008.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSansGeorgian-v2.005.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSerifGeorgian-v2.003.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSansLao-v2.003.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSerifLao-v2.003.zip ; curl -O  https://dev-www.libreoffice.org/src/NotoSansLisu-v2.102.zip ; curl -O  https://dev-www.libreoffice.org/src/culmus-0.140.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libre-hebrew-1.0.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/alef-1.001.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/Amiri-1.001.zip ; curl -O  https://dev-www.libreoffice.org/src/ReemKufi-2.0.zip ; curl -O  https://dev-www.libreoffice.org/src/Scheherazade-2.100.zip ; curl -O  https://dev-www.libreoffice.org/src/Agdasima-2.002.zip ; curl -O  https://dev-www.libreoffice.org/src/Bacasime_Antique-2.000.zip ; curl -O  https://dev-www.libreoffice.org/src/Belanosima-2.000.zip ; curl -O  https://dev-www.libreoffice.org/src/Caprasimo-1.001.zip ; curl -O  https://dev-www.libreoffice.org/src/Lugrasimo-1.001.zip ; curl -O  https://dev-www.libreoffice.org/src/Lumanosimo-1.010.zip ; curl -O  https://dev-www.libreoffice.org/src/Lunasima-2.009.zip ; curl -O  https://dev-www.libreoffice.org/src/libfreehand-0.1.2.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/freetype-2.14.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/frozen-1.2.0.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/glm-1.0.2.zip ; curl -O  https://dev-www.libreoffice.org/src/gpgme-1.24.3.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/graphite2-minimal-1.3.14.tgz ; curl -O  https://dev-www.libreoffice.org/src/harfbuzz-12.2.0.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/17410483b5b5f267aa18b7e00b65e6e0-hsqldb_1_8_0.zip ; curl -O  https://dev-www.libreoffice.org/src/hunspell-1.7.2.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/5ade6ae2a99bc1e9e57031ca88d36dad-hyphen-2.8.8.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/IAccessible2-1.3+git20231013.3d8c7f0.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/icu4c-77_1-src.tgz ; curl -O  https://dev-www.libreoffice.org/src/icu4c-77_1-data.zip ; curl -O  https://dev-www.libreoffice.org/src/Java-WebSocket-1.6.0.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/ba2930200c9f019c2d93a8c88c651a0f-flow-engine-0.9.4.zip ; curl -O  https://dev-www.libreoffice.org/src/d8bd5eed178db6e2b18eeed243f85aa8-flute-1.1.6.zip ; curl -O  https://dev-www.libreoffice.org/src/eeb2c7ddf0d302fba4bfc6e97eac9624-libbase-1.1.6.zip ; curl -O  https://dev-www.libreoffice.org/src/3bdf40c0d199af31923e900d082ca2dd-libfonts-1.1.6.zip ; curl -O  https://dev-www.libreoffice.org/src/3404ab6b1792ae5f16bbd603bd1e1d03-libformula-1.1.7.zip ; curl -O  https://dev-www.libreoffice.org/src/db60e4fde8dd6d6807523deb71ee34dc-liblayout-0.2.10.zip ; curl -O  https://dev-www.libreoffice.org/src/97b2d4dba862397f446b217e2b623e71-libloader-1.1.6.zip ; curl -O  https://dev-www.libreoffice.org/src/8ce2fcd72becf06c41f7201d15373ed9-librepository-1.1.6.zip ; curl -O  https://dev-www.libreoffice.org/src/f94d9870737518e3b597f9265f4e9803-libserializer-1.1.6.zip ; curl -O  https://dev-www.libreoffice.org/src/ace6ab49184e329db254e454a010f56d-libxml-1.1.7.zip ; curl -O  https://dev-www.libreoffice.org/src/39bb3fcea1514f1369fcfc87542390fd-sacjava-1.3.zip ; curl -O  https://dev-www.libreoffice.org/src/libjpeg-turbo-3.1.2.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/language-subtag-registry-2025-08-25.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/lcms2-2.17.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libassuan-3.0.2.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/libatomic_ops-7.8.4.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libeot-0.01.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/libexttextcat-3.4.7.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libffi-3.5.2.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libgpg-error-1.56.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/liblangtag-0.6.8.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/libnumbertext-1.0.11.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/ltm-1.3.0.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libwebp-1.6.0.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/xmlsec1-1.3.9.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libxml2-2.14.$(LIBXML_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libxslt-1.1.$(LIBXSLT_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/26b3e95ddf3d9c077c480ea45874b3b8-lp_solve_5.5.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/lxml-6.0.2.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/mariadb-connector-c-3.3.18-src.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/mdds-3.1.0.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/mDNSResponder-878.200.35.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/meson-1.8.3.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libmspub-0.1.4.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libmwaw-0.3.$(MWAW_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/mythes-1.2.5.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/nss-3.118.1-with-nspr-4.37.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libodfgen-0.1.$(ODFGEN_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/onlineupdate-c003be8b9727672e7d30972983b375f4c200233f-2.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/openldap-2.6.10.tgz ; curl -O  https://dev-www.libreoffice.org/src/openssl-3.0.18.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/liborcus-0.20.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libpagemaker-0.0.4.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/pdfium-7012.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/pixman-0.42.2.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libpng-1.6.53.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/tiff-4.7.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/poppler-25.11.0.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/poppler-data-0.4.12.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/postgresql-15.15.tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/Python-3.11.14.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/python.3.12.8.nupkg ; curl -O  https://dev-www.libreoffice.org/src/libqxp-0.0.2.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/raptor2-2.0.16.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/1f5def51ca0026cd192958ef07228b52-rasqal-0.9.33.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/e5be03eda13ef68aabab6e42aa67715e-redland-1.0.17.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/librevenge-0.0.$(REVENGE_VERSION_MICRO).tar.bz2 ; curl -O  https://dev-www.libreoffice.org/src/rhino-1.7.15.1.zip ; curl -O  https://dev-www.libreoffice.org/src/skia-m136-28685d899b0a35894743e2cedad4c9f525e90e1e.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libstaroffice-0.0.$(STAROFFICE_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/twaindsm_2.4.1.orig.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libvisio-0.1.10.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libwpd-0.10.$(WPD_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libwpg-0.3.$(WPG_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/libwps-0.4.$(WPS_VERSION_MICRO).tar.xz ; curl -O  https://dev-www.libreoffice.org/src/a7983f859eafb2677d7ff386a023bc40-xsltml_2.1.2.zip ; curl -O  https://dev-www.libreoffice.org/src/zlib-1.3.1.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/zstd-1.5.7.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/libzmf-0.0.2.tar.xz ; curl -O  https://dev-www.libreoffice.org/src/zxcvbn-c-2.6.tar.gz ; curl -O  https://dev-www.libreoffice.org/src/zxing-cpp-2.3.0.tar.gz


    

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
