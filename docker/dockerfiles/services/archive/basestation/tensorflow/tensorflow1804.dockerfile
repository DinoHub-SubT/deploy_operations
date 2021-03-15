# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# #==========================================================================
# other examples found here? https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile

# cuda 9.0 ->   9.0-ubuntu18.04-devel
# cuda 10.0 ->  10.0-ubuntu18.04-devel
# ARG CUDA_VERSION=10.0-ubuntu18.04-devel
# FROM subt/tensorflow-cuda:$CUDA_VERSION
FROM subt/cuda-9:0.1

# Install apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install wget (to make life easier below) and editors (to allow people to edit
# the files inside the container)
RUN apt-get update && \
    apt-get install -y wget vim emacs nano git python-pip sudo

# Get the tensorflow models research directory, and move it into tensorflow
# source folder to match recommendation of installation
RUN git clone --depth 1 https://github.com/tensorflow/models.git /tensorflow/models && \
    ls /

# Install the latest version
# cuda 9.0  -> 1.12.0
ARG TENSORFLOW_VERSION=1.12.0
RUN pip install tensorflow-gpu==$TENSORFLOW_VERSION

RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update \
 && sudo -E apt-get install -y \
   tzdata \
 && sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean

# Install the Tensorflow Object Detection API from here
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md

# Install object detection api dependencies
RUN apt-get update && \
    apt-get install -y protobuf-compiler python-pil python-lxml python-tk python-setuptools && \
    pip install --upgrade numpy && \
    pip install --upgrade Cython && \
    pip install --upgrade contextlib2 && \
    pip install --upgrade jupyter && \
    pip install --upgrade matplotlib && \
    pip install opencv-python

# Install pycocoapi
RUN git clone --depth 1 https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    make -j8 && \
    cp -r pycocotools /tensorflow/models/research && \
    cd ../../ && \
    rm -rf cocoapi

# Get protoc 3.0.0, rather than the old version already in the container
RUN curl -OL "https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip" && \
    unzip protoc-3.0.0-linux-x86_64.zip -d proto3 && \
    mv proto3/bin/* /usr/local/bin && \
    mv proto3/include/* /usr/local/include && \
    rm -rf proto3 protoc-3.0.0-linux-x86_64.zip

# Run protoc on the object detection repo
RUN cd /tensorflow/models/research && \
    protoc object_detection/protos/*.proto --python_out=.

# Set the PYTHONPATH to finish installing the API
ENV PYTHONPATH $PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim

# Set the cuda library path
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/cuda-10.0/compat:/usr/local/cuda-10.0/lib64

# //////////////////////////////////////////////////////////////////////////////
# minor additions to the default tensorflow dockerfile below:

# add a developer user
ARG user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
  && echo "$USERNAME:$USERNAME" | chpasswd \
  && adduser $USERNAME sudo \
  && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# commands below run as the developer user
USER $USERNAME

# create a ssh directory
RUN mkdir /home/$USERNAME/.ssh

# install libcudnn & nvinfer from 16.04 binaries
RUN mkdir -p /home/$USERNAME/thirdparty/nvidia
# must be on context path when building
COPY perception/nv-tensorrt-repo-ubuntu1604-cuda9.0-ga-trt4.0.1.6-20180612_1-1_amd64.deb /home/$USERNAME/thirdparty/nvidia
RUN cd /home/$USERNAME/thirdparty/nvidia/ \
 && sudo dpkg -i nv-tensorrt-repo-ubuntu1604-cuda9.0-ga-trt4.0.1.6-20180612_1-1_amd64.deb \
 && cd /var/nv-tensorrt-repo-cuda9.0-ga-trt4.0.1.6-20180612 \
 && sudo dpkg -i libcudnn7_7.1.3.16-1+cuda9.0_amd64.deb \
 && sudo dpkg -i libcudnn7-dev_7.1.3.16-1+cuda9.0_amd64.deb \
 && sudo dpkg -i libnvinfer4_4.1.2-1+cuda9.0_amd64.deb \
 && sudo apt --fix-broken install -y \
 && sudo apt-get clean

# use developer directory
WORKDIR /home/$USERNAME/

# entrypoint command
CMD /bin/bash
