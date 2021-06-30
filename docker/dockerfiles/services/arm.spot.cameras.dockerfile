# //////////////////////////////////////////////////////////////////////////////
# subt camera dockerfile -- version: 0.1
# //////////////////////////////////////////////////////////////////////////////
ARG ROS_VERSION=$ROS_VERSION
FROM nvcr.io/nvidia/l4t-base:r32.4.3

# //////////////////////////////////////////////////////////////////////////////
# general tools install
USER root
RUN apt-get update --no-install-recommends \
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
  wget \
  tmux \
  curl \
  less \
  net-tools \
  byobu \
  libgl-dev \
  iputils-ping \
  nano \
  libgl-dev \
  iputils-ping \
  chrony \
  sharutils \
  python-setuptools \
  python-pip \
  v4l-utils \
  apt-utils \
  # for reference (dont need because of base image)
  # gstreamer \
  libgstreamer1.0-0 \
  libgstreamer1.0-dev \
  gstreamer1.0-tools \
  gstreamer1.0-doc \
  gstreamer1.0-libav \
  gstreamer1.0-plugins-base \
  gir1.2-gst-plugins-base-1.0 \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  libgstreamer-plugins-base1.0-dev \
  gir1.2-gstreamer-1.0 \
  libmjpegutils-2.1 \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# ros install

# setup timezone
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENV ROS_DISTRO melodic

# install ros packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-melodic-ros-core=1.4.1-0* \
    && rm -rf /var/lib/apt/lists/*

# //////////////////////////////////////////////////////////////////////////////
# create new user

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
 && echo "$USERNAME:$USERNAME" | chpasswd \
 && adduser $USERNAME sudo \
 && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Add a user with the same user_id as the user outside the container
# Requires a docker build argument `user_id`
ARG user_id=$user_id
ENV USERNAME developer

# Commands below run as the developer user
USER $USERNAME

# When running a container start in the developer's home folder
WORKDIR /home/$USERNAME

# Set the timezone
RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update \
 && sudo -E apt-get install -y \
   tzdata \
 && sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
 && sudo dpkg-reconfigure --frontend noninteractive tzdata \
 && sudo apt-get clean

# //////////////////////////////////////////////////////////////////////////////
# meta ros packages install

RUN sudo /bin/sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
 && sudo /bin/sh -c 'apt-key adv --keyserver  hkp://keyserver.ubuntu.com:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
 && sudo /bin/sh -c 'apt-key adv --keyserver keys.gnupg.net --recv-key C8B3A55A6F3EFCDE || apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key C8B3A55A6F3EFCDE' \
 && sudo curl http://repo.ros2.org/repos.key | sudo apt-key add - \
 && sudo apt-get update \
 && sudo apt-get install -y --no-install-recommends \
  python-rosdep \
  libboost-all-dev \
  python-wstool \
  python-catkin-tools \
  python-rosinstall \
  python-wstool \
  libboost-all-dev \
  libeigen3-dev \
  doxygen \
  graphviz \
  python-requests \
  libcgal-qt5-dev \
  qtbase5-dev \
  libyaml-cpp-dev \
  python3-pip \
  python3-rospkg-modules \
  python3-dbg \
  python3-empy \
  python3-numpy \
  python3-pip \
  python3-venv \
  ros-melodic-diagnostics  \
  ros-melodic-image-transport \
  # rosmon deps \
  ros-melodic-rosfmt \
  ros-melodic-rqt-gui \
  ros-melodic-rqt-gui-cpp \
  ros-melodic-catch-ros \
  libncurses5-dev \
  libpcap0.8-dev \
  libtbb-dev \
 && sudo apt-get clean \
 && sudo rm -rf /var/lib/apt/lists/*
RUN sudo rosdep init && rosdep update

# Add developer user to groups to run drivers
RUN sudo usermod -a -G dialout developer
RUN sudo usermod -a -G tty developer
RUN sudo usermod -a -G video developer
RUN sudo usermod -a -G root developer

# //////////////////////////////////////////////////////////////////////////////
# entrypoint startup

ENV entrypoint_container_path /docker-entrypoint/

# add entrypoint scripts (general & system specific)
ADD entrypoints/ $entrypoint_container_path/
#ADD $arch/entrypoints/ $entrypoint_container_path/

# execute entrypoint script
RUN sudo chmod +x -R $entrypoint_container_path/

# set image to run entrypoint script
ENTRYPOINT $entrypoint_container_path/docker-entrypoint.bash
