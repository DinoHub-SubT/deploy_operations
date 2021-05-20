# //////////////////////////////////////////////////////////////////////////////
# @brief simulation dockerfile
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image
FROM subt/x86.offline.${DOCKER_IMAGE_ARCH}.ros.melodic:${DOCKER_IMAGE_TAG}

# Assuming ros base image has set the user_id correctly, use the user with the same user_id as host
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
  fping \
  etherwake \
  wakeonlan \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# ROS install dependencies
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo /bin/sh -c 'echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/realsense.list' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  ros-melodic-pcl-ros \
  # cloud compare deps \
  qt5-default \
  qtscript5-dev \
  libssl-dev \
  qttools5-dev \
  qttools5-dev-tools \
  qtmultimedia5-dev \
  libqt5svg5-dev \
  libqt5webkit5-dev \
  libsdl2-dev \
  libasound2 \
  libxmu-dev \
  libxi-dev \
  freeglut3-dev \
  libasound2-dev \
  libjack-jackd2-dev \
  libxrandr-dev \
  libqt5xmlpatterns5-dev \
  libqt5xmlpatterns5 \
  libqt5opengl5-dev \
  ros-melodic-rosbash \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# Install Cloud Compare
RUN mkdir -p ~/thirdparty \
 && cd ~/thirdparty \
 && git clone --recursive https://github.com/cloudcompare/CloudCompare.git \
 && cd CloudCompare \
 && mkdir build \
 && cd build \
 && cmake ../ \
 && make \
 && sudo make install

# Install CMake Version 3.15
ENV version=3.15
ENV build=2
RUN mkdir -p ~/thirdparty \
 && cd ~/thirdparty \
 && wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz \
 && tar -xzvf cmake-$version.$build.tar.gz \
 && cd cmake-$version.$build/ \
 && ./bootstrap \
 && make -j4 \
 && sudo make install \
 && rm -rf ~/thirdparty

# Install GTest
RUN cd /usr/src/gtest \
 && sudo cmake CMakeLists.txt \
 && sudo make \
 # copy or symlink libgtest.a and libgtest_main.a to your /usr/lib folder \
 && sudo cp *.a /usr/lib

RUN pip install wheel --user
RUN pip install --user \
 graphviz

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
