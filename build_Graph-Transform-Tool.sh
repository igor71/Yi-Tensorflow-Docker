#! /bin/bash

############################################################################
# Configure the build for Graph Transform Tool by accepting default build  #
# and setting library locations options                                    #
############################################################################

export CI_BUILD_PYTHON=python PYTHON_BIN_PATH=/usr/local/bin/python

export PYTHON_LIB_PATH=/usr/local/lib/python3.6/site-packages

export TF_CUDA_VERSION=9.0 TF_CUDNN_VERSION=7

export TF_NEED_CUDA=1 TF_CUDA_COMPUTE_CAPABILITIES=5.2,6.1,7.0

export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/nvidia/lib64:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64/stubs

no |./configure

######################################################################################################################
# Build and use Graph Transform Tool. The Graph Transform tool is designed to work on models that                    #
# are saved as GraphDef files, usually in a binary protobuf format. This is the low-level definition                 #
# of a TensorFlow computational graph, including a list of nodes and the input and output connections                #
# between them. If you're using a Python API to train your model, this will usually be saved out in the              #
# same directory as your checkpoints, and usually has a '.pb' suffix.                                                #
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/graph_transforms/README.md#inspecting-graphs #
# ####################################################################################################################

cpu_info=$(cat /proc/cpuinfo | grep 'model name' | uniq)
   if [[ $cpu_info == *"E5-2650"* ]] || [[ $cpu_info == *"E5-2698"* ]] ; then
      CPU=$( echo $cpu_info |cut -d' ' -f7)
   else
      CPU=$( echo $cpu_info |cut -d' ' -f6)
   fi

   case $CPU in
        i5-6500|i7-5960X|i7-6900K|i7-6950X)
           echo "Building Graph Transform Tool Package For $CPU"
           INSTALL_DIR=/whl
           HOME=/home/jenkins
           bazel build //tensorflow/tools/graph_transforms:transform_graph && \
           mkdir ${INSTALL_DIR}
                ;;

	i9-7940X)
           echo "Building Tensorflow Package For $CPU"
           INSTALL_DIR=/whl
           HOME=/home/jenkins
            bazel build //tensorflow/tools/graph_transforms:transform_graph && \
            mkdir ${INSTALL_DIR}
                ;;

        E5-2650|E5-2698)
           echo "Building Tensorflow Package For $CPU"
           INSTALL_DIR=/whl
           HOME=/home/jenkins
            bazel build //tensorflow/tools/graph_transforms:transform_graph && \
            mkdir ${INSTALL_DIR}

                break
                ;;
		        *)
           echo "No Configuration File Set For $CPU"
                ;;
  esac

#######################################################################
#    Archive Graph Transform Tool package & copy to network share     #
#######################################################################

cd /tensorflow/bazel-bin/tensorflow/tools

PACKAGE_DIR=graph_transforms

if [ -d "$PACKAGE_DIR" ]; then tar cpzf - ${PACKAGE_DIR} -P | pv -s $(du -sb ${PACKAGE_DIR} | awk '{print $1}') > ${INSTALL_DIR}/${PACKAGE_DIR}.tar.gz; fi

pv -f ${INSTALL_DIR}/${PACKAGE_DIR}.tar.gz > $HOME/${PACKAGE_DIR}.tar.gz

cd ${HOME}

ls -lh ${INSTALL_DIR}
     if [ "$?" != "0" ]; then
          echo "There is no Graph Transform Tool package in $HOME dir!!!"
          exit -1
     fi

echo "All Done!!! Look for Graph Transform Tool whl package at ${PACKAGE_DIR}"
