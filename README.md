# Yi-Tensorflow-Docker

### Basic Image with  CUDA 10

```
Build yi/tflow-vnc:X.X.X-python-3.6-pytorch Image

Ubuntu Version  -->> Ubuntu 18.04.2 LTS

docker inspect -f '{{index .Config.Labels "com.nvidia.cuda.version"}}' 0a1b1a956cdb

CUDA Version   -->> 10.0.130

docker inspect -f '{{index .Config.Labels "com.nvidia.cudnn.version"}}' 0a1b1a956cdb

CUDNN Version  -->> 7.5.0.56
```

### Basic Image with  CUDA 9.0

```
Build yi/tflow-vnc:X.X.X-python-3.6-pytorch Image

Ubuntu Version  -->> Ubuntu 16.04.6 LTS

docker inspect -f '{{index .Config.Labels "com.nvidia.cuda.version"}}' bdccc25c5e3d

CUDA Version   -->> 9.0.176

docker inspect -f '{{index .Config.Labels "com.nvidia.cudnn.version"}}' bdccc25c5e3d

CUDNN Version  -->> 7.4.1.5
```

### HOW-To

*Before running build job on Jenkis, please make following changes:*
 
 a. *Change Jenknins filename to Jenkinsfile accordind to desired basic docker image will be used for build
    (CUDA 10 or CUDA 9.0)*
    
 b. *Make appropriate changes inside the Docker file that will be used in build proccess (CUDA & CUDNN ENV)* 
   

1. Check if desired version of tensorflow is available for target server
   ```
   cd /media/common/DOCKER_IMAGES/Tensorflow/Develop/
   python search_packages.py
   Server # (example: 18): 3
   Python version # (2.7 or 3.6): 2.7
   ```
   The output will be in following format:
   ```
   Tensorflow: 1.4.0, Cuda: 8.0, Cudnn: cudnn6
   Tensorflow: 1.9.0, Cuda: 9.0, Cudnn: cudnn7
   Tensorflow: 1.3.1, Cuda: 8.0, Cudnn: cudnn5
   Tensorflow: 1.8.0, Cuda: 9.0, Cudnn: cudnn7
   ```
   Meaning for server-3 and python 2.7 available tensorflow version: 1.3.1, 1.4.0, 1.8.0, & 1.9.0

2. After verifing desired tensorflow version exist, open in chrome browser:

   http://jenkins-cloud:8080/jenkins/job/Build-Yi-Tflow-VNC-Docker-Image/
   
   And click on "Build with Paramerers"
  
   Chose desired options from drop down menus as following

   target_server --->> server where you need yi\tflow-vnc docker
  
   python_version --->> python version for above docker image
  
   tensorflow_version --->> desired tensorflow version
  
   And finally, click on "BUILD" button
  
  3. Once build completed, run the docker as foolwing:
  
     ```
     yi-docker tflow-vnc run :<port_number> --version=x.x.x-python-3.6    -->> based on python 3.6.8
     yi-docker tflow-vnc run :<port_number> --version=x.x.x-python-2.7    -->> based on python 2.7.12
     ```
     where x.x.x is tensorflow version, e.g. 1.8.0 or 1.4.1... etc
  
  4. Checking installed torch (and his components) version:
     ```
     python -c 'import h5py; print(h5py.version.info)'  -->> python 3.6.8
   
     python -c "import torch; print(torch.__version__)"
     ```
 
