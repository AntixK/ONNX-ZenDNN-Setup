FROM ubuntu:20.04

# To prevent unnecessary requests from user during the build
ARG DEBIAN_FRONTEND=noninteractive 
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ARG CONDA_VER=latest

RUN apt-get update && \
    apt-get install -y \
    unzip \
    zip \
    curl \
    ca-certificates \
    git \
    wget \
    python3-pip \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# Link python3 and python
RUN ln -sv /usr/bin/python3 /usr/bin/python

WORKDIR /home/zendnn

RUN pip install --no-cache-dir --upgrade pip \
    wheel \
    build \
    setuptools 

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 

RUN mkdir /home/deps/
COPY lib/PT_v1.9.0_ZenDNN_v3.2_Python_v3.9.zip /home/deps/PT_v1.9.0_ZenDNN_v3.2_Python_v3.9.zip
COPY lib/aocl-blis-linux-aocc-3.1.0.tar.gz /home/deps/aocl-blis-linux-aocc-3.1.0.tar.gz
COPY lib/aocc-compiler-3.2.0.tar /home/deps/aocc-compiler-3.2.0.tar

RUN unzip /home/deps/PT_v1.9.0_ZenDNN_v3.2_Python_v3.9.zip -d /home/deps/pyzendnn
RUN tar -zxvf /home/deps/aocl-blis-linux-aocc-3.1.0.tar.gz -C /home/deps/
RUN tar -xvf /home/deps/aocc-compiler-3.2.0.tar -C /home/deps

RUN conda --version

