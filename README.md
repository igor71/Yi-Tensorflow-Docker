# Yi-Tensorflow-Docker

Build yi/tflow-vnc:X.X.X Image

Ubuntu Version  -->> Ubuntu 16.04.6 LTS

docker inspect -f '{{index .Config.Labels "com.nvidia.cuda.version"}}' eaf424ee8e35

CUDA Version   -->> 10.1.130

docker inspect -f '{{index .Config.Labels "com.nvidia.cudnn.version"}}' eaf424ee8e35

CUDNN Version  -->> 7.4.1.5

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
     yi-docker tflow-vnc run :<port_number> --version=x.x.x-python-3.6    -->> based on python 3.6.8
     yi-docker tflow-vnc run :<port_number> --version=x.x.x-python-2.7    -->> based on python 2.7.12
     ```
     where x.x.x is tensorflow version, e.g. 1.8.0 or 1.4.1... etc
  
  4. Checking installed tensorflow (and his components) version:
     ```
     python -c 'import h5py; print(h5py.version.info)'  -->> python 3.6.8
   
     python -c "import tensorflow as tf; print(tf.__version__)"
     ```
 
