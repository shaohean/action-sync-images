#FROM continuumio/anaconda3:2024.06-1
#RUN pip install git+https://github.com/amazon-science/chronos-forecasting.git

FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubi8
RUN apt update && apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6 && wget https://repo.anaconda.com/anaconda/Anaconda3-2024.06-1-Linux-x86_64.sh -O ~/anaconda.sh && bash ~/anaconda.sh -b -p $HOME/anaconda && conda config --set auto_activate_base True  && conda init && pip install git+https://github.com/amazon-science/chronos-forecasting.git 
