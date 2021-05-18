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
  python-rosdep \
  python-rosinstall \
  ros-melodic-joystick-drivers \
  ros-melodic-pointcloud-to-laserscan \
  ros-melodic-robot-localization \
  ros-melodic-spacenav-node \
  ros-melodic-tf2-sensor-msgs \
  ros-melodic-twist-mux \
  libproj-dev \
  libnlopt-dev \
  libncurses5-dev \
  ros-melodic-velodyne-* \
  ros-melodic-velodyne-description \
  ros-melodic-hector-sensors-description \
  ros-melodic-joint-state-controller \
  ros-melodic-octomap \
  ros-melodic-octomap-server \
  ros-melodic-octomap-ros \
  ros-melodic-octomap-mapping \
  ros-melodic-octomap-msgs \
  ros-melodic-smach-viewer \
  ros-melodic-random-numbers \
  ros-melodic-mav-msgs \
  ros-melodic-mavros-msgs \
  ros-melodic-rosserial \
  ros-melodic-teleop-twist-joy \
  ros-melodic-rosfmt \
  ros-melodic-jsk-rviz* \
  ros-melodic-diagnostic-updater \
  #################### \
  # state est rosdeps  \
  #################### \
  gstreamer1.0-plugins-base \
  gir1.2-gst-plugins-base-1.0 \
  libgstreamer1.0-dev \
  festival \
  festvox-kallpc16k \
  gstreamer1.0-plugins-ugly \
  python-gi \
  gstreamer1.0-plugins-good \
  libgstreamer-plugins-base1.0-dev \
  gstreamer1.0-tools \
  gir1.2-gstreamer-1.0 \
  chrony \
  sharutils \
  python-setuptools \
  # rosmon deps \
  ros-melodic-rosfmt \
  ros-melodic-rqt-gui \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-catch-ros \
  libncurses5-dev \
  libpcap0.8-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# force a rosdep update
RUN rosdep update

RUN pip2 install wheel setuptools pexpect --user
RUN pip2 install  --user genpy pyquaternion

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
