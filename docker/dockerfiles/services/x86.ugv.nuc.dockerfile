# //////////////////////////////////////////////////////////////////////////////
# @brief subt's ugv:nuc dockerfile
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image
FROM subt/x86.ugv.nuc.${DOCKER_IMAGE_ARCH}.${DOCKER_BASE_IMAGE_PROJECT}:${DOCKER_IMAGE_TAG}

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# general tools install
RUN sudo apt-get update --no-install-recommends \
 && sudo apt-get install -y \
  lm-sensors \
  autoconf \
  automake \
  libflann-dev \
  libbluetooth-dev \
  libserial-dev \
  # realsesne \
  libssl-dev \
  libusb-1.0-0-dev \
  pkg-config \
  libgtk-3-dev \
  libglfw3-dev \
  libgl1-mesa-dev \
  libglu1-mesa-dev \
  at \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# ros install
RUN sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  ros-melodic-ros-type-introspection \
  ros-melodic-pcl-ros \
  ros-melodic-rosfmt \
  ros-melodic-rqt-gui \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-rqt-gui-py \
  ros-melodic-catch-ros \
  ros-melodic-rosserial \
  ros-melodic-serial \
  ros-melodic-diagnostic-aggregator \
  libncurses5-dev \
  libpcap0.8-dev \
  # realsense \
  ros-melodic-ddynamic-reconfigure \
  ros-melodic-xacro \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*
RUN rosdep update

# add user to groups
RUN sudo usermod -a -G dialout developer

# //////////////////////////////////////////////////////////////////////////////
# Install librealsense for realsense 515 camera
RUN mkdir -p ~/thirdparty/realsense \
 && cd ~/thirdparty/realsense \
 && git clone https://github.com/IntelRealSense/librealsense realsense_sdk \
 && cd realsense_sdk \
 && mkdir build \
 && cd build \
 && cmake ../ -DCMAKE_BUILD_TYPE=Release \
 && sudo make uninstall \
 && make clean \
 && make \
 && sudo make install

# Install the librealsense ros driver
RUN mkdir -p ~/thirdparty/realsense/ros/src \
 && cd ~/thirdparty/realsense/ros/src \
 && git clone https://github.com/IntelRealSense/realsense-ros \
 && cd ~/thirdparty/realsense/ros/ \
 && catkin config --extend /opt/ros/melodic/ \
 && catkin config -DCMAKE_BUILD_TYPE=Release \
 && catkin build

# //////////////////////////////////////////////////////////////////////////////
# install subt python packages
RUN pip install --user wheel
RUN pip install --user \
 hurry.filesize==0.9 \
 graphviz==0.16 \
 serial==0.0.97 \
 pyserial==3.5 \
 shapely==1.7.1 \
 empy==3.3.4 \
 pybluez==0.23 \
 pyyaml==5.4.1 \
 rospkg==1.3.0 \
 protobuf==3.15.8 \
 matplotlib==2.2.5 \
 psutil==5.8.0

# //////////////////////////////////////////////////////////////////////////////
# Install any thirdparty libraries
# //////////////////////////////////////////////////////////////////////////////

# # install xsens libraries (already installed in superodometry image)
RUN cd /home/$USERNAME/thirdparty-software/uav/ \
 && cd xsens_cpp_driver/receive_xsens/config/mt_sdk/ \
 && sudo ./mt_sdk_4.8.sh

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
