### Build OpenCV from source with Intel's Deep Learning Inference Engine backend support inside Docker Container

 ```
 pv /media/common/DOCKER_IMAGES/OpenVINO/yi-inference-engine-base.tar | docker load
 docker tag 4ec5f665499d yi/inference-engine:base
 docker run -it -d --name inference_engine -v /media:/media yi/inference-engine:base
 yi-dockeradmin inference_engine
 
 mkdir opencv-python-inference-engine && cd opencv-python-inference-engine
 mkdir dldt opencv build
 mkdir -p build/dldt
 mkdir -p build/opencv
 
wget -P $PWD/dldt https://github.com/opencv/dldt/archive/2019_R1.1.tar.gz
pv dldt/2019_R1.1.tar.gz | tar xpzf - -C $PWD/dldt
shopt -s dotglob # Includes filenames beginning with a dot.
mv -- dldt/dldt-2019_R1.1/* dldt/
rm -rf dldt/dldt-2019_R1.1 && rm -f dldt/2019_R1.1.tar.gz

wget -P $PWD/opencv https://github.com/opencv/opencv/archive/4.1.0.tar.gz
pv opencv/4.1.0.tar.gz  | tar xpzf - -C $PWD/opencv
mv -- opencv/opencv-4.1.0/* opencv/
rm -f opencv/4.1.0.tar.gz && rm -rf opencv/opencv-4.1.0

cd dldt/inference-engine/thirdparty/ade
git clone https://github.com/opencv/ade/ ./
git reset --hard 562e301


cd ../../../../build/dldt
sed -i '/add_subdirectory(tests)/s/^/#/g' ../../dldt/inference-engine/CMakeLists.txt
curl -OSL ftp://jenkins-cloud/pub/Tflow-VNC-Soft/OpenVINO/dldt_setup.sh -o $PWD/dldt_setup.sh
bash dldt_setup.sh
make --jobs=$(nproc --all)

cd ../opencv
curl -OSL ftp://jenkins-cloud/pub/Tflow-VNC-Soft/OpenVINO/opencv_setup.sh -o $PWD/opencv_setup.sh
chmod u+x opencv_setup.sh
ABS_PORTION=/opencv-python-inference-engine ./opencv_setup.sh
make --jobs=$(nproc --all)

cd ..
cp -R /media/common/DOCKER_IMAGES/Tensorflow/Tflow-VNC-Soft/OpenVINO/create_wheel/ .
cp build/opencv/lib/python3/cv2.cpython*.so create_wheel/cv2/cv2.so

cp dldt/inference-engine/bin/intel64/Release/lib/*.so create_wheel/cv2/
cp dldt/inference-engine/bin/intel64/Release/lib/*.mvcmd create_wheel/cv2/
cp dldt/inference-engine/temp/tbb/lib/libtbb.so.2 create_wheel/cv2/

chrpath -r '$ORIGIN' create_wheel/cv2/cv2.so
cd create_wheel
python setup.py bdist_wheel

python /media/common/DOCKER_IMAGES/Tensorflow/Tflow-VNC-Soft/OpenVINO/TEST/foo.py
``` 


### Reference:
https://github.com/opencv/opencv/wiki/Intel's-Deep-Learning-Inference-Engine-backend
https://github.com/banderlog/opencv-python-inference-engine
