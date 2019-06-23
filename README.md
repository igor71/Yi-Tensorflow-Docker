# Yi-Tensorflow-Docker

Build Graph Transform Tool inside relevant tflow-build docker container

### HOW-To
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
     yi/tflow-build:0.6-python-v.3.6.3 -->> for tflow version 1.5-1.9 & python 3.6

     yi/tflow-build:0.6 -->> for tflow version 1.5-1.9 & python 2.7
          
     yi/tflow-build:0.7-python-v.3.6.3 -->> for tflow version 1.10 & python 3.6
          
     yi/tflow-build:0.7 -->> for tflow version 1.10 & python 2.7
          
     yi/tflow-build:0.8-python-v.3.6.3 -->> for tflow version 1.11 - 1.13 & python 3.6
          
     yi/tflow-build:0.8 -->> for tflow version 1.11 -1.13 & python 2.7
          
     yi/tflow-build:0.9-python-v.3.6 -->> for tflow version 2.0 & Ubuntu 16.04.6 with python 3.6.8
          
     yi/tflow-build:1.0-python-v.3.6 -->> for tflow version 2.0 & Ubuntu 18.04.2 with python 3.6.8
          
     yi/tflow-build:1.1-python-v.3.6 -->> for tflow version 1.13 with CUDA 10.0 & Ubuntu 16.04.6/18.04.2 with python 3.6.8
          
     yi/tflow-build:1.2-python-v.3.6 -->> for tflow version 1.14 with CUDA 10.0 & Ubuntu 16.04.6/18.04.2 with python 3.6.8
     
     ########################## Load Docker Image ########################################################################
     
     pv /media/common/DOCKER_IMAGES/TFlow-Build/yi-tflow-build-ssh-X.X-python-v.3.6.X.tar | docker load
     
     docker images
      
     docker tag <Image ID> yi/tflow-build:X.X-python-v.3.6
     
     ######################### Running Docker Container ##################################################################
     
     nvidia-docker run -d -p 37001:22 --name gtt_build -v /media:/media yi/tflow-build:X.X-python-v.3.6 -->> Ubuntu-16
     
     docker run --runtime=nvidia -d -p 37001:22 --name gtt_build -v /media:/media yi/tflow-build:X.X-python-v.3.6 -->> Ubuntu-18
     
     yi-dockeradmin gtt_build
     
     ####################### Installing Desired Tensorflow Version #######################################################
     
     INSTALL_DIR=/media/common/DOCKER_IMAGES/Tensorflow/Tensorflow-1.3.1-8.0-cudnn5-devel-ubuntu14.04-Server_8.9
     
     cd pip --no-cache-dir install --upgrade ${INSTALL_DIR}/tensorflow-1*.whl
     
     ###################### Building Graph Transform Tool #################################################################
     
     cd /
     
     rm build_tf_package.sh tflow-build.sh
     
     git clone --branch=Graph-Transform-Tool --depth=1 https://github.com/igor71/Yi-Tensorflow-Docker
    
     cp /Yi-Tensorflow-Docker/build_Graph-Transform-Tool.sh ..
     
     cp /Yi-Tensorflow-Docker/tflow-build.sh ..
     
     rm -rf Yi-Tensorflow-Docker
     
     bash tflow-build.sh
     
     ```
     
  4. Checking installed tensorflow (and his components) version:
     ```
     python -c 'import h5py; print(h5py.version.info)'
    
     python -c 'import tensorflow as tf; print(tf.__version__)'
     
     python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"
     
     ```
 
