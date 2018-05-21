FROM yi/tflow-gui:latest
 
MAINTAINER Igor Rabkin <igor.rabkin@xiaoyi.com>

ARG TFLOW=tensorflow-1.8.0-cp36-cp36m-linux_x86_64.whl

#################################################
#     Python 3.6 installations for dev          #
#################################################

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.6 get-pip.py && \
    rm get-pip.py 

RUN add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get update && apt-get install -y --no-install-recommends \
    python3.6 \
    python3.6-dev \
    python3.6-venv \
    && \ 
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*
	
RUN ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/local/bin/pip /usr/local/bin/pip3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python	
   
   
################################################################## 
#              Pick up some TF dependencies                      #
##################################################################

RUN apt-get update && apt-get install -y --no-install-recommends \ 		 
         libfreetype6-dev \
         libpng12-dev \ 
         libzmq3-dev \
         libcurl3-dev \
         libgoogle-perftools-dev \		 
         pkg-config \  
         python3-tk \
         && \ 
     apt-get clean && \ 
     rm -rf /var/lib/apt/lists/*  
 
 
RUN python3.6 -m pip --no-cache-dir install \ 
        Pillow \
        toposort \
        networkx \
        pytest \
        h5py \
        ipykernel \
        jupyter \
        matplotlib \
        numpy \
        pandas \
        scipy \
        sklearn \
        tensorlayer \
	scikit-learn \
        tqdm \
        click==6.7 \
        more_itertools \
	utils \
	bs4 \
	opencv-python \
	python3-utils \
	scikit-image \
	xmltodict \
        easydict \
	urllib3==1.21.1 \
        && \
    python3.6 -m ipykernel.kernelspec \
	      && \
    apt-get clean && \ 
    rm -rf /var/lib/apt/lists/*
	
	
###################################
# Install TensorFlow GPU version. #
###################################

  RUN cd /
  ARG CRED="server:123server123"
  RUN  curl -u ${CRED} ftp://yifileserver/DOCKER_IMAGES/Tensorflow/Tensorflow-1.8.0-9.0-cudnn7-devel-ubuntu16.04-Server_19.20/${TFLOW} -o ${TFLOW} && \
      pip --no-cache-dir install --upgrade /${TFLOW} && \
      rm -f /${TFLOW}   

  
##################################################
# Configure the build for our CUDA configuration #
##################################################

ENV CI_BUILD_PYTHON python
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV TF_NEED_CUDA 1
ENV TF_CUDA_COMPUTE_CAPABILITIES=5.2,6.1
ENV TF_CUDA_VERSION=9.0
ENV TF_CUDNN_VERSION=7
 
################ INTEL MKL SUPPORT #################

ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
RUN cd /usr/local/lib && \
    curl -u ${CRED} ftp://yifileserver/IT/YiIT/lib/libiomp5.so -o libiomp5.so && \
    curl -u ${CRED} ftp://yifileserver/IT/YiIT/lib/libmklml_gnu.so -o libmklml_gnu.so && \
    curl -u ${CRED} ftp://yifileserver/IT/YiIT/lib/libmklml_intel.so -o libmklml_intel.so
    
####################################################
