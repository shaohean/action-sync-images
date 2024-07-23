
#FROM continuumio/anaconda3:2024.06-1
#RUN pip install git+https://github.com/amazon-science/chronos-forecasting.git

FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubi8
RUN rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo && yum clean all && yum makecache  &&  yum install -y wget libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver git &&  yum clean all && wget  https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O anaconda.sh  -q && /bin/bash anaconda.sh -b -p /opt/conda  &&  rm anaconda.sh  && ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh &&  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && echo "conda activate base" >> ~/.bashrc && find /opt/conda/ -follow -type f -name '*.a' -delete && find /opt/conda/ -follow -type f -name '*.js.map' -delete && /opt/conda/bin/conda clean -afy && conda config --set auto_activate_base True && source ~/.bashrc && conda init bash --quiet  &&  pip install git+https://github.com/amazon-science/chronos-forecasting.git 
