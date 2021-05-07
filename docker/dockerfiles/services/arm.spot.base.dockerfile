# //////////////////////////////////////////////////////////////////////////////
# @brief subt gpu base base ros dockerfile
# //////////////////////////////////////////////////////////////////////////////
ARG REC_BASE_DOCKER_IMAGE=arm64v8/ros:melodic-ros-core
# Ubuntu 18.04 with nvidia-docker2 beta opengl support
FROM $REC_BASE_DOCKER_IMAGE

# //////////////////////////////////////////////////////////////////////////////
# general tools install
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update --no-install-recommends \
 && apt-get install -y \
  build-essential \
  cmake \
  cppcheck \
  gdb \
  git \
  lsb-release \
  software-properties-common \
  sudo \
  vim \
  emacs \
  nano \
  wget \
  tmux \
  curl \
  less \
  net-tools \
  byobu \
  libgl-dev \
  iputils-ping \
  doxygen \
  graphviz \
  python-requests \
  python-pip \
  locales \
  xvfb \
  tzdata \
  chrony \
  sharutils \
  # for reference (dont need because of base image)
  # gstreamer \
  # libgstreamer1.0-0 \
  # libgstreamer1.0-dev \
  # gstreamer1.0-tools \
  # gstreamer1.0-doc \
  # gstreamer1.0-libav \
  # gstreamer1.0-plugins-base \
  # gir1.2-gst-plugins-base-1.0 \
  # gstreamer1.0-plugins-good \
  # gstreamer1.0-plugins-ugly \
  # libgstreamer-plugins-base1.0-dev \
  # gir1.2-gstreamer-1.0 \
  # libmjpegutils-2.1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && dpkg-reconfigure --frontend=noninteractive locales \
 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer
ENV USER=developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME
# Commands below run as the developer user
USER $USERNAME
# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# remove ssh host checking (for git clone in container)
# eventually to be removed by the above ssh keys setup
RUN mkdir $HOME/.ssh && ssh-keyscan bitbucket.org >> $HOME/.ssh/known_hosts

# Set the timezone
RUN sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean

# //////////////////////////////////////////////////////////////////////////////
# ros install
## https://github.com/osrf/gazebo/issues/2731
## http://gazebosim.org/distributions/gazebo/releases/
## Issues installing gazebo9-common :P
RUN curl -Ol https://osrf-distributions.s3.us-east-1.amazonaws.com/gazebo/releases/gazebo9-common_9.13.1-1~bionic_all.deb

RUN sudo /bin/sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' \
 && sudo /bin/sh -c 'wget -q http://packages.osrfoundation.org/gazebo.key -O - | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 sudo apt-key add -' \
 && sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo apt-get update \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  ./gazebo9-common_9.13.1-1~bionic_all.deb \
 && rm ./gazebo9-common_9.13.1-1~bionic_all.deb \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  # general ros melodic dependencies \
  python-rosdep \
  libboost-all-dev \
  libeigen3-dev \
  assimp-utils \
  libcgal-dev \
  libcgal-qt5-dev \
  libproj-dev \
  libnlopt-dev \
  python-wstool \
  python-catkin-tools \
  libglfw3-dev \
  libblosc-dev \
  libopenexr-dev \
  liblog4cplus-dev \
  libsuitesparse-dev \
  libsdl1.2-dev \
  # basic ros-melodic packages \
  ros-melodic-catch-ros \
  ros-melodic-smach-viewer \
  ros-melodic-tf-conversions \
  ros-melodic-gazebo-* \
  ros-melodic-random-numbers \
  ros-melodic-cmake-modules \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-rviz \
  # common workspace dependencies \
  ros-melodic-geometry \
  ros-melodic-tf-conversions \
  ros-melodic-ros-type-introspection \
  ros-melodic-tf2-geometry-msgs \
  python-rosinstall \
  ros-melodic-joystick-drivers \
  ros-melodic-pointcloud-to-laserscan \
  ros-melodic-robot-localization \
  ros-melodic-spacenav-node \
  ros-melodic-tf2-sensor-msgs \
  ros-melodic-twist-mux \
  ros-melodic-velodyne-simulator \
  libncurses5-dev \
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
  ros-melodic-teleop-twist-joy \
  ros-melodic-rosfmt \
  ros-melodic-jsk-rviz* \
  # state estimation rosdeps  \
  festival \
  festvox-kallpc16k \
  python-gi \
  python-setuptools \
  ros-melodic-gazebo-msgs \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
RUN pip install wheel setuptools pexpect --user
# Needs wheel to properly install first
RUN pip install PyYAML  tmuxp rospkg catkin_tools catkin_pkg

# force a rosdep update
RUN sudo rosdep init && rosdep update

# add tmux configuration
RUN git clone https://github.com/gpakosz/.tmux.git \
 && ln -s -f .tmux/.tmux.conf \
 && cp .tmux/.tmux.conf.local .

# //////////////////////////////////////////////////////////////////////////////
# export environment variables

# Ugly: update the python environment path
ENV PYTHONPATH=${PYTHONPATH}:/home/$USERNAME/.local/lib/python2.7/site-packages/
ENV PATH=${PATH}:/home/$USERNAME/.local/bin/

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
