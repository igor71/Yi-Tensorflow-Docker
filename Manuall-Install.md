### Clone Repositoy:

 ```
git clone --branch=r1.1X-OpenVINO --depth=1 https://github.com/igor71/Yi-Tensorflow-Docker 

cd Yi-Tensorflow-Docker

```

### Build the docker:

 ```
docker build -f Dockerfile-OpenVINO-Base -t yi/openvino:1.144 .

 ```
 ### Running docker container:
 
 ```
 docker run -it -d  --name openvino -v /media:/media yi/openvino:1.144
 
 yi-dockeradmin openvino_base
 
 ```
 
 ### Running tests as root inside docker container:
 
 ```
 cd /opt/intel/openvino/deployment_tools/demo

./demo_squeezenet_download_convert_run.sh

```

### Running test as non-root user inside docker container:

```
su openvino

cd /tmp

source /tmp/setupvars.sh

cp -R /media/common/USERS/Sagi/OpenVINO .

cd OpenVINO/

python ssh_v2_VINO.py

```


 
