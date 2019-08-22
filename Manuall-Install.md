### Clone Repositoy:

 ```
git clone --branch=r1.1X-OpenVINO --depth=1 https://github.com/igor71/Yi-Tensorflow-Docker 

cd Yi-Tensorflow-Docker

```

### Build the docker:

 ```
docker build -f Dockerfile-OpenVINO-Base -t yi/openvino:2.275 .

 ```
 ### Running docker container:
 
 ```
 docker run -it -d  --name openvino -v /media:/media yi/openvino:2.275
 
 yi-dockeradmin openvino
 
 ```
 
 ### Running tests as root inside docker container:
 
 ```
 source /opt/intel/openvino/bin/setupvars.sh
 
 cd /opt/intel/openvino/deployment_tools/demo

./demo_squeezenet_download_convert_run.sh

pv /media/common/DOWNLOADS/UBUNTU/OpenVINO/DEMO/squeezenet1.1.xml > /opt/intel/openvino_2019.2.275/deployment_tools/demo/squeezenet1.1.xml

pv /media/common/DOWNLOADS/UBUNTU/OpenVINO/DEMO/squeezenet1.1.bin > /opt/intel/openvino_2019.2.275/deployment_tools/demo/squeezenet1.1.bin

cd /opt/intel/openvino_2019.2.275/deployment_tools/inference_engine/samples/python_samples

python classification_sample/classification_sample.py -m /opt/intel/openvino_2019.2.275/deployment_tools/demo/squeezenet1.1.xml -i /opt/intel/openvino_2019.2.275/deployment_tools/demo/car.png

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

### Reference:

https://software.intel.com/en-us/articles/use-an-inference-engine-api-in-python-to-deploy-the-openvino-toolkit


 
