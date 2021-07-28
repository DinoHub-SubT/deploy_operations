# //////////////////////////////////////////////////////////////////////////////
# @brief subt's basestation dockerfile
# //////////////////////////////////////////////////////////////////////////////

# get the passed, deployerbooks environment variables (for maintaining the docker image names)
ARG DOCKER_IMAGE_TAG=$DOCKER_IMAGE_TAG
ARG DOCKER_BASE_IMAGE_ROS=$DOCKER_BASE_IMAGE_ROS
ARG DOCKER_BASE_IMAGE_PROJECT=$DOCKER_BASE_IMAGE_PROJECT
ARG DOCKER_IMAGE_ARCH=$DOCKER_IMAGE_ARCH

# Get the base image
FROM subt/x86.ugv.ppc.${DOCKER_IMAGE_ARCH}.${DOCKER_BASE_IMAGE_PROJECT}:${DOCKER_IMAGE_TAG}

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
  fping \
  etherwake \
  wakeonlan \
  # simulation (temporary), todo remove \
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

RUN sudo apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE || sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE

# //////////////////////////////////////////////////////////////////////////////
# ros install
RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -' \
 # && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 # && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 # && sudo /bin/sh -c 'echo "deb http://realsense-hw-public.s3.amazonaws.com/Debian/apt-repo bionic main" > /etc/apt/sources.list.d/realsense.list' \
 # && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE ' \
 # && sudo /bin/sh -c 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key F6E65AC044F831AC80A06380C8B3A55A6F3EFCDE' \
 && sudo /bin/sh -c 'add-apt-repository "deb https://librealsense.intel.com/Debian/apt-repo $(lsb_release -cs) main" -u' \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  ros-melodic-octomap-ros \
  ros-melodic-octomap-server \
  libignition-transport4-dev \
  ros-melodic-velodyne-description \
  ros-melodic-hector-sensors-description \
  ros-melodic-joint-state-controller \
  ros-melodic-octomap \
  ros-melodic-octomap-server \
  ros-melodic-octomap-ros \
  ros-melodic-octomap-mapping \
  ros-melodic-octomap-msgs \
  ros-melodic-velodyne-* \
  ros-melodic-multimaster-fkie \
  ros-melodic-mav-msgs \
  ros-melodic-mavros-msgs \
  ros-melodic-rosserial \
  ros-melodic-serial \
  ros-melodic-teleop-twist-joy \
  ros-melodic-rosfmt \
  ros-melodic-rospy-message-converter \
  ros-melodic-ros-type-introspection \
  ros-melodic-rosmon \
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
  graphviz \
  #################### \
  # realsense  \
  #################### \
  librealsense2-dkms \
  librealsense2-utils \
  librealsense2-dev \
  librealsense2-dbg \
  #################### \
  # other \
  #################### \
  iputils-ping \
  nano \
  # rosmon from source deps \
  libserial-dev \
  libncurses-dev \
  libncurses5-dev \
  libncurses5-dev \
  lm-sensors \
  autoconf \
  automake \
  fping \
  libbluetooth-dev \
  libgoogle-glog-dev \
  # Simulation (temporary), todo remove \
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
  ros-melodic-diagnostic-aggregator \
  ros-melodic-ddynamic-reconfigure \
  ros-melodic-xacro \
  libncurses5-dev \
  libpcap0.8-dev \
  # vdbmap \
  libglfw3-dev \
  libblosc-dev \
  libopenexr-dev \
  liblog4cplus-dev \
  python3-tk \
  python-tk \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# remove gflags
# RUN sudo apt-get remove libgflags-dev -y \
#  && sudo apt autoremove -y

# add user to groups
RUN sudo usermod -a -G dialout developer

# fping
RUN mkdir ~/software \
 && git clone https://github.com/NetworkEng/fping ~/software/fping \
 && cd ~/software/fping \
 && ./autogen.sh \
 && ./configure \
 && make \
 && sudo make install \
 && sudo chmod 6755 /usr/local/sbin/fping

# labjack
RUN mkdir ~/labjack \
 && cd ~/labjack \
 && curl -ssLO https://labjack.com/sites/default/files/software/labjack_ljm_software_2019_07_16_x86_64.tar.gz \
 && tar xvf labjack_ljm_software_2019_07_16_x86_64.tar.gz \
 && cd labjack_ljm_software_2019_07_16_x86_64 \
 && sudo ./labjack_ljm_installer.run -- --no-restart-device-rules

# install subt python packages
RUN pip install --user wheel
RUN pip install --user \
 fping \
 hurry.filesize \
 graphviz \
 serial \
 pyserial \
 multiping \
 shapely \
 empy \
 pybluez \
 pyyaml \
 rospkg \
 fping \
 shapely \
 protobuf \
 matplotlib \
 labjack-ljm \
 psutil \
 # comms planner \
 numpy \
 matplotlib \
 Pillow \
 torch \
 torchvision \
 sympy \
 shapely \
 scikit-image \
 bresenham \
 pandas \
 python-resize-image \
 unzip \
 gfortran \
 texlive-latex-base \
 libnlopt-dev \
 libf2c2-dev \
 libarmadillo-dev \
 glpk-utils libglpk-dev \
 libcdd-dev

# Install Mosek & OOQP
RUN cp -r ~/thirdparty-software/ugv/mosek ~/mosek \
 # install ma27 \
 && cd ~/thirdparty-software/ugv \
 && unzip ma27-1.0.0.zip \
 && cd ma27-1.0.0 \
 && ./configure \
 && make \
 && sudo make install \
 # install OOQP
 && cd ~/thirdparty-software/ugv \
 && unzip OOQP.zip \
 && OOQP \
 && ./configure \
 && make \
 && sudo make install

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
