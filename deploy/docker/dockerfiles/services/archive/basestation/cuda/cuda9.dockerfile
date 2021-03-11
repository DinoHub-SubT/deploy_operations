# //////////////////////////////////////////////////////////////////////////////
# cuda 9.0, ubuntu 18.04 -- version: 0.1 devel
# //////////////////////////////////////////////////////////////////////////////
FROM ubuntu:18.04
LABEL maintainer "NVIDIA CORPORATION <cudatools@nvidia.com>"

# //////////////////////////////////////////////////////////////////////////////
# install cuda
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates lsb-core && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl

ENV CUDA_VERSION 9.0.176
ENV CUDA_PKG_VERSION 9-0=$CUDA_VERSION-1
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  cuda-cudart-$CUDA_PKG_VERSION \
 && ln -s cuda-9.0 /usr/local/cuda

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="${CUDA_VERSION}"

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.0"

# //////////////////////////////////////////////////////////////////////////////
# runtime
ENV NCCL_VERSION 2.4.2
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  cuda-libraries-$CUDA_PKG_VERSION \
  cuda-cublas-9-0=9.0.176.4-1 \
  libnccl2=$NCCL_VERSION-1+cuda9.0 \
 && apt-mark hold libnccl2

# //////////////////////////////////////////////////////////////////////////////
#  cudnn7
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  libcudnn7 \
  libcudnn7-dev \
 && rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# devel
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
  cuda-libraries-dev-$CUDA_PKG_VERSION \
  cuda-nvml-dev-$CUDA_PKG_VERSION \
  cuda-minimal-build-$CUDA_PKG_VERSION \
  cuda-command-line-tools-$CUDA_PKG_VERSION \
  cuda-core-9-0=9.0.176.3-1 \
  cuda-cublas-dev-9-0=9.0.176.4-1 \
  libnccl-dev=$NCCL_VERSION-1+cuda9.0 \
 && rm -rf /var/lib/apt/lists/*
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# //////////////////////////////////////////////////////////////////////////////
# install samples
ARG SM_ARC="50 60"
RUN apt-get update \
 && apt-get install git -y \
 && cd /usr/local/cuda \
 && git clone https://github.com/NVIDIA/cuda-samples.git \
 && cd /usr/local/cuda/cuda-samples/Samples/deviceQuery \
 && make SMS="${SM_ARC}"

# //////////////////////////////////////////////////////////////////////////////
# install python packages

# Needed for string substitution 
SHELL ["/bin/bash", "-c"]
RUN apt-get update \
 && apt-get install -y --no-install-recommends --allow-downgrades \
  libcurl3-dev \
  libfreetype6-dev \
  libhdf5-serial-dev \
  libzmq3-dev \
  pkg-config \
  rsync \
  software-properties-common \
  unzip \
  zip \
  zlib1g-dev \
  wget \
  git \
  sudo 

# installs cuda10?
# RUN apt-get update \
#  && apt-get install libnvinfer5 -y \
#  && sudo ln -s /usr/lib/x86_64-linux-gnu/libnvinfer.so.5 /usr/lib/x86_64-linux-gnu/libnvinfer.so.4 \
#  && apt-get clean

# Configure the build for our CUDA configuration.
ENV CI_BUILD_PYTHON python
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH
ENV TF_NEED_CUDA 1
ENV TF_NEED_TENSORRT 1
ENV TF_CUDA_COMPUTE_CAPABILITIES=3.5,5.2,6.0,6.1,7.0
ENV TF_CUDA_VERSION=${CUDA}
ENV TF_CUDNN_VERSION=${CUDNN_MAJOR_VERSION}
# CACHE_STOP is used to rerun future commands, otherwise cloning tensorflow will be cached and will not pull the most recent version
ARG CACHE_STOP=1
# Check out TensorFlow source code if --build-arg CHECKOUT_TF_SRC=1
ARG CHECKOUT_TF_SRC=0
RUN test "${CHECKOUT_TF_SRC}" -eq 1 && git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src || true

ARG USE_PYTHON_3_NOT_2
ARG _PY_SUFFIX=${USE_PYTHON_3_NOT_2:+3}
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python 

RUN apt-get update \
 && apt-get install -y \
  build-essential \
  curl \
  git \
  wget \
  openjdk-8-jdk \
  ${PYTHON}-dev \
  virtualenv \
  swig

RUN ${PIP} --no-cache-dir install \
    Pillow \
    h5py \
    keras_applications \
    keras_preprocessing \
    matplotlib \
    mock \
    numpy \
    scipy \
    sklearn \
    pandas \
    portpicker \
    && test "${USE_PYTHON_3_NOT_2}" -eq 1 && true || ${PIP} --no-cache-dir install \
    enum34

# 0.19.2
# Install bazel
ARG BAZEL_VERSION=0.24.1
RUN mkdir /bazel && \
    wget -O /bazel/installer.sh "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh" && \
    wget -O /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    chmod +x /bazel/installer.sh && \
    /bazel/installer.sh && \
    rm -f /bazel/installer.sh

# remove all cuda packages
RUN rm -rf /var/lib/apt/lists/*

