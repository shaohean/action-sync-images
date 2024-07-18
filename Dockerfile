FROM continuumio/anaconda3:2024.06-1
RUN pip install git+https://github.com/amazon-science/chronos-forecasting.git
