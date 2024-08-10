#FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubi8
#RUN rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo && yum clean all && yum makecache  &&  yum install -y wget libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver git &&  yum clean all && wget  https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O anaconda.sh  -q && /bin/bash anaconda.sh -b -p /opt/conda  &&  rm anaconda.sh  && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh &&  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && echo "conda activate base" >> ~/.bashrc && echo "export PATH="/opt/conda/bin:$PATH"" >> ~/.bashrc && ls -lh /opt/conda/etc/profile.d/conda.sh /opt/conda  && source ~/.bashrc && find /opt/conda/ -follow -type f -name '*.a' -delete && find /opt/conda/ -follow -type f -name '*.js.map' -delete && /opt/conda/bin/conda clean -afy && conda config --set auto_activate_base True  && conda init bash --quiet  &&  pip install git+https://github.com/amazon-science/chronos-forecasting.git 
#FROM alpine
#RUN  apt update;apt install -y curl && curl -ikv  -o harbor.tar.gz https://objects.githubusercontent.com/github-production-release-asset-2e65be/50613991/dc6c4622-1b12-4f1b-9ead-b0c0cda51ad2?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20240726%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240726T084646Z&X-Amz-Expires=300&X-Amz-Signature=3b91fce1d166437d191c9844ae300cb324b5eaacd40fc8c7b8f4151866c5c9d8&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=50613991&response-content-disposition=attachment%3B%20filename%3Dharbor-offline-installer-v2.10.3.tgz&response-content-type=application%2Foctet-stream
FROM alpine:3.19
RUN apk add go && apk add curl && curl -LOk  https://github.com/harness/gitness/archive/refs/tags/v2.24.0.tar.gz && tar -xf v2.24.0.tar.gz &&go env |grep -i cgo && cd gitness-2.24.0/scripts/ && sh build.sh 
