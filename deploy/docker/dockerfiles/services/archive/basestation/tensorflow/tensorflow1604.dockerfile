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
FROM tensorflow/tensorflow:1.11.0-gpu

# Install apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

# Install wget (to make life easier below) and editors (to allow people to edit
# the files inside the container)
RUN apt-get update && \
    apt-get install -y wget vim emacs nano git sudo


# Get the tensorflow models research directory, and move it into tensorflow
# source folder to match recommendation of installation
RUN git clone --depth 1 https://github.com/tensorflow/models.git /tensorflow/models && \
    ls /

# Install the latest version
RUN pip install tensorflow-gpu==1.12.0

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

# WORKDIR /tensorflow

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

# use developer directory
WORKDIR /home/$USERNAME/

# entrypoint command
CMD /bin/bash
