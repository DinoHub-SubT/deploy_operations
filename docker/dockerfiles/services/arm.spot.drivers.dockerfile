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
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# force a rosdep update
RUN rosdep update

# Install deployer dependencies
# RUN sudo -H pip2 install wheel setuptools pexpect
# RUN sudo -H pip2 install genpy pyquaternion

# Install boston dynamics spot api
RUN rosdep update
RUN sudo -H pip3 install wheel setuptools cython
RUN sudo -H pip3 install bosdyn-client bosdyn-mission bosdyn-api bosdyn-core

# install spot ros driver
RUN sudo apt-get update
RUN mkdir -p /tmp/spot_build_ws/src
RUN git clone https://github.com/clearpathrobotics/spot_ros.git /tmp/spot_build_ws/src/spot_ros
RUN sudo /bin/bash -c "cd /tmp/spot_build_ws/ && source /opt/ros/melodic/setup.bash && catkin_make && catkin_make install -DCMAKE_INSTALL_PREFIX=/opt/ros/melodic && rosdep install --from-paths src --ignore-src -y"
RUN sudo rm -rf /tmp/spod_build_ws/src
RUN sudo -H pip uninstall -y pyyaml

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
