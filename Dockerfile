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

FROM maven
RUN /bin/bash -c "apt update && apt install -q -y rpm yarn nodejs npm curl python && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | tee /etc/apt/trusted.gpg.d/yarn.asc  && echo \"deb https://dl.yarnpkg.com/debian/ stable main\" | tee /etc/apt/sources.list.d/yarn.list && apt update && apt install -q -y yarn openjdk-8-jdk && rm -rf /opt/java/openjdk  && cp -a /usr/lib/jvm/java-8-openjdk-amd64 /opt/java/openjdk && wget -q https://www-eu.apache.org/dist/ambari/ambari-2.7.8/apache-ambari-2.7.8-src.tar.gz && tar xfz apache-ambari-2.7.8-src.tar.gz && cd apache-ambari-2.7.8-src && mvn -q versions:set -DnewVersion=2.7.8.0.0 && pushd ambari-metrics && mvn -q versions:set -DnewVersion=2.7.8.0.0 && popd && mvn -B clean install rpm:rpm -DnewVersion=2.7.8.0.0 -DbuildNumber=da8f1b9b5a799bfa8e2d8aa9ab31d6d5a1cc31a0 -DskipTests -Dpython.ver=\"python >= 2.6\""

