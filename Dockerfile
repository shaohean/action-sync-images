FROM registry.cn-hongkong.aliyuncs.com/soft24/python:3.10
RUN pip install  --no-cache-dir git+https://github.com/amazon-science/chronos-forecasting.git
