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
     yi-docker tflow-vnc run :<port_number> --version=x.x.x-python-3.6
     
     yi-dockeradmin horovod
     
     cd /tmp
     
     horovodrun -np 4 -H localhost:4 python keras_mnist_advanced.py -->> single server check
     
     In order to suppress Read -1 stderr error when using horovodrun, use folowing command:
     
     CUDA_VISIBLE_DEVICES=0,1 horovodrun -np 2 -H localhost:2 python keras_mnist_advanced.py | & grep -v "Read -1"
     
     Above command will tun on two GPU's (ID 0 & 1) and suppress Read -1 stderr error
     
     ```
  
  4. Checking installed tensorflow (and his components) version:
     ```
     python -c 'import h5py; print(h5py.version.info)' 
  
     python -c 'import tensorflow as tf; print(tf.__version__)'
   
     python -c "import tensorflow as tf; print(tf.contrib.eager.num_gpus())"
     
     ```
  5. Horovod Building Options:
  
     ```
     bdist_wheel ---> will build you a wheel file on that can be installed on a server with exactly the same build flags (e.g.
     HOROVOD_GPU_ALLREDUCE) and version of TensorFlow, MPI, CUDA, and NCCL as the server you built the wheel on.
     
     sdist -->> provides source tarball that you can install on a target server with build flags and versions of dependencies available
     on the server that you're installing the tarball.
     ```
     Reference: https://github.com/horovod/horovod/issues/155
     
  6. Specify running on a specific GPU:
     
     This is something that's actually not controlled by mpirun, but within your code. The mpirun command is just specifying how many
     "ranks" (processes) to execute on each node, not which GPUs to use.
     
     The GPU assignment happens somewhere in your training script train.py with a line like this (typically):
     ```
     config = tf.ConfigProto()
     config.gpu_options.visible_device_list = str(hvd.local_rank())
     ```
     `hvd.local_rank()` says "use GPU with the same ID as the local rank", but you can in fact set the visible device list to be
     whatever you want. For example, to achieve what you're trying to do, you can explicitly map individual ranks to devices, like:
     ```
     device_map = {
     0: 0,
     1: 2,
     2: 1,
     3: 2
     }
     config = tf.ConfigProto()
     config.gpu_options.visible_device_list = str(device_map[hvd.rank()])
     ```
     Reference: https://github.com/horovod/horovod/issues/572
  
