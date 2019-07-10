### Build OpenCV from source with Intel's Deep Learning Inference Engine backend support inside OpenVINO Docker

 ```
apt-get update

pip uninstall opencv-python

apt-get install -y --no-install-recommends cmake pkg-config xz-utils

wget https://github.com/opencv/opencv/archive/4.1.0.zip -O opencv-4.1.0.zip

wget https://github.com/opencv/opencv_contrib/archive/4.1.0.zip -O opencv_contrib-4.1.0.zip

unzip opencv-4.1.0.zip

unzip opencv_contrib-4.1.0.zip

rm -f opencv-4.1.0.zip opencv_contrib-4.1.0.zip

cd opencv-4.1.0

mkdir opencv_build && cd opencv_build

nano opencv.sh

cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.1.0/modules \
      -D OPENCV_ENABLE_NONFREE=ON \
      -D WITH_IPP=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D OPENCV_ENABLE_PKG_CONFIG=ON \
      -D PYTHON_EXECUTABLE=/usr/local/bin/python3.6 \
      -D WITH_INF_ENGINE=ON \
      -D ENABLE_CXX11=ON ..
	  
bash opencv.sh
	  
make -j$(nproc) 

make install

ldconfig
 ```

### Reference:
https://github.com/opencv/opencv/wiki/Intel's-Deep-Learning-Inference-Engine-backend
