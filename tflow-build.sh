#!/bin/bash

# Manually build Graph Transform Tool from the sources 

TF_BRANCH=r1.13

cd /

git clone --branch=${TF_BRANCH} --depth=1 https://github.com/tensorflow/tensorflow.git

cd tensorflow

git checkout ${TF_BRANCH}

updatedb

cd /

cp build_Graph-Transform-Tool.sh /tensorflow/build_GTT_package.sh

cd tensorflow

/bin/bash build_GTT_package.sh
