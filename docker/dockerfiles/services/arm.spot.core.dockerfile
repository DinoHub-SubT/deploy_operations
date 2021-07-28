# //////////////////////////////////////////////////////////////////////////////
# @brief subt perception cpu dockerfile
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image
FROM subt/arm.${DOCKER_BASE_IMAGE_PROJECT}.${DOCKER_IMAGE_ARCH}.ros.melodic:${DOCKER_IMAGE_TAG}

# //////////////////////////////////////////////////////////////////////////////
# ros install
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  ros-melodic-joystick-drivers \
  ros-melodic-joint-state-controller \
  ros-melodic-mavros \
  ros-melodic-mavros-extras \
  ros-melodic-mav-msgs \
  ros-melodic-mavros-msgs \
  ros-melodic-joy \
  ros-melodic-teleop-twist-joy \
  libproj-dev \
  libnlopt-dev \
  libpcap0.8-dev \
  ros-melodic-interactive-marker-twist-server \
  ros-melodic-robot-state-publisher \
  ros-melodic-joint-state-publisher-gui \
  ros-melodic-joint-state-publisher \
  ros-melodic-image-proc \
  ros-melodic-image-transport-plugins \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# force a rosdep update
RUN rosdep update

# Install deployer dependencies
RUN sudo -H pip2 install wheel setuptools pexpect
RUN sudo -H pip2 install genpy pyquaternion

# Install boston dynamics spot ros dependencies
RUN sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  python3-pip \
  python3-rospkg-modules \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# Install boston dynamics spot pip dependencies
RUN sudo -H pip3 install wheel setuptools cython
RUN sudo -H pip3 install bosdyn-client bosdyn-mission bosdyn-api bosdyn-core empy futures 
RUN pip2 uninstall -y pyyaml futures

# Install boston dynamics spot driver
RUN mkdir -p /home/developer/thirdparty/spot_driver/src \
 && cd /home/developer/thirdparty/spot_driver/src \
 && git clone https://github.com/clearpathrobotics/spot_ros.git \
 && git clone https://github.com/ros/geometry2 --branch 0.6.5 \
 && cd /home/developer/thirdparty/spot_driver/ \
 && catkin config --extend /opt/ros/melodic \
 && catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release \
  -DPYTHON_EXECUTABLE=/usr/bin/python3 \
  -DPYTHON_INCLUDE_DIR=/usr/include/python3.6m \
  -DPYTHON_LIBRARY=/usr/lib/aarch64-linux-gnu/libpython3.6m.so \
 && catkin build

# general tools install
RUN sudo apt-get update --no-install-recommends \
 && sudo apt-get install -y \
  libpcap0.8-dev \
  libgoogle-glog-dev \
  libatlas-base-dev \
  libeigen3-dev  \
  libsuitesparse-dev \
  libparmetis-dev \
  libmetis-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# ceras solver
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone https://ceres-solver.googlesource.com/ceres-solver ceres-solver/src \
 && cd ceres-solver/src \
 && git checkout 1.14.0 \
 && cd /home/developer/thirdparty-software/ceres-solver \
 && mkdir build \
 && cd build \
 && cmake -DBUILD_TESTING=OFF -DBUILD_DOCUMENTATION=OFF -DBUILD_EXAMPLES=OFF -DBUILD_BENCHMARKS=OFF -DPROVIDE_UNINSTALL_TARGET=OFF ../src \
 && make -j4 \
 && sudo make install

# gtsam
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone https://github.com/borglab/gtsam.git gtsam/src \
 && cd /home/developer/thirdparty-software/gtsam/src \
 && git checkout 4.0.2 \
 && cd /home/developer/thirdparty-software/gtsam/ \
 && mkdir build \
 && cd build \
 && cmake -DGTSAM_BUILD_WITH_MARCH_NATIVE=OFF -DGTSAM_BUILD_TESTS=OFF -DGTSAM_BUILD_EXAMPLES_ALWAYS=OFF ../src \
 && sudo make install -j4

# sophus
RUN mkdir -p /home/developer/thirdparty-software/ \
 && cd /home/developer/thirdparty-software/ \
 && git clone http://github.com/strasdat/Sophus.git sophus/src \
 && cd sophus/src \
 && git checkout 593db47 \
 && cd /home/developer/thirdparty-software/sophus/ \
 && mkdir build \
 && cd build \
 && cmake -DBUILD_TESTS=OFF ../src \
 && make -j8 \
 && sudo make install -j4 \
 && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/include/

# Add developer user to groups to run drivers
RUN sudo usermod -a -G dialout developer
RUN sudo usermod -a -G tty developer
RUN sudo usermod -a -G video developer
RUN sudo usermod -a -G root developer

# //////////////////////////////////////////////////////////////////////////////
# entrypoint startup

# entrypoint env vars
ARG arch=$arch
ENV entrypoint_container_path /docker-entrypoint/

# add entrypoint scripts (general & system specific)
ADD entrypoints/ $entrypoint_container_path/
ADD $arch/entrypoints/ $entrypoint_container_path/

# execute entrypoint script
RUN sudo chmod +x -R $entrypoint_container_path/

# set image to run entrypoint script
ENTRYPOINT $entrypoint_container_path/docker-entrypoint.bash
