# //////////////////////////////////////////////////////////////////////////////
# @brief subt ugv:sim dockerfile
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image
FROM subt/x86.ugv.${DOCKER_IMAGE_ARCH}.${DOCKER_BASE_IMAGE_PROJECT}:${DOCKER_IMAGE_TAG}

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
  git \
  git-lfs \
  lm-sensors \
  autoconf \
  automake \
  libflann-dev \
  libbluetooth-dev \
  libsdformat6-dev \
  libserial-dev \
  libsuitesparse-dev \
  libeigen3-dev \
  libsdl1.2-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# Install ROS packages && Gazebo 9
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  gazebo9 \
  libgazebo9-dev \
  ros-melodic-ros-type-introspection \
  ros-melodic-pcl-ros \
  ros-melodic-rosfmt \
  ros-melodic-rqt-gui \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-rqt-gui-py \
  ros-melodic-catch-ros \
  ros-melodic-rosserial \
  ros-melodic-serial \
  ros-melodic-joystick-drivers \
  ros-melodic-husky-description \
  ros-melodic-jackal-description \
  ros-melodic-mav-msgs \
  ros-melodic-octomap-msgs \
  ros-melodic-octomap-ros \
  ros-melodic-rotors-comm \
  ros-melodic-rotors-control \
  ros-melodic-rotors-gazebo-plugins \
  ros-melodic-twist-mux \
  ros-melodic-velocity-controllers \
  ros-melodic-ros-controllers \
  ros-melodic-ros-control \
  ros-melodic-multimaster-launch \
  ros-melodic-hector-gazebo-plugins \
  ros-melodic-interactive-marker-twist-server \
  ros-melodic-teleop-twist-joy \
  ros-melodic-roslint \
  ros-melodic-rotors-gazebo \
  ros-melodic-robot-localization \
  ros-melodic-pointcloud-to-laserscan \
  ros-melodic-rotors-description \
  libignition-gazebo2-plugins \
  ros-melodic-rqt-image-view \
  ros-melodic-image-proc \
  ros-melodic-image-transport-plugins \
  libncurses5-dev \
  libpcap0.8-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

RUN rosdep update

# add user to groups
RUN sudo usermod -a -G dialout developer

# install subt python packages
RUN pip install --user wheel
RUN pip install --user \
 hurry.filesize \
 graphviz \
 serial \
 pyserial \
 shapely \
 empy \
 pybluez \
 pyyaml \
 rospkg \
 shapely \
 graphviz \
 protobuf \
 matplotlib

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
