#FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubi8
#RUN rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo && yum clean all && yum makecache  &&  yum install -y wget libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver git &&  yum clean all && wget  https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O anaconda.sh  -q && /bin/bash anaconda.sh -b -p /opt/conda  &&  rm anaconda.sh  && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh &&  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && echo "conda activate base" >> ~/.bashrc && echo "export PATH="/opt/conda/bin:$PATH"" >> ~/.bashrc && ls -lh /opt/conda/etc/profile.d/conda.sh /opt/conda  && source ~/.bashrc && find /opt/conda/ -follow -type f -name '*.a' -delete && find /opt/conda/ -follow -type f -name '*.js.map' -delete && /opt/conda/bin/conda clean -afy && conda config --set auto_activate_base True  && conda init bash --quiet  &&  pip install git+https://github.com/amazon-science/chronos-forecasting.git 
#FROM alpine
#RUN  apt update;apt install -y curl && curl -ikv  -o harbor.tar.gz https://objects.githubusercontent.com/github-production-release-asset-2e65be/50613991/dc6c4622-1b12-4f1b-9ead-b0c0cda51ad2?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20240726%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240726T084646Z&X-Amz-Expires=300&X-Amz-Signature=3b91fce1d166437d191c9844ae300cb324b5eaacd40fc8c7b8f4151866c5c9d8&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=50613991&response-content-disposition=attachment%3B%20filename%3Dharbor-offline-installer-v2.10.3.tgz&response-content-type=application%2Foctet-stream
FROM golang:1.22.6-alpine3.20 AS Builder

RUN sed -i 's/https:\/\/dl-cdn.alpinelinux.org/http:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apk/repositories && \
    echo "Asia/Shanghai" > /etc/timezone

RUN apk add build-base && \
    go env -w GO111MODULE=on && \
    go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct

ENV DRONE_VERSION 2.24.0

WORKDIR /src

# Build with online code
RUN apk add curl && curl -L https://github.com/drone/drone/archive/refs/tags/v${DRONE_VERSION}.tar.gz -o v${DRONE_VERSION}.tar.gz && \
    tar zxvf v${DRONE_VERSION}.tar.gz && rm v${DRONE_VERSION}.tar.gz
# OR with offline tarball
# ADD drone-1.10.1.tar.gz /src/

WORKDIR /src/drone-${DRONE_VERSION}

RUN go mod download

ENV CGO_CFLAGS="-g -O2 -Wno-return-local-addr"

RUN go build -ldflags "-extldflags \"-static\"" -tags="nolimit" github.com/drone/drone/cmd/drone-server



FROM alpine:3.19 AS Certs
RUN sed -i 's/https:\/\/dl-cdn.alpinelinux.org/http:\/\/mirrors.tuna.tsinghua.edu.cn/' /etc/apk/repositories && \
    echo "Asia/Shanghai" > /etc/timezone
RUN apk add -U --no-cache ca-certificates



FROM alpine:3.19
EXPOSE 80 443
VOLUME /data

RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

ENV GODEBUG netdns=go
ENV XDG_CACHE_HOME /data
ENV DRONE_DATABASE_DRIVER sqlite3
ENV DRONE_DATABASE_DATASOURCE /data/database.sqlite
ENV DRONE_RUNNER_OS=linux
ENV DRONE_RUNNER_ARCH=amd64
ENV DRONE_SERVER_PORT=:80
ENV DRONE_SERVER_HOST=localhost
ENV DRONE_DATADOG_ENABLED=true
ENV DRONE_DATADOG_ENDPOINT=https://stats.drone.ci/api/v1/series

COPY --from=Certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=Builder /src/drone-2.24.0/drone-server /bin/drone-server
ENTRYPOINT ["/bin/drone-server"]
