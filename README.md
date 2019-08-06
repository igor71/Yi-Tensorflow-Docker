# Yi-Horovod-Pytorch

Build yi/horovod:pytorch-python-3.6 Docker Image (NO GUI)

### HOW-TO

2. Open in chrome browser:

   http://jenkins-cloud:8080/jenkins/job/Build-Yi-Tflow-VNC-Docker-Image/
   
   And click on "Build with Paramerers"
  
   Chose desired options from drop down menus as following

   `target_server` --->> server where you need yi/horovod:pytorch-python-3.6 docker image
  
   `python_version` --->> python version for above docker image
  
   `tensorflow_version` --->> desired tensorflow version (if relevant -->> choose desired version)
   
   `cuda_version` --->> desired cuda version
  
   And finally, click on "BUILD" button
  
  3. Once build completed, run the docker as foolwing:
  
     ```
     On Master Server -22:
     
     nvidia-docker run --network=host --name=horovod-pytorch -v /media:/media -it -d --privileged yi/horovod:pytorch-python-3.6
     
     On Slave Servers:
     
     nvidia-docker run --network=host --name=horovod-pytorch -v /media:/media -it -d --privileged yi/horovod:pytorch-python-3.6 bash -c "/usr/sbin/sshd -p 12345; sleep infinity"
     
     On Master:
     
     yi-dockeradmin horovod-pytorch
     
     horovodrun -np 4 -H localhost:4 python keras_mnist_advanced.py -->> single server check
     
     In order to suppress Read -1 stderr error when using horovodrun, use folowing command:
     
     CUDA_VISIBLE_DEVICES=0,1 horovodrun -np 2 -H localhost:2 python keras_mnist_advanced.py |& grep -v "Read -1"
     
     Above command will tun on two GPU's (ID 0 & 1) and suppress Read -1 stderr error
     
     
     horovodrun -np 12 -H server-22:8,server-19:4 -p 12345 python keras_mnist_advanced.py -->> multiple servers check
     ```
  
  4. Checking installed Pytorch & Horovod (and their components) version:
     ```
     python -c 'import h5py; print(h5py.version.info)' 
  
     python -c 'import torch as th; print(th.__version__)'
     
     python -c 'import horovod as hd; print(hd.__version__)'
     
     python -c 'import torch; print(torch.cuda.nccl.version())'
     
     Get cuDNN & NCCL version:
     
     locate cudnn | grep "libcudnn.so." | tail -n1 | sed -r 's/^.*\.so\.//'
     
     locate nccl| grep "libnccl.so" | tail -n1 | sed -r 's/^.*\.so\.//'
      
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
     
     
