# //////////////////////////////////////////////////////////////////////////////
# @brief subt perception cpu dockerfile
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image
FROM subt/x86.${DOCKER_BASE_IMAGE_PROJECT}.${DOCKER_IMAGE_ARCH}.ros.melodic:${DOCKER_IMAGE_TAG}

# Change to root user, to install packages
USER root

# Install apt-utils
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils

#install latest cmake
ADD https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.sh /cmake-3.17.0-Linux-x86_64.sh
RUN mkdir /opt/cmake
RUN sh /cmake-3.17.0-Linux-x86_64.sh --prefix=/opt/cmake --skip-license
RUN ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake
RUN cmake --version
# Tools I find useful during development
RUN apt-get update --no-install-recommends \
  && apt-get install -y \
   libbluetooth-dev \
   libcwiid-dev \
   libgoogle-glog-dev \
   libspnav-dev \
   libusb-dev \
   mercurial \
   python3-dbg \
   python3-empy \
   python3-numpy \
   python3-pip \
   python3-venv \
   ruby2.5 \
   ruby2.5-dev \
  && sudo apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Commands below run as the developer user
USER $USERNAME

RUN pip3 install --upgrade pip

# Make a couple folders for organizing docker volumes
RUN mkdir ~/workspaces ~/other

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# remove ssh host checking (for git clone in container)
# eventually to be removed by the above ssh keys setup
RUN mkdir -p $HOME/.ssh && ssh-keyscan bitbucket.org >> $HOME/.ssh/known_hosts

# RUN export DEBIAN_FRONTEND=noninteractive \
#    && sudo apt-get update \
#    && sudo -E apt-get install -y \
#    tzdata \
#    && sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime \
#    && sudo dpkg-reconfigure --frontend noninteractive tzdata \
#    && sudo apt-get clean

# Get the tensorflow models research directory, and move it into tensorflow
# source folder to match recommendation of installation
RUN sudo git clone --depth 1 https://github.com/tensorflow/models.git /tensorflow/models && \
    ls /

# Install the latest version
RUN pip3 install tensorflow-gpu==1.15 tensorflow==1.15

# Install the Tensorflow Object Detection API from here
# https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md

RUN sudo /bin/sh -c 'echo "deb [trusted=yes] http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'echo "deb [trusted=yes] http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-prerelease `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-prerelease.list' \
 && sudo /bin/sh -c 'wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -' \
 && sudo /bin/sh -c 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
    protobuf-compiler \
    python-pil \
    python-lxml \
    python-tk \
    python3-dev \
    clang \
    python3-catkin-pkg-modules \
    ros-melodic-pcl-ros \
    ros-melodic-tf2-geometry-msgs \
    ros-melodic-rosmon \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN pip3 install empy gnupg && \
    pip3 install --upgrade numpy && \
    pip3 install --upgrade Cython && \
    pip3 install --upgrade contextlib2 && \
    pip3 install --upgrade jupyter && \
    pip3 install --upgrade matplotlib && \
    pip3 install --upgrade pyyaml && \
    pip3 install opencv-python

# Install pycocoapi
RUN sudo git clone --depth 1 https://github.com/cocodataset/cocoapi.git && \
    cd cocoapi/PythonAPI && \
    sudo make -j8 && \
    sudo cp -r pycocotools /tensorflow/models/research && \
    cd ../../ && \
    sudo rm -rf cocoapi

# Get protoc 3.0.0, rather than the old version already in the container
RUN curl -OL "https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip" && \
    unzip protoc-3.0.0-linux-x86_64.zip -d proto3 && \
    sudo mv proto3/bin/* /usr/local/bin && \
    sudo mv proto3/include/* /usr/local/include && \
    sudo rm -rf proto3 protoc-3.0.0-linux-x86_64.zip

# Run protoc on the object detection repo
RUN cd /tensorflow/models/research && \
    sudo protoc object_detection/protos/*.proto --python_out=.

# Set the PYTHONPATH to finish installing the API
ENV PYTHONPATH $PYTHONPATH:/tensorflow/models/research:/tensorflow/models/research/slim

RUN sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  python3-rospkg \
  python3-opencv \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# build opencv from source
ARG OPENCV_VERSION=3.4.0
RUN mkdir /home/$USER/opencv_dep  \
 && cd /home/$USER/opencv_dep \
 && mkdir src \
 && cd src \
 && git clone https://github.com/opencv/opencv \
 && cd opencv \
 && git checkout tags/$OPENCV_VERSION \
 && cd .. \
 && git clone https://github.com/opencv/opencv_contrib \
 && cd opencv_contrib \
 && git checkout tags/$OPENCV_VERSION \
 && cd ../.. \
 && mkdir build \
 && cd build \
 && cmake \
  -DOPENCV_EXTRA_MODULES_PATH=../src/opencv_contrib/modules/ \
  -DCMAKE_BUILD_TYPE=Release \
  -DCUDA_NVCC_FLAGS=--expt-relaxed-constexpr \
  -D WITH_CUDA=OFF \
  -D ENABLE_FAST_MATH=1 \
  -D CUDA_FAST_MATH=0 \
  -D WITH_CUBLAS=0 \
  -D INSTALL_PYTHON_EXAMPLES=ON \
  # -D BUILD_EXAMPLES=ON \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  ../src/opencv \
 && make -j8 \
 && sudo make install \
 && cd .. \
 && rm -rf build

RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F42ED6FBAB17C654

# catkin build tools
# RUN sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' \
#  && sudo apt-get update \
#  && wget http://packages.ros.org/ros.key -O - | sudo apt-key add - \
#  && sudo apt-get install python-catkin-tools -y

# ///////////////////////////////////////////////////////////////////////////////
# OpenVino
ARG DOWNLOAD_LINK=http://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_2019.3.334.tgz
ARG INSTALL_DIR=/opt/intel/openvino
ARG TEMP_DIR=/home/developer/tmp/openvino_installer

RUN sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  cpio \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN mkdir -p $TEMP_DIR && cd $TEMP_DIR && \
    wget -c $DOWNLOAD_LINK && \
    tar xf l_openvino_toolkit*.tgz && \
    cd l_openvino_toolkit* && \
    sed -i 's/decline/accept/g' silent.cfg && \
    sudo ./install.sh -s silent.cfg && \
    rm -rf $TEMP_DIR

RUN sudo $INSTALL_DIR/install_dependencies/install_openvino_dependencies.sh

RUN cd $INSTALL_DIR/deployment_tools/model_optimizer/install_prerequisites && \
    sudo ./install_prerequisites.sh

WORKDIR /opt/intel/openvino/install_dependencies

RUN sudo ./install_NEO_OCL_driver.sh
RUN /bin/bash -c "source $INSTALL_DIR/bin/setupvars.sh"
RUN echo "source $INSTALL_DIR/bin/setupvars.sh" >> /home/developer/.bashrc

RUN sudo apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE \
&& sudo add-apt-repository "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" -u

RUN sudo usermod -a -G users "$(whoami)"

# Build librealsense
# RUN git clone -b v2.31.0 https://github.com/IntelRealSense/librealsense.git ~/librealsense
# # RUN sed -i '/^#include "..\/include\/librealsense2\/hpp\/rs_frame.hpp"/a #include "synthetic-stream.h"' ~/librealsense/src/proc/pointcloud.h
# RUN mkdir ~/librealsense/build \
#  && cd ~/librealsense/build \
#  && cmake .. -DCMAKE_BUILD_TYPE=Release \
#  && make \
#  && sudo make install
# RUN rm -rf ~/librealsense

RUN git clone https://github.com/IntelRealSense/librealsense.git ~/librealsense \
 && cd ~/librealsense \
 && git checkout d8f5d42 \
 && mkdir build \
 && cd build \
 && cmake .. -DCMAKE_BUILD_TYPE=Release \
 && sudo make uninstall \
 && make clean \
 && make \
 && sudo make install \
 && rm -rf build

# install subt python packages
RUN sudo apt-get update \
 && sudo apt update --fix-missing \
 && sudo apt-get install -y --no-install-recommends \
  # librealsense2-dkms \
  # librealsense2-utils \
  # librealsense2-dev \
  # librealsense2-dbg \
  ros-melodic-diagnostic-updater \
  ros-melodic-image-transport \
  ros-melodic-tf2-geometry-msgs \
  ros-melodic-nodelet \
  ros-melodic-dynamic-reconfigure \
  ros-melodic-rospy \
  ros-melodic-nav-msgs \
  ros-melodic-camera-info-manager \
  ros-melodic-perception-pcl \
  python3-setuptools \
  python3-pip \
  python3-yaml \
  python3-dev \
  python3-numpy \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN pip3 install wheel --user
RUN pip3 install hurry.filesize graphviz serial pyserial multiping shapely empy trollius --user
RUN echo "alias python=/usr/bin/python3" >> ~/.bash_profile
RUN /bin/bash -c "alias python=/usr/bin/python3"
RUN python --version

RUN echo "source /opt/ros/melodic/setup.bash" >> /home/developer/.bashrc

RUN sudo apt-get update \
 && sudo apt update --fix-missing \
 && sudo apt-get install -y --no-install-recommends \
  ros-melodic-camera-info-manager \
  ros-melodic-visualization-msgs \
  ros-melodic-cv-bridge \
  ros-melodic-image-geometry \
  ros-melodic-serial \
  ros-melodic-rqt \
  ros-melodic-angles \
  libserial-dev \
  ros-melodic-rosbash \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

WORKDIR /home/$USERNAME/

# ////////////////////////////////////////////////////////
# GTSAM INSTALL

RUN sudo apt-get update --no-install-recommends \
 && sudo apt-get install -y \
  libgoogle-glog-dev \
  libatlas-base-dev \
  libeigen3-dev  \
  libsuitesparse-dev \
  libparmetis-dev \
  libmetis-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone https://github.com/borglab/gtsam.git gtsam/src \
 && cd /home/developer/thirdparty-software/gtsam/src \
 && git checkout 4.0.2 \
 && cd /home/developer/thirdparty-software/gtsam/ \
 && mkdir build \
 && cd build \
 && cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF ../src \
 && sudo make install -j8 \
 && cd .. \
 && rm -rf build

# //////////////////////////////////////////////////////////////////////////////
# ceras solver
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone https://ceres-solver.googlesource.com/ceres-solver ceres-solver/src \
 && cd ceres-solver/src \
 && git checkout 2.0.0 \
 && cd /home/developer/thirdparty-software/ceres-solver \
 && mkdir build \
 && cd build \
 && cmake ../src \
 && make -j3 \
 && make test \
 && sudo make install \
 && cd .. \
 && rm -rf build

# //////////////////////////////////////////////////////////////////////////////
# install ROS ueye driver
COPY --chown=$USERNAME:$USERNAME thirdparty-software/ /home/$USERNAME/thirdparty-software/
RUN cd /home/$USERNAME/thirdparty-software/download/uav/ \
 && unzip ids-software-suite-linux-4.94-64 \
 && cd ids-software-suite-linux-4.94-64 \
 && sudo chmod +x ueye_4.94.0.1229_amd64.run \
 && echo "yes" | sudo sh ueye_4.94.0.1229_amd64.run

# //////////////////////////////////////////////////////////////////////////////
# add entrypoint scripts (general & system specific)
ADD entrypoints/ $entry_path/

# //////////////////////////////////////////////////////////////////////////////
# TODO: remove this, see why catkin build fails (even with all cmake vars enabled) with Py3

# install subt python packages
# python2 installs
RUN pip install wheel --user
RUN pip install wheel pexpect --user
# python3 installs1
RUN sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  python3-pip \
  python3-yaml \
  python-catkin-tools \
  python3-dev \
  python3-numpy \
  # common workspace dependencies \
  ros-melodic-geometry \
  ros-melodic-tf-conversions \
  ros-melodic-ros-type-introspection \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN pip3 install wheel --user
RUN pip3 install  --user \
  rospkg \
  rosdep \
  catkin_pkg \
  genpy \
  setuptools \
  PyYAML \
  pexpect \
  tmuxp \
  catkin_tools
RUN echo "alias python=/usr/bin/python3" >> ~/.bash_profile

# export PYTHON paths
ENV PYTHONPATH="/home/${USERNAME}/.local/lib/python2.7/site-packages/:${PYTHONPATH}"
ENV PATH="/home/${USERNAME}/.local/bin/:${PATH}"
# export python3 stuff...SO UGLY!!!!!
RUN echo "export ROS_PYTHON_VERSION=3" >> /home/developer/.bashrc
RUN echo "export PYTHONPATH=" >> /home/developer/.bashrc
RUN echo "source /opt/ros/melodic/setup.bash" >> /home/developer/.bashrc

# //////////////////////////////////////////////////////////////////////////////
# entrypoint startup
# //////////////////////////////////////////////////////////////////////////////

# entrypoint path inside the docker container
ENV entry_path /docker-entrypoint/

# add entrypoint scripts (general & system specific)
ADD entrypoints/ $entry_path/

# execute entrypoint script
RUN sudo chown -R $USERNAME:$USERNAME $entry_path/
RUN sudo chmod +x -R $entry_path/

# set image to run entrypoint script
ENTRYPOINT $entry_path/docker-entrypoint.bash
