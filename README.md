# Yi-Tensorflow-Docker

Build yi/tflow-vnc:X.X.X Image

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
     On Master Server -22:
     
     nvidia-docker run --network=host --name=horovod -v /media:/media -it -d --privileged yi/tflow-vnc:1.13.1-python-3.6-horovod
     
     On Slave Servers:
     
     nvidia-docker run --network=host --name=horovod -v /media:/media -it -d --privileged yi/tflow-vnc:1.13.1-python-3.6-horovod bash -c "/usr/sbin/sshd -p 12345; sleep infinity"
     
     On Master:
     
     yi-dockeradmin horovod
     
     horovodrun -np 12 -H server-22:8,server-19:4 -p 12345 python keras_mnist_advanced.py
     ```
  
  4. Checking installed tensorflow (and his components) version:
     ```
     python -c 'import h5py; print(h5py.version.info)' 
  
     python -c 'import tensorflow as tf; print(tf.__version__)'
   
     
     python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"
     
     ```
 
