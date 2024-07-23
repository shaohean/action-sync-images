#FROM continuumio/anaconda3:2024.06-1
#RUN pip install git+https://github.com/amazon-science/chronos-forecasting.git

FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubi8
RUN rm -rf /etc/yum.repos.d/* && curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo && yum clean all && yum makecache  &&  yum install -y wget libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver && wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh -O ~/anaconda.sh && bash ~/anaconda.sh -b -p $HOME/anaconda3 && conda init bash --quiet ; source ~/anaconda3/bin/activate && conda activate base ; conda config --set auto_activate_base True  ; pip install git+https://github.com/amazon-science/chronos-forecasting.git 
